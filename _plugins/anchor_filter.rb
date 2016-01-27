require "i18n"
I18n.config.available_locales = :en

# Converts "Eugène Ionesco" -> "eugene-ionesco"
module Jekyll
  module AnchorFilter
    def anchor(input)
      begin
        # Remove accents/diacritics, swap spaces for hyphens, remove specials
        # and downcase input
        I18n.transliterate(input).gsub(" ", "-").gsub(/[^\\dA-Za-z\-]/,"").downcase
      rescue NoMethodError
        # For when we're passed something silly (gsub will fail)
        ""
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::AnchorFilter)
