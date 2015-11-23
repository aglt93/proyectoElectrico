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
     parameter QW = 32'hB7E15163
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

    reg [T_LENGTH-1:0] rCount_nxt;
    reg [W-1:0] oS_sub_i_prima_nxt;
    reg [T_LENGTH-1:0] oS_address_nxt;
    reg oDone_nxt;
    reg oS_we_nxt;

    always @(*) 
        begin
               case (state)

                    `IDLE: begin
                        oS_address_nxt = rCount;
                        oDone_nxt = oDone;
                        oS_we_nxt = oS_we;                        
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        rCount_nxt = rCount;
                    end

                    `WAIT_ADDR: begin
                        oS_address_nxt = rCount-1;
                        oDone_nxt = oDone;
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        oS_we_nxt = 0;
                        rCount_nxt = rCount;
                    end
                         
                    `READ_DATA: begin
                    	 oS_address_nxt = oS_address;
                         oDone_nxt = oDone;
                         oS_we_nxt = oS_we;
                         oS_sub_i_prima_nxt = oS_sub_i_prima;
                         rCount_nxt = rCount;
                    end
                         
                    `OPERATE_DATA: begin
                        oS_address_nxt = rCount;
                         oDone_nxt = oDone;
                         oS_we_nxt = oS_we;                        
                         oS_sub_i_prima_nxt = iS_sub_i + QW;
                         rCount_nxt = rCount;
                    end
                         
                    `WRITE_DATA: begin
                         rCount_nxt = rCount+1;
                         oS_address_nxt = oS_address;
                         oS_sub_i_prima_nxt = oS_sub_i_prima;
                         oS_we_nxt = 1;
  
                         if (rCount == T) begin
                              oDone_nxt = 1;
                         end

                         else begin
                              oDone_nxt = oDone;     
                         end
                    end

                    default: begin
                    	oS_address_nxt = rCount;
                        oDone_nxt = oDone;
                        oS_we_nxt = oS_we;                        
                        oS_sub_i_prima_nxt = oS_sub_i_prima;
                        rCount_nxt = rCount;
                    end

               endcase
          end

        always @(posedge clk) begin
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

	    always @(posedge clk) begin
	    	if (rst) begin
	    		oS_address <= 0;
                oDone <= 0;
                oS_we <= 0;                        
                oS_sub_i_prima <= 0;
                rCount <= 1;
	    	end
	    	else begin
	    		oS_address <= oS_address_nxt;
                oDone <= oDone_nxt;
                oS_we <= oS_we_nxt;                        
                oS_sub_i_prima <= oS_sub_i_prima_nxt;
                rCount <= rCount_nxt;
	    	end
	    end

endmodule