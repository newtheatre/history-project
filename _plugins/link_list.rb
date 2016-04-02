module Jekyll
  class LinkListTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super
      @link_hash = markup.strip
    end

    def single_get_href(link)
      # Used several times so spun out here
      if not link.key?('href') then Jekyll.logger.abort_with(
        "Link list:", "Missing href in #{@page['path']}") end
      return link['href']
    end

    def single_link(link)
      # Some sanity checks and useful exceptions
      if not link.key?('type') then Jekyll.logger.abort_with(
        "Link list:", "Missing type in #{@page['path']}") end

      # Select link type from data path or nil
      link_type = @site.data['link-types'].select {
        |i| i['type'] == link['type'] }[0]
      link_type_default = @site.data['link-types'].select {
        |i| i['type'] == "default" }[0]

      # Defaults
      title = link['type']
      icon = link_type_default['icon']
      data = ""
      if link.key?('comment') then comment = link['comment']
      else comment = nil end

      # If title, use
      if link.key?('title') then title = link['title'] end

      # Apply link type stuff
      if link_type
        if link_type.key?('icon') then icon = link_type['icon'] end
        if link_type.key?('data') then data = link_type['data'] end
        if link_type.key?('href')
          if not link.key?('username') then Jekyll.logger.abort_with(
            "Link list:", "Missing username in #{@page['path']}") end
          href = link_type['href'].sub("???", link['username'])
        else
          href = single_get_href(link)
        end
      else
        href = single_get_href(link)
      end

      """<dt class=\"single-line\">
           <i class=\"fa fa-fw #{icon}\"></i>
           <a href=\"#{href}\" #{data}>#{title}</a>
           <span class=\"debug debug-hidden-content\" data-debug-toggle>#{comment}</span>
         </dt>
         <dd class=\"hidden\">#{href}</dd>\n"""
    end

    def render(context)
      @site = context.registers[:site]
      @page = context.environments.first['page']

      if @page.key?(@link_hash)
        links = @page[@link_hash]
        return links.collect { |link| single_link(link) }
      else
        return nil
      end
    end
  end
end

Liquid::Template.register_tag('link_list', Jekyll::LinkListTag)
