require_relative '../utils/file_handler'

module Rubyvernac
  module Generators

    class TemplateGenerator
      TEMPLATE_FILES_PATH = Dir.pwd + '/lib/templates'

      def initialize(language:)
        @language = language
        @generated_gem_path = Dir.pwd + "/new_gems/rubyvernac-#{language}"

        @file_handler = Rubyvernac::Utils::FileHandler.new
      end

      def generate_gem_files
        @file_handler.make_dir_if_not_exists(@generated_gem_path)

        template_files = @file_handler.list_files(TEMPLATE_FILES_PATH)
        generate_gem_from_template(template_files)
      end

      private

        def generate_gem_from_template(template_files)
          template_files.each do |template_file_path|
            template_content = @file_handler.read_file(template_file_path)
            template_content = inject_lang_name(template_content)

            template_filename = @file_handler.extract_filename_from_path(template_file_path)
            template_filename = remove_template_extensions(template_filename)
            template_filename = inject_lang_name(template_filename)

            dir_path_in_gem = template_file_path.gsub(TEMPLATE_FILES_PATH, @generated_gem_path)

            template_dirname = File.dirname(dir_path_in_gem)
            template_dirname = inject_lang_name(template_dirname)
            @file_handler.make_dir_if_not_exists(template_dirname)

            template_file_path_in_gem = "#{template_dirname}/#{template_filename}"

            @file_handler.write_to_file(template_file_path_in_gem, template_content)
          end

          @file_handler.make_executable("#{@generated_gem_path}/bin/ruby_#{@language}")
          @file_handler.change_dir(@generated_gem_path) do
            system("git init")
          end
        end

        # Replaces template file path with gem path:
        #
        #   "~/ruby-vernac-parser/lib/templates/Gemfile"
        #   becomes
        #   "~/ruby-vernac-parser/new_gems/rubyvernac-hindi/Gemfile"
        #   replacing /lib/templates with /new_gems/rubyvernac-hindi
        #
        # this preserves the sub path of the file in templates folder.
        def path_in_gem(template_file_path)
          template_file_path.gsub(TEMPLATE_FILES_PATH, @generated_gem_path)
        end

        # Injects actual language into template strings
        # For eg. rubyvernac-_lang_ => rubyvernac-hindi
        def inject_lang_name(template_str)
          template_str.gsub("__lang__", @language)
             .gsub("__Lang__", @language.capitalize)
        end

        def remove_template_extensions(filename)
          filename.gsub(".txt", "")
            .gsub(".text", ".txt")
            .gsub("_hidden_", "")
        end

    end

  end
end
