RSpec.describe Rubyvernac::CloudProvider::StubbedTranslatorApi do

  subject do
    Rubyvernac::CloudProvider::StubbedTranslatorApi.new(
      stubbed_translations: Dir.pwd + '/lib/templates/lib/rubyvernac/stubs'
    )
  end

  describe "#translate" do
    it "translates a word correctly" do
      expect(subject.translate('ancestors', 'hi')).to eq('पूर्वजों')
    end

    it "raises error if translation failed" do
      expect{ subject.translate('abcd', 'hi') }.to raise_error(Rubyvernac::TranslationFailedException, "Translation failed for abcd")
    end
  end

end
