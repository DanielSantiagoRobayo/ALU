`timescale 1ns / 1ps


module multiplicador( input init,
							 input [3:0] MA, 
							 input [3:0] MB,
							 input clk,
							 output reg [7:0] producto,
							 output reg done
    );

reg sh;
reg rst;
reg add;
reg [6:0] A;
reg [3:0] B;
reg [2:0] status;
wire z;

//Eliminar despues
reg [7:0] pp;


//initial begin
//status =0;
//end

// bloque comparador 
assign z = (B==0)?1:0;

//DATAPATH
//bloques de registros de desplazamiento para A y B
always @(negedge clk) begin   
	if (rst) begin
		A = {3'b000, MA};
		B = MB;
	end
	else	begin 
		if (sh) begin
			A = A << 1;
			B = B >> 1;
		end
	end
end 

//bloque de add pp
always @(negedge clk) begin   
	if (rst) begin
		pp = 0;
	end
	else	begin 
		if (add) begin
			pp = pp + A;
		end
	end
end

//registro del valor final
always @(negedge clk) begin
	if (done) begin
		producto[7:0] = pp[7:0];
	end
end 

//FMS - Controlador 
parameter START = 0,  CHECK = 1, ADD = 2, SHIFT = 3, END1 = 4;

always @(posedge clk) begin
	case (status)
	START: begin
		sh	<= 0;
		add	<= 0;
		if (init) begin
			status	<= CHECK;
			done	<= 0;
			rst		<= 1;
		end
		end
	CHECK: begin 
		done	<= 0;
		rst		<= 0;
		sh		<= 0;
		add		<= 0;
		if (B[0]==1)
			status	<=ADD;
		else
			status	<=SHIFT;
		end
	ADD: begin
		done	<= 0;
		rst		<= 0;
		sh		<= 0;
		add		<= 1;
		status	<= SHIFT;
		end
	SHIFT: begin
		done	<= 0;
		rst		<= 0;
		sh		<= 1;
		add		<= 0;
		if (z==1)
			status	<= END1;
		else
			status	<= CHECK;
		end
	END1: begin
		done	<= 1;
		rst		<= 0;
		sh		<= 0;
		add		<= 0;
		status	<= START;
	end
	 default:
		status	<= START;
	endcase	
end	

endmodule
