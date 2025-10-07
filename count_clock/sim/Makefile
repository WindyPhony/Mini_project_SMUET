# Detect RTL & TB files
RTL := $(wildcard ../rtl/*.v)
TB  := $(wildcard ../tb/*.v)
TOP := $(basename $(notdir $(firstword $(TB))))  # auto detect top tb module

.PHONY: all build sim run wave clean

all: build run

build:
	@echo ">>> Creating library and compiling..."
	@echo "RTL Files: $(RTL)"
	@echo "TB Files:  $(TB)"
	vlib work
	vlog $(RTL) $(TB)

run sim:
	@echo ">>> Running simulation (console mode)..."
	vsim -c -do "run -all; quit" $(TOP)
wave:
	@echo ">>> Launching ModelSim GUI and running simulation..."
	vsim -voptargs=+acc $(TOP) -do "add wave -r /*; run -all"

clean:
	@echo ">>> Cleaning simulation files..."
	rm -rf work transcript vsim.wlf *.log
