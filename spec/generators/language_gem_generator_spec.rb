RSpec.describe Rubyvernac::Generators::LanguageGemGenerator do

  describe "#generate" do
    it "Generates templates and language classes" do
      validator = instance_double("Rubyvernac::Validators::LanguageValidator")
      expect(validator).to receive(:validate).with('hindi')

      validator_klass = class_double("Rubyvernac::Validators::LanguageValidator").
        as_stubbed_const(transfer_nested_constants: true)
      expect(validator_klass).to receive(:new).and_return(validator)

      template_generator = instance_double("Rubyvernac::Generators::TemplateGenerator")
      expect(template_generator).to receive(:generate_gem_files)

      template_generator_klass = class_double("Rubyvernac::Generators::TemplateGenerator").
        as_stubbed_const(transfer_nested_constants: true)
      expect(template_generator_klass).to receive(:new).
        with(language: 'hindi', gem_path: Dir.pwd + "/new_gems/rubyvernac-hindi").
        and_return(template_generator)

      language_classes_generator = instance_double("Rubyvernac::Generators::LanguageClassesGenerator")
      expect(language_classes_generator).to receive(:generate_class_files)

      language_classes_generator_klass = class_double("Rubyvernac::Generators::LanguageClassesGenerator").
        as_stubbed_const(transfer_nested_constants: true)
      expect(language_classes_generator_klass).to receive(:new).and_return(language_classes_generator)

      instance = Rubyvernac::Generators::LanguageGemGenerator.new(language: 'hindi')
      instance.generate
    end
  end

end
