module top_module();
    reg clk=0;
    reg EN=1;
    reg enA;
    reg enB;
    reg enI;
    reg ap_start;
    reg [15:0]addrA;
    reg [15:0]dataA;
    reg [15:0]addrB;
    reg [15:0]dataB;
    reg [15:0]addrI;
    reg [15:0]dataI;
    reg [15:0]addrO;
    reg [15:0]A = 4'b0;
    reg [15:0]B = 4'b0;
    reg [15:0]C = 4'b0;
    wire [15:0]dataO;
    wire ap_done;

	always #5 clk = ~clk;  // Create clock with period=10
	// initial `probe_start;   // Start the timing diagram

	// `probe(clk);        // Probe signal "clk"
    
    // cuber cb(.a(a), .y(cube));
    CU main_unit(clk, addrA, dataA, enA, addrB, dataB, enB, addrI, dataI, enI, addrO, dataO, ap_start, ap_done);

    reg [15:0]MEMA [0:255];
    reg [15:0]MEMB [0:255];
    reg [15:0]MEMI [0:255];
    reg [15:0]MEMO [0:255];
    integer i,f;
	// A testbench
    initial begin
        $readmemb("dataA.txt", MEMA);
        $readmemb("dataB.txt", MEMB);
        $readmemb("dataI.txt", MEMI);
    end

	initial begin
       
    // [FIX] reading from text file, move to testbench 
   
        // $readmemb("data.txt", MEM);

        f = $fopen("mem_content.txt");
        $fdisplay(f,"time = %d\n", $time, 
        "\tmemory0[0] = %b\n", MEMA[0],   
        "\tmemory[1] = %b\n", MEMA[1],
        "\tmemory[2] = %b\n", MEMA[2],
        "\tmemory[3] = %b\n", MEMA[3]);
        // $fmonitor(f, "time = %d\n", $time, 
        // "\tmemory[0] = %b\n", MEM[0],   
        // "\tmemory[1] = %b\n", MEM[1],
        // "\tmemory[2] = %b\n", MEM[2],
        // "\tmemory[3] = %b\n", MEM[3],);
        #210;
        $fdisplay(f,"time = %d\n", $time, 
        "\tmemory[0] = %b\n", MEMA[0],   
        "\tmemory[1] = %b\n", MEMA[1],
        "\tmemory[2] = %b\n", MEMA[2],
        "\tmemory[3] = %b\n", MEMA[3]);
        $fclose(f);
    
        $dumpfile("PC_test.vcd");
        $dumpvars(0,top_module);
        
        // Initialising
        enA <= 1;
        enB <= 1;
        enI <= 1;
        addrO <= 0;
		for(i=0; i<256; i++) begin
            #10 dataA <= MEMA[i];
            dataB <= MEMB[i];
            dataI <= MEMI[i];
            addrA <= i;
            addrB <= i;
            addrI <= i;
        end
        #10
        enA <= 0;
        enB <= 0;
        enI <= 0;
        // Sending Start
        #12 ap_start <= 1;
        #400
        addrO <= 0;

        for(i=0; i<256; i++) begin
            #10 MEMO[i] <= dataO;
            addrO <= i + 1;
        end
        $writememb("dataO_sim.txt", MEMO);
        #500

        

        
        
		#400 $finish;            // Quit the simulation
	end

    always @(posedge ap_done) begin 
        addrO <= 0;

        for(i=0; i<256; i++) begin
            #10 MEMO[i] <= dataO;
            addrO <= i + 1;
        end
        $writememb("dataO_sim.txt", MEMO);
        
    end
endmodule