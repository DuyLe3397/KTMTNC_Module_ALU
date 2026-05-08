`timescale 1ns / 1ps

module alu (
    input  wire [3:0]  alu_sel,
    input  wire [31:0] operand_a,
    input  wire [31:0] operand_b,
    output reg  [31:0] result
);

    localparam ALU_ADD  = 4'b0000; // rd = rs1 + rs2
    localparam ALU_SUB  = 4'b0001; // rd = rs1 - rs2
    localparam ALU_SLL  = 4'b0010; // rd = rs1 << rs2[4:0]
    localparam ALU_SLT  = 4'b0011; // rd = (rs1 < rs2) signed ? 1 : 0
    localparam ALU_SLTU = 4'b0100; // rd = (rs1 < rs2) unsigned ? 1 : 0
    localparam ALU_XOR  = 4'b0101; // rd = rs1 ^ rs2
    localparam ALU_SRL  = 4'b0110; // rd = rs1 >> rs2[4:0]
    localparam ALU_SRA  = 4'b0111; // rd = rs1 >>> rs2[4:0]
    localparam ALU_OR   = 4'b1000; // rd = rs1 | rs2
    localparam ALU_AND  = 4'b1001; // rd = rs1 & rs2

    always @(*) begin
        case (alu_sel)
            ALU_ADD : result = operand_a + operand_b;
            ALU_SUB : result = operand_a - operand_b;
            ALU_SLL : result = operand_a << operand_b[4:0];
            ALU_SLT : result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0;
            ALU_SLTU: result = (operand_a < operand_b) ? 32'd1 : 32'd0;
            ALU_XOR : result = operand_a ^ operand_b;
            ALU_SRL : result = operand_a >> operand_b[4:0];
            ALU_SRA : result = $signed(operand_a) >>> operand_b[4:0];
            ALU_OR  : result = operand_a | operand_b;
            ALU_AND : result = operand_a & operand_b;
            default : result = 32'b0;
        endcase
    end

endmodule