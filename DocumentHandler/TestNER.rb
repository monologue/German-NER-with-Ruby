require 'csv'

class TestNER 

	attr_accessor :data1, :data2, :true_per, :true_org, :true_loc, :true_oth, :true_all, :false_per, :false_org, :false_loc, :false_oth, :false_all, :true_negative

	def initialize
		@data1 = CSV.read("out.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		@data2 = CSV.read("test.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		@true_per = 0
		@true_org = 0
		@true_loc = 0
		@true_oth = 0
		@true_all = 0
		@false_per = 0
		@false_org = 0
		@false_loc = 0
		@false_oth = 0
		@false_all = 0
		@true_negative = 0
	end
	
	def read_data()
		compare(data1, data2)
	end
	
	def compare(file1, file2)
		for i in 0..file1.size-1
			if file1[i] == file2[i] 
				if file1[i]['PER'] == 'false' && file1[i]['ORG'] == 'false' && file1[i]['LOC'] == 'false' && file1[i]['OTH'] == 'false'
					@true_negative += 1
				end
=begin
				if file1[i]['ORG'] == 'false'
					@true_negative += 1
				end
				if file1[i]['LOC'] == 'false'
					@true_negative += 1
				end
				if file1[i]['OTH'] == 'false'
					@true_negative += 1
				end
=end
				if file1[i]['PER'] == 'true'
					@true_per = true_per + 1
					@true_all = true_all + 1
				end
				if file1[i]['ORG'] == 'true'
					@true_org = true_org + 1
					@true_all = true_all + 1
				end
				if file1[i]['LOC'] == 'true'
					@true_loc = +1
					@true_all = +1
				end
				if file1[i]['OTH'] == 'true'
					@true_oth = +1
					@true_all = +1
				end
			
			else 
				if file1[i]['PER'] == 'false' && file2[i]['PER'] == 'true'
					#false_negative_per
				end
				if file1[i]['PER'] == 'true' && file2[i]['PER'] == 'false'
					#false_positive_per
				end
				if file1[i]['ORG'] == 'false' && file2[i]['ORG'] == 'true'
					
				end
				if file1[i]['ORG'] == 'true' && file2[i]['ORG'] == 'false'
				
				end
				if file1[i]['LOC'] == 'false' && file2[i]['LOC'] == 'true'
					
				end
				if file1[i]['LOC'] == 'true' && file2[i]['LOC'] == 'false'
				
				end
				if file1[i]['OTH'] == 'false' && file2[i]['OTH'] == 'true'
					
				end
				if file1[i]['OTH'] == 'true' && file2[i]['OTH'] == 'false'
				
				end
			end
		end
		puts "true_all = #{@true_all} \t true_org = #{@true_org}\t true_per = #{true_per}\t false_all = #{true_negative} \t length =  #{file1.length-1}"
	end
	
	def increase(smth)
		@smth = smth + 1
		#parameter wird geclont, ursprüngliche Variable bleibt, smth bleibt local.
		#beim lesen von var kann ohne @ zugegeriffen werden. bei veränderung mit @ zugreifen
	end
	


end

t = TestNER.new()
t.read_data()

