`include "S_operation.v"
`timescale 1ns/10ps

`define w 32 // Cantidad de bits por palabra.
`define u 4 // Cantidad de bytes por palabra.
`define b 16 // Cantidad de bytes de la llave.
`define b_length $clog2(`b) // Bits para direccionar a todos los bytes b de la llave.
`define r 12 // Cantidad de rondas.
`define t 2*(`r+1) // Tamaño del vector S es igual a 2 (r+1) donde r es la cantidad de rondas.
`define t_length $clog2(`t)
`define c 4 // Tamaño del vector L. Corresponde a b/u.
`define c_length 2 // Cantidad de bits para direccionar al vector L.
`define qW 5 //32'h9E3779B9 // Constantes
`define pW 10 //32'hB7E15163 //

module probador 
(
    output reg rst,
    output reg clk1,
    output reg clk2,
    output reg [`w-1:0] S_sub_i,
    input [`t_length-1:0] S_address,
    input [`w-1:0] S_sub_i_prima,
    input done
);

    // Definiciones iniciales
    integer i;

    reg [`w-1:0] S [`t-1:0];


    // Include del driver
    `include "S_driver.v"


    // Initial
    initial begin

    $dumpfile("S_prueba.vcd");
    $dumpvars;

    S[0] = `pW;
    clk1 = 0;

    // Tarea de inicio.
    drv_init();

    // Tareas para llenar el vector L.
    repeat(40) begin
        fork 
            drv_write();
            drv_read();
        join
    end

    // Finaliza la simulacion.
    #2 $finish;
    		
    end

    // Reloj 1.
    always #5 clk1 = ~clk1;	

    // Reloj 2, retrasado respecto al clk1.
    always @(*) begin
        clk2 = #0.5 clk1;
    end

endmodule




module tester;

    wire clk1;
    wire clk2;
    wire rst;
    wire [`w-1:0] S_sub_i;
    wire [`w-1:0] S_sub_i_prima;
    wire [`t_length-1:0] S_address;
    wire done;
     
    probador test
    (
        .clk1(clk1),
        .clk2(clk2),
        .rst(rst),
        .S_sub_i(S_sub_i),
        .S_sub_i_prima(S_sub_i_prima),
        .S_address(S_address),
        .done(done)
    );
      
    initArrayS
    #(
        .w(`w),
        .t(`t),
        .t_length(`t_length),
        .qW(`qW)
    )
    pegado 
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