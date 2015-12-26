# encoding: UTF-8

module Jekyll
  module Drops
    class MutableDrop < Liquid::Drop
      NON_CONTENT_METHODS = [:[], :[]=, :inspect, :to_h, :fallback_data].freeze

      def initialize(obj)
        @obj = obj
        @mutations = {}
      end

      def [](key)
        if @mutations.key? key
          @mutations[key]
        elsif respond_to? key
          public_send key
        else
          fallback_data[key]
        end
      end

      def []=(key, val)
        @mutations[key] = val
      end

      def to_h
        [
          self.class.instance_methods(false) - NON_CONTENT_METHODS,
          @mutations.keys,
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
