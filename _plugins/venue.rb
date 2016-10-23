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

    def self.make_path(venue_name)
      # Downcase, remove specials, space->underscore
      venue_path = venue_name.downcase.gsub(/[^a-z0-9 -]/, '').gsub(/ /, '-').gsub('---', '-')
      "/#{ venue_path }"
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

      for venue_page in @collection.docs
        # Assign shows to venue, or not
        venue_page.data['shows'] = site.data['shows_by_venue'][venue_page.data['title']] || []

        venue_page.data['show_count']  = venue_page.data['shows'].size
        # venue_page.data['class'] = venue_page.path.split('/')[-1][0..-4]
        venue_page.data['class'] = 'venue'

        if venue_page.data['images']
          venue_page.data['smug_images'] = []
          for imageKey in venue_page.data['images']
            smugImage = SmugImage.new(imageKey)
            venue_page.data['smug_images'].push(smugImage)
          end
        end
      end
    end
  end
end
