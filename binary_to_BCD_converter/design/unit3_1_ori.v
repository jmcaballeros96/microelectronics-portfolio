`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.11.2018 13:22:39
// Design Name: 
// Module Name: unit3_1
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


module unit3_1  (clk, rst, convierte, IN, Rcentenas, Rdecenas, Runidades, fin, listo);

parameter N= 9;
input clk, rst, convierte;
input [N-1:0] IN;
output reg [3:0] Rcentenas, Rdecenas, Runidades;
output fin, listo;


function integer F1;
	input [31:0] num;
	integer i;
	begin
	 	i = num;		
		for(F1 = 0; i > 0; F1 = F1 + 1)
			i = i >> 1;
	end
endfunction

reg[2:0] Contador;
reg [N-1:0] RIN;
parameter espera=3'b000, prepara=3'b001, opera1=3'b010, opera2=3'b011, ultimo=3'b100;
reg [2:0] state;
assign listo = (state==espera);
assign fin =(state==ultimo);

always @(posedge clk)
if (rst)
state<= espera;
else
case (state)
espera: begin if (convierte == 1) state <= prepara; else state <= espera; end
prepara: begin Rcentenas <= 0; Rdecenas <= 0; Runidades <= 0; Contador <= N-1; RIN <= IN; state <= opera1; end
opera1:begin if (Rdecenas >= 5) Rdecenas <= Rdecenas +3; 
             if (Runidades >=5) Runidades <= Runidades + 3;
             if (Rcentenas >=5) Rcentenas <= Rcentenas + 3;
             state <= opera2;
        end
opera2: begin
            Contador <= Contador -1;
            Rcentenas <= {Rcentenas[2:0], Rdecenas[3]};
            Rdecenas <= {Rdecenas[2:0], Runidades[3]};
            Runidades <= {Runidades[2:0], RIN[N-1]};
            RIN <= RIN << 1;
            if (Contador == 0) state <= ultimo; else state <= opera1;
           end
ultimo: state <= espera;
default: state<= espera;
endcase
endmodule
