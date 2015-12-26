# encoding: UTF-8

module Jekyll
  module Drops
    class ImmutableDrop < Liquid::Drop
      IllegalDropModification = Class.new(Jekyll::StandardError)

      NON_CONTENT_METHODS = [:[], :[]=, :inspect, :to_h, :fallback_data].freeze

      def initialize(obj)
        @obj = obj
      end

      def [](key)
        if respond_to? key
          public_send key
        else
          fallback_data[key]
        end
      end

      def []=(key, val)
        if respond_to? key
          raise IllegalDropModification.new("Key #{key} cannot be set in the drop.")
        else
          fallback_data[key] = val
        end
      end

      def to_h
        [
          self.class.instance_methods(false) - NON_CONTENT_METHODS,
          fallback_data.keys
        ].flatten.inject({}) do |result, key|
          result[key] = self[key]
          result
        end
      end
      alias_method :inspect, :to_h

    end
  end
end
