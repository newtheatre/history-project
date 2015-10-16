module Jekyll
  class ShowDataGenerator < Jekyll::Generator
    priority :highest

    def generate(site)
      puts "Processing shows..."
      all_shows = site.collections["shows"].docs
      years = site.collections["years"].docs

      # This is here as it's needed here, I expect year.rb to be run after.
      years_by_slug = Hash.new
      for year in years
        years_by_slug[year.data["year"]] = year
      end

      # Compute extra show data attributes
      shows_by_year = Hash.new
      for show, index in all_shows.each_with_index do
        path_split = show.path.split("/")
        year = path_split[path_split.length-2]

        # Set year attributes
        show.data["year"] = year
        show.data["year_hyphenated"] = year.sub("_","-")
        show.data["year_page"] = years_by_slug[show.data["year"]]

        # To put content in meta description
        show.data["excerpt"] = show.content

        # Fetch SmugMug album data
        if show.data.has_key? "smugmug"
          smug = Smug.new
          show.data["smugmug_album"] = smug.get_show_photos(show.data["smugmug"])
        end

        # Generate the legacy path for 301 redirect re. #142 Make semantic and pretty urls
        legacy_path = "shows/#{show.data["year"]}/#{show.basename_without_ext}.html"
        show.data["redirect_from"] = legacy_path

      end

      # Sort Shows
      sorted_shows = all_shows.sort_by do | show |
        if show.data.has_key?("season_sort")
          # Sort by year, then by season_sort
          [show.data["year_page"].data["sort"], show.data["season_sort"].to_i]
        else
          # If no season_sort, assume 1000
          [show.data["year_page"].data["sort"], 1000]
        end
      end

      for show, index in sorted_shows.each_with_index do
        # Put show into an array as a member of the shows_byt_year hash
        # Create that array if this is the first time we've touched this year
        (shows_by_year[show.data["year"]] ||= []) << show

        # Set sort dependant attributes
        show.data["index"] = index
        show.data["next"] = sorted_shows[index + 1]
        show.data["previous"] = sorted_shows[index - 1]

        # Extract cast/crew data for reverse indexing
        if show.data.has_key?("cast") and show.data["cast"].class == Array
          fill_people_reverse_index(show, show.data["cast"], "people_ri_shows", site) end
        if show.data.has_key?("crew") and show.data["crew"].class == Array
          fill_people_reverse_index(show, show.data["crew"], "people_ri_shows", site) end

        # Set the show poster attribute, see #117
        if show.data["assets"]

          # Find assets that fit the criteria for being a display image
          override_assets = show.data["assets"].select { |i| i["display_image"] == true }
          posters = show.data["assets"].select { |i| i["type"] == "poster" }
          flyers = show.data["assets"].select { |i|
            if i.has_key?("page")
              i["type"] == "flyer" and not i["page"] > 1
            else
              i["type"] == "flyer"
            end
          }
          programmes = show.data["assets"].select { |i|
            if i.has_key?("page")
              i["type"] == "programme" and not i["page"] > 1
            else
              i["type"] == "programme"
            end
          }

          # Pick one in this order of precedence
          if override_assets.size > 0
            display_image = override_assets[0]
          elsif posters.size > 0
            display_image = posters[0]
          elsif flyers.size > 0
            display_image = flyers[0]
          elsif programmes.size > 0
            display_image = programmes[0]
          end

          # Set attrs
          if display_image
            show.data["poster"] = display_image
            show.data["display_image"] = display_image
          end

        end
      end

      # Accessible chopped and diced shows
      site.data["shows"] = all_shows
      site.data["shows_by_year"] = shows_by_year

    end
  end
end
