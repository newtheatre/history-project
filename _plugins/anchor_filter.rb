require "i18n"
I18n.config.available_locales = :en

# Converts "Eugène Ionesco" -> "eugene-ionesco"
module Jekyll
  module AnchorFilter
    def anchor(input)
      begin
        # Remove accents/diacritics
        I18n.transliterate(input).gsub(/[ ]/, "-").downcase
      rescue NoMethodError
        # For when we're passed something silly (gsub will fail)
        ""
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::AnchorFilter)
