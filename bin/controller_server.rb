require 'webrick'
require_relative '../lib/controller_base'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

class MyController < ControllerBase
  def go
    if @req.path == "/cats"
      render_content("hello cats!", "text/html")
    else
      redirect_to("/cats")
    end
  end
end
#this method

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  MyController.new(req, res).go
end
#this takes the req and res calls the go method on and instance of
#MyController (which was created taking them as inputs) to create a response

trap('INT') { server.shutdown }
server.start
