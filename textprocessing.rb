# das Programm übergibt eine Datei zeilenweise an einen Array (lines).
# Die Zeilen werden dann in einen zweiten Array übergeben (saetze), 
# der für jeden Satz einen eigenen Array erstellt. Mit saetze[][][] kann auf 
# einzelne Sätze, Zeilen und Spalten zugegriffen werden  

require 'csv'
class Textprocessing
	def saetze
	lines = Array.new

	CSV.foreach("TreeTagTest.txt", {:col_sep => "\t", :quote_char => "\0" }) do |row| #lesen der Datei und Überführung in einen Array
			lines << [row[0], row[1], row[2]]
	end

	arr_saetze = Array.new
	i = 0
	arr_saetze[0] = Array.new
	lines.each do |line|
			arr_saetze[i] << line
			
			if line[0] == "."
				 i = i +1
				 arr_saetze[i] = Array.new
			end
			
	end
		return arr_saetze
	end

	def testzugriff
		#Testzugriffe, Zugriff mit: [satz][zeile][spalte]
		puts saetze[0][0][0]
		puts saetze[0][0][2]
		puts saetze[0][1][2]
		puts saetze[0][1][0]
	end
end

T = Textprocessing.new
T.testzugriff