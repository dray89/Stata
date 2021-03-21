/*
Scrape IPEDS Using Python From Stata16 Do File! Yes... It is possible!
*/
cd "..\iCloudDrive\GitHub\Stata\Data Cleaning Project\Web Scrape Ipeds"
python
import requests
import json
from lxml import html
import zipfile

cookie_file = open(r'cookies.json', 'r')
cookies = json.loads(cookie_file.read())

header_file = open(r'headers.json', 'r')
headers = json.loads(header_file.read())

params = (
    ('goToReportId', '7'),
)

data_file = open(r'data.json', 'r')
data = json.loads(data_file.read())
 
response = requests.post('https://nces.ed.gov/ipeds/datacenter/DataFiles.aspx', headers=headers, params=params, cookies=cookies, data=data)

#NB. Original query string below. It seems impossible to parse and
#reproduce query strings 100% accurately so the one below is given
#in case the reproduced version is not "correct".
# response = requests.post('https://nces.ed.gov/ipeds/datacenter/DataFiles.aspx?goToReportId=7', headers=headers, cookies=cookies, data=data)

tree = html.fromstring(response.content)
links = tree.xpath('//a/@href')
files = ["SAL1980_A_Stata", "SAL90_A_Stata", "SAL2001_A_S_Stata",
         "SAL1980_A_Data", "SAL90_A_Data", "SAL2001_A_S_Data"]

result = []
for each in files:
    for l in links:
        if each in l:
           result.append(l) 
           
for each in result:
    r = requests.get("https://nces.ed.gov/ipeds/datacenter/"+each, allow_redirects=True)
    open(f"{each[5:]}", 'wb').write(r.content)
    


paths = [r".\SAL90_A_Data_Stata.zip",
r".\SAL90_A_Stata.zip",
r".\SAL1980_A_Data_Stata.zip",
r".\SAL1980_A_Stata.zip",
r".\SAL2001_A_S_Data_Stata.zip",
r".\SAL2001_A_S_Stata.zip" ]

for each in paths:
    with zipfile.ZipFile(each, 'r') as zip_ref:
        zip_ref.extractall() #Optional Path to save file.
end