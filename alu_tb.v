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
                $display("[PASS] Test %02d | %-6s | A=%08h  B=%08h | Result=%08h",
                         test_num, op_name, operand_a, operand_b, result);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] Test %02d | %-6s | A=%08h  B=%08h | Expected=%08h  Got=%08h",
                         test_num, op_name, operand_a, operand_b, expected, result);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    initial begin
        pass_cnt = 0; fail_cnt = 0; test_num = 0;
        $display("=== ALU Testbench - RISC-V RV32I ===");

        // ADD - them edge cases
        $display("\n--- ADD ---");
        alu_sel = 4'b0000;
        operand_a = 32'd10;       operand_b = 32'd20;       check_result(32'd30,       "ADD   ");
        operand_a = 32'hFFFFFFFF; operand_b = 32'd1;        check_result(32'd0,        "ADD   "); // wrap-around
        operand_a = 32'd0;        operand_b = 32'd0;        check_result(32'd0,        "ADD   "); // zero + zero
        operand_a = 32'h7FFFFFFF; operand_b = 32'd1;        check_result(32'h80000000, "ADD   "); // max signed + 1

        // SUB - them edge cases
        $display("\n--- SUB ---");
        alu_sel = 4'b0001;
        operand_a = 32'd30;       operand_b = 32'd10;       check_result(32'd20,       "SUB   ");
        operand_a = 32'd10;       operand_b = 32'd30;       check_result(32'hFFFFFFEC, "SUB   "); // negative result
        operand_a = 32'd5;        operand_b = 32'd5;        check_result(32'd0,        "SUB   "); // zero

        // SLL
        $display("\n--- SLL ---");
        alu_sel = 4'b0010;
        operand_a = 32'd1;        operand_b = 32'd4;        check_result(32'd16,       "SLL   ");
        operand_a = 32'h00000001; operand_b = 32'd31;       check_result(32'h80000000, "SLL   "); // shift to MSB
        operand_a = 32'hFFFFFFFF; operand_b = 32'd1;        check_result(32'hFFFFFFFE, "SLL   ");

        // SLT
        $display("\n--- SLT ---");
        alu_sel = 4'b0011;
        operand_a = 32'hFFFFFFFF; operand_b = 32'd1;        check_result(32'd1,        "SLT   "); // -1 < 1
        operand_a = 32'd5;        operand_b = 32'd3;        check_result(32'd0,        "SLT   ");
        operand_a = 32'd3;        operand_b = 32'd3;        check_result(32'd0,        "SLT   "); // equal -> 0
        operand_a = 32'h80000000; operand_b = 32'd0;        check_result(32'd1,        "SLT   "); // min_int < 0

        // SLTU
        $display("\n--- SLTU ---");
        alu_sel = 4'b0100;
        operand_a = 32'hFFFFFFFF; operand_b = 32'd1;        check_result(32'd0,        "SLTU  "); // large > 1
        operand_a = 32'd1;        operand_b = 32'hFFFFFFFF; check_result(32'd1,        "SLTU  "); // 1 < large
        operand_a = 32'd0;        operand_b = 32'd0;        check_result(32'd0,        "SLTU  ");

        // XOR
        $display("\n--- XOR ---");
        alu_sel = 4'b0101;
        operand_a = 32'hAAAAAAAA; operand_b = 32'h55555555; check_result(32'hFFFFFFFF, "XOR   ");
        operand_a = 32'hFFFFFFFF; operand_b = 32'hFFFFFFFF; check_result(32'd0,        "XOR   "); // x^x=0
        operand_a = 32'h12345678; operand_b = 32'h00000000; check_result(32'h12345678, "XOR   "); // x^0=x

        // SRL
        $display("\n--- SRL ---");
        alu_sel = 4'b0110;
        operand_a = 32'h80000000; operand_b = 32'd1;        check_result(32'h40000000, "SRL   ");
        operand_a = 32'hFFFFFFFF; operand_b = 32'd4;        check_result(32'h0FFFFFFF, "SRL   ");
        operand_a = 32'h00000010; operand_b = 32'd4;        check_result(32'h00000001, "SRL   ");

        // SRA
        $display("\n--- SRA ---");
        alu_sel = 4'b0111;
        operand_a = 32'h80000000; operand_b = 32'd1;        check_result(32'hC0000000, "SRA   "); // neg: fill 1
        operand_a = 32'hFFFFFFFF; operand_b = 32'd4;        check_result(32'hFFFFFFFF, "SRA   "); // -1>>4=-1
        operand_a = 32'h7FFFFFFF; operand_b = 32'd1;        check_result(32'h3FFFFFFF, "SRA   "); // pos: fill 0
        operand_a = 32'd16;       operand_b = 32'd2;        check_result(32'd4,        "SRA   ");

        // OR
        $display("\n--- OR ---");
        alu_sel = 4'b1000;
        operand_a = 32'hAAAAAAAA; operand_b = 32'h55555555; check_result(32'hFFFFFFFF, "OR    ");
        operand_a = 32'h00000000; operand_b = 32'h12345678; check_result(32'h12345678, "OR    ");
        operand_a = 32'd0;        operand_b = 32'd0;        check_result(32'd0,        "OR    ");

        // AND
        $display("\n--- AND ---");
        alu_sel = 4'b1001;
        operand_a = 32'hFFFFFFFF; operand_b = 32'h0F0F0F0F; check_result(32'h0F0F0F0F, "AND   ");
        operand_a = 32'hAAAAAAAA; operand_b = 32'h55555555; check_result(32'd0,        "AND   "); // no common bits
        operand_a = 32'hFFFFFFFF; operand_b = 32'hFFFFFFFF; check_result(32'hFFFFFFFF, "AND   ");

        $display("\nPASS: %0d | FAIL: %0d", pass_cnt, fail_cnt);
        $stop;
    end

endmodule