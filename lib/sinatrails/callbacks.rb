module Sinatrails
  module Callbacks
    class Callback < Struct.new(:method, :only, :except)
      def match? action
        return false if !only.nil? && !only.include?(action)
        return false if !except.nil? && except.include?(action)
  
        true
      end
    end

    def self.included base
      base.extend ClassMethods
    end

    def self.get_callbacks name
      []
    end

    module ClassMethods
      def init_callbacks
        @callbacks ||= Hash.new { |h,k| h[k] = [] }
      end

      def set_callback name, method, opt
        init_callbacks
        @callbacks[name] << Callback.new(method, opt[:only], opt[:except])
      end

      def get_callbacks name
        init_callbacks
        @callbacks.fetch(name, [])
      end

      def ancestors_with_callbacks
        self.ancestors.select { |a| a.respond_to? :get_callbacks }
      end

      def callbacks_for action, name
        ancestors_with_callbacks.
          flat_map { |a| a.get_callbacks(name) }.
          select { |c| c.match? action }.
          map(&:method)
      end
    end
  end
end
