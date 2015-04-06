require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
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
  end
end
