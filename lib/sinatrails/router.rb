module Sinatrails
  class Router < Struct.new(:sinatra)
    def add_route method, path, target, opts = {}
      controller, action = target.split '#'
  
      action = action.to_sym
      controller = (controller.camelize + 'Controller').constantize

      defaults = opts.fetch(:defaults, {})
  
      sinatra.send method, path do
        params.merge! indifferent_params(defaults)
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
