module ROM_shift
(
	input [4:0] addr,
	// input clock,
	output reg [23:0] q
);

	reg [23:0] rom[31:0];
	
	// Read the memory contents in the file dual_port_rom_init.txt.
	initial 
	begin
		$readmemb("ROM_shift_init.txt", rom);
	end
	
	// Assign values in the positive edge of the clock
	always @ (addr)
	begin
		q <= rom[addr];
	end
endmodule