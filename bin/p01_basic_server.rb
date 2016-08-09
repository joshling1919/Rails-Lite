require 'rack'
app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  text = req.path
  res.write("#{req.path}")
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
