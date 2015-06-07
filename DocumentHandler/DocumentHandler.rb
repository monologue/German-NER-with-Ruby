require 'nokogiri'
filename = 'micro.xml'
#require 'parts.rb'
=begin
The class DocumentHandler takes a xml-Document (in this case mini.xml) and parses it with Nokogiris Saxparser.
Therefore the methods start_element und end_element looksup elements in the data and performes tasks when they 
arrive.
The DocumentHandler creates three arrays: text, sentence and word.
=end
#this class parses the input-document and gives back an array for every text.
class DocumentHandler < Nokogiri::XML::SAX::Document
	attr_accessor :texts
	@@count_text = 0
	@@current_element = Array.new
	
	def initialize()
		@texts = Array.new
	end
	
	def start_element( name, attrs=[])
=begin		if @@count_text == 1 #only in purpose of testing
				return
			end
=end
		#Create a new instance of type Text for every text and push it to the @@current_element array.
		if name == "text"
			t = Text.new(attrs[0][1])
			@@current_element << t
			texts << t
		end
		#Create a new instance of type Sentence for every sentence and push it to the @@current_element array.
		if name == 'sentence'
			s = Sentence.new(attrs[1])
			@@current_element.last.add_content(s)
			@@current_element << s
		end
		
		if name == 'word'
			#if attrs.length == 8
				#puts attrs.length
#end
			case attrs[3][0]
				when "morph"
					if attrs.length == 10
						w = Word.new(attrs[0][1], attrs[1][1], attrs[2][1], attrs[4][1], attrs[5][1], attrs[6][1], attrs[3][1], attrs[7][1], attrs[8][1])
					end
					if attrs.length == 9
						w = Word.new(attrs[0][1], attrs[1][1], attrs[2][1], attrs[4][1], attrs[5][1], attrs[6][1], attrs[3][1], attrs[7][1], attrs[8][1])
					end
					if attrs.length == 8
						w = Word.new(attrs[0][1], attrs[1][1], attrs[2][1], attrs[5][1], attrs[7][1], attrs[6][1], attrs[4][1], attrs[3][1])
					end
					if attrs.length == 7
						w = Word.new(attrs[0][1], attrs[1][1], attrs[2][1], attrs[4][1], attrs[5][1], attrs[3][1], attrs[6][1])
					end
				when "lemma"
					w = Punctuation.new(attrs[0][1], attrs[1][1], attrs[2][1], attrs[3][1], attrs[4][1], attrs[5][1])
				when "func"
					w = Word.new(attrs[0][1], attrs[1][1], attrs[2][1], attrs[3][1], attrs[6][1], attrs[4][1], attrs[5][1])
			end
			w.get("deprel")
			@@current_element.last.add_content(w)
			@@current_element << w
		end
		
		if name == 'node'
			case attrs.length
				when 3
					n = Knoten.new(attrs[0][1], attrs[1][1], attrs[2][1])
				when 4
					n = Knoten.new(attrs[0][1], attrs[1][1], attrs[2][1], attrs[3][1])
				when 2 
					n = Knoten.new(attrs[0][1], attrs[1][1])
			end
			@@current_element.last.add_content(n) 
			@@current_element << n
		end

		if name == 'ne'
			ne = NE.new(attrs[0][1], attrs[1][1])
			@@current_element.last.add_content(ne) 
			@@current_element << ne
		end
	end
	
	def end_element(name)
		if name =='text'
			puts @@current_element.last.id
			@@current_element.pop
		end
		if name == 'sentence'
				@@current_element.pop
		end
		if name == 'node'
				@@current_element.pop
		end
		if name == 'word'
				@@current_element.pop
		end
		if name == 'ne'
			if @@current_element[-1] =! @@current_element.first
				@@current_element.pop
			end
				
		end
	end

	
	def end_document
		#texts.each { |text|
		#	text.sentences.each { |sentence|
		#		sentence.print()}}
	end
	
	#this method simply counts the number of texts and sentences existing in the input-document.
	def count_frequency(name)
		if name == 'text'
			@@count_text += 1
		end
		if name == 'sentence'
			@@count_sentence += 1
		end
	end	

end

class Text

	attr_accessor :id, :sentences
	
	def initialize(name)
		@id = name
		@sentences = Array.new
	end
	
#This method adds an sentence to the sentences
	def add_content(obj)
		sentences << obj
	end
	
	def get_current_sentence
		return sentences.last(1)
	end
end

class Sentence

	attr_accessor :id, :satzzeichen, :sentence_parts, :NE
	
	def initialize(name)
		@satzzeichen = String.new
		@sentence_parts = Array.new
		@NE = false
		@id = name
	end
	
	def add_content(obj)
		sentence_parts << obj
	end
	
	def print()
		sentence_parts.each {|part|
			part.print()}
	end
end

class Knoten 
	attr_accessor :func, :parent, :category, :knoten, :id
	category_list = %w{ADJX ADVY DP FX NX PX VXFIN VXINF LV C FKOORD KOORD LK MF MFE NF PARORD VC VCE VF FKONJ DM P-SIMPX R-SIMPX SIMPX}
	def initialize(name, category, func = "empty", parent = "empty")
		@id = name
		@func = func 
		@parent = parent 
		@category = category 
		@knoten = Array.new
	end
	
	def add_content(obj)
		knoten << obj
	end
	
	def print()
		#puts knoten
		knoten.each {|k|
			k.print()} # NoMethodError: private method 'print' called for nil:NilClass ?
	end
end

class Word

	attr_accessor :id, :form, :lemma, :pos, :morph, :func, :parent, :deprel, :dephead
	
	pos_list = %w[ADJA ADJD ADV APPR APPRART APPO APZR ART CARD FM ITJ KOUI KOUS KON KOKOM NN NE PDS PIS PIAT PIDAT PPER PPOSS PPOSAT PRELS PRELAT PRF PWS PWAT PWAV PROP PTKZU PTKNEG PTKVZ PTKANT PTKA TRUNC VVFIN VVIMP VVINF VVIZU VVPP VAFIN VAIMP VAINF VAPP VMFIN VMINF VMPP XY]
=begin	
	def initialize(name, form, pos, func, deprel, parent, lemma = "empty", morph = "empty",  dephead = "empty")
		@id = name
		@form = form
		@lemma = lemma
		@pos = pos
		@morph = morph
		@func = func
		@parent = parent
		@deprel = deprel
	end
=end
	def initialize(name)
		@id = name
	end
	
	def add_form(form)
		@form = form
	end
	
	def add_pos(pos)
		@pos = pos
	end
	
	def add_func(func)
		@func = func
	end
	
	def add_deprel(deprel)
		@deprel = deprel
	end
	
	def add_parent(parent)
		@parent = parent
	end
	
	def add_lemma(lemma)
		@lemma = lemma
	end
	
	def add_morpg(morph)
		@morph = morph
	end
	
	def add_dephead(dephead)
		@dephead = dephead
	end
	
	def differentiate
		if pos == punctuation
			Punctuation.new()
		end
		if pos =! pos_list
			puts "/n Fehler, unbekanntes pos /n" 
		end
	end
	def print()
		puts form
	end
	def get(value)
		case value
			when "id"
				return id
			when "form"
				return form
			when "pos"
				return pos
			when "func"
				puts func
			when "deprel"
				return deprel
			when "parent"
				return parent
			when "lemma"
				return lemma
			when "morph"
				return moprh
			when "dephead"
				return dephead
		end
	end
end

class Punctuation
	attr_accessor :if, :form, :pos, :lemma, :func, :deprel
	punctuation = ["$,","$.","$("]
	def initialize(name, form, pos, lemma, func, deprel)
		@id = name
		@form = form
		@pos = pos
		@lemma = lemma
		@func = func
		@deprel = deprel
	end
	
	def print()
		puts form
	end
	
	def get(value)
	end
	
end

class NE
	attr_accessor :type, :ne, :id
	type_list = %w{ORG OTH LOC GPE PER}
	def initialize(name, type)
		@id = name
		@type = type
		@ne = Array.new
	end
	
	def add_content(obj)
		ne << obj
	end
	
	def print()
		ne.each {|part|
			part.print}
	end
	def get(value)
	end
end

class NER
	attr_accessor :rules, :sentences
	
	def initialize
		@rules = Array.new
		@sentences = Array.new
	end
	
	#reads the rules and calls split_rule for every line, one line contains one rule
	def read_rules
		File.readlines(RULES).each do |line|
			@rules << split_rule(line)
		end
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
			#puts string.scan(splitPattern)[3].to_i
			r.add_length(string.scan(splitPattern)[0][2].to_i)
			#puts r.length
			r.add_category(string.scan(splitPattern)[0][0].to_s)
			#puts r.category
			r.add_start(string.scan(splitPattern)[0][1])
		return r
	end
	
	#splitting the ruleParts/conditions into the three elements feature, position, value
	def condition_parts(string)
		splitPattern = /\w+\.[a-zA-Z]+|\w+/ # Klammern hinzugefügt, noch nicht getestet!
		element = string.scan(splitPattern)
		#test
		#if element[2].start_with?("ElementOf") then puts element[2]
		#end
		case element[0]
			when "POS" then  return POSCondition.new(element[1].to_i, element[2])							
			when "token" then return TokenCondition.new(element[1].to_i, element[2].to_s)
		end
		
	end
	def get_input()
	end
end
parser = Nokogiri::XML::SAX::Parser.new(DocumentHandler.new)
parser.parse_file('micro.xml')










