`include "ram.v"
`include "L_operation.v"


`timescale 1ns/10ps

`define w 32 // Cantidad de bits por palabra.
`define u 4 // Cantidad de bytes por palabra.
`define b 16 // Cantidad de bytes de la llave.
`define b_length $clog2(`b) // Bits para direccionar a todos los bytes b de la llave.
`define r 12 // Cantidad de rondas.
`define t 2*(`r+1) // Tamaño del vector S es igual a 2 (r+1) donde r es la cantidad de rondas.
`define t_length $clog2(`t) // Cantidad de bit para direccionar al vector S.
`define c 4 // Tamaño del vector L. Corresponde a b/u.
`define c_length 2 // Cantidad de bits para direccionar al vector L.
`define qW 5 //32'h9E3779B9 // Constantes
`define pW 10 //32'hB7E15163 //



module testbench
(
	output reg clk,
	output reg rst
);

	integer i;
	reg [127:0] key;

	initial begin

		$dumpfile("L.vcd");
		$dumpvars;
		
		clk=0;
		rst = 0;
		key = 128'hFFFEEEE58684FFF05FFE493853000434;

		for (i = 0; i < `c; i = i + 1) begin
				L_RAM.ram[i]=0;
		end

		for (i = 0; i < `b; i = i + 1) begin
				key_RAM.ram[i]=key[8*i+:8];
		end 

		#2 rst = 1;
		#4 rst = 0;
		#800 $finish;

	end

	always #5 clk=~clk;

endmodule



module probador;

	parameter W = `w;
	parameter W_bits = $clog2(W);
	parameter C = `c;
	parameter C_length = $clog2(C);
	parameter B = `b;
	parameter B_length = $clog2(B);

	wire clk;
	wire rst;
	//
	wire [W-1:0] L_sub_i_prima;
	wire [W-1:0] L_sub_i;
	wire L_we;
	wire [C_length-1:0] L_address;
	//
	wire [7:0] key_sub_i;
	wire [B_length-1:0] key_address;
	wire done;

	////////////////////////////////////////////
	testbench test
	(
		.clk(clk),
		.rst(rst)
	);

	/////////////////////////////////////////////
	L_operation 
	#(
		.W(W),
		.C(C)
	)
	operation
	(
		.clk(clk),
		.rst(rst),
		.L_sub_i(L_sub_i),
		.L_sub_i_prima(L_sub_i_prima),
		.L_we(L_we),
		.L_address(L_address),
		.key_address(key_address),
		.key_sub_i(key_sub_i),
		.done(done)
	);


	////////////////////////////////////////////
	RAM_DUAL_READ_DUAL_WRITE_PORT  
	#( 
		.DATA_WIDTH(8),
		.ADDR_WIDTH(B_length) 
	)
	key_RAM
	(
		.clk(clk),
		.data_a(0),
		.data_b(0),
		.addr_a(key_address),
		.addr_b(0),
		.we_a(0),
		.we_b(0),
		.q_a(key_sub_i)
	);


	///////////////////////////////////////////
	RAM_DUAL_READ_DUAL_WRITE_PORT  
	#( 
		.DATA_WIDTH(W),
		.ADDR_WIDTH(C_length) 
	)
	L_RAM
	(
		.clk(clk),
		.data_a(L_sub_i_prima),
		.data_b(0),
		.addr_a(L_address),
		.addr_b(0),
		.we_a(L_we),
		.we_b(0),
		.q_a(L_sub_i)
	);


endmodule