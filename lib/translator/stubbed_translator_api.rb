require "google/cloud/translate/v3"
require 'dotenv/load'

module Translator
  class StubbedTranslatorApi

    def translate(word)
      translation_mappings[word]
    end

    def translation_mappings
      @translation_mappings ||= build_translation_mappings
    end

    def build_translation_mappings
      mappings = {}
      Dir.children('lib/stubs').each do |file|
        stub = YAML.load_file("lib/stubs/#{file}")

        klass = file.split('.')[0]
        stub[klass].keys.each do |key|
          next if key == 'cname'
          mappings.merge!(stub[klass][key])
        end
      end

      mappings
    end

  end
end
