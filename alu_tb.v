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
    integer test_num;

    task check_result;
        input [31:0] expected;
        input [47:0] op_name;
        begin
            test_num = test_num + 1;
            #1;
            if (result === expected) begin
                $display("[PASS] Test %02d | %-6s | A=%08h B=%08h | Result=%08h",
                         test_num, op_name, operand_a, operand_b, result);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] Test %02d | %-6s | A=%08h B=%08h | Expected=%08h Got=%08h",
                         test_num, op_name, operand_a, operand_b, expected, result);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    initial begin
        pass_cnt = 0; fail_cnt = 0; test_num = 0;
        $display("=== ALU Testbench - RISC-V RV32I ===");

        // ADD
        $display("\n--- ADD ---");
        alu_sel = 4'b0000;
        operand_a = 32'd10;       operand_b = 32'd20;       check_result(32'd30,       "ADD   ");
        operand_a = 32'hFFFFFFFF; operand_b = 32'd1;        check_result(32'd0,        "ADD   ");

        // SUB
        $display("\n--- SUB ---");
        alu_sel = 4'b0001;
        operand_a = 32'd30;       operand_b = 32'd10;       check_result(32'd20,       "SUB   ");
        operand_a = 32'd10;       operand_b = 32'd30;       check_result(32'hFFFFFFEC, "SUB   ");

        // SLL
        $display("\n--- SLL ---");
        alu_sel = 4'b0010;
        operand_a = 32'd1;        operand_b = 32'd4;        check_result(32'd16,       "SLL   ");
        operand_a = 32'h00000001; operand_b = 32'd31;       check_result(32'h80000000, "SLL   ");

        // SLT
        $display("\n--- SLT ---");
        alu_sel = 4'b0011;
        operand_a = 32'hFFFFFFFF; operand_b = 32'd1;        check_result(32'd1,        "SLT   ");
        operand_a = 32'd5;        operand_b = 32'd3;        check_result(32'd0,        "SLT   ");
        operand_a = 32'h80000000; operand_b = 32'd0;        check_result(32'd1,        "SLT   ");

        // SLTU
        $display("\n--- SLTU ---");
        alu_sel = 4'b0100;
        operand_a = 32'hFFFFFFFF; operand_b = 32'd1;        check_result(32'd0,        "SLTU  ");
        operand_a = 32'd1;        operand_b = 32'hFFFFFFFF; check_result(32'd1,        "SLTU  ");

        // XOR
        $display("\n--- XOR ---");
        alu_sel = 4'b0101;
        operand_a = 32'hAAAAAAAA; operand_b = 32'h55555555; check_result(32'hFFFFFFFF, "XOR   ");
        operand_a = 32'hFFFFFFFF; operand_b = 32'hFFFFFFFF; check_result(32'd0,        "XOR   ");

        // SRL
        $display("\n--- SRL ---");
        alu_sel = 4'b0110;
        operand_a = 32'h80000000; operand_b = 32'd1;        check_result(32'h40000000, "SRL   ");
        operand_a = 32'hFFFFFFFF; operand_b = 32'd4;        check_result(32'h0FFFFFFF, "SRL   ");

        // SRA
        $display("\n--- SRA ---");
        alu_sel = 4'b0111;
        operand_a = 32'h80000000; operand_b = 32'd1;        check_result(32'hC0000000, "SRA   ");
        operand_a = 32'hFFFFFFFF; operand_b = 32'd4;        check_result(32'hFFFFFFFF, "SRA   ");

        // OR
        $display("\n--- OR ---");
        alu_sel = 4'b1000;
        operand_a = 32'hAAAAAAAA; operand_b = 32'h55555555; check_result(32'hFFFFFFFF, "OR    ");
        operand_a = 32'd0;        operand_b = 32'h12345678; check_result(32'h12345678, "OR    ");

        // AND
        $display("\n--- AND ---");
        alu_sel = 4'b1001;
        operand_a = 32'hFFFFFFFF; operand_b = 32'h0F0F0F0F; check_result(32'h0F0F0F0F, "AND   ");
        operand_a = 32'hAAAAAAAA; operand_b = 32'h55555555; check_result(32'd0,        "AND   ");

        $display("\nPASS: %0d | FAIL: %0d", pass_cnt, fail_cnt);
        $stop;
    end

endmodule