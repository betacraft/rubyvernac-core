require 'yaml'

module Rubyvernac
  module Translator

    class LanguageCodes

      def find_code(language)
        return available_languages[language]
      end

      private
        def available_languages
          @_available_languages ||= YAML::load_file("lib/available_languages.yml")
          @_available_languages
        end

    end

  end
end
