`define ZERO 0
`define ONE 1
`define TWO 2
`define THREE 3
`define FOUR 4
`define FIVE 5
`define SIX 6
`define SEVEN 7
`define EIGHT 8
`define NINE 9
`define TEN 10
`define ELEVEN 11
`define TWELVE 12
`define THIRTEEN 13
`define FOURTEEN 14
`define FIFTEEN 15
`define SIXTEEN 16
`define SEVENTEEN 17
`define EIGHTEEN 18
`define NINETEEN 19
`define TWENTY 20
`define TWENTY_ONE 21
`define TWENTY_TWO 22
`define TWENTY_THREE 23
`define TWENTY_FOUR 24
`define TWENTY_FIVE 25
`define TWENTY_SIX 26
`define TWENTY_SEVEN 27
`define TWENTY_EIGHT 28
`define TWENTY_NINE 29
`define THIRTY 30
`define THIRTY_ONE 31
`define THIRTY_TWO 32
`define THIRTY_THREE 33
`define THIRTY_FOUR 34
`define THIRTY_FIVE 35
`define THIRTY_SIX 36
`define THIRTY_SEVEN 37
`define THIRTY_EIGHT 38
`define THIRTY_NINE 39
`define FORTY 40
`define FORTY_ONE 41
`define FORTY_TWO 42
`define FORTY_THREE 43
`define FORTY_FOUR 44
`define FORTY_FIVE 45
`define FORTY_SIX 46
`define FORTY_SEVEN 47
`define FORTY_EIGHT 48
`define FORTY_NINE 49
`define FIFTY 50
`define FIFTY_ONE 51
`define FIFTY_TWO 52
`define FIFTY_THREE 53
`define FIFTY_FOUR 54
`define FIFTY_FIVE 55
`define FIFTY_SIX 56
`define FIFTY_SEVEN 57
`define FIFTY_EIGHT 58
`define FIFTY_NINE 59
`define SIXTY 60
`define SIXTY_ONE 61
`define SIXTY_TWO 62
`define SIXTY_THREE 63
`define SIXTY_FOUR 64
`define SIXTY_FIVE 65
`define SIXTY_SIX 66


module barrelShifter16 
(
	input wire [W_SIZE-1:0] iData,
	input wire [W_WIDTH-1:0] iRotate,
	input wire iDir,
	output reg [W_SIZE-1:0] oData
);


	parameter W_SIZE = 16;
	parameter W_WIDTH = $clog2(W_SIZE);

	always @(*) begin
		case (iRotate)

			`ZERO: begin
				oData <= iData;
			end
			///////////////////////////////////////

			`ONE: begin
				if (iDir) begin
					oData <= {iData[`ONE-1:0],iData[W_SIZE-1:`ONE]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`ONE-1:0],iData[W_SIZE-1:W_SIZE-`ONE]};
				end
			end
			///////////////////////////////////////

			`TWO: begin
				if (iDir) begin
					oData <= {iData[`TWO-1:0],iData[W_SIZE-1:`TWO]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`TWO-1:0],iData[W_SIZE-1:W_SIZE-`TWO]};
				end
			end
			///////////////////////////////////////

			`THREE: begin
				if (iDir) begin
					oData <= {iData[`THREE-1:0],iData[W_SIZE-1:`THREE]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`THREE-1:0],iData[W_SIZE-1:W_SIZE-`THREE]};
				end
			end
			///////////////////////////////////////

			`FOUR: begin
				if (iDir) begin
					oData <= {iData[`FOUR-1:0],iData[W_SIZE-1:`FOUR]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`FOUR-1:0],iData[W_SIZE-1:W_SIZE-`FOUR]};
				end
			end
			///////////////////////////////////////

			`FIVE: begin
				if (iDir) begin
					oData <= {iData[`FIVE-1:0],iData[W_SIZE-1:`FIVE]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`FIVE-1:0],iData[W_SIZE-1:W_SIZE-`FIVE]};
				end
			end
			///////////////////////////////////////

			`SIX: begin
				if (iDir) begin
					oData <= {iData[`SIX-1:0],iData[W_SIZE-1:`SIX]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`SIX-1:0],iData[W_SIZE-1:W_SIZE-`SIX]};
				end
			end
			///////////////////////////////////////

			`SEVEN: begin
				if (iDir) begin
					oData <= {iData[`SEVEN-1:0],iData[W_SIZE-1:`SEVEN]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`SEVEN-1:0],iData[W_SIZE-1:W_SIZE-`SEVEN]};
				end
			end
			///////////////////////////////////////

			`EIGHT: begin
				if (iDir) begin
					oData <= {iData[`EIGHT-1:0],iData[W_SIZE-1:`EIGHT]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`EIGHT-1:0],iData[W_SIZE-1:W_SIZE-`EIGHT]};
				end
			end
			///////////////////////////////////////

			`NINE: begin
				if (iDir) begin
					oData <= {iData[`NINE-1:0],iData[W_SIZE-1:`NINE]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`NINE-1:0],iData[W_SIZE-1:W_SIZE-`NINE]};
				end
			end
			///////////////////////////////////////

			`TEN: begin
				if (iDir) begin
					oData <= {iData[`TEN-1:0],iData[W_SIZE-1:`TEN]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`TEN-1:0],iData[W_SIZE-1:W_SIZE-`TEN]};
				end
			end
			///////////////////////////////////////

			`ELEVEN: begin
				if (iDir) begin
					oData <= {iData[`ELEVEN-1:0],iData[W_SIZE-1:`ELEVEN]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`ELEVEN-1:0],iData[W_SIZE-1:W_SIZE-`ELEVEN]};
				end
			end
			///////////////////////////////////////

			`TWELVE: begin
				if (iDir) begin
					oData <= {iData[`TWELVE-1:0],iData[W_SIZE-1:`TWELVE]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`TWELVE-1:0],iData[W_SIZE-1:W_SIZE-`TWELVE]};
				end
			end
			///////////////////////////////////////

			`THIRTEEN: begin
				if (iDir) begin
					oData <= {iData[`THIRTEEN-1:0],iData[W_SIZE-1:`THIRTEEN]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`THIRTEEN-1:0],iData[W_SIZE-1:W_SIZE-`THIRTEEN]};
				end
			end
			///////////////////////////////////////

			`FOURTEEN: begin
				if (iDir) begin
					oData <= {iData[`FOURTEEN-1:0],iData[W_SIZE-1:`FOURTEEN]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`FOURTEEN-1:0],iData[W_SIZE-1:W_SIZE-`FOURTEEN]};
				end
			end
			///////////////////////////////////////

			`FIFTEEN: begin
				if (iDir) begin
					oData <= {iData[`FIFTEEN-1:0],iData[W_SIZE-1:`FIFTEEN]}; 
				end
				else begin
					oData <= {iData[W_SIZE-`FIFTEEN-1:0],iData[W_SIZE-1:W_SIZE-`FIFTEEN]};
				end
			end
		endcase
	end

endmodule

































module barrelShifter32
(
	input wire [W_SIZE-1:0] iData,
	input wire [W_WIDTH-1:0] iRotate,
	input wire iDir,
	output reg [W_SIZE-1:0] oData
);


	parameter W_SIZE = 32;
	parameter W_WIDTH = $clog2(W_SIZE);

	always @(*) begin

		case (iRotate)


`ZERO: begin
	oData <= iData;
end
///////////////////////////////////////

`ONE: begin
	if (iDir) begin
		oData <= {iData[`ONE-1:0],iData[W_SIZE-1:`ONE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`ONE-1:0],iData[W_SIZE-1:W_SIZE-`ONE]};
	end
end
///////////////////////////////////////

`TWO: begin
	if (iDir) begin
		oData <= {iData[`TWO-1:0],iData[W_SIZE-1:`TWO]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWO-1:0],iData[W_SIZE-1:W_SIZE-`TWO]};
	end
end
///////////////////////////////////////

`THREE: begin
	if (iDir) begin
		oData <= {iData[`THREE-1:0],iData[W_SIZE-1:`THREE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THREE-1:0],iData[W_SIZE-1:W_SIZE-`THREE]};
	end
end
///////////////////////////////////////

`FOUR: begin
	if (iDir) begin
		oData <= {iData[`FOUR-1:0],iData[W_SIZE-1:`FOUR]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FOUR-1:0],iData[W_SIZE-1:W_SIZE-`FOUR]};
	end
end
///////////////////////////////////////

`FIVE: begin
	if (iDir) begin
		oData <= {iData[`FIVE-1:0],iData[W_SIZE-1:`FIVE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIVE-1:0],iData[W_SIZE-1:W_SIZE-`FIVE]};
	end
end
///////////////////////////////////////

`SIX: begin
	if (iDir) begin
		oData <= {iData[`SIX-1:0],iData[W_SIZE-1:`SIX]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`SIX-1:0],iData[W_SIZE-1:W_SIZE-`SIX]};
	end
end
///////////////////////////////////////

`SEVEN: begin
	if (iDir) begin
		oData <= {iData[`SEVEN-1:0],iData[W_SIZE-1:`SEVEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`SEVEN-1:0],iData[W_SIZE-1:W_SIZE-`SEVEN]};
	end
end
///////////////////////////////////////

`EIGHT: begin
	if (iDir) begin
		oData <= {iData[`EIGHT-1:0],iData[W_SIZE-1:`EIGHT]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`EIGHT-1:0],iData[W_SIZE-1:W_SIZE-`EIGHT]};
	end
end
///////////////////////////////////////

`NINE: begin
	if (iDir) begin
		oData <= {iData[`NINE-1:0],iData[W_SIZE-1:`NINE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`NINE-1:0],iData[W_SIZE-1:W_SIZE-`NINE]};
	end
end
///////////////////////////////////////

`TEN: begin
	if (iDir) begin
		oData <= {iData[`TEN-1:0],iData[W_SIZE-1:`TEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TEN-1:0],iData[W_SIZE-1:W_SIZE-`TEN]};
	end
end
///////////////////////////////////////

`ELEVEN: begin
	if (iDir) begin
		oData <= {iData[`ELEVEN-1:0],iData[W_SIZE-1:`ELEVEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`ELEVEN-1:0],iData[W_SIZE-1:W_SIZE-`ELEVEN]};
	end
end
///////////////////////////////////////

`TWELVE: begin
	if (iDir) begin
		oData <= {iData[`TWELVE-1:0],iData[W_SIZE-1:`TWELVE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWELVE-1:0],iData[W_SIZE-1:W_SIZE-`TWELVE]};
	end
end
///////////////////////////////////////

`THIRTEEN: begin
	if (iDir) begin
		oData <= {iData[`THIRTEEN-1:0],iData[W_SIZE-1:`THIRTEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTEEN-1:0],iData[W_SIZE-1:W_SIZE-`THIRTEEN]};
	end
end
///////////////////////////////////////

`FOURTEEN: begin
	if (iDir) begin
		oData <= {iData[`FOURTEEN-1:0],iData[W_SIZE-1:`FOURTEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FOURTEEN-1:0],iData[W_SIZE-1:W_SIZE-`FOURTEEN]};
	end
end
///////////////////////////////////////

`FIFTEEN: begin
	if (iDir) begin
		oData <= {iData[`FIFTEEN-1:0],iData[W_SIZE-1:`FIFTEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIFTEEN-1:0],iData[W_SIZE-1:W_SIZE-`FIFTEEN]};
	end
end
///////////////////////////////////////

`SIXTEEN: begin
	if (iDir) begin
		oData <= {iData[`SIXTEEN-1:0],iData[W_SIZE-1:`SIXTEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`SIXTEEN-1:0],iData[W_SIZE-1:W_SIZE-`SIXTEEN]};
	end
end
///////////////////////////////////////

`SEVENTEEN: begin
	if (iDir) begin
		oData <= {iData[`SEVENTEEN-1:0],iData[W_SIZE-1:`SEVENTEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`SEVENTEEN-1:0],iData[W_SIZE-1:W_SIZE-`SEVENTEEN]};
	end
end
///////////////////////////////////////

`EIGHTEEN: begin
	if (iDir) begin
		oData <= {iData[`EIGHTEEN-1:0],iData[W_SIZE-1:`EIGHTEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`EIGHTEEN-1:0],iData[W_SIZE-1:W_SIZE-`EIGHTEEN]};
	end
end
///////////////////////////////////////

`NINETEEN: begin
	if (iDir) begin
		oData <= {iData[`NINETEEN-1:0],iData[W_SIZE-1:`NINETEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`NINETEEN-1:0],iData[W_SIZE-1:W_SIZE-`NINETEEN]};
	end
end
///////////////////////////////////////

`TWENTY: begin
	if (iDir) begin
		oData <= {iData[`TWENTY-1:0],iData[W_SIZE-1:`TWENTY]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY]};
	end
end
///////////////////////////////////////

`TWENTY_ONE: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_ONE-1:0],iData[W_SIZE-1:`TWENTY_ONE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_ONE-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_ONE]};
	end
end
///////////////////////////////////////

`TWENTY_TWO: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_TWO-1:0],iData[W_SIZE-1:`TWENTY_TWO]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_TWO-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_TWO]};
	end
end
///////////////////////////////////////

`TWENTY_THREE: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_THREE-1:0],iData[W_SIZE-1:`TWENTY_THREE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_THREE-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_THREE]};
	end
end
///////////////////////////////////////

`TWENTY_FOUR: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_FOUR-1:0],iData[W_SIZE-1:`TWENTY_FOUR]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_FOUR-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_FOUR]};
	end
end
///////////////////////////////////////

`TWENTY_FIVE: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_FIVE-1:0],iData[W_SIZE-1:`TWENTY_FIVE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_FIVE-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_FIVE]};
	end
end
///////////////////////////////////////

`TWENTY_SIX: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_SIX-1:0],iData[W_SIZE-1:`TWENTY_SIX]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_SIX-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_SIX]};
	end
end
///////////////////////////////////////

`TWENTY_SEVEN: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_SEVEN-1:0],iData[W_SIZE-1:`TWENTY_SEVEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_SEVEN-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_SEVEN]};
	end
end
///////////////////////////////////////

`TWENTY_EIGHT: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_EIGHT-1:0],iData[W_SIZE-1:`TWENTY_EIGHT]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_EIGHT-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_EIGHT]};
	end
end
///////////////////////////////////////

`TWENTY_NINE: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_NINE-1:0],iData[W_SIZE-1:`TWENTY_NINE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_NINE-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_NINE]};
	end
end
///////////////////////////////////////

`THIRTY: begin
	if (iDir) begin
		oData <= {iData[`THIRTY-1:0],iData[W_SIZE-1:`THIRTY]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTY-1:0],iData[W_SIZE-1:W_SIZE-`THIRTY]};
	end
end
///////////////////////////////////////

`THIRTY_ONE: begin
	if (iDir) begin
		oData <= {iData[`THIRTY_ONE-1:0],iData[W_SIZE-1:`THIRTY_ONE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTY_ONE-1:0],iData[W_SIZE-1:W_SIZE-`THIRTY_ONE]};
	end
end
endcase
end

endmodule















































module barrelShifter64
(
	input wire [W_SIZE-1:0] iData,
	input wire [W_WIDTH-1:0] iRotate,
	input wire iDir,
	output reg [W_SIZE-1:0] oData
);


	parameter W_SIZE = 64;
	parameter W_WIDTH = $clog2(W_SIZE);

	always @(*) begin
		case (iRotate)

`ZERO: begin
	oData <= iData;
end
///////////////////////////////////////

`ONE: begin
	if (iDir) begin
		oData <= {iData[`ONE-1:0],iData[W_SIZE-1:`ONE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`ONE-1:0],iData[W_SIZE-1:W_SIZE-`ONE]};
	end
end
///////////////////////////////////////

`TWO: begin
	if (iDir) begin
		oData <= {iData[`TWO-1:0],iData[W_SIZE-1:`TWO]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWO-1:0],iData[W_SIZE-1:W_SIZE-`TWO]};
	end
end
///////////////////////////////////////

`THREE: begin
	if (iDir) begin
		oData <= {iData[`THREE-1:0],iData[W_SIZE-1:`THREE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THREE-1:0],iData[W_SIZE-1:W_SIZE-`THREE]};
	end
end
///////////////////////////////////////

`FOUR: begin
	if (iDir) begin
		oData <= {iData[`FOUR-1:0],iData[W_SIZE-1:`FOUR]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FOUR-1:0],iData[W_SIZE-1:W_SIZE-`FOUR]};
	end
end
///////////////////////////////////////

`FIVE: begin
	if (iDir) begin
		oData <= {iData[`FIVE-1:0],iData[W_SIZE-1:`FIVE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIVE-1:0],iData[W_SIZE-1:W_SIZE-`FIVE]};
	end
end
///////////////////////////////////////

`SIX: begin
	if (iDir) begin
		oData <= {iData[`SIX-1:0],iData[W_SIZE-1:`SIX]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`SIX-1:0],iData[W_SIZE-1:W_SIZE-`SIX]};
	end
end
///////////////////////////////////////

`SEVEN: begin
	if (iDir) begin
		oData <= {iData[`SEVEN-1:0],iData[W_SIZE-1:`SEVEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`SEVEN-1:0],iData[W_SIZE-1:W_SIZE-`SEVEN]};
	end
end
///////////////////////////////////////

`EIGHT: begin
	if (iDir) begin
		oData <= {iData[`EIGHT-1:0],iData[W_SIZE-1:`EIGHT]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`EIGHT-1:0],iData[W_SIZE-1:W_SIZE-`EIGHT]};
	end
end
///////////////////////////////////////

`NINE: begin
	if (iDir) begin
		oData <= {iData[`NINE-1:0],iData[W_SIZE-1:`NINE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`NINE-1:0],iData[W_SIZE-1:W_SIZE-`NINE]};
	end
end
///////////////////////////////////////

`TEN: begin
	if (iDir) begin
		oData <= {iData[`TEN-1:0],iData[W_SIZE-1:`TEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TEN-1:0],iData[W_SIZE-1:W_SIZE-`TEN]};
	end
end
///////////////////////////////////////

`ELEVEN: begin
	if (iDir) begin
		oData <= {iData[`ELEVEN-1:0],iData[W_SIZE-1:`ELEVEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`ELEVEN-1:0],iData[W_SIZE-1:W_SIZE-`ELEVEN]};
	end
end
///////////////////////////////////////

`TWELVE: begin
	if (iDir) begin
		oData <= {iData[`TWELVE-1:0],iData[W_SIZE-1:`TWELVE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWELVE-1:0],iData[W_SIZE-1:W_SIZE-`TWELVE]};
	end
end
///////////////////////////////////////

`THIRTEEN: begin
	if (iDir) begin
		oData <= {iData[`THIRTEEN-1:0],iData[W_SIZE-1:`THIRTEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTEEN-1:0],iData[W_SIZE-1:W_SIZE-`THIRTEEN]};
	end
end
///////////////////////////////////////

`FOURTEEN: begin
	if (iDir) begin
		oData <= {iData[`FOURTEEN-1:0],iData[W_SIZE-1:`FOURTEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FOURTEEN-1:0],iData[W_SIZE-1:W_SIZE-`FOURTEEN]};
	end
end
///////////////////////////////////////

`FIFTEEN: begin
	if (iDir) begin
		oData <= {iData[`FIFTEEN-1:0],iData[W_SIZE-1:`FIFTEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIFTEEN-1:0],iData[W_SIZE-1:W_SIZE-`FIFTEEN]};
	end
end
///////////////////////////////////////

`SIXTEEN: begin
	if (iDir) begin
		oData <= {iData[`SIXTEEN-1:0],iData[W_SIZE-1:`SIXTEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`SIXTEEN-1:0],iData[W_SIZE-1:W_SIZE-`SIXTEEN]};
	end
end
///////////////////////////////////////

`SEVENTEEN: begin
	if (iDir) begin
		oData <= {iData[`SEVENTEEN-1:0],iData[W_SIZE-1:`SEVENTEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`SEVENTEEN-1:0],iData[W_SIZE-1:W_SIZE-`SEVENTEEN]};
	end
end
///////////////////////////////////////

`EIGHTEEN: begin
	if (iDir) begin
		oData <= {iData[`EIGHTEEN-1:0],iData[W_SIZE-1:`EIGHTEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`EIGHTEEN-1:0],iData[W_SIZE-1:W_SIZE-`EIGHTEEN]};
	end
end
///////////////////////////////////////

`NINETEEN: begin
	if (iDir) begin
		oData <= {iData[`NINETEEN-1:0],iData[W_SIZE-1:`NINETEEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`NINETEEN-1:0],iData[W_SIZE-1:W_SIZE-`NINETEEN]};
	end
end
///////////////////////////////////////

`TWENTY: begin
	if (iDir) begin
		oData <= {iData[`TWENTY-1:0],iData[W_SIZE-1:`TWENTY]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY]};
	end
end
///////////////////////////////////////

`TWENTY_ONE: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_ONE-1:0],iData[W_SIZE-1:`TWENTY_ONE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_ONE-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_ONE]};
	end
end
///////////////////////////////////////

`TWENTY_TWO: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_TWO-1:0],iData[W_SIZE-1:`TWENTY_TWO]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_TWO-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_TWO]};
	end
end
///////////////////////////////////////

`TWENTY_THREE: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_THREE-1:0],iData[W_SIZE-1:`TWENTY_THREE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_THREE-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_THREE]};
	end
end
///////////////////////////////////////

`TWENTY_FOUR: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_FOUR-1:0],iData[W_SIZE-1:`TWENTY_FOUR]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_FOUR-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_FOUR]};
	end
end
///////////////////////////////////////

`TWENTY_FIVE: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_FIVE-1:0],iData[W_SIZE-1:`TWENTY_FIVE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_FIVE-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_FIVE]};
	end
end
///////////////////////////////////////

`TWENTY_SIX: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_SIX-1:0],iData[W_SIZE-1:`TWENTY_SIX]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_SIX-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_SIX]};
	end
end
///////////////////////////////////////

`TWENTY_SEVEN: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_SEVEN-1:0],iData[W_SIZE-1:`TWENTY_SEVEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_SEVEN-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_SEVEN]};
	end
end
///////////////////////////////////////

`TWENTY_EIGHT: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_EIGHT-1:0],iData[W_SIZE-1:`TWENTY_EIGHT]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_EIGHT-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_EIGHT]};
	end
end
///////////////////////////////////////

`TWENTY_NINE: begin
	if (iDir) begin
		oData <= {iData[`TWENTY_NINE-1:0],iData[W_SIZE-1:`TWENTY_NINE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`TWENTY_NINE-1:0],iData[W_SIZE-1:W_SIZE-`TWENTY_NINE]};
	end
end
///////////////////////////////////////

`THIRTY: begin
	if (iDir) begin
		oData <= {iData[`THIRTY-1:0],iData[W_SIZE-1:`THIRTY]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTY-1:0],iData[W_SIZE-1:W_SIZE-`THIRTY]};
	end
end
///////////////////////////////////////

`THIRTY_ONE: begin
	if (iDir) begin
		oData <= {iData[`THIRTY_ONE-1:0],iData[W_SIZE-1:`THIRTY_ONE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTY_ONE-1:0],iData[W_SIZE-1:W_SIZE-`THIRTY_ONE]};
	end
end
///////////////////////////////////////

`THIRTY_TWO: begin
	if (iDir) begin
		oData <= {iData[`THIRTY_TWO-1:0],iData[W_SIZE-1:`THIRTY_TWO]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTY_TWO-1:0],iData[W_SIZE-1:W_SIZE-`THIRTY_TWO]};
	end
end
///////////////////////////////////////

`THIRTY_THREE: begin
	if (iDir) begin
		oData <= {iData[`THIRTY_THREE-1:0],iData[W_SIZE-1:`THIRTY_THREE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTY_THREE-1:0],iData[W_SIZE-1:W_SIZE-`THIRTY_THREE]};
	end
end
///////////////////////////////////////

`THIRTY_FOUR: begin
	if (iDir) begin
		oData <= {iData[`THIRTY_FOUR-1:0],iData[W_SIZE-1:`THIRTY_FOUR]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTY_FOUR-1:0],iData[W_SIZE-1:W_SIZE-`THIRTY_FOUR]};
	end
end
///////////////////////////////////////

`THIRTY_FIVE: begin
	if (iDir) begin
		oData <= {iData[`THIRTY_FIVE-1:0],iData[W_SIZE-1:`THIRTY_FIVE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTY_FIVE-1:0],iData[W_SIZE-1:W_SIZE-`THIRTY_FIVE]};
	end
end
///////////////////////////////////////

`THIRTY_SIX: begin
	if (iDir) begin
		oData <= {iData[`THIRTY_SIX-1:0],iData[W_SIZE-1:`THIRTY_SIX]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTY_SIX-1:0],iData[W_SIZE-1:W_SIZE-`THIRTY_SIX]};
	end
end
///////////////////////////////////////

`THIRTY_SEVEN: begin
	if (iDir) begin
		oData <= {iData[`THIRTY_SEVEN-1:0],iData[W_SIZE-1:`THIRTY_SEVEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTY_SEVEN-1:0],iData[W_SIZE-1:W_SIZE-`THIRTY_SEVEN]};
	end
end
///////////////////////////////////////

`THIRTY_EIGHT: begin
	if (iDir) begin
		oData <= {iData[`THIRTY_EIGHT-1:0],iData[W_SIZE-1:`THIRTY_EIGHT]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTY_EIGHT-1:0],iData[W_SIZE-1:W_SIZE-`THIRTY_EIGHT]};
	end
end
///////////////////////////////////////

`THIRTY_NINE: begin
	if (iDir) begin
		oData <= {iData[`THIRTY_NINE-1:0],iData[W_SIZE-1:`THIRTY_NINE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`THIRTY_NINE-1:0],iData[W_SIZE-1:W_SIZE-`THIRTY_NINE]};
	end
end
///////////////////////////////////////

`FORTY: begin
	if (iDir) begin
		oData <= {iData[`FORTY-1:0],iData[W_SIZE-1:`FORTY]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FORTY-1:0],iData[W_SIZE-1:W_SIZE-`FORTY]};
	end
end
///////////////////////////////////////

`FORTY_ONE: begin
	if (iDir) begin
		oData <= {iData[`FORTY_ONE-1:0],iData[W_SIZE-1:`FORTY_ONE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FORTY_ONE-1:0],iData[W_SIZE-1:W_SIZE-`FORTY_ONE]};
	end
end
///////////////////////////////////////

`FORTY_TWO: begin
	if (iDir) begin
		oData <= {iData[`FORTY_TWO-1:0],iData[W_SIZE-1:`FORTY_TWO]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FORTY_TWO-1:0],iData[W_SIZE-1:W_SIZE-`FORTY_TWO]};
	end
end
///////////////////////////////////////

`FORTY_THREE: begin
	if (iDir) begin
		oData <= {iData[`FORTY_THREE-1:0],iData[W_SIZE-1:`FORTY_THREE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FORTY_THREE-1:0],iData[W_SIZE-1:W_SIZE-`FORTY_THREE]};
	end
end
///////////////////////////////////////

`FORTY_FOUR: begin
	if (iDir) begin
		oData <= {iData[`FORTY_FOUR-1:0],iData[W_SIZE-1:`FORTY_FOUR]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FORTY_FOUR-1:0],iData[W_SIZE-1:W_SIZE-`FORTY_FOUR]};
	end
end
///////////////////////////////////////

`FORTY_FIVE: begin
	if (iDir) begin
		oData <= {iData[`FORTY_FIVE-1:0],iData[W_SIZE-1:`FORTY_FIVE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FORTY_FIVE-1:0],iData[W_SIZE-1:W_SIZE-`FORTY_FIVE]};
	end
end
///////////////////////////////////////
`FORTY_SIX: begin
	if (iDir) begin
		oData <= {iData[`FORTY_SIX-1:0],iData[W_SIZE-1:`FORTY_SIX]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FORTY_SIX-1:0],iData[W_SIZE-1:W_SIZE-`FORTY_SIX]};
	end
end
///////////////////////////////////////

`FORTY_SEVEN: begin
	if (iDir) begin
		oData <= {iData[`FORTY_SEVEN-1:0],iData[W_SIZE-1:`FORTY_SEVEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FORTY_SEVEN-1:0],iData[W_SIZE-1:W_SIZE-`FORTY_SEVEN]};
	end
end
///////////////////////////////////////

`FORTY_EIGHT: begin
	if (iDir) begin
		oData <= {iData[`FORTY_EIGHT-1:0],iData[W_SIZE-1:`FORTY_EIGHT]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FORTY_EIGHT-1:0],iData[W_SIZE-1:W_SIZE-`FORTY_EIGHT]};
	end
end
///////////////////////////////////////

`FORTY_NINE: begin
	if (iDir) begin
		oData <= {iData[`FORTY_NINE-1:0],iData[W_SIZE-1:`FORTY_NINE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FORTY_NINE-1:0],iData[W_SIZE-1:W_SIZE-`FORTY_NINE]};
	end
end
///////////////////////////////////////

`FIFTY: begin
	if (iDir) begin
		oData <= {iData[`FIFTY-1:0],iData[W_SIZE-1:`FIFTY]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIFTY-1:0],iData[W_SIZE-1:W_SIZE-`FIFTY]};
	end
end
///////////////////////////////////////

`FIFTY_ONE: begin
	if (iDir) begin
		oData <= {iData[`FIFTY_ONE-1:0],iData[W_SIZE-1:`FIFTY_ONE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIFTY_ONE-1:0],iData[W_SIZE-1:W_SIZE-`FIFTY_ONE]};
	end
end
///////////////////////////////////////

`FIFTY_TWO: begin
	if (iDir) begin
		oData <= {iData[`FIFTY_TWO-1:0],iData[W_SIZE-1:`FIFTY_TWO]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIFTY_TWO-1:0],iData[W_SIZE-1:W_SIZE-`FIFTY_TWO]};
	end
end
///////////////////////////////////////

`FIFTY_THREE: begin
	if (iDir) begin
		oData <= {iData[`FIFTY_THREE-1:0],iData[W_SIZE-1:`FIFTY_THREE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIFTY_THREE-1:0],iData[W_SIZE-1:W_SIZE-`FIFTY_THREE]};
	end
end
///////////////////////////////////////

`FIFTY_FOUR: begin
	if (iDir) begin
		oData <= {iData[`FIFTY_FOUR-1:0],iData[W_SIZE-1:`FIFTY_FOUR]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIFTY_FOUR-1:0],iData[W_SIZE-1:W_SIZE-`FIFTY_FOUR]};
	end
end
///////////////////////////////////////

`FIFTY_FIVE: begin
	if (iDir) begin
		oData <= {iData[`FIFTY_FIVE-1:0],iData[W_SIZE-1:`FIFTY_FIVE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIFTY_FIVE-1:0],iData[W_SIZE-1:W_SIZE-`FIFTY_FIVE]};
	end
end
///////////////////////////////////////

`FIFTY_SIX: begin
	if (iDir) begin
		oData <= {iData[`FIFTY_SIX-1:0],iData[W_SIZE-1:`FIFTY_SIX]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIFTY_SIX-1:0],iData[W_SIZE-1:W_SIZE-`FIFTY_SIX]};
	end
end
///////////////////////////////////////

`FIFTY_SEVEN: begin
	if (iDir) begin
		oData <= {iData[`FIFTY_SEVEN-1:0],iData[W_SIZE-1:`FIFTY_SEVEN]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIFTY_SEVEN-1:0],iData[W_SIZE-1:W_SIZE-`FIFTY_SEVEN]};
	end
end
///////////////////////////////////////

`FIFTY_EIGHT: begin
	if (iDir) begin
		oData <= {iData[`FIFTY_EIGHT-1:0],iData[W_SIZE-1:`FIFTY_EIGHT]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIFTY_EIGHT-1:0],iData[W_SIZE-1:W_SIZE-`FIFTY_EIGHT]};
	end
end
///////////////////////////////////////

`FIFTY_NINE: begin
	if (iDir) begin
		oData <= {iData[`FIFTY_NINE-1:0],iData[W_SIZE-1:`FIFTY_NINE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`FIFTY_NINE-1:0],iData[W_SIZE-1:W_SIZE-`FIFTY_NINE]};
	end
end
///////////////////////////////////////

`SIXTY: begin
	if (iDir) begin
		oData <= {iData[`SIXTY-1:0],iData[W_SIZE-1:`SIXTY]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`SIXTY-1:0],iData[W_SIZE-1:W_SIZE-`SIXTY]};
	end
end
///////////////////////////////////////

`SIXTY_ONE: begin
	if (iDir) begin
		oData <= {iData[`SIXTY_ONE-1:0],iData[W_SIZE-1:`SIXTY_ONE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`SIXTY_ONE-1:0],iData[W_SIZE-1:W_SIZE-`SIXTY_ONE]};
	end
end
///////////////////////////////////////

`SIXTY_TWO: begin
	if (iDir) begin
		oData <= {iData[`SIXTY_TWO-1:0],iData[W_SIZE-1:`SIXTY_TWO]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`SIXTY_TWO-1:0],iData[W_SIZE-1:W_SIZE-`SIXTY_TWO]};
	end
end
///////////////////////////////////////

`SIXTY_THREE: begin
	if (iDir) begin
		oData <= {iData[`SIXTY_THREE-1:0],iData[W_SIZE-1:`SIXTY_THREE]}; 
	end
	else begin
		oData <= {iData[W_SIZE-`SIXTY_THREE-1:0],iData[W_SIZE-1:W_SIZE-`SIXTY_THREE]};
	end
end
endcase
end

endmodule

