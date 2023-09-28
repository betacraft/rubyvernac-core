require_relative "../../lib/ruby-vernac-parser.rb"
require 'pry-nav'
RSpec.describe "RubyVernacParser" do
  let (:translation_file) { Dir.pwd + "/spec/examples/keyword_mapping.yml" }

  describe "executes a non english program" do

    it "with puts" do
      parser = RubyVernacParser.new(
        source_file: Dir.pwd + "/spec/examples/hindi/000_hello_world.rb",
        language: "ruby",
        keywords_file: translation_file
      )
      expect{ parser.execute }.to output("नमश्कार!\n").to_stdout
    end

    it "with a method definition" do
      parser = RubyVernacParser.new(
        source_file: Dir.pwd + "/spec/examples/hindi/001_def.rb",
        language: "ruby",
        keywords_file: translation_file
      )
      expect{ parser.execute }.to output("२ सरकार।\n").to_stdout
    end

    # TODO Doesn't work, converts the code into following which errrors out
    # for अ in १..१३
    #   puts #{अ}
    # end
    # (irb):1:in `<main>': undefined local variable or method `१' for main:Object (NameError)
    #         from /home/ashish/.rvm/rubies/ruby-3.1.4/lib/ruby/gems/3.1.0/gems/irb-1.4.1/exe/irb:11:in `<top (required)>'
    #         from /home/ashish/.rvm/rubies/ruby-3.1.4/bin/irb:31:in `load'
    #         from /home/ashish/.rvm/rubies/ruby-3.1.4/bin/irb:31:in `<main>'
    it "with a for loop" do
      skip
      parser = RubyVernacParser.new(
        source_file: Dir.pwd + "/spec/examples/hindi/002_for_loop.rb",
        language: "ruby",
        keywords_file: translation_file
      )
      expect{ parser.execute }.to output("\n").to_stdout
    end

    it "with a while loop" do
      parser = RubyVernacParser.new(
        source_file: Dir.pwd + "/spec/examples/hindi/003_while_loop.rb",
        language: "ruby",
        keywords_file: translation_file
      )
      expect{ parser.execute }.to output("आज नकद कल उधार !\nआज नकद कल उधार !\nआज नकद कल उधार !\nआज नकद कल उधार !\nआज नकद कल उधार !\n").to_stdout
    end

    it "with a case statement" do
      parser = RubyVernacParser.new(
        source_file: Dir.pwd + "/spec/examples/hindi/004_case_statement.rb",
        language: "ruby",
        keywords_file: translation_file
      )
      expect{ parser.execute }.to output("!\n").to_stdout
    end

  end
end
