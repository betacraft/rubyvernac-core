RSpec.describe Rubyvernac::CloudProvider::TranslatorApi do

  describe "#translate" do
    it "delegate translate to cloud provider instance" do
      skip("Need to debug why allow_any_instance_of is not working")

      allow(::Google::Cloud::Translate::V3::TranslationService::Client).to receive(:new).and_return({})
      allow_any_instance_of(Rubyvernac::CloudProvider::Gcp::GoogleTranslatorApi).to receive(:translate).
        with(anything,anything).and_return

      subject.translate('test', 'hi')
      # subject.translate
    end
  end

end
