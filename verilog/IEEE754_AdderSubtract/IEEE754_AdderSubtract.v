/**************************************************************
- Author      : RUIZ QUINTANA, Diego
- Module      : IEEE754_AdderSubtract
- Description : This module calculates IEEE-754 addition-sub-
					 traction of two signed numbers. The input and 
					 output is in IEEE-754. No rounding mode is set. 
					 Work's well with results smaller than 10e3 in 
					 order to preserve the max error below than 
					 1e-4.
**************************************************************/
module IEEE754_AdderSubtract
(
	input clock,
	input resetn,
	input [31:0] a,
	input [31:0] b,
	output reg [31:0] y
);

	wire mode, sign;
	wire [7:0]  exp_g;
	wire [23:0] mnts_g;
	wire [47:0] mnts_shift; 

	ControlLogic _ControlLogic (a, b, mode, sign, exp_g, mnts_g, mnts_shift);
	
	wire [30:0] adder_result;
	Adder _Adder (exp_g, mnts_g, mnts_shift[47:23], adder_result);
	
	wire [30:0] subtract_result;
	Subtract _Subtract (exp_g, mnts_g, mnts_shift[47:23], subtract_result);
	
	wire [30:0] result;
	assign result = mode ? adder_result : subtract_result;
	
	// Register the signals to set a pipelined design
	reg [31:0] y1;
	always @(posedge clock) 
	begin
		if (!resetn) begin
			y1 <= 32'h00000000;
			y  <= 32'h00000000;
		end else begin
			y1 <= {sign, result};
			y  <= y1;
		end
	end
	
endmodule

module ControlLogic
(
	input  [31:0] a,
	input  [31:0] b,
	output mode,
	output sign,
	output [7:0]  exp_g,
	output [23:0] mnts_g,
	output [47:0] mnts_shift
);

	// Wires for signs
	wire sign_a, sign_b;

	// Wires for exponents
	wire [7:0]  exp_a, exp_b;
	// Wires for greatest and less exponent
	wire [7:0]  exp_l;
	
	// Wires for mantissas
	wire [22:0] mnts_a, mnts_b;
	// Wires for greatest and less mantissas
	wire [23:0] mnts_l;
	
	// Get the signs
	assign sign_a = a[31];
	assign sign_b = b[31];
	
	// Get the exponents
	assign exp_a = a[30:23];
	assign exp_b = b[30:23];
	
	// Get the mantissas
	assign mnts_a = a[22:0];
	assign mnts_b = b[22:0];
	
	// Signals to set the greater exponent and manstissa
	wire greater_exp;
	
	// Set the signal for greater mantissa and exponent
	assign greater_exp  = (exp_b >= exp_a) ? 1'b1 : 1'b0;
	
	// Set the the greatest and less exponent
	assign exp_g = greater_exp ? exp_b : exp_a;
	assign exp_l = greater_exp ? exp_a : exp_b;
	
	// Set the the greatest and less mantissa with the hidden bit
	assign mnts_g = greater_exp ? {1'b1, mnts_b} : {1'b1, mnts_a};
	assign mnts_l = greater_exp ? {1'b1, mnts_a} : {1'b1, mnts_b};
	
	// Wire for shifted mantissa in order to align it
	// wire [47:0] mnts_shift;
	
	// Wire for shift
	wire [7:0] shift;
	assign shift = exp_g - exp_l;
	
	// Get the shift for mantissa from a ROM in order to 
	// avoid the barrel shifter: if a barrel shifter is
	// used, then the number of ALM's is 50. Else if the
	// dynamic shifter is acomplished via fixed point 
	// multiplication, then only 1 ALM is needed, but a 1
	// DSP is also needed.
	wire [23:0] shift_mult_, shift_mult;
	ROM_shift ROM_shift_(shift[4:0], shift_mult_);
	
	assign shift_mult = shift < 32 ? shift_mult_ : 24'b000000000000000000000001;
	
	// Shifts the mantissa via fixed point multiplication
	assign mnts_shift = mnts_l * shift_mult;
	
	// wire mode;
	assign mode = (sign_a == sign_b) ? 1'b1 : 1'b0;
	
	wire greater;
	assign greater = (a[30:0] >= b[30:0]) ? sign_a : sign_b;
	
	assign sign = mode ? sign_a : greater;

endmodule

module Adder
(
	input  [7:0]  exp_g,
	input  [23:0] mnts_g, 
	input  [24:0] mnts_shift,
	output [30:0] result
);

	// Add the mantissas
	wire signed [24:0] mnts;
	assign mnts = mnts_shift + mnts_g;
	
	// Normalization bit
	wire nrm_bit = mnts[24];
	
	// Normalize the exponent addign the nrm_bit
	wire [7:0] exp;
	assign exp = exp_g + nrm_bit;
	
	// Normalize the mantissa shifting it
	wire [22:0] mnts_res;
	assign mnts_res = nrm_bit ? mnts[23:1] : mnts[22:0];

	// Concatenate exponent and mantissa
	assign result = {exp, mnts_res};
	
endmodule

module Subtract
(
	input  [7:0]  exp_g,
	input  [23:0] mnts_g, 
	input  [24:0] mnts_shift,
	output [30:0] result
);

	// Subtract the mantissas
	wire [23:0] mnts;
	assign mnts = (mnts_g >= mnts_shift) ? mnts_g - mnts_shift : mnts_shift - mnts_g;
	
	// How many left shifts are needed? The answer is via a CLZ
	wire [4:0] shift_left;
	CLZ_24bits _CLZ_24bits(mnts, shift_left);
	
	// Normalize the mantissa shifting it
	wire [23:0] mnts_norm;
	assign mnts_norm = mnts << shift_left;
	
	// Normalize the exponent subtracting shift_left
	wire [7:0] exp_norm;
	assign exp_norm = exp_g - shift_left;
	
	// Concatenate exponent and mantissa
	assign result = {exp_norm, mnts_norm[22:0]};

endmodule

// This module has been created via the following paper:
// Journal of ELECTRICAL ENGINEERING, VOL. 66, NO. 6, 2015, 329–333
module CLZ_24bits
(
	input [23:0] X,
	output unsigned [4:0] Y
);

	wire unsigned [11:0] p;
	wire unsigned [5:0]  v_clz4b;
	wire unsigned [2:0]  y_bne;
	wire unsigned [1:0]  y_mux;
	wire unsigned Q;
	
	priority_encoder_4b pe8(X[3:0],   p[11:10], v_clz4b[5]); // Priority encoder 4 bits for X[31:28]
	priority_encoder_4b pe7(X[7:4],   p[9:8],   v_clz4b[4]); // Priority encoder 4 bits for X[27:24]
	priority_encoder_4b pe6(X[11:8],  p[7:6],   v_clz4b[3]); // Priority encoder 4 bits for X[23:20]
	priority_encoder_4b pe5(X[15:12], p[5:4],   v_clz4b[2]); // Priority encoder 4 bits for X[19:16]
	priority_encoder_4b pe4(X[19:16], p[3:2],   v_clz4b[1]); // Priority encoder 4 bits for X[15:12]
	priority_encoder_4b pe3(X[23:20], p[1:0],   v_clz4b[0]); // Priority encoder 4 bits for X[11:8]
	
	BNE BNE_(v_clz4b, y_bne, Q);
	
	mux_282 mux_282_(y_bne, p, y_mux);
	
	assign Y = {y_bne, y_mux};
	
endmodule

module priority_encoder_4b
(
	input [3:0] X,
	output[1:0] Y,
	output v
);

	wire unsigned [1:0]Out_;
	wire unsigned v_;
	
	reg unsigned [1:0] Out;
	reg unsigned v_reg;
	
	assign Out_[0] = X[3] || (~X[2] && X[1]);
	assign Out_[1] = X[3] || X[2];
	assign v_ = X[3] || X[2] || X[0] || X[1];
	
	assign Y = ~Out_;
	assign v = ~v_;
	
endmodule

module BNE
(
	input unsigned [5:0] a,
	output unsigned[2:0] y,
	output unsigned Q
);
	assign Q = a[0] && a[1] && a[2] && a[3] &&
				  a[4] && a[5]; 
	
	assign y[0] = (a[0] && (~a[1] || (a[2] && ~a[3]))) || 
					  (a[0] && a[2] && a[4]);
	
	assign y[1] = a[0] && a[1] && (~a[2] || ~a[3] || (a[4] && a[5]));
	
	assign y[2] = a[0] && a[1] && a[2] && a[3];

endmodule


module mux_282
(
	input  unsigned [2:0]  S,
	input  unsigned [11:0] X,
	output reg unsigned [1:0]  Y	
);

	wire unsigned[1:0] Y_;
	always @(*) begin
		case(S)
			3'b000:  Y <= X[1:0];
			3'b001:  Y <= X[3:2];
			3'b010:  Y <= X[5:4];
			3'b011:  Y <= X[7:6];
			3'b100:  Y <= X[9:8];
			3'b101:  Y <= X[11:10];
			default: Y <= 2'b00;
		endcase
	end
endmodule
