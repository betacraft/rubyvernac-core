RSpec.describe Rubyvernac::Translator::LanguageBasedTranslator do

  describe "#generate_translations" do
    before :all do
      ENV['STUB_CLOUD_APIS'] = 'true'
    end

    it "generates translations" do
      ['array.yml', 'class.yml', 'integer.yml', 'math.yml', 'module.yml', 'object.yml'].each do |filename|
        instance = Rubyvernac::Translator::LanguageBasedTranslator.new(
          lang_code: 'hi',
          translations_path: Dir.pwd + '/spec/stubs',
          filename: filename
        )

        sample_class_path = Dir.pwd + "/spec/stubs/sample/classes/#{filename}"
        target_class_path = Dir.pwd + "/spec/stubs/classes/#{filename}"

        FileUtils.cp(sample_class_path, target_class_path)
        instance.generate_translations

        translated_class_path = Dir.pwd + "/spec/stubs/translated/classes/#{filename}"

        expect(FileUtils.compare_file(translated_class_path, target_class_path)).to be_truthy
      end
    end
  end

end
