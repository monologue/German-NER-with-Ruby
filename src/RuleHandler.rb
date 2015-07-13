require_relative 'Rule.rb'

class RuleHandler
	attr_accessor :rules, :sentences, :falseRules#, :rule
	
	def initialize()
		@rules = Array.new
		@sentences = Array.new
		@falseRules = ['PERf', 'ORGf', 'LOCf', 'OTHf']
	end

	def read_rules(data)
		File.readlines("../Rules/"+data).each do |line|
			@rules << split_rule(line, @rules.length)
		end
	end

	def split_rule(string, index)
		r = Rule.new(index)
		i = 0
		splitPatternCondition = /(\w+\.-*\d+\s+\=\s+[\w\.äößü]+)+/
		splitPatternRule = /\>\s+(\w+)\s+(\d+).(\d+)/
		splitPatternRuleException = /\>\s+(\w+)/
		while string.force_encoding("UTF-8").scan(splitPatternCondition)[i]
			r.add_condition(condition_parts(string.scan(splitPatternCondition)[i][0]))			
			i = i + 1
		end
			if falseRules.include?(string.scan(splitPatternRuleException)[0][0])
				r.add_category(string.scan(splitPatternRuleException)[0][0])
			else
			r.add_length(string.scan(splitPatternRule)[0][2].to_i)
			r.add_category(string.scan(splitPatternRule)[0][0])
			r.add_start(string.scan(splitPatternRule)[0][1])
			end
		return r
	end
	
	def condition_parts(string)
		splitPattern = /([a-zA-Z]+).(-\d|\d)\s.\s(\w+.\w+|\w+)/
		element = string.scan(splitPattern)[0]
		case element[0]
			when "POS" then return POSCondition.new(element[1].to_i, element[2])							
			when "token" then return TokenCondition.new(element[1].to_i, element[2])
			when "case" then return CaseCondition.new(element[1].to_i, element[2])
			when "suffix" then return SuffixCondition.new(element[1].to_i, element[2])
			when "prefix" then return PrefixCondition.new(element[1].to_i, element[2])
			when "pow" then return PartOfWordCondition.new(element[1].to_i, element[2])
			when "punct" then return PunctuationCondition.new(element[1].to_i, element[2])
			when "context" then return ContextCondition.new(element[1].to_i, element[2])
			when "lemma" then return LemmaCondition.new(element[1].to_i, element[2])
		end
		puts "default"
	end	
	
end