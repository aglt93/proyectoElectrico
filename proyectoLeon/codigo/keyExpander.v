`include "L_operation.v"
`include "S_operation.v"
`include "mixer.v"


module keyExpander 
#(
	parameter b = 16,
	parameter b_length = 4,
	parameter w = 32,
	parameter u = 4,
	parameter c = 4,
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

	wire L_done;
	wire S_done;

	wire start;

	wire [c_length-1:0] L_address1;
	wire [c_length-1:0] L_address2;
	wire [w-1:0] L_sub_i_prima1;
	wire [w-1:0] L_sub_i_prima2;

	wire [t_length-1:0] S_address1;
	wire [t_length-1:0] S_address2;
	wire [w-1:0] S_sub_i_prima1;
	wire [w-1:0] S_sub_i_prima2;

	assign start = L_done && S_done;

	assign L_sub_i_prima = (!start) ? L_sub_i_prima1:L_sub_i_prima2;
	assign L_address = (!start) ? L_address1:L_address2;

	assign S_sub_i_prima = (!start) ? S_sub_i_prima1:S_sub_i_prima2;
	assign S_address = (!start) ? S_address1:S_address2;


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
        .L_sub_i_prima(L_sub_i_prima1),
        .key_address(key_address),
        .L_address(L_address1),
        .done(L_done)
	);
	/////////////////////////////////////////////
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
        .S_sub_i_prima(S_sub_i_prima1),
        .S_address(S_address1),
        .done(S_done)	
	);
	//////////////////////////////////////////////
	
	keyMixer
	#(
		.w(w),
		.c(c),
		.c_length(c_length),
		.t(t),
		.t_length(t_length)
	)
	mixer
	(
		.clk1(clk1),
        .clk2(clk2),
        .rst(rst),
        .start(start),
        //
		.L_address(L_address2),
        .L_sub_i(L_sub_i),
        .L_sub_i_prima(L_sub_i_prima2),
        //
        .S_sub_i(S_sub_i),
        .S_sub_i_prima(S_sub_i_prima2),
        .S_address(S_address2),
        //
        .done(done)
	);
	


endmodule