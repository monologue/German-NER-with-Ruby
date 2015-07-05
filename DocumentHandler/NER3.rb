require_relative 'RuleHandler.rb'
require_relative 'DocumentHandler.rb'
require_relative 'Rule.rb'
require 'nokogiri'
require 'csv'

class NER3 < Nokogiri::XML::SAX::Document
	attr_accessor :ner
	@@rule_lists = ['Per_Rules.txt', 'Org_Rules.txt', 'Loc_Rules.txt']
	def initialize
		@ner = Array.new
	end
	
	def ner_main
		File.open("out.txt", 'a') {|f| f.write("Word" + "\t" + "PER" + "\t" + "ORG" + "\t" + "LOC" + "\t" + "OTH" + "\t" + "Rule1" + "\t" + "Rule2" + "\t" + "Rule3" + "\n")}
		data = DocumentHandler.new #new object from type DocumentHandler
		data.new_Element()	#calls the parser and reads the xml-data
		data.texts.each {|text|
			text.sentences.each {|sentence|
				r = RuleHandler.new
				@@rule_lists.each {|rule_list|
					r.read_rules(rule_list)
					line = 0
					while line < sentence.sentence_parts.length
						r.rules.each_with_index do |rule, index|
							puts rule.index
							if rule.matched?(text, sentence.sentence_parts, line)
								i = 0
								rule.apply(sentence.sentence_parts, line)
								while i < rule.length
									sentence.sentence_parts[line + i].add_rule("#{rule_list}#{index}")
									text.current_lexicon(sentence.sentence_parts[line + i].form, rule.category)
									i = i +1
								end
								line = line + rule.length
								break
								else if index == r.rules.size-1
									line = line + 1
								end
							end
						end
					end
				
				}	
			}
	
			text.sentences.each {|sentence|
				r = RuleHandler.new
				r.read_rules('ausnahmen.txt')
				#@@rule_lists.each {|rule_list|
				#r.read_rules(rule_list)
				line = 0
				while line < sentence.sentence_parts.length
						r.rules.each_with_index do |rule, index|
							if rule.matched?(text, sentence.sentence_parts, line)
								rule.change(sentence.sentence_parts, line)
								line = line +1
								break
							else if index == r.rules.size-1
									line = line + 1
								end
							end
						end
					end	
			}
			
				write_ner(text)
		}
	end	
	
	def write_ner(text)
		text.sentences.each {|sentence|
			sentence.sentence_parts.each {|word|
				#if the word is no punctuation mark, it will be written in out.txt
				if word.pos !~ /[$]/
					File.open("out.txt", 'a') {|f| f.write(word.form + "\t" + word.per.to_s + "\t" + word.org.to_s + "\t" + word.loc.to_s + "\t" + word.oth.to_s + "\t" + word.rule1.to_s + "\t" + word.rule2.to_s + "\t" + word.rule3.to_s + "\n")}
				end
			}
		}
	end		
end


N = NER3.new
N.ner_main