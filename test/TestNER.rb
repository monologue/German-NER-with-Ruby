# encoding: UTF-8
require 'csv'

class TestNER 

	attr_accessor :data1, :data2, :count, :found, :wrong_found, :Columns, :not_ne
	def initialize
		@data1 = CSV.read("C:/git/German-NER-with-Ruby/Output/out.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		@data2 = CSV.read("C:/git/German-NER-with-Ruby/test/expected/train.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		#@data1 = CSV.read("C:/git/German-NER-with-Ruby/Output/outm.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		#@data2 = CSV.read("C:/git/German-NER-with-Ruby/test/expected/micro.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		
		@count = { "PER" => 0,  "ORG" => 0, "LOC" => 0, "OTH" => 0}
		@found = { 'PER' => 0,  "ORG" => 0, "LOC" => 0, "OTH" => 0}
		@wrong_found = { "PER" => 0,  "ORG" => 0, "LOC" => 0, "OTH" => 0}
		@Columns = ['Word','PER', 'ORG', 'LOC', 'OTH']
		@not_ne = 0
	end
	
	def read_data()
		compare(data1, data2)
	end
	
	def compare(file1, file2)
		for i in 0..file1.size-1
		if file1[i]['Word'] =! file2[i]['Word']
			puts "Wörter in Output und Testdatei ungleich in Zeile #{i}"
			exit
		end
			@Columns.each {|col|
				if file1[i][col] != file2[i][col] && file2[i][col] == 'true' && file1[i][col] == 'false'
					@count[col] += 1
					write_not_found_data(file1[i]['ID'], file2[i]['Word'], col)
				end
				if file1[i][col] == file2[i][col]
					if (file1[i][col] == 'true')
						@found[col] += 1
						@count[col] += 1
					end
					if (file1[i][col] == 'false')
						@not_ne += 1
					end
				end
				if file1[i][col] != file2[i][col] && file1[i][col] == 'true' && file2[i][col] == 'false'
					@wrong_found[col] += 1
					@not_ne += 1
					
					write_false_data(file1[i]['ID'], file2[i]['Word'], col, file1[i]['Rules'])
				end
				
			}
		end
		output()
	end	
		
	def output()
		ne = count['PER']+count['ORG']+count['LOC']+count['OTH']
		puts "per: #{count['PER']}\tper gefunden: #{found['PER']}\tfalsch gef: #{wrong_found['PER']}\torg: #{count['ORG']}\torg gefunden: #{found['ORG']}\tfalsch gef: #{wrong_found['ORG']}
		\rloc: #{count['LOC']}loc gefunden: #{found['LOC']}\tfalsch gef: #{wrong_found['LOC']}\toth: #{count['OTH']}\toth gefunden: #{found['OTH']}\tfalsch gef: #{wrong_found['OTH']}
		\rne: #{count['PER']+count['ORG']+count['LOC']+count['OTH']}\tnot_ne: #{(data2.size-1)-ne} or: #{not_ne}" 
	end
	
	def write_false_data(id, word, ne, rules)
		File.open("C:/git/German-NER-with-Ruby/test/false/#{ne}.txt", 'a') {|f| f.write(id + "\t" + word + "\t" + ne + "\t" + rules + "\n")}
	end
	
	def write_not_found_data(id, word, ne)
		File.open("C:/git/German-NER-with-Ruby/test/notfound/#{ne}.txt", 'a') {|f| f.write(id + "\t" + word + "\t" + ne + "\n")}
	end
end

t = TestNER.new()
t.read_data()

