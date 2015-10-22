`timescale 1ns/10ps

module keyBytesToWords 
#(
	parameter b = 16, 
	parameter t = 26, 
	parameter w = 32,
	parameter u = 4,
	parameter c = 4
)

(
	input clk,
	input rst,
	input [7:0] key_sub_i,
	input [w-1:0] L_sub_i,
	output key_address,
	output [] L_address,
	output [w-1:0] L_sub_i_prima
);

	reg [w-1:0] temp;	
	reg [4:0] count;

	wire done;


	assign done = (!count) ? 1:0;

	always @(posedge clk or posedge rst) begin

		if(rst) begin
			count = b;
		end

		else begin 
			if (done==0) begin
				L_sub_i_prima =  {L_sub_i[7:0],L_sub_i[w-1:0]} + key_sub_i;
				count = count - 1;
			end
		end
	end

endmodule
/*
module oper1 
#(
	parameter w = 32
)

(
	input clk,
	input rst,
	input [w-1:0] wordIn,
	input [7:0] constant,
	output reg [w-1:0] wordOut
);

	wire [w-9:0] zeros;
	assign zeros = 0;

	reg [7:0] temporal;

	always @(posedge clk or posedge rst) begin

		if(rst) begin
			wordOut = 0;
		end

		else begin
			temporal = #1 constant;
			wordOut = #1 {wordIn[7:0],wordIn[w-1:8]} + {zeros,temporal};	

		end

	end

endmodule
*/