`timescale 1ns / 1ps

module alu(
    input [3:0] portA,
    input [3:0] portB,
    input [2:0] opcode,
    output [6:0] sseg,
    output [7:0] an,
	output doneM,
	output doneD,
    input clk,
    input rst
 );

 //PROVISIONAL

 
// Declaración de salidas de cada bloque 
wire [7:0] sal_suma;
wire [7:0] sal_resta;
wire [3:0] sal_div;
wire [7:0] sal_mult;
wire [7:0] sal_rshiftAB;
wire [7:0] sal_lshiftAB;
wire [7:0] sal_zeroA;
wire [7:0] sal_zeroB;

// Declaración de las entradas init de cada bloque 
reg [7:0] init; 
wire init_suma;
wire init_resta;
wire init_mult;
wire init_div;
wire init_rshiftAB;
wire init_lshiftAB;
wire init_zeroA;
wire init_zeroB;

// 
assign init_suma	= init[0];
assign init_resta	= init[1];
assign init_mult	= init[2];
assign init_div	= init[3];
assign init_rshiftAB = init[4];
assign init_lshiftAB = init[5];
assign init_zeroA = init[6];
assign init_zeroB = init[7];

reg [15:0]int_bcd;

wire [3:0] operacion;


// descripción del decodificacion de operaciones
always @(*) begin
	case(opcode) 
		3'b000: init <=1;
		3'b001: init <=2;
		3'b010: init <=4;
		3'b011: init <=8;
		3'b100: init <=16;
		3'b101: init <=32;
		3'b110: init <=64;
		3'b111: init <=128;
	default:
		init <= 0;
	endcase
	
end
// Descripción del multiplexor
always @(*) begin
	case(opcode) 
		3'b000: int_bcd <= {8'b000,sal_suma};
		3'b001: int_bcd <= {8'b000,sal_resta};
		3'b010: int_bcd <= {8'b000,sal_mult};
		3'b011: int_bcd <= {8'b000,sal_div};
		3'b100: int_bcd <= {8'b000,sal_rshiftAB};
		3'b101: int_bcd <= {8'b000,sal_lshiftAB};
		3'b110: int_bcd <= {8'b000,sal_zeroA};
		3'b111: int_bcd <= {8'b000,sal_zeroB};
	default:
		int_bcd <= 0;
	endcase
	
end


//instanciación de los componentes

sum4b			sum(.init(init_suma), .xi({portA}), .yi({portB}),.sum(sal_suma));
restador		res(.clk(clk), .portA({portA}), .portB({portB}), .resta(sal_resta));
multiplicador	mul(.init(init_mult), .MA({portA}), .MB({portB}), .clk(clk), .producto(sal_mult), .done(doneM));
divisor			div(.init(init_div), .divendo({portA}),.divsor({portB}), .clk(clk), .cociente(sal_div), .done(doneD));
rshiftAB		rshiftAB(.init(init_rshiftAB), .portA({portA}), .portB({portB}), .rshiftAB(sal_rshiftAB));
lshiftAB		lshiftAB(.init(init_lshiftAB), .portA({portA}), .portB({portB}), .lshiftAB(sal_lshiftAB));
zeroA		zeroA(.init(init_zeroA), .portA({portA}), .portB({portB}), .zeroA(sal_zeroA));
zeroB		zeroB(.init(init_zeroB), .portA({portA}), .portB({portB}), .zeroB(sal_zeroB));
display			disp(.num(int_bcd), .clk(clk), .sseg(sseg), .an(an), .rst(rst));
endmodule
