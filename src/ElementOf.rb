# encoding: UTF-8

class ElementOf
	
	attr_reader :result
	CITIES = File.readlines("C:/git/German-NER-with-Ruby/Dictionary/GerCities.txt").map { |l| l.chomp  }
	STATES = File.readlines("C:/git/German-NER-with-Ruby/Dictionary/States.txt").map { |l| l.chomp.force_encoding(Encoding::UTF_8)  }
	PER = File.readlines("C:/git/German-NER-with-Ruby/Dictionary/FirstNames.txt").map { |l| l.chomp.force_encoding(Encoding::UTF_8)}
	ORG = File.readlines("C:/git/German-NER-with-Ruby/Dictionary/OrgEnding.txt").map { |l| l.chomp  }
	ORGANISATION = File.readlines("C:/git/German-NER-with-Ruby/Dictionary/ORG.txt").map { |l| l.chomp  }
	LEXICON = Array.new
	NUMBERS = File.readlines("C:/git/German-NER-with-Ruby/Dictionary/Numbers.txt").map { |l| l.chomp  }
	NACH = ["in", "nach"]
	ORGEND = File.readlines("C:/git/German-NER-with-Ruby/Dictionary/OrgEnding.txt").map{|l| l.chomp}
	NOLOC = File.readlines("C:/git/German-NER-with-Ruby/Dictionary/not_loc.txt").map{|l| l.chomp}
	MITARBEITER = File.readlines("C:/git/German-NER-with-Ruby/Dictionary/Mitarbeiter.txt").map{|l| l.chomp}
	ANREDE = File.readlines("C:/git/German-NER-with-Ruby/Dictionary/Anrede.txt").map{|l| l.chomp}
	NOORG = File.readlines("C:/git/German-NER-with-Ruby/Dictionary/not_org.txt").map{|l| l.chomp}

	def initialize()
		@result = false
	end

	def NameList(word)
		return PER.include?(word.force_encoding(Encoding::UTF_8))
	end

	def NoOrg(word)
		return NOORG.include?(word)
	end
	def Organisation(word)
		return ORGANISATION.include?(word)
	end
	
	def Anrede(word)
		return ANREDE.include?(word)
	end
	
	def Mitarbeiter(word)
		return MITARBEITER.include?(word)
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
		if City(word) == true
			return
		else return State(word)
		end 
	end

	def City(word)
		return CITIES.include?(word)
	end

	def State(word)
		return STATES.include?(word.force_encoding(Encoding::UTF_8))
	end

	def OrgEnding(word)
		return ORG.include?(word)
	end
	
	def NoLoc(word)
		return NOLOC.include?(word)
	end
end