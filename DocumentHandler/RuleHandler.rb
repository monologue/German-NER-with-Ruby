require_relative 'Rule.rb'
class RuleHandler
	attr_accessor :rules, :sentences#, :rule
	
	def initialize()
		@rules = Array.new
		@sentences = Array.new
		#@rule = rule
	end
	
	#reads the rules and calls split_rule for every line, one line contains one rule
	def read_rules(data)
		#case rule 
			#when "per" 
				File.readlines(data).each do |line|
					@rules << split_rule(line)
				end
			#when "org" 
				#File.readlines("Org_Rules.txt").each do |line|
					#@rules << split_rule(line)
				#end
			#when "loc" 
				#File.readlines("Loc_Rules.txt").each do |line|
					#@rules << split_rule(line)
			#	end
			#when "oth" 
			#	File.readlines("Oth_Rules.txt").each do |line|
				#	@rules << split_rule(line)
			#	end
			#when "mix"	
				#File.readlines("Mix_Rules.txt").each do |line|
				#	@rules << split_rule(line)
				#end
		#end
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
			r.add_length(string.scan(splitPattern)[0][2].to_i)
			r.add_category(string.scan(splitPattern)[0][0].to_s)
			r.add_start(string.scan(splitPattern)[0][1])
		return r
	end
	
	#splitting the ruleParts/conditions into the three elements feature, position, value
	def condition_parts(string)
		splitPattern = /\w+\.[a-zA-Z]+|\w+/ # Klammern hinzugefügt, noch nicht getestet!
		element = string.scan(splitPattern)
		case element[0]
			when "POS" then return POSCondition.new(element[1].to_i, element[2])							
			when "token" then return TokenCondition.new(element[1].to_i, element[2].to_s)
			when "case" then return CaseCondition.new(element[1].to_i, element[2].to_s)
			when "suffix" then return SuffixCondition.new(element[1].to_i, element[2].to_s)
			when "prefix" then return PrefixCondition.new(element[1].to_i, element[2].to_s)
			when "pow" then return PartOfWordCondition.new(element[1].to_i, element[2].to_s)
			when "punct" then return PunctuationCondition.new(element[1].to_i, element[2].to_s)
		end	
	end	
	
end