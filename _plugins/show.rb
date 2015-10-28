module Jekyll
  class ShowDataGenerator < Jekyll::Generator
    priority :highest

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
      if show.data.has_key?("playwright")
        return ["playwright", show.data["playwright"], "by #{ show.data["playwright"] }"]
      elsif show.data.has_key?("devised")
        if show.data["devised"] == true
          return ["devised", "", "Devised"]
        else
          return ["devised", show.data["devised"], "Devised by #{ show.data["devised"] }"]
        end
      else
        return ["unknown", nil, "Playwright Unknown"]
      end
      # Return playwright_type, playwright, playwright_formatted
    end

    def get_show_year(show)
      path_split = show.path.split("/")
      path_split[path_split.length-2]
    end

    def get_show_year_page(show)
      years_by_slug[show.data["year"]]
    end

    def get_show_playwright_formatted_long(show)
      ret = show.data["playwright_formatted"]

      if show.data.has_key?("translator")
        ret = "#{ ret }; Translated by #{ show.data["translator"] }"
      end

      if show.data.has_key?("adaptor")
        ret = "#{ ret }; Adapted by #{ show.data["adaptor"] }"
      end

      return ret
    end

    def get_show_override_assets(show)
      show.data["assets"].select { |i| i["display_image"] == true }
    end

    def get_show_posters(show)
      show.data["assets"].select { |i| i["type"] == "poster" }
    end

    def get_show_flyers(show)
      show.data["assets"].select { |i|
        if i.has_key?("page")
          i["type"] == "flyer" and not i["page"] > 1
        else
          i["type"] == "flyer"
        end
      }
    end

    def get_show_programmes(show)
      show.data["assets"].select { |i|
        if i.has_key?("page")
          i["type"] == "programme" and not i["page"] > 1
        else
          i["type"] == "programme"
        end
      }
    end

    def get_show_display_image(show)
      # Assets required
      return nil if not show.data.has_key?("assets")

      # Find assets that fit the criteria for being a display image
      override_assets = get_show_override_assets(show)
      posters = get_show_posters(show)
      flyers = get_show_flyers(show)
      programmes = get_show_programmes(show)

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
      if show.data.has_key? "smugmug"
        smug = Smug.new
        return smug.get_show_photos(show.data["smugmug"], @site)
      else
        return nil
      end
    end

    def get_show_legacy_paths(show)
      "shows/#{show.data["year"]}/#{show.basename_without_ext}.html"
    end

    def generate_show_pls(show, key)
      if show.data.has_key?(key) and show.data[key]
        return parse_person_list(show.data[key], people_by_filename)
      else
        return nil
      end
    end

    def send_people(show, key)
      """Send a person_list to the reverse index"""
      if show.data.has_key?(key) and show.data[key].class == Array
        fill_people_reverse_index(show, show.data[key], "people_ri_shows", @site)
      end
    end

    # Show generator
    def generate_show(show)
      # Set year attributes
      show.data["year"] = get_show_year(show)
      show.data["year_page"] = get_show_year_page(show)

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
        if show.data.has_key?("season_sort")
          # Sort by year, then by season_sort
          [show.data["year_page"].data["sort"], show.data["season_sort"].to_i]
        else
          # If no season_sort, assume 1000
          [show.data["year_page"].data["sort"], 1000]
        end
      end
    end

    # Main generation method
    def generate(site)
      puts "Processing shows..."

      @site = site

      @years = @site.collections["years"].docs
      @people = @site.collections["people"].docs

      # Compute extra show data attributes and sort
      shows = sort_shows(
        @site.collections["shows"].docs.each { |show| generate_show(show) }
      )

      shows_by_year = Hash.new

      for show, index in shows.each_with_index do
        # Put show into an array as a member of the shows_byt_year hash
        # Create that array if this is the first time we've touched this year
        (shows_by_year[show.data["year"]] ||= []) << show

        # Set sort dependant attributes
        show.data["index"] = index
        show.data["next"] = shows[index + 1]
        show.data["previous"] = shows[index - 1]

        # Extract cast/crew data for reverse indexing, this wants to happen to
        # the sorted shows so lists on people records are in order
        send_people(show, "cast")
        send_people(show, "crew")
      end

      # Accessible chopped and diced shows
      @site.data["shows"] = shows
      @site.data["shows_by_year"] = shows_by_year

    end
  end
end
