require "ruby-vernac-parser"
require "bundler"
require 'pry'

require_relative "../translator/main"

namespace :setup do

  desc "Fetch translations of keywords"
  task :fetch_translations do
    `bundle install`
    Bundler.setup(:default)
    binding.pry

    ruby_vernac_parser = RubyVernacParser.new

    # language = "hindi"
    # translator = Translator::Main.new(
    #   language: "hindi",
    #   lang_code: ruby_vernac_parser.find_lang_code("hindi")
    # )
    # translator.generate_translations
  end

end
