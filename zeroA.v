`timescale 1ns / 1ps


module rshiftAB(init, portA, portB,co, rshift);

  input init;
  input [3 :0] portA;
  input [3 :0] portB;
  output co;
  output [7 :0] rshift;
  
  
  wire [7:0] st;
  assign rshift= st[7:0];

  assign st  = 	portA>>portB;

endmodule
