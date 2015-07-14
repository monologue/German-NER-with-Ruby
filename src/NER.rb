require_relative 'RuleHandler.rb'
require_relative 'DocumentHandler.rb'
require_relative 'Rule.rb'
require 'nokogiri'
require 'csv'

class NER < Nokogiri::XML::SAX::Document

  def ner_main
    File.open("../Output/out-develop.txt", 'w') {|f| f.write("ID" + "\t" + "Word" + "\t" + "PER" + "\t" + "ORG" + "\t" + "LOC" + "\t" + "OTH" + "\t" + "Rules" + "\n")}
    data = DocumentHandler.new 
    data.new_Element()  
    r = RuleHandler.new
    #r.read_rules("Rules.txt")
    r.read_rules("single_rule.txt")

    data.texts.each {|text|
      r.rules.each do |rule|
        text.sentences.each {|sentence|
          line = 0
          while line < sentence.sentence_parts.length
            if rule.matched?(text, sentence.sentence_parts, line)   
              rule.apply(sentence.sentence_parts, line)
            end
            line = line + 1
          end
        }
      end
      write_ner(text)
    }
  end 
  
  def write_ner(text)
    text.sentences.each {|sentence|
      sentence.sentence_parts.each {|word|
        if word.pos !~ /[$]/
          File.open("../Output/out-develop.txt", 'a') {|f| f.write(word.id + "\t" + word.form + "\t" + word.per.to_s + "\t" + word.org.to_s + "\t" + word.loc.to_s + "\t" + word.oth.to_s + "\t" + word.rules.to_s + "\n")}
        end
      }
    }
  end

end

N = NER.new
N.ner_main