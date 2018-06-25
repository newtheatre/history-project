SORT_CITIES = ['Nottingham', 'Edinburgh', nil]

module Jekyll
  class VenuePage < Document
    def initialize(site, collection, venue)
      @site = site
      @venue = venue
      @path = VenuePage.make_path(venue)
      @extname = File.extname(path)
      @output_ext = Jekyll::Renderer.new(site, self).output_ext
      @collection = collection
      @has_yaml_header = nil

      defaults = @site.frontmatter_defaults.all(url, collection.label.to_sym)

      @data = Utils.deep_merge_hashes(defaults, {"title" => get_title(), "placeholder" => true})
    end

    def get_title()
      "#{ @venue }"
    end

    def self.make_basename(venue_name)
      # 'A Venue' → 'a-venue'
      venue_name.downcase.gsub(/[^a-z0-9 -]/, '').gsub(/ /, '-').gsub('---', '-')
    end

    def self.make_path(venue_name)
      # Downcase, remove specials, space->underscore
      "/#{ self.make_basename(venue_name) }"
    end

    def content()
      ""
    end
  end

  class VenueGenerator < Generator
    priority :low

    def generate(site)
      # Generate venue pages for venues without manually created pages.
      if not site.config["skip_venues"]
        @collection = site.collections["venues"]
        Jekyll.logger.info "Generating venues..."

        for venue in site.data["shows_by_venue"]
          unless @collection.docs.detect { |doc| doc.data["title"] == venue[0] }
            @collection.docs << VenuePage.new(site, @collection, venue[0])
          end
        end
      else
        Jekyll.logger.warn "Skipping venue generation"
      end

      # Single venue generation
      for venue_page in @collection.docs
        # Ensure the page title matches the filename, as we generate links to the filename elsewhere given the title. See #1027
        if VenuePage.make_basename(venue_page.data['title']) != venue_page.basename_without_ext
          Jekyll.logger.abort_with("Venue filename '#{venue_page.basename}' does not match venue title '#{venue_page.data['title']}'. It should be (based on title) '#{VenuePage.make_basename(venue_page.data['title'])}.md'.")
        end

        # Assign shows to venue, or not
        venue_page.data['shows'] = site.data['shows_by_venue'][venue_page.data['title']] || []

        venue_page.data['show_count']  = venue_page.data['shows'].size
        # venue_page.data['class'] = venue_page.path.split('/')[-1][0..-4]
        venue_page.data['class'] = 'venue'

        venue_page.data['title_short'] ||= venue_page.data['title']

        if venue_page.data['images']
          venue_page.data['smug_images'] = []
          for imageKey in venue_page.data['images']
            smugImage = SmugImage.new(imageKey)
            venue_page.data['smug_images'].push(smugImage)
          end
        end

        venue_page.data['is_listed'] = venue_page.data['show_count'] > 1

        # Set city_sort, used for listing cities on archive page
        if venue_page.data.key?('city')
          venue_page.data['city_sort'] = SORT_CITIES.include?(venue_page.data['city']) ? venue_page.data['city'] : nil
        else
          venue_page.data['city_sort'] = nil
        end

        if venue_page.data.key?("links")
          venue_page.data["links"] = LinkList::LinkList.new(@site, venue_page.data["links"], venue_page)
          @site.data['link-register'].add_list(venue_page.data["links"])
        end
        
      end

      # Venue groups
      site.data['venues_by_city'] = Hash.new
      @collection.docs.each do |venue|
        site.data['venues_by_city'][venue.data.fetch('city_sort', nil)] ||= Array.new
        site.data['venues_by_city'][venue.data.fetch('city_sort', nil)].push(venue)
      end
      site.data['venues_by_city'].each do |city, venues|
        # Sort venues if sort param is set, used to push NT venues to top of Nottingham list
        venues.sort! { |a, b| a.data.fetch('sort', 999) <=> b.data.fetch('sort', 999) }
      end
    end
  end
end
