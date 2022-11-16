# ruby-vernac-parser

## Usage


   ```ruby
    require "ruby-vernac-parser"
    
    parser = RubyVernacParser.new(source_file: <path to source>,
      language: <programing-language: "ruby", keywords_file: <path to keywords file>)
     
    parser.execute #Execute the parsed script
   ```
