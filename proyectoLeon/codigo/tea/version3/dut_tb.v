`timescale 1ns/10ps

`include "dut.v"

module testbench;

	parameter WORD_SIZE = 32;
	parameter DELTA = 32'h9e3779b9;
	parameter ROUND_NUMBER = 32;
	////////////////////////////////////
	reg clk;
	reg rst;

	reg [WORD_SIZE-1:0] key0;
	reg [WORD_SIZE-1:0] key1;
	reg [WORD_SIZE-1:0] key2;
	reg [WORD_SIZE-1:0] key3;
	//
	reg [WORD_SIZE-1:0] A;
	reg [WORD_SIZE-1:0] B;
	//
	wire [WORD_SIZE-1:0] A_decipher;
	wire [WORD_SIZE-1:0] B_decipher;
	//
	reg start;
	reg start2;
	wire done;
	wire [1:0] oKey_address;
	reg [WORD_SIZE-1:0] iKey_sub_i;

	/////////////////////////////////////////
	dut
	#(
		.WORD_SIZE(WORD_SIZE),
		.DELTA(DELTA),
		.ROUND_NUMBER(ROUND_NUMBER)
	)
	tea
	(
		.clk(clk),
		.rst(rst),
		.iStartCipher(start2),
		.iStartDecipher(start),
		.iV0(A),
		.iV1(B),
		.iKey_sub_i(iKey_sub_i),
		.oKey_address(oKey_address),
		.oC0(A_decipher),
		.oC1(B_decipher),
		.oDone(done1)
	);


	always @(oKey_address) begin

		iKey_sub_i = 0;

		case(oKey_address)

			0: begin
				iKey_sub_i = key0;
			end

			1: begin
				iKey_sub_i = key1;
			end

			2: begin
				iKey_sub_i = key2;
			end

			3: begin
				iKey_sub_i = key3;
			end


		endcase

	end

	initial begin

		$dumpfile("dut.vcd");
		$dumpvars;
		clk=0;
		rst = 0;
		start=0;
		start2=0;
		key0 = 32'h132acf42;
		key1 = 32'h234acb45;
		key2 = 32'h3235acbe;
		key3 = 32'h4533f235;

		A = 32'h3d45f7a7;
		B = 32'h235fcb21;

		#2 rst = 1;
		#4 rst = 0;

		#1000
		start2 = 1;

		#4000
		$display("Plain text = %X",{A,B});
		A = A_decipher;
		B = B_decipher;
		#10
		
		$display("Cipher text = %X",{A_decipher,B_decipher});
		start2 = 0;
		#100
		start=1;

		#4000
		$display("Decipher text = %X",{A_decipher, B_decipher});
		
		#1 $finish;

	end

	always #5 clk=~clk;

endmodule