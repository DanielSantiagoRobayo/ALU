`timescale 1ns / 1ps

module divisor(input init,
					input [3:0] divendo,
					input [3:0] divsor,
					input clk,
					output reg [3:0] cociente,
					output reg done
					);

reg [3:0] A, B;     //residuo, divisor
reg [3:0] n;		//cuenta restas - cociente
reg [2:0] status;
reg resta, reset;
reg contar;

wire count, error;
assign count = (B <= A)?1:0;
assign error = (B == 4'b0000)?1:0;


//DATAPATH
always @(negedge clk)begin
    if(reset) begin
		A = divendo[3:0];
		B = divsor[3:0];
		n = 0;
	end else if (resta) begin
			A = A - B;
	end
	
	if (contar && count) begin
			n = n + 1;
	end
end

//Bloque valor final
always @(negedge clk) begin
	if (done) begin
	   if (error) begin
	       cociente = 4'b1110; //e - error
	   end else begin
	       cociente = n;
	   end
	end
end

//FMS
parameter START = 0, CHECK = 1,RESTA = 2, END = 3;
always @(posedge clk) begin
	case(status)
		START: begin
			resta <= 0;
			contar <= 0;
			if(init) begin
				done <= 0;
				reset <= 1;
				status <= CHECK;
			end
		end

		CHECK : begin
			resta <= 0;
			done <= 0;
			reset <= 0;
			if (error) begin
                contar <= 0;
				status <= END;
            end else if (count)begin
                contar <= 1;
				status <= RESTA;
			end else begin
			    contar <= 0;
				status <= END;
			end
		end
		
		RESTA: begin
			resta <= 1;
			contar <= 0;
			done <= 0;
			reset <= 0;
			status <= CHECK;
		end
		
		END: begin
			resta <= 0;
			contar <= 0;
			done <= 1;
			reset <= 0;
			status <= START;			
		end
		
		default: status <= START;
	endcase
end

endmodule