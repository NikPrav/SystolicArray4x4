// Main Control Unit that interfaces everything
module CU(
    input clk,
    input [15:0] addrA,
    input [15:0] dataA,
    input enA,
    input [15:0] addrB,
    input [15:0] dataB,
    input enB,
    input [15:0] addrI,
    input [15:0] dataI,
    input enI,
    input [15:0] addrO,
    output [15:0] dataO,
    input ap_start,
    output ap_done
);

    
    
    reg ap_done;
    reg enO;
    // reg dataO;       
    reg addrO_in;

    reg PE_en;

    // Inputs to the systolic array
    reg [15:0] r1;
    reg [15:0] r2;
    reg [15:0] r3;
    reg [15:0] r4;

    reg [15:0] c1;
    reg [15:0] c2;
    reg [15:0] c3;
    reg [15:0] c4;

    // Systolic Array interconnects
    // Horizontal
    wire [15:0] or11, or12, or13, or14, or21, or22, or23, or24, or31, or32, or33, or34, or41, or42, or43, or44;
    // Vertical
    wire [15:0] oc11, oc12, oc13, oc14, oc21, oc22, oc23, oc24, oc31, oc32, oc33, oc34, oc41, oc42, oc43, oc44;
    // Outputs
    wire [15:0] o11, o12, o13, o14, o21, o22, o23, o24, o31, o32, o33, o34, o41, o42, o43, o44;

    // Data_in values
    wire [15:0] dataA_out[3:0];
    wire [15:0] dataB_out[3:0];
    reg [15:0] addrA_out[3:0];
    reg [15:0] addrB_out[3:0];
    reg [15:0] addrI_out;
    wire [15:0] dataI_out;
    wire [15:0] dataO_out;
    reg [15:0] addrO_out;

    // Output Array Pointer
    reg [15:0] addrO_ptr;

    // Current state of PE
    reg state;
    reg [15:0] counter, nxt_counter;
    reg [15:0] dataA_Pointer;
    reg [15:0] dataB_Pointer;
    reg mem_buf, reset_buf;

    integer i;
    // Stores A values
    DATAMEM_array bankA(
        .clk(clk),
        .write_EN(enA),
        .data_in(dataA),
        .addr_in(addrA),
        .addr_out1(addrA_out[0]),
        .addr_out2(addrA_out[1]),
        .addr_out3(addrA_out[2]),
        .addr_out4(addrA_out[3]),
        .data_out1(dataA_out[0]),
        .data_out2(dataA_out[1]),
        .data_out3(dataA_out[2]),
        .data_out4(dataA_out[3])
    );

    // Stores B values
    DATAMEM_array bankB(
        .clk(clk),
        .write_EN(enB),
        .data_in(dataB),
        .addr_in(addrB),
        .addr_out1(addrB_out[0]),
        .addr_out2(addrB_out[1]),
        .addr_out3(addrB_out[2]),
        .addr_out4(addrB_out[3]),
        .data_out1(dataB_out[0]),
        .data_out2(dataB_out[1]),
        .data_out3(dataB_out[2]),
        .data_out4(dataB_out[3])
    );

    // Stores Instructions
    DATAMEM bankI(
        .clk(clk),
        .write_EN(enI),
        .data_in(dataI),
        .addr_in(addrI),
        .addr_out(addrI_out),
        .data_out(dataI_out)
    );

    // Stores Output after excecutions
    DATAMEM_output bankO(
        .clk(clk),
        .write_EN(enO),
        .addr_ptr(addrO_ptr),
        .data_in11(o11),
        .data_in12(o12),
        .data_in13(o13),
        .data_in14(o14),
        .data_in21(o21),
        .data_in22(o22),
        .data_in23(o23),
        .data_in24(o24),
        .data_in31(o31),
        .data_in32(o32),
        .data_in33(o33),
        .data_in34(o34),
        .data_in41(o41),
        .data_in42(o42),
        .data_in43(o43),
        .data_in44(o44),
        .data_out(dataO),
        .addr_out(addrO)
    );

    // 4x4 Systolic Array Declaration
    // Row1
    PE block11(clk, PE_en, r1, c1, or11, oc11, o11);
    PE block12(clk, PE_en, or11, c2, or12, oc12, o12);
    PE block13(clk, PE_en, or12, c3, or13, oc13, o13);
    PE block14(clk, PE_en, or13, c4, or14, oc14, o14);
    // Row2
    PE block21(clk, PE_en, r2, oc11, or21, oc21, o21);
    PE block22(clk, PE_en, or21, oc12, or22, oc22, o22);
    PE block23(clk, PE_en, or22, oc13, or23, oc23, o23);
    PE block24(clk, PE_en, or23, oc14, or24, oc24, o24);
    // Row3
    PE block31(clk, PE_en, r3, oc21, or31, oc31, o31);
    PE block32(clk, PE_en, or31, oc22, or32, oc32, o32);
    PE block33(clk, PE_en, or32, oc23, or33, oc33, o33);
    PE block34(clk, PE_en, or33, oc24, or34, oc34, o34);
    // Row4
    PE block41(clk, PE_en, r4, oc31, or41, oc41, o41);
    PE block42(clk, PE_en, or41, oc32, or42, oc42, o42);
    PE block43(clk, PE_en, or42, oc33, or43, oc43, o43);
    PE block44(clk, PE_en, or43, oc34, or44, oc44, o44);

    always @(posedge ap_start) begin
            state <= 0;
            counter <= 16'b0000000000000000;
            nxt_counter <= 16'b0000000000000000;
            addrI_out <= 16'b0000000000000000;
            dataA_Pointer <= 16'b0000000000000000;
            dataB_Pointer <= 16'b0000000000000000;
            PE_en <= 1;
            reset_buf <= 1;
            mem_buf <= 1;
            addrO_ptr <= 0;
    end

    always @(posedge enI) begin
        state <= 0;
    end


    // always @()

    always @(posedge clk) begin
        // Waiting for ap_start
        c1 <= dataA_out[0];
        c2 <= dataA_out[1];
        c3 <= dataA_out[2];
        c4 <= dataA_out[3];
        r1 <= dataB_out[0];
        r2 <= dataB_out[1];
        r3 <= dataB_out[2];
        r4 <= dataB_out[3];
        
        counter <= counter + 1;
        if (reset_buf == 1'b1) begin
                // PE_en <= 0;
                state <= 1;
            end 

        // State check
        if (state == 1'b1) begin
            // c1
            // mem_buf <= 0;
            reset_buf <= 0;
            enO <= 1;
            if (mem_buf == 1'b0) begin
                PE_en <= 0;
                // counter <= 1;
                // state <= 1;
            end 
            // else begin 
            //     counter <= 0;
            // end

            

            if (counter < dataI_out + 1 && counter > 0) begin
                addrA_out[0] = dataA_Pointer + counter - 1;
                // PE_en <= 0;
                mem_buf <= 0;
            end else begin 
                addrA_out[0] = 255;
            end

            //c2
            if (counter < (dataI_out + 2) && counter > 1) begin
                addrA_out[1] = dataA_Pointer + counter - 2 + dataI_out*1;
            end else begin 
                addrA_out[1] = 255;
            end

            //c3
            if (counter < (dataI_out + 3) && counter > 2) begin
                addrA_out[2] = dataA_Pointer + counter - 3 + dataI_out*2;
            end else begin 
                addrA_out[2] = 255;
            end

            // c4
            if (counter < (dataI_out + 4) && counter > 3) begin
                addrA_out[3] = dataA_Pointer + counter - 4 + dataI_out*3;
            end else begin 
                addrA_out[3] = 255;
            end

            // r1
            if (counter < dataI_out + 1 && counter > 0) begin
                addrB_out[0] = dataB_Pointer + (counter - 1)*4;
            end else begin 
                addrB_out[0] = 255;
            end

            //r2
            if (counter < (dataI_out + 2) && counter > 1) begin
                addrB_out[1] = dataB_Pointer + (counter - 2)*4 + 1;
            end else begin 
                addrB_out[1] = 255;
            end

            //r3
            if (counter < (dataI_out + 3) && counter > 2) begin
                addrB_out[2] = dataB_Pointer + (counter - 3)*4 + 2;
            end else begin 
                addrB_out[2] = 255;
            end

            //r4
            if (counter < (dataI_out + 4) && counter > 3) begin
                addrB_out[3] = dataB_Pointer + (counter - 4)*4 + 3;
            end else begin 
                addrB_out[3] = 255;
            end

            // nxt_counter <= counter + 1;

            // End condition for Instruction Excecution
            if (counter == (dataI_out + 4)) begin
                state <= 1'b0;
                
                for(i=0;i<4;++i) begin
                    addrA_out[i] = 255;
                    addrB_out[i] = 255;
                end
            end

            
        end

        if (counter == (dataI_out + 9)) begin
            addrI_out <= addrI_out + 1;
            // [TODO] Change to shift operator
            addrO_ptr <= addrO_ptr + 16;
            dataA_Pointer <= dataA_Pointer + dataI_out*4;
            dataB_Pointer <= dataB_Pointer + dataI_out*4;
            state <= 0;
            counter <= 16'b0000000000000000;
            nxt_counter <= 16'b0000000000000000;
            PE_en <= 1;
            reset_buf <= 1;
            mem_buf <= 1;
        end

        if (dataI_out == 0) begin 
            ap_done <= 1;
        end
    end
        
    // always @(posedge counter) begin
    //     if (counter > dataI_out + 2) begin
    //         dataA_Pointer <= dataA_Pointer + dataI_out*4;
    //         dataB_Pointer <= dataB_Pointer + dataI_out*4;
    //         nxt_counter <= 0;
    //         addrI_out <= addrI_out + 1;
    //     end
    // end
        



    
endmodule