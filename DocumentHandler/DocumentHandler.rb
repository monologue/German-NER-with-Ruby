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
		end
		#Create a new instance of type Sentence for every sentence and push it to the @@current_element array.
		if name == 'sentence'
			s = Sentence.new(attrs[1])
			@@current_element.last.add_content(s)
			@@current_element << s
		end
		if name == 'word'
			w = Word.new(attrs[0,1], attrs[1,1])
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
			texts << @@current_element
			@@current_element.pop
			#puts texts.to_s
		end
		if name == 'sentence'
			#puts @@current_element.last.to_s
			#if @@current_element[-1] =! @@current_element.first
				@@current_element.pop
			#end
		end
		if name == 'node'
			#puts @@current_element.last.id
			#if @@current_element[-1] =! @@current_element.first
				@@current_element.pop
			#end
		end
		if name == 'word'
			#puts @@current_element.last.to_s
			#if @@current_element[-1] =! @@current_element.first
				@@current_element.pop
			#end
		end
		if name == 'ne'
			if @@current_element[-1] =! @@current_element.first
				@@current_element.pop
			end
				
		end
	end

	
	def end_document
		texts.each { |sentences|
			sentences.each { |parts|
					puts parts.to_s}}
		#funktioniert, aber wie Kontrolle? wie iterieren?		
		#puts texts[1][0].sentences[0].sentence_parts[1]
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
end

class Word

	attr_accessor :id, :form, :lemma, :pos, :morph, :func, :parent, :deprel
	
	pos_list = %w[ADJA ADJD ADV APPR APPRART APPO APZR ART CARD FM ITJ KOUI KOUS KON KOKOM NN NE PDS PIS PIAT PIDAT PPER PPOSS PPOSAT PRELS PRELAT PRF PWS PWAT PWAV PROP PTKZU PTKNEG PTKVZ PTKANT PTKA TRUNC VVFIN VVIMP VVINF VVIZU VVPP VAFIN VAIMP VAINF VAPP VMFIN VMINF VMPP XY]
	punctuation = ["$,","$.","$("]
	
	def initialize(name, form = "empty")
		@id = name
		@form = form
	end
	
	def differentiate
		if pos == punctuation
			Punctuation.new()
		end
		if pos =! pos_list
			puts "/n Fehler, unbekanntes pos /n" 
		end
	end
end

class Punctuation

	def initialize()
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
end
parser = Nokogiri::XML::SAX::Parser.new(DocumentHandler.new)
parser.parse_file('micro.xml')