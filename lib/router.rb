class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    # pattern is something like Regexp.new("^/cats$")
    # req.path is something like '/cats'
    # r = Regexp.new("^/cats$")
    # '/cats' =~ r
    req.request_method.downcase.to_sym == http_method && !!(pattern =~ req.path)
  end

  # use pattern to pull out route params
  # instantiate controller and call controller action
  def run(req, res)
    url_params = {}
    data = pattern.match(req.path)
    data.names.each_with_index do |name, idx|
      url_params[name] = data.captures[idx]
    end
    controller_class.new(req, res, url_params).invoke_action(action_name)
    nil
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  # router.draw do
  #   get Regexp.new("^/cats$"), Cats2Controller, :index
  #   get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
  # end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
    instance_eval(&proc)
  end

  # make each of these methods that
  # when called add route
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # should return the route that matches this request
  def match(req)
    @routes.find {|route| route.matches?(req)}
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
    route = match(req)
    if route
      route.run
    else
      res.status = 404
    end
  end
end
