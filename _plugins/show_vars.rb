module ShowVars
  class Generator < Jekyll::Generator
    def generate(site)
      all_shows = site.collections["shows"].docs
      for page in site.pages do
        # puts page["title"]
        page.data["all_shows"] = all_shows
      end
    end
  end
end
