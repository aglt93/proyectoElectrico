`ifndef COLLATERALS_V
`define COLLATERALS_V

`timescale 1ns / 1ps
`include "aDefinitions.v"
/**********************************************************************************
Theia, Ray Cast Programable graphic Processing Unit.
Copyright (C) 2010  Diego Valverde (diego.valverde.g@gmail.com)

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

***********************************************************************************/

//----------------------------------------------------
module FFD_POSEDGE_SYNCRONOUS_RESET # ( parameter SIZE=`WIDTH )
(
	input wire				Clock,
	input wire				Reset,
	input wire				Enable,
	input wire [SIZE-1:0]	D,
	output reg [SIZE-1:0]	Q
);
	

always @ (posedge Clock) 
begin
	if ( Reset )
		Q <= {SIZE{1'b0}};
	else
	begin	
		if (Enable) 
			Q <= D; 
	end	
 
end//always

endmodule
//------------------------------------------------
module PULSE
(
input wire				Clock,
input wire				Reset,
input wire				Enable,
input wire        	D,
output wire          Q
);

wire wDelay;
FFD_POSEDGE_SYNCRONOUS_RESET # (1) FFD (Clock,Reset,Enable,D,wDelay);

assign Q = (Enable) ?  (D ^ wDelay) & D: 1'b0;

endmodule
//------------------------------------------------
module ADDER # (parameter SIZE=`WIDTH)
(
input wire Clock,
input wire Reset,
input wire iTrigger,
input wire [SIZE-1:0] iA,iB,
output wire [SIZE-1:0] oR,
output wire            oDone
);
wire [SIZE-1:0] wR,wR_Delay;
assign wR = iA + iB;

FFD_POSEDGE_SYNCRONOUS_RESET # (1) FFD0 (Clock,Reset,1'b1,iTrigger,oDone);

FFD_POSEDGE_SYNCRONOUS_RESET # (SIZE) FFD (Clock,Reset,iTrigger,wR,wR_Delay);
assign oR = wR_Delay;

endmodule
//------------------------------------------------
module OR # (parameter SIZE=`WIDTH)
(
input wire Clock,
input wire Reset,
input wire iTrigger,
input wire [SIZE-1:0] iA,iB,
output wire [SIZE-1:0] oR,
output wire            oDone
);
wire [SIZE-1:0] wR,wR_Delay;
assign wR = iA | iB;

FFD_POSEDGE_SYNCRONOUS_RESET # (1) FFD0 (Clock,Reset,1'b1,iTrigger,oDone);


FFD_POSEDGE_SYNCRONOUS_RESET #  (SIZE) FFD (Clock,Reset,iTrigger,wR,wR_Delay);
assign oR = wR_Delay;

endmodule
//------------------------------------------------
module AND # (parameter SIZE=`WIDTH)
(
input wire Clock,
input wire Reset,
input wire iTrigger,
input wire [SIZE-1:0] iA,iB,
output wire [SIZE-1:0] oR,
output wire            oDone
);
wire [SIZE-1:0] wR,wR_Delay;
assign wR = iA & iB;

FFD_POSEDGE_SYNCRONOUS_RESET # (1) FFD0 (Clock,Reset,1'b1,iTrigger,oDone);


FFD_POSEDGE_SYNCRONOUS_RESET #  (SIZE) FFD (Clock,Reset,iTrigger,wR,wR_Delay);
assign oR = wR_Delay;

endmodule
//------------------------------------------------
module UPCOUNTER_POSEDGE # (parameter SIZE=`WIDTH)
(
input wire Clock, Reset,
input wire [SIZE-1:0] Initial,
input wire Enable,
output reg [SIZE-1:0] Q
);


  always @(posedge Clock )
  begin
      if (Reset)
        Q <= Initial;
      else
		begin
		if (Enable)
			Q <= Q + 1;
			
		end			
  end

endmodule

//----------------------------------------------------------------------

module DECODER_ONEHOT_2_BINARY # (parameter OUTPUT_WIDTH = 6)
(
input wire [6:0] iIn,
output reg[OUTPUT_WIDTH-1:0] oOut
);

always @ (*)
begin
	case (iIn)
		7'b0000000: oOut = 0;
		7'b0000001: oOut = 1;
		7'b0000010: oOut = 2; 
		7'b0000100: oOut = 3;
		7'b0001000: oOut = 4;
		7'b0010000: oOut = 5;
		7'b0100000: oOut = 6;
		7'b1000000: oOut = 7;
	default:
		oOut = 0;
	endcase
end
endmodule

//----------------------------------------------------------------------

module SELECT_1_TO_N # ( parameter SEL_WIDTH=4, parameter OUTPUT_WIDTH=16 )
 (
 input wire [SEL_WIDTH-1:0] Sel,
 input wire  En,
 output wire [OUTPUT_WIDTH-1:0] O
 );

reg[OUTPUT_WIDTH-1:0] shift;

always @ ( * )
begin
	if (~En)
		shift = 1;
	else
		shift = (1 << 	Sel);


end

assign O = ( ~En ) ? 0 : shift ;

//assign O = En & (1 << Sel);

endmodule 

//----------------------------------------------------------------------
module MUXFULLPARALELL_GENERIC #(parameter  WIDTH = `WIDTH, parameter  CHANNELS = 4, parameter SELBITS = 2) 
(

    input wire   [(CHANNELS*WIDTH)-1:0]      in_bus,
    input wire   [SELBITS-1:0]    sel,   

    output wire [WIDTH-1:0]                 out
    );

genvar ig;
    
wire    [WIDTH-1:0] input_array [0:CHANNELS-1];

assign  out = input_array[sel];

generate
    for(ig=0; ig<CHANNELS; ig=ig+1) 
	 begin: array_assignments
        assign  input_array[ig] = in_bus[(ig*WIDTH)+:WIDTH];
    end
endgenerate



endmodule
//----------------------------------------------------------------------
module MUXFULLPARALELL_2SEL_GENERIC # ( parameter SIZE=`WIDTH )
 (
 input wire [1:0] Sel,
 input wire [SIZE-1:0]I1, I2, I3,I4,
 output reg [SIZE-1:0] O1
 );

always @( * )

  begin

    case (Sel)

      2'b00: O1 = I1;
      2'b01: O1 = I2;
		2'b10: O1 = I3;
		2'b11: O1 = I4;
		default: O1 = SIZE;

    endcase

  end

endmodule 
//------------------------------------------------------------------------
module MUXFULLPARALELL_3SEL_GENERIC # ( parameter SIZE=`WIDTH )
 (
 input wire [2:0] Sel,
 input wire [SIZE-1:0]I1, I2, I3,I4,I5,I6,I7,I8,
 output reg [SIZE-1:0] O1
 );

always @( * )

  begin

    case (Sel)

      3'b000: O1 = I1;
      3'b001: O1 = I2;
		3'b010: O1 = I3;
		3'b011: O1 = I4;
		3'b100: O1 = I5;
		3'b101: O1 = I6;
		3'b110: O1 = I7;
		3'b111: O1 = I8;
		default: O1 = SIZE;

    endcase

  end

endmodule 
//------------------------------------------------------------------------
module CIRCULAR_SHIFTLEFT_POSEDGE_EX # ( parameter SIZE=`WIDTH )
( input wire Clock, 
  input wire Reset,
  input wire[SIZE-1:0] Initial, 
  input wire      Enable,
  output wire[SIZE-1:0] O
);

reg [SIZE-1:0] tmp;


  always @(posedge Clock)
  begin
  if (Reset)
		tmp <= Initial;
	else
	begin
		if (Enable)
		begin
			if (tmp[SIZE-1])
			begin
				tmp <= Initial;
			end	
			else
			begin
				tmp <= tmp << 1;
			end	
		end	
	end	
  end
  
  
    assign O  = tmp;
endmodule
//------------------------------------------------
module MUXFULLPARALELL_3SEL_WALKINGONE # ( parameter SIZE=`WIDTH )
 (
 input wire [2:0] Sel,
 input wire [SIZE-1:0]I1, I2, I3,
 output reg [SIZE-1:0] O1
 );

always @( * )

  begin

    case (Sel)

      3'b001: O1 = I1;
      3'b010: O1 = I2;
      3'b100: O1 = I3;
      default: O1 = SIZE;

    endcase

  end

endmodule 
//------------------------------------------------
module MUXFULLPARALELL_3SEL_EN # ( parameter SIZE=`WIDTH )
 (
 input wire [1:0] SEL,
 input wire [SIZE-1:0]I1, I2, I3,
 input wire EN,
 output reg [SIZE-1:0] O1
 );

always @( * )

  begin
	if (EN)
	begin
    case (SEL)

      2'b00: O1 = I1;
      2'b01: O1 = I2;
      2'b10: O1 = I3;
      default: O1 = SIZE;

    endcase
	end
	else
	begin
		O1 = I1;
	end
  end

endmodule
//------------------------------------------------
module MUXFULLPARALELL_4SEL_WALKINGONE # ( parameter SIZE=`WIDTH )
 (
 input wire [2:0] Sel,
 input wire [SIZE-1:0]I1, I2, I3, I4,
 output reg [SIZE-1:0] O1
 );

always @( * )

  begin

    case (Sel)

      4'b0001: O1 = I1;
      4'b0010: O1 = I2;
      4'b0100: O1 = I3;
		4'b1000: O1 = I4;
      default: O1 = SIZE;

    endcase

  end

endmodule 

//------------------------------------------------
module SHIFTLEFT_POSEDGE # ( parameter SIZE=`WIDTH )
( input wire Clock, 
  input wire Reset,
  input wire[SIZE-1:0] Initial, 
  input wire      Enable,
  output wire[SIZE-1:0] O
);

reg [SIZE-1:0] tmp;


  always @(posedge Clock)
  begin
  if (Reset)
		tmp <= Initial;
	else
	begin
		if (Enable)
			tmp <= tmp << 1;
	end	
  end
  
  
    assign O  = tmp;
endmodule

//------------------------------------------------
module NOT_POSEDGE # ( parameter SIZE=`WIDTH )
( input wire Clock,
input wire Reset,
input wire iTrigger,
input wire [SIZE-1:0] iA,
output wire [SIZE-1:0] oR,
output wire            oDone
);
wire [SIZE-1:0] wR,wR_Delay;
assign wR = ~iA ;

FFD_POSEDGE_SYNCRONOUS_RESET # (1) FFD0 (Clock,Reset,1'b1,iTrigger,oDone);


FFD_POSEDGE_SYNCRONOUS_RESET #  (SIZE) FFD (Clock,Reset,iTrigger,wR,wR_Delay);
assign oR = wR_Delay;

endmodule
//------------------------------------------------
module SHIFTLEFT_POSEDGE_2 # ( parameter SIZE=`WIDTH )
( input wire Clock,
input wire Reset,
input wire iTrigger,
input wire [SIZE-1:0] iA,iB,
output wire [SIZE-1:0] oR,
output wire            oDone
);
wire [SIZE-1:0] wR,wR_Delay;
assign wR = iA << iB;

FFD_POSEDGE_SYNCRONOUS_RESET # (1) FFD0 (Clock,Reset,1'b1,iTrigger,oDone);


FFD_POSEDGE_SYNCRONOUS_RESET #  (SIZE) FFD (Clock,Reset,iTrigger,wR,wR_Delay);
assign oR = wR_Delay;

endmodule
//------------------------------------------------
module SHIFTRIGHT_POSEDGE_2 # ( parameter SIZE=`WIDTH )
( 
input wire Clock,
input wire Reset,
input wire iTrigger,
input wire [SIZE-1:0] iA,iB,
output wire [SIZE-1:0] oR,
output wire            oDone
);
wire [SIZE-1:0] wR,wA,wB,wR_Delay;
wire wSign,wSign_Delay;
assign wSign = iA[SIZE-1] ^ iB[SIZE-1];

assign wA = (iA[SIZE-1])?~iA+1'b1: iA;
assign wB = (iB[SIZE-1])?~iB+1'b1: iB;
assign wR = wA >> wB;

FFD_POSEDGE_SYNCRONOUS_RESET # (1) FFD0 (Clock,Reset,1'b1,iTrigger,oDone);
FFD_POSEDGE_SYNCRONOUS_RESET # (1) FFDSIGN (Clock,Reset,1'b1,wSign,wSign_Delay);

FFD_POSEDGE_SYNCRONOUS_RESET #  (SIZE) FFD (Clock,Reset,iTrigger,wR,wR_Delay);
assign oR = (wSign_Delay) ? (~wR_Delay + 1'b1): wR_Delay;

endmodule
//------------------------------------------------
module CIRCULAR_SHIFTLEFT_POSEDGE # ( parameter SIZE=`WIDTH )
( input wire Clock, 
  input wire Reset,
  input wire[SIZE-1:0] Initial, 
  input wire      Enable,
  output wire[SIZE-1:0] O
);

reg [SIZE-1:0] tmp;


  always @(posedge Clock)
  begin
  if (Reset || tmp[SIZE-1])
		tmp <= Initial;
	else
	begin
		if (Enable)
			tmp <= tmp << 1;
	end	
  end
  
  
    assign O  = tmp;
endmodule
//-----------------------------------------------------------
/*
	Sorry forgot how this flop is called.
	Any way Truth table is this
	
	Q	S	Q_next R
	0	0	0		 0
	0	1	1		 0
	1	0	1		 0
	1	1	1		 0
	X	X	0		 1
	
	The idea is that it toggles from 0 to 1 when S = 1, but if it 
	gets another S = 1, it keeps the output to 1.
*/
module FFToggleOnce_1Bit
(
	input wire Clock,
	input wire Reset,
	input wire Enable,
	input wire S,
	output reg Q
	
);


reg Q_next;

always @ (negedge Clock)
begin
	Q <= Q_next;
end

always @ ( posedge Clock )
begin
	if (Reset)
		Q_next <= 0;
	else if (Enable)
		Q_next <= (S && !Q) || Q;
	else
		Q_next <= Q;
end
endmodule

//-----------------------------------------------------------


module FFD32_POSEDGE
(
	input wire Clock,
	input wire[31:0] D,
	output reg[31:0] Q
);
	
	always @ (posedge Clock)
		Q <= D;
	
endmodule

//------------------------------------------------
module MUXFULLPARALELL_96bits_2SEL
 (
 input wire Sel,
 input wire [95:0]I1, I2,
 output reg [95:0] O1
 );



always @( * )

  begin

    case (Sel)

      1'b0: O1 = I1;
      1'b1: O1 = I2;

    endcase

  end

endmodule 

//------------------------------------------------
module MUXFULLPARALELL_16bits_2SEL
 (
 input wire Sel,
 input wire [15:0]I1, I2,
 output reg [15:0] O1
 );



always @( * )

  begin

    case (Sel)

      1'b0: O1 = I1;
      1'b1: O1 = I2;

    endcase

  end

endmodule 

//--------------------------------------------------------------

  module FFT1 
  (
   input wire D,
   input wire Clock, 
   input wire Reset , 
   output reg Q       
 );
 
  always @ ( posedge Clock or posedge Reset )
  begin
  
	if (Reset)
	begin
    Q <= 1'b0;
   end 
	else 
	begin
		if (D) 
			Q <=  ! Q;
	end
	
  end//always
  
 endmodule
//--------------------------------------------------------------



 module sync_fifo #(  parameter DATA_WIDTH = 8, parameter DEPTH = 8, parameter ADDR_WIDTH=3 )
(

 input wire [DATA_WIDTH-1:0]  din,
 input wire wr_en,
 input wire rd_en,
 output wire[DATA_WIDTH-1:0] dout,
 output reg full,
 output reg empty,
 output wire oOneElement,
 input wire clk,
 input wire reset

);

 
//parameter ADDR_WIDTH = $clog2(DEPTH);	

reg   [ADDR_WIDTH : 0]     rd_ptr; // note MSB is not really address
reg   [ADDR_WIDTH : 0]     wr_ptr; // note MSB is not really address
wire  [ADDR_WIDTH-1 : 0]  wr_loc;
wire  [ADDR_WIDTH-1 : 0]  rd_loc;
reg   [DATA_WIDTH-1 : 0]  mem[DEPTH-1 : 0];

assign oOneElement = ((wr_loc - rd_loc) == 1'b1)? 1'b1 : 1'b0;
assign wr_loc = wr_ptr[ADDR_WIDTH-1 : 0];
assign rd_loc = rd_ptr[ADDR_WIDTH-1 : 0];

always @(posedge clk) begin
 if(reset) begin
 wr_ptr <= 'h0;
 rd_ptr <= 'h0;
end // end if

else begin
 if(wr_en & (~full))begin
 wr_ptr <= wr_ptr+1;
 end
 if(rd_en & (~empty))
 rd_ptr <= rd_ptr+1;
 end //end else

end//end always

 

//empty if all the bits of rd_ptr and wr_ptr are the same.

//full if all bits except the MSB are equal and MSB differes

always @(rd_ptr or wr_ptr)begin

 //default catch-alls

 empty <= 1'b0;

 full  <= 1'b0;

 if(rd_ptr[ADDR_WIDTH-1:0]==wr_ptr[ADDR_WIDTH-1:0])begin

 if(rd_ptr[ADDR_WIDTH]==wr_ptr[ADDR_WIDTH])

 empty <= 1'b1;

 else

 full  <= 1'b1;

 end//end if

end//end always

 

always @(posedge clk) begin

 if (wr_en)

 mem[wr_loc] <= din;

end //end always

assign dout = mem[rd_loc];//rd_en ? mem[rd_loc]:'h0;

endmodule

//---------------------------------------------------------------------

/*
Synchronous memory blocks have two independent address ports, allowing
for operations on two unique addresses simultaneously. A read operation and a write
operation can share the same port if they share the same address.
In the synchronous RAM block architecture, there is no priority between the two
ports. Therefore, if you write to the same location on both ports at the same time, the
result is indeterminate in the device architecture.
When a read and write operation occurs on the same port for
the same address, the new data being written to the memory is read. When a read and
write operation occurs on different ports for the same address, the old data in the
memory is read. Simultaneous writes to the same location on both ports results in
indeterminate behavior.

*/
module RAM_DUAL_READ_DUAL_WRITE_PORT  # ( parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 6 )
(
input wire [(DATA_WIDTH-1):0] data_a, data_b,
input wire [(ADDR_WIDTH-1):0] addr_a, addr_b,
input wire we_a, we_b, clk,
output reg [(DATA_WIDTH-1):0] q_a, q_b
);


// Declare the RAM variable
reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	always @ (posedge clk)
	begin // Port A
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
			q_a <= ram[addr_a];
	end
		
	always @ (posedge clk)
	begin // Port b
		if (we_b) 
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else 
			q_b <= ram[addr_b];
	end
endmodule


module RAM_QUAD_PORT  # ( parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 6 )
(
input wire [(DATA_WIDTH-1):0] data_a, data_b,
input wire [(ADDR_WIDTH-1):0] waddr_a, waddr_b,
input wire [(ADDR_WIDTH-1):0] raddr_a, raddr_b,
input wire we_a, we_b, clk,
output reg [(DATA_WIDTH-1):0] q_a, q_b
);


// Declare the RAM variable
reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	always @ (posedge clk)
	begin // Port A
		if (we_a)
		begin	
			ram[waddr_a] <= data_a;
			q_a <= data_a;
		end
		else
			q_a <= ram[waddr_a];
	end
		
	always @ (posedge clk)
	begin // Port B
		if (we_b) 
		begin
			ram[waddr_b] <= data_b;
			q_b <= data_b;
		end
		else
			q_b <= ram[waddr_b];
	end
	
	
endmodule
//-------------------------------------------------------------------------------
//----------------------------------------------------
   // A four level, round-robin arbiter. This was
   // orginally coded by WD Peterson in VHDL.
   //----------------------------------------------------
    module ROUND_ROBIN_ARBITER (
      clk,    
      rst,    
		req4,   
      req3,   
      req2,   
     req1,   
     req0,
	  gnt4,	  
     gnt3,   
     gnt2,   
     gnt1,   
     gnt0   
   );
   // --------------Port Declaration----------------------- 
   input           clk;    
   input           rst;    
	input           req4;   
   input           req3;   
   input           req2;   
   input           req1;   
   input           req0;   
	output          gnt4;   
   output          gnt3;   
   output          gnt2;   
   output          gnt1;   
   output          gnt0;   
   
   //--------------Internal Registers----------------------
   wire    [2:0]   gnt       ;   
   wire            comreq    ; 
   wire            beg       ;
   wire   [2:0]    lgnt      ;
   wire            lcomreq   ;
   reg             lgnt0     ;
   reg             lgnt1     ;
   reg             lgnt2     ;
   reg             lgnt3     ;
	reg             lgnt4     ;
   reg             lasmask   ;
   reg             lmask0    ;
   reg             lmask1    ;
	reg             lmask2    ;
   reg             ledge     ;
   
   //--------------Code Starts Here----------------------- 
   always @ (posedge clk)
   if (rst) begin
     lgnt0 <= 0;
     lgnt1 <= 0;
     lgnt2 <= 0;
     lgnt3 <= 0;
	  lgnt4 <= 0;
   end else begin                                     
     lgnt0 <=(~lcomreq & ~lmask2 & ~lmask1 & ~lmask0 & ~req4 & ~req3 & ~req2 & ~req1 & req0)
           | (~lcomreq & ~lmask2 & ~lmask1 &  lmask0 & ~req4 & ~req3 & ~req2 &  req0)
           | (~lcomreq & ~lmask2 &  lmask1 & ~lmask0 & ~req4 & ~req3 &  req0)
           | (~lcomreq & ~lmask2 &  lmask1 &  lmask0 & ~req4 & req0  )
			  | (~lcomreq &  lmask2 & ~lmask1 & ~lmask0 &  req0  )
           | ( lcomreq & lgnt0 );
     lgnt1 <=(~lcomreq & ~lmask2 & ~lmask1 & ~lmask0 &  req1)
           | (~lcomreq & ~lmask2 & ~lmask1 &  lmask0 & ~req4 & ~req3 & ~req2 &  req1 & ~req0)
           | (~lcomreq & ~lmask2 &  lmask1 & ~lmask0 & ~req4 & ~req3 &  req1 & ~req0)
           | (~lcomreq & ~lmask2 &  lmask1 &  lmask0 & ~req4 &  req1 & ~req0)
			  | (~lcomreq &  lmask2 & ~lmask1 & ~lmask0 &  req1 & ~req0)
           | ( lcomreq &  lgnt1);
     lgnt2 <=(~lcomreq & ~lmask2 & ~lmask1 & ~lmask0 &  req2  & ~req1)
           | (~lcomreq & ~lmask2 & ~lmask1 &  lmask0 &  req2)
           | (~lcomreq & ~lmask2 &  lmask1 & ~lmask0 & ~req4 & ~req3 &  req2  & ~req1 & ~req0)
           | (~lcomreq & ~lmask2 &  lmask1 &  lmask0 & ~req4 & req2 & ~req1 & ~req0)
			  | ( lcomreq &  lmask2 & ~lmask1 & ~lmask0 &  req2 & ~req1 & ~req0)
           | ( lcomreq &  lgnt2);
     lgnt3 <=(~lcomreq & ~lmask2 & ~lmask1 & ~lmask0 & ~req4 & req3  & ~req2 & ~req1)
           | (~lcomreq & ~lmask2 & ~lmask1 &  lmask0 & ~req4 & req3  & ~req2)
           | (~lcomreq & ~lmask2 &  lmask1 & ~lmask0 & ~req4 & req3)
			  | (~lcomreq & ~lmask2 & ~lmask2 &  lmask1 &  lmask0 &  req3)
           | ( lcomreq &  lmask2 & ~lmask1 & ~lmask0 & ~req4 & req3  & ~req2 & ~req1 & ~req0)
           | ( lcomreq & lgnt3);
	  lgnt4 <=(~lcomreq & ~lmask2 & ~lmask1 & ~lmask0 &  req4 & ~req3  & ~req2 & ~req1 & ~req0)
           | (~lcomreq & ~lmask2 & ~lmask1 &  lmask0 &  req4 & ~req3  & ~req2 & ~req1 )
           | (~lcomreq & ~lmask2 &  lmask1 & ~lmask0 &  req4 & ~req3  & ~req2 )
			  | (~lcomreq & ~lmask2 &  lmask1 &  lmask0 &  req4 & ~req3 )
           | ( lcomreq &  lmask2 & ~lmask1 & ~lmask0 &  req4 )
           | ( lcomreq & lgnt3);	  
   end 
   
   //----------------------------------------------------
   // lasmask state machine.
   //----------------------------------------------------
   assign beg = (req4 | req3 | req2 | req1 | req0) & ~lcomreq;
   always @ (posedge clk)
   begin                                     
     lasmask <= (beg & ~ledge & ~lasmask);
     ledge   <= (beg & ~ledge &  lasmask) 
             |  (beg &  ledge & ~lasmask);
   end 
   
   //----------------------------------------------------
   // comreq logic.
   //----------------------------------------------------
   assign lcomreq = 
							( req4 & lgnt4 )
						 | ( req3 & lgnt3 )
                   | ( req2 & lgnt2 )
                   | ( req1 & lgnt1 )
                   | ( req0 & lgnt0 );
   
   //----------------------------------------------------
   // Encoder logic.
   //----------------------------------------------------
   assign  lgnt =  {lgnt4,(lgnt3 | lgnt2),(lgnt3 | lgnt1)};
   
   //----------------------------------------------------
   // lmask register.
  //----------------------------------------------------
  always @ (posedge clk )
  if( rst ) begin
	 lmask2 <= 0;
    lmask1 <= 0;
    lmask0 <= 0;
  end else if(lasmask) begin
    lmask2 <= lgnt[2];
    lmask1 <= lgnt[1];
    lmask0 <= lgnt[0];
  end else begin
	 lmask2 <= lmask2;
    lmask1 <= lmask1;
    lmask0 <= lmask0;
  end 
  
  assign comreq = lcomreq;
  assign gnt    = lgnt;
  //----------------------------------------------------
  // Drive the outputs
  //----------------------------------------------------
  assign gnt4   = lgnt4;
  assign gnt3   = lgnt3;
  assign gnt2   = lgnt2;
  assign gnt1   = lgnt1;
  assign gnt0   = lgnt0;
  
  endmodule
//-------------------------------------------------------------------------------
module ROUND_ROBIN_5_ENTRIES
(
input wire Clock,
input wire Reset,
input wire iRequest0,
input wire iRequest1,
input wire iRequest2,
input wire iRequest3,
input wire iRequest4,
output wire oGrant0,
output wire oGrant1,
output wire oGrant2,
output wire oGrant3,
output wire oGrant4,
output wire oPriorityGrant

);
wire wMaks2,wMaks1,wMaks0;
wire wGrant0,wGrant1,wGrant2,wGrant3,wGrant4;

assign wGrant0 = 
                   (wMaks2 &  ~wMaks1 &  ~wMaks0 &  iRequest0 &  ~iRequest4 )
						|(~wMaks2 &  wMaks1 &  wMaks0 &  iRequest0 &  ~iRequest4 & ~iRequest3 )
						|(~wMaks2 &  wMaks1 & ~wMaks0 &  iRequest0 &  ~iRequest4 & ~iRequest3 & ~iRequest2 )
						|(~wMaks2 & ~wMaks1 &  wMaks0 &  iRequest0 &  ~iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 )
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest0 );
						
						
assign wGrant1 =  
                   (wMaks2 &  ~wMaks1 & ~wMaks0 &   iRequest1 & ~iRequest0 &  ~iRequest4)
						|(~wMaks2 &  wMaks1 &  wMaks0 &   iRequest1 & ~iRequest0 &  ~iRequest4 & ~iRequest3 )
						|(~wMaks2 &  wMaks1 & ~wMaks0 &   iRequest1 & ~iRequest0 &  ~iRequest4 & ~iRequest3 & ~iRequest2 )
						|(~wMaks2 & ~wMaks1 &  wMaks0 &   iRequest1 )
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &   iRequest1 & ~iRequest0) ;						

assign wGrant2 = 
                   (wMaks2 &  ~wMaks1 &  ~wMaks0 &  iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest4 )
						|(~wMaks2 &  wMaks1 &  wMaks0 &  iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest4 & ~iRequest3 )
						|(~wMaks2 &  wMaks1 & ~wMaks0 &  iRequest2 )
						|(~wMaks2 & ~wMaks1 &  wMaks0 &  iRequest2 & ~iRequest1 )
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest2 & ~iRequest1 & ~iRequest0 );
						
assign wGrant3 = 
                   (wMaks2 &  ~wMaks1 &  ~wMaks0 &  iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest4 )
						|(~wMaks2 &  wMaks1 &  wMaks0 &  iRequest3 )
						|(~wMaks2 &  wMaks1 & ~wMaks0 &  iRequest3 & ~iRequest2 )
						|(~wMaks2 & ~wMaks1 &  wMaks0 &  iRequest3 & ~iRequest2 & ~iRequest1 )
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 );

assign wGrant4 = 
                   ( wMaks2 &  ~wMaks1 &  ~wMaks0 &  iRequest4 )
						|(~wMaks2 &  wMaks1 &  wMaks0 &  iRequest4 & ~iRequest3 )
						|(~wMaks2 &  wMaks1 & ~wMaks0 &  iRequest4 & ~iRequest3 & ~iRequest2 )
						|(~wMaks2 & ~wMaks1 &  wMaks0 &  iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 )
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 );						


assign oPriorityGrant = wGrant0;
wire wGrant1_Pre, wGrant2_Pre, wGrant3_Pre, wGrant4_Pre;

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD0
( 	Clock, Reset, 1'b1 , wGrant0, oGrant0);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD1
( 	Clock, Reset, 1'b1 , wGrant1,  wGrant1_Pre );  //If priority grant comes this cycle then we are having troubles...

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD2
( 	Clock, Reset, 1'b1 , wGrant2, wGrant2_Pre );

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD3
( 	Clock, Reset, 1'b1 , wGrant3, wGrant3_Pre );

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD4
( 	Clock, Reset, 1'b1 , wGrant4, wGrant4_Pre );


assign oGrant1 = wGrant1_Pre & ~oPriorityGrant;
assign oGrant2 = wGrant2_Pre & ~oPriorityGrant;
assign oGrant3 = wGrant3_Pre & ~oPriorityGrant;
assign oGrant4 = wGrant4_Pre & ~oPriorityGrant;

reg [4:0]  rCurrentState, rNextState;
//Next states logic and Reset sequence
always @(posedge Clock ) 
  begin 
			
    if (Reset )  
		rCurrentState <= 0; 
    else        
		rCurrentState <= rNextState; 
		
end
reg[2:0] rMask;

assign wMaks0 = rMask[0];
assign wMaks1 = rMask[1];
assign wMaks2 = rMask[2];

always @ ( * )
begin
	case (rCurrentState)
	//--------------------------------------
	0:  //Mask for grant 0
	begin
		rMask = 3'd0;
		rNextState = 1;
	end
	1: //Mask for grant 1
	begin
		rMask = 3'd1;
		rNextState = 2;
	end
	2:
	begin
		rMask = 3'd2;
		rNextState = 3;
	end
	3:
	begin
		rMask = 3'd3;
		rNextState = 4;
	end
	4:
	begin
		rMask = 3'd4;
		rNextState = 0;
	end
	endcase
end
	/*
UPCOUNTER_POSEDGE # (3) UP1
(
.Clock( Clock ),
.Reset( Reset ),
.Initial( 3'b0 ),
.Enable( 1'b1 ),
.Q({wMaks2,wMaks1,wMaks0})
);
*/
			
						
endmodule
//-------------------------------------------------------------------------------
module ROUND_ROBIN_6_ENTRIES
(
input wire Clock,
input wire Reset,
input wire iRequest0,
input wire iRequest1,
input wire iRequest2,
input wire iRequest3,
input wire iRequest4,
input wire iRequest5,
output wire oGrant0,
output wire oGrant1,
output wire oGrant2,
output wire oGrant3,
output wire oGrant4,
output wire oGrant5,
output wire oPriorityGrant

);
wire wMaks2,wMaks1,wMaks0;
wire wGrant0,wGrant1,wGrant2,wGrant3,wGrant4,wGrant5;

assign wGrant0 = 
                   (wMaks2 &  ~wMaks1 &  wMaks0 & iRequest0 &  ~iRequest5 )
						|( wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest0 &  ~iRequest5 & ~iRequest4 )
						|(~wMaks2 &  wMaks1 &  wMaks0 &  iRequest0 &  ~iRequest5 & ~iRequest4 & ~iRequest3 )
						|(~wMaks2 &  wMaks1 & ~wMaks0 &  iRequest0 &  ~iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2 )
						|(~wMaks2 & ~wMaks1 &  wMaks0 &  iRequest0 &  ~iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1)
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest0 );
						
						
assign wGrant1 = 
                   (wMaks2 &  ~wMaks1 &  wMaks0 &   iRequest1 & ~iRequest0 &  ~iRequest5)
						|( wMaks2 & ~wMaks1 & ~wMaks0 &   iRequest1 & ~iRequest0 &  ~iRequest5 & ~iRequest4 )
						|(~wMaks2 &  wMaks1 &  wMaks0 &   iRequest1 & ~iRequest0 &  ~iRequest5 & ~iRequest4 & ~iRequest3 )
						|(~wMaks2 &  wMaks1 & ~wMaks0 &   iRequest1 & ~iRequest0 &  ~iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2)
						|(~wMaks2 & ~wMaks1 &  wMaks0 &   iRequest1 )
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &   iRequest1 & ~iRequest0);						

assign wGrant2 = 
                   (wMaks2 &  ~wMaks1 &   wMaks0 & iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest5 )
						|( wMaks2 & ~wMaks1 &  ~wMaks0 & iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest5 & ~iRequest4 )
						|(~wMaks2 &  wMaks1 &  wMaks0 &  iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest5 & ~iRequest4 & ~iRequest3)
						|(~wMaks2 &  wMaks1 & ~wMaks0 &  iRequest2 )
						|(~wMaks2 & ~wMaks1 &  wMaks0 &  iRequest2 & ~iRequest1 )
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest2 & ~iRequest1 & ~iRequest0 );
						
assign wGrant3 = 
						 ( wMaks2 & ~wMaks1 &  wMaks0 &  iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest5 )
                  |( wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest5 & ~iRequest4)
						|(~wMaks2 &  wMaks1 &  wMaks0 &  iRequest3 )
						|(~wMaks2 &  wMaks1 & ~wMaks0 &  iRequest3 & ~iRequest2 )
						|(~wMaks2 & ~wMaks1 &  wMaks0 &  iRequest3 & ~iRequest2 & ~iRequest1 )
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 );

assign wGrant4 = 
                   ( wMaks2 &  ~wMaks1 &  wMaks0 &  iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 & ~iRequest5)
						|( wMaks2 &  ~wMaks1 & ~wMaks0 &  iRequest4  )
						|(~wMaks2 &  wMaks1 &  wMaks0  &  iRequest4 & ~iRequest3  )
						|(~wMaks2 &  wMaks1 & ~wMaks0  &  iRequest4 & ~iRequest3 & ~iRequest2   )
						|(~wMaks2 & ~wMaks1 &  wMaks0  &  iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1  )
						|(~wMaks2 & ~wMaks1 & ~wMaks0  &  iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 );						

assign wGrant5 = 
                  ( wMaks2 &  ~wMaks1 &   wMaks0 & iRequest5 )
						|( wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest5 & ~iRequest4 )
						|(~wMaks2 &  wMaks1 &  wMaks0 &  iRequest5 & ~iRequest4 & ~iRequest3 )
						|(~wMaks2 &  wMaks1 & ~wMaks0 &  iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2 )
						|(~wMaks2 & ~wMaks1 &  wMaks0 &  iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 )
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 );												


assign oPriorityGrant = wGrant0;

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD0
( 	Clock, Reset, 1'b1 , wGrant0, oGrant0);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD1
( 	Clock, Reset, 1'b1 , wGrant1,  oGrant1 );

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD2
( 	Clock, Reset, 1'b1 , wGrant2, oGrant2 );

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD3
( 	Clock, Reset, 1'b1 , wGrant3, oGrant3 );

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD4
( 	Clock, Reset, 1'b1 , wGrant4, oGrant4 );

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD5
( 	Clock, Reset, 1'b1 , wGrant5, oGrant5 );


reg [4:0]  rCurrentState, rNextState;
//Next states logic and Reset sequence
always @(posedge Clock ) 
  begin 
			
    if (Reset )  
		rCurrentState <= 0; 
    else        
		rCurrentState <= rNextState; 
		
end
reg[2:0] rMask;

assign wMaks0 = rMask[0];
assign wMaks1 = rMask[1];
assign wMaks2 = rMask[2];

always @ ( * )
begin
	case (rCurrentState)
	//--------------------------------------
	0:
	begin
		rMask = 3'd0;
		rNextState = 1;
	end
	1:
	begin
		rMask = 3'd1;
		rNextState = 2;
	end
	2:
	begin
		rMask = 3'd2;
		rNextState = 3;
	end
	3:
	begin
		rMask = 3'd3;
		rNextState = 4;
	end
	4:
	begin
		rMask = 3'd4;
		rNextState = 5;
	end
	5:
	begin
		rMask = 3'd5;
		rNextState = 0;
	end
	endcase
end
	/*
UPCOUNTER_POSEDGE # (3) UP1
(
.Clock( Clock ),
.Reset( Reset ),
.Initial( 3'b0 ),
.Enable( 1'b1 ),
.Q({wMaks2,wMaks1,wMaks0})
);
*/
			
						
endmodule
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
module ROUND_ROBIN_7_ENTRIES
(
input wire Clock,
input wire Reset,
input wire iRequest0,
input wire iRequest1,
input wire iRequest2,
input wire iRequest3,
input wire iRequest4,
input wire iRequest5,
input wire iRequest6,
output wire oGrant0,
output wire oGrant1,
output wire oGrant2,
output wire oGrant3,
output wire oGrant4,
output wire oGrant5,
output wire oGrant6,
output wire oPriorityGrant

);
wire wMaks2,wMaks1,wMaks0;
wire wGrant0,wGrant1,wGrant2,wGrant3,wGrant4,wGrant5,wGrant6;

assign wGrant0 = 
                   ( wMaks2 &  wMaks1 & ~wMaks0 &  iRequest0 &  ~iRequest6 )
						|( wMaks2 & ~wMaks1 &  wMaks0 &  iRequest0 &  ~iRequest6 & ~iRequest5 )
						|( wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest0 &  ~iRequest6 & ~iRequest5 & ~iRequest4 )
						|(~wMaks2 &  wMaks1 &  wMaks0 &  iRequest0 &  ~iRequest6 & ~iRequest5 & ~iRequest4 & ~iRequest3 )
						|(~wMaks2 &  wMaks1 & ~wMaks0 &  iRequest0 &  ~iRequest6 & ~iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2)
						|(~wMaks2 & ~wMaks1 &  wMaks0 &  iRequest0 &  ~iRequest6 & ~iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1)
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest0 );
						
						
assign wGrant1 = 
                   ( wMaks2 &  wMaks1 & ~wMaks0 &   iRequest1 & ~iRequest0 &  ~iRequest6)
						|( wMaks2 & ~wMaks1 &  wMaks0 &   iRequest1 & ~iRequest0 &  ~iRequest6 & ~iRequest5 )
						|( wMaks2 & ~wMaks1 & ~wMaks0 &   iRequest1 & ~iRequest0 &  ~iRequest6 & ~iRequest5 & ~iRequest4 )
						|(~wMaks2 &  wMaks1 &  wMaks0 &   iRequest1 & ~iRequest0 &  ~iRequest6 & ~iRequest5 & ~iRequest4 & ~iRequest3)
						|(~wMaks2 &  wMaks1 & ~wMaks0 &   iRequest1 & ~iRequest0 &  ~iRequest6 & ~iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2)
						|(~wMaks2 & ~wMaks1 &  wMaks0 &   iRequest1 )
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &   iRequest1 & ~iRequest0);						

assign wGrant2 = 
                   ( wMaks2 &  wMaks1 & ~wMaks0 &  iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest6 )
						|( wMaks2 & ~wMaks1 &  wMaks0 &  iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest6 & ~iRequest5 )
						|( wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest6 & ~iRequest5 & ~iRequest4)
						|(~wMaks2 &  wMaks1 &  wMaks0 &  iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest6 & ~iRequest5 & ~iRequest4 & ~iRequest3)
						|(~wMaks2 &  wMaks1 & ~wMaks0 &  iRequest2 )
						|(~wMaks2 & ~wMaks1 &  wMaks0 &  iRequest2 & ~iRequest1 )
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest2 & ~iRequest1 & ~iRequest0 );
						
assign wGrant3 = 
						 ( wMaks2 &  wMaks1 & ~wMaks0 &  iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest6 )
                  |( wMaks2 & ~wMaks1 &  wMaks0 &  iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest6 & ~iRequest5)
						|( wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 &  ~iRequest6 & ~iRequest5 & ~iRequest4)
						|(~wMaks2 &  wMaks1 &  wMaks0 &  iRequest3 )
						|(~wMaks2 &  wMaks1 & ~wMaks0 &  iRequest3 & ~iRequest2 )
						|(~wMaks2 & ~wMaks1 &  wMaks0 &  iRequest3 & ~iRequest2 & ~iRequest1 )
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 );

assign wGrant4 = 
                   ( wMaks2 &   wMaks1 & ~wMaks0  &  iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 & ~iRequest6)
						|( wMaks2 &  ~wMaks1 &  wMaks0  &  iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 & ~iRequest6 & ~iRequest5)
						|( wMaks2 &  ~wMaks1 & ~wMaks0  &  iRequest4  )
						|(~wMaks2 &   wMaks1 &  wMaks0  &  iRequest4 & ~iRequest3  )
						|(~wMaks2 &   wMaks1 & ~wMaks0  &  iRequest4 & ~iRequest3 & ~iRequest2   )
						|(~wMaks2 &  ~wMaks1 &  wMaks0  &  iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1  )
						|(~wMaks2 &  ~wMaks1 & ~wMaks0  &  iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 );						

assign wGrant5 = 
                  (  wMaks2 &  wMaks1 & ~wMaks0  &  iRequest5 & ~iRequest4 )
						|( wMaks2 & ~wMaks1 &  wMaks0 &  iRequest5 )
						|( wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest5 & ~iRequest4 & ~iRequest3 )
						|(~wMaks2 &  wMaks1 &  wMaks0 &  iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2 )
						|(~wMaks2 &  wMaks1 & ~wMaks0 &  iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 )
						|(~wMaks2 & ~wMaks1 &  wMaks0 &  iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 )
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 & ~iRequest6);	

assign wGrant6 = 
                   ( wMaks2 &  wMaks1 & ~wMaks0 &  iRequest6 )
						|( wMaks2 & ~wMaks1 &  wMaks0 &  iRequest6 & ~iRequest5 )
						|( wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest6 & ~iRequest5 & ~iRequest4 )
						|(~wMaks2 &  wMaks1 &  wMaks0 &  iRequest6 & ~iRequest5 & ~iRequest4 & ~iRequest3 )
						|(~wMaks2 &  wMaks1 & ~wMaks0 &  iRequest6 & ~iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2 )
						|(~wMaks2 & ~wMaks1 &  wMaks0 &  iRequest6 & ~iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 )												
						|(~wMaks2 & ~wMaks1 & ~wMaks0 &  iRequest6 & ~iRequest5 & ~iRequest4 & ~iRequest3 & ~iRequest2 & ~iRequest1 & ~iRequest0 );												


assign oPriorityGrant = wGrant0;

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD0
( 	Clock, Reset, 1'b1 , wGrant0, oGrant0);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD1
( 	Clock, Reset, 1'b1 , wGrant1,  oGrant1 );

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD2
( 	Clock, Reset, 1'b1 , wGrant2, oGrant2 );

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD3
( 	Clock, Reset, 1'b1 , wGrant3, oGrant3 );

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD4
( 	Clock, Reset, 1'b1 , wGrant4, oGrant4 );

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD5
( 	Clock, Reset, 1'b1 , wGrant5, oGrant5 );


FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFD6
( 	Clock, Reset, 1'b1 , wGrant6, oGrant6 );


reg [4:0]  rCurrentState, rNextState;
//Next states logic and Reset sequence
always @(posedge Clock ) 
  begin 
			
    if (Reset )  
		rCurrentState <= 0; 
    else        
		rCurrentState <= rNextState; 
		
end
reg[2:0] rMask;

assign wMaks0 = rMask[0];
assign wMaks1 = rMask[1];
assign wMaks2 = rMask[2];

always @ ( * )
begin
	case (rCurrentState)
	//--------------------------------------
	0:
	begin
		rMask = 3'd0;
		rNextState = 1;
	end
	1:
	begin
		rMask = 3'd1;
		rNextState = 2;
	end
	2:
	begin
		rMask = 3'd2;
		rNextState = 3;
	end
	3:
	begin
		rMask = 3'd3;
		rNextState = 4;
	end
	4:
	begin
		rMask = 3'd4;
		rNextState = 5;
	end
	5:
	begin
		rMask = 3'd5;
		rNextState = 6;
	end
	6:
	begin
		rMask = 3'd6;
		rNextState = 0;
	end
	endcase
end

						
endmodule
`endif
