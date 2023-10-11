require_relative "../exceptions/language_not_available_exception"
module Rubyvernac
  module Validators
    class LanguageValidator
      def validate(language)
        raise Rubyvernac::LanguageNotAvailableException.new if !available_languages.key?(language)

        true
      end

      private

      def available_languages
        @_available_languages ||= YAML.load_file(Dir.pwd + "/lib/templates/lib/available_languages.yml")
        @_available_languages
      end
    end
  end
end
