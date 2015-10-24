`timescale 1ns/10ps

module keyBytesToWords 
#(
	parameter b = 16,
	parameter b_length = 4,
	parameter w = 32,
	parameter u = 4,
	parameter c = 4,
	parameter c_length = 2
)

(
	input clk1,
	input clk2,
	input rst,
	input [7:0] key_sub_i,
	input [w-1:0] L_sub_i,
	output [b_length-1:0] key_address,
	output [c_length-1:0] L_address,
	output reg [w-1:0] L_sub_i_prima
);

	reg [b_length:0] count;

	wire done;


	assign done = (!count) ? 1:0;
	assign key_address = count;
	assign L_address = count/u;

	reg [w-1:0] temp;

	always @(posedge clk2 or posedge rst) begin

		if(rst) begin
			count = b;
		end

		else begin 
			if (done==0) begin
				temp = {L_sub_i[7:0],L_sub_i[w-1:0]};	
				//$display("L = %h   ,  temp = %h" , L_sub_i,temp);
				L_sub_i_prima = temp + key_sub_i;
			end
		end
	end

	always @(posedge clk1) begin
		if (done==0 && rst==0) begin
			count = count - 1;
		end
	end

endmodule