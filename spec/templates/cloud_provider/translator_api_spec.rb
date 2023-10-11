RSpec.describe Rubyvernac::CloudProvider::TranslatorApi do

  describe "#translate" do
    it "delegate translate to cloud provider instance" do
      translator = instance_double("Rubyvernac::CloudProvider::Gcp::GoogleTranslatorApi")
        expect(translator).to receive(:translate).with("text_to_be_translated", "hi").
        and_return("text_after_translation")

      translator_klass = class_double("Rubyvernac::CloudProvider::Gcp::GoogleTranslatorApi")
        .as_stubbed_const(transfer_nested_constants: true)
      expect(translator_klass).to receive(:instance).and_return(translator)

      instance = Rubyvernac::CloudProvider::TranslatorApi.new

      expect(instance.translate("text_to_be_translated", "hi")).to eq("text_after_translation")
    end
  end

end
