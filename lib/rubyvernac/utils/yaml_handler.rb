require "yaml"

module Rubyvernac
  module Utils

    class YamlHandler

      def stringified_load_file(filepath)
        content = load_file(filepath)

        stringified_content = {}
        content.each do |key, val|
          stringified_content[key.to_s] = val
        end

        stringified_content
      end

      def load_file(filepath)
        YAML.load_file(filepath)
      end

    end

  end
end
