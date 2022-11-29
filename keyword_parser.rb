require_relative "./lib/ruby-vernac-parser"

arg = ARGV
RubyVernacParser.new(
  source_file: arg[0],
  language: arg[1],
  keywords_file: arg[2]
).execute

