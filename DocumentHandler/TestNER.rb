require 'csv'

class TestNER 

	attr_accessor :data1, :data2, :count, :found, :wrong_found, :Columns, :not_ne
	def initialize
		@data1 = CSV.read("out.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		@data2 = CSV.read("train.txt", {col_sep: "\t", quote_char: "\0", headers: true})
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
		same = true
		for i in 0..file1.size-1
		if file1[i]['Word'] =! file2[i]['Word']
			puts file1[i]['Word']
			puts i
			exit
		end
			@Columns.each {|col|
				if file1[i][col] != file2[i][col] && file2[i][col] == 'true' && file1[i][col] == 'false'
					@count[col] += 1
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
				end
				
			}
		end
		
		ne = count['PER']+count['ORG']+count['LOC']+count['OTH']
		puts "per: #{count['PER']}\tper gefunden: #{found['PER']}\torg: #{count['ORG']}\torg gefunden: #{found['ORG']}\tloc: #{count['LOC']}loc gefunden: #{found['LOC']}\toth: #{count['OTH']}\toth gefunden: #{found['OTH']}
		\rne: #{count['PER']+count['ORG']+count['LOC']+count['OTH']}\tnot_ne: #{(file2.size-1)-ne} or: #{not_ne}" 
=begin
		puts "ne: #{ne}\t nicht ne: #{file2.size-1-ne} \tne gefunden: #{ne_gefunden}\tnicht gefunden: #{ne_nicht_gefunden}
		per: #{per}\tper gefunden: #{per_gefunden}\tfalsch gefunden: #{per_falsch_gef}
		org: #{org}\torg gefunden: #{org_gefunden}\tfalsch gefunden: #{org_falsch_gef}
		loc: #{loc}\tloc gefunden: #{loc_gefunden}\t\tfalsch gefunden: #{loc_falsch_gef}
		oth: #{oth}\toth gefunden: #{oth_gefunden}\t\tfalsch gefunden: #{oth_falsch_gef}"
=end

end
end

t = TestNER.new()
t.read_data()

