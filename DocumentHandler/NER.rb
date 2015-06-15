=begin 
The Class NER should take an POS-tagged text, parse a set of rules and apply them on the tagged text. A rule consists
of one to infinite number of conditions, if all conditions of one rules are true, the rule can be applied.
=end

require_relative 'RuleHandler.rb'
require_relative 'Rule.rb'

require 'csv'
class NER 

	#attr_accessor :rules, :sentences
	
	def initialize
		#@rules = Array.new
		#@sentences = Array.new
	end

	#def parse_sentences
	#		@sentences.each do |sentence|
	#			parse_sentence(sentence)
	#		end
	#end	
	
	def parse_sentence
		rules = RuleHandler.new
		rules.read_rules
		line = 0
		data = Nokogiri::XML::SAX::Parser.new(DocumentHandler.new)
		data.parse_file('micro.xml')
		t = data.output
		t.each {|text|
			text.each {|sentence|
				while line < sentence.sentence_parts.length
					rules.each_with_index do |rule, index|
						if rule.matched?(sentence.sentence_parts, line)
							rule.apply(sentence.sentence_parts, line)
							puts sentence.sentence_parts[line][0]
							line = line + rule.length
							break
						else if index == @rules.size-1
							File.open(OUTPUT, 'a') {|f| f.write(sentence.sentence_parts[line][0] + "\t" + "O"+ "\t" + "O" +"\n")}
							line = line +1 
						end
						end
					end
					
				end
				}}
	end

end

N = NER.new
N.parse_sentence
	