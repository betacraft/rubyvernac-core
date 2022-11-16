require "byebug"
require_relative "./lib/language_parser"

class KeywordParser
  attr_reader :args, :keywords

  def initialize
    @args = ARGV
    @keywords = {}
  end

  def call
    if args.size != 3
      print "Arguments - parser source_file language keywords_file\n"
      return
    end

    begin
      bytes = File.read(args[0])
    rescue => err
      print "Error reading input file, #{err}\n"
      return
    end

    begin
      read_keywords
    rescue => err
      print "Error reading keywords #{err}\n"
      return
    end

    p processedString = LanguageParser.run(
        byte_string: bytes,
        keywords: keywords,
        language: args[1]
      )
    temp_file_path = "#{args[0]}.tmp"

    File.delete(temp_file_path) if File.exist?(temp_file_path)
    File.open(temp_file_path, 'w') { |file| file.write(processedString) }


    case args[1]
    when "ruby"
      command = "ruby"
    else
      command = "run"
    end

    # running script
    begin
      output = `#{command} #{temp_file_path}`
    rescue => err
      print "Error running script- #{err}"
      return
    end
    File.delete(temp_file_path)

    print "Script Output - \n#{output}"
  end

  private
    def read_keywords
      file = File.open(args[2])
      file.readlines.map(&:chomp).each do |line|
        fields = line.split(" ")
        next if fields.size != 2
        @keywords[fields[0]] = fields[1]
      end
    end

end

KeywordParser.new.call