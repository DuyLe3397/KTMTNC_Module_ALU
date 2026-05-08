`timescale 1ns / 1ps

module alu (
    input  wire [3:0]  alu_sel,
    input  wire [31:0] operand_a,
    input  wire [31:0] operand_b,
    output reg  [31:0] result
);

    // ALUSel encoding
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_SLL = 4'b0010;
    localparam ALU_SRL = 4'b0110;

    always @(*) begin
        case (alu_sel)
            ALU_ADD: result = operand_a + operand_b;
            ALU_SUB: result = operand_a - operand_b;
            ALU_SLL: result = operand_a << operand_b[4:0];
            ALU_SRL: result = operand_a >> operand_b[4:0];
            default: result = 32'b0;
        endcase
    end

endmodule