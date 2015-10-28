`include "mixer.v"

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

module probador 
(
    output reg rst,
    output reg clk1,
    output reg clk2,
    //
    output reg [`w-1:0] L_sub_i,
    output reg [7:0] key_sub_i,
    input [`b_length-1:0] key_address,
    input [`c_length-1:0] L_address,
    input [`w-1:0] L_sub_i_prima,
    input L_done,
    //
    output reg [`w-1:0] S_sub_i,
    input [`t_length-1:0] S_address,
    input [`w-1:0] S_sub_i_prima,
    input S_done
);

    integer i;

    reg [`w-1:0] L [`c-1:0];
    reg [`w-1:0] S [`t-1:0];
    reg [7:0] keyInBytes [`b-1:0];
    reg [8*`b-1:0] key;

    `include "mixer_driver.v"

    initial begin

    $dumpfile("mixer_prueba.vcd");
    $dumpvars;

    S[0] = `pW;
    key = 128'hFFFEEEE58684FFF05FFE493853000434;
    clk1 = 0;

    drv_init();

    repeat(40) begin
        fork 
            drv_write();
            drv_read();
        join
    end

    #2 $finish;
    		
    end

    always #5 clk1 = ~clk1;	

    always @(*) begin
        clk2 = #0.5 clk1;
    end

endmodule


module tester;

    wire [7:0] key_sub_i;
    wire [`w-1:0] L_sub_i,L_sub_i_prima;
    wire [`b_length-1:0] key_address;
    wire [`c_length-1:0] L_address;
    wire L_done;
    //
    wire [`w-1:0] S_sub_i;
    wire [`w-1:0] S_sub_i_prima;
    wire [`t_length-1:0] S_address;
    wire S_done;
     
    probador test
    (
        .clk1(clk1),
        .clk2(clk2),
        .rst(rst),
        //
        .key_sub_i(key_sub_i),
        .L_sub_i(L_sub_i),
        .L_sub_i_prima(L_sub_i_prima),
        .key_address(key_address),
        .L_address(L_address),
        .L_done(L_done),
        //
        .S_sub_i(S_sub_i),
        .S_sub_i_prima(S_sub_i_prima),
        .S_address(S_address),
        .S_done(S_done)
    );
      
    keyMixer 
    #(
        .b(`b),
        .b_length(`b_length),
        .w(`w),
        .u(`u),
        .c_length(`c_length),
        .t(`t),
        .t_length(`t_length),
        .qW(`qW)
    )
    pegado 
    (
        .clk1(clk1),
        .clk2(clk2),
        .rst(rst),
        //
        .key_sub_i(key_sub_i),
        .L_sub_i(L_sub_i),
        .L_sub_i_prima(L_sub_i_prima),
        .key_address(key_address),
        .L_address(L_address),
        .L_done(L_done),
        //
        .S_sub_i(S_sub_i),
        .S_sub_i_prima(S_sub_i_prima),
        .S_address(S_address),
        .S_done(S_done)
    );

endmodule