CORPUS = "TreeTagTest.txt"
RULES = "Rules.txt"
OUTPUT = "out.txt"

R = NER.new
R.read_rules
R.parse_sentences