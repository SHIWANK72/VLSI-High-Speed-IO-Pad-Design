// ============================================================
// io_pad_wrapper.v
// Digital control wrapper for High-Speed I/O Pad
// Shiwank Gupta | Nik-Coronics | Phase 2
//
// Function:
//   - Holds OE / PU_EN / PD_EN / SLEW / IE / SCHMITT_EN /
//     LOOPBACK_EN configuration via a simple register-write
//     interface
//   - Synchronizes the raw pad input (async, off-chip) into
//     the core clock domain via a 2-flop synchronizer
//   - Supports input-path power gating (IE) and an internal
//     loopback self-test mode (LOOPBACK_EN) for DFT
//   - Forwards core output data + control signals to the
//     analog IO cell (ESD clamp + driver chain, Magic layout)
//
// Register Map (reg_addr):
//   0x0 : CTRL   [0]   = OE
//                [1]   = PU_EN
//                [2]   = PD_EN
//                [4:3] = SLEW        (00=slowest ... 11=fastest)
//                [5]   = IE          (input path enable)
//                [6]   = SCHMITT_EN  (input hysteresis enable)
//                [7]   = LOOPBACK_EN (DFT self-test loopback)
//   0x1 : STATUS (read-only)
//                [0]   = pad_din_raw (live, unsynchronized)
//                [1]   = core_din    (synchronized)
// ============================================================

module io_pad_wrapper (
    input  wire       clk,
    input  wire       rst_n,

    // --- Simple register interface (core side) ---
    input  wire        reg_we,
    input  wire [1:0]  reg_addr,
    input  wire [7:0]  reg_wdata,
    output reg  [7:0]  reg_rdata,

    // --- Core-side data path ---
    input  wire        core_dout,   // data core wants to drive on pad
    output reg          core_din,   // synchronized data received from pad

    // --- Analog IO cell side (to ESD clamp + driver chain macro) ---
    output wire        pad_oe,         // output enable -> driver chain tri-state
    output wire        pad_pu_en,      // pull-up enable -> analog pad cell
    output wire        pad_pd_en,      // pull-down enable -> analog pad cell
    output wire [1:0]  pad_slew,       // slew-rate select -> driver stage strength mux
    output wire        pad_schmitt_en, // input hysteresis enable -> analog input buffer
    output wire        pad_dout,       // data forwarded to driver chain input
    input  wire        pad_din_raw    // raw (async) signal from ESD clamp node
);

    // ------------------------------------------------------------
    // Control register (8 bits, single word):
    //   [0]=OE  [1]=PU_EN  [2]=PD_EN  [4:3]=SLEW
    //   [5]=IE  [6]=SCHMITT_EN  [7]=LOOPBACK_EN
    // ------------------------------------------------------------
    reg [7:0] ctrl_reg;

    localparam ADDR_CTRL   = 2'b00;
    localparam ADDR_STATUS = 2'b01;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ctrl_reg <= 8'h00; // default: input mode, no pulls, slowest slew,
                                // input path disabled, schmitt off, no loopback
        end else if (reg_we && (reg_addr == ADDR_CTRL)) begin
            ctrl_reg <= reg_wdata;
        end
    end

    assign pad_oe         = ctrl_reg[0];
    assign pad_pu_en      = ctrl_reg[1];
    assign pad_pd_en      = ctrl_reg[2];
    assign pad_slew       = ctrl_reg[4:3];
    wire   ie             = ctrl_reg[5];
    assign pad_schmitt_en = ctrl_reg[6];
    wire   loopback_en    = ctrl_reg[7];

    // ------------------------------------------------------------
    // Register readback
    // ------------------------------------------------------------
    always @(*) begin
        case (reg_addr)
            ADDR_CTRL:   reg_rdata = ctrl_reg;
            ADDR_STATUS: reg_rdata = {6'b0, core_din, pad_din_raw};
            default:     reg_rdata = 8'h00;
        endcase
    end

    // ------------------------------------------------------------
    // Output path: core drives pad only when OE = 1
    // ------------------------------------------------------------
    assign pad_dout = core_dout;

    // ------------------------------------------------------------
    // Input path: 2-flop synchronizer, with:
    //   - IE gating (power-down: holds synchronizer at 0 when IE=0)
    //   - LOOPBACK_EN: routes core_dout back into the synchronizer
    //     input instead of the real pad signal, for DFT self-test
    //     of the digital data path without the analog macro
    // ------------------------------------------------------------
    reg  sync_ff1;
    wire pad_din_effective = loopback_en ? core_dout : pad_din_raw;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff1 <= 1'b0;
            core_din <= 1'b0;
        end else if (!ie) begin
            sync_ff1 <= 1'b0;
            core_din <= 1'b0;
        end else begin
            sync_ff1 <= pad_din_effective;
            core_din <= sync_ff1;
        end
    end

endmodule