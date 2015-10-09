require 'httparty'

class Smug
  include HTTParty
  base_uri 'https://smugmug.com'
  headers 'Accept' => 'application/json'

  def api_key
    ENV['SMUGMUG_API_KEY']
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

  def get_show_photos(albumID)
    album = fetch_album_images(albumID)
    if album
      # Create and array of image IDs and fetch their custom sizes
      imageList = Array.new
      album.each { |image| imageList.push image["ImageKey"] }
      imageURLs = fetch_image_urls(imageList, "sizecustom", "ImageSizeCustom", "height=1000&width=1000")

      # Collect additional attributes into album object
      album.collect do |image|
        image["NTHP_Parsed"] = true
        image["LargeImage"] = imageURLs.shift
        image
      end
    end
  end
end