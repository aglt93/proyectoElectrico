import json
from sys import argv
import os

fileName = argv[1]
frecuency = 0

try:
	with open(fileName,'r') as fileUtil:

		line = ""
		while not line.startswith("clk"):
			line = next(fileUtil)

		frecuency = line.split("           ",1)[1].strip()

except Exception as e:
	print "Not able to parse file " + fileName + " because " + str(e)

#############################################################################################################
try:
	timing = json.load(open("json/timing.json",'r'))
	timing[fileName] = frecuency
	json.dump(timing,open("json/timing.json",'w'),sort_keys=True,indent=4, separators=(',', ': '))

except Exception as e:
	print "In readTiming.py: " + str(e)
	exit(4)
