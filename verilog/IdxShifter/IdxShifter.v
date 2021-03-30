/***********************************************************
- Author      : RUIZ QUINTANA, Diego
- Module      : IdxShifter
- Description : This module multiply by 2 the input.  The
					 input is an integer, therefore only a one 
					 shifter is needed.
***********************************************************/

module IdxShifter
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
		end else begin
			y1 <= {x[30:0], 1'b0};
			y  <= y1;
		end
	end

endmodule
