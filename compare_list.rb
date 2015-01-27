# Eingabe des Textes oder des Satzes ohne Satzzeichen
puts "Bitte geben Sie einen deutschen Satz oder Text ein:  "
satz = gets
# Zerlegung der Eingabe in Array durch Leerzeichentrennung
word = []
word = satz.split(' ')

# Einlesen von Dateien mit Named Entities

#datei1 = File.new("Staedte.txt", "r")
#loc = []
#loc = datei1.readlines
#datei1.close
#datei2 = File.new("Vornamen.txt", "r")
#per = []
#per = datei2.readlines
#datei2.close
#datei3 = File.new("Unternehmen.txt", "r")
#org = []
#org = datei3.readlines
#datei3.close

# Testarrays
loc = ["Aachen", "Berlin", "Trier"]
per = ["Merkel", "Gauck", "Gabriel"]
org = ["BASF", "Bayer", "Deutsches Rotes Kreuz"]

#Indexierung für Eingabearray
index = 0

#Schreiben in externe .txt-Datei
result = open("result.txt", "w")

while index < word.length
  #Vergleich "LOC-Lexikon" mit Eingabearray 
  if loc.include?(word[index])
    result.write(word[index] + "      LOC")
    result.write("\n")
  #Vergleich "PER-Lexikon" mit Eingabearray 
  elsif per.include?(word[index])
    result.write(word[index] + "      PER")
    result.write("\n")
  #Vergleich "ORG-Lexikon" mit Eingabearray   
  elsif org.include?(word[index])
    result.write(word[index] + "      ORG")
    result.write("\n")
  else
    result.write(word[index])
    result.write("\n")
  end
  index = index + 1
end

result.close