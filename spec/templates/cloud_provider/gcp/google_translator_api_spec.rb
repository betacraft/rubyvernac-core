require "ostruct"

RSpec.describe Rubyvernac::CloudProvider::Gcp::GoogleTranslatorApi do
  describe "#translate" do
    it "makes correct translate api call" do
      gcp_client = double("gcp client")

      expect(::Google::Cloud::Translate::V3::TranslationService::Client).to receive(:new).and_return(gcp_client)
      instance = Rubyvernac::CloudProvider::Gcp::GoogleTranslatorApi.instance

      translation_request = double("translation request")
      expect(::Google::Cloud::Translate::V3::TranslateTextRequest).to receive(:new)
        .with(
          contents: ["ancestors"],
          source_language_code: :en,
          target_language_code: "hi",
          parent: ENV["GOOGLE_PROJECT_ID"]
        )
        .and_return(translation_request)

      stubbed_response = OpenStruct.new(
        translations: [
          OpenStruct.new(translated_text: "पूर्वजों")
        ]
      )
      expect(gcp_client).to receive(:translate_text)
        .with(translation_request)
        .and_return(stubbed_response)

      expect(instance.translate("ancestors", "hi")).to eq("पूर्वजों")
    end
  end
end
