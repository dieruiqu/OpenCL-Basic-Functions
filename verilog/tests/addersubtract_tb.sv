


module addersubtract_tb;

	// CLK scale units
	timeunit 1ns;

	integer delay = 3;

	reg clock;
	reg resetn;
	real a, b;
	reg signed[31:0] y;

	real gold, fpga, error, mse;
	real value_a, value_b;
	integer seed;
	integer f_bits = 18;

	// Init declaration of signals
	initial begin
		clock  = 1;
		resetn = 0;
		#40;
		resetn = 1;
	end

	// CLK declaration always 5 ns
	always 
		#5 clock =! clock;

	
	// Task to set values from -5 to 5 with 
	// 16 fractional bits
	task set_values; 
	begin
		seed = $random;
		a = $itor($dist_normal(seed, 0*(2**f_bits), 100*(2**f_bits))) / (2**(f_bits+0));
		// if (a < 0)
			// a = -a;

		seed = $random;
		b = $itor($dist_normal(seed, 0*(2**f_bits), 100*(2**f_bits))) / (2**(f_bits+0));
		// if (b < 0)
			// b = -b;
	end
	endtask
	
	
	always @(a, b)
	begin
		value_a <= repeat(delay) @(posedge clock) a;
		value_b <= repeat(delay) @(posedge clock) b;
		error <= fpga - gold;
		fpga = $bitstoshortreal(y);
		gold <= repeat(delay) @(posedge clock) a + b;


		/*
		assertion1 : assert (abs_error < 50e-4)
			else $display("Absolute Error > 50e-6: %e", abs_error);
		*/
	end
	

	// Always a positive edge of clock, the X
	// value is update
	always @(posedge clock)
	begin
		if (resetn == 0) begin
			a = 0.0;
			b = 0.0;
		end	else begin
			set_values();
		end
	end

	IEEE754_AdderSubtract _IEEE754_AdderSubtract
	(
		.clock  (clock),
		.resetn (resetn),
		.a ($shortrealtobits(a)),
		.b ($shortrealtobits(b)),
		.y (y)
	);

endmodule