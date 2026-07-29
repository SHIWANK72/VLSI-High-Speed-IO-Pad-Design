// ============================================================
// tb_io_pad_wrapper.v
// Directed testbench for io_pad_wrapper
// Shiwank Gupta | Nik-Coronics | Phase 2
// ============================================================
`timescale 1ns/1ps

module tb_io_pad_wrapper;

    reg        clk;
    reg        rst_n;
    reg        reg_we;
    reg [1:0]  reg_addr;
    reg [7:0]  reg_wdata;
    wire [7:0] reg_rdata;

    reg        core_dout;
    wire       core_din;

    wire       pad_oe;
    wire       pad_pu_en;
    wire       pad_pd_en;
    wire [1:0] pad_slew;
    wire       pad_schmitt_en;
    wire       pad_dout;
    reg        pad_din_raw;

    integer errors = 0;
    integer test_num = 0;

    io_pad_wrapper dut (
        .clk(clk), .rst_n(rst_n),
        .reg_we(reg_we), .reg_addr(reg_addr), .reg_wdata(reg_wdata), .reg_rdata(reg_rdata),
        .core_dout(core_dout), .core_din(core_din),
        .pad_oe(pad_oe), .pad_pu_en(pad_pu_en), .pad_pd_en(pad_pd_en), .pad_slew(pad_slew),
        .pad_schmitt_en(pad_schmitt_en),
        .pad_dout(pad_dout), .pad_din_raw(pad_din_raw)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    task check(input cond, input [319:0] msg);
        begin
            test_num = test_num + 1;
            if (cond) $display("[PASS] Test %0d: %s", test_num, msg);
            else begin
                $display("[FAIL] Test %0d: %s", test_num, msg);
                errors = errors + 1;
            end
        end
    endtask

    task write_ctrl(input [7:0] val);
        begin
            @(negedge clk);
            reg_we = 1; reg_addr = 2'b00; reg_wdata = val;
            @(negedge clk);
            reg_we = 0;
        end
    endtask

    initial begin
        clk = 0; rst_n = 0;
        reg_we = 0; reg_addr = 0; reg_wdata = 0;
        core_dout = 0; pad_din_raw = 0;

        // --- Test 1: Reset behavior ---
        repeat (3) @(posedge clk);
        check(pad_oe == 0 && pad_pu_en == 0 && pad_pd_en == 0 &&
              pad_slew == 2'b00 && pad_schmitt_en == 0,
              "Reset: OE/PU_EN/PD_EN/SLEW/SCHMITT_EN all 0");

        rst_n = 1;
        @(posedge clk);

        // --- Test 2: Write CTRL = OE only ---
        write_ctrl(8'b0000_0001);
        check(pad_oe == 1 && pad_pu_en == 0 && pad_pd_en == 0,
              "CTRL write: OE=1, PU_EN=0, PD_EN=0");

        // --- Test 3: Write CTRL = OE + PU_EN + SLEW=10 ---
        write_ctrl(8'b0001_0011);
        check(pad_oe == 1 && pad_pu_en == 1 && pad_pd_en == 0 && pad_slew == 2'b10,
              "CTRL write: OE=1, PU_EN=1, PD_EN=0, SLEW=10");

        // --- Test 4: Register readback (STATUS ADDR reads CTRL correctly) ---
        @(negedge clk);
        reg_addr = 2'b00;
        #1;
        check(reg_rdata == 8'b0001_0011, "CTRL readback matches last write");

        // --- Test 5: SCHMITT_EN forwarding ---
        write_ctrl(8'b0100_0011); // SCHMITT_EN=1, PU_EN=1, OE=1
        check(pad_schmitt_en == 1, "SCHMITT_EN=1 correctly forwarded to pad_schmitt_en");

        // --- Test 6: Output data path (core_dout -> pad_dout) ---
        core_dout = 1;
        #1;
        check(pad_dout == 1, "core_dout=1 forwards to pad_dout");
        core_dout = 0;
        #1;
        check(pad_dout == 0, "core_dout=0 forwards to pad_dout");

        // --- Test 7: IE=0 gates input path (power-down, synchronizer forced 0) ---
        write_ctrl(8'b0000_0001); // OE=1, IE=0 (bit5=0)
        pad_din_raw = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        check(core_din == 0, "IE=0: core_din stays 0 even with pad_din_raw=1 (input gated)");

        // --- Test 8: IE=1 restores normal synchronizer operation ---
        write_ctrl(8'b0010_0001); // OE=1, IE=1 (bit5=1)
        pad_din_raw = 1;
        @(posedge clk); #1;
        check(core_din == 0, "IE=1: core_din still 0 after 1 clk (2-flop sync in progress)");
        @(posedge clk); #1;
        check(core_din == 1, "IE=1: core_din=1 after 2 clk (synchronizer settled)");

        pad_din_raw = 0;
        @(posedge clk); #1;
        @(posedge clk); #1;
        check(core_din == 0, "core_din returns to 0 after synchronizer settles");

        // --- Test 9: LOOPBACK_EN routes core_dout into synchronizer (DFT self-test) ---
        write_ctrl(8'b1010_0001); // OE=1, IE=1, LOOPBACK_EN=1
        pad_din_raw = 0;      // real pad signal held low - should be ignored
        core_dout = 1;        // core drives 1, should loop back through synchronizer
        @(posedge clk); #1;
        @(posedge clk); #1;
        check(core_din == 1, "LOOPBACK_EN=1: core_dout=1 loops back to core_din (pad_din_raw ignored)");

        core_dout = 0;
        @(posedge clk); #1;
        @(posedge clk); #1;
        check(core_din == 0, "LOOPBACK_EN=1: core_dout=0 loops back to core_din correctly");

        // --- Test 10: STATUS register reflects live pad_din_raw + core_din ---
        write_ctrl(8'b0010_0001); // disable loopback, IE=1, OE=1
        pad_din_raw = 1;
        @(posedge clk); #1; // sync_ff1 = 1
        @(posedge clk); #1; // core_din = 1
        reg_addr = 2'b01; // STATUS
        #1;
        check(reg_rdata[0] == 1 && reg_rdata[1] == 1,
              "STATUS register: bit0=pad_din_raw(1), bit1=core_din(1)");

        pad_din_raw = 0;
        @(posedge clk); #1;
        reg_addr = 2'b01;
        #1;
        check(reg_rdata[0] == 0, "STATUS register: bit0 tracks pad_din_raw live (0)");

        // --- Summary ---
        repeat (2) @(posedge clk);
        if (errors == 0)
            $display("\n===== ALL TESTS PASSED (%0d/%0d) =====\n", test_num, test_num);
        else
            $display("\n===== %0d/%0d TESTS FAILED =====\n", errors, test_num);

        $finish;
    end

endmodule