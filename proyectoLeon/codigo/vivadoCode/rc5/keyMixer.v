`define IDLE 4'd0
`define WAIT_ADDR 4'd1
`define READ_DATA 4'd2
`define SUM_AB1 4'd3
`define SUM_S_AB 4'd4
`define ROT_S 4'd5
`define SUM_AB2 4'd6
`define SUM_L_AB 4'd7
`define WAIT_ROT_L 4'd8
`define ROT_L 4'd9
`define WRITE_DATA 4'd10

module keyMixer 
#(
	parameter W = 32,
	parameter C = 4,
	parameter T = 26
)

(
	input wire clk,
	input wire rst,
	input wire iStart,
	//
	output reg [C_LENGTH-1:0] oL_address,
	input wire [W-1:0] iL_sub_i,
    output reg [W-1:0] oL_sub_i_prima,
    // 
    input wire [W-1:0] iS_sub_i,
    output reg [T_LENGTH-1:0] oS_address,
    output reg [W-1:0] oS_sub_i_prima,
    //
    output reg oDone,
    output reg oS_we,
    output reg oL_we
);

	parameter C_LENGTH = $clog2(C);
	parameter T_LENGTH = $clog2(T);
	parameter MIXCOUNT = (T>C) ? 3*T:3*C;
	parameter MIXCOUNT_LENGTH = $clog2(MIXCOUNT);
    parameter MIXCOUNT_BIT_VALUE = 2**MIXCOUNT_LENGTH-1;
	parameter ROTVALUE = $clog2(W);

    //****************************************
	reg [W-1:0] A;
	reg [W-1:0] B;
    reg [W-1:0] rSumTemp;
    reg [MIXCOUNT_LENGTH-1:0] rCount;

    reg [3:0] state;
    wire [W-1:0] wL_rotate;
    //****************************************


    //****************************************
    reg [W-1:0] A_nxt;
    reg [W-1:0] B_nxt;
    reg [W-1:0] rSumTemp_nxt;
    reg [MIXCOUNT_LENGTH-1:0] rCount_nxt;
    reg [C_LENGTH-1:0] oL_address_nxt;
    reg [W-1:0] oL_sub_i_prima_nxt;
    reg [T_LENGTH-1:0] oS_address_nxt;
    reg [W-1:0] oS_sub_i_prima_nxt;
    reg oDone_nxt;
    reg oS_we_nxt;
    reg oL_we_nxt;
    //****************************************

    //*********************************************************************
    `ifdef barrel16
        barrelShifter16
    `endif

    `ifdef barrel32
        barrelShifter32 
    `endif

    `ifdef barrel64
        barrelShifter64 
    `endif

    barrel
    (
        .iData(oL_sub_i_prima),
        .iRotate(rSumTemp[ROTVALUE-1:0]),
        .iDir(0), //Hacia la izquierda
        .oData(wL_rotate)
    );
    //*********************************************************************

     always @(*) 
          begin
               case (state)
                    // 0
                    `IDLE: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = rSumTemp;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oL_we_nxt = oL_we;
                        oS_we_nxt = oS_we;
                    end
                    // 1
                    `WAIT_ADDR: begin
                        rCount_nxt = rCount + 1;
                        oS_address_nxt = (oS_address + 1);// % T;
                        oL_address_nxt = (oL_address + 1);// % C;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = rSumTemp;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oS_we_nxt = 0;
                        oL_we_nxt = 0;
                    end
                    // 2     
                    `READ_DATA: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = rSumTemp;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oS_we_nxt = oS_we;
                        oL_we_nxt = oL_we;
                    end
                    // 3
                    // Se realiza la suma A+B.
                    `SUM_AB1: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = A+B;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oS_we_nxt = oS_we;
                        oL_we_nxt = oL_we;
                    end
                    // 4 /////////////////////
                    `SUM_S_AB: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = rSumTemp;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = iS_sub_i + rSumTemp;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oS_we_nxt = oS_we;
                        oL_we_nxt = oL_we;
                    end
                    // 5 /////////////////////
                    `ROT_S: begin
                        rCount_nxt = rCount;
                        A_nxt = {oS_sub_i_prima[W-4:0],oS_sub_i_prima[W-1:W-3]};
                        B_nxt = B;
                        rSumTemp_nxt = rSumTemp;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = A_nxt;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oS_we_nxt = oS_we;
                        oL_we_nxt = oL_we;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                    end
                    /// 6 ////////////////////
                    `SUM_AB2: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = A + B;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oS_we_nxt = oS_we;
                        oL_we_nxt = oL_we;
                    end
                    /// 7 ////////////////////
                    `SUM_L_AB: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = rSumTemp;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = iL_sub_i + rSumTemp;
                        oS_we_nxt = oS_we;
                        oL_we_nxt = oL_we;
                    end
                    ///// 8 //////////////////
                    `WAIT_ROT_L: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = rSumTemp;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oS_we_nxt = oS_we;
                        oL_we_nxt = oL_we;
                    end
                    /////// 9 ////////////////
                    `ROT_L: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                        A_nxt = A;
                        B_nxt = wL_rotate;
                        rSumTemp_nxt = rSumTemp;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = wL_rotate;
                        oS_we_nxt = oS_we;
                        oL_we_nxt = oL_we;
                    end
                    ///// 10 //////////////////
                    `WRITE_DATA: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = rSumTemp;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oS_we_nxt = 1;
                        oL_we_nxt = 1;
                        
                         if (rCount == MIXCOUNT-1) begin
                              oDone_nxt = 1;
                         end

                         else begin
                              oDone_nxt = oDone;     
                         end
                    end

                    default: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = rSumTemp;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oL_we_nxt = oL_we;
                        oS_we_nxt = oS_we;
                    end

               endcase
          end

     always @(posedge clk)
          begin
               if (!iStart || rst)
                    state = `IDLE;
               else
                    case (state)
                        ///////////////////////
                        `IDLE: begin
                        	if (iStart) begin
                                state <= `WAIT_ADDR;
                            end
                            else begin
                                state <= `IDLE;
                            end
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
                        ///////////////////////     
                        `READ_DATA: begin
                        	state <= `SUM_AB1;	
                        end
                        ///////////////////////
                        `SUM_AB1: begin
                            state <= `SUM_S_AB;
                        end
                        ///////////////////////
                        `SUM_S_AB: begin
                           state <= `ROT_S; 
                        end
                        ///////////////////////
                        `ROT_S: begin
                            state <= `SUM_AB2;
                        end
                        ///////////////////////
                        `SUM_AB2: begin
                            state <= `SUM_L_AB;
                        end
                        ///////////////////////
                        `SUM_L_AB: begin
                            state <= `WAIT_ROT_L;
                        end
                        ///////////////////////
                        `WAIT_ROT_L: begin
                            state <= `ROT_L;
                        end
                        ///////////////////////
                        `ROT_L: begin
                            state <= `WRITE_DATA;
                        end
                        ///////////////////////
                        `WRITE_DATA: begin
                            state <= `WAIT_ADDR;
                        end
                        ///////////////////////  
                        default: begin
                            state <= `IDLE;
                        end
                    endcase
          end


        always @(posedge clk) begin
            if (!iStart || rst) begin
                rCount <= MIXCOUNT_BIT_VALUE;
                oS_address <= T-1;
                oL_address <= C-1;
                A <= 0;
                B <= 0;
                rSumTemp <= 0;
                oDone <= 0;
                oS_sub_i_prima <= 0;
                oL_sub_i_prima <= 0;
                oL_we <= 0;
                oS_we <= 0;
            end

            else begin
                rCount <= rCount_nxt;
                oS_address <= oS_address_nxt;
                oL_address <= oL_address_nxt;
                A <= A_nxt;
                B <= B_nxt;
                rSumTemp <= rSumTemp_nxt;
                oDone <= oDone_nxt;
                oS_sub_i_prima <= oS_sub_i_prima_nxt;
                oL_sub_i_prima <= oL_sub_i_prima_nxt;
                oL_we <= oL_we_nxt;
                oS_we <= oS_we_nxt;
            end
        end


endmodule