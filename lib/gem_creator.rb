require 'yaml'
require "fileutils"
require_relative './translations'

class GemCreator
  attr_reader :language, :author_name, :author_email

  def initialize(language: "", author_name: "", author_email: "")
    @language = language.downcase
    @author_name = author_name
    @author_email = author_email
    @errors = []
    validate_language
  end


  def generate
    if !@errors.empty?
      puts @errors
      return
    end

    generate_files
    get_translations
    print "\n The new gem can be found in 'new_gems' folder\n"
    # FileUtils.mv('/tmp/your_file', '/opt/new/location/your_file') # To move the output folder
  end

  private

  def get_translations
    Translations.new(language: language, lang_code: @language_code).run
  end

  def validate_language
    available_languages = YAML::load_file("lib/available_languages.yml")
    @language_code = available_languages[language]
    @errors << "Language not found" if @language_code.nil?
  end

  def generate_files
    relavtive_dir_path = "new_gems/rubyvernac-#{language}"
    FileUtils::mkdir_p relavtive_dir_path if !Dir.exist? relavtive_dir_path
    dir_path = File.expand_path("../../#{relavtive_dir_path}", __FILE__)
    Dir.glob(File.expand_path('../templates/**/**', __FILE__)).each do |file_path|
      next if !File.file?(file_path)
      file = File.open(file_path)
      file_name = update_lang(
                    file_path
                     .gsub(".txt", "")
                     .gsub(".text", ".txt")
                     .gsub("_hidden_", "")
                     .gsub(File.expand_path('../templates/', __FILE__), "")
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
