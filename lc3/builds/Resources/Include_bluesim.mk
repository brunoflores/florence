# This file is not a standalone Makefile, but 'include'd by other Makefiles

# ================================================================
# Compile Bluesim intermediate files from BSV sources

TMP_DIRS = -bdir build_dir -simdir build_dir -info-dir build_dir

build_dir:
	mkdir -p $@

.PHONY: compile
compile: build_dir
	@echo "INFO: Re-compiling Core"
	bsc -u -elab -sim $(TMP_DIRS) $(BSC_COMPILATION_FLAGS) \
		-p $(BSC_PATH) $(TOPFILE)
	@echo "INFO: Re-compiled  Core"

# ================================================================
# Compile and link Bluesim intermediate files into a Bluesim executable

SIM_EXE_FILE = exe_HW_sim

BSC_C_FLAGS += \
	-Xl -v \
	-Xc -O3 -Xc++ -O3

.PHONY: simulator
simulator:
	@echo "INFO: linking bsc-compiled objects into Bluesim executable"
	bsc -sim -parallel-sim-link 8 \
		$(TMP_DIRS) \
		-e $(TOPMODULE) -o ./$(SIM_EXE_FILE) \
		$(BSC_C_FLAGS) \
		$(REPO)/src_Testbench/Top/C_Imported_Functions.c
	@echo "INFO: linked bsc-compiled objects into Bluesim executable"