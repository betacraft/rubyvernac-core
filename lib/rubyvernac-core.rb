require 'forwardable'
require 'open3'

require_relative "./rubyvernac/parser/language_parser"
require_relative "./rubyvernac/parser/language_alias_loader"
require_relative "./rubyvernac/utils/file_handler"
require_relative "./rubyvernac/utils/yaml_handler"

class RubyvernacCore
  extend Forwardable

  def_delegators :@language_alias_loader, :create_aliases

  def initialize(source_file: nil, language: "ruby", keywords_file: nil)
    @source_file = source_file
    @keywords_file = keywords_file

    @file_handler = Rubyvernac::Utils::FileHandler.new
    @yaml_handler = Rubyvernac::Utils::YamlHandler.new
    @parser = Rubyvernac::Parser::LanguageParser.new

    @language = language
    @language_alias_loader = Rubyvernac::Parser::LanguageAliasLoader.new
  end

  def execute
    translated_code = translate_code

    write_to_temp_file(translated_code)

    output = run_ruby_subprocess

    puts "Script Output -"
    puts "#{output}"
  end

  def parse
    translated_code = translate_code

    print "Parsed code -\n#{translated_code}"
    translated_code
  end

  private

  def translate_code
    source = @file_handler.read_file(@source_file)
    keywords = load_keywords(@keywords_file)

    @parser.parse(
      byte_string: source,
      keywords: keywords,
      language: @language
    )
  end

  def load_keywords(keywords_file)
    keywords = @yaml_handler.stringified_load_file(keywords_file)
    inverted_keywords = {}

    keywords.each do |keyword_in_eng, keyword_in_non_eng|
      inverted_keywords[keyword_in_non_eng.to_s] = keyword_in_eng.to_s
    end

    inverted_keywords
  end

  def run_ruby_subprocess
    stdout, stderr, status = Open3.capture3(command, temp_file_path)
    @file_handler.delete_file(temp_file_path)

    raise "Error running script - #{stderr}" if !status.success?

    stdout
  end

  def write_to_temp_file(content)
    @file_handler.write_to_file(temp_file_path, content)
  end

  def temp_file_path
    filepath, extension = @source_file.split('.')

    "#{filepath}.tmp.#{extension}"
  end

  def command
    @command ||=   case @language
                    when "ruby"
                      "ruby"
                    else
                      "run"
                    end
  end

end
