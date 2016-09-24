# SmugImage
# Author: Will Pimblett, March 2016
#
# Get a single SM image in many sizes with liquid support

require_relative 'smugmug'

Struct.new("CustomSize", :name, :size)

class SmugImage < Smug

  # See http://help.smugmug.com/customer/portal/articles/93250
  SIZES = [
    'ImageSizeTiny',
    'ImageSizeThumb',
    'ImageSizeSmall',
    'ImageSizeMedium',
    'ImageSizeLarge',
    'ImageSizeXLarge',
    'ImageSizeX2Large',
    'ImageSizeX3Large',
    'ImageSizeOriginal',
  ]

  CUSTOM_SIZES = [
    Struct::CustomSize.new("poster_thumb", "33x44!"),
    Struct::CustomSize.new("poster_thumb_1", "33x44!"),
    Struct::CustomSize.new("poster_thumb_2", "66x88!"),
    Struct::CustomSize.new("poster_thumb_3", "99x132!"),

    Struct::CustomSize.new("poster_search", "128x162"),
    Struct::CustomSize.new("poster_grid", "200x282!"),
    Struct::CustomSize.new("poster_large", "440x622"),

    Struct::CustomSize.new("person_list", "41x41!"),
    Struct::CustomSize.new("person_bio", "160x160!"),
    Struct::CustomSize.new("person_search", "140x140!"),
  ]

  def initialize(imageID)
    @imageID = imageID
    imageSizeDetails # Prefetch data
  end

  def fetchImageSizeDetails
    # Fetch ISD from API
    Jekyll.logger.info "Fetching SM image:", "#{ @imageID }, many sizes"
    url = api_url("image/#{ @imageID }!sizedetails")
    data = self.class.get(url)
    if data.key? "Response" and data["Response"].key? "ImageSizeDetails"
      return data["Response"]["ImageSizeDetails"]
    else
      Jekyll.logger.error "SM error:", "Invalid ImageSizeDetails response"
    end
  end

  def getImageSizeDetails
    # Attempt fetch from cache
    isd = cache_fetch(@imageID)

    if not isd and api_key
      # Not in cache, fetch new and save to cache
      isd = fetchImageSizeDetails
      if isd then cache_save(@imageID, isd) end
    elsif not isd and not api_key
      Jekyll.logger.error "Skipping SM fetch:",  "No API key"
    end

    return isd
  end

  def imageSizeDetails
    @isd ||= getImageSizeDetails
  end

  def getSize(size)
    if imageSizeDetails.key? size
      imageSizeDetails[size]["Url"]
    else
      getSize(SIZES[SIZES.index(size) - 1])
    end
  end

  def customSize(size)
    imageSizeDetails["ImageUrlTemplate"].gsub("\#size\#", size)
  end

  def to_liquid
    if @isd
      h = {
        "key" => @imageID,
        # SM named sizes aren't really used
        "tiny" => getSize("ImageSizeTiny"),
        "thumb" => getSize("ImageSizeThumb"),
        "small" => getSize("ImageSizeSmall"),
        "medium" => getSize("ImageSizeMedium"),
        "large" => getSize("ImageSizeLarge"),
        "xlarge" => getSize("ImageSizeXLarge"),
        "x2large" => getSize("ImageSizeX2Large"),
        "x3large" => getSize("ImageSizeX3Large"),
        "original" => getSize("ImageSizeOriginal"),
      }
      
      # Add all our custom sizes
      for size in CUSTOM_SIZES
        h[size.name] = customSize(size.size)
      end

      return h
    else
      return nil
    end
  end

end
