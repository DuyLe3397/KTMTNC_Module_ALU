`timescale 1ns / 1ps

module alu_tb;

    // ---- DUT ports ----
    reg  [3:0]  alu_sel;
    reg  [31:0] operand_a;
    reg  [31:0] operand_b;
    wire [31:0] result;

    // ---- Instantiate DUT ----
    alu DUT (
        .alu_sel  (alu_sel),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .result   (result)
    );

    // ---- Test counters ----
    integer pass_cnt;
    integer fail_cnt;
    integer test_num;

    // ---- Check task ----
    task check_result;
        input [31:0] expected;
        input [47:0] op_name; // 6-char string
        begin
            test_num = test_num + 1;
            #1; // wait for combinational settle
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

        $display("===========================================================");
        $display("  Le Van Duy | duy.lv241719e@sis.hust.edu.vn");
        $display("===========================================================");

        // ADD  (alu_sel = 4'b0000)
        $display("\n--- ADD (rs1 + rs2) ---");
        alu_sel = 4'b0000;

        operand_a = 32'd10;         operand_b = 32'd20;
        check_result(32'd30,              "ADD   ");           // co ban

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd1;        // wrap-around ve 0
        check_result(32'd0,               "ADD   ");

        operand_a = 32'd0;          operand_b = 32'd0;         // 0 + 0 = 0
        check_result(32'd0,               "ADD   ");

        operand_a = 32'h7FFFFFFF;   operand_b = 32'd1;         // signed overflow: max_int + 1
        check_result(32'h80000000,        "ADD   ");

        operand_a = 32'h80000000;   operand_b = 32'h80000000; // (-min) + (-min) = 0 (overflow)
        check_result(32'h00000000,        "ADD   ");

        operand_a = 32'hFFFFFFFE;   operand_b = 32'hFFFFFFFE; // -2 + -2 = -4 (0xFFFFFFFC)
        check_result(32'hFFFFFFFC,        "ADD   ");

        operand_a = 32'h00000001;   operand_b = 32'hFFFFFFFF; // giao hoan: 1 + (-1) = 0
        check_result(32'd0,               "ADD   ");

        // SUB  (alu_sel = 4'b0001)
        $display("\n--- SUB (rs1 - rs2) ---");
        alu_sel = 4'b0001;

        operand_a = 32'd30;         operand_b = 32'd10;
        check_result(32'd20,              "SUB   ");

        operand_a = 32'd10;         operand_b = 32'd30;        // ket qua am
        check_result(32'hFFFFFFEC,        "SUB   ");

        operand_a = 32'd5;          operand_b = 32'd5;         // bang nhau -> 0
        check_result(32'd0,               "SUB   ");

        operand_a = 32'h00000000;   operand_b = 32'h00000001; // 0 - 1 = -1 (0xFFFFFFFF)
        check_result(32'hFFFFFFFF,        "SUB   ");

        operand_a = 32'h80000000;   operand_b = 32'h00000001; // min_int - 1 (overflow)
        check_result(32'h7FFFFFFF,        "SUB   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFF; // -1 - (-1) = 0
        check_result(32'd0,               "SUB   ");

        operand_a = 32'h00000000;   operand_b = 32'h80000000; // 0 - min_int = min_int (overflow)
        check_result(32'h80000000,        "SUB   ");

        // SLL  (alu_sel = 4'b0010)
        $display("\n--- SLL (rs1 << rs2[4:0]) ---");
        alu_sel = 4'b0010;

        operand_a = 32'd1;          operand_b = 32'd4;
        check_result(32'd16,              "SLL   ");

        operand_a = 32'h00000001;   operand_b = 32'd31;        // shift len MSB
        check_result(32'h80000000,        "SLL   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd1;
        check_result(32'hFFFFFFFE,        "SLL   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd0;         // shift 0 bit -> giu nguyen
        check_result(32'hFFFFFFFF,        "SLL   ");

        operand_a = 32'h00000001;   operand_b = 32'd32;        // rs2[4:0]=0 -> shift 0 bit
        check_result(32'h00000001,        "SLL   ");

        operand_a = 32'hDEADBEEF;   operand_b = 32'd16;        // shift 16 bit
        check_result(32'hBEEF0000,        "SLL   ");

        operand_a = 32'h00000001;   operand_b = 32'd63;        // rs2[4:0]=31 -> shift 31
        check_result(32'h80000000,        "SLL   ");

        // SLT  (alu_sel = 4'b0011) - signed comparison
        $display("\n--- SLT signed: (rs1 < rs2) ? 1 : 0 ---");
        alu_sel = 4'b0011;

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd1;         // -1 < 1 -> 1
        check_result(32'd1,               "SLT   ");

        operand_a = 32'd5;          operand_b = 32'd3;         // 5 >= 3 -> 0
        check_result(32'd0,               "SLT   ");

        operand_a = 32'd3;          operand_b = 32'd3;         // bang nhau -> 0
        check_result(32'd0,               "SLT   ");

        operand_a = 32'h80000000;   operand_b = 32'd0;         // min_int < 0 -> 1
        check_result(32'd1,               "SLT   ");

        operand_a = 32'h80000000;   operand_b = 32'h7FFFFFFF; // min_int < max_int -> 1
        check_result(32'd1,               "SLT   ");

        operand_a = 32'h7FFFFFFF;   operand_b = 32'h80000000; // max_int > min_int -> 0
        check_result(32'd0,               "SLT   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFE; // -1 > -2 -> 0
        check_result(32'd0,               "SLT   ");

        operand_a = 32'hFFFFFFFE;   operand_b = 32'hFFFFFFFF; // -2 < -1 -> 1
        check_result(32'd1,               "SLT   ");

        operand_a = 32'd0;          operand_b = 32'hFFFFFFFF; // 0 > -1 -> 0
        check_result(32'd0,               "SLT   ");

        // SLTU (alu_sel = 4'b0100) - unsigned comparison
        $display("\n--- SLTU unsigned: (rs1 < rs2) ? 1 : 0 ---");
        alu_sel = 4'b0100;

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd1;         // 4G-1 > 1 -> 0
        check_result(32'd0,               "SLTU  ");

        operand_a = 32'd1;          operand_b = 32'hFFFFFFFF;  // 1 < 4G-1 -> 1
        check_result(32'd1,               "SLTU  ");

        operand_a = 32'd0;          operand_b = 32'd0;
        check_result(32'd0,               "SLTU  ");

        operand_a = 32'd0;          operand_b = 32'd1;         // 0 < 1 -> 1
        check_result(32'd1,               "SLTU  ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFF; // bang nhau -> 0
        check_result(32'd0,               "SLTU  ");

        operand_a = 32'hFFFFFFFE;   operand_b = 32'hFFFFFFFF; // 4G-2 < 4G-1 -> 1
        check_result(32'd1,               "SLTU  ");

        operand_a = 32'h80000000;   operand_b = 32'h7FFFFFFF; // unsigned: 2G > 2G-1 -> 0
        check_result(32'd0,               "SLTU  ");            // (nguoc lai SLT!)

        // XOR  (alu_sel = 4'b0101)
        $display("\n--- XOR (rs1 ^ rs2) ---");
        alu_sel = 4'b0101;

        operand_a = 32'hAAAAAAAA;   operand_b = 32'h55555555;  // bit xen ke -> all 1
        check_result(32'hFFFFFFFF,        "XOR   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFF;  // x ^ x = 0
        check_result(32'd0,               "XOR   ");

        operand_a = 32'h12345678;   operand_b = 32'h00000000;  // x ^ 0 = x
        check_result(32'h12345678,        "XOR   ");

        operand_a = 32'h00000000;   operand_b = 32'h00000000;  // 0 ^ 0 = 0
        check_result(32'd0,               "XOR   ");

        operand_a = 32'hDEADBEEF;   operand_b = 32'hFFFFFFFF;  // x ^ all1 = ~x (NOT)
        check_result(32'h21524110,        "XOR   ");

        operand_a = 32'hA5A5A5A5;   operand_b = 32'h5A5A5A5A;  // xen ke nguoc -> all 1
        check_result(32'hFFFFFFFF,        "XOR   ");

        operand_a = 32'h12345678;   operand_b = 32'h12345678;  // x ^ x = 0 (gia tri bat ky)
        check_result(32'd0,               "XOR   ");

        // SRL  (alu_sel = 4'b0110) - logical right shift (zero-fill)
        $display("\n--- SRL (rs1 >> rs2[4:0], zero-fill) ---");
        alu_sel = 4'b0110;

        operand_a = 32'h80000000;   operand_b = 32'd1;
        check_result(32'h40000000,        "SRL   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd4;
        check_result(32'h0FFFFFFF,        "SRL   ");

        operand_a = 32'h00000010;   operand_b = 32'd4;
        check_result(32'h00000001,        "SRL   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd0;         // shift 0 bit -> giu nguyen
        check_result(32'hFFFFFFFF,        "SRL   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd31;        // shift 31 -> chi con bit 31
        check_result(32'h00000001,        "SRL   ");

        operand_a = 32'h80000000;   operand_b = 32'd31;        // 1000...0 >> 31 = 1
        check_result(32'h00000001,        "SRL   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd32;        // rs2[4:0]=0 -> shift 0
        check_result(32'hFFFFFFFF,        "SRL   ");

        operand_a = 32'h00000000;   operand_b = 32'd15;        // 0 >> bat ky = 0
        check_result(32'h00000000,        "SRL   ");

        // SRA  (alu_sel = 4'b0111) - arithmetic right shift (sign-fill)
        $display("\n--- SRA (rs1 >>> rs2[4:0], sign-fill) ---");
        alu_sel = 4'b0111;

        operand_a = 32'h80000000;   operand_b = 32'd1;         // so am: fill 1
        check_result(32'hC0000000,        "SRA   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd4;         // -1 >>> 4 = -1
        check_result(32'hFFFFFFFF,        "SRA   ");

        operand_a = 32'h7FFFFFFF;   operand_b = 32'd1;         // so duong: fill 0
        check_result(32'h3FFFFFFF,        "SRA   ");

        operand_a = 32'd16;         operand_b = 32'd2;         // 16 >>> 2 = 4
        check_result(32'd4,               "SRA   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd31;        // -1 >>> 31 = -1 (all ones)
        check_result(32'hFFFFFFFF,        "SRA   ");

        operand_a = 32'h80000000;   operand_b = 32'd31;        // min_int >>> 31 = -1
        check_result(32'hFFFFFFFF,        "SRA   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd0;         // shift 0 -> giu nguyen
        check_result(32'hFFFFFFFF,        "SRA   ");

        operand_a = 32'h7FFFFFFF;   operand_b = 32'd31;        // max_int >>> 31 = 0
        check_result(32'h00000000,        "SRA   ");

        operand_a = 32'hFFFFFFF0;   operand_b = 32'd4;         // -16 >>> 4 = -1
        check_result(32'hFFFFFFFF,        "SRA   ");

        // OR   (alu_sel = 4'b1000)
        $display("\n--- OR (rs1 | rs2) ---");
        alu_sel = 4'b1000;

        operand_a = 32'hAAAAAAAA;   operand_b = 32'h55555555;  // xen ke -> all 1
        check_result(32'hFFFFFFFF,        "OR    ");

        operand_a = 32'h00000000;   operand_b = 32'h12345678;  // 0 | x = x
        check_result(32'h12345678,        "OR    ");

        operand_a = 32'd0;          operand_b = 32'd0;
        check_result(32'd0,               "OR    ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'h00000000;  // all1 | 0 = all1
        check_result(32'hFFFFFFFF,        "OR    ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFF;  // all1 | all1 = all1
        check_result(32'hFFFFFFFF,        "OR    ");

        operand_a = 32'h0F0F0F0F;   operand_b = 32'hF0F0F0F0;  // bo sung -> all 1
        check_result(32'hFFFFFFFF,        "OR    ");

        operand_a = 32'h12345678;   operand_b = 32'h12345678;  // x | x = x
        check_result(32'h12345678,        "OR    ");

        // AND  (alu_sel = 4'b1001)
        $display("\n--- AND (rs1 & rs2) ---");
        alu_sel = 4'b1001;

        operand_a = 32'hFFFFFFFF;   operand_b = 32'h0F0F0F0F;
        check_result(32'h0F0F0F0F,        "AND   ");

        operand_a = 32'hAAAAAAAA;   operand_b = 32'h55555555;  // khong co bit chung -> 0
        check_result(32'd0,               "AND   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFF;
        check_result(32'hFFFFFFFF,        "AND   ");

        operand_a = 32'h00000000;   operand_b = 32'hFFFFFFFF;  // 0 & x = 0
        check_result(32'h00000000,        "AND   ");

        operand_a = 32'hFFFFFFFF;   operand_b = 32'h00000000;  // x & 0 = 0
        check_result(32'h00000000,        "AND   ");

        operand_a = 32'h12345678;   operand_b = 32'h12345678;  // x & x = x
        check_result(32'h12345678,        "AND   ");

        operand_a = 32'hDEADBEEF;   operand_b = 32'h0000FFFF;  // mask lay 16 bit thap
        check_result(32'h0000BEEF,        "AND   ");

        operand_a = 32'hDEADBEEF;   operand_b = 32'hFFFF0000;  // mask lay 16 bit cao
        check_result(32'hDEAD0000,        "AND   ");

        // DEFAULT (alu_sel chua duoc dinh nghia -> result = 0)
        $display("\n--- DEFAULT (alu_sel khong hop le -> 0) ---");

        operand_a = 32'hDEADBEEF;   operand_b = 32'hCAFEBABE;
        alu_sel = 4'b1010; check_result(32'h00000000, "DEF   "); // sel=10 -> 0
        alu_sel = 4'b1011; check_result(32'h00000000, "DEF   "); // sel=11 -> 0
        alu_sel = 4'b1111; check_result(32'h00000000, "DEF   "); // sel=15 -> 0

        // Summary
        $display("\n===========================================================");
        $display("  Tong so test: %0d  |  PASS: %0d  |  FAIL: %0d",
                 pass_cnt + fail_cnt, pass_cnt, fail_cnt);
        $stop;
    end

endmodule