from os import system


fileNames = ["16_12_16.txt","32_12_16.txt","64_12_16.txt","32_16_7.txt","32_16_12.txt","32_16_16.txt"]


for fileUtil in fileNames:
	system("python readUtilization.py " + fileUtil)