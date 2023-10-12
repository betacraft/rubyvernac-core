RSpec.describe Rubyvernac::Utils::FileHandler do
  let(:dir_path) { Dir.pwd + '/test' }
  let(:sub_dir_path) { dir_path + '/sub_dir' }

  describe "System commands" do
    it "makes file executable" do
      filename = 'sample.txt'
      file_path = Dir.pwd + '/' + filename

      create_file(Dir.pwd, filename)
      expect(Kernel).to receive(:system).with("chmod a+x #{file_path}")
      subject.make_executable(file_path)
    end

    it "changes directory" do
      orig_dir = Dir.pwd

      subject.make_dir_if_not_exists(dir_path)
      subject.change_dir(dir_path) do
        expect(Dir.pwd).to eq(dir_path)
      end
    end

    after :each do
      rmdir(dir_path)
    end
  end

  describe "#extract_filename_from_path and #extract_dirname_from_path" do
    it "extracts filename from path" do
      expect(subject.extract_filename_from_path(dir_path + '/sample.txt')).to eq("sample.txt")
    end

    it "extracts dirname from path" do
      expect(subject.extract_dirname_from_path(dir_path + '/sample.txt')).to eq(dir_path)
    end
  end

  describe "#make_dir_if_not_exists" do
    it "creates directory if it does not exists" do
      expect(Dir.exists?(dir_path)).to be_falsey

      subject.make_dir_if_not_exists(dir_path)
      expect(Dir.exists?(dir_path)).to be_truthy
    end

    it "does not creates directory if it already exists" do
      subject.make_dir_if_not_exists(dir_path)
      expect(Dir.exists?(dir_path)).to be_truthy

      subject.make_dir_if_not_exists(dir_path)
      expect(FileUtils).not_to receive(:mkdir_p).with(dir_path)
    end

    after :each do
      rmdir(dir_path)
    end
  end

  describe "#list_files" do
    before :all do
      @file_dir = "#{Dir.pwd}/files"
      @paths = []

      3.times do |ind|
        path = "#{@file_dir}/file_#{ind}"
        create_file(@file_dir, "file_#{ind}")
        @paths.push(path)
      end
    end

    it "returns files in a directory" do
      expect(subject.list_files(@file_dir).sort).to eq(@paths)
    end

    after :all do
      rmdir(@file_dir)
    end
  end

  describe "Read and write to files" do
    before :each do
      filename = 'sample.txt'
      @file_path = Dir.pwd + '/' + filename

      rm_file(@file_path)
      create_file(Dir.pwd, filename)
    end

    it "reads file and returns its content" do
      subject.write_to_file(@file_path, 'hello world')
      expect(subject.read_file(@file_path)).to eq('hello world')
    end

    it "writes to file" do
      subject.write_to_file(@file_path, 'another world')
      expect(subject.read_file(@file_path)).to eq('another world')
    end

    it "appends to file" do
      subject.write_to_file(@file_path, 'hello')
      subject.append_to_file(@file_path, ' world')

      expect(subject.read_file(@file_path)).to eq('hello world')
    end

    it "checks for if it's a file" do
      expect(subject.is_file?(@file_path)).to be_truthy
    end

    after :each do
      rm_file(@file_path)
    end
  end

  def create_file(dir_path, filename)
    FileUtils.mkdir_p(dir_path)
    FileUtils.touch(dir_path + '/' + filename)
  end

  def rmdir(dir_path)
    if Dir.exists?(dir_path)
      FileUtils.rm_rf(dir_path)
    end
  end

  def rm_file(file_path)
    File.delete(file_path) if File.exists?(file_path)
  end

end
