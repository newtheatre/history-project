module Trivia
  class Quote
    def initialize(site, quote_hash)
      @site = site
      @quote_hash = quote_hash
    end

    def person
      if @quote_hash.key?('name')
        people = @site.collections["people"].docs
        people_by_filename = generate_people_by_filename(people)
        filename = make_hp_path(@quote_hash['name'])
        if people_by_filename.key?(filename)
          return people_by_filename[filename]
        end
      end
    end

    def to_liquid
      {
        "quote" => @quote_hash['quote'],
        "name" => @quote_hash['name'],
        "submitted" => @quote_hash['submitted'],
        "person" => person,
      }
    end
  end

  class QuoteList
    def initialize(site, trivia_list)
      @site = site
      @trivia_list = trivia_list
    end

    def quotes
      quotes = Array.new
      for item in @trivia_list
        quotes << Quote.new(@site, item)
      end
      return quotes
    end

    def to_liquid
      quotes
    end
  end
end