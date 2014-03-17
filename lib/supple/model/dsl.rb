module Supple
  module DSL
    class Mapping
      def initialize(data = {}, &block)
        @data = data
        @data[property_key] ||= {}
        instance_eval(&block) if block_given?
      end

      def prop(name, options = {}, &block)
        if block_given?
          @data[property_key][name] = Mapping.new(options).instance_eval(&block).to_hash
        end
        @data[property_key][name] = options
      end

      def dynamic_template(name, &block)
        @data[:dynamic_templates] ||= []
        dt = DynamicTemplate.new(name, &block)
        @data[:dynamic_templates] << dt.to_hash
      end

      def to_hash
        @data
      end

      private

      def property_key
        @data[:type].to_s == 'multi_field' ? :fields : :properties
      end
    end

    class DynamicTemplate
      def initialize(name, options = {}, &block)
        @name = name
        @options = options
        @data = {}
        instance_eval(&block) if block_given?
      end

      [:match, :unmatch, :match_mapping_type, :path_match, :path_unmatch, :match_pattern].each do |meth|
        define_method(meth) do |val|
          @data[meth] = val
        end
      end
      def mapping(data = {}, &block)
        mapping = Mapping.new(data)
        mapping.instance_eval(&block) if block_given?
        @data[:mapping] = mapping.to_hash
      end

      def to_hash
        @options[@name] = @data
        @options
      end
    end
  end
end
