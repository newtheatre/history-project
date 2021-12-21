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
      elsif show.data.key?("improvised")
        # Is an improv show 
        if show.data["improvised"] == true
          ["improvised", nil, "Improvised"]
        end 
      else
        # Is
        ["unknown", nil, "Playwright Unknown"]
      end
      # Return playwright_type, playwright, playwright_formatted
    end

    def get_show_year(show)
      path_split = show.path.split("/")
      year_year = path_split[path_split.length - 2]
      match_data = /(^\d{2})_(\d{2})$/.match year_year
      if match_data.nil?
        # Check we use the correct format
        Jekyll.logger.abort_with("Invalid year folder #{year_year} in #{show.relative_path}, must match format YY_YY")
      elsif not (match_data[1].to_i == match_data[2].to_i - 1 or [match_data[1].to_i, match_data[2].to_i] == [99, 0])
        # Check year_1 == year_2 - 1, or century rollover
        Jekyll.logger.abort_with("Invalid year folder #{year_year} in #{show.relative_path}, year span (#{match_data[1].to_i} to #{match_data[2].to_i}) invalid")
      end
      return year_year
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
      # Retired, was live 2015-10-29 until 2017-02-24
      # "shows/#{show.data['year']}/#{show.basename_without_ext}.html"
    end

    def ignore_missing(show, seasons)
      # Should we ignore most errors on this show record?
      seasons.include? show.data['season']
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

    def missing_majority(show)
      # We don't have crew_incomplete yet, so let's work it out.
      show_crew_count = show.data["crew"] ? show.data["crew"].length : 0
      amount_missing = 0 
      missing_fields = ''

      if not show.data["date_start"]
        amount_missing += 1
        missing_fields += 'date_start '
      end 
      if not show.data["poster"]
        amount_missing += 1
        missing_fields += 'poster '
      end 
      if show.data["excerpt"] == ''
        amount_missing += 1
        missing_fields += 'excerpt '
      end
      if not show.data["cast"]
        amount_missing += 1
        missing_fields += 'cast '
      elsif show.data["cast_incomplete"] == true 
        amount_missing += 1
        missing_fields += 'cast_incomplete '
      end 
      if show.data["crew"]
        if show.data["crew"].size <= @site.config['show_low_crew']
          amount_missing += 1
          missing_fields += 'crew_short '
        end 
      else 
        amount_missing += 1
        missing_fields += 'crew '
      end 
      if show.data["playwright_type"] == "unknown"
        amount_missing += 1
        missing_fields += 'playwright '
      end 
      if not show.data["venue"]
        amount_missing += 1
        missing_fields += 'venue '
      end 

      if amount_missing >= 4 
        missing_majority = true 
      else 
        missing_majority = false 
      end 
      return missing_majority, missing_fields
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
        # Prioritise venue sort for link, as if set URL based on venue will not exist. PR #603.
        v = show.data["venue_sort"] || show.data["venue"]
        show.data["venue_path"] = "/venues" + VenuePage.make_path(v) + "/"
      end

      # To put content in meta description
      show.data["excerpt"] = show.content

      # Set meta attributes
      show.data["playwright_type"], show.data["playwright"],
        show.data["playwright_formatted"] = get_show_playwright(show)

      show.data["playwright_formatted_long"] = get_show_playwright_formatted_long(show)

      # Add extra data to cast / crew lists
      show.data["cast"] = generate_show_pls(show, "cast")

      if show.data.key?("student_written") and show.data["student_written"] and show.data.key?("playwright") and not show.data["playwright"].nil? and not show.data["playwright_false"]
        if show.data.key?("adaptor") and not show.data["adaptor"].nil?
          student_playwright = show.data["adaptor"]
          playwright_role = "Adaptor"
        elsif show.data.key?("translator") and not show.data["translator"].nil?
          student_playwright = show.data["translator"]
          playwright_role = "Translator"
        else 
          student_playwright = show.data["playwright"]
          playwright_role = "Playwright"
        end 

        if not student_playwright.include?(" and ") and not student_playwright.include?(", ") and not student_playwright.include?(" & ")
          # Exclude multiple playwrights 
          if show.data.key?("playwright_alias")
            # Students often write under different names. Offer the ability to account for that and still attribute appropriately. Related to #965.
            student_playwright = {"role"=>playwright_role, "name"=>show.data["playwright_alias"]}
          else
            student_playwright = {"role"=>playwright_role, "name"=>student_playwright}
          end 
          if show.data.key?("crew")
            if not show.data["crew"].include?(playwright_role)
              # Add the playwright to the top of the crew list 
              show.data["crew"].unshift(student_playwright)
            else
              Jekyll.logger.warn show.data["title"] + " has student playwright set manually"
            end
          else 
            # No existing crew list? No problem.
            show.data["crew"] = [student_playwright]
          end 
        end
      end 

      show.data["crew"] = generate_show_pls(show, "crew")

      # Process trivia
      if show.data.key?('trivia')
        show.data['trivia'] = Trivia::QuoteList.new(@site, show.data['trivia'])
      end

      # Fetch SmugMug album data
      show.data["smugmug_album"] = get_show_smugmug(show)

      # Generate the legacy path for 301 redirect re. #142 Make semantic and pretty urls
      # No legacy paths currently, disable
      # show.data["redirect_from"] = Array(get_show_legacy_paths(show)).freeze

      # Replace assets' image attr with a SmugImage
      show.data["assets"] ||= []
      show.data["assets"].each do |asset|
        if asset.key? "image"
          asset["image"] = SmugImage.new(asset["image"])
        elsif asset.key? "video"
          asset["video"] = SmugImage.new(asset["video"])
        end
      end

      # Set the show poster attribute, see #117
      display_image = get_show_display_image(show)
      show.data["poster"] = display_image
      show.data["display_image"] = display_image

      if show.data.key?("links")
        show.data["links"] = LinkList::LinkList.new(@site, show.data["links"], show)
        @site.data['link-register'].add_list(show.data["links"])
      end

      # Set ignore_missing if not already
      show.data["ignore_missing"] ||= ignore_missing(show, @site.config["ignore_missing_in_seasons"])

      # Work out if we're missing the majority of key fields for the show
      show.data["missing_majority"], show.data["missing_fields"] = missing_majority(show)
    end

    def sort_shows(shows)
      return shows.sort_by do | show |
        if show.data.key?("season_sort")
          # Sort by year, then by season_sort
          [show.data["year_page"].data["start_year"], show.data["season_sort"].to_i]
        else
          # If no season_sort, assume 1000
          [show.data["year_page"].data["start_year"], 1000]
        end
      end
    end

    def generate_show_with_index(show, index)
      # Set sort dependant attributes
      show.data["seq_index"] = index
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
