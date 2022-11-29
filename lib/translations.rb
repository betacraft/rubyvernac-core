require 'yaml'
require 'dotenv/load'
require "google/cloud/translate/v3"

class Translations
  attr_reader :language, :lang_code, :dir_path

  def initialize(language: nil, lang_code: nil)
    @language = language
    @lang_code = lang_code
    @dir_path = File.expand_path("../../new_gems/rubyvernac-#{language}/lib/translations", __FILE__)
  end

  def run
    return if language.nil?

    print "\n\nGetting translations\n"
    print "== Please wait this will take some time ==\n"
    thread_1 = Thread.new{handle_transilation_files}
    thread_2 = Thread.new{handle_keywords_file}
    spinner(thread_1, thread_2)
    thread_1.join
    thread_2.join
  end

  private

  def handle_keywords_file
    @keywords = []
    file = File.open("#{dir_path}/keywords.txt")
    file.readlines.map(&:chomp).each do |line|
      next if line.empty?
      new_word = translate(line) rescue ""
      next if new_word.empty?
      @keywords << "#{new_word} #{line}"
    end

    # hard coding missing keywords
    @keywords << "#{translate("else if")} elseif"

    content = @keywords.join("\n")
    File.open("#{dir_path}/keywords.txt", "w") {|f| f.write(content) }
  end

  def handle_transilation_files
    # class_names = ObjectSpace.each_object(Class).map(&:name) # Will be a heavy execution
    class_names = ["Array", "Class", "Object", "Integer", "Math"]
    # class_names = ["Array"]

    class_names.each do |cname|
      class_name = eval(cname) # Note: Fixnum -> Integer
      content = Hash.new

      # place to keep class's name - 
      content[class_name.name.downcase] = content[class_name.name.downcase] ||
        Hash.new
      content[class_name.name.downcase]['cname'] = translate(class_name)

      # class methods
      class_name.public_methods.sort.each do |method_name|
        content[class_name.name.downcase]['cpumethods'] = content[class_name.name.downcase]['cpumethods'] ||
          Hash.new

        content[class_name.name.downcase]['cpumethods'][method_name.to_s] = 
          translate(method_name.to_s)
      end

      # class methods
      class_name.private_methods.sort.each do |method_name|
        content[class_name.name.downcase]['cprmethods'] = content[class_name.name.downcase]['cprmethods'] ||
          Hash.new

        content[class_name.name.downcase]['cprmethods'][method_name.to_s] = 
          translate(method_name.to_s)
      end

      # instance methods
      class_name.instance_methods.sort.each do |method_name|
        content[class_name.name.downcase]['ipumethods'] = content[class_name.name.downcase]['ipumethods'] ||
          Hash.new

        content[class_name.name.downcase]['ipumethods'][method_name.to_s] =
          translate(method_name.to_s)
      end

      # instance methods
      class_name.private_instance_methods.sort.each do |method_name|
        content[class_name.name.downcase]['iprmethods'] = content[class_name.name.downcase]['iprmethods'] ||
          Hash.new

        content[class_name.name.downcase]['iprmethods'][method_name.to_s] = 
          translate(method_name.to_s)
      end
      File.open(File.expand_path("#{dir_path}/#{class_name.name.downcase}.yml"), 'w+') do |f|
        f.write( content.to_yaml )
      end
    end
  end

  def translate(word)
    begin
      request = ::Google::Cloud::Translate::V3::TranslateTextRequest.new(
        contents: ["#{word}"], source_language_code: "en",
        target_language_code: lang_code, parent: ENV["GOOGLE_PROJECT_ID"])
      response = google_client.translate_text request
      str = response.translations.first&.translated_text || ""
    rescue Exception => e
      puts e.message
      str = ''
    end

    #replace spaces - 
    str = str.gsub(/ |\./, '_')

    # # return none if it's only latin - 
    # !!str.match(/^[a-zA-Z0-9_\-+? ]*$/) ?
    #   '' :
    #   str

    str
  end

  def google_client
    @google_client ||= ::Google::Cloud::Translate::V3::TranslationService::Client.new
  end

  def spinner(thread_1, thread_2)
    spinner1 = Enumerator.new do |e|
      loop do
        e.yield '|'
        e.yield '/'
        e.yield '-'
        e.yield '\\'
      end
    end
    while (thread_1.alive? || thread_2.alive?)
      printf("\r%s", spinner1.next)
      sleep(0.1)
    end
    printf("%s", "")
  end

end