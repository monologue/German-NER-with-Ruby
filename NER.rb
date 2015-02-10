=begin 
The Class NER should take an POS-tagged text, parse a set of rules and apply them on the tagged text. A rule consists
of one to infinite number of conditions, if all conditions of one rules are true, the rule can be applied.
=end

require 'csv'
class NER 
	attr_accessor :rules, :sentences
	def initialize
		@rules = Array.new
		@sentences = Array.new
	end

	def parse_sentences
		split_sentences 
			@sentences.each do |sentence|
				parse_sentence(sentence)
			end
	end	
	
	def parse_sentence(sentence)
		line = 0
		while line < sentence.length
		#for line in 0..sentence.length-1
		#index = 1
			@rules.each_with_index do |rule, index|
				if rule.matched?(sentence, line)
					rule.apply(sentence, line)
					puts sentence[line][0]
					line = line + rule.length
					break
					else if index == @rules.size-1
						File.open(OUTPUT, 'a') {|f| f.write(sentence[line][0] + "\t" + "O"+ "\t" + "O" +"\n")}
						line = line +1 
				end
			end
		end
	end
	end

	
	#reads the rules and calls split_rule for every line, one line contains one rule
	def read_rules
		File.readlines(RULES).each do |line|
			@rules << split_rule(line)
		end
	end
	
	#this function splits the rules after a pattern and saves the parts in an array and returns this array
	def split_rule(string)
		r = Rule.new
		i = 0
		splitPatternCondition = /(\w+\.\d+\s+\=\s+[\w\.]+)+/
		splitPattern = /\>\s+(\w+)\s+(\d+).(\d+)/
		while string.scan(splitPatternCondition)[i]
			r.add_condition(condition_parts(string.scan(splitPatternCondition)[i].to_s))			
			i = i + 1
		end
			#puts string.scan(splitPattern)[3].to_i
			r.add_length(string.scan(splitPattern)[0][2].to_i)
			#puts r.length
			r.add_category(string.scan(splitPattern)[0][0].to_s)
			#puts r.category
			r.add_start(string.scan(splitPattern)[0][1])
		return r
	end
	
	#splitting the ruleParts/conditions into the three elements feature, position, value
	def condition_parts(string)
		splitPattern = /\w+\.[a-zA-Z]+|\w+/ # Klammern hinzugefügt, noch nicht getestet!
		element = string.scan(splitPattern)
		#test
		#if element[2].start_with?("ElementOf") then puts element[2]
		#end
		case element[0]
			when "POS" then  return POSCondition.new(element[1].to_i, element[2])							
			when "token" then return TokenCondition.new(element[1].to_i, element[2].to_s)
		end
		
	end
	
	#reads the tagged text and saves every line as an array in array lines, @sentences has one dimension more to 
	#get access to the single sentences
	def split_sentences
		lines = Array.new

		CSV.foreach(CORPUS, {:col_sep => "\t", :quote_char => "\0" }) do |row| 
			lines << [row[0], row[1], row[2]]
		end

		sentence = []
		lines.each do |line|
			sentence << line
			if line[0] == "."
				@sentences.push(sentence)
				sentence = []
			end
		end
		return @sentences
	end	
end
	