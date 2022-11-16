require_relative "./parser/language_parser"

class RubyVernacParser
  attr_reader :source_file, :language, :keywords_file, :keywords

  def initialize(source_file: nil, language: nil, keywords_file: nil)
    @source_file = source_file
    @language = language
    @keywords_file = keywords_file
    @keywords = {}
  end

  def execute
    if source_file.nil? || language.nil? || keywords_file.nil?
      raise "Arguments - source_file, language, keywords_file\n"
    end

    begin
      bytes = File.read(source_file)
    rescue => err
      raise "Error reading input file, #{err}\n"
    end

    begin
      read_keywords
    rescue => err
      raise "Error reading keywords #{err}\n"
    end

    p processedString = LanguageParser.run(
        byte_string: bytes,
        keywords: keywords,
        language: language
      )
    temp_file_path = "#{source_file}.tmp"

    File.delete(temp_file_path) if File.exist?(temp_file_path)
    File.open(temp_file_path, 'w') { |file| file.write(processedString) }

    case language
    when "ruby"
      command = "ruby"
    else
      command = "run"
    end

    # running script
    begin
      output = `#{command} #{temp_file_path}`
    rescue => err
      raise "Error running script- #{err}"
    end
    File.delete(temp_file_path)

    print "Script Output - \n#{output}"
  end

  private
    def read_keywords
      file = File.open(keywords_file)
      file.readlines.map(&:chomp).each do |line|
        fields = line.split(" ")
        next if fields.size != 2
        @keywords[fields[0]] = fields[1]
      end
    end

end

