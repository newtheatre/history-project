module NTHP
  class RenderOnce
    # Liquid object to render an include only the once, then use that cached
    # version on subsequent usages. Sacrifices page variables for render speed.
    def initialize(site, template)
      @site = site
      @template_path = File.join(site.source, '_includes', template)
    end

    def render
      @render || render!
    end

    def render!
      content = ''
      f = File.open(@template_path, "r")
      f.each_line do |line|
        content += line
      end

      payload = @site.site_payload

      info = {
        filters:   [Jekyll::Filters],
        registers: { :site => @site, :page => payload['page'] }
      }

      @render = @site.liquid_renderer.file(@template_path).parse(content).render!(payload, info)
      return @render
    end

    def to_liquid
      render
    end
  end
end
