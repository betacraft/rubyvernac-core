require 'pry-nav'
require "fileutils"

require_relative '../translator/main'
require_relative 'language_codes'
require_relative '../exceptions/language_not_available_exception'

class LanguageGemGenerator
  attr_reader :language, :author_name, :author_email

  def initialize(language: "", author_name: "", author_email: "")
    @language = language.downcase
    @author_name = author_name
    @author_email = author_email

    @language_codes = LanguageCodes.new
  end


  def generate
    lang_code = @language_codes.find_code(language)

    generate_files

    translator = Translator::Main.new(language: language, lang_code: lang_code)
    translator.generate_translations

    print "\n The new gem can be found in 'new_gems' folder\n"
    # FileUtils.mv('/tmp/your_file', '/opt/new/location/your_file') # To move the output folder
  rescue LanguageNotAvailableException => e
    puts e.message
  end

  private

  def generate_files
    dir_path = Dir.pwd + "/new_gems/rubyvernac-#{language}"
    FileUtils::mkdir_p dir_path if !Dir.exist? dir_path
    Dir.glob(File.expand_path('lib/templates/**/**')).each do |file_path|
      next if !File.file?(file_path)
      file = File.open(file_path)
      file_name = update_lang(
                    file_path
                     .gsub(".txt", "")
                     .gsub(".text", ".txt")
                     .gsub("_hidden_", "")
                     .gsub(File.expand_path('lib/templates/'), "")
                  )
      content = update_lang(file.read)
      new_file_path = "#{dir_path}#{file_name}"
      dirname = File.dirname(new_file_path)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
      new_file = File.open(new_file_path, "w") {|f| f.write(content) }
    end
    `chmod a+x "#{dir_path}"/bin/ruby_#{language}`
    Dir.chdir(dir_path) do
      `git init`
    end
  end

  def update_lang str
    str.gsub("__lang__", language)
       .gsub("__Lang__", language.capitalize)
  end
end
