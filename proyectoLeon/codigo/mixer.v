
module keyMixer 
#(
	parameter w = 32,
	parameter c = 4,
	parameter c_length = 2,
	parameter t = 26,
	parameter t_length = $clog2(t)
)

(
	input clk1,
	input clk2,
	input rst,
	input start,
	//
	output [c_length-1:0] L_address,
	input [w-1:0] L_sub_i,
    output reg [w-1:0] L_sub_i_prima,
    // 
    input [w-1:0] S_sub_i,
    output [t_length-1:0] S_address,
    output reg [w-1:0] S_sub_i_prima,
    //
    output done

);

	parameter mixCount = (t>c) ? 3*t:3*c;
	parameter mixCount_length = $clog2(mixCount);
	parameter rotValue = $clog2(w);

	reg [mixCount-1:0] count;
	reg [w-1:0] A;
	reg [w-1:0] B;
	reg [t_length-1:0] i;
	reg [c_length-1:0] j;
	reg [rotValue-1:0] rot_L;

	assign done = (count==mixCount) ? 1:0;
	assign S_address = i;
	assign L_address = j;

	always @(posedge clk2 or posedge rst) begin

		if (rst) begin
			count = 0;
			A = 0;
			B = 0;
			i = 0;
			j = 0;
			
		end

		else if (!done && start) begin
			
			S_sub_i_prima = S_sub_i+A+B;
			S_sub_i_prima = {S_sub_i_prima[2:0],S_sub_i_prima[w-1:3]};
			A = S_sub_i_prima;
			//
			L_sub_i_prima = L_sub_i + A + B;
			rot_L = (A + B) % w;
			B = L_sub_i_prima;
			//
			i = (i+1) % t;
			j = (j+1) % c;
			count = count+1;

		end
	end
	/*
	always @(posedge clk1) begin
		if (start) begin
				
		end
	end
	*/
endmodule