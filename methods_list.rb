  def compare_list_loc (satz)
    input = satz.split(' ')
    loc = File.readline("Staedte.txt").map { |l| l.chomp}
    puts input.map { |word| loc.include?(word)}
  end

  def compare_list_per (satz)
    input = satz.split(' ')
    per = File.readline("Vornamen.txt").map { |l| l.chomp}
    puts input.map { |word| per.include?(word)}
  end

  def compare_list_org (satz)
    input = satz.split(' ')
    org = File.readline("Organisation.txt").map { |l| l.chomp}
    puts input.map { |word| org.include?(word)}
  end