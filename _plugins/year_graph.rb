module NTHP
  class YearGraph
    YEARGRAPH_WIDTH = 1400
    YEARGRAPH_HEIGHT = 400
    MIN_HEIGHT = 3

    def initialize(site)
      @site = site
    end

    def graph
      @graph || graph!
    end

    def graph!
      # Max number of shows
      ns_max = @site.data['top_show_count']
      # Number of years
      ny = (@site.config['year_end'] - @site.config['year_start']) + 1

      # Width and height constants
      w_c = YEARGRAPH_WIDTH
      h_c = YEARGRAPH_HEIGHT - MIN_HEIGHT

      # Columns
      cols = Array.new

      @site.collections["years"].docs.each_with_index do |year, i|
        ns = year.data['show_count']
        w_i = 1/ny.to_f * w_c
        h_i = (ns/ns_max.to_f * h_c) + MIN_HEIGHT
        y = YEARGRAPH_HEIGHT - h_i
        x = i/ny.to_f * YEARGRAPH_WIDTH
        cols << {
          'x' => x,
          'y' => y,
          'width' => w_i,
          'height' => h_i,
          'year' => year,
        }
      end

      @graph = cols
      return @graph
    end

    def to_liquid
      {
        'width' => YEARGRAPH_WIDTH,
        'height' => YEARGRAPH_HEIGHT,
        'graph' => graph,
      }
    end
  end
end
