`timescale 1ns/10ps


module initArrayS
#(
	parameter b = 16,
	parameter b_length = 4,
	parameter w = 32,
	parameter t = 26,
	parameter t_length = $clog2(t),
	parameter qW = 32'h9E3779B9
)

(
	input clk1,
	input clk2,
	input rst,
	input [w-1:0]S_sub_i,

	output reg [w-1:0] S_sub_i_prima,
	output [t_length-1:0] S_address,
	output wire done
);

	reg [t_length-1:0] count;
	assign S_address = count;

	assign done = (count==(t-1)) ? 1:0;

	always @(posedge clk2 or posedge rst) begin

		if(rst) begin
			count = 2**t_length-1;
		end

		else begin 
			if (done==0) begin
				S_sub_i_prima = S_sub_i + qW;
			end
		end
	end

	always @(posedge clk1) begin
		if (done==0 && rst==0) begin
			count = count + 1;
		end
	end


endmodule

