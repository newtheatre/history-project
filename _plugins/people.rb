module Jekyll
  class PlaceholderPeoplePage < Document
    def initialize(site, collection, title)
      @site = site
      @path = make_path(title)
      @extname = File.extname(path)
      @output_ext = Jekyll::Renderer.new(site, self).output_ext
      @collection = collection
      @has_yaml_header = nil
      @title = title

      defaults = @site.frontmatter_defaults.all(url, collection.label.to_sym)

      my_data = {
        'title' => @title,
        'placeholder' => true,
        'editable' => false
      }

      @data = Utils.deep_merge_hashes(defaults, my_data)

    end

    def make_path(title)
      # Downcase, remove specials, space->underscore
      path_no_ext = title.downcase.gsub(/[^0-9a-z \-]/i, '').gsub(' ','_')
      "/#{path_no_ext}"
    end

    def content()
      ""
    end

  end


  class PeoplePlaceholderGenerator < Generator
    priority :normal

    def generate(site)
      if not site.config["skip_virtual_people"]
        @collection = site.collections["people"]
        Jekyll.logger.info "Generating virtual people..."

        for name in site.data["people_names"]
          unless @collection.docs.detect { |doc| doc.data["title"] == name }
            @collection.docs << PlaceholderPeoplePage.new(site, @collection, name)
          end
        end
      else
        Jekyll.logger.warn "Skipping virtual people generation"
      end

    end

  end


  class PeopleDataGenerator < Generator
    priority :low # Before years, after shows and committees

    def last_year(data)
      # Return the last year someone worked at the theatre given a list of
      # shows or years
      if data and data.size > 0
        last = data[-1]["item"]
        last_year = last.data["year_page"]
        return last_year.data["sort"] + 1
      else
        return 0
      end
    end

    def estimate_graduated(person)
      max_graduated_shows = last_year(person.data["shows"])
      max_graduated_committtes = last_year(person.data["committees"])

      max_graduated = [max_graduated_shows, max_graduated_committtes].max

      # Limit guessing to a recency limit and actually getting an answer
      if max_graduated <= (Time.now().year - @site.config["estimate_recency_limit"]) and
        max_graduated > 0
        return max_graduated
      else
        return nil
      end
    end

    def generate_person(person)
      """Method called on all people"""
      # Populate person record with data from the reverse index
      if @site.data["people_names"].include?( person.data["title"] )
        person.data["shows"] = @site.data["people_ri_shows"][ person.data["title"] ]
        person.data["committees"] = @site.data["people_ri_committees"][ person.data["title"] ]
      end

      # Graduation estimation
      if not person.data["graduated"]
        person.data["graduated"] = estimate_graduated(person)
        person.data["graduated_estimated"] = true
      else
        person.data["graduated_actual"] = person.data["graduated"]
        person.data["graduated_estimated"] = false
      end

      # Replace headshots with SmugMug Images
      if person.data["headshot"]
        person.data["headshot"] = SmugImage.new(person.data["headshot"])
      end

      # Person additional data
      person.data["path_name"] = make_hp_path(person.data["title"])
      person.data["decade"] = "#{person.data["graduated"]}"[0,3]

      # People by filename
      @people_by_filename[person.basename_without_ext] = person
    end

    def generate(site)
      Jekyll.logger.info "Processing people..."
      people = site.collections["people"].docs

      @site = site
      years = @site.collections["years"].docs
      @this_year = years[-1]

      @people_by_filename = Hash.new

      people.each { |person| generate_person(person) }

      @site.data["people"] = people
      @site.data["people_by_filename"] = @people_by_filename
    end
  end
end

# Utility functions

def generate_people_by_filename(people)
  people_by_filename = Hash.new
  for person in people
    people_by_filename[person.basename_without_ext] = person
  end
  return people_by_filename
end
