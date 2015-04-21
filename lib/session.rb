require 'json'
require 'webrick'

class Session
  def initialize(req)
    @session = Hash.new
    rails_cookie = req.cookies.find { |cookie| cookie.name == "_rails_lite_app"}
    @session = JSON.parse(rails_cookie.value) if rails_cookie
  end

  def [](key)
    @session[key.to_s]
  end

  def []=(key, val)
    @session[key.to_sym] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    @cookie = WEBrick::Cookie.new('_rails_lite_app', @session.to_json)
    res.cookies << @cookie
  end
end
