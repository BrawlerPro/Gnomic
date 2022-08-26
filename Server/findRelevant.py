import json
from datetime import datetime
from dateutil.relativedelta import relativedelta, FR, SA


TRANSPORT_THRESHOLD = 8

def find():
	now = datetime.timestamp(datetime.now())
	friday = datetime.now() + relativedelta(weekday=FR(-2))
	sunday = friday + relativedelta(weekday=SA(-1))

	with open("startups.json") as file:
		data = json.load(file)
		all_names = [i["startup"] for i in data]
		unique_names = list(set(all_names))

		transport_filtered_data = list(filter(lambda i: i["isTransport"] >= TRANSPORT_THRESHOLD, data))
		#print(datetime.timestamp(sunday), datetime.timestamp(friday), now, transport_filtered_data[0]["date"]/1000)
		filtered_data = filter(lambda i: datetime.timestamp(sunday) <= i["date"]/1000 <= datetime.timestamp(friday), transport_filtered_data)
		transport_names = [i["startup"] for i in filtered_data]
		unique_transport = list(set(transport_names))
		unique_transport.sort(key=lambda i: -all_names.count(i))
		
		popularity = {}
		for u in unique_transport:
			popularity[u] = all_names.count(u)

		filtered_data = list(data)
		filtered_data.sort(key=lambda y: y["date"])
		print(filtered_data)
		
		print(popularity)
		final = []
		for item in unique_transport:
			final.append({"startup": item, "popul": all_names.count(item)})
		with open("result.json", "w") as out:
			out.write(json.dumps(final))
