module Jekyll
  class YearGraphGenerator < Generator
    priority :lowest

    def generate(site)
      Jekyll.logger.info "Processing year graph..."

      path = File.join(site.source, '_includes/fancy/year_graph.html')

      content = ''
      f = File.open(path, "r")
      f.each_line do |line|
        content += line
      end

      payload = site.site_payload

      info = {
        filters:   [Jekyll::Filters],
        registers: { :site => site, :page => payload['page'] }
      }

      site.data['year_graph'] = site.liquid_renderer.file(path).parse(content).render!(payload, info)
    end
  end
end
