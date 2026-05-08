# Cách chạy dự án

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
