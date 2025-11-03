// ======================= TESTBENCH ======================
`timescale 1ns/1ps
module tb;
  parameter N = 9;

  reg              clk = 0;
  reg              rst = 0;
  reg              convierte = 0;
  reg  [N-1:0]     IN = 0;
  wire [3:0]       Rcentenas, Rdecenas, Runidades;
  wire             fin, listo;

  unit3_1_fixed #(.N(N)) dut (
    .clk(clk), .rst(rst), .convierte(convierte), .IN(IN),
    .Rcentenas(Rcentenas), .Rdecenas(Rdecenas), .Runidades(Runidades),
    .fin(fin), .listo(listo)
  );

  // Reloj (100 MHz)
  always #5 clk = ~clk;

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb);
  end

  initial begin
    // Reset síncrono
    rst = 1;
    repeat (3) @(posedge clk);
    rst = 0;
    
    //Requisito 1 y 2 => Prueba 1 y 2
    // PRUEBA 1: IN = 19 
    IN = 19;
    convierte = 1;
    @(posedge clk);
    convierte = 0;

    wait (fin == 1);
    @(posedge clk);
    $display("IN=19  -> C:%0d D:%0d U:%0d", Rcentenas, Rdecenas, Runidades);

    // PRUEBA 2: IN = 511
    IN = 511;
    convierte = 1;
    @(posedge clk);
    convierte = 0;

    wait (fin == 1);
    @(posedge clk);
    $display("IN=511 -> C:%0d D:%0d U:%0d", Rcentenas, Rdecenas, Runidades);

    // Requisito 3
    // PRUEBA 3: 511 Con rst interrumpiendo
    IN = 511;
    convierte = 1;
    @(posedge clk);
    convierte = 0;
    repeat (5) @(posedge clk);
    rst = 1;
    @(posedge clk);
    rst = 0;
    @(posedge clk);
    $display("IN =511 tras reset en medio: C=%0d D=%0d U=%0d", Rcentenas, Rdecenas, Runidades);

    // Resuisito 4
    // PRUEBA 4: IN = 19 y luego IN =511
    IN = 19;
    convierte = 1;
    @(posedge clk);
    convierte = 0;
    repeat (2) @(posedge clk);

    IN = 511;
    convierte = 1;
    @(posedge clk);
    convierte = 0;
    wait (fin==1);
    $display("IN = 19 y cambio IN=511 -> C:%0d D:%0d U:%0d", Rcentenas, Rdecenas, Runidades);

    $finish;
  end
endmodule