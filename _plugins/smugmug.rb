require 'httparty'

class Smug
  include HTTParty
  base_uri 'https://smugmug.com'
  headers 'Accept' => 'application/json'
  default_timeout 20

  def api_key
    ENV['SMUGMUG_API_KEY']
  end

  def cache_dir
    "_smugmug_cache"
  end

  def cache_invalid_time
    # Time now, minus some seconds
    # We compare the cache file ctime to this
    #            s  m  h  days
    Time.new - ( 60*60*24*14 )
  end

  def api_url(method, parameters=nil)
    if parameters
      "/api/v2/#{ method }?APIKey=#{ api_key }&#{ parameters }"
    else
      "/api/v2/#{ method }?APIKey=#{ api_key }"
    end
  end

  def fetch_album_images(albumID)
    # Given an album id, return the SM objects in that album
    puts "Fetching SmugMug album #{ albumID }"
    url = api_url("album/#{ albumID }!images")
    data = self.class.get(url)
    if data.has_key? "Response"
      return data["Response"]["AlbumImage"]
    else
      puts "Error: Invalid SmugMug Response"
      return false
    end
  end

  def fetch_image_urls(imageIDs, size, sizeClass, sizeParameters=nil)
    # Given a list of image ids, return SM single sized images
    puts "Fetching SmugMug image #{ imageIDs } #{ size }"

    imageIDs_as_parameter = imageIDs.join(',')
    url = api_url("image/#{ imageIDs_as_parameter }!#{ size }", sizeParameters)
    data = self.class.get(url)
    return data["Response"][sizeClass]
  end

  def fetch_show_photos(albumID)
    album = fetch_album_images(albumID)
    if album
      # Create and array of image IDs and fetch their custom sizes
      imageList = Array.new
      album.each { |image| imageList.push image["ImageKey"] }
      largeImageURLs = fetch_image_urls(imageList, "sizecustom", "ImageSizeCustom", "height=1000&width=1000")
      thumbImageURLs = fetch_image_urls(imageList, "sizecustom", "ImageSizeCustom", "height=300&width=300")

      # Collect additional attributes into album object
      album.collect do |image|
        image["NTHP_Parsed"] = true
        image["LargeImage"] = largeImageURLs.shift
        image["ThumbImage"] = thumbImageURLs.shift
        image
      end
    end
  end

  def get_show_photos(albumID)
    fn = "#{ cache_dir }/#{ albumID }.json"
    album = nil

    if File.exists?(fn)
      # Album cached, load that
      puts "Loading album #{ albumID } from local cache"
      cache_file = File.open(fn, "r")

      if cache_file.ctime < cache_invalid_time
        # Delete and do over as cache invalid
        cache_file.close
        File.delete(fn)
        return get_show_photos(albumID)
      else
        # Cache valid, use that
        album = JSON.load(cache_file)
      end

    else
      # No cache, do properly
      album = fetch_show_photos(albumID)

      Dir.mkdir(cache_dir) unless File.directory?(cache_dir)
      File.open(fn, "w") do |cache_file|
        JSON.dump(album, cache_file)
      end
    end

    return album
  end
end
