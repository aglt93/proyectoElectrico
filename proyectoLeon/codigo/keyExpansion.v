

module keyBytesToWords 
#(
	parameter b = 16, 
	parameter t = 26, 
	parameter w = 32,
	parameter u = 4,
	parameter c = 4
)

(
	input [w-1:0] pW,
	input [w-1:0] qW,
	input [8*b-1:0] key
);

	reg [w-1:0] S [t-1:0];
	reg [w-1:0] L [c-1:0];
	reg i = 0;

	always @(L[0]) begin 
		repeat (b) begin
			
			L[i] = (L[i]<<<8) + key[i];

		end	  	
	end 
endmodule