`timescale 1ns / 1ps
import dsp_pkg::*;

module mac_unit #(
    parameter int A_WIDTH   = DATA_WIDTH,
    parameter int B_WIDTH   = COEFF_WIDTH,
    parameter int OUT_WIDTH = ACC_WIDTH
)(
    input  logic                      clk,
    input  logic                      srst,
    input  logic                      en,
    input  logic signed [A_WIDTH-1:0]   a_in,
    input  logic signed [B_WIDTH-1:0]   b_in,
    input  logic signed [OUT_WIDTH-1:0] accum_in,
    output logic signed [OUT_WIDTH-1:0] accum_out
);
    logic signed [A_WIDTH-1:0]         a_reg;
    logic signed [B_WIDTH-1:0]         b_reg;
    logic signed [A_WIDTH+B_WIDTH-1:0] mult_reg;

    always_ff @(posedge clk) begin
        if (srst) begin
            a_reg     <= '0;
            b_reg     <= '0;
            mult_reg  <= '0;
            accum_out <= '0;
        end else if (en) begin
            a_reg     <= a_in;
            b_reg     <= b_in;
            mult_reg  <= a_reg * b_reg;
            accum_out <= accum_in + mult_reg;
        end
    end
endmodule
