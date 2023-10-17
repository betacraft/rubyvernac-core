require_relative "./lib/ruby-vernac-parser"

RubyVernacParser.new(
  source_file: ARGV[0],
  language: ARGV[1],
  keywords_file: ARGV[2],
  message_text: true
).execute

