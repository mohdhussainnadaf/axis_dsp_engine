#!/usr/bin/env python3
import subprocess
import sys

def run():
    print("=== Running SystemVerilog Simulation ===")
    compile_cmd = "iverilog -g2012 -o build/sim.out rtl/dsp_pkg.sv rtl/mac_unit.sv rtl/axis_fir_engine.sv tb/tb_axis_fir_engine.sv"
    res = subprocess.run(compile_cmd, shell=True, capture_output=True, text=True)
    if res.returncode != 0:
        print(f"[FAIL] Compilation Error:\n{res.stderr}")
        sys.exit(1)
    
    sim_cmd = "vvp build/sim.out"
    res = subprocess.run(sim_cmd, shell=True, capture_output=True, text=True)
    print(res.stdout)
    if "SUCCESS" in res.stdout:
        print("[PASS] Verification Suite Completed Successfully!")

if __name__ == "__main__":
    run()
