=begin
The class DocumentHandler takes a xml-Document (in this case mini.xml) and parses it with Nokogiris Saxparser.
Therefore the methods start_element und end_element looksup elements in the data and performes tasks when they 
arrive.
The DocumentHandler creates three arrays: text, sentence and word.
=end
#this class parses the input-document and gives back an array for every text.

require_relative 'RuleHandler.rb'
#require_relative 'DocumentHandler.rb'
require_relative 'Rule.rb'
require 'nokogiri'
require 'csv'
class DocumentHandler < Nokogiri::XML::SAX::Document
	attr_accessor :texts, :rules
	@@count_text = 0
	@@current_element = Array.new
	@@ne = nil
	
	def initialize()
		@texts = Array.new
		@rules = Array.new
	end
	
	def get_texts()
		puts @texts
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
			w = Word.new(attrs[0][1])
			attrs.each {|attribute|
				case attribute[0]
					when "xml:id"
						#do nothing
					when "form"
						w.add_form(attribute[1])
					when "pos"
						w.add_pos(attribute[1])
					when "lemma"
						w.add_lemma(attribute[1])
					when "morph"
						w.add_morph(attribute[1])
					when "func"
						w.add_func(attribute[1])
					when "parent"
						w.add_parent(attribute[1])
					when "deprel"
						w.add_deprel(attribute[1])
					when "dephead"
						w.add_dephead(attribute[1])
					when "comment" #do nothing
					when "wsd-lexunits" #do nothing
					else puts "Fehler!\n ----------------------------------------------------------------\n #{w.id} #{attribute}"
					end
					
				}
				#puts w.id
			@@current_element.last.add_content(w)
			@@current_element << w
		end
	
		#if name == 'ne'
		#	@@ne = attrs[1][1]		
		#	puts @@ne
		#end
	end

	def end_element(name)
		if name =='text'
			@@current_element.pop
		end
		if name == 'sentence'
				@@current_element.pop
		end
		if name == 'word'
			#if @@ne == nil
				@@current_element.pop
			#else @@current_element.last.add_ne(@@ne)
				#case @@ne
					#when "ORG"
					#	@@current_element.last.add_org
					#when "PER"
					#	@@current_element.last.add_per
					#when "OTH"
					#	@@current_element.last.add_oth
					#when "LOC"
					#	@@current_element.last.add_loc
				#end
				#@@current_element.pop
			#end
		end
		#if name == 'ne'
		#	@@ne = nil
		#end
		
	end

	def new_Element()
		parser = Nokogiri::XML::SAX::Parser.new(self)
		parser.parse_file('micro.xml')
	end

	def end_document
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

	attr_accessor :id, :sentences, :ne_per, :ne_org, :ne_oth
	
	def initialize(name)
		@id = name
		@sentences = Array.new
		@ne_per = Array.new
		@ne_org = Array.new
		@ne_oth = Array.new
	end
	
#This method adds an sentence to the sentences
	def add_content(obj)
		sentences << obj
	end
	
	def get_current_sentence
		return sentences.last(1)
	end
	
	def current_lexicon(word, type)
		case type
		when "ORG" && ne_org.include?(word) == false
			ne_org << word
		when "PER" 
			if ne_per.include?(word) == false
				ne_per << word
			end
		when "OTH" && ne_oth.include?(word) == false
			ne_oth << word
		end
	end
	
	def check_lexicon(word)
		return ne_per.include?(word)
		 
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
	
	#print-method for testing purpose
	def print()
		sentence_parts.each {|word|
			word.print()}
	end
	
	def output
		sentence_parts.each {|word|
			word.output()}
	end
end
=begin
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
=end
class Word

	attr_accessor :id, :form, :lemma, :pos, :morph, :func, :parent, :deprel, :dephead, :ne_type, :ne, :punctuation, :per, :org, :loc, :oth
	
	@@pos_list = %w[ADJA ADJD ADV APPR APPRART APPO APZR ART CARD FM ITJ KOUI KOUS KON KOKOM NN NE PDS PDAT PIS PIAT PIDAT PPER PPOSS PPOSAT PRELS PRELAT PRF PWS PWAT PWAV PROP PTKZU PTKNEG PTKVZ PTKANT PTKA TRUNC VVFIN VVIMP VVINF VVIZU VVPP VAFIN VAIMP VAINF VAPP VMFIN VMINF VMPP XY]
	@@punctuation = ["$,","$.","$("]
	
	def initialize(name)
		@id = name
		@ne = false
		@punctuation = false
		@loc = false
		@org = false
		@per = false
		@oth = false
	end
	def add_loc()
		@loc = true
	end
	def add_org()
		@org = true
	end
	def add_per()
		@per = true
	end
	def add_oth()
		@oth = true
	end
	def add_ne(ne)
		@ne = true
		@ne_type = ne
	end
	
	def add_form(form)
		@form = form
	end
	
	def add_pos(pos)
		if @@pos_list.include?(pos)
			@pos = pos
		else if @@punctuation.include?(pos)
			@pos = pos
			@punctuation = true
		else puts "------------------------------\n Fehler! Unbekanntes POS \n -------------------------------------------#{id}"
			exit
		end
		end
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
	
	def add_morph(morph)
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
	
	def output
		w = [id, lemma, pos]
	end
	
end


#parser = Nokogiri::XML::SAX::Parser.new(DocumentHandler.new)
#parser.parse_file('micro.xml')









