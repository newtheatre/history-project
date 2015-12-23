module Jekyll
  class VenuePage < Document
    def initialize(site, collection, venue, shows)
      @site = site
      @venue = venue
      @path = VenuePage.make_path(venue)
      @extname = File.extname(path)
      @output_ext = Jekyll::Renderer.new(site, self).output_ext
      @collection = collection
      @has_yaml_header = nil

      defaults = @site.frontmatter_defaults.all(url, collection.label.to_sym)

      my_data = {
        "title" => get_title(),
        "sort" => shows.size,
        "shows" => shows
      }

      @data = Utils.deep_merge_hashes(defaults, my_data)
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
      if not site.config["skip_venues"]
        @collection = site.collections["venues"]
        Jekyll.logger.info "Generating venues..."

        for venue in site.data["shows_by_venue"]
          unless @collection.docs.detect { |doc| doc.data["title"] == venue[0] }
            @collection.docs << VenuePage.new(site, @collection, venue[0], venue[1])
          end
        end
      else
        Jekyll.logger.warn "Skipping venue generation"
      end
    end
  end
end
