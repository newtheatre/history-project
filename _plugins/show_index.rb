module Jekyll
  class ShowIndexTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      site = context.registers[:site]
      ret = ""
      site.collections[:shows].docs.each do |show|
        ret << show.title
      end
      "#{ret}"
    end
  end
end

Liquid::Template.register_tag('show_index', Jekyll::ShowIndexTag)
