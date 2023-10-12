RSpec.describe Rubyvernac::Generators::LanguageClassesGenerator do

  subject do
    Rubyvernac::Generators::LanguageClassesGenerator.new(
      language: 'hindi',
      gem_path: Dir.pwd + '/spec/stubs/gem_path'
    )
  end

  before :all do
    FileUtils.mkdir_p(Dir.pwd + '/spec/stubs/gem_path')
  end

  describe "#generate_class_files" do
    it "generates translation files for ruby classes" do
      subject.generate_class_files

      ['array.yml'].each do |file|
        generated = YAML.load_file(Dir.pwd + '/spec/stubs/gem_path/lib/translations/classes/' + file)
        orig = YAML.load_file(Dir.pwd + '/spec/stubs/language_classes_generator/' + file)

        klass = file.split('.')[0]
        expect(generated[klass]['cname']).to eq(orig[klass]['cname'])

        orig[klass].keys.each do |method_type|
          next if method_type == 'cname'

          orig[klass][method_type].keys do |method|
            expect(generated[klass][method_type][method]).to eq(orig[klass][method_type][method])
          end
        end
      end
    end
  end

  after :all do
    dir_path = Dir.pwd + '/spec/stubs/gem_path'
    if Dir.exists?(dir_path)
      FileUtils.rm_rf(dir_path)
    end
  end
end
