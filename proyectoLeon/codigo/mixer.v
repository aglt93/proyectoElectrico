`include "L_operation.v"
`include "S_operation.v"


module keyMixer 
#(
	parameter b = 16,
	parameter b_length = 4,
	parameter w = 32,
	parameter u = 4,
	parameter c_length = 2,
	parameter t = 26,
	parameter t_length = $clog2(t),
	parameter qW = 32'h9E3779B9
)

(
	// Entradas generales
	input clk1,
	input clk2,
	input rst,
	// Entradas/salidas para L.
	input [7:0] key_sub_i,
	input [w-1:0] L_sub_i,
	output [b_length-1:0] key_address,
	output [c_length-1:0] L_address,
	output [w-1:0] L_sub_i_prima,
	// Entradas/salidas para S.
	input [w-1:0]S_sub_i,
	output [w-1:0] S_sub_i_prima,
	output [t_length-1:0] S_address,
	output done
);

	keyBytesToWords 
	#(
		.b(b),
        .b_length(b_length),
        .w(w),
        .u(u),
        .c_length(c_length)
	)
	block_L
	(
        .clk1(clk1),
        .clk2(clk2),
        .rst(rst),
        .key_sub_i(key_sub_i),
        .L_sub_i(L_sub_i),
        .L_sub_i_prima(L_sub_i_prima),
        .key_address(key_address),
        .L_address(L_address)

	);
	///////////////////
	initArrayS
	#(
		.w(w),
        .t(t),
        .t_length(t_length),
        .qW(qW)
	)
	block_S
	(
		.clk1(clk1),
        .clk2(clk2),
        .rst(rst),
        .S_sub_i(S_sub_i),
        .S_sub_i_prima(S_sub_i_prima),
        .S_address(S_address),
        .done(done)	
	);

endmodule