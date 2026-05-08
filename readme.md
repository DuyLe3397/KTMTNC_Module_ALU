# ALU RISC-V RV32I — Hướng dẫn chạy

## Yêu cầu

- [Icarus Verilog](http://iverilog.icarus.com/) (iverilog + vvp)

---

## Cài đặt Icarus Verilog

**Windows:**
Tải installer tại: https://bleyer.org/icarus/

**Kiểm tra cài đặt:**

```bash
iverilog -v
```

---

## Cấu trúc thư mục

```
.
├── alu.v        # Module ALU chính
├── alu_tb.v     # Testbench
└── README.md
```

---

## Cách chạy

**Bước 1 — Compile:**

```bash
iverilog -o alu_sim alu.v alu_tb.v
```

**Bước 2 — Chạy mô phỏng:**

```bash
vvp alu_sim
```

## Các phép tính

| alu_sel | Phép tính | Mô tả                        |
| ------- | --------- | ---------------------------- |
| `0000`  | ADD       | rs1 + rs2                    |
| `0001`  | SUB       | rs1 - rs2                    |
| `0010`  | SLL       | rs1 << rs2[4:0]              |
| `0011`  | SLT       | (rs1 < rs2) signed ? 1 : 0   |
| `0100`  | SLTU      | (rs1 < rs2) unsigned ? 1 : 0 |
| `0101`  | XOR       | rs1 ^ rs2                    |
| `0110`  | SRL       | rs1 >> rs2[4:0] (zero-fill)  |
| `0111`  | SRA       | rs1 >>> rs2[4:0] (sign-fill) |
| `1000`  | OR        | rs1 \| rs2                   |
| `1001`  | AND       | rs1 & rs2                    |
