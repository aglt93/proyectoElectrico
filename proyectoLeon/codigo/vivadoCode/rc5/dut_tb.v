`timescale 1ns/10ps

`include "dut.v"

`define W 32 // Cantidad de bits por palabra.
`define U (`W/8)
`define B 16 // Cantidad de bytes de la llave.
`define R 12 // Cantidad de rondas.
`define C (`B/`U) // Tamaño del vector L. Corresponde a b/u.

`define barrel32

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
	parameter B_LENGTH = $clog2(b);

	integer i;
	reg [127:0] key;

	reg [W-1:0] iA;
	reg [W-1:0] iB;
	reg [W-1:0] iA_cipher;
	reg [W-1:0] iB_cipher;

	reg clk;
	reg rst;
	reg iStartCipher;
	reg iStartDecipher;

	reg [7:0] iKey_sub_i;
	reg [B_LENGTH-1:0] iKey_address;
	reg iWen;

	wire [W-1:0] oA_cipher;
	wire [W-1:0] oB_cipher;
	wire [W-1:0] oA_decipher;
	wire [W-1:0] oB_decipher;
	wire oDoneCipher;
	wire oDoneDecipher;

	dut 
	#(
		.W(W),
		.C(C),
		.B(b),
		.R(R),
		.QW(QW)
	)
		dut
	(
		.clk(clk),
		.rst(rst),
		.iStartCipher(iStartCipher),
		.iStartDecipher(iStartDecipher),
		.iKey_sub_i(iKey_sub_i),
		.iKey_address(iKey_address),
		.iWen(iWen),
		.iA(iA),
		.iB(iB),
		.iA_cipher(iA_cipher),
		.iB_cipher(iB_cipher),
		.oA_cipher(oA_cipher),
		.oB_cipher(oB_cipher),
		.oA_decipher(oA_decipher),
		.oB_decipher(oB_decipher),
		.oDoneCipher(oDoneCipher),
		.oDoneDecipher(oDoneDecipher)
	);




	initial begin

		$dumpfile("dut.vcd");
		$dumpvars;
		clk=0;
		rst = 0;
		iStartCipher = 0;
		iStartDecipher = 0;
		key = 128'h91CEA91001A5556351B241BE19465F91; 
		//128'hd4543e135e68d4564a2c5b2aac54b1a5;
		   
		
		for (i = 0; i < C; i = i + 1) begin
			dut.L_RAM.ram[i]=0;
			
		end

		for (i = 0; i < b; i = i + 1) begin
			dut.key_RAM.ram[i]=key[8*i+:8];
			
		end 	

		dut.S_RAM.ram[0]=PW;

		iA = 32'heedba521;
		//32'hf232b52a;
		iB = 32'h6d8f4b15;
		//32'heeebba13;
		
		#2 rst = 1;
		#4 rst = 0;

		#100
		iStartCipher = 1;

		#27020
		$display("Plain text = %X",{iA,iB});
		$display("Cipher text = %X",{oA_cipher,oB_cipher});
		iA_cipher = oA_cipher;
		iB_cipher = oB_cipher;

		#10 

		iStartCipher = 0;

		#10
		for (i = 0; i < C; i = i + 1) begin
			dut.L_RAM.ram[i]=0;
		end

		for (i = 0; i < b; i = i + 1) begin
			dut.key_RAM.ram[i]=key[8*i+:8];
		end 
		dut.S_RAM.ram[0]=PW;

		#10
		iStartDecipher = 1;		

		#20000
		$display("Decipher text = %X",{oA_decipher, oB_decipher});
		
		#1 $finish;

	end

	always #5 clk=~clk;

endmodule