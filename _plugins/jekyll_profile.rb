module Jekyll
  class Site
    def render
      relative_permalinks_deprecation_method

      payload = site_payload
      collections.each do |label, collection|
        collection.docs.each do |document|
          t1 = Time.now
          if true
            document.output = Jekyll::Renderer.new(self, document).run
          end
          t2 = Time.now
          puts document.path + ": " + (t2-t1).to_s
        end
      end

      payload = site_payload
      [posts, pages].flatten.each do |page_or_post|
        t1 = Time.now
        if true
          page_or_post.render(layouts, payload)
        end
        t2 = Time.now
        puts page_or_post.path + ": " + (t2-t1).to_s
      end
    rescue Errno::ENOENT
      # ignore missing layout dir
    end
  end
end
