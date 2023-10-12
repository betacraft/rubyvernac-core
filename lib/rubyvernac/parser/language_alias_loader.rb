require "yaml"

module Rubyvernac
  module Parser
    class LanguageAliasLoader
      def create_aliases(translations_path)
        Dir.glob(translations_path + "/*.yml").each do |filepath|
          content = YAML.load_file(File.expand_path(filepath.to_s))
          class_name = content.keys[0].capitalize

          # class name -
          # class_trans = content[content.keys.first]['cname']
          # Object.class_eval(" #{class_trans} = #{class_name} ") unless class_trans.length.zero?

          # class methods -
          content.first.last["cpumethods"].each do |k, v|
            alias_class_method(class_name, k, v) unless v.chop.length.zero?
          end

          content.first.last["cprmethods"].each do |k, v|
            alias_class_method(class_name, k, v) unless v.chop.length.zero?
          end

          # instance methods -
          content.first.last["ipumethods"]&.each do |k, v|
            alias_instance_method(class_name, k, v) unless v.chop.length.zero?
          end

          # instance methods -
          content.first.last["iprmethods"]&.each do |k, v|
            next if [:respond_to_missing?, :method_missing].include?(k.to_sym)
            alias_instance_method(class_name, k, v) unless v.chop.length.zero?
          end
        end
      end

      private

      def alias_class_method(class_name, orig_name, alias_name)
        klass = Object.class_eval(class_name)
        singleton_klass = klass.singleton_class

        singleton_klass.send(:alias_method, alias_name, orig_name)
      end

      def alias_instance_method(class_name, orig_name, alias_name)
        klass = Object.class_eval(class_name)

        klass.send(:alias_method, alias_name, orig_name)
      end
    end
  end
end
