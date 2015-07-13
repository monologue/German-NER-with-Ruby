require_relative 'RuleHandler.rb'
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
		if name == "text"
			t = Text.new(attrs[0][1])
			@@current_element << t
			texts << t
		end
		
		if name == 'sentence'
			s = Sentence.new(attrs[1])
			@@current_element.last.add_content(s)
			@@current_element << s
		end
		
		if name == 'word'
			w = Word.new(attrs[0][1])
			attrs.each {|attribute|
				case attribute[0]
					when "xml:id" then #do nothing
					when "form" then w.add_form(attribute[1])
					when "pos" then w.add_pos(attribute[1])
					when "lemma" then w.add_lemma(attribute[1])
					when "morph" then w.add_morph(attribute[1])
					when "func" then w.add_func(attribute[1])
					when "parent" then w.add_parent(attribute[1])
					when "deprel" then w.add_deprel(attribute[1])
					when "dephead" then w.add_dephead(attribute[1])
					when "comment" #do nothing
					when "wsd-lexunits" #do nothing
					else puts "Fehler!\n ------------------\n #{w.id} #{attribute} in DocumentHandler start_element"
				end
			}
			@@current_element.last.add_content(w)
			@@current_element << w
		end
	end

	def end_element(name)
		if name =='text'
			@@current_element.pop
		end
		if name == 'sentence'
				@@current_element.pop
		end
		if name == 'word'
				@@current_element.pop
		end
	end

	def new_Element()
		parser = Nokogiri::XML::SAX::Parser.new(self)
		#parser.parse_file('C:/git/German-NER-with-Ruby/Input/train.xml')
		parser.parse_file('C:/git/German-NER-with-Ruby/Input/develop.xml')
		#parser.parse_file('C:/git/German-NER-with-Ruby/Input/micro.xml')
	end

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

	attr_accessor :id, :sentences, :ne_per, :ne_org, :ne_oth, :ne_loc
	
	def initialize(name)
		@id = name
		@sentences = Array.new
		@ne_per = Array.new
		@ne_org = Array.new
		@ne_oth = Array.new
		@ne_loc = Array.new
	end
	
	def add_content(obj)
		sentences << obj
	end		

end

class Sentence

	attr_accessor :id, :sentence_parts, :NE
	
	def initialize(name)
		@sentence_parts = Array.new
		@NE = false
		@id = name
	end
	
	def add_content(obj)
		sentence_parts << obj
	end

end

class Word

	attr_accessor :id, :form, :lemma, :pos, :morph, :func, :parent, :deprel, :dephead, :ne_type, :ne, :punctuation, :per, :org, :loc, :oth, :rules
	
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
		@rules = Array.new
		@morph = "default"
		@func = "default"
		@lemma = "default"
	end
	
	def add_rule(string)
		@rules << string
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
	def del_per()
		@per = false
	end
	def del_loc()
		@loc = false
	end
	def del_org()
		@org = false
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

end