import json
from os import system

#############################################################################################
# Se obtiene los datos parseados de los reportes
utilJson = json.load(open("utilization/json/utilization.json",'r'))
timingJson = json.load(open("timing/json/timing.json",'r'))

#############################################################################################
# Se obtiene los nombres de las metricas
csvHeader = "Word size (bits),Round number,"
csvLine = ""

utilJson8_32 = utilJson["8_32.txt"]

for key,value in utilJson8_32.iteritems():
	csvHeader += key + ","

csvHeader += "Max frecuency (MHz)"

##############################################################################################
# Se obtienen las metricas
for fileName, valueJson in utilJson.iteritems():

	frecuency = timingJson[fileName]
	
	implementationDescription = fileName.split(".",1)[0].split("_",1)
	csvLine +=  implementationDescription[0] + ","  + implementationDescription[1] + ","

	for key,value in valueJson.iteritems():

		csvLine += value + ","
	
	csvLine += frecuency + "\n"

csvHeader += "\n"

################################################################################################
# Se escriben los datos a un csv para poder abrir en excel.
with open("TEA_metrics.csv",'w') as metrics:
	metrics.write(csvHeader)
	metrics.write(csvLine)


