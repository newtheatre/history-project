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

      # defaults = @site.frontmatter_defaults.all(url, collection.label.to_sym)
      defaults = @site.config['collections']['people'] # Above no work, this work

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

      @collection = site.collections["people"]

      for title, shows in site.data["people_ri_shows"]
        unless @collection.docs.detect { |doc| doc.data['title'] == title }
          @collection.docs << PlaceholderPeoplePage.new(site, @collection, title)
        end
      end

    end

  end

  class PeopleDataGenerator < Generator
    priority :low # Before years, after shows and committees

    def generate(site)
      puts "Processing people..."
      people = site.collections["people"].docs


      for person in people

        # Populate person record with data from the reverse index
        if site.data["people_ri_shows"].has_key?( person.data["title"] )
          person.data["shows"] = site.data["people_ri_shows"][ person.data["title"] ]
          person.data["committees"] = site.data["people_ri_committees"][ person.data["title"] ]
        end

        # Person additional data
        person.data["path_name"] = make_hp_path(person.data["title"])

      end

    end
  end
end

