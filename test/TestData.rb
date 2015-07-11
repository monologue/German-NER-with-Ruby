require_relative "C:/git/German-NER-with-Ruby/src/DocumentHandler.rb"

#class for creating a test-document
class TestData < Nokogiri::XML::SAX::Document
	
	@@current_element = Array.new
	@@org = false
	@@per = false
	@@oth = false
	@@loc = false
	@@ne = Array.new
	
	attr_accessor :texts
	
	def initialize()
		@texts = Array.new
	end
	
	def start_element( name, attrs=[])
	
		if name == 'text'
			t = Text.new(attrs[0][1])
			@@current_element << t
			texts << t
		end
		
		if name == 'sentence'
			s = Sentence.new(attrs[1])
			@@current_element.last.add_content(s)
			@@current_element << s
		end
		
		if name == 'ne'
			n = NE.new(attrs[0][1], attrs[1][1])
			@@ne << n
			case attrs[1][1]
				when "PER" then @@per = true
				when "ORG" then @@org = true
				when "LOC" then @@loc = true
				when "GPE" then @@loc = true
				when "OTH" then @@oth = true
			end

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
			if @@per == true
				w.add_per
			end
			if @@org == true
				w.add_org
			end
			if @@loc == true
				w.add_loc
			end
			if @@oth == true
				w.add_oth
			end
		
			@@current_element.last.add_content(w)
			@@current_element << w
		end
		
	end
	
	def set_ne(ne)
		ne = !ne
	end
	
	def end_element(name, attrs =[])
	
		if name == 'text'
			@@current_element.pop
		end
		
		if name == 'sentence'
			@@current_element.pop
		end
		
		if name == 'ne'
			case @@ne.last.type
				when "PER" then @@per = false
				when "ORG" then @@org = false
				when "LOC" then @@loc = false
				when "GPE" then @@loc = false
				when "OTH" then @@oth = false
			end
			@@ne.pop
			 
			if @@ne.last != nil && @@ne.last.type == 'ORG'
				@@org = true
			end
			
		end
		
		if name == 'word'
			@@current_element.pop
		end	
	end
	
	def end_document
		File.open("C:/git/German-NER-with-Ruby/test/expected/micro.txt", 'a') {|f| f.write("ID" + "\t" + "Word" + "\t" + "Lemma" + "\t" + "Morph" + "\t" + "Func" + "\t" + "PER" + "\t" + "ORG" + "\t" + "LOC" + "\t" + "OTH" + "\n")}
		texts.each {|text|
			text.sentences.each {|sentence|
				write_ner(sentence.sentence_parts)}
		}
	end
	
	def write_ner(sentence)
		sentence.each {|word|
			#if the word is no punctuation mark, it will be written in test.txt
			if word.pos !~ /[$]/
				File.open("C:/git/German-NER-with-Ruby/test/expected/micro.txt", 'a') {|f| f.write(word.id + "\t" + word.form + "\t" + word.lemma + "\t" + word.morph + "\t" + word.func + "\t" + word.per.to_s + "\t" + word.org.to_s + "\t" + word.loc.to_s + "\t" + word.oth.to_s + "\n")}
			else 
			next
			end
		}	
	end	
	
	def new_Element()
		parser = Nokogiri::XML::SAX::Parser.new(self)
		parser.parse_file('C:/git/German-NER-with-Ruby/test/Input/micro.xml')
		#parser.parse_file('micro.xml')
	end
end

class NE

	attr_accessor :name, :type
	
	def initialize(id, type)
		@name = id
		@type = type
	end
end
parser = Nokogiri::XML::SAX::Parser.new(TestData.new)
#parser.parse_file('C:/git/German-NER-with-Ruby/Input/train.xml')
parser.parse_file('C:/git/German-NER-with-Ruby/Input/micro.xml')