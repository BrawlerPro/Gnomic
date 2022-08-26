import time
import requests
from bs4 import BeautifulSoup as bs
from selenium import webdriver
import json
from datetime import datetime
browser = None

PAGE_1 = "https://www.techstars.com"
PAGE_2 = "https://www.eu-startups.com"
PAGE_3 = "https://techstartups.com"
PAGE_4 = "https://techcrunch.com"
PAGE_5 = "https://inc42.com/buzz"
PAGE_5_PHP = "https://inc42.com/wp-admin/admin-ajax.php"

# https://inc42.com/buzz/ has nice JSON
# https://www.techstars.com/newsroom/techstars-partners-with-mih-consortium-to-drive-innovation-on-the-next-EV-Mobility

# Page 1 -----------------------------------------------------------------------------------------------------------------------
def parse1_page(url):
	print("Parsing page", url)
	r = requests.get(url)
	soup = bs(r.text, "html.parser")
	main_block = soup.select("div.jss4 > div")[0]
	title = ''.join(main_block.find("h3").find_all(text=True))
	date_str = ''.join(main_block.find("h6").find_all(text=True))
	date = datetime.timestamp(datetime.strptime(date_str, "%b %d, %Y"))*1000
	tags = main_block.select("div.jss102")[0].find_all(text=True)
	if len(main_block.select("a.jss111")):
		tags = tags + main_block.select("a.jss111")[0].find_all(text=True)
	text_paragraphs = main_block.select('div.jss98 > p')
	highlighted = []
	all_text = ""
	for p in text_paragraphs:
		all_text = all_text + ' '.join(p.find_all(text=True))
		links = p.find_all("a")
		for link in links:
			highlighted.append({"text": ' '.join(link.find_all(text=True)), "link": link["href"]})
	
	return {
		"url": url,
		"title": title,
		"date": date,
		"text": all_text,
		"tags": tags,
		"highlighted": highlighted
	}


def parse1(page=1):
	browser.get(PAGE_1 + "/newsroom?page=" + str(page))
	r = browser.page_source
	soup = bs(r, "html.parser")
	blocks = soup.select("div.MuiContainer-root.MuiContainer-maxWidthLg")[1].find_all("div", class_="jss95")
	data = []
	for block in blocks:
		title = block.select("div > a")[2]
		data.append(parse1_page(PAGE_1 + title["href"]))
	
	return data


# Page 2 -----------------------------------------------------------------------------------------------------------------------
def parse2_page(url):
	print("Parsing page", url)
	r = requests.get(url)
	soup = bs(r.text, "html.parser")
	main_block = soup.select("div#tdi_72 > div.tdi_73 > div.tdi_75 > div.wpb_wrapper")[0]
	title = main_block.find("h1").getText()
	tags = []
	if len(main_block.select("ul.tdb-tags")):
		tags = main_block.select("ul.tdb-tags")[0].find_all(text=True)[1:]
	all_text = ' '.join(main_block.select('div.tdb_single_content > div')[0].find_all(text=True))
	highlighted = []
	for link in main_block.select('div.tdb_single_content > div')[0].find_all("a"):
		highlighted.append({"text": ' '.join(link.find_all(text=True)), "link": link["href"]})
	
	date_str = ' '.join(main_block.find("time").find_all(text=True))
	date = datetime.timestamp(datetime.strptime(date_str, "%B %d, %Y"))*1000
	return {
		"url": url,
		"title": title,
		"date": date,
		"text": all_text,
		"tags": tags,
		"highlighted": highlighted
	}


def parse2(page=1):
	r = requests.get(PAGE_2 + "/page/" + str(page))
	soup = bs(r.text, "html.parser")
	blocks = soup.select("div#tdi_76")[0].findChildren("div", recursive=False)
	data = []
	for block in blocks:
		link = block.select("div.td-module-thumb > a")[0]
		data.append(parse2_page(link["href"]))
	
	return data


# Page 3 -----------------------------------------------------------------------------------------------------------------------
def parse3_page(url):
	print("Parsing page", url)
	r = requests.get(url)
	soup = bs(r.text, "html.parser")
	main_block = soup.select("div.post_content_wrapper")[0]
	title = ''.join(main_block.find("h1").find_all(text=True))
	date_str = ''.join(main_block.select("span.post_info_date")[0].find_all(text=True)).strip()
	date = datetime.timestamp(datetime.strptime(date_str, "Posted On %B %d, %Y"))*1000
	text_paragraphs = main_block.select("div.post_header.single")[0].find_all("p")
	all_text = ""
	highlighted = []
	for p in text_paragraphs:
		all_text = all_text + ' '.join(p.find_all(text=True))
		for link in p.find_all("a"):
			highlighted.append({"text": ' '.join(link.find_all(text=True)), "link": link["href"]})


	return {
		"url": url,
		"title": title,
		"date": date,
		"text": all_text,
		"tags": [],
		"highlighted": highlighted
	}


def parse3(page=1):
	r = requests.post("https://techstartups.com/wp-admin/admin-ajax.php?action=grandnews_pagination_list", json={"offset": (page-1)*12, "items": 12})
	soup = bs(r.text, "html.parser")
	titles = soup.select("div.post_header_title")
	data = []
	for title in titles:
		link = title.find("a")["href"]
		print(link)
		data.append(parse3_page(link))

	return data

# Page 4 -----------------------------------------------------------------------------------------------------------------------
def parse4_page(url):
	try:
		browser.get(url)
	except Exception:
		pass
	r = browser.page_source
	soup = bs(r, "html.parser")
	main_block = soup.select("div.content > div > div > article > div.article__content-outer")[0]
	title = ''.join(main_block.find("h1").find_all(text=True))
	tags = main_block.select("div.article__tags > ul")[0].find_all(text=True)
	text_paragraphs = main_block.select('div.article-content > p')
	highlighted = []
	all_text = ""
	for p in text_paragraphs:
		all_text = all_text + ' '.join(p.find_all(text=True))
		links = p.find_all("a")
		for link in links:
			highlighted.append({"text": ' '.join(link.find_all(text=True)), "link": link["href"]})
	
	return {
		"url": url,
		"title": title,
		"date": 0,
		"text": all_text,
		"tags": tags,
		"highlighted": highlighted
	}

def parse4_data(data):
	content = data["content"]["rendered"]
	soup = bs(content, "html.parser")
	all_text = ' '.join(soup.find_all(text=True))
	highlighted = []
	date = datetime.timestamp(datetime.strptime(data["date"], "%Y-%m-%dT%H:%M:%S"))*1000
	for link in soup.find_all("a"):
		highlighted.append({"text": ' '.join(link.find_all(text=True)), "link": link["href"]})


	return {
		"url": data["link"],
		"title": data["title"]["rendered"],
		"date": date,
		"text": all_text,
		"tags": [],
		"highlighted": highlighted
	}

def parse4(page=1):
	r = requests.get(PAGE_4 + "/wp-json/tc/v1/magazine?page="+str(page)+"&_embed=true&cachePrevention=0")
	print(len(r.json()))
	pages = r.json()

	data = []
	for page in pages:
		data.append(parse4_data(page))
	return data
	data = []
	for block in blocks:
		link = block.find("a")
		print(link["href"])
		data.append(parse3_page(link["href"]))

	return data

def parse():
	global browser
	options = webdriver.ChromeOptions()
	options.add_argument('--headless')
	browser = webdriver.Chrome(options=options, executable_path='D:\chromedriver\chromedriver.exe')
	browser.set_page_load_timeout(60)
	
	with open("parsedData.json", "r+") as file:
		data = json.load(file)
		while len(data) < 4: data.append([])
		data[0] = []
		for i in range(1, 21):
			print("Page " + str(i) + "...", "Length is", len(data[0]))
			try:
				data[0] = data[0] + parse1(i)
			except Exception as e:
				print("Error while parsing 1.")
			pass

		data[1] = []
		for i in range(1, 21):
			print("Page " + str(i) + "...", "Length is", len(data[1]))
			try:
				data[1] = data[1] + parse2(i)
			except Exception as e:
				print("Error while parsing 2.")
			pass

		data[2] = []
		for i in range(1, 21):
			print("Page " + str(i) + "...", "Length is", len(data[2]))
			try:
				data[2] = data[2] + parse3(i)
			except Exception as e:
				print("Error while parsing 3.")
			pass
		
		data[3] = []
		for i in range(1, 21):
			print("Page " + str(i) + "...", "Length is", len(data[3]))
			try:
				data[3] = data[3] + parse4(i)
			except Exception as e:
				print("Error while parsing 4.")
			pass

		file.seek(0)
		file.write(json.dumps(data))
	
	browser.quit()
	exit()

parse()

#print(parse1_page("https://www.techstars.com/newsroom/techstars-and-j-p-morgan-launch-third-founder-catalyst-program-in-miami"))