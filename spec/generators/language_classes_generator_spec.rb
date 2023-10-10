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

      ['array.yml', 'class.yml', 'integer.yml', 'math.yml', 'module.yml', 'object.yml'].each do |file|
        expect(FileUtils.compare_file(Dir.pwd + '/spec/stubs/gem_path/lib/translations/classes/' + file, Dir.pwd + '/spec/stubs/language_classes_generator/' + file)).to be_truthy
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
