require 'csv'

class NETest
	
	def einlesen (datei1, datei2) # Datei1 entspricht dem Testset/Trainingsset und Datei2 dem eigens erstellten Set
		datei2array =[]
		true_negative = 0
		false_negative =0
		true_positive = 0
		false_positive = 0
		false_other = 0
		named_entities = 0
		error = 0
		
		CSV.foreach(datei2, {:col_sep => "\t", :quote_char => "\0" }) do |row| #lesen der Datei und Überführung in einen Array
			datei2array << [row[0], row[1], row[2]]
		end
		
		zaehler = 0 #gibt die Zeile des Arrays an
		CSV.foreach(datei1, {:col_sep => "\t", :quote_char => "\0" }) do |row|
			if zaehler >= datei2array.length
				break
			end
			if row.empty?() || row[0] == '#' #ignoriere leere Zeilen und Zeilen die mit "#" beginnen
				next
			end
			puts zaehler
			
			if row[1] == datei2array[zaehler][0]
				puts row[1]
			else
				puts "error"
				error += 1
			end
			
			if row[3] == datei2array[zaehler][2] && #zählt die gemeinsamen Elemente ohne NE/ true_negative
				row[2] == datei2array[zaehler][1] &&
				row [2] == "O"
				true_negative +=1
			end
			
			if row[2] != datei2array[zaehler][1] && #zählt die false_negative
				row[2] != "O" &&
				datei2array[zaehler][1] == "O"
				false_negative += 1
			end
			
			if row[2] != datei2array[zaehler][1] && #zählt die false_positive
				row[2] == "O" &&
				datei2array[zaehler][1] != "O"
				false_positive += 1
			end
			
			if row[2] == datei2array[zaehler][1] &&  #zählt die true_positive
				row[2] != "O"
				true_positive += 1
			end
			
			if row[2] != datei2array[zaehler][1] && #zählt die false_other (gefundene NEs, die mit dem Trainingsset nicht übereinstimmen)
				row[2] != datei2array[zaehler][1] &&
				row[2] != "O" &&
				datei2array[zaehler][1] != "O"
				false_other += 1
			end
			
			if row[2] != "O" #zählt die NEs insgesamt
				named_entities += 1
			end
			
			
			zaehler +=1		
		end
	puts "true_negative = #{true_negative} \nfalse_negative = #{false_negative} \ntrue_positive = #{true_positive} \nfalse_positive = #{false_negative} \nfalse_other = #{false_other} \nNamed Entities = #{named_entities}\nErrors = #{error}" 
	end
	
end

c = NETest.new
c.einlesen("NER-de-test.tsv", "beispieltest.txt")
 