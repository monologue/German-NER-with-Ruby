require_relative 'DocumentHandler.rb'
class Condition
	attr_reader :feature, :position, :value
	def initialize(feature, position, value)
		@feature = feature
		@position = position
		@value = value
	end
	#a condition used on a line from a sentence can be true or false
	def matched?(sentence, line)
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
		#puts @category
	end
	#def show_category
	#	puts @category
	#end
	def add_start(start)
		@start = start
	end
	def matched?(sentence, line)
		result = false
		@conditions.each do |condition|
			if condition.matched?(sentence, line) == false
				#puts("S did not match for line " + line.to_s + " for condition " + condition.value + "\n")
				return false
			end
			if 	condition.matched?(sentence, line) == true
				result = true
			else 
				puts "unbekannter Fehler in Rule.matched?" 
				exit
			end
		end
		puts("Sentence did match for line " + line.to_s + "\n")		
		return result
	end
	def apply(sentence, line)
		i = 1
		File.open(OUTPUT, 'a') {|f| f.write(sentence[line+@start.to_i].form + "\t"  + @category + "\t" +"O" +"\n")}
		while i < @length
			File.open(OUTPUT, 'a') {|f| f.write(sentence[line+i].form + "\t"  + @category + "\t" +"O"+"\n")}
			i = i+ 1
		end
	end
end

class POSCondition < Condition
	
	def initialize(position, value)
		@position = position
		@value = value
	end
	
	def matched?(sentence, line)
		puts "matched?"
		if (sentence.length < line + @position)
			#puts @value
			return false
		end
		if @value == sentence[line + @position].pos
			puts "funktioniert"
			#puts @value
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
	
	def matched?(sentence, line)
		puts @value
		if (sentence.length < line + @position)
			#puts @value
			return false
		end
		if @value == sentence[line + @position].form
			puts @value
			return true
		end
		#if @value == 
		if @value =~ /ElementOf/
			e = ElementOf.new
			#puts @position
			case @value
				when  /NameList/ then return e.NameList(sentence[line + @position].form) 
				when /LocationList/ then return ElementOf.LocationList(sentence[line + @position].form)
				when "OrganizationList" then return ElementOf.OrganizationList(sentence[line + @position].form)
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
	def matched?(sentence, line)
		if (sentence.length < line + @position)
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
	def matched?(sentence, line)
		if (sentence.length < line + @position)
			return false
		end
	end
end

class PartOfWordCondition < Condition
	def initialize(position, value)
		@position = position
		@value = value
	end
	def matched?(sentence, line)
		if (sentence.length < line + @position)
			return false
		end
	end
end

class PunctationCondition < Condition
	def initialize(position, value)
		@position = position
		@value = value
	end
	def matched?(sentence, line)
		if (sentence.length < line + @position)
			return false
		end
	end
end
