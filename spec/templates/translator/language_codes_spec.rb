RSpec.describe Rubyvernac::Translator::LanguageCodes do
  subject do
    Rubyvernac::Translator::LanguageCodes.new(
      config_path: Dir.pwd + "/lib/templates/lib/available_languages.yml"
    )
  end

  describe "allows available languages" do
    it "allows hindi language" do
      expect(subject.find_code("hindi")).to eq("hi")
    end

    it "allows spanish language" do
      expect(subject.find_code("spanish")).to eq("es")
    end
  end
end
