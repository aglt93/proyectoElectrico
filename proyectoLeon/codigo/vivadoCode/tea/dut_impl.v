`define WORD_SIZE 128
`define DELTA 32'h9e3779b9
//////////////////////////////////////

`define ROUND_NUMBER 32
//`define NO_XILLINX

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
	input wire [WORD_SIZE-1:0] serial_port_in,
	output reg [WORD_SIZE-1:0] serial_port_out
);


// Entradas
reg [WORD_SIZE-1:0] iV0;
reg [WORD_SIZE-1:0] iV1;
reg [WORD_SIZE-1:0] iK0;
reg [WORD_SIZE-1:0] iK1;
reg [WORD_SIZE-1:0] iK2;
reg [WORD_SIZE-1:0] iK3;
// Salidas
wire [WORD_SIZE-1:0] oC0;
wire [WORD_SIZE-1:0] oC1;
wire [WORD_SIZE-1:0] oV0;
wire [WORD_SIZE-1:0] oV1;



//////////////// LOGICA PARA SERIALIZAR //////////////////////////
reg [3:0] muxCount;
always @(posedge clk) begin
	
	if(rst) begin
		muxCount = 0;
	end
	else begin
		muxCount = muxCount + 1;
	end

end


// Serializar entradas
always @(posedge clk) begin

	case(muxCount)

		0: begin
			iV0 <= serial_port_in;
			iV1 <= iV1;
			iK0 <= iK0;
			iK1 <= iK1;
			iK2 <= iK2;
			iK3 <= iK3;
		end

		1: begin
			iV0 <= iV0;
			iV1 <= serial_port_in;
			iK0 <= iK0;
			iK1 <= iK1;
			iK2 <= iK2;
			iK3 <= iK3;
		end

		2: begin
			iV0 <= iV0;
			iV1 <= iV1;
			iK0 <= serial_port_in;
			iK1 <= iK1;
			iK2 <= iK2;
			iK3 <= iK3;
		end


		3: begin
			iV0 <= iV0;
			iV1 <= iV1;
			iK0 <= iK0;
			iK1 <= serial_port_in;
			iK2 <= iK2;
			iK3 <= iK3;
		end

		4: begin
			iV0 <= iV0;
			iV1 <= iV1;
			iK0 <= iK0;
			iK1 <= iK1;
			iK2 <= serial_port_in;
			iK3 <= iK3;
		end

		5: begin
			iV0 <= iV0;
			iV1 <= iV1;
			iK0 <= iK0;
			iK1 <= iK1;
			iK2 <= iK2;
			iK3 <= serial_port_in;
		end

		default: begin
			iV0 <= iV0;
			iV1 <= iV1;
			iK0 <= iK0;
			iK1 <= iK1;
			iK2 <= iK2;
			iK3 <= iK3;
		end
	endcase

end


// Serializar salidas
always @(posedge clk) begin

	case(muxCount)

		0: begin
			serial_port_out <= oC0;
		end

		1: begin
			serial_port_out <= oC1;
		end

		2: begin
			serial_port_out <= oV0;
		end

		3: begin
			serial_port_out <= oV1;
		end

		default: begin
			serial_port_out <= 0;
		end
	endcase

end
//////////////// FIN LOGICA PARA SERIALIZAR //////////////////////////


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

