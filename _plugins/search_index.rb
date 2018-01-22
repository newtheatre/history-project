module SearchIndex
  class SearchIndex
    def initialize(documents)
      @documents = documents
    end

    def to_liquid
      # Make a DocumentIndex for each page
      @documents.map { |doc|
        if doc.data["search"] == false or doc.data["title"] == ""
          next
        end
        DocumentIndex.new(doc)
      }.reject {|doc| doc==nil}
    end
  end

  class DocumentIndex
    def initialize(document)
      @document = document
    end

    def type
      # Page or collection name
      if @document.is_a? Jekyll::Page
        return "page"
      elsif @document.is_a? Jekyll::Document
        return @document.collection.label
      else
        raise "Unknown document type"
      end
    end

    def image_thumb
      case type
      when "shows"
        if @document.data['poster']
          @document.data['poster']['image'].customSize("33x44!")
        end
      when "people"
        if @document.data['headshot']
          @document.data['headshot'].customSize("44x44!")
        end
      end
    end

    def people_join(key)
      # Can we do the things with the thing? Less nil:NilClass errors
      if @document.data.has_key?(key) and @document.data[key]
        return @document.data[key].map{|x| x['name']}.join(', ')
      else
        return ""
      end
    end

    def excerpt
      # For some reason excerpts are out of control (just got a index.json of
      # 1.7GB, crazy). Do some trimming here.
      if @document.data['excerpt']
        @document.data['excerpt'].to_s[0..300]
      else
        ""
      end
    end

    def byline
      case type
      when "shows"
        @document.data['playwright_formatted']
      when "people"
        "#{@document.data['shows_count']} credits"
      end
    end

    def year
      case type
      when "shows"
        @document.data['year_page']['title']
      when "people"
        @document.data['graduated']
      end
    end

    def to_liquid
      {
        'url' => @document.url,
        'title' => @document.data['title'],
        'collection' => type,
        'excerpt' => excerpt,
        'byline' => byline,
        'year' => year,
        'image_thumb' => image_thumb,

        'playwright' => @document.data['playwright'],
        'date_start' => @document.data['date_start'],
        'date_end' => @document.data['date_end'],
        'people' => people_join('cast') + people_join('crew'),

        'forename' => @document.data['forename'],
        'surname' => @document.data['surname'],
        'graduated' => @document.data['graduated'],
      }
    end
  end
end
