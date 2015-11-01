`timescale 1ns/10ps

`define IDLE 3'b000
`define WAIT_ADDR 3'b001
`define READ_DATA 3'b010
`define OPERATE_DATA 3'b011
`define WRITE_DATA 3'b100


module L_operation
#(
     parameter B = 16,
     parameter W = 32,
     parameter U = 4,
     parameter C = 4
)

(
     input clk,
     input rst,
     //
     output reg [B_length-1:0] key_address,
     input [7:0] key_sub_i,
     //
     input [W-1:0] L_sub_i,
     output reg [C_length-1:0] L_address,
     //
     output reg [W-1:0] L_sub_i_prima,
     output reg done,
     output reg L_we
);

     parameter B_length = $clog2(B);
     parameter C_length = $clog2(C);

     reg [2:0] state;
     reg [B_length-1:0] count;

     always @(state) 
          begin
               case (state)

                    `IDLE: begin
                         count <= B-1;
                         done <= 0;
                         L_we <= 0;
                    end
                         
                    `WAIT_ADDR: begin
                        key_address <= count;
                        L_address <= count/U;
                        done <= done;
                        L_sub_i_prima <= L_sub_i_prima;
                        L_we <= 0;
                    end
                         
                    `READ_DATA: begin
                         key_address <= key_address;
                         L_address <= L_address;
                         done <= done;
                         L_we <= L_we;
                         L_sub_i_prima <= L_sub_i_prima;
                    end
                         
                    `OPERATE_DATA: begin
                         key_address <= key_address;
                         L_address <= L_address;
                         done <= done;
                         L_we <= L_we;                         
                         L_sub_i_prima <= {L_sub_i[W-9:0],L_sub_i[W-1:W-8]} + key_sub_i;
                    end
                         
                    `WRITE_DATA: begin
                         count = count-1;
                         key_address <= key_address;
                         L_address <= L_address;
                         L_sub_i_prima <= L_sub_i_prima;
                         L_we <= 1;

                         if (count == B-1) begin
                              done <= 1;
                         end

                         else begin
                              done <= done;     
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
                            if (done) begin
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