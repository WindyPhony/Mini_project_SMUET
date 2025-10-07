# Đường dẫn
RTL_DIR = ../rtl
TB_DIR  = ../tb

# Lấy tất cả file Verilog trong hai thư mục
RTL_FILES = $(wildcard $(RTL_DIR)/*.v)
TB_FILES  = $(wildcard $(TB_DIR)/*.v)

# Thư viện làm việc
WORK = work

# Tìm dòng có 'module' trong file testbench, lấy tên sau 'module'
TOP := $(shell grep -hoP 'module\s+\K\w+' $(TB_DIR)/*.v | head -n 1)

.PHONY: all build run wave clean

# Mục tiêu mặc định
all: build run

# 1. Biên dịch RTL + Testbench
build:
	@echo "Creating library and compiling..."
	vlib $(WORK) || true
	vlog $(RTL_FILES) $(TB_FILES)

# 2. Chạy mô phỏng (có add wave)
run:
	@echo "Running simulation with top = $(TOP)..."
	vsim -c -wlf vsim.wlf $(TOP) -do "add wave -r /*; run -all"

# 3. Mở waveform
wave:
	vsim -view vsim.wlf &

# 4. Dọn file sinh ra
clean:
	@echo "Cleaning simulation files..."
	rm -rf $(WORK) transcript vsim.wlf *.log

