SNAPSHOT_BASE = "https://archive.is"

module LinkList
  class Link
    # Single link within a link list or link register

    def initialize(site, link_hash, page_ref=nil)
      @link_hash = link_hash
      @site = site
      @page_ref = page_ref

      # Select link type from data path or fallback on default
      @link_type = @site.data['link-types'].select {
        |i| i['type'] == link_hash['type'] }[0]
      if @link_type.nil?
        @link_type = @site.data['link-types'].select {
          |i| i['type'] == "default" }[0]
      end
    end

    def type
      # Returns the string type of the link
      if @link_hash.key?('type')
        @link_hash['type']
      else
        # TODO feed back into calling Jekyll plugin
        Jekyll.logger.abort_with("Missing key type in link <#{href_source}> on page #{@page_ref.relative_path}.")
      end
    end

    def href_source
      if not @link_hash.key?('href')
        Jekyll.logger.abort_with("Missing key href in link on page #{@page_ref.relative_path}.")
      end
      @link_hash['href']
    end

    def href
      if @link_type and @link_type.key?('href')
        if not username
          Jekyll.logger.abort_with("Missing key username in link on page #{@page_ref.relative_path}, type has href template.")
        end
        @link_type['href'].sub("???", username)
      else
        href_source
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

    def publisher
      if @link_type.fetch('is_news', false) and not @link_hash.key?('publisher')
        Jekyll.logger.abort_with("Missing key publisher for link <#{href_source}> on page #{@page_ref.relative_path}, type #{type} is a news type.")
      end
      @link_hash['publisher']
    end

    def icon
      @link_hash['icon'] || @link_type['icon']
    end

    def data
      @link_hash['data'] || @link_type['data']
    end

    def date
      @link_hash['date']
    end

    def stars
      # TODO remove, see #843
      @link_hash['stars']
    end

    def rating
      @link_hash['rating']
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
        'publisher' => publisher,
        'icon' => icon,
        'data' => data,
        'date' => date,
        'stars' => stars,
        'rating' => rating,
        'quote' => quote,
        'comment' => @link_hash['comment'],
        'page' => @page_ref,
      }
    end
  end

  class LinkList
    # List of links

    def initialize(site, raw_list, page_ref)
      @raw_list = raw_list
      @site = site
      @page_ref = page_ref
    end

    def links
      @raw_list.map do |link|
        link = Link.new(@site, link, @page_ref)
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

    def add_list(list)
      # Add a LinkList to the register
      list.links.each do |link|
        @link_register << link
      end
    end

    def to_liquid
      @link_register
    end
  end
end
