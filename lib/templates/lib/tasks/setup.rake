require "ruby-vernac-parser"
require "bundler"
require 'pry'

require_relative "../translator/main"

namespace :setup do

  desc "Fetch translations of keywords"
  task :fetch_translations do
    `bundle install`
    Bundler.setup(:default)

    translator = Translator::Main.new(language: "__lang__")
    translator.generate_translations
  end

end
