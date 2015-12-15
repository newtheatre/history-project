module Jekyll
  class YearPage < Document
    def initialize(site, collection, year)
      @site = site
      @year = year
      @path = make_path()
      @extname = File.extname(path)
      @output_ext = Jekyll::Renderer.new(site, self).output_ext
      @collection = collection
      @has_yaml_header = nil

      defaults = @site.frontmatter_defaults.all(url, collection.label.to_sym)

      my_data = {
        "title" => get_title(),
        "sort" => @year,
        "year" => "#{ year_span_short[0] }_#{ year_span_short[1] }",
        "decade" => @year.to_s[0..2],
      }

      @data = Utils.deep_merge_hashes(defaults, my_data)
    end

    def year_span_short()
      """Return the two character representation of the year span as a list"""
      [@year.to_s[2..3], (@year + 1).to_s[2..3]]
    end

    def get_title()
      "#{ @year.to_s } - #{ year_span_short[1] }"
    end

    def make_path()
      # Downcase, remove specials, space->underscore
      "/#{ year_span_short[0] }_#{ year_span_short[1] }"
    end

    def content()
      ""
    end
  end

  class YearGenerator < Generator
    priority :highest

    def generate(site)
      if not site.config["skip_years"]
        @collection = site.collections["years"]
        Jekyll.logger.info "Generating years..."

        for year in site.config["year_start"]..site.config["year_end"]
          unless @collection.docs.detect { |doc| doc.data["sort"] == year }
            @collection.docs << YearPage.new(site, @collection, year)
          end
        end
      else
        Jekyll.logger.warn "Skipping year generation"
      end
    end
  end

  class YearDataGenerator < Generator
    priority :lowest  # Should be one of the last to execute

    def get_sorted_years(years)
      years.sort_by { |year| year.data["sort"] }
    end

    def add_to_years_by_decade(year)
      (@years_by_decade[year.data["decade"]] ||= []) << year
    end

    def get_year_legacy_path(year)
      "years/#{year.basename_without_ext}.html"
    end

    def get_year_slug(year)
      year.data["year"]
    end

    def generate_year(year, index)
      """Method called for every year"""
      year_slug = get_year_slug(year)
      add_to_years_by_decade(year)

      # Title prettyness replacement
      year.data["title"] = year.data["title"].sub("-","&ndash;")

      year.data["committee"] = @site.data["committees_by_year"][year_slug]
      year.data["next"] = @years[index + 1]
      year.data["previous"] = @years[index - 1]
      year.data["shows"] = @site.data["shows_by_year"][year_slug]

      # Yucky ruby syntax, if not empty assign size, otherwise 0 cos no shows
      year.data["show_count"] = year.data["shows"] ? year.data["shows"].size : 0

      # Keep track of the most number of shows
      @top_show_count ||= 0 # Instance var common to all years
      @top_show_count = year.data["show_count"] if year.data["show_count"] > @top_show_count

      year.data["redirect_from"] = get_year_legacy_path(year)
    end

    def generate(site)
      Jekyll.logger.info "Processing years..."
      @site = site
      @years = get_sorted_years(@site.collections["years"].docs)
      committees = @site.collections["committees"].docs

      @years_by_decade = Hash.new
      top_show_count = 0

      @years.each_with_index { |year, index| generate_year(year, index) }

      # Create a copy of years_by_decade but with the lists reversed
      years_by_decade_reversed = Hash.new
      for key, value in @years_by_decade.each_pair
        years_by_decade_reversed[key] = value.reverse
      end

      @site.data["years"] = @years
      @site.data["years_by_decade"] = @years_by_decade
      @site.data["years_by_decade_reversed"] = years_by_decade_reversed
      @site.data["top_show_count"] = @top_show_count

    end
  end
end

# Utility functions

def generate_years_by_slug(years)
  years_by_slug = Hash.new
  for year in years
    years_by_slug[year.data["year"]] = year
  end
  return years_by_slug
end
