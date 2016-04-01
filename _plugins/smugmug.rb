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

end
