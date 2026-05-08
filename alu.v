`timescale 1ns / 1ps

module alu (
    input  wire [3:0]  alu_sel,
    input  wire [31:0] operand_a,
    input  wire [31:0] operand_b,
    output reg  [31:0] result
);

    always @(*) begin
        case (alu_sel)
            4'b0000: result = operand_a + operand_b; // ADD
            4'b0001: result = operand_a - operand_b; // SUB
            default: result = 32'b0;
        endcase
    end

endmodule