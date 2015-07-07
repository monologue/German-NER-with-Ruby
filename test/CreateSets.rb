require 'nokogiri'

class CreateSets  < Nokogiri::XML::SAX::Document
	attr_accessor :train, :test, :develop
	@@current_text
	
	def initialize
		@train = 0
		@test = 0
		@develop = 0
	end
	
	def get_text
		@doc = Nokogiri::XML(File.open("tuebadz-9.1-exportXML-v2.xml"))
		#@doc =  Nokogiri::XML(File.open("train.xml"))
		@doc.xpath("//text").each {|text|
			@@current_text = text
			random_text
			puts "test = #{@test}\ttrain = #{@train}\tdevelop = #{@develop}"
			}
	end
	
	def random_text()
		x = rand(10)
		case x
			when 1..3 
				create('train') 
				@train += 1 #Trainingsset
			when 4..6 
				create('develop') 
				@develop += 1#Developmentset
			else 
				create('test') 
				@test +=1 #Testset
		end
	end
	 
	def create(set)
		case set
			when 'test'
				puts "test"
				File.open("test.xml", 'a') {|f| f.write("#{@@current_text}\n")}
			when 'train'
				puts "train"
				File.open("train.xml", 'a') {|f| f.write("#{@@current_text}\n")}
			when 'develop'
				puts "develop"
				File.open("develop.xml", 'a') {|f| f.write("#{@@current_text}\n")}
	
		end
	end
end

c = CreateSets.new
c.get_text
