module io_pad_wrapper (clk,
    core_din,
    core_dout,
    pad_din_raw,
    pad_dout,
    pad_oe,
    pad_pd_en,
    pad_pu_en,
    pad_schmitt_en,
    reg_we,
    rst_n,
    pad_slew,
    reg_addr,
    reg_rdata,
    reg_wdata);
 input clk;
 output core_din;
 input core_dout;
 input pad_din_raw;
 output pad_dout;
 output pad_oe;
 output pad_pd_en;
 output pad_pu_en;
 output pad_schmitt_en;
 input reg_we;
 input rst_n;
 output [1:0] pad_slew;
 input [1:0] reg_addr;
 output [7:0] reg_rdata;
 input [7:0] reg_wdata;

 wire _00_;
 wire _01_;
 wire _02_;
 wire _03_;
 wire _04_;
 wire _05_;
 wire _06_;
 wire _07_;
 wire _08_;
 wire _09_;
 wire _10_;
 wire _11_;
 wire _12_;
 wire _13_;
 wire ie;
 wire loopback_en;
 wire sync_ff1;
 wire clknet_0_clk;
 wire clknet_1_0__leaf_clk;
 wire clknet_1_1__leaf_clk;

 sky130_fd_sc_hd__nor2_2 _14_ (.A(reg_addr[1]),
    .B(reg_addr[0]),
    .Y(_10_));
 sky130_fd_sc_hd__and2b_2 _15_ (.A_N(reg_addr[1]),
    .B(reg_addr[0]),
    .X(_11_));
 sky130_fd_sc_hd__a22o_2 _16_ (.A1(pad_oe),
    .A2(_10_),
    .B1(_11_),
    .B2(pad_din_raw),
    .X(reg_rdata[0]));
 sky130_fd_sc_hd__a22o_2 _17_ (.A1(pad_pu_en),
    .A2(_10_),
    .B1(_11_),
    .B2(core_din),
    .X(reg_rdata[1]));
 sky130_fd_sc_hd__and2_2 _18_ (.A(pad_pd_en),
    .B(_10_),
    .X(reg_rdata[2]));
 sky130_fd_sc_hd__and2_2 _19_ (.A(pad_slew[0]),
    .B(_10_),
    .X(reg_rdata[3]));
 sky130_fd_sc_hd__and2_2 _20_ (.A(pad_slew[1]),
    .B(_10_),
    .X(reg_rdata[4]));
 sky130_fd_sc_hd__and2_2 _21_ (.A(ie),
    .B(_10_),
    .X(reg_rdata[5]));
 sky130_fd_sc_hd__and2_2 _22_ (.A(pad_schmitt_en),
    .B(_10_),
    .X(reg_rdata[6]));
 sky130_fd_sc_hd__and2_2 _23_ (.A(loopback_en),
    .B(_10_),
    .X(reg_rdata[7]));
 sky130_fd_sc_hd__and2_2 _24_ (.A(ie),
    .B(sync_ff1),
    .X(_00_));
 sky130_fd_sc_hd__mux2_1 _25_ (.A0(pad_din_raw),
    .A1(core_dout),
    .S(loopback_en),
    .X(_12_));
 sky130_fd_sc_hd__and2_2 _26_ (.A(ie),
    .B(_12_),
    .X(_01_));
 sky130_fd_sc_hd__or3b_2 _27_ (.A(reg_addr[1]),
    .B(reg_addr[0]),
    .C_N(reg_we),
    .X(_13_));
 sky130_fd_sc_hd__mux2_1 _28_ (.A0(reg_wdata[0]),
    .A1(pad_oe),
    .S(_13_),
    .X(_02_));
 sky130_fd_sc_hd__mux2_1 _29_ (.A0(reg_wdata[1]),
    .A1(pad_pu_en),
    .S(_13_),
    .X(_03_));
 sky130_fd_sc_hd__mux2_1 _30_ (.A0(reg_wdata[2]),
    .A1(pad_pd_en),
    .S(_13_),
    .X(_04_));
 sky130_fd_sc_hd__mux2_1 _31_ (.A0(reg_wdata[3]),
    .A1(pad_slew[0]),
    .S(_13_),
    .X(_05_));
 sky130_fd_sc_hd__mux2_1 _32_ (.A0(reg_wdata[4]),
    .A1(pad_slew[1]),
    .S(_13_),
    .X(_06_));
 sky130_fd_sc_hd__mux2_1 _33_ (.A0(reg_wdata[5]),
    .A1(ie),
    .S(_13_),
    .X(_07_));
 sky130_fd_sc_hd__mux2_1 _34_ (.A0(reg_wdata[6]),
    .A1(pad_schmitt_en),
    .S(_13_),
    .X(_08_));
 sky130_fd_sc_hd__mux2_1 _35_ (.A0(reg_wdata[7]),
    .A1(loopback_en),
    .S(_13_),
    .X(_09_));
 sky130_fd_sc_hd__dfrtp_2 _36_ (.CLK(clknet_1_1__leaf_clk),
    .D(_02_),
    .RESET_B(rst_n),
    .Q(pad_oe));
 sky130_fd_sc_hd__dfrtp_2 _37_ (.CLK(clknet_1_0__leaf_clk),
    .D(_03_),
    .RESET_B(rst_n),
    .Q(pad_pu_en));
 sky130_fd_sc_hd__dfrtp_2 _38_ (.CLK(clknet_1_0__leaf_clk),
    .D(_04_),
    .RESET_B(rst_n),
    .Q(pad_pd_en));
 sky130_fd_sc_hd__dfrtp_2 _39_ (.CLK(clknet_1_0__leaf_clk),
    .D(_05_),
    .RESET_B(rst_n),
    .Q(pad_slew[0]));
 sky130_fd_sc_hd__dfrtp_2 _40_ (.CLK(clknet_1_1__leaf_clk),
    .D(_06_),
    .RESET_B(rst_n),
    .Q(pad_slew[1]));
 sky130_fd_sc_hd__dfrtp_2 _41_ (.CLK(clknet_1_1__leaf_clk),
    .D(_07_),
    .RESET_B(rst_n),
    .Q(ie));
 sky130_fd_sc_hd__dfrtp_2 _42_ (.CLK(clknet_1_1__leaf_clk),
    .D(_08_),
    .RESET_B(rst_n),
    .Q(pad_schmitt_en));
 sky130_fd_sc_hd__dfrtp_2 _43_ (.CLK(clknet_1_0__leaf_clk),
    .D(_09_),
    .RESET_B(rst_n),
    .Q(loopback_en));
 sky130_fd_sc_hd__dfrtp_2 _44_ (.CLK(clknet_1_1__leaf_clk),
    .D(_00_),
    .RESET_B(rst_n),
    .Q(core_din));
 sky130_fd_sc_hd__dfrtp_2 _45_ (.CLK(clknet_1_1__leaf_clk),
    .D(_01_),
    .RESET_B(rst_n),
    .Q(sync_ff1));
 sky130_fd_sc_hd__buf_2 _46_ (.A(core_dout),
    .X(pad_dout));
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_0_Right_0 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_1_Right_1 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_2_Right_2 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_3_Right_3 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_4_Right_4 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_5_Right_5 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_6_Right_6 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_7_Right_7 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_8_Right_8 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_9_Right_9 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_10_Right_10 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_0_Left_11 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_1_Left_12 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_2_Left_13 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_3_Left_14 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_4_Left_15 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_5_Left_16 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_6_Left_17 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_7_Left_18 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_8_Left_19 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_9_Left_20 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_10_Left_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_22 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_28 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_34 ();
 sky130_fd_sc_hd__clkbuf_16 clkbuf_0_clk (.A(clk),
    .X(clknet_0_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_1_0__f_clk (.A(clknet_0_clk),
    .X(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_1_1__f_clk (.A(clknet_0_clk),
    .X(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__clkbuf_8 clkload0 (.A(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__decap_6 FILLER_0_0_3 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_0_15 ();
 sky130_fd_sc_hd__decap_6 FILLER_0_0_29 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_0_46 ();
 sky130_fd_sc_hd__decap_6 FILLER_0_0_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_1_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_1_34 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_1_55 ();
 sky130_fd_sc_hd__decap_6 FILLER_0_1_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_2_3 ();
 sky130_fd_sc_hd__decap_8 FILLER_0_2_29 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_2_58 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_2_62 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_3_3 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_4_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_4_7 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_4_24 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_4_35 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_4_58 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_4_62 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_5_3 ();
 sky130_fd_sc_hd__decap_8 FILLER_0_5_48 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_6_3 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_6_29 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_6_61 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_7_3 ();
 sky130_fd_sc_hd__decap_6 FILLER_0_8_3 ();
 sky130_ef_sc_hd__decap_12 FILLER_0_8_15 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_8_27 ();
 sky130_fd_sc_hd__decap_8 FILLER_0_8_29 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_8_58 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_8_62 ();
 sky130_fd_sc_hd__decap_6 FILLER_0_9_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_9_9 ();
 sky130_ef_sc_hd__decap_12 FILLER_0_9_14 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_9_55 ();
 sky130_fd_sc_hd__decap_6 FILLER_0_9_57 ();
 sky130_ef_sc_hd__decap_12 FILLER_0_10_3 ();
 sky130_ef_sc_hd__decap_12 FILLER_0_10_15 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_10_27 ();
 sky130_ef_sc_hd__decap_12 FILLER_0_10_29 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_10_41 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_10_45 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_10_55 ();
 sky130_fd_sc_hd__decap_6 FILLER_0_10_57 ();
endmodule
