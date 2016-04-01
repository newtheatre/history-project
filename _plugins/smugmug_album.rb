# SmugAlbum
# Author: Will Pimblett, October 2015
#
# Fetches SmugMug albums for Jekyll sites. We use for production shot galleries.

require_relative 'smugmug'

class SmugAlbum < Smug

  def fetch_album_data(albumID)
    # Given an album id, return the SM album
    Jekyll.logger.info "Fetching SM Album:", "#{ albumID }"
    url = api_url("album/#{ albumID }")
    data = self.class.get(url)
    if data.key? "Response"
      return data["Response"]["Album"]
    else
      Jekyll.logger.error "SM Error:", "Invalid album response"
      return false
    end

  end

  def fetch_album_images(albumID)
    # Given an album id, return the SM objects in that album
    Jekyll.logger.info "Fetching SM Image List:", "#{ albumID }"
    url = api_url("album/#{ albumID }!images", "count=9999")
    data = self.class.get(url)
    if data.key? "Response"
      return data["Response"]["AlbumImage"]
    else
      Jekyll.logger.error "SM Error:", "Invalid album images response"
      puts url
      return false
    end
  end

  def fetch_image_urls(imageIDs, size, sizeClass, sizeParameters=nil)
    # Given a list of image ids, return SM single sized images
    Jekyll.logger.info "Fetching SM Images:", "#{ imageIDs.size } at #{ size }"

    imageIDs_as_parameter = imageIDs.join(',')
    url = api_url("image/#{ imageIDs_as_parameter }!#{ size }", sizeParameters)
    data = self.class.get(url)
    return data["Response"][sizeClass]
  end

  def fetch_album(albumID)
    album_data = fetch_album_data(albumID)
    if not album_data then return false end

    album_images = fetch_album_images(albumID)
    if not album_images then return false end

    if album_data and album_images
      # Create and array of image IDs and fetch their custom sizes
      imageList = Array.new
      album_images.each { |image| imageList.push image["ImageKey"] }
      largeImageURLs = fetch_image_urls(imageList, "sizecustom", "ImageSizeCustom", "height=1000&width=1900")
      thumbImageURLs = fetch_image_urls(imageList, "sizecustom", "ImageSizeCustom", "height=300&width=300")

      # Patch additional attributes into album object
      i = 0
      album_images.collect do |image|
        image["NTHP_Parsed"] = true
        image["LargeImage"] = largeImageURLs.shift
        image["ThumbImage"] = thumbImageURLs.shift
        image["ImageCount"] = i
        i+=1
        image
      end

      # Patch images into album_data
      album_data["Images"] = album_images
      album_data["LastFetched"] = Time.now
      album_data["ImageCount"] = i

      return album_data
    end
  end

  def get_show_photos(albumID)
    # Attempt fetch from cache
    album = cache_fetch(albumID)

    if not album and api_key
      # Not in cache, fetch new and save to cache
      album = fetch_album(albumID)
      if album then cache_save(albumID, album) end
    elsif not album and not api_key
      Jekyll.logger.error "SM Skip:",  "No API key"
    end

    return album
  end

end
