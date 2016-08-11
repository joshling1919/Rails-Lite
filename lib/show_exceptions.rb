require 'erb'
require 'byebug'

class ShowExceptions
  attr_reader :app
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      app.call(env)
    rescue RuntimeError => e
      res = Rack::Response.new
      res.status = 500
      res['Content-type'] = "text/html"
      res.write(render_exception(e))
      res.finish
    end
  end

  private

  def render_exception(e)
    @exception = e
    @backtrace = e.backtrace
    match = /(.*?)\:/.match(@backtrace.join)
    @source_code = File.binread(match[1]).to_s
    file_content = File.read("lib/templates/rescue.html.erb")
    content = ERB.new(file_content).result(binding)
  end

end
