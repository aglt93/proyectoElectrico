module cipher
#(
	parameter r = 12,
	parameter t = 26,
	parameter w = 32
)

(
	input clk1,
	input clk2,
	input rst,
	//
	input start,
	input [w-1:0] A_cipher,
	input [w-1:0] B_cipher,
	input [w-1:0] S_sub_i1,
	input [w-1:0] S_sub_i2,
	output [t_length-1:0] S_address,
	output done,
	output reg [w-1:0] A_decipher,
	output reg [w-1:0] B_decipher
);

	parameter r_length = $clog2(r);
	parameter t_length = $clog2(t);

	reg [r_length:0] countDecipher;
	reg i;

	assign done = (countDecipher == 0) ? 1:0;
	assign  S_address = 2*i;

	always @(posedge clk2 or posedge rst) begin
		
		if (rst) begin
			countDecipher = 0;
		end

		else if (!done && start) begin
			if (countDecipher == r) begin
				A_decipher = (A_cipher - S_sub_i1) ^ B_cipher;
				B_decipher = (B_cipher - S_sub_i2) ^ A_cipher;
			end
			else if (countDecipher == 1) begin
				A_decipher = A_decipher - S_sub_i1;
				B_decipher = B_decipher - S_sub_i2;	
			end

			else begin
				A_decipher = (A_decipher - S_sub_i1) ^ B_decipher;
				B_decipher = (B_decipher - S_sub_i2) ^ A_decipher;	
			end
			
		end
	end

	always @(posedge clk1) begin
		if(start) begin
			countDecipher = countDecipher-1;
		end
	end

endmodule