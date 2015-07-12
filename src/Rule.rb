# encoding: UTF-8
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
	def matched?(text, sentence, line, category)
	end
end 

class Rule
	
	attr_accessor :conditions, :category, :start, :length, :index
	
	def initialize(index)
		@conditions = Array.new
		@category = String.new
		@length = 0
		@index = index
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
=begin
		if category == 'PERf' || category == 'LOCf' || category == 'ORGf'
			@conditions.each do |condition|
				if condition.matched?(text, sentence, line, category) == false
					return false
				elsif condition.matched?(text, sentence, line, category) == true
						result = true
				else 
							#puts sentence[line].id
							#puts "unbekannter Fehler in Rule.matched?1" 
							#exit
				end
					return result
			end
			
		else
=end
		@conditions.each do |condition|
			
			if condition.matched?(text, sentence, line, category) == false
				return false
			end
			if 	condition.matched?(text, sentence, line, category) == true
				result = true
			else 
				puts "should not happen"
				exit
			end
		end		
		return result
	end
	
	def apply(sentence, line)
	i = 0
	e = ElementOf.new
	if @category =~ /[A-Z]{3}f/
		return change(sentence, line)
	end

	case @category	
		when "PER"
			while i < @length 
				#puts "#{sentence[line+i].form} #{sentence[line + i].id}"
				sentence[line+i].add_per 
				sentence[line + i].add_rule("#{index}")
				e.add_word(sentence[line + i].form, category)
				i = i +1
			end
		when "ORG" 
			while i < @length 
				sentence[line+i].add_org
				sentence[line + i].add_rule("#{index}")
				e.add_word(sentence[line + i].form, category)
				i = i +1
			end
		when "OTH" 
			while i < @length 
				sentence[line+i].add_oth
				sentence[line + i].add_rule("#{index}")
				e.add_word(sentence[line + i].form, category)
				i = i +1
			end
		when "LOC" 
			while i < @length 
				sentence[line+i].add_loc
				sentence[line + i].add_rule("#{index}")
				e.add_word(sentence[line + i].form, category)
				i = i +1
			end
		#else puts "andere Kategorie in apply"
		end
	end
	
	def change(sentence, line)
		i = 0
		e = ElementOf.new
		case @category
			when 'PERf'
			if sentence[line+i].per == true
				while sentence[line+i].per == true 
					sentence[line+i].del_per
					sentence[line+i].add_rule("#{-index}")
					e.del_word(sentence[line+i].form, "PER")
					i += 1
					if (sentence.length-1 < line + i)
						return false
					end
				end
			else puts "no per"
			end
			when 'LOCf'
			if sentence[line+i].loc == true
				while sentence[line+i].loc == true
					sentence[line+i].del_loc
					sentence[line+i].add_rule("#{-index}")
					e.del_word(sentence[line+i].form, "LOC")
					i += 1
					if (sentence.length-1 < line + i)
						return false
					end
				end
			end
			when 'ORGf'
			if sentence[line+i].org == true
				#puts "true??? #{sentence[line + i].per}"
				while sentence[line+i].org == true 
					sentence[line+i].del_org
					sentence[line+i].add_rule("#{-index}")
					e.del_word(sentence[line+i].form, "ORG")
					i += 1
					if (sentence.length-1 < line + i)
						return false
					end
				end
			else 
				return false
			end
		end
	end
end

class POSCondition < Condition
	
	def initialize(position, value)
		@position = position
		@value = value
	end
	
	def matched?(text, sentence, line, category)
		if (sentence.length-1 < line + @position) || (0 > line + @position) 
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
	
	def matched?(text, sentence, line, category)
		if (sentence.length-1 < line + @position) || (0 > line + @position) 
			return false
		end
		if @value.force_encoding(Encoding::UTF_8) == sentence[line + @position].form.force_encoding(Encoding::UTF_8)
			return true
		end
		if @value =~ /ElementOf/
			e = ::ElementOf.new
			case @value
				when  /NameList/ then return e.NameList(sentence[line + @position].form) 
				when /LocationList/ then return e.LocationList(sentence[line + @position].form)
				when /OrgEnding/ then return e.OrgEnding(sentence[line + @position].form)
				when /CurrentLexicon/ then return e.check_lexicon(sentence[line + @position].form, category)
				when /Numbers/ then return e.Numbers(sentence[line + position].form)
				when /number/ then return e.numeric?(sentence[line + position].form)
				when /InNach/ then return e.InNach(sentence[line + position].form)
				when /noLoc/ then return e.NoLoc(sentence[line + position].form)
				when /Mitarbeiter/ then return e.Mitarbeiter(sentence[line + position].form)
				when /Anrede/ then return e.Anrede(sentence[line + position].form)
				when /\.Org$/ then return e.Organisation(sentence[line + position].form)
				when /noOrg/ then return e.NoOrg(sentence[line + position].form)
				when /found/ then return sentence[line + position].org

			end
		end
		return false
	end
end

class LemmaCondition < Condition
	def initialize(position, value)
		@position = position
		@value = value
	end
	
	def matched?(text, sentence, line, category)
		if (sentence.length-1 < line + @position) || (0 > line + @position) 
			return false
		end
		if @value == sentence[line + @position].form
			return true
		else return false
		end
		if @value =~ /ElementOf/
			e = ::ElementOf.new
			case @value
				when  /NameList/ then return e.NameList(sentence[line + @position].lemma) 
				when /LocationList/ then return e.LocationList(sentence[line + @position].lemma) 
				when /OrgEnding/ then return e.OrgEnding(sentence[line + @position].lemma)
				when /CurrentLexicon/ then return e.check_lexicon(sentence[line + @position].lemma, category)
				when /Numbers/ then return e.Numbers(sentence[line + position].lemma)
				when /number/ then return e.numeric?(sentence[line + position].lemma)
				when /InNach/ then return e.InNach(sentence[line + position].lemma)
				when /noLoc/ then return e.NoLoc(sentence[line + position].lemma)
				when /Anrede/ then return e.Anrede(sentence[line + position].lemma)
				when /Mitarbeiter/ then return e.Mitarbeiter(sentence[line + position].lemma)
				when /\.Org$/ then return e.Organisation(sentence[line + position].lemma)
				when /noOrg/ then return e.NoOrg(sentence[line + position].lemma)
				when /found/ then return sentence[line + position].org
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
	def matched?(text, sentence, line, category)
		if (sentence.length-1 < line + @position) || (0 > line + @position) 
			return false
		end

		if (sentence[line + @position].form).start_with?(@value)
			return false
		end

		if (sentence[line + @position].form).end_with?(@value)
			return true
		else 
			return false
		end
	end
end

class PrefixCondition < Condition
	def initialize(position, value)
		@position = position
		@value = value
	end
	def matched?(text, sentence, line, category)
		if (sentence.length-1 < line + @position) || (0 > line + @position) 
			return false
		end
		if (sentence[line + @position].form).end_with?(@value)
			return false
		end
		if (sentence[line + @position].form).end_with?(@value)
			return true
		end
		return false
	end
end

class PartOfWordCondition < Condition
	def initialize(position, value)
		@position = position
		@value = value
	end
	def matched?(text, sentence, line, category)
		if (sentence.length-1 < line + @position) || (0 > line + @position) 
			return false
		end
	end
end

class PunctationCondition < Condition
	def initialize(position, value)
		@position = position
		@value = value
	end
	def matched?(text, sentence, line, category)
		if (sentence.length-1 < line + @position) || (0 > line + @position) 
			return false
		end
	end
end

class CaseCondition < Condition
	def initialize(position, value)
		@position = position
		@value = value
	end
	
	def matched?(text, sentence, line, category)
		if (sentence.length-1 < line + @position) || (0 > line + @position) 
			return false
		end
		
		if @value == "aC" 
			if sentence[line + @position].form =~ /^[A-Z]+$/ 
				return true
			end
			return false		
		end
		if @value == "fC"
			if sentence[line + @position].form =~ /[A-Z][a-z]*/ 
				return true
			end
			return false
		end
		if @value == "mixed"
			if sentence[line + @position].form =~ /[a-z]*\S[A-Z]\S*/ 
				return true
			end
			return false
		end
		if @value == "token"
			if sentence[line + @position].form =~ /[A-Z]\./ 
				return true
			end
			return false
		end
		return false
	end
end
