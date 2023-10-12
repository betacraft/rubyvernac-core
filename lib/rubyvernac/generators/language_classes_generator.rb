require_relative "../utils/file_handler"
require "yaml"

module Rubyvernac
  module Generators
    class LanguageClassesGenerator
      CONFIG = {
        classes: ["Array", "Class", "Object", "Integer", "Math", "Module"],
        methods: {
          public_methods: "cpumethods",
          private_methods: "cprmethods",
          instance_methods: "ipumethods",
          private_instance_methods: "iprmethods"
        }
      }.freeze

      def initialize(language:, gem_path:)
        @file_handler = Rubyvernac::Utils::FileHandler.new
        @translations_path = "#{gem_path}/lib/translations/classes"

        @file_handler.make_dir_if_not_exists(@translations_path)
      end

      def generate_class_files
        CONFIG[:classes].each do |klass|
          klass = eval(klass) # Note: Fixnum -> Integer
          content = {}
          class_name = klass.name.downcase

          # place to keep class's name -
          content[class_name] = content[class_name] || {}
          content[class_name]["cname"] = klass.name

          class_name = klass.name.downcase
          CONFIG[:methods].each do |method, key|
            klass.send(method).sort.each do |method_name|
              content[class_name][key] = content[class_name][key] || {}
              content[class_name][key][method_name.to_s] = method_name.to_s
            end
          end

          translations_path = "#{@translations_path}/#{class_name}.yml"
          @file_handler.append_to_file(translations_path, content.to_yaml)
        end
      end
    end
  end
end
