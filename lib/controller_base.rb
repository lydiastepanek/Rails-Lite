require_relative 'session'
require_relative 'params'
require_relative 'router'
require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = Params.new(@req, route_params)
  end

  def session
    @session ||= Session.new(req)
  end

  def redirect_to(url)
    raise "already redirected" if already_built_response?
    unless already_built_response?
      res.header["location"] = url
      res.status = 302
    end
    @already_built_response = true
    session.store_session(res)
    # "HTTP/1.1 302 Found
    # Location: http://www.iana.org/domains/example/"
  end

  def render_content(content, content_type)
    raise "already rendered" if already_built_response?
    unless already_built_response?
      res.body = content
      res.content_type = content_type
    end
    @already_built_response = true
    session.store_session(res)
  end

  def already_built_response?
    @already_built_response ||= false
  end

  def render(template_name)
    raise "already rendered" if already_built_response?
    template_file = "views/#{self.class.to_s.underscore}/#{template_name.to_s}.html.erb"
    contents = File.read(template_file)
    unless already_built_response?
      res.body = ERB.new(contents).result(binding)
      res.content_type = "text/html"
    end
    @already_built_response = true
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?
  end

end
