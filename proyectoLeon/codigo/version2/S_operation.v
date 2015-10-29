`timescale 1ns/10ps

`define IDLE 3'b000
`define WAIT_ADDR 3'b001
`define READ_DATA 3'b010
`define OPERATE_DATA 3'b011
`define WRITE_DATA 3'b100



module S_operation
#(
     parameter T = 16,
     parameter W = 32,
     parameter QW = 4
)

(

    input clk,
    input rst,
    //
    input wire [W-1:0] iS_sub_i,
    output reg [W-1:0] oS_sub_i_prima,
    output reg [T_LENGTH-1:0] oS_address,
    output reg oDone,
    output reg oS_we
);

    parameter T_LENGTH = $clog2(T);
    parameter T_BIT_SIZE = 2**T_LENGTH-1;

     reg [2:0] state;
     reg [T_LENGTH-1:0] rCount;

     always @(state) 
          begin
               case (state)

                    `IDLE: begin
                         rCount <= 1;
                         oDone <= 0;
                         oS_we <= 0;
                    end

                    `WAIT_ADDR: begin
                        oS_address <= rCount-1;
                        oDone <= oDone;
                        oS_sub_i_prima <= oS_sub_i_prima;
                        oS_we <= 0;
                    end
                         
                    `READ_DATA: begin
                         oS_address <= oS_address;
                         oDone <= oDone;
                         oS_we <= oS_we;
                         oS_sub_i_prima <= oS_sub_i_prima;
                    end
                         
                    `OPERATE_DATA: begin
                         oS_address <= rCount;
                         oDone <= oDone;
                         oS_we <= oS_we;                        
                         oS_sub_i_prima <= iS_sub_i + QW;
                    end
                         
                    `WRITE_DATA: begin
                         rCount = rCount+1;
                         oS_address <= oS_address;
                         oS_sub_i_prima <= oS_sub_i_prima;
                         oS_we <= 1;

                         if (rCount == T) begin
                              oDone <= 1;
                         end

                         else begin
                              oDone <= oDone;     
                         end
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
                        	if (!rst) begin
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
                        	state <= `OPERATE_DATA;	
                        end
                        ///////////////////////
                        `OPERATE_DATA: begin
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

endmodule