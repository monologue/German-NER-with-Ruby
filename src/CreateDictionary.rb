require 'csv'
class CreateDictionary 

	attr_reader :data
	attr_accessor :dictionary

	def initialize()
		@data = CSV.read("C:/git/German-NER-with-Ruby/test/expected/train.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		

	end

	def read_data()
	end

	def create_dicitionary()
		dictionary = Array.new		
		string = String.new
		for i in 0..data.size-1	
		# for i in 660..675			
			not_same_id = false
			if data[i]["ORG"] == "true"
				puts i
				puts "data: " +data[i]["Word"]
				if string.empty?
					puts "string empty"
					string = data[i]["Word"]
				else
					if i > 1 && position(data[i]['ID']).to_i ==  position(data[i-1]['ID']).to_i + 1
						string += " " + data[i]["Word"]
						puts "string: " + string
					end
				end
					
				if i >= data.size-1 || position(data[i+1]['ID']).to_i !=  position(data[i]['ID']).to_i + 1 || data[i+1]["ORG"] != "true" 
					puts "Writing string:" + string + "!"
					dictionary << string
					string = String.new
				end
 
			end
		end
		# puts dictionary
		dictionary = dictionary.uniq.sort
		

		file = File.open("C:/git/German-NER-with-Ruby/Dictionary/ORG.txt", "a+")
		dictionary.each do |line| 
			file.write(line + "\n")
		end
		file.close
	end

	def position(word)
		positionPattern = /_([0-9]*)/
		word.scan(positionPattern)[0][0]
	end

end

cd = CreateDictionary.new()
cd.create_dicitionary