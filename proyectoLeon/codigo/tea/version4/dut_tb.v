`timescale 1ns/10ps
`include "dut.v"

`define WORD_SIZE 128
`define DELTA 32'h9e3779b9
`define ROUND_NUMBER 32

module testbench;

	parameter WORD_SIZE = `WORD_SIZE;
	parameter DELTA = `DELTA;
	parameter ROUND_NUMBER = `ROUND_NUMBER;
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
	wire [WORD_SIZE-1:0] A_cipher;
	wire [WORD_SIZE-1:0] B_cipher;
	//
	reg start;
	reg start2;
	wire done;
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
		.iK0(key0),
		.iK1(key1),
		.iK2(key2),
		.iK3(key3),
		.oC0(A_cipher),
		.oC1(B_cipher),
		.oV0(A_decipher),
		.oV1(B_decipher),
		.oDoneCipher(done1),
		.oDoneDecipher(done2)
	);

	// Task para randomizar los valores de entrada.
	task random; 
	begin
		key0 = $random;
		key1 = $random;
		key2 = $random;
		key3 = $random;
		B = 128'h9a34483d3b1a68a41235130bf207ee95;
		A = 128'h3ca67c8e158908776dcc3a7b41cb88e6;
	end
	endtask

	////////////////////////////////////////////
	initial begin

		$dumpfile("dut.vcd");
		$dumpvars;
		clk=0;
		rst = 0;
		start=0;
		start2=0;
		/*
		key0 = 32'h132acf42;
		key1 = 32'h234acb45;
		key2 = 32'h3235acbe;
		key3 = 32'h4533f235;

		A = 32'h3d45f7a7;
		B = 32'h235fcb21;
	*/
		random();
		#2 rst = 1;
		#4 rst = 0;

		#1000
		start2 = 1;

		#4000
		$display("Plain text = %X",{A,B});
		A = A_cipher;
		B = B_cipher;
		#10
		
		$display("Cipher text = %X",{tea.cifrar.oC1,tea.cifrar.oC0});
		
		start=1;

		#4000
		$display("Decipher text = %X",{A_decipher, B_decipher});
		
		#1 $finish;

	end

	always #5 clk=~clk;

endmodule
