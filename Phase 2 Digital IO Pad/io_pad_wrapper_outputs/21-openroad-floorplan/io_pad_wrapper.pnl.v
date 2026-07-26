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
 wire VPWR;
 wire VGND;

 sky130_fd_sc_hd__nor2_2 _14_ (.A(reg_addr[1]),
    .B(reg_addr[0]),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(_10_));
 sky130_fd_sc_hd__and2b_2 _15_ (.A_N(reg_addr[1]),
    .B(reg_addr[0]),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_11_));
 sky130_fd_sc_hd__a22o_2 _16_ (.A1(pad_oe),
    .A2(_10_),
    .B1(_11_),
    .B2(pad_din_raw),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(reg_rdata[0]));
 sky130_fd_sc_hd__a22o_2 _17_ (.A1(pad_pu_en),
    .A2(_10_),
    .B1(_11_),
    .B2(core_din),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(reg_rdata[1]));
 sky130_fd_sc_hd__and2_2 _18_ (.A(pad_pd_en),
    .B(_10_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(reg_rdata[2]));
 sky130_fd_sc_hd__and2_2 _19_ (.A(pad_slew[0]),
    .B(_10_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(reg_rdata[3]));
 sky130_fd_sc_hd__and2_2 _20_ (.A(pad_slew[1]),
    .B(_10_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(reg_rdata[4]));
 sky130_fd_sc_hd__and2_2 _21_ (.A(ie),
    .B(_10_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(reg_rdata[5]));
 sky130_fd_sc_hd__and2_2 _22_ (.A(pad_schmitt_en),
    .B(_10_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(reg_rdata[6]));
 sky130_fd_sc_hd__and2_2 _23_ (.A(loopback_en),
    .B(_10_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(reg_rdata[7]));
 sky130_fd_sc_hd__and2_2 _24_ (.A(ie),
    .B(sync_ff1),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_00_));
 sky130_fd_sc_hd__mux2_1 _25_ (.A0(pad_din_raw),
    .A1(core_dout),
    .S(loopback_en),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_12_));
 sky130_fd_sc_hd__and2_2 _26_ (.A(ie),
    .B(_12_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_01_));
 sky130_fd_sc_hd__or3b_2 _27_ (.A(reg_addr[1]),
    .B(reg_addr[0]),
    .C_N(reg_we),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_13_));
 sky130_fd_sc_hd__mux2_1 _28_ (.A0(reg_wdata[0]),
    .A1(pad_oe),
    .S(_13_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_02_));
 sky130_fd_sc_hd__mux2_1 _29_ (.A0(reg_wdata[1]),
    .A1(pad_pu_en),
    .S(_13_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_03_));
 sky130_fd_sc_hd__mux2_1 _30_ (.A0(reg_wdata[2]),
    .A1(pad_pd_en),
    .S(_13_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_04_));
 sky130_fd_sc_hd__mux2_1 _31_ (.A0(reg_wdata[3]),
    .A1(pad_slew[0]),
    .S(_13_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_05_));
 sky130_fd_sc_hd__mux2_1 _32_ (.A0(reg_wdata[4]),
    .A1(pad_slew[1]),
    .S(_13_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_06_));
 sky130_fd_sc_hd__mux2_1 _33_ (.A0(reg_wdata[5]),
    .A1(ie),
    .S(_13_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_07_));
 sky130_fd_sc_hd__mux2_1 _34_ (.A0(reg_wdata[6]),
    .A1(pad_schmitt_en),
    .S(_13_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_08_));
 sky130_fd_sc_hd__mux2_1 _35_ (.A0(reg_wdata[7]),
    .A1(loopback_en),
    .S(_13_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_09_));
 sky130_fd_sc_hd__dfrtp_2 _36_ (.CLK(clk),
    .D(_02_),
    .RESET_B(rst_n),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(pad_oe));
 sky130_fd_sc_hd__dfrtp_2 _37_ (.CLK(clk),
    .D(_03_),
    .RESET_B(rst_n),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(pad_pu_en));
 sky130_fd_sc_hd__dfrtp_2 _38_ (.CLK(clk),
    .D(_04_),
    .RESET_B(rst_n),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(pad_pd_en));
 sky130_fd_sc_hd__dfrtp_2 _39_ (.CLK(clk),
    .D(_05_),
    .RESET_B(rst_n),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(pad_slew[0]));
 sky130_fd_sc_hd__dfrtp_2 _40_ (.CLK(clk),
    .D(_06_),
    .RESET_B(rst_n),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(pad_slew[1]));
 sky130_fd_sc_hd__dfrtp_2 _41_ (.CLK(clk),
    .D(_07_),
    .RESET_B(rst_n),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(ie));
 sky130_fd_sc_hd__dfrtp_2 _42_ (.CLK(clk),
    .D(_08_),
    .RESET_B(rst_n),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(pad_schmitt_en));
 sky130_fd_sc_hd__dfrtp_2 _43_ (.CLK(clk),
    .D(_09_),
    .RESET_B(rst_n),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(loopback_en));
 sky130_fd_sc_hd__dfrtp_2 _44_ (.CLK(clk),
    .D(_00_),
    .RESET_B(rst_n),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(core_din));
 sky130_fd_sc_hd__dfrtp_2 _45_ (.CLK(clk),
    .D(_01_),
    .RESET_B(rst_n),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(sync_ff1));
 sky130_fd_sc_hd__buf_2 _46_ (.A(core_dout),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(pad_dout));
endmodule
