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
	
	attr_accessor :conditions, :category, :start, :length
	
	def initialize
		@conditions = Array.new
		@category = String.new
	end
	
	def add_condition(condition)
		@conditions << condition
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
		if category == 'PERf'
			@conditions.each do |condition|
				if condition.matched?(text, sentence, line) == false
					#puts("S did not match for line " + line.to_s + " for condition " + condition.value + "\n")
					return false
				end
				if 	condition.matched?(text, sentence, line) == true
					result = true
				else 
					#puts condition.position
					#puts "unbekannter Fehler in Rule.matched?1" 
					#exit
				end
				return result
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
				puts sentence[line].id
				puts "unbekannter Fehler in Rule.matched?2" 
				#exit
			end
		end		
		return result
	end
	end
	
	def apply(sentence, line)
		
		#puts sentence[line].form
		i = 1
		e = ElementOf.new
		case @category	
			when "PER"
				sentence[line].add_per 
				e.add_word(sentence[line].form)
				while i < @length 
					#puts "#{sentence[line+i].form} #{sentence[line + i].id}"
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
	
	def change(sentence, line)
		i = 0
		e = ElementOf.new
		case @category
			when 'PERf'
				while sentence[line+i].per == true
					sentence[line+i].del_per
					e.del_word(sentence[line+i].form)
					i += 1
				end
		end
	end
end

class POSCondition < Condition
	
	def initialize(position, value)
		@position = position
		@value = value
	end
	
	def matched?(text, sentence, line)
		if position == -1
			puts "negative position"
		end
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
		if position == "-1"
			puts "negative position"
		end
		if (sentence.length-1 < line + @position)
			return false
		end
		#if (line + @position < 1)
		#	return false
		#end
		if @value == sentence[line + @position].form
			return true
		end
		if @value =~ /ElementOf/
			e = ::ElementOf.new
			case @value
				when  /NameList/ then return e.NameList(sentence[line + @position].form) 
				when /LocationList/ then return e.LocationList(sentence[line + @position].form)
				when /OrgEnding/ then return e.OrgEnding(sentence[line + @position].form)
				when /CurrentLexicon/ then return text.check_lexicon(sentence[line + @position].form)
				when /Numbers/ then return e.Numbers(sentence[line + position].form)
				when /number/ then return e.numeric?(sentence[line + position].form)
				when /InNach/ then return e.InNach(sentence[line + position].form)
				when /OrgEnding/ then return e.OrgEnding(sentence[line + position].form)
					#if e.InNach(sentence[line + position].form) == true
					#	puts sentence[line].form
					#	puts sentence[line + position].form
					#	return true
					#end
			end
		return false
		
		end
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
