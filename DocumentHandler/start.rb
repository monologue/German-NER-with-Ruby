require_relative 'DocumentHandler.rb'
require_relative 'RuleHandler.rb'

parser = Nokogiri::XML::SAX::Parser.new(DocumentHandler.new)
parser.parse_file('micro.xml')
R = RuleHandler.new
R.read_rules
