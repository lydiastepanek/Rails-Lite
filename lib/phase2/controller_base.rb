module Phase2
  class ControllerBase
    attr_reader :req, :res

    # Setup the controller
    def initialize(req, res)
      @req = req
      @res = res
    end

    # Helper method to alias @already_built_response
    def already_built_response?
    end

    # Set the response status code and header
    def redirect_to(url)
      raise "already redirected" if already_built_response?
      unless already_built_response?
        res.header["location"] = url
        res.status = 302
      end
      @already_built_response = true
      # "HTTP/1.1 302 Found
      # Location: http://www.iana.org/domains/example/"
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, content_type)
      raise "already rendered" if already_built_response?
      unless already_built_response?
        res.body = content
        res.content_type = content_type
      end
      @already_built_response = true
    end

    def already_built_response?
      @already_built_response ||= false
    end

  end
end
