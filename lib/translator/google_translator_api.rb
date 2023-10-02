require "google/cloud/translate/v3"
require 'dotenv/load'

require_relative 'stubbed_translator_api'

module Translator
  class GoogleTranslatorApi

    def initialize(target_language_code)
      @target_language_code = target_language_code
      @client ||= ::Google::Cloud::Translate::V3::TranslationService::Client.new do |config|
        config.credentials = "/home/ashish/gcp/keyfile.json"
      end
    end

    def translate(word)
      begin
        response = make_translate_text_request(word)

        translated_word = response.translations.first&.translated_text || ""
      rescue Exception => e
        puts e.message
        translated_word = ''
      end

      #replace spaces -
      translated_word = translated_word.gsub(/ |\./, '_')

      # # return none if it's only latin -
      # !!translated_word.match(/^[a-zA-Z0-9_\-+? ]*$/) ?
      #   '' :
      #   translated_word

      translated_word
    end

    def stubbed_translation(word)
      @stubbed ||= Translator::StubbedTranslatorApi.new
      @stubbed.translate(word) || ""
    end

    private
      def make_translate_text_request(word)
        request = ::Google::Cloud::Translate::V3::TranslateTextRequest.new(
          contents: ["#{word}"],
          source_language_code: :en,
          target_language_code: @target_language_code,
          parent: ENV["GOOGLE_PROJECT_ID"]
        )
        response = @client.translate_text(request)

        response
      end

  end
end
