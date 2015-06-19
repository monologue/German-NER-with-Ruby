class ElementOf
	#Methods should check if List contains word
	loc = File.readlines("Cities.txt").map { |l| l.chomp  }
	PER = File.readlines("FirstNames.txt").map { |l| l.chomp  }
	ORG = File.readlines("OrgEnding.txt").map { |l| l.chomp  }
	LEXICON = Array.new
	
	def initialize()
	end
	def NameList(word)
		return PER.include?(word)
	end

	def add_word(word)
		LEXICON << word
	end
	def LocationList(word)
		return loc.include?(word)
	end
	
	def OrgEnding(word)
		return ORG.include?(word)
	end
	
	
	#def check_lexicon(word)
	#	LEXICON.include?(word)
	#end
end