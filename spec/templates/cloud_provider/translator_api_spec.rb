RSpec.describe Rubyvernac::CloudProvider::TranslatorApi do

  describe "#translate" do
    it "delegate translate to cloud provider instance" do
      class TestDouble
        def translate(word, lang_code)
          return 'translated text'
        end
      end

      instance = Rubyvernac::CloudProvider::TranslatorApi.new(cloud_provider: TestDouble.new)

      expect(instance.translate('test', 'hi')).to eq('translated text')
    end
  end

end
