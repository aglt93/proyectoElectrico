`timescale 1ns/10ps

`include "decipher.v"

module testbench;

	parameter WORD_SIZE = 16;
	parameter DELTA = 32'h9e3779b9;
	parameter ROUND_NUMBER = 32;
	////////////////////////////////////
	reg clk;
	reg rst;

	reg [WORD_SIZE-1:0] key0;
	reg [WORD_SIZE-1:0] key1;
	reg [WORD_SIZE-1:0] key2;
	reg [WORD_SIZE-1:0] key3;
	reg [WORD_SIZE-1:0] A;
	reg [WORD_SIZE-1:0] B;

	wire [WORD_SIZE-1:0] A_decipher;
	wire [WORD_SIZE-1:0] B_decipher;

	wire done;
	/////////////////////////////////////////
	cipher
	#(
		.WORD_SIZE(WORD_SIZE),
		.DELTA(DELTA),
		.ROUND_NUMBER(ROUND_NUMBER)
	)
	dut
	(
		.clk(clk),
		.rst(rst),
		.iV0(A),
		.iV1(B),
		.iK0(key0),
		.iK1(key1),
		.iK2(key2),
		.iK3(key3),
		.oC0(A_decipher),
		.oC1(B_decipher),
		.oDone(done)
	);

	initial begin

		$dumpfile("decipher.vcd");
		$dumpvars;
		clk=0;
		rst = 0;

		key0 = 32'h132acf42;
		key1 = 32'h234acb45;
		key2 = 32'h3235acbe;
		key3 = 32'h4533f235;

		A = 16'h5986;
		B = 16'h6d67;

		#2 rst = 1;
		#4 rst = 0;


		#4000	
		$display("Plain text = %X",{A,B});
		$display("decipher text = %X",{A_decipher,B_decipher});
		//$display("Decipher text = %X",{A_decipher, B_decipher});
		
		#1 $finish;

	end

	always #5 clk=~clk;

endmodule