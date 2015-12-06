`define IDLE 4'd0
`define READ_INIT 4'd1
`define OPER_INIT 4'd2
`define CHANGE_ADDR 4'd3
`define WAIT_ADDR 4'd4
`define READ_DATA 4'd5
`define XOR1 4'd6
`define ROT_B 4'd7
`define SUM_A 4'd8
`define XOR2 4'd9
`define ROT_A 4'd10
`define SUM_B 4'd11


module cipher
#(

	parameter W = 32,
	parameter R = 12
)

(
	input wire clk,
	input wire rst,
	//
	input wire iStart,
	input wire [W-1:0] iA,
	input wire [W-1:0] iB,
	//
	output reg [T_LENGTH-1:0] oS_address1,
	output reg [T_LENGTH-1:0] oS_address2,
	input wire [W-1:0] iS_sub_i1,
	input wire [W-1:0] iS_sub_i2,
	//
	output reg [W-1:0] oA_cipher,
	output reg [W-1:0] oB_cipher,
	output reg oDone
);
	//*********************************
	parameter R_BIT = $clog2(R);
	parameter ROT_VALUE = $clog2(W);
	parameter T = 2*(R+1);
	parameter T_LENGTH = $clog2(T);
	//*********************************
	reg [3:0] state;
	reg [R_BIT:0] rCount;
	reg [W-1:0] rA_XOR_B;
	reg [ROT_VALUE-1:0] rRot_value;
	//*********************************
	reg [R_BIT:0] rCount_nxt;
	reg [W-1:0] rA_XOR_B_nxt;
	reg [ROT_VALUE-1:0] rRot_value_nxt;
	reg [W-1:0] oS_address1_nxt;
	reg [W-1:0] oS_address2_nxt;
	reg [W-1:0] oA_cipher_nxt;
	reg [W-1:0] oB_cipher_nxt;
	reg oDone_nxt;
	//*********************************
	wire [W-1:0] wA_XOR_B_rot;

	`ifdef barrel16
        barrelShifter16
    `endif

    `ifdef barrel32
        barrelShifter32 
    `endif

    `ifdef barrel64
        barrelShifter64 
    `endif
    
	bar
	(
		.iData(rA_XOR_B),
		.iRotate(rRot_value),
		.iDir(0),
		.oData(wA_XOR_B_rot)
	);
	//********************************
	always @(*) begin
		case (state)
			`IDLE: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_cipher_nxt = oA_cipher;
				oB_cipher_nxt = oB_cipher;
				rCount_nxt = rCount;
				rA_XOR_B_nxt = rA_XOR_B;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`READ_INIT: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_cipher_nxt = oA_cipher;
				oB_cipher_nxt = oB_cipher;
				rCount_nxt = rCount;
				rA_XOR_B_nxt = rA_XOR_B;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`OPER_INIT: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_cipher_nxt = iA + iS_sub_i1;
				oB_cipher_nxt = iB + iS_sub_i2;
				rCount_nxt = rCount;
				rA_XOR_B_nxt = rA_XOR_B;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`CHANGE_ADDR: begin
				oS_address1_nxt = rCount << 1;
				oS_address2_nxt = (rCount << 1) + 1;
				oA_cipher_nxt = oA_cipher;
				oB_cipher_nxt = oB_cipher;
				rCount_nxt = rCount;
				rA_XOR_B_nxt = rA_XOR_B;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`WAIT_ADDR: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_cipher_nxt = oA_cipher;
				oB_cipher_nxt = oB_cipher;
				rCount_nxt = rCount;
				rA_XOR_B_nxt = rA_XOR_B;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`READ_DATA: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_cipher_nxt = oA_cipher;
				oB_cipher_nxt = oB_cipher;
				rCount_nxt = rCount;
				rA_XOR_B_nxt = rA_XOR_B;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`XOR1: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_cipher_nxt = oA_cipher;
				oB_cipher_nxt = oB_cipher;
				rCount_nxt = rCount;
				rA_XOR_B_nxt = oA_cipher ^ oB_cipher;
				rRot_value_nxt = oB_cipher;
				oDone_nxt = oDone;
			end
			////////////////////////
			`ROT_B: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_cipher_nxt = oA_cipher;
				oB_cipher_nxt = oB_cipher;
				rCount_nxt = rCount;
				rA_XOR_B_nxt = rA_XOR_B;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`SUM_A: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_cipher_nxt = wA_XOR_B_rot + iS_sub_i1;
				oB_cipher_nxt = oB_cipher;
				rCount_nxt = rCount;
				rA_XOR_B_nxt = rA_XOR_B;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`XOR2: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_cipher_nxt = oA_cipher;
				oB_cipher_nxt = oB_cipher;
				rCount_nxt = rCount;
				rA_XOR_B_nxt = oA_cipher ^ oB_cipher;
				rRot_value_nxt = oA_cipher;
				oDone_nxt = oDone;
			end
			////////////////////////
			`ROT_A: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_cipher_nxt = oA_cipher;
				oB_cipher_nxt = oB_cipher;
				rCount_nxt = rCount;
				rA_XOR_B_nxt = rA_XOR_B;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`SUM_B: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_cipher_nxt = oA_cipher;
				oB_cipher_nxt = wA_XOR_B_rot + iS_sub_i2;
				rCount_nxt = rCount + 1;
				rA_XOR_B_nxt = rA_XOR_B;
				rRot_value_nxt = rRot_value;
				//$display(R);
				//$display(rCount);
				if (rCount == R) begin
					oDone_nxt = 1;
				end

				else begin
					oDone_nxt = 0;
				end
			end
			////////////////////////
			default: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_cipher_nxt = oA_cipher;
				oB_cipher_nxt = oB_cipher;
				rCount_nxt = rCount;
				rA_XOR_B_nxt = rA_XOR_B;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
		endcase
	end




	always @(posedge clk) begin
      	if (!iStart || rst)
      		state <= `IDLE;
      	else
  			case (state)
                ///////////////////////
                `IDLE: begin
                    if (iStart) begin
                    	state <= `READ_INIT;
                    end
                    else begin
                    	state <= `IDLE;
                    end
                end
                ////////////////////////
                `READ_INIT: begin
                    state <= `OPER_INIT;
                end
                ////////////////////////
                `OPER_INIT: begin
                	state <= `CHANGE_ADDR;
                end
                ////////////////////////
                `CHANGE_ADDR: begin
                	if (oDone) begin
				    	state <= `CHANGE_ADDR;
				    end

				    else begin
				    	state <= `WAIT_ADDR; 
				    end
                end
                ////////////////////////
                `WAIT_ADDR: begin
                	state <= `READ_DATA;
                end
                ////////////////////////
                `READ_DATA: begin
                	state <= `XOR1;
                end
                ////////////////////////
                `XOR1: begin
                	state <= `ROT_B;
                end
                ////////////////////////
                `ROT_B: begin
                	state <= `SUM_A;
                end
                ////////////////////////
                `SUM_A: begin
                	state <= `XOR2;
                end
                ////////////////////////
                `XOR2: begin
                	state <= `ROT_A;
                end
                ////////////////////////
                `ROT_A: begin
                	state <= `SUM_B;
                end
                ////////////////////////
                `SUM_B: begin
                	state <= `CHANGE_ADDR;
                end
                ////////////////////////
                default: begin
                	state <= `IDLE;
                end
    		endcase
	end


	always @(posedge clk) begin
		if (!iStart || rst) begin
			oS_address1 <= 0;
			oS_address2 <= 1;
			oA_cipher <= 0;
			oB_cipher <= 0;
			rCount <= 1;
			rA_XOR_B <= 0;
			rRot_value <= 0;
			oDone <= 0;	
		end
		else begin
			oS_address1 <= oS_address1_nxt;
			oS_address2 <= oS_address2_nxt;
			oA_cipher <= oA_cipher_nxt;
			oB_cipher <= oB_cipher_nxt;
			rCount <= rCount_nxt;
			rA_XOR_B <= rA_XOR_B_nxt;
			rRot_value <= rRot_value_nxt;
			oDone <= oDone_nxt;
		end
	end

	



endmodule