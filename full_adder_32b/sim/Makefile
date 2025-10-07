# Đường dẫn
RTL_DIR = ../rtl
TB_DIR  = ../tb

# Lấy tất cả file Verilog trong thư mục
RTL_FILES = $(wildcard $(RTL_DIR)/*.v)
TB_FILES  = $(wildcard $(TB_DIR)/*.v)

# Thư viện làm việc
WORK = work

# Top module testbench (có thể override khi chạy make)
TOP ?= full_adder_tb

.PHONY: all build run clean

all: build run

# Tạo thư viện và compile RTL + TB
build:
	@echo ">>> Creating library and compiling..."
	vlib $(WORK) || true
	vlog $(RTL_FILES) $(TB_FILES)

# Run simulation
run:
	@echo ">>> Running simulation with top=$(TOP)..."
	vsim -c -do "run -all; quit" $(TOP)

# Xóa file sinh ra
clean:
	@echo ">>> Cleaning simulation files..."
	rm -rf $(WORK) transcript vsim.wlf *.log

