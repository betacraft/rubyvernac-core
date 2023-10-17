RSpec.describe RubyVernacParser do
  subject do
    RubyVernacParser.new(
      source_file: Dir.pwd + '/spec/stubs/ruby_vernac_parser/example.rb',
      keywords_file: Dir.pwd + '/spec/stubs/ruby_vernac_parser/keywords.yml'
    )
  end

  describe "#parse" do
    it "returns translated code from hindi language to english language" do
      expect{ subject.parse }.to output("Parsed code -\ndef कितने_आदमी_थे\nputs \"२ सरकार।\"\nend\n\nकितने_आदमी_थे()\n").to_stdout
    end
  end

  describe "#execute" do
    it "" do
      expect{ subject.execute }.to output("Script Output -\n२ सरकार।\n").to_stdout
    end
  end
end
