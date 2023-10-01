require "fileutils"

class FileHandler

  def make_dir_if_not_exists(dir_abs_path)
    if !Dir.exists?(dir_abs_path)
      FileUtils::mkdir_p(dir_abs_path)
    end
  end

  def list_files(rel_path)
    Dir.glob(File.expand_path(rel_path))
  end

  def file_exists?(abs_path)
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

  def make_executable(abs_path)
      system("chmod a+x #{abs_path}")
  end

  def change_dir(abs_path)
    Dir.chdir(abs_path) do
      yield
    end
  end

end
