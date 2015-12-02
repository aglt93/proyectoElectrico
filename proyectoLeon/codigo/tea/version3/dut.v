`define WORD_SIZE 32
`define DELTA 32'h9e3779b9
`define ROUND_NUMBER 32
`define NO_XILLINX

`ifdef NO_XILLINX
	`include "cipher.v"
	`include "decipher.v"
	`include "key.v"
`endif



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
	input wire [WORD_SIZE-1:0] iKey_sub_i,
	output wire [1:0] oKey_address,
	// Texto cifrado
	output reg [WORD_SIZE-1:0] oC0,
	output reg [WORD_SIZE-1:0] oC1,
	// Senales de done.
	output reg oDone
);

wire [WORD_SIZE-1:0] rK0;
wire [WORD_SIZE-1:0] rK1;
wire [WORD_SIZE-1:0] rK2;
wire [WORD_SIZE-1:0] rK3;
//
wire [WORD_SIZE-1:0] oC0_cipher;
wire [WORD_SIZE-1:0] oC1_cipher;
wire [WORD_SIZE-1:0] oC0_decipher;
wire [WORD_SIZE-1:0] oC1_decipher;

always @(*) begin
	if(iStartCipher) begin
		oC0 = oC0_cipher;
		oC1 = oC1_cipher;
		oDone = oDone_cipher;
	end
	else if(iStartDecipher) begin
		oC0 = oC0_decipher;
		oC1 = oC1_decipher;
		oDone = oDone_decipher;
	end
end

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
	.iStart(iStartCipher && doneKey),
	.iV0(iV0),
	.iV1(iV1),
	.iK0(rK0),
	.iK1(rK1),
	.iK2(rK2),
	.iK3(rK3),
	.oC0(oC0_cipher),
	.oC1(oC1_cipher),
	.oDone(oDone_cipher)	
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
	.iStart(iStartDecipher && doneKey),
	.iV0(iV0),
	.iV1(iV1),
	.iK0(rK0),
	.iK1(rK1),
	.iK2(rK2),
	.iK3(rK3),
	.oC0(oC0_decipher),
	.oC1(oC1_decipher),
	.oDone(oDone_decipher)	
);


key
#(
	.WORD_SIZE(WORD_SIZE)
)
llave
(
	.clk(clk),
	.rst(rst),
	.iStart(iStartCipher || iStartDecipher),
	.iKey_sub_i(iKey_sub_i),
	.oKey_address(oKey_address),
	.oKey0(rK0),
	.oKey1(rK1),
	.oKey2(rK2),
	.oKey3(rK3),
	.oDone(doneKey)
);

endmodule