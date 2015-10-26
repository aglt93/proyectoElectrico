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
	input [w-1:0] A,
	input [w-1:0] B,
	input [w-1:0] S_sub_i1,
	input [w-1:0] S_sub_i2,
	output [t_length-1:0] S_address,
	output done,
	output reg [w-1:0] A_cipher,
	output reg [w-1:0] B_cipher
);

	parameter r_length = $clog2(r);
	parameter t_length = $clog2(t);

	reg [r_length:0] countCipher;
	reg i;

	assign done = (countCipher == r) ? 1:0;
	assign  S_address = 2*i;

	always @(posedge clk2 or posedge rst) begin
		
		if (rst) begin
			countCipher = 0;
		end

		else if (!done && start) begin
			if (countCipher == 1) begin
				A_cipher = (A ^ B) + S_sub_i1;
				B_cipher = (A ^ B) + S_sub_i2;
			end
			else begin
				A_cipher = (A_cipher ^ B_cipher) + S_sub_i1;
				B_cipher = (A_cipher ^ B_cipher) + S_sub_i2;	
			end
			
		end
	end

	always @(posedge clk1) begin
		if(start) begin
			countCipher = countCipher+1;
		end
	end

endmodule