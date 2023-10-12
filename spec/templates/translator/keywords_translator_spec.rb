RSpec.describe Rubyvernac::Translator::KeywordsTranslator do
  subject do
    Rubyvernac::Translator::KeywordsTranslator.new(
      lang_code: "hi",
      translations_path: Dir.pwd + "/spec/stubs",
      filename: "keywords.yml"
    )
  end

  describe "#generate_translations" do
    before :all do
      ENV["STUB_CLOUD_APIS"] = "true"
    end

    it "generates translations" do
      sample_keyword_path = Dir.pwd + "/spec/stubs/sample/keywords.yml"
      target_keyword_path = Dir.pwd + "/spec/stubs/keywords.yml"

      FileUtils.cp(sample_keyword_path, target_keyword_path)
      subject.generate_translations

      translated_keyword_path = Dir.pwd + "/spec/stubs/translated/keywords.yml"

      expect(FileUtils.compare_file(translated_keyword_path, target_keyword_path)).to be_truthy
    end
  end
end
