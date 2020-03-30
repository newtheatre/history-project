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
      path_no_ext = make_hp_path(title)
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
        # Filter the data set to only items with valid year_pages
        data.select! { |i| not i["item"].nil? }
        data.select! { |i| not i["item"].data["year_page"].nil? }

        # If we have a valid item return its grad year
        if data.size > 0
          last_item = data[-1]["item"]
          last_year = last_item.data["year_page"]
          return last_year.data["grad_year"]
        end
      end

      # Data empty or no useful data
      return 0
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

    def year_link(grad_year) # Get the /year/ link for a given graduation year.
      year_end = (grad_year.to_s)[2,2] # Take the last 2 characters of the grad year
      year_start = ((grad_year - 1).to_s)[2,2] # Take the last 2 characters of (grad year -1)

      grad_link = year_start + '_' + year_end 

      return grad_link
    end 

    def generate_person(person)
      """Method called on all people"""
      # Validate things
      if not person.data.has_key?("title")
        Jekyll.logger.abort_with("Person record #{person.basename_without_ext} missing key 'title'")
      end

      if make_hp_path(person.data["title"]) != person.basename_without_ext
        # Ensure the page title matches the filename, as we generate links to the filename elsewhere given the title.
        # See issue #649
        Jekyll.logger.abort_with("Person record #{person.basename_without_ext} does not match 'title': '#{person.data['title']}'")
      end

      # Names
      person.data["name"] = person.data["title"]
      person.data["forename"] = person.data["title"].split[0..-2].join(" ")
      person.data["surname"] = person.data["title"].split[-1]

      # Populate person record with data from the reverse index
      if @site.data["people_names"].include?( person.data["title"] )
        person.data["shows"] = @site.data["people_ri_shows"][ person.data["title"] ] || []
        person.data["shows_count"] = person.data["shows"].size
        person.data["committees"] = @site.data["people_ri_committees"][ person.data["title"] ] || []
        person.data["committees_count"] = person.data["committees"].size
      end

      # Graduation estimation
      if not person.data["graduated"] # If we don't know the date, estimate
        person.data["graduated"] = estimate_graduated(person)
        person.data["graduated_estimated"] = true
      else 
        person.data["graduated_actual"] = person.data["graduated"]
        person.data["graduated_estimated"] = false
      end

      # Student status 

      # People who have not graduated; those graduating in the future, or those graduating later this year are students.
      # The month where most students will have graduated is defined in _config.yml
      if (not person.data["graduated"] or (person.data["graduated"] > Time.now().year)) or 
        ((person.data["graduated"] == Time.now().year) and (Time.now().month < @site.config["graduation_month"]))
        if (person.data["shows"]) or (person.data["committees"])
          person.data["student"] = true 
        else 
          person.data["student"] = false 
        end
      else 
        person.data["student"] = false # Ensure person always has student status set
      end 

      # Replace headshots with SmugMug Images
      if person.data["headshot"]
        person.data["headshot"] = SmugImage.new(person.data["headshot"])
      end

      # Person additional data
      person.data["path_name"] = make_hp_path(person.data["title"])
      person.data["decade"] = "#{person.data["graduated"]}"[0,3]
      if person.data["graduated"] and person.data["student"] == false 
        person.data["grad_link"] = year_link(person.data["graduated"])
      end 

      # True when a bio is present, editor or submitter
      person.data["has_bio"] = person.content.length > 0

      # Person link lists
      person.data["links"] = LinkList::LinkList.new(@site, person.data["links"], person)
      @site.data['link-register'].add_list(person.data["links"])
      person.data["news"] = LinkList::LinkList.new(@site, person.data["news"], person)
      @site.data['link-register'].add_list(person.data["news"])

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

def sort_people(a, b)
  z = (a.data["surname"] <=> b.data["surname"])
  z.zero? ? (a.data["forename"] <=> b.data["forename"]) : z
end
