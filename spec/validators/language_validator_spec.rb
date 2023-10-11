require "fileutils"

RSpec.describe Rubyvernac::Validators::LanguageValidator do
  describe "validates available languages" do
    it "allows hindi language" do
      expect { subject.validate("hindi") }.not_to raise_error(Rubyvernac::LanguageNotAvailableException)
    end

    it "allows spanish language" do
      expect { subject.validate("spanish") }.not_to raise_error(Rubyvernac::LanguageNotAvailableException)
    end

    it "doesn't allow not available language" do
      expect { subject.validate("english") }.to raise_error(Rubyvernac::LanguageNotAvailableException)
    end

    it "raises error if for any other input" do
      expect { subject.validate("test") }.to raise_error(Rubyvernac::LanguageNotAvailableException)
    end
  end
end
