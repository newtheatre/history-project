module Jekyll
  class PeopleDataGenerator < Jekyll::Generator
    priority :normal # Before years, after shows and committees

    def generate(site)
      puts "Processing people..."
      people = site.collections["people"].docs


      for person in people

        # Populate person record with data from the reverse index
        if site.data["people_ri"].has_key?( person.data["title"] )
          person.data["shows"] = site.data["people_ri"][ person.data["title"] ]
        end

      end

    end
  end
end

