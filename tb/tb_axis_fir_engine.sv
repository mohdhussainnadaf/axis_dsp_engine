`timescale 1ns / 1ps
import dsp_pkg::*;

module tb_axis_fir_engine;
    logic clk = 0;
    logic rst_n = 0;

    ctrl_reg_t ctrl_reg;
    logic signed [COEFF_WIDTH-1:0] coeffs [NUM_TAPS];

    logic [DATA_WIDTH-1:0] s_axis_tdata = 0;
    logic                  s_axis_tvalid = 0;
    logic                  s_axis_tready;

    logic [DATA_WIDTH-1:0] m_axis_tdata;
    logic                  m_axis_tvalid;
    logic                  m_axis_tready = 1;

    always #5 clk = ~clk;

    axis_fir_engine #(.TAPS(NUM_TAPS)) dut (
        .clk(clk), .rst_n(rst_n), .ctrl_reg(ctrl_reg), .coeffs(coeffs),
        .s_axis_tdata(s_axis_tdata), .s_axis_tvalid(s_axis_tvalid), .s_axis_tready(s_axis_tready),
        .m_axis_tdata(m_axis_tdata), .m_axis_tvalid(m_axis_tvalid), .m_axis_tready(m_axis_tready)
    );

    initial begin
        $dumpfile("sim_output.vcd");
        $dumpvars(0, tb_axis_fir_engine);

        ctrl_reg.enable = 1'b1;
        ctrl_reg.soft_reset = 1'b0;
        ctrl_reg.filter_mode = 4'h1;
        ctrl_reg.gain_scaler = 16'h1000;

        coeffs[0] = 16'sh0100; coeffs[1] = 16'sh0400;
        coeffs[2] = 16'sh0C00; coeffs[3] = 16'sh1000;
        coeffs[4] = 16'sh1000; coeffs[5] = 16'sh0C00;
        coeffs[6] = 16'sh0400; coeffs[7] = 16'sh0100;

        #20 rst_n = 1;
        #10;
        
        $display("[TB] Sending Impulse Sample...");
        @(posedge clk);
        s_axis_tdata <= 16'sh2000;
        s_axis_tvalid <= 1'b1;
        @(posedge clk);
        s_axis_tvalid <= 1'b0;

        #200;
        $display("[TB] SUCCESS: Test completed.");
        $finish;
    end

    always @(posedge clk) begin
        if (m_axis_tvalid && m_axis_tready) begin
            $display("[MONITOR] Output Data = 0x%0h", m_axis_tdata);
        end
    end
endmodule
