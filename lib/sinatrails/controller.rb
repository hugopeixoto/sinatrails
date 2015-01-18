require "sinatrails/callbacks"

module Sinatrails
  class Controller
    include Sinatrails::Callbacks

    def self.before_filter method, opt = {}
      set_callback 'before', method, opt
    end

    class Headers < Struct.new(:request)
      def [] key
        request.env["HTTP_" + key.underscore.upcase]
      end
    end

    attr_accessor :params, :request
    def initialize p,r,h
      self.params = p
      self.request = r

      class << self.request; self; end.send :define_method, :headers do
        @H ||= Headers.new(self)
      end
    end

    def render opts=nil
      @response ||= if opts.respond_to? :keys
        [Rack::Utils.status_code(opts[:status] || :ok), opts[:json].to_json]
      else
        opts.to_s
      end
    end

    def execute_until_someone_renders chain
      chain.each do |action|
        self.send action
        break if defined? @response
      end
    end

    def execute method
      chain = self.class.callbacks_for(method, 'before') + [method]

      execute_until_someone_renders chain

      @response
    end
  end
end


