import json
from sys import argv
import os


utilJson = {}
fileName = argv[1]

try:
	with open(fileName,'r') as fileUtil:

		for line in fileUtil:
			if 'SLICEL' in line:
				sliceL = [i.strip() for i in line.split('|',6)]
				utilJson[sliceL[1]]=sliceL[2]

			elif 'SLICEM' in line:
				sliceM = [i.strip() for i in line.split('|',6)]
				utilJson[sliceM[1]]=sliceM[2]

			elif 'LUT as Logic' in line:
				lutL = [i.strip() for i in line.split('|',6)]
				utilJson[lutL[1]]=lutL[2]

			elif 'LUT as Memory' in line:
				lutM = [i.strip() for i in line.split('|',6)]
				utilJson[lutM[1]]=lutM[2]

			elif 'Slice Registers' in line:
				sliceRegisters = [i.strip() for i in line.split('|',6)]
				utilJson[sliceRegisters[1]]=sliceRegisters[2]

			elif '| Block RAM Tile' in line:
				ram = [i.strip() for i in line.split('|',6)]
				utilJson[ram[1]]=ram[2]

			elif 'DSPs' in line:
				dsp = [i.strip() for i in line.split('|',6)]
				utilJson[dsp[1]]=dsp[2]

except Exception as e:
	print "Not able to parse file " + fileName + " because " + str(e)

#############################################################################################################
try:
	util = json.load(open("json/utilization.json",'r'))
	util[fileName] = utilJson
	json.dump(util,open("json/utilization.json",'w'),sort_keys=True,indent=4, separators=(',', ': '))

except Exception as e:
	print "In readUtilization.py: " + str(e)
	exit(4)