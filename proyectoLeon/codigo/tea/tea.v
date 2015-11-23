`timescale 1ns/10ps

`define IDLE 3'b000
`define WAIT_ADDR 3'b001
`define READ_DATA 3'b010
`define OPERATE_DATA 3'b011
`define WRITE_DATA 3'b100


module cipher 
#(
	parameter WORD_SIZE = 32,
	parameter delta = 32b9e3779b9
)

(
	// Texto plano
	input wire [WORD_SIZE-1:0] v0,
	input wire [WORD_SIZE-1:0] v1,
	// Llave
	input wire [WORD_SIZE-1:0] k0,
	input wire [WORD_SIZE-1:0] k1,
	input wire [WORD_SIZE-1:0] k2,
	input wire [WORD_SIZE-1:0] k3,
	//Texto cifrado
	output reg [WORD_SIZE-1:0] c0,
	output reg [WORD_SIZE-1:0] c1
);

	    always @(*) 
          begin
               case (state)

                    `IDLE: begin
                        count_nxt = count;
                        done_nxt = done;
                        L_we_nxt = L_we;
                        key_address_nxt = key_address;
                        L_address_nxt = L_address;
                        L_sub_i_prima_nxt = L_sub_i_prima;
                    end
                         
                    `WAIT_ADDR: begin
                        count_nxt = count;
                        key_address_nxt = count;
                        L_address_nxt = count/U;
                        done_nxt = done;
                        L_sub_i_prima_nxt = L_sub_i_prima;
                        L_we_nxt = 0;
                    end
                         
                    `READ_DATA: begin
                         count_nxt = count;
                         key_address_nxt = key_address;
                         L_address_nxt = L_address;
                         done_nxt = done;
                         L_we_nxt = L_we;
                         L_sub_i_prima_nxt = L_sub_i_prima;
                    end
                         
                    `OPERATE_DATA: begin
                         count_nxt = count;
                         key_address_nxt = key_address;
                         L_address_nxt = L_address;
                         done_nxt = done;
                         L_we_nxt = L_we;                         
                         L_sub_i_prima_nxt = {L_sub_i[W-9:0],L_sub_i[W-1:W-8]} + key_sub_i;
                    end
                         
                    `WRITE_DATA: begin
                         count_nxt = count-1;
                         key_address_nxt = key_address;
                         L_address_nxt = L_address;
                         L_sub_i_prima_nxt = L_sub_i_prima;
                         L_we_nxt = 1;

                         if (count_nxt == B-1) begin
                              done_nxt = 1;
                         end

                         else begin
                              done_nxt = done;     
                         end
                    end
                    
                    default: begin
                        count_nxt = count;
                        done_nxt = done;
                        L_we_nxt = L_we;
                        key_address_nxt = key_address;
                        L_address_nxt = L_address;
                        L_sub_i_prima_nxt = L_sub_i_prima;
                    end
                    
               endcase
          end

     always @(posedge clk)
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

        always @(posedge clk) begin
            if(rst) begin
                count = B-1;
                done = 0;
                L_we = 0;
                key_address = 0;
                L_address = 0;
                L_sub_i_prima = 0;
            end

            else begin
                count = count_nxt;
                done = done_nxt;
                L_we = L_we_nxt;
                key_address = key_address_nxt;
                L_address = L_address_nxt;
                L_sub_i_prima = L_sub_i_prima_nxt;
            end

        end



endmodule