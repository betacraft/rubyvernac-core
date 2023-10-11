require "fileutils"

module Rubyvernac
  module Utils

    class FileHandler

      def make_dir_if_not_exists(dir_abs_path)
        if !Dir.exists?(dir_abs_path)
          FileUtils.mkdir_p(dir_abs_path)
        end
      end

      def list_files(abs_path)
        path_regex = File.join(abs_path, '/**/**')
        all_paths = Dir.glob(File.expand_path(path_regex))

        all_paths.select { |path| is_file?(path) }
      end

      def is_file?(abs_path)
        File.file?(abs_path)
      end

      def read_file(abs_path)
        File.read(abs_path)
      end

      def extract_filename_from_path(abs_path)
        File.basename(abs_path)
      end

      def extract_dirname_from_path(abs_path)
        File.dirname(abs_path)
      end

      def write_to_file(abs_path, content)
        File.open(abs_path, "w") do |f|
          f.write(content)
        end
      end

      def append_to_file(abs_path, content)
        File.open(abs_path, 'a') do |f|
          f.write( content )
        end
      end

      def make_executable(abs_path)
        Kernel.system("chmod a+x #{abs_path}")
      end

      def change_dir(abs_path)
        Dir.chdir(abs_path) do
          yield
        end
      end

    end

  end
end
