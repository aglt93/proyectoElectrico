`define WORD_SIZE 32
`define DELTA 32'h9e3779b9
`define ROUND_NUMBER 32
`define NO_XILLINX

`ifdef NO_XILLINX
	`include "dut.v"
`endif

module dut_impl
#(
	parameter WORD_SIZE = `WORD_SIZE,
	parameter DELTA = `DELTA,
	parameter ROUND_NUMBER = `ROUND_NUMBER
)

(
	input wire clk,
	input wire rst,
	input wire iStartCipher,
	input wire iStartDecipher,
	output wire oDoneCipher,
	output wire oDoneDecipher,
	inout reg [WORD_SIZE-1:0] serial_port
);

reg [3:0] muxCount;
always @(posedge clk) begin
	
	if(rst) begin
		muxCount = 0;
	end
	else begin
		muxCount = muxCount + 1;
	end

end



always @(posedge clk) begin

	case(muxCount)

		0: begin
			serial_port = iV0;
		end


	endcase

end

wire [WORD_SIZE-1:0] iV0;
wire [WORD_SIZE-1:0] iV1;
wire [WORD_SIZE-1:0] iK0;
wire [WORD_SIZE-1:0] iK1;
wire [WORD_SIZE-1:0] iK2;
wire [WORD_SIZE-1:0] iK3;
wire [WORD_SIZE-1:0] oC0;
wire [WORD_SIZE-1:0] oC1;
wire [WORD_SIZE-1:0] oV0;
wire [WORD_SIZE-1:0] oV1;


dut 
#(
	.WORD_SIZE(WORD_SIZE),
	.DELTA(DELTA),
	.ROUND_NUMBER(ROUND_NUMBER)
)

dut_implementacion

(
	.clk(clk),
	.rst(rst),
	.iStartCipher(iStartCipher),
	.iStartDecipher(iStartDecipher),
	.iV0(iV0),
	.iV1(iV1),
	.iK0(iK0),
	.iK1(iK1),
	.iK2(iK2),
	.iK3(iK3),
	.oC0(oC0),
	.oC1(oC1),
	.oV0(oV0),
	.oV1(oV1),
	.oDoneCipher(oDoneCipher),
	.oDoneDecipher(oDoneDecipher)	
);

endmodule

