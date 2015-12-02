from os import system


fileNames = ["8_32","16_32","32_32","64_32","128_32"]


for fileUtil in fileNames:
	system("python readUtilization.py " + fileUtil)