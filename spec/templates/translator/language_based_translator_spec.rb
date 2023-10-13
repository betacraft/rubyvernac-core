RSpec.describe Rubyvernac::Translator::LanguageBasedTranslator do

  describe "#generate_translations" do
    before :all do
      ENV['STUBBED_TRANSLATIONS'] = 'lib/templates/lib/rubyvernac/stubs'
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

        compare_translations(translated_class_path, target_class_path, filename)
      end
    end
  end

  def compare_translations(orig, generated, filename)
    orig = YAML.load_file(orig)
    generated = YAML.load_file(generated)

    klass = filename.split('.')[0]
    expect(generated[klass]['cname']).to eq(orig[klass]['cname'])

    orig[klass].keys.each do |method_type|
      next if method_type == 'cname'

      orig[klass][method_type].keys do |method|
        expect(generated[klass][method_type][method]).to eq(orig[klass][method_type][method])
      end
    end
  end

end
