require 'nokogiri'

class CountText  < Nokogiri::XML::SAX::Document
	attr_accessor :count
	def initialize
		@count = 0
	end
	
	def start_element(name, attrs=[])
		if name == 'text'
			@count += 1
		end
	end
	
	def end_document
		puts count
	end
end
parser = Nokogiri::XML::SAX::Parser.new(CountText.new)
parser.parse_file('C:/git/German-NER-with-Ruby/Input/test.xml')
#p = Nokogiri::XML::SAX::Parser.new(CountText.new)
#parser.parse_file('C:/git/German-NER-with-Ruby/Input/train.xml')
#c= Nokogiri::XML::SAX::Parser.new(CountText.new)
#parser.parse_file('C:/git/German-NER-with-Ruby/Input/develop.xml')
#parser.parse_file('tuebadz-9.1-exportXML-v2.xml')