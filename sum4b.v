`timescale 1ns / 1ps

module sum4b(init, xi, yi,co, sum);

  input init;
  input [3 :0] xi;
  input [3 :0] yi;
  output co;
  output [7 :0] sum;
  
  
  wire [7:0] st;
  assign sum= st[7:0];

  assign st  = 	xi+yi;

endmodule
