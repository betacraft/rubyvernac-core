# ruby-vernac-parser

## Installation

Install dependencies:

    $ bundle


## Usage


   ```ruby
    require "ruby-vernac-parser"
    
    parser = RubyVernacParser.new(source_file: <path to source>,
      language: <programing-language: "ruby">, keywords_file: <path to keywords file>)
     
    parser.execute #Execute the parsed script
   ```

## Generate language translation gem

    ruby language_gem_generator.rb

  And then provide the preferred language
  The new GEM will be available in the 'new_gems' folder

  Instructions regarding the usage of the gem will be available with the respective gems

## Parsing and exectuing scripts
    ruby keyword_parser.rb <path to file> ruby <path to keywords> 
