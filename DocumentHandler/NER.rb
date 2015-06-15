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
		data = DocumentHandler.new
		#data.parse_file('micro.xml')
		#t = data.output
		#puts data.get_texts
		data.get_texts.each {|text|
			puts text
			text.each {|sentence|
				puts sentence.sentence_parts
				while line < sentence.sentence_parts.length
					rules.each_with_index do |rule, index|
						if rule.matched?(sentence.sentence_parts, line)
							puts "matched"
							rule.apply(sentence.sentence_parts, line)
							puts sentence.sentence_parts[line].form
							line = line + rule.length
							break
						else if index == @rules.size-1
							puts "not matched"
							File.open(OUTPUT, 'a') {|f| f.write(sentence.sentence_parts[line].form + "\t" + "O"+ "\t" + "O" +"\n")}
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
	