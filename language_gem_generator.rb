require_relative "lib/rubyvernac/generators/language_gem_generator"

print "Ruby Vernac Language Gem Generator\n"
# print "Enter author name: "
# author_name = gets.chomp()
# print "Enter author email: "
# author_email = gets.chomp()
print "Enter prefered language: "
selected_language = gets.chomp

Rubyvernac::Generators::LanguageGemGenerator.new(
  language: selected_language
  # author_email: author_email,
  # author_name: author_name
).generate
