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
	input [w-1:0] pW,
	input [w-1:0] qW,
	input [8*b-1:0] key,
	output [w-1:0] out0,out1,out2,out3
);


	wire [w-1:0] S [t-1:0];
	wire [w-1:0] L [c-1:0];
	wire [7:0] keyInBytes [b-1:0];

	generate

		genvar i,j;
		/*
		for (j = 0; j < b; j = j+1) begin
			assign keyInBytes[j]=key[8*j+7:8*j];
		end
		*/
		for (i = b-1; i >= 0 ; i = i - 1) begin
			oper1 #(w) hola (clk,rst,L[i/u],key[8*i+7:8*i],L[i/u]);
		end

	endgenerate

	assign out0 = L[0];
	assign out1 = L[1];
	assign out2 = L[2];
	assign out3 = L[3];

endmodule

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
