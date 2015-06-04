module Jekyll
  module Tags
    class IncludeRootTag < IncludeTag
      def tag_includes_dir
        '.'.freeze
      end
    end
  end
end

Liquid::Template.register_tag('include_root', Jekyll::Tags::IncludeRootTag)
