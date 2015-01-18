module Sinatrails
  class Router < Struct.new(:sinatra)
    def add_route method, path, target
      controller, action = target.split '#'
  
      action = action.to_sym
      controller = (controller.camelize + 'Controller').constantize
  
      sinatra.send method, path do
        controller.new(params, request, headers).execute action
      end
    end
  
    [:get, :post, :put, :patch, :delete].each do |method|
      define_method method do |path, target|
        add_route method, path, target
      end
    end
  end
end
