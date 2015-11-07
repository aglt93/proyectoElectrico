`include "barrelShifter.v"

module cipher
#(

	parameter W = 32,
	parameter R = 12
)

(
	input wire clk,
	input wire rst,
	//
	input wire [W-1:0] iA,
	input wire [W-1:0] iB,
	//
	output reg [W-1:0] oS_address,
	input wire [W-1:0] iS_sub_i,
	//
	output wire [W-1:0] oA_cipher,
	output wire [W-1:0] oB_cipher
);

	parameter R_BIT = $clog2(R);
	//parameter R_SIZE = 2**R_BIT;
	parameter ROT_VALUE = $clog2(W);

	reg [R_BIT-1:0] rCount;

	wire [W-1:0] wA_XOR_B_rot;
	wire [W-1:0] wA_XOR_B;


	barrelShifter32
	(
		.iData(wA_XOR_B),
		.iRotate(oB_cipher[ROT_VALUE-1:0]),
		.iDir(0),
		.oData(wA_XOR_B_rot)
	);

	



endmodule