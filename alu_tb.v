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

    // ---- counters ----    
    integer pass_cnt;
    integer fail_cnt;
    integer test_num;

    task check_result;
        input [31:0] expected;
        input [47:0] op_name; // 6-char string
        begin
            test_num = test_num + 1;
            #1; // wait
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
        pass_cnt = 0;
        fail_cnt = 0;
        test_num = 0;
        // ADD  (alu_sel = 4'b0000)
        $display("\n--- ADD (rs1 + rs2) ---");
        alu_sel = 4'b0000;

        operand_a = 32'd10;         operand_b = 32'd20;
        check_result(32'd30,              "ADD   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd1; 
        check_result(32'd0,               "ADD   ");

        operand_a = 32'd0;          operand_b = 32'd0;
        check_result(32'd0,               "ADD   ");

        operand_a = 32'h7FFFFFFF;   operand_b = 32'd1;   // max signed + 1
        check_result(32'h80000000,        "ADD   ");

        // SUB  (alu_sel = 4'b0001)
        $display("\n--- SUB (rs1 - rs2) ---");
        alu_sel = 4'b0001;

        operand_a = 32'd30;         operand_b = 32'd10;
        check_result(32'd20,              "SUB   ");

        operand_a = 32'd10;         operand_b = 32'd30;  
        check_result(32'hFFFFFFEC,        "SUB   ");

        operand_a = 32'd5;          operand_b = 32'd5;   // zero
        check_result(32'd0,               "SUB   ");

        // SLL  (alu_sel = 4'b0010)
        $display("\n--- SLL (rs1 << rs2[4:0]) ---");
        alu_sel = 4'b0010;

        operand_a = 32'd1;          operand_b = 32'd4;
        check_result(32'd16,              "SLL   ");

        operand_a = 32'h00000001;   operand_b = 32'd31; 
        check_result(32'h80000000,        "SLL   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd1;
        check_result(32'hFFFFFFFE,        "SLL   ");

        // SLT  (alu_sel = 4'b0011) 
        $display("\n--- SLT signed: (rs1 < rs2) ? 1 : 0 ---");
        alu_sel = 4'b0011;

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd1;   // -1 < 1 -> 1
        check_result(32'd1,               "SLT   ");

        operand_a = 32'd5;          operand_b = 32'd3;   // 5 >= 3 -> 0
        check_result(32'd0,               "SLT   ");

        operand_a = 32'd3;          operand_b = 32'd3;   // equal -> 0
        check_result(32'd0,               "SLT   ");

        operand_a = 32'h80000000;   operand_b = 32'd0;   // min_int < 0 -> 1
        check_result(32'd1,               "SLT   ");

        // SLTU (alu_sel = 4'b0100)
        $display("\n--- SLTU unsigned: (rs1 < rs2) ? 1 : 0 ---");
        alu_sel = 4'b0100;

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd1;   // large > 1 -> 0
        check_result(32'd0,               "SLTU  ");

        operand_a = 32'd1;          operand_b = 32'hFFFFFFFF; // 1 < large -> 1
        check_result(32'd1,               "SLTU  ");

        operand_a = 32'd0;          operand_b = 32'd0;
        check_result(32'd0,               "SLTU  ");

        // XOR  (alu_sel = 4'b0101)
        $display("\n--- XOR (rs1 ^ rs2) ---");
        alu_sel = 4'b0101;

        operand_a = 32'hAAAAAAAA;   operand_b = 32'h55555555;
        check_result(32'hFFFFFFFF,        "XOR   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFF; // x ^ x = 0
        check_result(32'd0,               "XOR   ");

        operand_a = 32'h12345678;   operand_b = 32'h00000000; // x ^ 0 = x
        check_result(32'h12345678,        "XOR   ");

        // SRL  (alu_sel = 4'b0110)
        $display("\n--- SRL (rs1 >> rs2[4:0], zero-fill) ---");
        alu_sel = 4'b0110;

        operand_a = 32'h80000000;   operand_b = 32'd1;
        check_result(32'h40000000,        "SRL   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd4;
        check_result(32'h0FFFFFFF,        "SRL   ");

        operand_a = 32'h00000010;   operand_b = 32'd4;
        check_result(32'h00000001,        "SRL   ");

        // SRA  (alu_sel = 4'b0111)
        $display("\n--- SRA (rs1 >>> rs2[4:0], sign-fill) ---");
        alu_sel = 4'b0111;

        operand_a = 32'h80000000;   operand_b = 32'd1;   
        check_result(32'hC0000000,        "SRA   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd4;   // -1 >> 4 = -1
        check_result(32'hFFFFFFFF,        "SRA   ");

        operand_a = 32'h7FFFFFFF;   operand_b = 32'd1;   
        check_result(32'h3FFFFFFF,        "SRA   ");

        operand_a = 32'd16;         operand_b = 32'd2;   // 16 >> 2 = 4
        check_result(32'd4,               "SRA   ");

        // OR   (alu_sel = 4'b1000)
        $display("\n--- OR (rs1 | rs2) ---");
        alu_sel = 4'b1000;

        operand_a = 32'hAAAAAAAA;   operand_b = 32'h55555555;
        check_result(32'hFFFFFFFF,        "OR    ");

        operand_a = 32'h00000000;   operand_b = 32'h12345678;
        check_result(32'h12345678,        "OR    ");

        operand_a = 32'd0;          operand_b = 32'd0;
        check_result(32'd0,               "OR    ");

        // AND  (alu_sel = 4'b1001)
        $display("\n--- AND (rs1 & rs2) ---");
        alu_sel = 4'b1001;

        operand_a = 32'hFFFFFFFF;   operand_b = 32'h0F0F0F0F;
        check_result(32'h0F0F0F0F,        "AND   ");

        operand_a = 32'hAAAAAAAA;   operand_b = 32'h55555555;
        check_result(32'd0,               "AND   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFF;
        check_result(32'hFFFFFFFF,        "AND   ");

        // Summary
        $display("  Tong: %0d  |  PASS: %0d  |  FAIL: %0d",
                 pass_cnt + fail_cnt, pass_cnt, fail_cnt);
        $display("===========================================================\n");
        $stop;
    end

endmodule