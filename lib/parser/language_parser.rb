class LanguageParser
  attr_reader :byte_string, :keywords, :language

  def self.run(byte_string: "", keywords: {}, language: "")
    new(byte_string, keywords, language).run
  end

  def initialize(byte_string, keywords, language)
    @processed_string_buffer = ""
    @keywords_found = 0
    @class_names = []

    @byte_string = byte_string
    @keywords = keywords
    @language = language
  end

  def run
    case language
    when "ruby"
      line_comment_string = "#"
    else
      line_comment_string = "//"
    end
    lines = byte_string.split("\n")

    lines.each do |line|
      if line.strip.start_with?(line_comment_string)
        @processed_string_buffer << (line + "\n")
        next
      end
      fields = line.split(" ")
      check_for_class_name = false

      quotes = 0
      single_quote = 0
      block_comment_start = 0
      block_comment_end = 0

      fields.each_with_index do |field, index|
        quotes += field.count("\"")
        single_quote += field.count("\'")
        block_comment_start += field.count("/*")
        block_comment_end += field.count("*/")

        if quotes%2 == 0 &&
           single_quote%2 == 0 &&
           block_comment_start == block_comment_end
          keyword = keywords[field]
          if !(keyword.nil? || keyword.empty?)

            if index == (fields.size - 1)
              @processed_string_buffer << keyword
            else
              @processed_string_buffer << (keyword  + " ")
            end

            check_for_class_name = true if keyword == "class"
            @keywords_found += 1

            next
          else
            if check_for_class_name
              @class_names << field
              check_for_class_name = false
              @processed_string_buffer << field

              next
            end
            ## This step is redundant
            # found = false
            # keywords.each do |k, v|
            #   if (field.include?(k) && k.size > 1)
            #     field[k] = v
            #     found = true
            #   end
            # end

            # if found
            #   @processed_string_buffer << (field + " ")
            #   next
            # end
          end
        end
        if index == (fields.size - 1)
          @processed_string_buffer << field
        else
          @processed_string_buffer << (field + " ")
        end
      end
      @processed_string_buffer << "\n"
    end
    processed_string = @processed_string_buffer.dup

    if @class_names.size != 0
      @class_names.each do |class_name|
        processed_string = processed_string.gsub(class_name, "C#{class_name}") #Class name has to be constant
      end
    end
    return processed_string
  end

end
