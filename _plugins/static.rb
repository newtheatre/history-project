# Static files plugin
# Given pre-generated files in the _site directory (by gulp), compute MD5 hashes
# for the href="" for CDN cache-busting.

require 'digest/md5'

module StaticFile
  class StaticTag < Liquid::Tag

    @@file_hashes = Hash.new

    def initialize(tag_name, text, tokens)
      super
      @filename = text.strip
      unless @@file_hashes.has_key? @filename
        @@file_hashes[@filename] = Digest::MD5.hexdigest(File.read("_site/#{@filename}"))
      end
    end

    def render(context)
      "#{@filename}?hash=#{@@file_hashes[@filename]}"
    end
  end
end

Liquid::Template.register_tag('static', StaticFile::StaticTag)
