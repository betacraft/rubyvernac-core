module Translations
  class FileBasedTranslator

    def initialize(lang_code: , dir_path:, input_file:, output_file:)
      @google_translator = GoogleTranslatorApi.new(lang_code)

      @input_file = File.open("#{dir_path}/#{input_file}")
      @output_file = File.open("#{dir_path}/#{output_file}")
    end

    def process_file
      translated_keywords = translate_input_file
      write_to_output_file(translated_keywords)
    end

    private

      def translate_input_file
        translated_keywords = []
        lines = @input_file.readlines

        lines.each do |line|
          line = line.chomp
          next if line.empty?

          translated_word = @google_translator.translate(line) rescue ""
          next if translated_word.empty?

          translated_keywords << "#{translated_word} #{line}"
        end

        # hard coding missing keywords
        translated_keywords << "#{@google_translator.translate("else if")} elseif"

        translated_keywords
      end

      def write_to_output_file(translated_keywords)
        content = translated_keywords.join("\n")

        File.open("#{dir_path}/#{output_file}", "w") {|f| f.write(content) }
      end

  end
end
