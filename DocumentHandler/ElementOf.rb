class ElementOf
	#Methods should check if List contains word
	LOC = File.readlines("Cities.txt").map { |l| l.chomp  }
	PER = File.readlines("FirstNames.txt").map { |l| l.chomp  }
	ORG = File.readlines("OrgEnding.txt").map { |l| l.chomp  }
	LEXICON = Array.new
	NUMBERS = File.readlines("Numbers.txt").map { |l| l.chomp  }
	NACH = ["in", "nach"]
	ORGEND = File.readlines("OrgEnding.txt").map{|l| l.chomp}
	NOLOC = File.readlines("not_loc.txt").map{|l| l.chomp}
	
	def NameList(word)
		return PER.include?(word)
	end
	
	def Numbers(word)
		i = 0
		while i < NUMBERS.length-1
			if NUMBERS[i] =~ word
				return true
			end
			return false
		#return NUMBERS.include?(word)
	end
	end
	def OrgEnding(word)
		return ORGEND.include?(word)
	end
	 def numeric?(string)
		return true if string =~ /\A\d+\Z/
		true if Float(string) rescue false
	end
	 

	def add_word(word)
		LEXICON << word
	end
	
	def del_word(word)
		if LEXICON.include?(word)
			LEXICON.delete(word)
		end
	end
	
	def InNach(word)
		return NACH.include?(word)
	end
	
	def LocationList(word)
		return LOC.include?(word)
	end
	
	def OrgEnding(word)
		return ORG.include?(word)
	end
	
	def NoLoc?(word)
		return NOLOC.include?(word)
	end
end