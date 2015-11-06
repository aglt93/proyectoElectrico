`define IDLE 3'b000
`define WAIT_ADDR 3'b001
`define READ_DATA 3'b010
`define OPERATE_DATA1 3'b011
`define OPERATE_DATA2 3'b100
`define OPERATE_DATA3 3'b101
`define OPERATE_DATA4 3'b110
`define WRITE_DATA 3'b111

`include "barrelShifter.v"

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

	parameter C_LENGTH = 2;
	parameter T_LENGTH = $clog2(T);
	parameter MIXCOUNT = (T>C) ? 3*T:3*C;
	parameter MIXCOUNT_LENGTH = $clog2(MIXCOUNT);
    parameter MIXCOUNT_BIT_VALUE = 2**MIXCOUNT_LENGTH-1;
	parameter ROTVALUE = $clog2(W);

    //****************************************
	reg [W-1:0] A;
	reg [W-1:0] B;
    reg [W-1:0] rSumTemp;
	reg [T_LENGTH-1:0] i;
	reg [C_LENGTH-1:0] j;
	reg [ROTVALUE-1:0] rRot_L;
    reg [MIXCOUNT_LENGTH-1:0] rCount;

    reg [2:0] state;
    wire [W-1:0] wS_rotate;
    wire [W-1:0] wS_rotate1;
    //****************************************


    //****************************************
    reg [W-1:0] A_nxt;
    reg [W-1:0] B_nxt;
    reg [W-1:0] rSumTemp_nxt;
    reg [T_LENGTH-1:0] i_nxt;
    reg [C_LENGTH-1:0] j_nxt;
    reg [ROTVALUE-1:0] rRot_L_nxt;
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
    //FFD_POSEDGE_SYNCRONOUS_RESET #(W) ffBarrel(clk,rst,1,wS_rotate1,wS_rotate);

    barrelShifter32 barrel
    (
        .iData(oS_sub_i_prima),
        .iRotate(rRot_L),
        .iDir(0), //Hacia la izquierda
        .oData(wS_rotate)
    );
    //*********************************************************************

     always @(*) 
          begin
               case (state)

                    `IDLE: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                        i_nxt = i;
                        j_nxt = j;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = rSumTemp;
                        rRot_L_nxt = rRot_L;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oL_we_nxt = oL_we;
                        oS_we_nxt = oS_we;
                    end

                    `WAIT_ADDR: begin
                        rCount_nxt = rCount+1;
                        oS_address_nxt = i;
                        oL_address_nxt = j;
                        i_nxt = i;
                        j_nxt = j;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = rSumTemp;
                        rRot_L_nxt = rRot_L;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oS_we_nxt = 0;
                        oL_we_nxt = 0;
                    end
                         
                    `READ_DATA: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = i;
                        oL_address_nxt = j;
                        i_nxt = i;
                        j_nxt = j;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = rSumTemp;
                        rRot_L_nxt = rRot_L;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oS_we_nxt = oS_we;
                        oL_we_nxt = oL_we;

                    end
                    
                    // Se realiza la suma A+B.
                    `OPERATE_DATA1: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = i;
                        oL_address_nxt = j;
                        i_nxt = i;
                        j_nxt = j;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = A+B;
                        rRot_L_nxt = rRot_L;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oS_we_nxt = oS_we;
                        oL_we_nxt = oL_we;
                    end

                    // Se realiza la asignacion de los bits que se van a rotar.
                    // Se realiza la suma S[i] + A + B.
                    // Se realiza la suma L[j] + A + B.
                    `OPERATE_DATA2: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = i;
                        oL_address_nxt = j;
                        i_nxt = i;
                        j_nxt = j;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp<= rSumTemp;
                        rRot_L_nxt = rSumTemp[ROTVALUE-1:0];
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = iS_sub_i + rSumTemp;
                        oL_sub_i_prima_nxt = iL_sub_i + rSumTemp;
                        oS_we_nxt = oS_we;
                        oL_we_nxt = oL_we;
                    end

                    // Se realizan las rotaciones de S[i] y L[j].
                    // Se calculan los nuevos valores de i y j.
                    `OPERATE_DATA3: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                        i_nxt = i;
                        j_nxt = j;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp<= rSumTemp;
                        rRot_L_nxt = rRot_L;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = wS_rotate;
                        oL_sub_i_prima_nxt = {oL_sub_i_prima[W-4:0],oL_sub_i_prima[W-1:W-3]};
                        oS_we_nxt = oS_we;
                        oL_we_nxt = oL_we;
                    end

                    // Se manda a guardar los datos operados.
                    `WRITE_DATA: begin
                        rCount_nxt = rCount;
                        oS_address_nxt = oS_address;
                        oL_address_nxt = oL_address;
                        i_nxt = (i+1) % T;
                        j_nxt = (j+1) % C;
                        A_nxt = oS_sub_i_prima;
                        B_nxt = oL_sub_i_prima;
                        rSumTemp<= rSumTemp;
                        rRot_L_nxt = rRot_L;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oS_we_nxt = 1;
                        oL_we_nxt = 1;

                         if (rCount == MIXCOUNT) begin
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
                        i_nxt = i;
                        j_nxt = j;
                        A_nxt = A;
                        B_nxt = B;
                        rSumTemp_nxt = rSumTemp;
                        rRot_L_nxt = rRot_L;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oL_sub_i_prima_nxt = oL_sub_i_prima;
                        oL_we_nxt = oL_we;
                        oS_we_nxt = oS_we;
                    end

               endcase
          end

     always @(posedge clk or posedge rst)
          begin
               if (rst)
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
                        	state <= `OPERATE_DATA1;	
                        end
                        ///////////////////////
                        `OPERATE_DATA1: begin
                            state <= `OPERATE_DATA2;
                        end
                        ///////////////////////
                        `OPERATE_DATA2: begin
                            state <= `OPERATE_DATA3;
                        end
                        ///////////////////////
                        `OPERATE_DATA3: begin
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
            if (rst) begin
                rCount <= MIXCOUNT_BIT_VALUE;
                oS_address <= 0;
                oL_address <= 0;
                i <= 0;
                j <= 0;
                A <= 0;
                B <= 0;
                rSumTemp <= 0;
                rRot_L <= 0;
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
                i <= i_nxt;
                j <= j_nxt;
                A <= A_nxt;
                B <= B_nxt;
                rSumTemp <= rSumTemp_nxt;
                rRot_L <= rRot_L_nxt;
                oDone <= oDone_nxt;
                oS_sub_i_prima <= oS_sub_i_prima_nxt;
                oL_sub_i_prima <= oL_sub_i_prima_nxt;
                oL_we <= oL_we_nxt;
                oS_we <= oS_we_nxt;
            end
        end


endmodule