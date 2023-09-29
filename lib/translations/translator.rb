require_relative 'file_based_translator.rb'
require_relative 'language_based_translator.rb'

module Translations
  class Translator

    def initialize(language: nil, lang_code: nil)
      @language = language
      dir_path = File.expand_path("../../new_gems/rubyvernac-#{language}/lib/translations", __FILE__)

      @language_based_translator = LanguageBasedTranslator.new(lang_code: lang_code, dir_path: dir_path)
      @file_based_translator = FileBasedTranslator.new(
        lang_code: lang_code,
        dir_path: dir_path,
        input_file: "#{dir_path}/keywords.txt",
        output_file: "#{dir_path}/keywords.txt"
      )
    end

    def generate_translations
      return if @language.nil?

      print "\n\nGetting translations\n"
      print "== Please wait this will take some time ==\n"
      thread_1 = Thread.new{@file_based_translator.process_file}
      thread_2 = Thread.new{@language_based_translator.generate_translations}

      display_spinner(thread_1, thread_2)

      thread_1.join
      thread_2.join
    end

    private

      def display_spinner(threads)
        spinner = Enumerator.new do |e|
            loop do
              e.yield '|'
              e.yield '/'
              e.yield '-'
              e.yield '\\'
            end
          end
        while threads.any? { |thread| thread.alive? }
          printf("\r%s", spinner.next)
          sleep(0.1)
        end
        printf("%s", "")
      end

  end
end
