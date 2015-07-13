require 'csv'
require 'json'

class TestNER 

	attr_accessor :data1, :data2, :count, :found, :wrong_found, :Columns, :rules_quality

	def initialize
		@data1 = CSV.read("../Output/out-develop.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		@data2 = CSV.read("../test/expected/develop.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		@count = { "PER" => 0,  "ORG" => 0, "LOC" => 0, "OTH" => 0}
		@found = { 'PER' => 0,  "ORG" => 0, "LOC" => 0, "OTH" => 0}
		@wrong_found = { "PER" => 0,  "ORG" => 0, "LOC" => 0, "OTH" => 0}
		@Columns = ['Word','PER', 'ORG', 'LOC', 'OTH']
		@rules_quality = Array.new
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
					JSON.parse(file1[i]["Rules"]).each {|key|
						if key.to_i < 0 && rules_quality[-key.to_i]["type"] == col
							@rules_quality[-key.to_i]["false_positive"] += 1
						end
					}
				end

				if file1[i][col] == file2[i][col]
					if (file1[i][col] == 'true')
						@found[col] += 1
						@count[col] += 1
						JSON.parse(file1[i]["Rules"]).each {|key|
							if key.to_i >= 0 && @rules_quality[key.to_i]["type"] == col
								@rules_quality[key.to_i]["correct"] += 1
							end
						}
					end

					if (file1[i][col] == 'false')
						JSON.parse(file1[i]["Rules"]).each {|key|
							if key.to_i < 0 && @rules_quality[-key.to_i]["type"] == col
								@rules_quality[-key.to_i]["correct"] += 1
							end
						}
					end
				end

				if file1[i][col] != file2[i][col] && file1[i][col] == 'true' && file2[i][col] == 'false'
					@wrong_found[col] += 1
					JSON.parse(file1[i]["Rules"]).each {|key|
						if key.to_i >= 0 && @rules_quality[key.to_i]["type"] == col
							@rules_quality[key.to_i]["false_positive"] += 1
						end
					}
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
		\rne: #{count['PER']+count['ORG']+count['LOC']+count['OTH']}" 
	end
	
	def write_false_data(id, word, ne, rules)
		File.open("../test/false/#{ne}.txt", 'a') {|f| f.write(id + "\t" + word + "\t" + ne + "\t" + rules + "\n")}
	end
	
	def write_not_found_data(id, word, ne)
		File.open("../test/notfound/#{ne}.txt", 'a') {|f| f.write(id + "\t" + word + "\t" + ne + "\n")}
	end

	def write_rules_quality(filename)
		File.open("../test/"+filename, 'w') {|f| 
			f.write("ID" + "\t" + "type" + "\t" + "correct" + "\t" + "false_positive" + "\n")
			rules_quality.each {|rule|
				f.write(rule["id"].to_s + "\t" + rule["type"] + "\t" + rule["correct"].to_s + "\t" + rule["false_positive"].to_s + "\n")
			}
		}
	end

	def read_rules(filename)
		File.readlines(filename).each do |line|
			type = line.scan(/=>\s(\w{3})/)[0][0]
			@rules_quality.push({"id" => @rules_quality.length, "type" => type, "correct" => 0, "false_positive" => 0})
		end
	end

end

t = TestNER.new()
t.read_rules("../Rules/Oth_Rules.txt")
t.read_data()
t.write_rules_quality("quality.txt")