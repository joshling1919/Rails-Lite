require 'json'

class Flash
  attr_reader :now
  def initialize(req)
    @now = {}
    cookie = req.cookies['_rails_lite_app_flash']
    if cookie
      all_cookies = JSON.parse(cookie)
      all_cookies.each do |key, value|
        @now[key] = value
      end
    end
    @flash = {}
  end

  def [](key)
    @now[key.to_s] || @flash[key]
  end

  def []=(key, val)
    @flash[key] = val
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash', { path: :/, value: @flash.to_json} )
  end
end
