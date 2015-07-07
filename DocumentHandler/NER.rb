	#bei mehreren LIsten, rulehandler weiterentwickeln, einlesen der Schleife in extra schleife außerhalb
require_relative 'RuleHandler.rb'
require_relative 'DocumentHandler.rb'
require_relative 'Rule.rb'
require 'nokogiri'
require 'csv'

class NER < Nokogiri::XML::SAX::Document
	attr_accessor :ner
	@@rule_lists = ['Per_Rules.txt', 'Org_Rules.txt', 'Loc_Rules.txt', 'ausnahmen.txt']
	def initialize
		@ner = Array.new
	end
	
	def ner_main
		File.open("out.txt", 'a') {|f| f.write("ID" + "\t" + "Word" + "\t" + "PER" + "\t" + "ORG" + "\t" + "LOC" + "\t" + "OTH" + "\t" + "Rules" + "\n")}
		data = DocumentHandler.new 
		data.new_Element()	
		r = RuleHandler.new
		@@rule_lists.each {|rule_list| 
			r.read_rules(rule_list)
		}
		data.texts.each {|text|
			text.sentences.each {|sentence|
				line = 0
				while line < sentence.sentence_parts.length
					r.rules.each_with_index do |rule, index|
						if rule.matched?(text, sentence.sentence_parts, line)
							i = 0
							rule.apply(sentence.sentence_parts, line)
							while i < rule.length
								sentence.sentence_parts[line + i].add_rule("#{index},")
								text.current_lexicon(sentence.sentence_parts[line + i].form, rule.category)
								i = i +1
							end
							#break
						end
					end
					line = line + 1
					end
			}
			#r.read_rules('ausnahmen.txt')
			text.sentences.each {|sentence|	
				line = 0
				while line < sentence.sentence_parts.length
					r.rules.each_with_index do |rule, index|
						if rule.category == 'PERf' || rule.category == 'LOCf'
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
					File.open("out.txt", 'a') {|f| f.write(word.id + "\t" + word.form + "\t" + word.per.to_s + "\t" + word.org.to_s + "\t" + word.loc.to_s + "\t" + word.oth.to_s + "\t" + word.rules.to_s + "\n")}
				end
			}
		}
	end			
end

N = NER.new
N.ner_main