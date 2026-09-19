`timescale 1ns / 1ps
import dsp_pkg::*;

module axis_fir_engine #(
    parameter int TAPS = NUM_TAPS
)(
    input  logic                     clk,
    input  logic                     rst_n,
    input  ctrl_reg_t                ctrl_reg,
    input  logic signed [COEFF_WIDTH-1:0] coeffs [TAPS],

    input  logic [DATA_WIDTH-1:0]    s_axis_tdata,
    input  logic                     s_axis_tvalid,
    output logic                     s_axis_tready,

    output logic [DATA_WIDTH-1:0]    m_axis_tdata,
    output logic                     m_axis_tvalid,
    input  logic                     m_axis_tready
);
    logic signed [DATA_WIDTH-1:0] delay_line [TAPS];
    logic signed [ACC_WIDTH-1:0]  accum_chain [TAPS+1];

    assign s_axis_tready = m_axis_tready || !m_axis_tvalid;
    assign accum_chain[0] = '0;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < TAPS; i++) delay_line[i] <= '0;
        end else if (ctrl_reg.soft_reset) begin
            for (int i = 0; i < TAPS; i++) delay_line[i] <= '0;
        end else if (s_axis_tvalid && s_axis_tready && ctrl_reg.enable) begin
            delay_line[0] <= $signed(s_axis_tdata);
            for (int i = 1; i < TAPS; i++) delay_line[i] <= delay_line[i-1];
        end
    end

    genvar g_i;
    generate
        for (g_i = 0; g_i < TAPS; g_i++) begin : gen_mac_pipeline
            mac_unit #(
                .A_WIDTH(DATA_WIDTH),
                .B_WIDTH(COEFF_WIDTH),
                .OUT_WIDTH(ACC_WIDTH)
            ) u_mac (
                .clk      (clk),
                .srst     (!rst_n || ctrl_reg.soft_reset),
                .en       (s_axis_tvalid && s_axis_tready && ctrl_reg.enable),
                .a_in     (delay_line[g_i]),
                .b_in     (coeffs[g_i]),
                .accum_in (accum_chain[g_i]),
                .accum_out(accum_chain[g_i+1])
            );
        end
    endgenerate

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            m_axis_tvalid <= 1'b0;
            m_axis_tdata  <= '0;
        end else begin
            if (s_axis_tvalid && s_axis_tready && ctrl_reg.enable) begin
                m_axis_tvalid <= 1'b1;
                m_axis_tdata  <= accum_chain[TAPS][ACC_WIDTH-1 -: DATA_WIDTH];
            end else if (m_axis_tready) begin
                m_axis_tvalid <= 1'b0;
            end
        end
    end
endmodule
