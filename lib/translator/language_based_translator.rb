require 'yaml'

module Translator
  class LanguageBasedTranslator
    CONFIG = {
      classes: ["Array", "Class", "Object", "Integer", "Math"],
      methods: {
        public_methods: 'cpumethods',
        private_methods: 'cprmethods',
        instance_methods: 'ipumethods',
        private_instance_methods: 'iprmethods'
      }
    }.freeze

    def initialize(lang_code: , dir_path:)
      @google_translator = GoogleTranslatorApi.new(lang_code)
      @dir_path = dir_path
    end

    def generate_translations
      CONFIG[:classes].each do |klass|
        klass = eval(klass) # Note: Fixnum -> Integer
        content = Hash.new

        # place to keep class's name -
        content[klass.name.downcase] = content[klass.name.downcase] || {}
        content[klass.name.downcase]['cname'] = @google_translator.translate(klass.name)

        CONFIG[:methods].each do |method, key|
          class_name.send(method).sort.each do |method_name|
            content[class_name.name.downcase][key] = content[class_name.name.downcase]['cprmethods'] || {}

            content[class_name.name.downcase][key][method_name.to_s] =
              @google_translator.translate(method_name.to_s)
          end
        end

        append_to_output_file
      end
    end

    private

      def append_to_output_file(content)
        File.open(output_file, 'w+') do |f|
          f.write( content.to_yaml )
        end
      end

      def output_file
        File.expand_path("#{dir_path}/#{class_name.name.downcase}.yml")
      end

  end
end
