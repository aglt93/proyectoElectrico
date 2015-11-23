lista = ["ZERO","ONE","TWO","THREE","FOUR","FIVE","SIX","SEVEN",
	"EIGHT","NINE","TEN","ELEVEN","TWELVE","THIRTEEN","FOURTEEN",
	"FIFTEEN","SIXTEEN","SEVENTEEN","EIGHTEEN","NINETEEN","TWENTY",
	"TWENTY_ONE","TWENTY_TWO","TWENTY_THREE","TWENTY_FOUR","TWENTY_FIVE",
	"TWENTY_SIX","TWENTY_SEVEN","TWENTY_EIGHT","TWENTY_NINE","THIRTY",
	"THIRTY_ONE","THIRTY_TWO","THIRTY_THREE","THIRTY_FOUR","THIRTY_FIVE",
	"THIRTY_SIX","THIRTY_SEVEN","THIRTY_EIGHT","THIRTY_NINE","FORTY",
	"FORTY_ONE","FORTY_TWO","FORTY_THREE","FORTY_FOUR","FORTY_FIVE",
	"FORTY_SIX","FORTY_SEVEN","FORTY_EIGHT","FORTY_NINE","FIFTY",
	"FIFTY_ONE","FIFTY_TWO","FIFTY_THREE","FIFTY_FOUR","FIFTY_FIVE",
	"FIFTY_SIX","FIFTY_SEVEN","FIFTY_EIGHT","FIFTY_NINE","SIXTY",
	"SIXTY_ONE","SIXTY_TWO","SIXTY_THREE","SIXTY_FOUR","SIXTY_FIVE",
	"SIXTY_SIX"]

for item in lista:
	case = "`" + item + ": begin\n\tif (iDir) begin\n\t\toData \
<= {iData[`" + item +"-1:0],iData[W_SIZE-1:`"+item+"]}; \
\n\tend\n\telse begin\n\t\toData <= {iData[W_SIZE-`"+item+"-1:0],\
iData[W_SIZE-1:W_SIZE-`"+item+"]};\n\tend\nend\
\n///////////////////////////////////////\n"
	print case

for i in range (0,len(lista)):
	define = "`define " + lista[i] + " " + str(i)
	print define