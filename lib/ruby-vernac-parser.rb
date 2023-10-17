require 'forwardable'

require_relative "./rubyvernac/parser/language_parser"
require_relative "./rubyvernac/parser/language_alias_loader"
require_relative "./rubyvernac/utils/file_handler"
require_relative "./rubyvernac/utils/yaml_handler"

class RubyVernacParser
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
    # running script
    begin
      output = `#{command} #{temp_file_path}`
    rescue => err
      print "Error running script- #{err}"
      return
    ensure
      @file_handler.delete_file(temp_file_path)
    end
    print "Script Output - \n"
    print "#{output}"
  end

  def parse
    translated_code = translate_code

    print "Parsed code -\n#{translated_code}"
  end

  private

  def translate_code
    source = @file_handler.read_file(@source_file)
    keywords = @yaml_handler.stringified_load_file(@keywords_file)

    @parser.parse(
      byte_string: source,
      keywords: keywords,
      language: language
    )
  end

  def write_to_temp_file(content)
    @file_handler.write_to_file(temp_file_path, content)
  end

  def temp_file_path
    "#{@source_file}.tmp"
  end

  def command
    @command ||=   case language
                    when "ruby"
                      "ruby"
                    else
                      "run"
                    end
  end

end
