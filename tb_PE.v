module top_module();
    reg clk=0;
    reg EN=1;
    wire [15:0]A1;
    wire [15:0]B1;
    wire [15:0]C1;
    reg [15:0]A = 4'b0;
    reg [15:0]B = 4'b0;
    reg [15:0]C = 4'b0;

	always #5 clk = ~clk;  // Create clock with period=10
	// initial `probe_start;   // Start the timing diagram

	// `probe(clk);        // Probe signal "clk"
    
    // cuber cb(.a(a), .y(cube));
    PE process_elem(.EN(EN),
                    .clk(clk), 
                    .A(A),
                    .B(B),
                    .C(C),
                    .A1(A1),
                    .B1(B1),
                    .C1(C1));

	// A testbench
	initial begin
        $dumpfile("PC_test.vcd");
        $dumpvars(0,top_module);

		#10 A <= 16'b0000000000000001;
        B <= 16'b0000000000000001;
        C <= 16'b0000000000000001;
        #10 A <= 16'b0000000000000010;
        B <= 16'b0000000000000001;
        C <= 16'b0000000001000000;
        #10 A <= 16'b0000000000000010;
        B <= 16'b0000000000000010;
        C <= 16'b0000000000000001;
		#30 $finish;            // Quit the simulation
	end
endmodule