require_relative 'template_generator'

class LanguageGemGenerator
  attr_reader :language, :author_name, :author_email

  def initialize(language: "", author_name: "", author_email: "")
    @language = language.downcase

    @author_name = author_name
    @author_email = author_email

    @template_generator = TemplateGenerator.new(language: @language)
  end


  def generate
    @template_generator.generate_gem_files

    print "\n The new gem can be found in 'new_gems' folder\n"
    # FileUtils.mv('/tmp/your_file', '/opt/new/location/your_file') # To move the output folder
  rescue LanguageNotAvailableException => e
    puts e.message
  end

end
