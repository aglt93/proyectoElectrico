from os import system


fileNames = ["8_32s","8_32i","16_32s","16_32i","32_32s","32_32i","64_32s","64_32i","128_32"]
fileNames = ["8_32i","16_32i","32_32i","64_32s","rc5_32","rc5_8","rc5_16"]


with open("json/utilization.json",'w') as utilFile:
	utilFile.write("{}")

for fileUtil in fileNames:
	system("python readUtilization.py " + fileUtil)