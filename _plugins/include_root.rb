module Jekyll
  module Tags
    class IncludeRootTag < IncludeTag
      def resolved_includes_dir(context)
        '.'.freeze
      end
    end
  end
end

Liquid::Template.register_tag('include_root', Jekyll::Tags::IncludeRootTag)
