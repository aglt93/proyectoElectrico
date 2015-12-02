`timescale 1ns/10ps

`define IDLE 3'd0
`define WAIT_ADDR 3'd1
`define READ_DATA 3'd2
`define WRITE_DATA 3'd3
`define CHANGE_ADDR 3'd4


module key
#(
	parameter WORD_SIZE = 32
)

(
	input wire clk,
	input wire rst,
	input wire iStart, 
	input wire [WORD_SIZE-1:0] iKey_sub_i,
	output reg [WORD_SIZE_BITS-1:0] oKey_address,
	output reg [WORD_SIZE-1:0] oKey0,
	output reg [WORD_SIZE-1:0] oKey1,
	output reg [WORD_SIZE-1:0] oKey2,
	output reg [WORD_SIZE-1:0] oKey3,
	output reg oDone
);

	parameter WORD_SIZE_BITS = $clog2(4);

	reg [2:0] state;
	reg [WORD_SIZE_BITS-1:0] rCount;
	////////
	reg [WORD_SIZE_BITS-1:0] oKey_address_nxt;
	reg [WORD_SIZE-1:0] oKey0_nxt;
	reg [WORD_SIZE-1:0] oKey1_nxt;
	reg [WORD_SIZE-1:0] oKey2_nxt;
	reg [WORD_SIZE-1:0] oKey3_nxt;
	reg [WORD_SIZE_BITS-1:0] rCount_nxt;
	reg oDone_nxt;

	// COMBINATIONAL LOGIC
	always@(*) begin

		oKey_address_nxt = oKey_address;
		oKey0_nxt = oKey0;
		oKey1_nxt = oKey1;
		oKey2_nxt = oKey2;
		oKey3_nxt = oKey3;
		rCount_nxt = rCount;
		oDone_nxt = oDone;


		case (state)
			///////////////////////////
			`IDLE: begin
				oKey_address_nxt = oKey_address;
				oKey0_nxt = oKey0;
				oKey1_nxt = oKey1;
				oKey2_nxt = oKey2;
				oKey3_nxt = oKey3;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`WAIT_ADDR: begin
				oKey_address_nxt = oKey_address;
				oKey0_nxt = oKey0;
				oKey1_nxt = oKey1;
				oKey2_nxt = oKey2;
				oKey3_nxt = oKey3;
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`READ_DATA: begin
				oKey_address_nxt = oKey_address;

				oKey0_nxt = oKey0;
				oKey1_nxt = oKey1;
				oKey2_nxt = oKey2;
				oKey3_nxt = oKey3;

				case(oKey_address)

					0: begin
						oKey0_nxt = iKey_sub_i;
						oKey1_nxt = oKey1;
						oKey2_nxt = oKey2;
						oKey3_nxt = oKey3;
					end
					/////////////////////////
					1: begin
						oKey0_nxt = oKey0;
						oKey1_nxt = iKey_sub_i;
						oKey2_nxt = oKey2;
						oKey3_nxt = oKey3;
					end
					/////////////////////////
					2: begin
						oKey0_nxt = oKey0;
						oKey1_nxt = oKey1;
						oKey2_nxt = iKey_sub_i;
						oKey3_nxt = oKey3;
					end
					/////////////////////////
					3: begin
						oKey0_nxt = oKey0;
						oKey1_nxt = oKey1;
						oKey2_nxt = oKey2;
						oKey3_nxt = iKey_sub_i;
					end
				endcase
				
				rCount_nxt = rCount;
				oDone_nxt = oDone;
			end
			///////////////////////////
			`WRITE_DATA: begin
				oKey_address_nxt = oKey_address;
				oKey0_nxt = oKey0;
				oKey1_nxt = oKey1;
				oKey2_nxt = oKey2;
				oKey3_nxt = oKey3;
				rCount_nxt = rCount + 1;

				if(rCount_nxt == 0) begin
					oDone_nxt = 1;
				end

				else begin
					oDone_nxt = oDone;
				end 

			end
			///////////////////////////
			`CHANGE_ADDR: begin
				oKey_address_nxt = rCount;
				oKey0_nxt = oKey0;
				oKey1_nxt = oKey1;
				oKey2_nxt = oKey2;
				oKey3_nxt = oKey3;
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
			state <= `IDLE;

			case(state)
				///////////////////////////
				`IDLE: begin
					if (!iStart) begin
						state <= `IDLE;
					end
					else begin
						state <= `WAIT_ADDR;
					end
				end
				///////////////////////////
				`WAIT_ADDR: begin
					state <= `READ_DATA;
				end
				///////////////////////////
				`READ_DATA: begin
					state <= `WRITE_DATA;
				end
				///////////////////////////
				`WRITE_DATA: begin
					state <= `CHANGE_ADDR;
				end
				///////////////////////////
				`CHANGE_ADDR: begin
					if(oDone) begin
						state <= `CHANGE_ADDR;
					end
					
					else begin
						state <= `WAIT_ADDR;
					end
				end

			endcase
		end
	end

	// OUTPUT LOGIC
	always @(posedge clk) begin

		if (!iStart || rst) begin
			oKey_address <= 0;
			oKey0 <= 0;
			oKey1 <= 0;
			oKey2 <= 0;
			oKey3 <= 0;
			rCount <= 0;
			oDone <= 0;
		end

		else begin
			oKey_address <= oKey_address_nxt;
			oKey0 <= oKey0_nxt;
			oKey1 <= oKey1_nxt;
			oKey2 <= oKey2_nxt;
			oKey3 <= oKey3_nxt;
			rCount <= rCount_nxt;
			oDone <= oDone_nxt;
		end
	end

endmodule
