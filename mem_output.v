/*
Author: Nikhil Praveen ((nikhil.pravin@gmail.com))
mem_output.v (c) 2023
Organisation: Indian Institute of Technology, Hyderabad
Desc: Memory Module to store output from PE
Modified:  2023-08-27
*/


module DATAMEM_output (input clk,
                input write_EN,
                input [15:0] addr_ptr,
                input  [15:0] data_in11,
                input  [15:0] data_in12,
                input  [15:0] data_in13,
                input  [15:0] data_in14,
                input  [15:0] data_in21,
                input  [15:0] data_in22,
                input  [15:0] data_in23,
                input  [15:0] data_in24,
                input  [15:0] data_in31,
                input  [15:0] data_in32,
                input  [15:0] data_in33,
                input  [15:0] data_in34,
                input  [15:0] data_in41,
                input  [15:0] data_in42,
                input  [15:0] data_in43,
                input  [15:0] data_in44,
                input  [15:0] addr_out,
                output  [15:0] data_out
                );
    
    reg [15:0] MEM [255:0];
    integer f;   
    initial
    // [FIX] reading from text file, move to testbench 
    begin
        // $readmemb("data.txt", MEM);

        f = $fopen("mem_content_output.txt");
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
        #2900;
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
            MEM[0 + addr_ptr] <= data_in11;
            MEM[1 + addr_ptr] <= data_in21;
            MEM[2 + addr_ptr] <= data_in31;
            MEM[3 + addr_ptr] <= data_in41;
            MEM[4 + addr_ptr] <= data_in12;
            MEM[5 + addr_ptr] <= data_in22;
            MEM[6 + addr_ptr] <= data_in32;
            MEM[7 + addr_ptr] <= data_in42;
            MEM[8 + addr_ptr] <= data_in13;
            MEM[9 + addr_ptr] <= data_in23;
            MEM[10 + addr_ptr] <= data_in33;
            MEM[11 + addr_ptr] <= data_in43;
            MEM[12 + addr_ptr] <= data_in14;
            MEM[13 + addr_ptr] <= data_in24;
            MEM[14 + addr_ptr] <= data_in34;
            MEM[15 + addr_ptr] <= data_in44;
        end 
        // read always
        
    end

    assign data_out = MEM[addr_out];
    // assign read_data = MEM[read_addr];
    
endmodule