satz = "Maria ist mit Peter zu BASF gegangen, die in Trier sitzen. Danach ging Maria alleine zu Bayer die in Berlin sitzen."

words = satz.split(' ')

loc = File.readlines("Staedte.txt").map { |l| l.chomp  }
per = File.readlines("Vornamen.txt").map { |l| l.chomp  }
org = ["BASF", "Bayer"]

index = 0 

while index < words.length
  if loc.include?(words[index])
    puts words[index]+"   LOC"
  elsif per.include?(words[index])
    puts words[index]+"   PER"
  elsif org.include?(words[index])
    puts words[index]+"   ORG"
  else
    puts words[index]
  end
  index = index + 1
end