module Jekyll
  class AssetDataGenerator < Jekyll::Generator
    """Make asset data from all show files accessible"""
    priority :lowest

    # Pipeline: generate -> generate_show_assets(show) -> generate_asset(show, asset)

    def generate_asset(show, asset)
      """Method called for each asset in the asset attribute"""
      # Assign the show as an attr of the asset
      asset["show"] = show

      if asset.has_key?("image") and asset.has_key?("type")
        # Image asset

        case asset["type"]
          when "poster"
            @posters << asset
          when "flyer"
            @flyers << asset
          else
            # None
        end

      elsif asset.has_key?("filename") and asset.has_key?("type")
        # File asset
      end
    end

    def generate_show_assets(show)
      """Method called for each show, runs asset generators on each"""
      if show.data.has_key?("assets") and show.data["assets"]
        show.data["assets"].each { |asset| generate_asset(show, asset) }
      end

    end

    def poster_bar(posters, posters_in_bar=50)
      return posters.sample(posters_in_bar)
    end

    def generate(site)
      puts "Processing archive assets..."
      shows = site.data["shows"]

      @posters = Array.new
      @flyers = Array.new

      shows.each { |show| generate_show_assets(show) }

      site.data["asset_posters"] = @posters
      site.data["asset_flyers"] = @flyers

      # Not in use
      # site.data["assets_posters_bar"] = poster_bar(posters)
      # site.data["assets_posterwall"] = poster_bar(posters, 30)

    end
  end
end

