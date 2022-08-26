import nltk
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize, sent_tokenize
import json
from urllib.parse import urlparse
import re


keywords = [
	"transport",
	"transportation",
	"mobility",
	"future transportation",
	"conveyance",
	"vehicle",
	"electrobus",
	"carriage", 
	"removal", 
	"shipment", 
	"shipping", 
	"transference",
	"subway",
	"underground",
	"metro",
	"the tube",
	"drive",
	"bus",
	"bicycle",
	"bike",
	"cycle",
	"wheel",
	"scooter",
	"two-wheeler", 
	"pedal cycle",
	"plane",
	"monocycle",
	"helicopter",
	"minibus",
	"car",
	"limousine",
	"tram",
	"taxi",
	"train",
	"ship",
	"submarine",
	"truck",
	"moped",
	"motorbike",
	"boat",
	"cabriolet",
	"tire",
	"transportation",
	"ev"
]

banned_words = [
	"techstars", 
	"techcrunch", 
	"eu-startups", 
	"techstartups", 
	"build", 
	"apply", 
	"learn", 
	"startups", 
	"miami", 
	"demo", 
	"payments", 
	"ev",
	"deals",
	"here",
	"anything",
	"does"
]
banned_links = ["techstarstwsc.pros.is", "www.techstars.com"]
banned_startups = ["techstars"]

startups_file = open("NAMES.json")
banned_startups += json.load(startups_file)
startups_file.close()

PROBABILITY_TEXT = 1
PROBABILITY_TITLE = 5
PROBABILITY_TAGS = 3
PROBABILITY_CEO = 10

STARTUP_TITLE = 5
STARTUP_TAG = 2
STARTUP_LINK = 6

def ProperNounExtractor(text):
	sentences = nltk.sent_tokenize(text)
	result = []
	for sentence in sentences:
		words = nltk.word_tokenize(sentence)
		words = [word for word in words if word not in set(stopwords.words('english'))]
		tagged = nltk.pos_tag(words)
		for (word, tag) in tagged:
			if tag == 'NNP': # If the word is a proper noun
				for ban in banned_words:
					if ban.lower().find(word.lower()) != -1: break
				else:
					for ban in banned_startups:
						if ban.lower().find(word.lower()) != -1: break
					else:
						result.append(word)
		
	return result
	
def identify():
	with open("parsedData.json") as file:
		data = json.load(file)
		startups = []
		for website in data:
			count = 0
			for page in website:
				try:
					count+=1
					if count>30: break
					words = [word.upper() for word in page["text"].split()]
					nouns = ProperNounExtractor(page["text"])
					nouns = [word.upper() for word in nouns if len(word) >= 3]
					unique = list(set(nouns))
					unique.sort(key=lambda word: -words.count(word))
					possible_names = unique

					if not len(possible_names): continue

					# Highlights
					highlights = []
					links = []
					for hl in page["highlighted"]:
						link = urlparse(hl["link"].strip()).netloc
						if link in banned_links: continue
						highlights.append({"text": hl["text"], "link": link})
						links.append(link)
					
					possible_links = [dict(s) for s in set(frozenset(d.items()) for d in highlights)]
					possible_links.sort(key=lambda item: -links.count(item["link"]))

					link_names = []
					for item in possible_links:
						link_names.append(item["text"])

					# Tags
					tags_str = ' '.join(page["tags"]).upper()
					title = page["title"].upper()

					probabilities = {}
					for name in possible_names:
						prob = 0
						if name == "EV":
							print(title.find(name), tags_str.find(name), words.count(name))
							pass
						if title.find(name) != -1: prob+=STARTUP_TITLE
						if tags_str.find(name) != -1: prob+=STARTUP_TAG
						prob+=words.count(name)
						for link in link_names:
							if link.upper().find(name) != -1: prob+=STARTUP_LINK
						for link in possible_links:
							if link["link"].upper().find(name) != -1: prob+=STARTUP_LINK

						
						probabilities[name] = prob
					

					# CEOs
					last = [re.compile(r'CEO .*? of \w+')]

					for reg in last:
						for match in re.findall(reg, page["text"]):
							print(match)
							print("!!!!!!!!!!!")
							pass
					
					sorted_probabilities = {k: v for k, v in sorted(probabilities.items(), key=lambda item: -item[1])}

					print(title)
					print(page["url"])
					#print(sorted_probabilities)
					possible_startups = list(sorted_probabilities)
					startup = possible_startups[0]
					index = words.index(startup)

					# Double word name
					if index != len(words) and words[index+1] in possible_startups[:5]:
						startup = startup + " " + words[index+1]
					elif index != 0 and words[index-1] in possible_startups[:5]:
						startup = words[index-1] + " " + startup

					probability = 0
					for word in words:
						if word.lower() in keywords:
							probability+=PROBABILITY_TEXT
					for word in title.split():
						if word.lower() in keywords:
							probability+=PROBABILITY_TITLE
					for word in tags_str.split():
						if word.lower() in keywords:
							probability+=PROBABILITY_TAGS

					# Bans
					if startup.lower() in banned_startups: continue
					print(startup)

					startups.append({
						"startup": startup,
						"url": page["url"],
						"isTransport": probability,
						"date": page["date"]
					})
				except Exception as e:
					print("Whoops...")
					print(e)
		
		print(startups)
		with open("startups.json", "w") as out:
			out.write(json.dumps(startups))