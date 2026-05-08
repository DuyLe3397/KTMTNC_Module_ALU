`timescale 1ns / 1ps

module alu_tb;

    reg  [3:0]  alu_sel;
    reg  [31:0] operand_a;
    reg  [31:0] operand_b;
    wire [31:0] result;

    alu DUT (
        .alu_sel  (alu_sel),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .result   (result)
    );

    initial begin
        $display("=== ALU Testbench ===");

        // Test ADD
        alu_sel = 4'b0000;
        operand_a = 32'd10; operand_b = 32'd20;
        #10;
        $display("ADD: %0d + %0d = %0d (expected 30)", operand_a, operand_b, result);

        // Test SUB
        alu_sel = 4'b0001;
        operand_a = 32'd30; operand_b = 32'd10;
        #10;
        $display("SUB: %0d - %0d = %0d (expected 20)", operand_a, operand_b, result);

        $stop;
    end

endmodule