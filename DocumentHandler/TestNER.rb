require 'csv'

class TestNER 

	attr_accessor :data1, :data2

	def initialize
		@data1 = CSV.read("out.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		@data2 = CSV.read("test.txt", {col_sep: "\t", quote_char: "\0", headers: true})
	end
	
	def read_data()
		compare(data1, data2)
	end
	
	def compare(file1, file2)
		#file1.each_with_index {|line, index|
		file1.each_with_index {|row, line|
			file2.each {|row2|
				if row['PER'] == true && row['PER'] == row2['PER']
					#if row['PER'] == row2['PER']
						puts row['Word']
					#end
				end
			}
		}
	end
=begin
			for i in 0..file1.size
			if file1[i] == file2[i]
				#puts "Same #{file1[i]}"
			else
				#puts "#{file1[i]} != #{file2[i]}"
			end
=end
	
	
	def true_positive
		
	end
	
	def false_positive
	end
	
	def true_negative
	end
	
	def false_negative
	end
	
	def true_positive_per
		
	end
	
	def false_positive_per
	end
	
	def true_negative_per
	end
	
	def false_negative_per
	end
	
	def true_positive_org
		
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
end

t = TestNER.new()
t.read_data()

