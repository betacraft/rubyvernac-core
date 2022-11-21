require_relative "./lib/language_parser"

class KeywordParser
  attr_reader :args, :keywords, :input_bytes

  def initialize
    @args = ARGV
    @keywords = {}
    begin
      validate_args
      read_input_file
      read_keywords
    rescue
      # Do nothing and stop execution
    end
  end

  def execute
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

  def parse
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
      begin
        @input_bytes = File.read(args[0])
      rescue => err
        print "Error reading input file, #{err}\n"
        raise
      end
    end

    def read_keywords
      begin
        file = File.open(args[2])
        file.readlines.map(&:chomp).each do |line|
          fields = line.split(" ")
          next if fields.size != 2
          @keywords[fields[0]] = fields[1]
        end
      rescue => err
        print "Error reading keywords #{err}\n"
        raise
      end
    end

    def parsed_string
      @parsed_string ||= LanguageParser.run(
                            byte_string: input_bytes,
                            keywords: keywords,
                            language: args[1]
                          )
    end

    def command
      @command ||=   case args[1]
                      when "ruby"
                        "ruby"
                      else
                        "run"
                      end
    end

    def temp_file_path
      @temp_file_path ||= (
        file_path = "#{args[0]}.tmp"
        File.delete(file_path) if File.exist?(file_path)
        File.open(file_path, 'w') { |file| file.write(parsed_string) }
        file_path
      )
    end

end

KeywordParser.new.execute