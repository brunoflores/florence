# This file is not a standalone Makefile, but 'include'd by other Makefiles

.PHONY: all
all: compile simulator

# ================================================================
# Search path for bsc for .bsv files

CORE_DIRS = $(REPO)/core:$(REPO)/core/lib

TESTBENCH_DIRS = $(REPO)/testbench/Top:$(REPO)/testbench/SoC

BSC_PATH = $(CORE_DIRS):$(TESTBENCH_DIRS):+

# ================================================================
# Top-level file and module

TOPFILE ?= $(REPO)/testbench/Top/Top_HW_Side.bsv
TOPMODULE ?= mkTop_HW_Side

# ================================================================
# bsc compilation flags

BSC_COMPILATION_FLAGS += \
	-keep-fires -aggressive-conditions -no-warn-action-shadowing \
	-no-show-timestamps -check-assert \
	-suppress-warnings G0020 \
	+RTS -K128M -RTS -show-range-conflict

# ================================================================
# Runs simulation executable on ELF given by EXAMPLE

# TESTS_DIR ?= $(REPO)/Tests
# VERBOSITY ?= +v1
#
# EXAMPLE ?= PLEASE_DEFINE_EXAMPLE_PATH_TO_ELF
#
# .PHONY: run_example
# run_example:
# 	make -C $(TESTS_DIR)/elf_to_hex
# 	$(TESTS_DIR)/elf_to_hex/elf_to_hex $(EXAMPLE) Mem.hex
# 	./exe_HW_sim $(VERBOSITY) +tohost

# ================================================================
# Test: run the executable on the standard RISCV ISA test specified in TEST

# .PHONY: test
# test:
# 	make -C $(TESTS_DIR)/elf_to_hex
# 	$(TESTS_DIR)/elf_to_hex/elf_to_hex $(TESTS_DIR)/isa/$(TEST) Mem.hex
# 	./exe_HW_sim $(VERBOSITY) +tohost

# ================================================================

# .PHONY: clean
# clean:
# 	rm -r -f *~ Makefile_* symbol_table.txt build_dir obj_dir
#
# .PHONY: full_clean
# full_clean: clean
# 	rm -r -f $(SIM_EXE_FILE)* *.log *.vcd *.hex Logs/
