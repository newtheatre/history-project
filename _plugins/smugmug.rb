# Smug
# Author: Will Pimblett, October 2015
#
# Base class for SmugAlbum and SmugImage. Fetching SmugMug stuff for Jekyll sites.


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

  def cache_filename(id)
    "#{ cache_dir }/#{ id }.json"
  end

  def cache_fetch(id)
    if File.exist?(cache_filename(id))
      cache_file = File.open(cache_filename(id), "r")
      if cache_file.ctime < cache_invalid_time
        # Delete and do over as cache invalid
        cache_file.close
        File.delete(cache_filename(id))
        return nil
      else
        # Cache valid, use that
        return JSON.load(cache_file)
      end
    else
      return nil
    end
  end

  def cache_save(id, data)
    Dir.mkdir(cache_dir) unless File.directory?(cache_dir)
    File.open(cache_filename(id), "w") do |new_cache_file|
      JSON.dump(data, new_cache_file)
    end
  end

  def api_url(method, parameters=nil)
    if parameters
      "/api/v2/#{ method }?APIKey=#{ api_key }&#{ parameters }"
    else
      "/api/v2/#{ method }?APIKey=#{ api_key }"
    end
  end

end
