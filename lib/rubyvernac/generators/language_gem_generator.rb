require_relative 'template_generator'
require_relative 'language_classes_generator'
require_relative '../validators/language_validator'

module Rubyvernac
  module Generators

    class LanguageGemGenerator
      attr_reader :language, :author_name, :author_email

      def initialize(language: "", author_name: "", author_email: "", validator: Rubyvernac::Validators::LanguageValidator.new)
        @language = language.downcase

        @author_name = author_name
        @author_email = author_email

        @validator = validator

        gem_path = Dir.pwd + "/new_gems/rubyvernac-#{language}"
        @template_generator = Rubyvernac::Generators::TemplateGenerator.new(language: @language, gem_path: gem_path)
        @language_classes_generator = Rubyvernac::Generators::LanguageClassesGenerator.new(language: @language, gem_path: gem_path)
      end


      def generate
        @validator.validate(@language)

        @template_generator.generate_gem_files
        @language_classes_generator.generate_class_files

        print "\n The new gem can be found in 'new_gems' folder\n"
        # FileUtils.mv('/tmp/your_file', '/opt/new/location/your_file') # To move the output folder
      end

    end

  end
end
