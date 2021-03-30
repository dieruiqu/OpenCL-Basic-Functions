/***********************************************************
- Author      : RUIZ QUINTANA, Diego
- Module      : ReLU
- Description : This module calculates the ReLU function:
					 if (x <  0) --> Output equal to zero
					 if (x != 0) --> Output equal to x
***********************************************************/
module ReLU
(
	input clock,
	input resetn,
	input [31:0] x,
	output reg [31:0] y
);

	reg [31:0] y1;
	always @(posedge clock) 
	begin
		if (!resetn) begin
			y1 <= 32'h00000000;
			y  <= 32'h00000000;
		end else if (x[31] == 1'b0) begin
			y1 <= x;
			y  <= y1;
		end else begin
			y1 <= 32'h00000000;
			y  <= y1;
		end
	end

endmodule
