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

  # Cache timings
  MIN_INVALID_WEEKS = 4
  MAX_INVALID_WEEKS = 12

  def api_key
    ENV['SMUGMUG_API_KEY']
  end

  def cache_dir
    "_smugmug_cache"
  end

  def cache_invalid_time
    x = MIN_INVALID_WEEKS
    y = MAX_INVALID_WEEKS - MIN_INVALID_WEEKS
    # Time now, minus x to x+y weeks
    # We compare the cache file ctime to this
    #            s  m  h  days
    ( Time.now - ( 60*60*24*7*x ) - rand( 60*60*24*7*y ) ).to_i
  end

  def cache_filename(id)
    "#{ cache_dir }/#{ id }.json"
  end


  def cache_fetch(id)
    if File.exist?(cache_filename(id))
      cache_file = File.open(cache_filename(id), "r")
      cache_data = JSON.load(cache_file)
      cache_file.close

      if (not cache_data.key? "FetchTime" or
        cache_data["FetchTime"] < cache_invalid_time) and api_key and
        not ENV['SMUGMUG_CACHE_MAINTAIN']
        # Delete and do over as cache invalid
        Jekyll.logger.warn("SM cache invalidated:", "Refreshing #{id}")
        File.delete(cache_filename(id))
        return nil
      else
        # Cache valid, use that
        return cache_data
      end
    else
      return nil
    end
  end

  def cache_save(id, data)
    # Set fetch time for later cache invalidation checks
    data["FetchTime"] = Time.now.to_i
    # Create cache_dir and dump data as JSON
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
