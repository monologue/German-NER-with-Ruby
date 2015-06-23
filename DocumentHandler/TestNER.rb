require 'csv'

class TestNER 

	attr_accessor :data1, :data2, :true_per, :true_org, :true_loc, :true_oth, :true_all, :false_per, :false_org, :false_loc, :false_oth, :false_all

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
	end
	
	def read_data()
		compare(data1, data2)
	end
	
	def compare(file1, file2)
		for i in 0..file1.size-1
			if file1[i] == file2[i] 
				if file1[i]['PER'] == 'true'
					true_positive_per
					true_positive_all
				end
				if file1[i]['ORG'] == 'true'
					true_positive_org
					true_positive_all
				end
				if file1[i]['LOC'] == 'true'
					true_positive_loc
					true_positive_all
				end
				if file1[i]['OTH'] == 'true'
					true_oth
					true_all
				end
				if file1[i]['PER'] == 'false' && file1[i]['ORG'] == 'false'
					#puts file1[i]['Word']
				end
			end
		end
		puts "true_all = #{true_all} \t true_org = #{true_org}\t true_per = #{true_per}"
	end
	
	
	def true_positive_all
		increase(true_all)
	end
	
	def false_positive
	end
	
	def true_negative
	end
	
	def false_negative
	end
	
	def true_positive_per
		increase(true_per)
	end
	
	def false_positive_per
	end
	
	def true_negative_per
	end
	
	def false_negative_per
	end
	
	def true_positive_org
		increase(true_org)	
	end
	
	def false_positive_org
	end
	
	def true_negative_org
	end
	
	def false_negative_org
	end
	
	def true_positive_loc
		
	end
	
	def false_positive_loc
	end
	
	def true_negative_loc
	end
	
	def false_negative_loc
	end
	
	def true_positive_oth
		
	end
	
	def false_positive_oth
	end
	
	def true_negative_oth
	end
	
	def false_negative_oth
	end
	
	def increase(smth)
		smth = smth + 1
	end
end

t = TestNER.new()
t.read_data()

