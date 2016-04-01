module Jekyll
  class ShowDataGenerator < Jekyll::Generator
    priority :high

    # From years.rb
    def years_by_slug
      @years_by_slug ||= generate_years_by_slug(@years)
    end

    # From people.rb
    def people_by_filename
      @people_by_filename ||= generate_people_by_filename(@people)
    end

    # Attribute generators

    def get_show_playwright(show)
      if show.data.key?("playwright") and not show.data["playwright"].nil?
        if show.data["playwright"] == "various"
          # Is various, special case
          ["various", nil, "Various Writers"]
        else
          # Is a proper playwright
          ["playwright", show.data["playwright"], "by #{ show.data["playwright"] }"]
        end
      elsif show.data.key?("devised")
        # Is devised
        if show.data["devised"] == true
          ["devised", nil, "Devised"]
        else
          ["devised", nil, "Devised by #{ show.data["devised"] }"]
        end
      else
        # Is
        ["unknown", nil, "Playwright Unknown"]
      end
      # Return playwright_type, playwright, playwright_formatted
    end

    def get_show_year(show)
      path_split = show.path.split("/")
      path_split[path_split.length - 2]
    end

    def get_show_year_page(show)
      years_by_slug[show.data["year"]]
    end

    def get_show_playwright_formatted_long(show)
      ret = show.data["playwright_formatted"]

      if show.data.key?("translator")
        ret = "#{ ret }; Translated by #{ show.data["translator"] }"
      end

      if show.data.key?("adaptor")
        ret = "#{ ret }; Adapted by #{ show.data["adaptor"] }"
      end

      return ret
    end

    def get_show_override_assets(show)
      show.data["assets"].select { |i| i["display_image"] == true }
    end

    def get_show_asset_type(show, key, image_only=true)
      show.data["assets"].select do |i|
        # Skip non-images if image_only
        if image_only and not i.key?("image") then next end

        # If assets are paginated take page 1 only, else take first occurrence
        if i.key?("page")
          i["type"] == key and not i["page"] > 1
        else
          i["type"] == key
        end
      end
    end

    def get_show_display_image(show)
      # Assets required
      return nil unless show.data.key?("assets")

      # Find assets that fit the criteria for being a display image
      override_assets = get_show_override_assets(show)
      posters = get_show_asset_type(show, "poster")
      flyers = get_show_asset_type(show, "flyer")
      programmes = get_show_asset_type(show, "programme")

      # Pick one in this order of precedence
      if override_assets.size > 0
        return override_assets[0]
      elsif posters.size > 0
        return posters[0]
      elsif flyers.size > 0
        return flyers[0]
      elsif programmes.size > 0
        return programmes[0]
      else
        return nil
      end
    end

    def get_show_smugmug(show)
      if show.data.key? "prod_shots"
        smugalbum = SmugAlbum.new
        return smugalbum.get_show_photos(show.data["prod_shots"])
      else
        return nil
      end
    end

    def get_show_legacy_paths(show)
      "shows/#{show.data['year']}/#{show.basename_without_ext}.html"
    end

    def generate_show_pls(show, key)
      if show.data.key?(key) and show.data[key]
        return parse_person_list(show.data[key], people_by_filename)
      else
        return nil
      end
    end

    def send_people(show, key)
      """Send a person_list to the reverse index"""
      if show.data.key?(key) and show.data[key].class == Array
        fill_people_reverse_index(show, show.data[key], "people_ri_shows", @site)
      end
    end

    # Show generator
    def generate_show(show)
      # Set year attributes
      show.data["year"] = get_show_year(show)
      show.data["year_page"] = get_show_year_page(show)

      # If season / venue specified store relative path to its page
      if show.data["season"]
        show.data["season_path"] = "/seasons" + SeasonPage.make_path(show.data["season"]) + "/"
      end
      if show.data["venue"]
        show.data["venue_path"] = "/venues" + VenuePage.make_path(show.data["venue"]) + "/"
      end

      # To put content in meta description
      show.data["excerpt"] = show.content

      # Set meta attributes
      show.data["playwright_type"], show.data["playwright"],
        show.data["playwright_formatted"] = get_show_playwright(show)

      show.data["playwright_formatted_long"] = get_show_playwright_formatted_long(show)

      # Add extra data to cast / crew lists
      show.data["cast"] = generate_show_pls(show, "cast")
      show.data["crew"] = generate_show_pls(show, "crew")

      # Fetch SmugMug album data
      show.data["smugmug_album"] = get_show_smugmug(show)

      # Generate the legacy path for 301 redirect re. #142 Make semantic and pretty urls
      show.data["redirect_from"] = get_show_legacy_paths(show)

      # Set the show poster attribute, see #117
      display_image = get_show_display_image(show)
      show.data["poster"] = display_image
      show.data["display_image"] = display_image
    end

    def sort_shows(shows)
      return shows.sort_by do | show |
        if show.data.key?("season_sort")
          # Sort by year, then by season_sort
          [show.data["year_page"].data["sort"], show.data["season_sort"].to_i]
        else
          # If no season_sort, assume 1000
          [show.data["year_page"].data["sort"], 1000]
        end
      end
    end

    def generate_show_with_index(show, index)
      # Set sort dependant attributes
      show.data["index"] = index
      show.data["seq_next"] = @shows[index + 1]
      show.data["seq_previous"] = @shows[index - 1]

      # Extract cast/crew data for reverse indexing, this wants to happen to
      # the sorted shows so lists on people records are in order
      send_people(show, "cast")
      send_people(show, "crew")
    end

    def hash_shows_by_year(shows)
      """Returns a hash of shows by year"""
      shows_by_year = Hash.new
      # Iterate through sorted shows
      # Put show into an array as a member of the shows_by_year hash
      # Create that array if this is the first time we've touched this year
      shows.each { |show| (shows_by_year[show.data["year"]] ||= []) << show }
      return shows_by_year
    end

    # Main generation method
    def generate(site)
      Jekyll.logger.info "Processing shows..."

      @site = site

      @years = @site.collections["years"].docs
      @people = @site.collections["people"].docs

      # Compute extra show data attributes and sort, get list of shows
      @shows = @site.collections["shows"].docs.each { |show| generate_show(show) }

      @shows = sort_shows(@shows)

      # Compute extra show data attributes that require sorting to have happened
      @shows.each_with_index { |show, index| generate_show_with_index(show, index) }

      # Accessible chopped and diced shows
      @site.data["shows"] = @shows
      @site.data["shows_by_year"] = hash_shows_by_year(@shows)

    end
  end
end
