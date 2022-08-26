import json
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from google.oauth2 import service_account
import pandas as pd

# If modifying these scopes, delete the file token.json.
SCOPES =[
	"https://www.googleapis.com/auth/spreadsheets",
	"https://www.googleapis.com/auth/drive.file",
	"https://www.googleapis.com/auth/drive"
]

# The ID and range of a sample spreadsheet.
SPREADSHEET_ID = '16Ih3Yl89XXmEA8MDUuRdnEHAKV_AK3cukJn3htrUDs8'
save_csv = False

def push():
	creds = service_account.Credentials.from_service_account_file("credentials.json", scopes=SCOPES)

	try:
		service = build('sheets', 'v4', credentials=creds)

		# Call the Sheets API
		with open("result.json") as file:
			with open("startups.json") as startups:
				bars = json.load(file)
				startups = json.load(startups)
				sheet = service.spreadsheets()
				result = sheet.values().update(spreadsheetId=SPREADSHEET_ID,
						range="A1", valueInputOption="USER_ENTERED", body={"values": [[json.dumps([bars, startups])]]}).execute()
				
				if not save_csv: exit()
				converted_data = []
				i=0
				print(bars)
				for bar in bars:
					i+=1
					if i>11: break
					obj = [str(i), bar["startup"], bar["popul"]]
					for su in startups:
						if su["startup"] == obj[1]:
							print(su["startup"])
							obj.append(su["url"])
					converted_data.append(obj)
				
				df = pd.DataFrame(converted_data)
				df.to_csv('csv.csv', index=False)
				with open("csv.csv") as csv:
					result = sheet.values().update(spreadsheetId=SPREADSHEET_ID,
						range="csv!A1", valueInputOption="USER_ENTERED", body={"values": [[csv.read()]]}).execute()
	except HttpError as err:
		print(err)