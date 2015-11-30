`include "cipher.v"
`include "decipher.v"


`define WORD_SIZE 16
`define DELTA 32'h9e3779b9
`define ROUND_NUMBER 64


module dut
#(
	parameter WORD_SIZE = `WORD_SIZE,
	parameter DELTA = `DELTA,
	parameter ROUND_NUMBER = `ROUND_NUMBER
)

(
	input wire clk,
	input wire rst,
	// Texto plano
	input wire [WORD_SIZE-1:0] iV0,
	input wire [WORD_SIZE-1:0] iV1,
	// Senales de chip select
	input wire iStartCipher,
	input wire iStartDecipher,
	// Llave
	input wire [WORD_SIZE-1:0] iK0,
	input wire [WORD_SIZE-1:0] iK1,
	input wire [WORD_SIZE-1:0] iK2,
	input wire [WORD_SIZE-1:0] iK3,
	// Texto cifrado
	output wire [WORD_SIZE-1:0] oC0,
	output wire [WORD_SIZE-1:0] oC1,
	// Texto Descifrado
	// Texto cifrado
	output wire [WORD_SIZE-1:0] oV0,
	output wire [WORD_SIZE-1:0] oV1,
	// Senales de done.
	output wire oDoneCipher,
	output wire oDoneDecipher
);

cipher 
#(
	.WORD_SIZE(WORD_SIZE),
	.DELTA(DELTA),
	.ROUND_NUMBER(ROUND_NUMBER)
)
cifrar
(
	.clk(clk),
	.rst(rst),
	.iStart(iStartCipher),
	.iV0(iV0),
	.iV1(iV1),
	.iK0(iK0),
	.iK1(iK1),
	.iK2(iK2),
	.iK3(iK3),
	.oC0(oC0),
	.oC1(oC1),
	.oDone(oDoneCipher)	
); 




decipher 
#(
	.WORD_SIZE(WORD_SIZE),
	.DELTA(DELTA),
	.ROUND_NUMBER(ROUND_NUMBER)
)
descifrar
(
	.clk(clk),
	.rst(rst),
	.iStart(iStartDecipher),
	.iV0(iV0),
	.iV1(iV1),
	.iK0(iK0),
	.iK1(iK1),
	.iK2(iK2),
	.iK3(iK3),
	.oC0(oV0),
	.oC1(oV1),
	.oDone(oDoneDecipher)	
);


endmodule