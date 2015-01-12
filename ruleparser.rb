class Bedingung
	attr_reader :eigenschaft, :position, :wert
	def initialize(eigenschaft, position, wert)
		@eigenschaft = eigenschaft
		@position = position
		@wert = wert
	end
	
end
=begin 
Die Klasse Ruleparser liest die Regeln zeilenweise ein (eine Zeile soll genau eine Regel enthalten) 
und übergibt die einzelnen Teile/Bedingungen einem Array (arr_bedingungen).
=end
class Ruleparser

	def einlesen
		File.readlines('Regeln.txt').each do |line|
			bedingungen(line)
		end
	end
	
	def bedingungen(string)
		i = 0
		muster = /(\w+\.\d+\s+\=\s+[\w\.]+)+/
		arr_bedingungen = Array.new
		while string.scan(muster)[i]
			#puts "#{string.scan(muster)[i]}"
			arr_bedingungen << bedingung(string.scan(muster)[i].to_s)
			i = i + 1
		end
		return arr_bedingungen
		#puts arr_bedingungen[1].wert
	end
		
	def bedingung(string)
		muster = /(\w+)/
		element = string.scan(muster).flatten
		return Bedingung.new(element[0], element[1].to_i, element[2])
	end

end

R = Ruleparser.new
R.einlesen


