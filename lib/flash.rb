require 'json'

class Flash
  def initialize(req)
    cookie = req.cookies['_rails_lite_app_flash']
    if cookie
      @cookie = JSON.parse(cookie)
    else
      @cookie = {}
    end
  end

  def [](key)
    @cookie[key] || self.now[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def now
    @flash_cookie ||= {}
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash', { path: :/, value: @cookie.to_json} )
  end
end
