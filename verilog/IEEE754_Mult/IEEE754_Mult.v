/**************************************************************
- Author      : RUIZ QUINTANA, Diego
- Module      : IEEE754_Mult
- Description : This module calculates IEEE-754 multiplication
					 of two signed numbers. The input and output is
					 in IEEE-754.  No rounding mode  is set. Work's 
					 well with results  smaller than 10e3  in order 
					 to preserve the max error below than 1e-4
**************************************************************/

module IEEE754_Mult
(
	input clock,
	input resetn,
	input [31:0] a,
	input [31:0] b,
	output reg [31:0] y
);

	// Compute the sign
	wire sign;
	assign sign = (a[31] ^ b[31]);
	
	// Compute the exponent
	wire [7:0] exp_;
	assign exp_ = (a[30:23] + b[30:23]) + 8'b10000001;
	
	// Get the mantissas with the hidden bit
	wire [23:0] mnts_a, mnts_b;
	assign mnts_a = {1'b1, a[22:0]};
	assign mnts_b = {1'b1, b[22:0]};
	
	// Compute the mantissa
	wire [47:0] mnts_;
	assign mnts_ = (mnts_a * mnts_b);
	
	// Get the MSB from the computed mantissa
	wire signed [24:0] mnts;
	assign mnts = mnts_[47:23];
	
	// Get the normalize bit
	wire nrm_bit = mnts[24];
	
	// Compute the exponent with normalization
	wire [7:0] exp;
	assign exp = exp_ + nrm_bit;
	
	// Compute the mantissa with normalization
	wire [22:0] mnts_res;
	assign mnts_res = nrm_bit ? mnts[23:1] : mnts[22:0];
	
	// Register the signals to set a pipelined design
	reg [31:0] y1;
	always @(posedge clock) 
	begin
		// Negedge reset signal 
		if (!resetn) begin
			y1 <= 32'h00000000;
			y <= 32'h00000000;
		end else begin
			// If a or b are zero
			if (a == 32'h00000000 || b == 32'h00000000) begin
				y1 <= 32'h00000000;
			end else begin
				y1 <= {sign, exp, mnts_res};
			end
			// Final result
			y <= y1;
		end
	end

endmodule
