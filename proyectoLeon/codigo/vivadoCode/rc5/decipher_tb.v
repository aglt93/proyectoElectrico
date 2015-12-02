`timescale 1ns/10ps
`include "decipher_dut.v"

`define W 16 // Cantidad de bits por palabra.
`define U (`W/8)
`define B 16 // Cantidad de bytes de la llave.
`define R 12 // Cantidad de rondas.
`define C (`B/`U) // Tamaño del vector L. Corresponde a b/u.

`define barrel16

`ifdef barrel16
	`define PW 16'hb7e1 // Constantes
	`define QW 16'h9e37 //
`endif

`ifdef barrel32
	`define PW 32'hb7e15163 // Constantes
	`define QW 32'h9e3779b9//
`endif

`ifdef barrel64
	`define PW 64'hb7e151628aed2a6b // Constantes
	`define QW 64'h9e3779b97f4a7c15 //
`endif

module testbench;

	parameter W = `W;
	parameter C = `C;
	parameter b = `B;
	parameter R = `R;
	parameter QW = `QW;
	parameter PW = `PW;


	integer i;
	reg [127:0] key;
	reg clk;
	reg rst;

	wire done;
	reg [W-1:0] A;
	reg [W-1:0] B;
	wire [W-1:0] A_decipher;
	wire [W-1:0] B_decipher;


	decipher_dut 
	#(
		.W(W),
		.C(C),
		.B(b),
		.R(R),
		.QW(QW)
	)
		dut
	(
		clk,
		rst,
		A,
		B,
		A_decipher,
		B_decipher,
		done
	);

	initial begin

		$dumpfile("decipher.vcd");
		$dumpvars;
		clk=0;
		rst = 0;
		key = 128'h91CEA91001A5556351B241BE19465F91;

		for (i = 0; i < C; i = i + 1) begin
			dut.L_RAM.ram[i]=0;
		end

		for (i = 0; i < b; i = i + 1) begin
			dut.key_RAM.ram[i]=key[8*i+:8];
		end 	

		dut.S_RAM.ram[0]=PW;

		A = 32'heedba521;
		B = 32'h6d8f4b15;

		#2 rst = 1;
		#4 rst = 0;


		/*
		#1100
		$display("Valores de L:\n");
		for (i = 0; i < `c; i = i + 1) begin
			$display("L[%d] = %H", i,dut.L_RAM.ram[i]);
		end
		
		$display("\n\nValores de S:\n");
		
		for (i = 0; i <= `t; i = i + 1) begin
			$display("%H",dut.S_RAM.ram[i]);
		end 
		*/
		#11900
		/*
		$display("\n\nValores de S:\n");
		
		for (i = 0; i < `t; i = i + 1) begin
			$display("%H",dut.S_RAM.ram[i]);
		end
		
		$display("Valores de L:\n");
		for (i = 0; i < `c; i = i + 1) begin
			$display("L[%d] = %H", i,dut.L_RAM.ram[i]);
		end
		
		#3000
		*/		
		$display("Plain text = %X",{A,B});
		$display("Cipher text = %X",{dut.oA_cipher,dut.oB_cipher});
		$display("Decipher text = %X",{A_decipher, B_decipher});
		
		#1 $finish;

	end

	always #5 clk=~clk;

endmodule