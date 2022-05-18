`timescale 1ns / 1ps

module restador(init, clk, portA, portB, resta);
	input init, clk;
	input [3:0] portA;
	input [3:0] portB;
	output [7:0] resta;
	
	//registros
	reg [3:0] A, B, r;
	
	assign resta = r;
	
	//DATAPATH
	always @(posedge clk) begin
		A = portA;
		B = portB;
	
		if(A < B) begin		
			A[0] = (A[0] == 1'b1) ? 0 : 1;
			A[1] = (A[1] == 1'b1) ? 0 : 1;
			A[2] = (A[2] == 1'b1) ? 0 : 1;
			A[3] = (A[3] == 1'b1) ? 0 : 1;
			
			A = A + 4'b0001;
			r = A + B;
			
		end else if(A == B) begin
			r = 3'b0000;
		end
		
		else if(A > B) begin
			B[0] = (B[0] == 1'b1) ? 0 : 1;
			B[1] = (B[1] == 1'b1) ? 0 : 1;
			B[2] = (B[2] == 1'b1) ? 0 : 1;
			B[3] = (B[3] == 1'b1) ? 0 : 1;
			
			B = B + 4'b0001;
			r = A + B;	
		end
	end	

endmodule
