require 'rubygems'
require 'httparty'

class TyntClient
  include HTTParty
  base_uri "http://api.tynt.com/v1"
  format :json

  class TyntApiError < RuntimeError; end
  class TyntAuthenticationError < TyntApiError; end

  def initialize(tynt_appid)
    @cookies = {:appid => tynt_appid}
    self.class.cookies @cookies
  end

  def initialize(tynt_api_host, tynt_appid)
    self.class.base_uri "http://#{tynt_api_host}/v1"
    @cookies = {:appid => tynt_appid}
    self.class.cookies @cookies
  end

  def top_categories
    categories = open("/top")
    if categories.nil?
      return nil
    else
      return categories['categories']
    end
  end
  
  def top_pages_for_category(category)
    if category.is_a?(String)
      category_name = category
    else
      category_name = category['name']
    end
    return open("/top/#{category_name}/pages");
  end

  def top_images_for_category(category)
    if category.is_a?(String)
      category_name = category
    else
      category_name = category['name']
    end
    return open("/top/#{category_name}/images");
  end

  def top_terms_for_category(category)
    if category.is_a?(String)
      category_name = category
    else
      category_name = category['name']
    end
    return open("/top/#{category_name}/terms");
  end

  private
  def open(url)
    #puts "Open: " + self.class.default_options[:base_uri] + url
    response = self.class.get(url)
    check_for_error(response)
    return response
  end

  private
  def check_for_error(response)
    raise TyntApiError unless response.headers['content-type'] == "application/json"
    if response["error"]
      if response["error"]["code"] == "401"
        raise TyntAuthenticationError
      else
        raise TyntApiError
      end
    end
  end

end