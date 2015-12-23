module Jekyll
  class ShowsByGenerator < Jekyll::Generator
    priority :normal

    def show_iterator(show)
      if show.data["season"]
        (@shows_by_season[show.data["season"]] ||= []) << show
      end
      if show.data["period"]
        (@shows_by_period[show.data["period"]] ||= []) << show
      end
      if show.data["venue"] and show.data["venue"].downcase != "unknown"
        (@shows_by_venue[show.data["venue"]]   ||= []) << show
      end
    end

    def generate(site)
      Jekyll.logger.info "Generating shows by..."

      # Collection hashes
      @shows_by_season = Hash.new
      @shows_by_period = Hash.new
      @shows_by_venue  = Hash.new
      @shows_by_tour   = Hash.new  # NYI

      site.data["shows"].each { |show| show_iterator(show) }

      # Save sorted hashes
      site.data["shows_by_season"] = @shows_by_season.sort.to_h
      site.data["shows_by_period"] = @shows_by_period.sort.to_h
      site.data["shows_by_venue"] = @shows_by_venue.sort.to_h
      site.data["shows_by_tour"] = @shows_by_tour.sort.to_h
    end
  end
end
