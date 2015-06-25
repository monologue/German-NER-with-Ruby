require_relative 'DocumentHandler.rb'
require_relative 'ElementOf.rb'
class Condition
	attr_reader :feature, :position, :value
	def initialize(feature, position, value)
		@feature = feature
		@position = position
		@value = value
	end
	#a condition used on a line from a sentence can be true or false
	def matched?(text, sentence, line)
	end
end 

class Rule
	
	attr_accessor :conditions, :category, :start, :length, :type
	
	def initialize
		@conditions = Array.new
		@category = String.new
	end
	
	def add_condition(condition)
		@conditions << condition
	end
	
	def add_type(string)
		@type = string
	end
	
	def add_length(length)
		@length = length
	end
	
	def add_category(category)
		@category = category
	end

	def add_start(start)
		@start = start
	end
	
	def matched?(text, sentence, line)
		result = false
		if type == 'PERf'
			@conditions.each do |condition|
			if condition.matched?(text, sentence, line) == false
				puts "something"
				#puts("S did not match for line " + line.to_s + " for condition " + condition.value + "\n")
				break
			end
			if 	condition.matched?(text, sentence, line) == true
				puts "some other thing"
				result = false
			else 
				puts "unbekannter Fehler in Rule.matched?" 
				#exit
			end
		end
		else
		@conditions.each do |condition|
			if condition.matched?(text, sentence, line) == false
				#puts("S did not match for line " + line.to_s + " for condition " + condition.value + "\n")
				return false
			end
			if 	condition.matched?(text, sentence, line) == true
				result = true
			else 
				puts "unbekannter Fehler in Rule.matched?" 
				#exit
			end
		end
		end
		#puts("Sentence did match for line " + line.to_s + "\n")		
		return result
	end
	
	def apply(sentence, line)
		i = 1
		e = ElementOf.new
		case @category	
			when "PER"
				sentence[line].add_per 
				e.add_word(sentence[line].form)
				while i < @length 
					sentence[line+i].add_per 
					e.add_word(sentence[line + i].form)
					i = i +1
				end
			when "ORG" 
				sentence[line].add_org
				e.add_word(sentence[line].form)
				while i < @length 
					sentence[line+i].add_org
					e.add_word(sentence[line + i].form)
					i = i +1
				end
			when "OTH" 
				sentence[line].add_oth
				e.add_word(sentence[line].form)
				while i < @length 
					sentence[line+i].add_oth
					e.add_word(sentence[line + i].form)
					i = i +1
				end
			when "LOC" 
				sentence[line].add_loc
				e.add_word(sentence[line].form)
				while i < @length 
					sentence[line+i].add_loc
					e.add_word(sentence[line + i].form)
					i = i +1
				end
		end
	end
	
	def change(type, word)
		
		
	
	end
end

class POSCondition < Condition
	
	def initialize(position, value)
		@position = position
		@value = value
	end
	
	def matched?(text, sentence, line)
		if (sentence.length-1 < line + @position)
			return false
		end
		if @value == sentence[line + @position].pos
			return true
		end
		return false
	end
end

class TokenCondition < Condition
	def initialize(position, value)
		@position = position
		@value = value
	end
	
	def matched?(text, sentence, line)
		#puts @value
		if (sentence.length-1 < line + @position)
			return false
		end
		if @value == sentence[line + @position].form
			#puts @value
			return true
		end
		if @value =~ /ElementOf/
			e = ::ElementOf.new
			case @value
				when  /NameList/ then return e.NameList(sentence[line + @position].form) 
				when /LocationList/ then return e.LocationList(sentence[line + @position].form)
				when /OrgEnding/ then return e.OrgEnding(sentence[line + @position].form)
				when /CurrentLexicon/ then return text.check_lexicon(sentence[line + @position].form)
			end
		end
		return false
	end
end

class SuffixCondition < Condition
	def initialize(position, value)
		@position = position
		@value = value
	end
	def matched?(text, sentence, line)
		if (sentence.length-1 < line + @position)
			return false
		end
		#if sentence[line + @position][0] end.with? @value
	end
end

class PrefixCondition < Condition
	def initialize(position, value)
		@position = position
		@value = value
	end
	def matched?(text, sentence, line)
		if (sentence.length-1 < line + @position)
			return false
		end
	end
end

class PartOfWordCondition < Condition
	def initialize(position, value)
		@position = position
		@value = value
	end
	def matched?(text, sentence, line)
		if (sentence.length-1 < line + @position)
			return false
		end
	end
end

class PunctationCondition < Condition
	def initialize(position, value)
		@position = position
		@value = value
	end
	def matched?(text, sentence, line)
		if (sentence.length-1 < line + @position)
			return false
		end
	end
end

class CaseCondition < Condition
	def initialize(position, value)
		@position = position
		@value = value
	end
	
	def matched?(text, sentence, line)
		if (sentence.length-1 < line + @position)
			return false
		end
		
		if @value == "aC" 
			if sentence[line + @position].form =~ /[A-Z]+$/ 
				return true
			end
			return false		
		end
	end
end
