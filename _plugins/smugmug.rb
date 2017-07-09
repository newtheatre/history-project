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
    "tmp/smugmug"
  end

  def min_invalid_time
    # return the minimum number of seconds that a cached item can stay cached
    if ENV['TRAVIS_EVENT_TYPE'] == 'cron'
      days = 1
    else
      days = 14
    end
    return days * 24 * 60 * 60
  end

  def max_invalid_time
    # return the maximum number of seconds that a cached item can stay cached
    if ENV['TRAVIS_EVENT_TYPE'] == 'cron'
      days = 6
    else
      days = 42
    end
    return days * 24 * 60 * 60
  end

  def cache_invalid_time
    # Time now, minus x to x+y weeks
    # We compare the cache file fetch time to this
    ( Time.now - min_invalid_time - rand(max_invalid_time - min_invalid_time)).to_i
  end

  def cache_filename(id)
    "#{ cache_dir }/#{ id }.json"
  end


  def cache_fetch(id)
    if File.exist?(cache_filename(id))
      cache_file = File.open(cache_filename(id), "r")
      cache_data = JSON.load(cache_file)
      cache_file.close


      if (not cache_data.key? "FetchTime" or cache_data["FetchTime"] < cache_invalid_time) and
        api_key and not ENV['SMUGMUG_CACHE_MAINTAIN']
        # Delete and do over as cache invalid
        age = (Time.now - cache_data["FetchTime"]).to_i / (3600 * 24)
        Jekyll.logger.warn("SM cache invalidated:", "Refreshing #{id}, was #{age} days old")
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
