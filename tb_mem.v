module top_module();
    reg clk=0;
    reg write_EN;
    reg [15:0]data_in;
    wire [15:0]data_out1,data_out2,data_out3,data_out4;
    reg [15:0]addr_in;
    reg [15:0]addr_out1,addr_out2,addr_out3,addr_out4;
	always #5 clk = ~clk;  // Create clock with period=10
	// initial `probe_start;   // Start the timing diagram

	// `probe(clk);        // Probe signal "clk"
    
    // cuber cb(.a(a), .y(cube));
    integer i;
    DATAMEM_array dm(
                .clk(clk), 
                .write_EN(write_EN),
                .data_in(data_in),
                .addr_in(addr_in),
                .addr_out1(addr_out1),
                .addr_out2(addr_out2),
                .addr_out3(addr_out3),
                .addr_out4(addr_out4),
                .data_out1(data_out1),
                .data_out2(data_out2),
                .data_out3(data_out3),
                .data_out4(data_out4));

	// A testbench
	initial begin
        for(i=0; i<4; i=i+1) begin
            
        end
        addr_out1 <= 16'b0000000000000001;
        addr_out2 <= 16'b0000000000000010;
        addr_out3 <= 16'b0000000000000011;
        addr_out4 <= 16'b0000000000000000;
        $dumpfile("mem_test.vcd");
        $dumpvars(0,top_module);

		#10 data_in <= 16'b0000000000000001;
        addr_in <= 16'b0000000000000001;
        write_EN <= 1;
        #10 data_in <= 16'b0000000000010010;
        addr_in <= 16'b0000000000000010;
        write_EN <= 1;
        #10 data_in <= 16'b0000000000000010;
        addr_in <= 16'b0000000000000011;
        write_EN <= 1;
        #10 write_EN <= 0;
        addr_in <= 16'b0000000000000001;
        #10 write_EN <= 0;
        addr_in <= 16'b0000000000000001;
        #10 write_EN <= 0;
        addr_in <= 16'b0000000000000010;
		#30 $finish;            // Quit the simulation
	end
endmodule