require 'rubyvernac/__lang__'
require 'ruby-vernac-parser'

require 'yaml'

spec = Gem::Specification.find_by_name("rubyvernac-__lang__")
gem_root = spec.gem_dir

parser = RubyVernacParser.new
parser.create_aliases(gem_root + '/lib/translations/classes')
