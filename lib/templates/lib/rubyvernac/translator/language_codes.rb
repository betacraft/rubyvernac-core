require 'yaml'
require_relative '../exceptions/language_not_available_exception'

module Rubyvernac
  module Translator

    class LanguageCodes

      def find_code(language)
        if available_languages.key?(language)
          return available_languages[language]
        else
          raise Rubyvernac::LanguageNotAvailableException.new
        end
      end

      private
        def available_languages
          @_available_languages ||= YAML::load_file("lib/available_languages.yml")
          @_available_languages
        end

    end

  end
end
