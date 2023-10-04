require 'rubyvernac/__lang__'
require 'ruby-vernac-parser'

require 'yaml'
require 'pry'

spec = Gem::Specification.find_by_name("rubyvernac-__lang__")
gem_root = spec.gem_dir

require gem_root + '/lib/rubyvernac/language_alias_loader'

parser = RubyVernacParser.new
loader = LanguageAliasLoader.new(parser: parser)

loader.create_aliases(gem_root + '/lib/translations')
