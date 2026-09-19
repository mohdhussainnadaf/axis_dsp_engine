package dsp_pkg;
    parameter int DATA_WIDTH  = 16;
    parameter int COEFF_WIDTH = 16;
    parameter int NUM_TAPS    = 8;
    parameter int ACC_WIDTH   = 40;

    typedef struct packed {
        logic          enable;
        logic          soft_reset;
        logic [3:0]    filter_mode;
        logic [15:0]   gain_scaler;
    } ctrl_reg_t;
endpackage : dsp_pkg
