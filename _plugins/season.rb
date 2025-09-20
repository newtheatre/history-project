module Jekyll
  class SeasonPage < Document
    def initialize(site, collection, season, shows)
      @site = site
      @season = season
      @path = SeasonPage.make_path(season)
      @extname = File.extname(path)
      @output_ext = Jekyll::Renderer.new(site, self).output_ext
      @collection = collection
      @has_yaml_header = nil

      defaults = @site.frontmatter_defaults.all(url, collection.label.to_sym)

      my_data = {
        "title" => get_title(),
        "show_count" => shows.size,
        "shows" => shows,
        "class" => @path[1..-1],
      }

      @data = Utils.deep_merge_hashes(defaults, my_data)
    end

    def get_title()
      "#{ @season }"
    end

    def self.make_path(season_name)
      # Downcase, remove specials, space->underscore
      season_path = season_name.downcase.gsub(/[^a-z0-9 -]/, '').gsub(/ /, '-').gsub('---', '-')
      # Special case, UNCUT was renamed to Fringe and then to Studio
      if season_name == "UNCUT" then season_path = "studio" end
      if season_name == "Fringe" then season_path = "studio" end
      # Special case, Unscripted being renamed to Creatives
      if season_name == "Unscripted" then season_path = "creatives" end
      "/#{ season_path }"
    end

    def content()
      ""
    end
  end

  class SeasonGenerator < Generator
    priority :low

    def generate(site)
      if not site.config["skip_seasons"]
        @collection = site.collections["seasons"]
        Jekyll.logger.info "Generating seasons..."

        for season in site.data["shows_by_season"]
          unless @collection.docs.detect { |doc| doc.data["title"] == season[0] }
            @collection.docs << SeasonPage.new(site, @collection, season[0], season[1])
          end
        end
      else
        Jekyll.logger.warn "Skipping season generation"
      end
    end
  end
end
