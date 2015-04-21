# Rails Lite

## About

* A HTTP web server modeled after Ruby on Rails
* Conducted to understand the inner workings of Rails
* Created using a simple WEBrick web-server and Ruby metaprogramming

## How to Use
* Initialize a new router and a new server object (see bin/router_server.rb for reference)
* Router#draw and Router#run are the main methods you will need
* The #draw method takes inputs of pattern, controller_class, and action_name to create the route for a certain HTTP request
* The #run method sets the HTTP response body and content type according to inputs

## Interesting Features

* Uses ERB templating and binding to set response body
* Uses ActiveSupport::underscore to convert controller names into valid file paths
* Uses URI::decode_www_form to convert the server request query string and body into array formats that can be stored in a params hash

## Libraries Used
* ActiveSupport
* URI
