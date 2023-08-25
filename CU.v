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
    output ap_done,
);

    wire [15:0] dataA_out;
    wire [15:0] dataB_out;
    wire [15:0] dataI_out;

    reg enO;
    reg dataO;
    reg addrO_in;

    reg PE_en;

    // Inputs to the systolic array
    wire [15:0] r1;
    wire [15:0] r2;
    wire [15:0] r3;
    wire [15:0] r4;

    wire [15:0] c1;
    wire [15:0] c2;
    wire [15:0] c3;
    wire [15:0] c4;

    // Systolic Array interconnects
    // Horizontal
    wire [15:0] or11, or12, or13, or14, or21, or22, or23, or24, or31, or32, or33, or34, or41, or42, or43, or44;
    // Vertical
    wire [15:0] oc11, oc12, oc13, oc14, oc21, oc22, oc23, oc24, oc31, oc32, oc33, oc34, oc41, oc42, oc43, oc44;
    // Outputs
    wire [15:0] o11, o12, o13, o14, o21, o22, o23, o24, o31, o32, o33, o34, o41, o42, o43, o44;

    // Stores A values
    DATAMEM bankA(
        .clk(clk),
        .write_EN(enA),
        .data_in(dataA),
        .addr_in(addrA),
        .data_out(dataA_out)
    );

    // Stores B values
    DATAMEM bankB(
        .clk(clk),
        .write_EN(enB),
        .data_in(dataB),
        .addr_in(addrB),
        .data_out(dataB_out)
    );

    // Stores Instructions
    DATAMEM bankI(
        .clk(clk),
        .write_EN(enI),
        .data_in(dataI),
        .addr_in(addrI),
        .data_out(dataI_out)
    );

    // Stores Output after excecutions
    DATAMEM bankO(
        .clk(clk),
        .write_EN(enO),
        .data_in(dataO),
        .addr_in(addrO_in),
        .data_out(dataO_out)
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

    
endmodule