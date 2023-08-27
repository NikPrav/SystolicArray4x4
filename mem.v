/*
Author: Nikhil Praveen ((nikhil.pravin@gmail.com))
mem.v (c) 2023
Organisation: Indian Institute of Technology, Hyderabad
Desc: Memory Module 
Modified:  2023-08-27
*/


module DATAMEM (input clk,
                input write_EN,
                input  [15:0] data_in,
                input  [15:0] addr_in,
                input  [15:0] addr_out,
                output  [15:0] data_out
                );
    
    reg [16:0] MEM [255:0];
    integer f;
    
    initial
    // [FIX] reading from text file, move to testbench 
    begin
        // $readmemb("data.txt", MEM);

        f = $fopen("mem_content.txt");
        $fdisplay(f,"time = %d\n", $time, 
        "\tmemory[0] = %b\n", MEM[0],   
        "\tmemory[1] = %b\n", MEM[1],
        "\tmemory[2] = %b\n", MEM[2],
        "\tmemory[3] = %b\n", MEM[3]);
        // $fmonitor(f, "time = %d\n", $time, 
        // "\tmemory[0] = %b\n", MEM[0],   
        // "\tmemory[1] = %b\n", MEM[1],
        // "\tmemory[2] = %b\n", MEM[2],
        // "\tmemory[3] = %b\n", MEM[3],);
        #210;
        $fdisplay(f,"time = %d\n", $time, 
        "\tmemory[0] = %b\n", MEM[0],   
        "\tmemory[1] = %b\n", MEM[1],
        "\tmemory[2] = %b\n", MEM[2],
        "\tmemory[3] = %b\n", MEM[3]);
  $fclose(f);
    end

    always @(posedge clk)
    begin
        // Write if enable
        if (write_EN) begin
            MEM[addr_in] <= data_in;
        end 
        // read always
        
    end
    assign data_out = MEM[addr_out];
    // assign read_data = MEM[read_addr];
    
endmodule