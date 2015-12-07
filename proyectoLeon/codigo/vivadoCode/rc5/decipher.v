`define IDLE 4'd0
`define INIT 4'd1
`define WAIT_ADDR 4'd2
`define READ_DATA 4'd3
`define RES_B_S 4'd4
`define ROT_B 4'd5
`define XOR_B 4'd6
`define RES_A_S 4'd7
`define ROT_A 4'd8
`define XOR_A 4'd9
`define CHANGE_ADDR 4'd10
`define READ_FINAL 4'd11
`define OPER_FINAL 4'd12

`define barrel32

module decipher
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
	output reg [W-1:0] oA_decipher,
	output reg [W-1:0] oB_decipher,
	output reg oDone
);
	//*********************************
	parameter R_BIT = $clog2(R);
	parameter ROT_VALUE = $clog2(W);
	parameter T = 2*(R+1);
	parameter T_LENGTH = $clog2(T);
	//*********************************
	reg [3:0] state;
	reg [R_BIT-1:0] rCount;
	reg [W-1:0] rAorB;
	reg [ROT_VALUE-1:0] rRot_value;
	//*********************************
	reg [R_BIT-1:0] rCount_nxt;
	reg [W-1:0] rAorB_nxt;
	reg [ROT_VALUE-1:0] rRot_value_nxt;
	reg [W-1:0] oS_address1_nxt;
	reg [W-1:0] oS_address2_nxt;
	reg [W-1:0] oA_decipher_nxt;
	reg [W-1:0] oB_decipher_nxt;
	reg oDone_nxt;
	//*********************************
	wire [W-1:0] wAorB_rot;
	
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
		.iData(rAorB),
		.iRotate(rRot_value),
		.iDir(1),
		.oData(wAorB_rot)
	);
	//********************************
	always @(*) begin
		case (state)
			`IDLE: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_decipher_nxt = oA_decipher;
				oB_decipher_nxt = oB_decipher;
				rCount_nxt = rCount;
				rAorB_nxt = rAorB;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end			
			////////////////////////
			`INIT: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_decipher_nxt = iA;
				oB_decipher_nxt = iB;
				rCount_nxt = rCount;
				rAorB_nxt = rAorB;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`WAIT_ADDR: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_decipher_nxt = oA_decipher;
				oB_decipher_nxt = oB_decipher;
				rCount_nxt = rCount;
				rAorB_nxt = rAorB;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`READ_DATA: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_decipher_nxt = oA_decipher;
				oB_decipher_nxt = oB_decipher;
				rCount_nxt = rCount;
				rAorB_nxt = rAorB;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`RES_B_S: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_decipher_nxt = oA_decipher;

				// Resta B - S[2*i+1]
				oB_decipher_nxt = oB_decipher - iS_sub_i2;
				rCount_nxt = rCount;
				// Pongo el valor a rotar como B - S [2*i+1]
				rAorB_nxt = oB_decipher_nxt;
				// Roto ese valor A bits.
				rRot_value_nxt = oA_decipher;

				oDone_nxt = oDone;				
			end
			////////////////////////
			`ROT_B: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_decipher_nxt = oA_decipher;

				// Guardo el valor rotado en B.
				oB_decipher_nxt = wAorB_rot;
				rCount_nxt = rCount;
				rAorB_nxt = rAorB;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`XOR_B: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_decipher_nxt = oA_decipher;

				// Realizo la operacion B xor A y guardo en B.
				oB_decipher_nxt = oB_decipher ^ oA_decipher;
				rCount_nxt = rCount;
				rAorB_nxt = rAorB;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
				
			end
			////////////////////////
			`RES_A_S: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				// Resto A - S[2*i]
				oA_decipher_nxt = oA_decipher - iS_sub_i1;
				oB_decipher_nxt = oB_decipher;
				rCount_nxt = rCount;
				// Pongo el valor a rotar como A - S [2*i]
				rAorB_nxt = oA_decipher_nxt;
				// Roto ese valor B bits.
				rRot_value_nxt = oB_decipher;
				oDone_nxt = oDone;
			end
			////////////////////////
			`ROT_A: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;

				// Guardo el valor rotado en A.
				oA_decipher_nxt = wAorB_rot;
				oB_decipher_nxt = oB_decipher;
				rCount_nxt = rCount;
				rAorB_nxt = rAorB;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`XOR_A: begin
				// cambio direcciones
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				// hago A xor B y lo guardo en A.
				oA_decipher_nxt = oA_decipher ^ oB_decipher;
				oB_decipher_nxt = oB_decipher;
				rCount_nxt = rCount - 1;
				rAorB_nxt = rAorB;
				rRot_value_nxt = rRot_value;

				if(rCount == 1) begin
					oDone_nxt = 1;
				end
				else begin
					oDone_nxt = oDone;					
				end
			end
			`CHANGE_ADDR: begin
				oS_address1_nxt = rCount << 1;
				oS_address2_nxt = (rCount<<1) + 1;

				// Guardo el valor rotado en A.
				oA_decipher_nxt = oA_decipher;
				oB_decipher_nxt = oB_decipher;
				rCount_nxt = rCount;
				rAorB_nxt = rAorB;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
				
			end
			////////////////////////
			`READ_FINAL: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_decipher_nxt = oA_decipher;
				oB_decipher_nxt = oB_decipher;
				rCount_nxt = rCount;
				rAorB_nxt = rAorB;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			`OPER_FINAL: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;

				// Se realiza la operacion final A - S[0]
				oA_decipher_nxt = oA_decipher - iS_sub_i1;
				// Se realiza la operacion final B - S[1]
				oB_decipher_nxt = oB_decipher - iS_sub_i2;

				rCount_nxt = rCount;
				rAorB_nxt = rAorB;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
			////////////////////////
			default: begin
				oS_address1_nxt = oS_address1;
				oS_address2_nxt = oS_address2;
				oA_decipher_nxt = oA_decipher;
				oB_decipher_nxt = oB_decipher;
				rCount_nxt = rCount;
				rAorB_nxt = rAorB;
				rRot_value_nxt = rRot_value;
				oDone_nxt = oDone;
			end
		endcase
	end
	//***********************************************************************
	always @(posedge clk) begin
      	if (!iStart || rst)
      		state <= `IDLE;
      	else
  			case (state)
                ///////////////////////
                `IDLE: begin
                    if (iStart) begin
                    	state <= `INIT;
                    end
                    else begin
                    	state <= `IDLE;
                    end
                end
                ////////////////////////
                `INIT: begin
                	state <= `WAIT_ADDR;
                end
                ////////////////////////
				`WAIT_ADDR: begin
					if (oDone) begin
						state <= `WAIT_ADDR;
					end
					else begin
						state <= `READ_DATA;
					end
				end
				////////////////////////
				`READ_DATA: begin
					state <= `RES_B_S;
				end
				////////////////////////
				`RES_B_S: begin
					state <= `ROT_B;
				end
				////////////////////////
				`ROT_B: begin
					state <= `XOR_B;
				end
				////////////////////////
				`XOR_B: begin
					state <= `RES_A_S;
				end
				////////////////////////
				`RES_A_S: begin
					state <= `ROT_A;
				end
				////////////////////////
				`ROT_A: begin
					state <= `XOR_A;
				end
				////////////////////////
				`XOR_A: begin
					state <= `CHANGE_ADDR;
				end
				////////////////////////
				`CHANGE_ADDR: begin
					if(oDone) begin 
						state <= `READ_FINAL;
					end

					else begin
						state <= `WAIT_ADDR;
					end

				end
				////////////////////////
				`READ_FINAL: begin
					state <= `OPER_FINAL;
				end
				////////////////////////
				`OPER_FINAL: begin
					state <= `WAIT_ADDR;
				end
				////////////////////////
                default: begin
                	state <= `IDLE;
                end
    		endcase
	end
	//************************************************************************
	always @(posedge clk) begin
		if (!iStart || rst) begin
			oS_address1 <= R<<1;
			oS_address2 <= (R<<1) + 1;
			oA_decipher <= 0;
			oB_decipher <= 0;
			rCount <= R;
			rAorB <= 0;
			rRot_value <= 0;
			oDone <= 0;	
		end
		else begin
			oS_address1 <= oS_address1_nxt;
			oS_address2 <= oS_address2_nxt;
			oA_decipher <= oA_decipher_nxt;
			oB_decipher <= oB_decipher_nxt;
			rCount <= rCount_nxt;
			rAorB <= rAorB_nxt;
			rRot_value <= rRot_value_nxt;
			oDone <= oDone_nxt;
		end
	end

	



endmodule