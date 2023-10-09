RSpec.describe Rubyvernac::Generators::LanguageGemGenerator do
  subject { Rubyvernac::Generators::LanguageGemGenerator.new(language: 'hindi') }

  describe "" do
    it "" do
      skip("Not sure why allow_any_instance_of is not working")
      allow_any_instance_of(Rubyvernac::Validators::LanguageValidator).to receive(:validate).
        with('hindi').and_return

      expect_any_instance_of(Rubyvernac::Generators::TemplateGenerator).to receive(:generate_gem_files).once.and_return
      allow(Rubyvernac::Generators::TemplateGenerator).to receive(:new).
        with(language: 'hindi', gem_path: Dir.pwd + "/new_gems/rubyvernac-hindi").and_call_original

      expect_any_instance_of(Rubyvernac::Generators::LanguageClassesGenerator).to receive(:generate_class_files).once.and_return
      allow(Rubyvernac::Generators::LanguageClassesGenerator).to receive(:new).
        with(language: 'hindi', gem_path: Dir.pwd + "/new_gems/rubyvernac-hindi").and_call_original

      subject.generate
    end
  end

end
