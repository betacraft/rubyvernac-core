require_relative 'gcp/google_translator_api'

require 'forwardable'

module CloudProvider
  class TranslatorApi
    def_delegator :@cloud_provider, :translate

    def initialize
      @cloud_provider = Gcp::GoogleTranslatorApi.instance
    end

  end
end
