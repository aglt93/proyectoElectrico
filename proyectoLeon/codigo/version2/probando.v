`include "ram.v"
`include "keyExpander.v"

module hola
#(
	parameter W = 32,
	parameter C = 4,
	parameter B = 16,
	parameter R = 12,
	parameter QW = 32'hB7E15163
)
(
	input wire clk,
	input wire rst
);

	parameter T = 2*(R+1);
	parameter W_BITS = $clog2(W);
	parameter C_LENGTH = $clog2(C);
	parameter B_LENGTH = $clog2(B);
	parameter T_LENGTH = $clog2(T);

	wire [W-1:0] S_sub_i;
	wire [W-1:0] L_sub_i;
	wire [7:0] key_sub_i;
	wire [C_LENGTH-1:0] L_address;
	wire [T_LENGTH-1:0] S_address;
	wire L_we;
	wire S_we;
	wire [B_LENGTH-1:0] key_address;
	wire [W-1:0] S_sub_i_prima;
	wire [W-1:0] L_sub_i_prima;
	wire keyExpanderDone;



	//********************************************************************
	keyExpander
	#(
		.W(W),
		.C(C),
		.B(B),
		.R(R),
		.QW(QW)
	)
	expander
	(
		.clk(clk),
		.rst(rst),
		.iS_sub_i(S_sub_i),
		.iL_sub_i(L_sub_i),
		.iKey_sub_i(key_sub_i),
		.oL_address(L_address),
		.oS_address(S_address),
		.oKey_address(key_address),
		.oL_we(L_we),
		.oS_we(S_we),
		.oS_sub_i_prima(S_sub_i_prima),
		.oL_sub_i_prima(L_sub_i_prima),
		.oKeyExpanderDone(keyExpanderDone)
	);	
	//********************************************************************
	RAM_DUAL_READ_DUAL_WRITE_PORT  
	#( 
		.DATA_WIDTH(W),
		.ADDR_WIDTH(T_LENGTH) 
	)
	S_RAM
	(
		.clk(clk),
		.data_a(S_sub_i_prima),
		.data_b(0),
		.addr_a(S_address),
		.addr_b(0),
		.we_a(S_we),
		.we_b(0),
		.q_a(S_sub_i)
	);
	//********************************************************************
	RAM_DUAL_READ_DUAL_WRITE_PORT  
	#( 
		.DATA_WIDTH(8),
		.ADDR_WIDTH(B_LENGTH) 
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
	//*****************************************************
	RAM_DUAL_READ_DUAL_WRITE_PORT  
	#( 
		.DATA_WIDTH(W),
		.ADDR_WIDTH(C_LENGTH) 
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