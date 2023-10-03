require_relative '../translator/main'
require_relative 'language_codes'
require_relative 'template_generator'
require_relative '../exceptions/language_not_available_exception'

class LanguageGemGenerator
  attr_reader :language, :author_name, :author_email

  def initialize(language: "", author_name: "", author_email: "")
    @language = language.downcase

    @author_name = author_name
    @author_email = author_email

    @language_codes = LanguageCodes.new
    @template_generator = TemplateGenerator.new(language: @language)
  end


  def generate
    lang_code = @language_codes.find_code(language)

    @template_generator.generate_gem_files

    translator = Translator::Main.new(language: language, lang_code: lang_code)
    translator.generate_translations

    print "\n The new gem can be found in 'new_gems' folder\n"
    # FileUtils.mv('/tmp/your_file', '/opt/new/location/your_file') # To move the output folder
  rescue LanguageNotAvailableException => e
    puts e.message
  end

end
