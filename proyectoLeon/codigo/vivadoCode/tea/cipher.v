`timescale 1ns/10ps

`define IDLE 4'd0
`define ADD_DELTA 4'd1
`define SHIFT_V1_ADD_K0 4'd2
`define ADD_V1_SUM 4'd3
`define SHIFT_V1_ADD_K1 4'd4
`define XOR_ALL1 4'd5
`define ADD_ALL1 4'd6
`define SHIFT_V0_ADD_K2 4'd7
`define ADD_V0_SUM 4'd8
`define SHIFT_V0_ADD_K3 4'd9
`define XOR_ALL2 4'd10
`define ADD_ALL2 4'd11
`define DONE 4'd12

module cipher 
#(
	parameter WORD_SIZE = 16,
	parameter DELTA = 32'h9e3779b9,
	parameter ROUND_NUMBER = 32
)

(
	input wire clk,
	input wire rst,
	input wire iStart,
	// Texto plano
	input wire [WORD_SIZE-1:0] iV0,
	input wire [WORD_SIZE-1:0] iV1,
	// Llave
	input wire [WORD_SIZE-1:0] iK0,
	input wire [WORD_SIZE-1:0] iK1,
	input wire [WORD_SIZE-1:0] iK2,
	input wire [WORD_SIZE-1:0] iK3,
	// Texto cifrado
	output reg [WORD_SIZE-1:0] oC0,
	output reg [WORD_SIZE-1:0] oC1,
	output reg oDone
);

	parameter ROUND_NUMBER_BITS = $clog2(ROUND_NUMBER);

	reg [3:0] state;
	//
	reg [WORD_SIZE-1:0] rAux1;
	reg [WORD_SIZE-1:0] rAux2;
	reg [WORD_SIZE-1:0] rAux3;
	reg [WORD_SIZE-1:0] sum;
	reg [ROUND_NUMBER_BITS-1:0] rCount;
	//
	reg [WORD_SIZE-1:0] rAux1_nxt;
	reg [WORD_SIZE-1:0] rAux2_nxt;
	reg [WORD_SIZE-1:0] rAux3_nxt;
	reg [WORD_SIZE-1:0] sum_nxt;
	reg [ROUND_NUMBER_BITS-1:0] rCount_nxt;
	//
	reg [WORD_SIZE-1:0] oC0_nxt;
	reg [WORD_SIZE-1:0] oC1_nxt;
	reg oDone_nxt;


	// COMBINATIONAL LOGIC
	always@(*) begin

		case (state)
			///////////////////////////
			`IDLE: begin
				rAux1_nxt = rAux1;
				rAux2_nxt = rAux2;
				rAux3_nxt = rAux3;
				oC0_nxt = oC0;
				oC1_nxt = oC1;
				sum_nxt = sum;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`ADD_DELTA: begin
				rAux1_nxt = rAux1;
				rAux2_nxt = rAux2;
				rAux3_nxt = rAux3;
				oC0_nxt = oC0;
				oC1_nxt = oC1;
				sum_nxt = sum + DELTA;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`SHIFT_V1_ADD_K0: begin
				rAux1_nxt = (oC1<<4) + iK0;
				rAux2_nxt = rAux2;
				rAux3_nxt = rAux3;
				oC0_nxt = oC0;
				oC1_nxt = oC1;
				sum_nxt = sum;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`ADD_V1_SUM: begin
				rAux1_nxt = rAux1;
				rAux2_nxt = oC1 + sum;
				rAux3_nxt = rAux3;
				oC0_nxt = oC0;
				oC1_nxt = oC1;
				sum_nxt = sum;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`SHIFT_V1_ADD_K1: begin
				rAux1_nxt = rAux1;
				rAux2_nxt = rAux2;
				rAux3_nxt = (oC1>>5) + iK1;
				oC0_nxt = oC0;
				oC1_nxt = oC1;
				sum_nxt = sum;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`XOR_ALL1: begin
				rAux1_nxt = rAux1;
				rAux2_nxt = rAux2;
				rAux3_nxt = rAux1^rAux2^rAux3;
				oC0_nxt = oC0;
				oC1_nxt = oC1;
				sum_nxt = sum;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`ADD_ALL1: begin
				rAux1_nxt = rAux1;
				rAux2_nxt = rAux2;
				rAux3_nxt = rAux3;
				oC0_nxt = oC0 + rAux3;
				oC1_nxt = oC1;
				sum_nxt = sum;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`SHIFT_V0_ADD_K2: begin
				rAux1_nxt = (oC0<<4) + iK2;
				rAux2_nxt = rAux2;
				rAux3_nxt = rAux3;
				oC0_nxt = oC0;
				oC1_nxt = oC1;
				sum_nxt = sum;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`ADD_V0_SUM: begin
				rAux1_nxt = rAux1;
				rAux2_nxt = oC0 + sum;
				rAux3_nxt = rAux3;
				oC0_nxt = oC0;
				oC1_nxt = oC1;
				sum_nxt = sum;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`SHIFT_V0_ADD_K3: begin
				rAux1_nxt = rAux1;
				rAux2_nxt = rAux2;
				rAux3_nxt = (oC0>>5) + iK3;
				oC0_nxt = oC0;
				oC1_nxt = oC1;
				sum_nxt = sum;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`XOR_ALL2: begin
				rAux1_nxt = rAux1;
				rAux2_nxt = rAux2;
				rAux3_nxt = rAux1^rAux2^rAux3;
				oC0_nxt = oC0;
				oC1_nxt = oC1;
				sum_nxt = sum;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`ADD_ALL2: begin
				rAux1_nxt = rAux1;
				rAux2_nxt = rAux2;
				rAux3_nxt = rAux3;
				oC0_nxt = oC0;
				oC1_nxt = oC1 + rAux3;
				sum_nxt = sum;
				rCount_nxt = rCount+1;

				if(rCount == ROUND_NUMBER-1) begin
					oDone_nxt = 1;
				end

				else begin
					oDone_nxt = oDone;
				end
			end
			//////////////////////////
			`DONE: begin
				rAux1_nxt = rAux1;
				rAux2_nxt = rAux2;
				rAux3_nxt = rAux3;
				oC0_nxt = oC0;
				oC1_nxt = oC1;
				sum_nxt = sum;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end

			default: begin
				rAux1_nxt = rAux1;
				rAux2_nxt = rAux2;
				rAux3_nxt = rAux3;
				oC0_nxt = oC0;
				oC1_nxt = oC1;
				sum_nxt = sum;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end

		endcase
	end


	// NEXT STATE LOGIC
	always@(posedge clk) begin
		
		if(!iStart || rst) begin
			state <= `IDLE;
		end

		else begin

			case(state)
				///////////////////////////
				`IDLE: begin
					if (!iStart) begin
						state <= `IDLE;
					end
					else begin
						state <= `ADD_DELTA;
					end
				end
				///////////////////////////
				`ADD_DELTA: begin
					state <= `SHIFT_V1_ADD_K0;
				end
				///////////////////////////
				`SHIFT_V1_ADD_K0: begin
					state <= `ADD_V1_SUM;
				end
				///////////////////////////
				`ADD_V1_SUM: begin
					state <= `SHIFT_V1_ADD_K1;
				end
				///////////////////////////
				`SHIFT_V1_ADD_K1: begin
					state <= `XOR_ALL1;
				end
				///////////////////////////
				`XOR_ALL1: begin
					state <= `ADD_ALL1;
				end
				///////////////////////////
				`ADD_ALL1: begin
					state <= `SHIFT_V0_ADD_K2;
				end
				///////////////////////////
				`SHIFT_V0_ADD_K2: begin
					state <= `ADD_V0_SUM;
				end
				///////////////////////////
				`ADD_V0_SUM: begin
					state <= `SHIFT_V0_ADD_K3;
				end
				///////////////////////////
				`SHIFT_V0_ADD_K3: begin
					state <= `XOR_ALL2;
				end
				///////////////////////////
				`XOR_ALL2: begin
					state <= `ADD_ALL2;
				end
				///////////////////////////
				`ADD_ALL2: begin
					state <= `DONE;
				end
				///////////////////////////
				`DONE: begin
					if(oDone) begin
						state <= `DONE;
					end
					
					else begin
						state <= `ADD_DELTA;
					end
				end
				//////////////////////////
				default: begin
					state <= `IDLE;
				end
			endcase
		end
	end


	// OUTPUT LOGIC
	always @(posedge clk) begin

		if (!iStart || rst) begin
			rAux1 <= 0;
			rAux2 <= 0;
			rAux3 <= 0;
			oC0 <= iV0;
			oC1 <= iV1;
			sum <= 0;
			rCount <= 0;
			oDone <= 0;
		end
		else begin
			rAux1 <= rAux1_nxt;
			rAux2 <= rAux2_nxt;
			rAux3 <= rAux3_nxt;
			oC0 <= oC0_nxt;
			oC1 <= oC1_nxt;
			sum <= sum_nxt;
			rCount <= rCount_nxt;
			oDone <= oDone_nxt;
		end
	end

endmodule