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

    integer pass_cnt;
    integer fail_cnt;

    initial begin
        pass_cnt = 0; fail_cnt = 0;
        $display("=== ALU Testbench ===");

        // ADD
        alu_sel = 4'b0000; operand_a = 32'd10; operand_b = 32'd20; #10;
        if (result===32'd30) begin $display("[PASS] ADD"); pass_cnt=pass_cnt+1; end
        else begin $display("[FAIL] ADD expected 30 got %0d", result); fail_cnt=fail_cnt+1; end

        // SUB
        alu_sel = 4'b0001; operand_a = 32'd30; operand_b = 32'd10; #10;
        if (result===32'd20) begin $display("[PASS] SUB"); pass_cnt=pass_cnt+1; end
        else begin $display("[FAIL] SUB"); fail_cnt=fail_cnt+1; end

        // SLL
        alu_sel = 4'b0010; operand_a = 32'd1; operand_b = 32'd4; #10;
        if (result===32'd16) begin $display("[PASS] SLL"); pass_cnt=pass_cnt+1; end
        else begin $display("[FAIL] SLL"); fail_cnt=fail_cnt+1; end

        // SLT
        alu_sel = 4'b0011; operand_a = 32'hFFFFFFFF; operand_b = 32'd1; #10;
        if (result===32'd1) begin $display("[PASS] SLT"); pass_cnt=pass_cnt+1; end
        else begin $display("[FAIL] SLT"); fail_cnt=fail_cnt+1; end

        // SLTU
        alu_sel = 4'b0100; operand_a = 32'd1; operand_b = 32'hFFFFFFFF; #10;
        if (result===32'd1) begin $display("[PASS] SLTU"); pass_cnt=pass_cnt+1; end
        else begin $display("[FAIL] SLTU"); fail_cnt=fail_cnt+1; end

        // XOR
        alu_sel = 4'b0101; operand_a = 32'hAAAAAAAA; operand_b = 32'h55555555; #10;
        if (result===32'hFFFFFFFF) begin $display("[PASS] XOR"); pass_cnt=pass_cnt+1; end
        else begin $display("[FAIL] XOR"); fail_cnt=fail_cnt+1; end

        // SRL
        alu_sel = 4'b0110; operand_a = 32'h80000000; operand_b = 32'd1; #10;
        if (result===32'h40000000) begin $display("[PASS] SRL"); pass_cnt=pass_cnt+1; end
        else begin $display("[FAIL] SRL"); fail_cnt=fail_cnt+1; end

        // SRA - arithmetic right shift
        alu_sel = 4'b0111; operand_a = 32'h80000000; operand_b = 32'd1; #10;
        if (result===32'hC0000000) begin $display("[PASS] SRA"); pass_cnt=pass_cnt+1; end
        else begin $display("[FAIL] SRA"); fail_cnt=fail_cnt+1; end

        $display("PASS: %0d | FAIL: %0d", pass_cnt, fail_cnt);
        $stop;
    end

endmodule