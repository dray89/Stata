python
list_price = 70
pocket = {"uninsured":{"list_price": list_price}, "insured": {"list_price":0}, "coinsurance": {"list_price":.5*list_price}, "copay": {"list_price": 25}}

for i in pocket: 
	quantity = [100 - pocket]
	pocket[i]["quantity"]= quantity
	
print(pocket)
end