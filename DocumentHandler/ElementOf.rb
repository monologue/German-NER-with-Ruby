class ElementOf
	#Methods should check if List contains word
	loc = File.readlines("Cities.txt").map { |l| l.chomp  }
	PER = File.readlines("FirstNames.txt").map { |l| l.chomp  }
	org = File.readlines("OrgEnding.txt").map { |l| l.chomp  }
	
	def initialize()
	end
	def NameList(word)
		return PER.include?(word)
	end
	
	def LocationList(word)
		return loc.include?(word)
	end
	
	def OrgEnding(word)
		return org.include?(word)
	end
end