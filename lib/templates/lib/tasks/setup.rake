require_relative "../translator/main"

namespace :setup do

  desc "Fetch translations of keywords"
  task :fetch_translations, [:filename] do |t, args|
    translator = Translator::Main.new(language: "__lang__", filename: args[:filename])
    translator.generate_translations
  end

end
