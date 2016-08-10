require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @already_built_response = false
    @params = req.params.merge(route_params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Cannot render twice!" if already_built_response?
    @res.location = url
    @res.status = 302
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Cannot render twice!" if already_built_response?
    @res.set_header('Content-Type', content_type)
    @res.write(content)
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    name = template_name.to_s
    controller_name = self.class.to_s.underscore
    path = "views/#{controller_name}/#{name}.html.erb"
    file_content = File.read(path)
    content = ERB.new(file_content).result(binding)
    render_content(content, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end


  def invoke_action(name)
    send(name)
    unless @already_built_response
      render(name)
    end
  end
end
