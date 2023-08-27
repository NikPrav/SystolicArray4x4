module PE(
    input clk,
    input rst,
    // input signals
    input [15:0] A,
    input [15:0] B,
    // output signals
    output reg [15:0] A1,
    output reg [15:0] B1,
    output reg [15:0] C1
);
    wire [15:0] prd;
    
    always @(posedge clk or posedge rst)
    begin
        // Reset memory
        if (rst) begin
            A1 <= 0;
            B1 <= 0;
            C1 <= 0;
        end else begin
        // Compute
            // MAC operation
            C1 <= C1 + prd;
            // Forwarding inputs
            A1 <= A;
            B1 <= B;
        end
    end
    assign prd = A*B;
endmodule