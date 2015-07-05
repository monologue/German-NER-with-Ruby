require 'csv'

class TestNER 

	attr_accessor :data1, :data2, :per, :org, :loc, :oth, :ne, :not_ne, :ne_gefunden, :ne_nicht_gefunden, :per_gefunden, :org_gefunden, :oth_gefunden, :loc_gefunden, :per_falsch_gef, :org_falsch_gef, :loc_falsch_gef, :oth_falsch_gef
	def initialize
		@data1 = CSV.read("out.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		@data2 = CSV.read("test.txt", {col_sep: "\t", quote_char: "\0", headers: true})
		@org = 0
		@per = 0
		@ne = 0
		@loc = 0
		@oth = 0
		@not_ne = 0
		@ne_gefunden = 0
		@ne_nicht_gefunden = 0
		@per_gefunden = 0
		@org_gefunden = 0
		@loc_gefunden = 0
		@oth_gefunden = 0
		@per_falsch_gef = 0
		@org_falsch_gef = 0
		@loc_falsch_gef = 0
		@oth_falsch_gef = 0
		
	end
	
	def read_data()
		compare(data1, data2)
	end
	
	def compare(file1, file2)
		#Array.try_convert(file1[0])
		#puts file1[0][0..2].to_s
		for i in 0..file1.size-1
			if file2[i]['PER'] == 'true' || file2[i]['ORG'] == 'true' || file2[i]['LOC'] == 'true' || file2[i]['OTH'] == 'true'
				@ne += 1
			end
			if file1[i] == file2[i] 
				if file1[i]['PER'] == 'false' && file1[i]['ORG'] == 'false' && file1[i]['LOC'] == 'false' && file1[i]['OTH'] == 'false'
					@not_ne += 1
				end
				if file1[i]['PER'] == 'true'
					@per += 1
					@per_gefunden += 1
					@ne_gefunden += 1
				end
				if file1[i]['ORG'] == 'true'
					@org += 1
					@org_gefunden += 1
					@ne_gefunden += 1
				end
				if file1[i]['LOC'] == 'true'
					@loc += 1 
					@loc_gefunden += 1 
					@ne_gefunden += 1
				end
				if file1[i]['OTH'] == 'true'
					@oth += 1 
					@oth_gefunden += 1
					@ne_gefunden += 1
				end
			
			else 
				if file2[i]['PER'] == 'true' && file1[i]['PER'] == 'false' || file2[i]['ORG'] == 'true'  && file1[i]['ORG'] == 'false'|| file2[i]['LOC'] == 'true'  && file1[i]['LOC'] == 'false'|| file2[i]['OTH'] == 'true'  && file1[i]['ORG'] == 'false'
				@ne_nicht_gefunden += 1
				end
				if file1[i]['PER'] == 'false' && file2[i]['PER'] == 'true'
					@per += 1
					if file1[i]['ORG'] == 'true'
					end
					if file1[i]['LOC'] == 'true'
					end
					if file1[i]['OTH'] == 'true'
					end
					
				end
				if file1[i]['PER'] == 'true' && file2[i]['PER'] == 'false'
					@per_falsch_gef += 1
					
				end
				if file1[i]['ORG'] == 'false' && file2[i]['ORG'] == 'true'
					@org += 1
					if file1[i]['PER'] == 'true'
					end
					if file1[i]['LOC'] == 'true'
					end
					if file1[i]['OTH'] == 'true'
					end
				end
				if file1[i]['ORG'] == 'true' && file2[i]['ORG'] == 'false'
					@org_falsch_gef += 1
				end
				if file1[i]['LOC'] == 'false' && file2[i]['LOC'] == 'true'
					@loc += 1
					if file1[i]['ORG'] == 'true'
					end
					if file1[i]['PER'] == 'true'

					end
					if file1[i]['OTH'] == 'true'
					end
					
				end
				if file1[i]['LOC'] == 'true' && file2[i]['LOC'] == 'false'
					@loc_falsch_gef += 1
				end
				if file1[i]['OTH'] == 'false' && file2[i]['OTH'] == 'true'

					if file1[i]['ORG'] == 'true'
		
					end
					if file1[i]['LOC'] == 'true'
	
					end
					if file1[i]['PER'] == 'true'
	
					end
					
				end
				if file1[i]['OTH'] == 'true' && file2[i]['OTH'] == 'false'
					@oth_falsch_gef += 1
				end
			end
		end
		puts "ne: #{ne}\t nicht ne: #{not_ne} \tne gefunden: #{ne_gefunden}\tnicht gefunden: #{ne_nicht_gefunden}
		per: #{per}\tper gefunden: #{per_gefunden}\tfalsch gefunden: #{per_falsch_gef}
		org: #{org}\torg gefunden: #{org_gefunden}\tfalsch gefunden: #{org_falsch_gef}
		loc: #{loc}\tloc gefunden: #{loc_gefunden}\t\tfalsch gefunden: #{loc_falsch_gef}
		oth: #{oth}\toth gefunden: #{oth_gefunden}\t\tfalsch gefunden: #{oth_falsch_gef}"
	end

end

t = TestNER.new()
t.read_data()

