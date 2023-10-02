require 'yaml'

require_relative 'google_translator_api'
require_relative '../utils/file_handler'

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

    def initialize(lang_code: , translations_path:)
      @lang_code = lang_code
      @translations_path = translations_path

      @google_translator = GoogleTranslatorApi.instance
    end

    def generate_translations
      CONFIG[:classes].each do |klass|
        klass = eval(klass) # Note: Fixnum -> Integer
        content = Hash.new

        # place to keep class's name -
        content[klass.name.downcase] = content[klass.name.downcase] || {}
        content[klass.name.downcase]['cname'] = @google_translator.translate(klass.name, @lang_code)

        CONFIG[:methods].each do |method, key|
          klass.send(method).sort.each do |method_name|
            class_name = klass.name.downcase

            content[class_name][key] = content[class_name][key] || {}
            content[class_name][key][method_name.to_s] = @google_translator.translate(method_name.to_s, @lang_code)
          end
        end

        @file_handler.append_to_file("#{@translations_path}/#{class_name}.yml", content)
      end
    end

  end
end
