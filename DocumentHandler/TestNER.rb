require 'csv'

class TestNER 

	attr_accessor :data1, :data2, :true_per, :true_org, :true_loc, :true_oth, :true_all, :false_per, :false_org, :false_loc, :false_oth, :false_all, :true_negative,
					:all_per, :all_loc, :all_org, :all_oth, :false_neg_loc, :false_neg_org, :false_neg_oth, :false_neg_per, :false_true_per, :false_true_org,
					:false_true_loc, :false_true_oth

	def initialize
		@data1 = CSV.read("out.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		@data2 = CSV.read("test.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		@true_per = 0 #was found as a person and is one
		@true_org = 0
		@true_loc = 0
		@true_oth = 0
		@true_all = 0
		@false_per = 0 #was found as a person, but isn't
		@false_neg_per = 0	#wasn't found as a person, but is
		@false_true_per = 0
		@false_org = 0
		@false_neg_org = 0
		@false_true_org
		@false_loc = 0
		@false_neg_loc = 0
		@false_true_loc = 0
		@false_oth = 0
		@false_neg_oth = 0
		@false_true_oth = 0
		@false_all = 0
		@true_negative = 0
		@all_per = 0
		@all_org =0
		@all_loc = 0
		@all_oth = 0
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
					@true_loc += 1
					@true_all += 1
				end
				if file1[i]['OTH'] == 'true'
					@true_oth += 1
					@true_all += 1
				end
			
			else 
				if file1[i]['PER'] == 'false' && file2[i]['PER'] == 'true'
					#false_negative_per
					@false_neg_per = false_neg_per + 1
					@false_all += 1
					if file1[i]['ORG'] == 'true'
						@per_false_org += 1
					end
					if file1[i]['LOC'] == 'true'
						@per_false_loc += 1
					end
					if file1[i]['OTH'] == 'true'
						@per_false_oth += 1
					end
					
				end
				if file1[i]['PER'] == 'true' && file2[i]['PER'] == 'false'
					#false_positive_per
					@false_true_per += 1
					@false_all += 1
					
				end
				if file1[i]['ORG'] == 'false' && file2[i]['ORG'] == 'true'
					#false_negative_per
					@false_neg_org = false_neg_org + 1
					@false_all += 1
					if file1[i]['PER'] == 'true'
						@org_false_per += 1
					end
					if file1[i]['LOC'] == 'true'
						@org_false_loc += 1
					end
					if file1[i]['OTH'] == 'true'
						@org_false_oth += 1
					end
				end
				if file1[i]['ORG'] == 'true' && file2[i]['ORG'] == 'false'
					@false_true_org += 1
					@false_all += 1
				end
				if file1[i]['LOC'] == 'false' && file2[i]['LOC'] == 'true'
					#false_negative_per
					@false_neg_loc = false_neg_loc + 1
					@false_all += 1
					if file1[i]['ORG'] == 'true'
						@loc_false_org += 1
					end
					if file1[i]['PER'] == 'true'
						@loc_false_per += 1
					end
					if file1[i]['OTH'] == 'true'
						@loc_false_oth += 1
					end
					
				end
				if file1[i]['LOC'] == 'true' && file2[i]['LOC'] == 'false'
					@false_true_loc += 1
					@false_all += 1
				end
				if file1[i]['OTH'] == 'false' && file2[i]['OTH'] == 'true'
					#false_negative_per
					@false_neg_oth = false_neg_oth +1
					@false_all += 1
					if file1[i]['ORG'] == 'true'
						@oth_false_org += 1
					end
					if file1[i]['LOC'] == 'true'
						@oth_false_loc += 1
					end
					if file1[i]['PER'] == 'true'
						@oth_false_per += 1
					end
					
				end
				if file1[i]['OTH'] == 'true' && file2[i]['OTH'] == 'false'
					@false_true_oth += 1
					@false_all += 1
				end
			end
		end
		puts "true_all = #{@true_all} \t true_org = #{@true_org}\t true_per = #{true_per}\t false_all = #{true_negative}
			\rlength =  #{file1.length-1}\t false= #{false_all} \t false per= #{false_neg_per} \t false oth= #{false_neg_oth}
			\rfalse loc= #{false_neg_loc} \t false org= #{false_neg_org}"
	end

end

t = TestNER.new()
t.read_data()

