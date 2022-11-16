class LanguageParser

  def self.run(byte_string: "", keywords: {}, language: "")
    processed_string_buffer = ""
    quotes = 0
    single_quote = 0
    block_comment_start = 0
    block_comment_end = 0
    keywords_found = 0
    class_names = []

    case language
    when "ruby"
      lineCommentString = "#"
    else
      lineCommentString = "//"
    end
    lines = byte_string.split("\n")

    lines.each do |line|
      if line.strip.start_with?(lineCommentString)
          processed_string_buffer << (line + "\n")
        next
      end
      fields = line.split(" ")
      checkForClassName = false
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
              processed_string_buffer << keyword
            else
              processed_string_buffer << (keyword  + " ")
            end

            checkForClassName = true if keyword == "class"
            keywords_found += 1

            next
          else
            if checkForClassName
              class_names << field
              checkForClassName = false
              processed_string_buffer << field
              
              next
            end
            found = false
            keywords.each do |k, v|
              if field.include? k
                field[k] = v
                found = true
              end
            end

            if found
              processed_string_buffer << (field + " ")
              next
            end
          end
        end
        if index == (fields.size - 1)
          processed_string_buffer << field
        else
          processed_string_buffer << (field + " ")
        end
      end
      processed_string_buffer << "\n"
    end
    processed_string = processed_string_buffer.dup

    if class_names.size != 0
      class_names.each do |class_name|
        processed_string = processed_string.gsub(class_name, "C#{class_name}") #Class name has to be constant
      end
    end
    return processed_string
  end

end