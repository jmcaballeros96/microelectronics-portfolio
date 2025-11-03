`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
// 
// Create Date: 06.11.2018 13:22:39
// Design Name:
// Module Name: unit3_1_fixed
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module unit3_1_fixed (clk, rst, convierte, IN, Rcentenas, Rdecenas, Runidades, fin, listo);

  parameter N = 9;

  // Ports
  input              clk;
  input              rst;
  input              convierte;
  input      [N-1:0] IN;

  output reg [3:0]   Rcentenas;
  output reg [3:0]   Rdecenas;
  output reg [3:0]   Runidades;
  output             fin;
  output             listo;

  // Auxiliar function
  function integer F1;
    input [31:0] num;
    integer i;
    begin
      i = num;		
      for(F1 = 0; i > 0; F1 = F1 + 1)
        i = i >> 1;
    end
  endfunction

  // Inner registers
  reg [F1(N)-1:0] Contador;
  reg [N-1:0]     RIN;
  reg [2:0]       state;

  initial begin
  state      = 3'b000;
  Contador   = 0;
  RIN        = 0;
  Rcentenas  = 0;
  Rdecenas   = 0;
  Runidades  = 0;
  end

  // States
  parameter espera  = 3'b000,
            prepara = 3'b001,
            opera1  = 3'b010,
            opera2  = 3'b011,
            ultimo  = 3'b100;

  // Status signals
  assign listo = (state == espera);
  assign fin   = (state == ultimo);

  // Main
  always @(posedge clk) begin

    if (rst) begin
      state     <= espera;
      Rcentenas <= 0;
      Rdecenas  <= 0;
      Runidades <= 0;
      Contador  <= 0;
      RIN       <= 0;


    end else begin
      case (state)

        espera: begin

          if (convierte == 1)
            state <= prepara;
          else
            state <= espera;
        end

        prepara: begin
          Rcentenas <= 0;
          Rdecenas  <= 0;
          Runidades <= 0;
          RIN       <= IN;
          Contador  <= N-1;
          state     <= opera1;
        end

        opera1: begin
          if (Rdecenas  >= 5) Rdecenas  <= Rdecenas  + 3;
          if (Runidades >= 5) Runidades <= Runidades + 3;
          if (Rcentenas >= 5) Rcentenas <= Rcentenas + 3;
          state <= opera2;
        end

        opera2: begin
          Contador  <= Contador - 1;
          Rcentenas <= {Rcentenas[2:0], Rdecenas[3]};
          Rdecenas  <= {Rdecenas [2:0], Runidades[3]};
          Runidades <= {Runidades[2:0], RIN[N-1]};
          RIN       <= RIN << 1;

          if (Contador == 0)
            state <= ultimo;
          else
            state <= opera1;
        end

        ultimo: begin
          state <= espera;
        end

        default: begin
          state <= espera;
        end

      endcase
    end

  end

endmodule
