module Facts
  class Fact
    def initialize(site, fact_hash)
      @site = site
      @fact_hash = fact_hash
    end

    def person
      if @fact_hash.key?('name')
        people = @site.collections["people"].docs
        people_by_filename = generate_people_by_filename(people)
        filename = make_hp_path(@fact_hash['name'])
        if people_by_filename.key?(filename)
          return people_by_filename[filename]
        end
      end
    end

    def to_liquid
      {
        "fact" => @fact_hash['fact'],
        "name" => @fact_hash['name'],
        "submitted" => @fact_hash['submitted'],
        "person" => person,
      }
    end
  end

  class FactList
    def initialize(site, fact_list)
      @site = site
      @fact_list = fact_list
    end

    def facts
      facts = Array.new
      for fact in @fact_list
        facts << Fact.new(@site, fact)
      end
      return facts
    end

    def to_liquid
      facts
    end
  end
end