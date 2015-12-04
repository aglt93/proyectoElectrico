from os import system

fileNames = ["8_32.txt","16_32.txt","32_32.txt","64_32.txt","128_32.txt"]

with open("json/timing.json",'w') as utilFile:
	utilFile.write("{}")

for fileUtil in fileNames:
	system("python readTiming.py " + fileUtil)