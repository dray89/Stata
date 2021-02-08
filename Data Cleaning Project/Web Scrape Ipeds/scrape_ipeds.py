# -*- coding: utf-8 -*-
"""
Created on Thu Jan  7 19:55:28 2021

@author: rayde
"""

import requests
import json
from lxml import html

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
files = ["SAL1980_A_Stata", "SAL90_A_Stata", "SAL2001_A_S_Stata","SAL1980_A_Data", "SAL90_A_Data", "SAL2001_A_S_Data"]
result = []
for each in files:
    for l in links:
        if each in l:
           result.append(l) 
           
for each in result:
    r = requests.get("https://nces.ed.gov/ipeds/datacenter/"+each, allow_redirects=True)
    open(f"{each[5:]}", 'wb').write(r.content)
    

import zipfile
paths = [r"C:\Users\rayde\Desktop\Urban Institute Interview Project\Scrape Ipeds\SAL90_A_Data_Stata.zip",
r"C:\Users\rayde\Desktop\Urban Institute Interview Project\Scrape Ipeds\SAL90_A_Stata.zip",
r"C:\Users\rayde\Desktop\Urban Institute Interview Project\Scrape Ipeds\SAL1980_A_Data_Stata.zip",
r"C:\Users\rayde\Desktop\Urban Institute Interview Project\Scrape Ipeds\SAL1980_A_Stata.zip",
r"C:\Users\rayde\Desktop\Urban Institute Interview Project\Scrape Ipeds\SAL2001_A_S_Data_Stata.zip",
r"C:\Users\rayde\Desktop\Urban Institute Interview Project\Scrape Ipeds\SAL2001_A_S_Stata.zip" ]

for each in paths:
    with zipfile.ZipFile(each, 'r') as zip_ref:
        zip_ref.extractall()