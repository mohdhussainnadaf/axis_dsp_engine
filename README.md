cat << 'EOF' > README.md
# AXIS-Driven Digital Signal Processing & Logic Engine

A parameterizable **AXI4-Stream Digital Signal Processing (DSP) Acceleration Engine** designed in SystemVerilog. Features a multi-stage Configurable FIR Filter paired with pipelined Multiply-Accumulate (MAC) units targeted for high-throughput FPGA fabrics.

## Key Features
- **AXI4-Stream Data Pipeline:** Single-cycle throughput interface (`tdata`, `tvalid`, `tready`).
- **Pipelined MAC Blocks:** Optimized structure targeting DSP block primitives.
- **Automated Verification:** Self-checking SystemVerilog testbench driven by a Python regression runner.

## Directory Structure
- `rtl/` - SystemVerilog package, MAC core, and top-level AXI-Stream filter module.
- `tb/` - Self-checking SystemVerilog testbench.
- `scripts/` - Python regression suite (`run_regression.py`).

## Verification
Run the automated verification suite using Icarus Verilog:
```bash
python3 scripts/run_regression.py
