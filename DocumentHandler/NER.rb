=begin 
The Class NER should take an POS-tagged text, parse a set of rules and apply them on the tagged text. A rule consists
of one to infinite number of conditions, if all conditions of one rules are true, the rule can be applied.
=end

require_relative 'RuleHandler.rb'
require_relative 'DocumentHandler.rb'
require_relative 'Rule.rb'
require 'nokogiri'
require 'csv'
class NER < Nokogiri::XML::SAX::Document
	
	def initialize

	end
	
	def parse_sentence
		r = RuleHandler.new("per")
		r.read_rules
		data = DocumentHandler.new
		data.new_Element()
		data.texts.each {|text|
			text.sentences.each {|sentence|
				line = 0
				while line < sentence.sentence_parts.length
					r.rules.each_with_index do |rule, index|
						if rule.matched?(sentence.sentence_parts, line)
							#puts "matched"
							rule.apply(sentence.sentence_parts, line)
							line = line + rule.length
							break
						else if index == r.rules.size-1
							#puts "not matched"
							File.open("out.txt", 'a') {|f| f.write(sentence.sentence_parts[line].form + "\t" + "O"+ "\t" + "O" +"\n")}
							line = line +1 
						end
						end
					end	
				end
				}}
	end
	
	def rule_use(type)
		
	end
	

end

N = NER.new
N.parse_sentence
	