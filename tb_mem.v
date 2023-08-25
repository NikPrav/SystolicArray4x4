module top_module();
    reg clk=0;
    reg write_EN;
    reg [15:0]data_in;
    wire [15:0]data_out;
    reg [15:0]addr_in;

	always #5 clk = ~clk;  // Create clock with period=10
	// initial `probe_start;   // Start the timing diagram

	// `probe(clk);        // Probe signal "clk"
    
    // cuber cb(.a(a), .y(cube));
    datamem dm(
                .clk(clk), 
                .write_EN(write_EN),
                .data_in(data_in),
                .addr_in(addr_in),
                .data_out(data_out));

	// A testbench
	initial begin
        $dumpfile("mem_test.vcd");
        $dumpvars(0,top_module);

		#10 data_in <= 16'b0000000000000001;
        addr_in <= 16'b0000000000000001;
        write_EN <= 1;
        #10 data_in <= 16'b0000000000010010;
        addr_in <= 16'b0000000000000010;
        write_EN <= 1;
        #10 data_in <= 16'b0000000000000010;
        addr_in <= 16'b0000000000000101;
        write_EN <= 1;
        #10 write_EN <= 0;
        addr_in <= 16'b0000000000000001;
        #10 write_EN <= 0;
        addr_in <= 16'b0000000000000101;
        #10 write_EN <= 0;
        addr_in <= 16'b0000000000000010;
		#30 $finish;            // Quit the simulation
	end
endmodule