require "forwardable"
require "yaml"

require_relative "rubyvernac/parser/language_parser"
require_relative "rubyvernac/parser/language_alias_loader"

class RubyVernacParser
  extend Forwardable

  def_delegators :@language_alias_loader, :create_aliases
  attr_reader :keywords, :input_bytes, :message_text,
    :source_file, :language, :keywords_file

  def initialize(source_file: nil, language: "ruby",
    keywords_file: nil, message_text: false)
    # @args = ARGV
    @source_file = source_file
    @message_text = message_text
    @language = language
    @keywords_file = keywords_file
    @keywords = {}

    @language_alias_loader = Rubyvernac::Parser::LanguageAliasLoader.new
    begin
      # validate_args
      read_input_file if @source_file
      read_keywords if @keywords_file
    rescue
      @error = true # Do nothing and stop execution
    end
  end

  def execute
    return if @error
    if source_file.nil? || keywords_file.nil?
      raise "Arguments - source_file, keywords_file\n"
    end

    # running script
    begin
      output = `#{command} #{temp_file_path}`
    rescue => err
      print "Error running script- #{err}"
      return
    ensure
      File.delete(temp_file_path) if File.exist?(temp_file_path)
    end
    print "Script Output - \n" if message_text
    print "#{output}"
  end

  def parse
    return if @error
    print "Parsed code -\n#{parsed_string}"
  end

  private

  def validate_args
    if args.size != 3
      print "Arguments - parser source_file language keywords_file\n"
      raise
    end
  end

  def read_input_file
    @input_bytes = File.read(source_file)
  rescue => err
    print "Error reading input file, #{err}\n"
    raise
  end

  def read_keywords
    _keywords = YAML.load_file(@keywords_file)

    _keywords.each do |keyword_in_eng, keyword_in_non_eng|
      @keywords[keyword_in_non_eng.to_s] = keyword_in_eng.to_s
    end
  end

  def parsed_string
    @parsed_string ||= Rubyvernac::Parser::LanguageParser.run(
      byte_string: input_bytes,
      keywords: keywords,
      language: language
    )
  end

  def command
    @command ||= case language
    when "ruby"
      "ruby"
    else
      "run"
    end
  end

  def temp_file_path
    @temp_file_path ||= begin
      file_path = "#{source_file}.tmp"
      File.write(file_path, parsed_string)
      file_path
    end

    @temp_file_path
  end
end
