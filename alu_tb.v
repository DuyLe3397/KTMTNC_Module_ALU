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

    wire signed [31:0] sa = operand_a;
    wire signed [31:0] sb = operand_b;
    wire signed [31:0] sr = result;

    // check phep ADD/SUB  ->  in dang   a + b = r
    task check_add;
        input [31:0] expected;
        begin
            test_num = test_num + 1;
            #1;
            if (result === expected) begin
                $display("[PASS] Test %02d | ADD  | %0d + %0d = %0d",
                         test_num, operand_a, operand_b, result);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] Test %02d | ADD  | %0d + %0d = %0d  (expected %0d)",
                         test_num, operand_a, operand_b, result, expected);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    task check_sub;
        input [31:0] expected;
        begin
            test_num = test_num + 1;
            #1;
            if (result === expected) begin
                $display("[PASS] Test %02d | SUB  | %0d - %0d = %0d",
                         test_num, $signed(operand_a), $signed(operand_b), $signed(result));
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] Test %02d | SUB  | %0d - %0d = %0d  (expected %0d)",
                         test_num, $signed(operand_a), $signed(operand_b), $signed(result), $signed(expected));
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    task check_sll;
        input [31:0] expected;
        begin
            test_num = test_num + 1;
            #1;
            if (result === expected) begin
                $display("[PASS] Test %02d | SLL  | 0x%08h << %0d = 0x%08h",
                         test_num, operand_a, operand_b[4:0], result);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] Test %02d | SLL  | 0x%08h << %0d = 0x%08h  (expected 0x%08h)",
                         test_num, operand_a, operand_b[4:0], result, expected);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    task check_slt;
        input [31:0] expected;
        begin
            test_num = test_num + 1;
            #1;
            if (result === expected) begin
                $display("[PASS] Test %02d | SLT  | %0d < %0d (signed) ? -> %0d",
                         test_num, $signed(operand_a), $signed(operand_b), result);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] Test %02d | SLT  | %0d < %0d (signed) ? -> %0d  (expected %0d)",
                         test_num, $signed(operand_a), $signed(operand_b), result, expected);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    task check_sltu;
        input [31:0] expected;
        begin
            test_num = test_num + 1;
            #1;
            if (result === expected) begin
                $display("[PASS] Test %02d | SLTU | %0d < %0d (unsigned) ? -> %0d",
                         test_num, operand_a, operand_b, result);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] Test %02d | SLTU | %0d < %0d (unsigned) ? -> %0d  (expected %0d)",
                         test_num, operand_a, operand_b, result, expected);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    task check_xor;
        input [31:0] expected;
        begin
            test_num = test_num + 1;
            #1;
            if (result === expected) begin
                $display("[PASS] Test %02d | XOR  | 0x%08h ^ 0x%08h = 0x%08h",
                         test_num, operand_a, operand_b, result);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] Test %02d | XOR  | 0x%08h ^ 0x%08h = 0x%08h  (expected 0x%08h)",
                         test_num, operand_a, operand_b, result, expected);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    task check_srl;
        input [31:0] expected;
        begin
            test_num = test_num + 1;
            #1;
            if (result === expected) begin
                $display("[PASS] Test %02d | SRL  | 0x%08h >> %0d = 0x%08h",
                         test_num, operand_a, operand_b[4:0], result);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] Test %02d | SRL  | 0x%08h >> %0d = 0x%08h  (expected 0x%08h)",
                         test_num, operand_a, operand_b[4:0], result, expected);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    task check_sra;
        input [31:0] expected;
        begin
            test_num = test_num + 1;
            #1;
            if (result === expected) begin
                $display("[PASS] Test %02d | SRA  | %0d >>> %0d = %0d",
                         test_num, $signed(operand_a), operand_b[4:0], $signed(result));
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] Test %02d | SRA  | %0d >>> %0d = %0d  (expected %0d)",
                         test_num, $signed(operand_a), operand_b[4:0], $signed(result), $signed(expected));
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    task check_or;
        input [31:0] expected;
        begin
            test_num = test_num + 1;
            #1;
            if (result === expected) begin
                $display("[PASS] Test %02d | OR   | 0x%08h | 0x%08h = 0x%08h",
                         test_num, operand_a, operand_b, result);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] Test %02d | OR   | 0x%08h | 0x%08h = 0x%08h  (expected 0x%08h)",
                         test_num, operand_a, operand_b, result, expected);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    task check_and;
        input [31:0] expected;
        begin
            test_num = test_num + 1;
            #1;
            if (result === expected) begin
                $display("[PASS] Test %02d | AND  | 0x%08h & 0x%08h = 0x%08h",
                         test_num, operand_a, operand_b, result);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] Test %02d | AND  | 0x%08h & 0x%08h = 0x%08h  (expected 0x%08h)",
                         test_num, operand_a, operand_b, result, expected);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    initial begin
        pass_cnt = 0;
        fail_cnt = 0;
        test_num = 0;

        $display("===========================================================");

        // ADD  (alu_sel = 4'b0000)
        $display("\n--- ADD (rs1 + rs2) ---");
        alu_sel = 4'b0000;

        operand_a = 32'd10;         operand_b = 32'd20;
        check_add(32'd30);                                     // 10 + 20 = 30

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd1;
        check_add(32'd0);                                      // 4294967295 + 1 = 0 (wrap)

        operand_a = 32'd0;          operand_b = 32'd0;
        check_add(32'd0);                                      // 0 + 0 = 0

        operand_a = 32'h7FFFFFFF;   operand_b = 32'd1;
        check_add(32'h80000000);                               // 2147483647 + 1 = -2147483648 (overflow)

        operand_a = 32'h80000000;   operand_b = 32'h80000000;
        check_add(32'h00000000);                               // (-2G) + (-2G) = 0 (overflow)

        operand_a = 32'hFFFFFFFE;   operand_b = 32'hFFFFFFFE;
        check_add(32'hFFFFFFFC);                               // -2 + -2 = -4

        operand_a = 32'h00000001;   operand_b = 32'hFFFFFFFF;
        check_add(32'd0);                                      // 1 + (-1) = 0

        // SUB  (alu_sel = 4'b0001)
        $display("\n--- SUB (rs1 - rs2) ---");
        alu_sel = 4'b0001;

        operand_a = 32'd30;         operand_b = 32'd10;
        check_sub(32'd20);                                     // 30 - 10 = 20

        operand_a = 32'd10;         operand_b = 32'd30;
        check_sub(32'hFFFFFFEC);                               // 10 - 30 = -20

        operand_a = 32'd5;          operand_b = 32'd5;
        check_sub(32'd0);                                      // 5 - 5 = 0

        operand_a = 32'h00000000;   operand_b = 32'h00000001;
        check_sub(32'hFFFFFFFF);                               // 0 - 1 = -1

        operand_a = 32'h80000000;   operand_b = 32'h00000001;
        check_sub(32'h7FFFFFFF);                               // min_int - 1 = max_int (overflow)

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFF;
        check_sub(32'd0);                                      // -1 - (-1) = 0

        operand_a = 32'h00000000;   operand_b = 32'h80000000;
        check_sub(32'h80000000);                               // 0 - min_int = min_int (overflow)

        // SLL  (alu_sel = 4'b0010)
        $display("\n--- SLL (rs1 << rs2[4:0]) ---");
        alu_sel = 4'b0010;

        operand_a = 32'd1;          operand_b = 32'd4;
        check_sll(32'd16);                                     // 1 << 4 = 16

        operand_a = 32'h00000001;   operand_b = 32'd31;
        check_sll(32'h80000000);                               // 1 << 31 = 0x80000000

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd1;
        check_sll(32'hFFFFFFFE);                               // 0xFFFFFFFF << 1

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd0;
        check_sll(32'hFFFFFFFF);                               // shift 0 bit -> giu nguyen

        operand_a = 32'h00000001;   operand_b = 32'd32;
        check_sll(32'h00000001);                               // rs2[4:0]=0 -> shift 0

        operand_a = 32'hDEADBEEF;   operand_b = 32'd16;
        check_sll(32'hBEEF0000);                               // 0xDEADBEEF << 16

        operand_a = 32'h00000001;   operand_b = 32'd63;
        check_sll(32'h80000000);                               // rs2[4:0]=31 -> shift 31

        // SLT  (alu_sel = 4'b0011) 
        $display("\n--- SLT signed: (rs1 < rs2) ? 1 : 0 ---");
        alu_sel = 4'b0011;

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd1;
        check_slt(32'd1);                                      // -1 < 1 -> 1

        operand_a = 32'd5;          operand_b = 32'd3;
        check_slt(32'd0);                                      // 5 >= 3 -> 0

        operand_a = 32'd3;          operand_b = 32'd3;
        check_slt(32'd0);                                      // 3 == 3 -> 0

        operand_a = 32'h80000000;   operand_b = 32'd0;
        check_slt(32'd1);                                      // -2147483648 < 0 -> 1

        operand_a = 32'h80000000;   operand_b = 32'h7FFFFFFF;
        check_slt(32'd1);                                      // min_int < max_int -> 1

        operand_a = 32'h7FFFFFFF;   operand_b = 32'h80000000;
        check_slt(32'd0);                                      // max_int > min_int -> 0

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFE;
        check_slt(32'd0);                                      // -1 > -2 -> 0

        operand_a = 32'hFFFFFFFE;   operand_b = 32'hFFFFFFFF;
        check_slt(32'd1);                                      // -2 < -1 -> 1

        operand_a = 32'd0;          operand_b = 32'hFFFFFFFF;
        check_slt(32'd0);                                      // 0 > -1 -> 0

        // SLTU (alu_sel = 4'b0100) - unsigned comparison
        $display("\n--- SLTU unsigned: (rs1 < rs2) ? 1 : 0 ---");
        alu_sel = 4'b0100;

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd1;
        check_sltu(32'd0);                                     // 4294967295 > 1 -> 0

        operand_a = 32'd1;          operand_b = 32'hFFFFFFFF;
        check_sltu(32'd1);                                     // 1 < 4294967295 -> 1

        operand_a = 32'd0;          operand_b = 32'd0;
        check_sltu(32'd0);                                     // 0 == 0 -> 0

        operand_a = 32'd0;          operand_b = 32'd1;
        check_sltu(32'd1);                                     // 0 < 1 -> 1

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFF;
        check_sltu(32'd0);                                     // bang nhau -> 0

        operand_a = 32'hFFFFFFFE;   operand_b = 32'hFFFFFFFF;
        check_sltu(32'd1);                                     // 4G-2 < 4G-1 -> 1

        operand_a = 32'h80000000;   operand_b = 32'h7FFFFFFF;
        check_sltu(32'd0);                                     // unsigned: 2G > 2G-1 -> 0 (nguoc SLT!)

        // XOR  (alu_sel = 4'b0101)
        $display("\n--- XOR (rs1 ^ rs2) ---");
        alu_sel = 4'b0101;

        operand_a = 32'hAAAAAAAA;   operand_b = 32'h55555555;
        check_xor(32'hFFFFFFFF);                               // bit xen ke -> all 1

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFF;
        check_xor(32'd0);                                      // x ^ x = 0

        operand_a = 32'h12345678;   operand_b = 32'h00000000;
        check_xor(32'h12345678);                               // x ^ 0 = x

        operand_a = 32'h00000000;   operand_b = 32'h00000000;
        check_xor(32'd0);                                      // 0 ^ 0 = 0

        operand_a = 32'hDEADBEEF;   operand_b = 32'hFFFFFFFF;
        check_xor(32'h21524110);                               // x ^ 0xFFFFFFFF = ~x

        operand_a = 32'hA5A5A5A5;   operand_b = 32'h5A5A5A5A;
        check_xor(32'hFFFFFFFF);                               // xen ke nguoc -> all 1

        operand_a = 32'h12345678;   operand_b = 32'h12345678;
        check_xor(32'd0);                                      // x ^ x = 0 (gia tri bat ky)

        // SRL  (alu_sel = 4'b0110)
        $display("\n--- SRL (rs1 >> rs2[4:0], zero-fill) ---");
        alu_sel = 4'b0110;

        operand_a = 32'h80000000;   operand_b = 32'd1;
        check_srl(32'h40000000);                               // 0x80000000 >> 1 = 0x40000000

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd4;
        check_srl(32'h0FFFFFFF);                               // 0xFFFFFFFF >> 4 = 0x0FFFFFFF

        operand_a = 32'h00000010;   operand_b = 32'd4;
        check_srl(32'h00000001);                               // 16 >> 4 = 1

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd0;
        check_srl(32'hFFFFFFFF);                               // shift 0 -> giu nguyen

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd31;
        check_srl(32'h00000001);                               // >> 31 -> chi con bit cao nhat

        operand_a = 32'h80000000;   operand_b = 32'd31;
        check_srl(32'h00000001);                               // 0x80000000 >> 31 = 1

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd32;
        check_srl(32'hFFFFFFFF);                               // rs2[4:0]=0 -> shift 0

        operand_a = 32'h00000000;   operand_b = 32'd15;
        check_srl(32'h00000000);                               // 0 >> bat ky = 0

        // SRA  (alu_sel = 4'b0111)
        $display("\n--- SRA (rs1 >>> rs2[4:0], sign-fill) ---");
        alu_sel = 4'b0111;

        operand_a = 32'h80000000;   operand_b = 32'd1;
        check_sra(32'hC0000000);                               // -2147483648 >>> 1 = -1073741824

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd4;
        check_sra(32'hFFFFFFFF);                               // -1 >>> 4 = -1

        operand_a = 32'h7FFFFFFF;   operand_b = 32'd1;
        check_sra(32'h3FFFFFFF);                               // 2147483647 >>> 1 = 1073741823

        operand_a = 32'd16;         operand_b = 32'd2;
        check_sra(32'd4);                                      // 16 >>> 2 = 4

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd31;
        check_sra(32'hFFFFFFFF);                               // -1 >>> 31 = -1

        operand_a = 32'h80000000;   operand_b = 32'd31;
        check_sra(32'hFFFFFFFF);                               // min_int >>> 31 = -1

        operand_a = 32'hFFFFFFFF;   operand_b = 32'd0;
        check_sra(32'hFFFFFFFF);                               // shift 0 -> giu nguyen

        operand_a = 32'h7FFFFFFF;   operand_b = 32'd31;
        check_sra(32'h00000000);                               // max_int >>> 31 = 0

        operand_a = 32'hFFFFFFF0;   operand_b = 32'd4;
        check_sra(32'hFFFFFFFF);                               // -16 >>> 4 = -1

        // OR   (alu_sel = 4'b1000)
        $display("\n--- OR (rs1 | rs2) ---");
        alu_sel = 4'b1000;

        operand_a = 32'hAAAAAAAA;   operand_b = 32'h55555555;
        check_or(32'hFFFFFFFF);                                // bit xen ke -> all 1

        operand_a = 32'h00000000;   operand_b = 32'h12345678;
        check_or(32'h12345678);                                // 0 | x = x

        operand_a = 32'd0;          operand_b = 32'd0;
        check_or(32'd0);                                       // 0 | 0 = 0

        operand_a = 32'hFFFFFFFF;   operand_b = 32'h00000000;
        check_or(32'hFFFFFFFF);                                // all1 | 0 = all1

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFF;
        check_or(32'hFFFFFFFF);                                // all1 | all1 = all1

        operand_a = 32'h0F0F0F0F;   operand_b = 32'hF0F0F0F0;
        check_or(32'hFFFFFFFF);                                // bo sung nhau -> all 1

        operand_a = 32'h12345678;   operand_b = 32'h12345678;
        check_or(32'h12345678);                                // x | x = x

        // AND  (alu_sel = 4'b1001)
        $display("\n--- AND (rs1 & rs2) ---");
        alu_sel = 4'b1001;

        operand_a = 32'hFFFFFFFF;   operand_b = 32'h0F0F0F0F;
        check_and(32'h0F0F0F0F);                               // all1 & x = x

        operand_a = 32'hAAAAAAAA;   operand_b = 32'h55555555;
        check_and(32'd0);                                      // khong co bit chung -> 0

        operand_a = 32'hFFFFFFFF;   operand_b = 32'hFFFFFFFF;
        check_and(32'hFFFFFFFF);                               // all1 & all1 = all1

        operand_a = 32'h00000000;   operand_b = 32'hFFFFFFFF;
        check_and(32'h00000000);                               // 0 & x = 0

        operand_a = 32'hFFFFFFFF;   operand_b = 32'h00000000;
        check_and(32'h00000000);                               // x & 0 = 0

        operand_a = 32'h12345678;   operand_b = 32'h12345678;
        check_and(32'h12345678);                               // x & x = x

        operand_a = 32'hDEADBEEF;   operand_b = 32'h0000FFFF;
        check_and(32'h0000BEEF);                               // mask lay 16 bit thap

        operand_a = 32'hDEADBEEF;   operand_b = 32'hFFFF0000;
        check_and(32'hDEAD0000);                               // mask lay 16 bit cao

        // DEFAULT (alu_sel chua dinh nghia -> result = 0)
        $display("\n--- DEFAULT (alu_sel khong hop le -> 0) ---");
        operand_a = 32'hDEADBEEF;   operand_b = 32'hCAFEBABE;

        alu_sel = 4'b1010;
        test_num = test_num + 1; #1;
        if (result === 32'h0) begin
            $display("[PASS] Test %02d | DEF  | alu_sel=1010 -> result = 0", test_num);
            pass_cnt = pass_cnt + 1;
        end else begin
            $display("[FAIL] Test %02d | DEF  | alu_sel=1010 -> %08h  (expected 0)", test_num, result);
            fail_cnt = fail_cnt + 1;
        end

        alu_sel = 4'b1111;
        test_num = test_num + 1; #1;
        if (result === 32'h0) begin
            $display("[PASS] Test %02d | DEF  | alu_sel=1111 -> result = 0", test_num);
            pass_cnt = pass_cnt + 1;
        end else begin
            $display("[FAIL] Test %02d | DEF  | alu_sel=1111 -> %08h  (expected 0)", test_num, result);
            fail_cnt = fail_cnt + 1;
        end

        // Summary
        $display("\n===========================================================");
        $display("  Tong so test: %0d  |  PASS: %0d  |  FAIL: %0d",
                 pass_cnt + fail_cnt, pass_cnt, fail_cnt);
        $stop;
    end

endmodule