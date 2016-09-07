SNAPSHOT_BASE = "https://archive.is"

module LinkList
  class Link
    # Single link within a link list or link register

    def initialize(site, link_hash, page_ref=nil)
      @link_hash = link_hash
      @site = site
      @page_ref = page_ref

      # Select link type from data path or nil
      @link_type = @site.data['link-types'].select {
        |i| i['type'] == link_hash['type'] }[0]
      @link_type_default = @site.data['link-types'].select {
        |i| i['type'] == "default" }[0]
    end

    def type
      if @link_type['type']
        @link_type['type']
      else
        # TODO feed back into calling Jekyll plugin
        raise 'Missing link type'
      end
    end

    def href
      if @link_type.key?('href')
        @link_type['href'].sub("???", @link_hash['username'])
      else
        @link_hash['href']
      end
    end

    def href_snapshot
      if @link_hash.key?('snapshot')
        "#{SNAPSHOT_BASE}/#{@link_hash['snapshot']}"
      end
    end

    def snapshot
      @link_hash['snapshot']
    end

    def username
      @link_hash['username']
    end

    def title
      if @link_hash.key?('title')
        @link_hash['title']
      else
        @link_hash['type']
      end
    end
    
    def icon
      @link_hash['icon'] || @link_type['icon'] || @link_type_default['icon']
    end

    def data
      @link_hash['data'] || @link_type['data'] || @link_type_default['data']
    end

    def date
      @link_hash['date']
    end

    def stars
      @link_hash['stars']
    end

    def quote
      @link_hash['quote']
    end

    def to_liquid
      {
        'type' => type,
        'href' => href,
        'href_snapshot' => href_snapshot,
        'snapshot' => snapshot,
        'username' => username,
        'title' => title,
        'icon' => icon,
        'data' => data,
        'date' => date,
        'stars' => stars,
        'quote' => quote,
        'comment' => @link_hash['comment'],
        'page' => @page_ref,
      }
    end
  end

  class LinkList
    # List of links

    def initialize(site, linklist)
      @linklist = linklist
      @site = site
      @page_ref = nil
    end

    def links(page_ref=nil)
      @linklist.map do |link|
        link = Link.new(@site, link, page_ref)
        link
      end
    end

    def to_liquid
      links
    end
  end

  class LinkRegister
    # Register for holding all links to external resources for the site

    def initialize
      @link_register = Array.new
    end

    def add_list(list, page_ref)
      # Create LinkList with page refs and push to register array
      list.links(page_ref).each do |link|
        @link_register << link
      end
    end

    def to_liquid
      @link_register
    end
  end
end
