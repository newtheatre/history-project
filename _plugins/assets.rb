module Jekyll
  class AssetDataGenerator < Jekyll::Generator
    """Make asset data from all show files accessible"""
    priority :lowest


    def poster_bar(posters)
      posters_in_bar = 50
      # posters_for_bar = []

      # Do this rather than posters.sample(posters_in_bar) to allow posters_in_bar > posters.size
      # for i in 1..posters_in_bar do
      #   posters_for_bar << posters.sample
      # end

      return posters.sample(posters_in_bar)
    end

    def generate(site)
      puts "Processing archive assets..."
      all_shows = site.data["shows"]

      posters = []
      flyers = []

      for show in all_shows do
        loop_over = []
        if show.data["assets"]
          loop_over += show.data["assets"]
        end
        if show.data["photos"]
          loop_over += show.data["photos"]
        end

        for asset in loop_over do
          # Assign the show as an attr of the asset
          asset["show"] = show

          if asset.has_key?("image") and asset.has_key?("type")
            # Image asset

            case asset["type"]
              when "poster"
                posters << asset
              when "flyer"
                flyers << asset
              else
                # None
            end

          elsif asset.has_key?("filename") and asset.has_key?("type")
            # File asset
          end
        end

      end

      site.data["asset_posters"] = posters
      site.data["asset_flyers"] = flyers

      site.data["assets_posters_bar"] = poster_bar(posters)

    end
  end
end

