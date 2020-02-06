## clock
set_property -dict { PACKAGE_PIN AL34   IOSTANDARD LVDS } [get_ports { USRCLK_N }];
set_property -dict { PACKAGE_PIN AK34   IOSTANDARD LVDS } [get_ports { USRCLK_P }];
set_property -dict { PACKAGE_PIN AD40   IOSTANDARD LVCMOS18 } [get_ports { PCLK }];

## buttons 
set_property -dict { PACKAGE_PIN AV39   IOSTANDARD LVCMOS18 } [get_ports { RESET }];

## LEDS
set_property -dict { PACKAGE_PIN AM39   IOSTANDARD LVCMOS18 } [get_ports { LED[0] }];
set_property -dict { PACKAGE_PIN AN39   IOSTANDARD LVCMOS18 } [get_ports { LED[1] }];
set_property -dict { PACKAGE_PIN AR37   IOSTANDARD LVCMOS18 } [get_ports { LED[2] }];
set_property -dict { PACKAGE_PIN AT37   IOSTANDARD LVCMOS18 } [get_ports { LED[3] }];
set_property -dict { PACKAGE_PIN AR35   IOSTANDARD LVCMOS18 } [get_ports { LED[4] }];
set_property -dict { PACKAGE_PIN AP41   IOSTANDARD LVCMOS18 } [get_ports { LED[5] }];
set_property -dict { PACKAGE_PIN AP42   IOSTANDARD LVCMOS18 } [get_ports { LED[6] }];
set_property -dict { PACKAGE_PIN AU39   IOSTANDARD LVCMOS18 } [get_ports { LED[7] }];


## fx3 (FMC2)
set_property -dict { PACKAGE_PIN AJ41 IOSTANDARD LVCMOS18 } [get_ports { SLCS_N }];
set_property -dict { PACKAGE_PIN V33  IOSTANDARD LVCMOS18 } [get_ports { SLWR_N }];
set_property -dict { PACKAGE_PIN W32  IOSTANDARD LVCMOS18 } [get_ports { SLRD_N }];
set_property -dict { PACKAGE_PIN V34  IOSTANDARD LVCMOS18 } [get_ports { SLOE_N }];
set_property -dict { PACKAGE_PIN W36  IOSTANDARD LVCMOS18 } [get_ports { PKTEND_N }];
set_property -dict { PACKAGE_PIN AF39 IOSTANDARD LVCMOS18 } [get_ports { DQ[0] }];
set_property -dict { PACKAGE_PIN AK39 IOSTANDARD LVCMOS18 } [get_ports { DQ[1] }];
set_property -dict { PACKAGE_PIN AL39 IOSTANDARD LVCMOS18 } [get_ports { DQ[2] }];
set_property -dict { PACKAGE_PIN AL41 IOSTANDARD LVCMOS18 } [get_ports { DQ[3] }];
set_property -dict { PACKAGE_PIN AL42 IOSTANDARD LVCMOS18 } [get_ports { DQ[4] }];
set_property -dict { PACKAGE_PIN AC40 IOSTANDARD LVCMOS18 } [get_ports { DQ[5] }];
set_property -dict { PACKAGE_PIN AC41 IOSTANDARD LVCMOS18 } [get_ports { DQ[6] }];
set_property -dict { PACKAGE_PIN Y42  IOSTANDARD LVCMOS18 } [get_ports { DQ[7] }];
set_property -dict { PACKAGE_PIN AA42 IOSTANDARD LVCMOS18 } [get_ports { DQ[8] }];
set_property -dict { PACKAGE_PIN AC38 IOSTANDARD LVCMOS18 } [get_ports { DQ[9] }];
set_property -dict { PACKAGE_PIN AC39 IOSTANDARD LVCMOS18 } [get_ports { DQ[10] }];
set_property -dict { PACKAGE_PIN U32  IOSTANDARD LVCMOS18 } [get_ports { DQ[11] }];
set_property -dict { PACKAGE_PIN U33  IOSTANDARD LVCMOS18 } [get_ports { DQ[12] }];
set_property -dict { PACKAGE_PIN P35  IOSTANDARD LVCMOS18 } [get_ports { DQ[13] }];
set_property -dict { PACKAGE_PIN P36  IOSTANDARD LVCMOS18 } [get_ports { DQ[14] }];
set_property -dict { PACKAGE_PIN U34  IOSTANDARD LVCMOS18 } [get_ports { DQ[15] }];
set_property -dict { PACKAGE_PIN T35  IOSTANDARD LVCMOS18 } [get_ports { DQ[16] }];
set_property -dict { PACKAGE_PIN V35  IOSTANDARD LVCMOS18 } [get_ports { DQ[17] }];
set_property -dict { PACKAGE_PIN V36  IOSTANDARD LVCMOS18 } [get_ports { DQ[18] }];
set_property -dict { PACKAGE_PIN T32  IOSTANDARD LVCMOS18 } [get_ports { DQ[19] }];
set_property -dict { PACKAGE_PIN R32  IOSTANDARD LVCMOS18 } [get_ports { DQ[20] }];
set_property -dict { PACKAGE_PIN P37  IOSTANDARD LVCMOS18 } [get_ports { DQ[21] }];
set_property -dict { PACKAGE_PIN P38  IOSTANDARD LVCMOS18 } [get_ports { DQ[22] }];
set_property -dict { PACKAGE_PIN U39  IOSTANDARD LVCMOS18 } [get_ports { DQ[23] }];
set_property -dict { PACKAGE_PIN T39  IOSTANDARD LVCMOS18 } [get_ports { DQ[24] }];
set_property -dict { PACKAGE_PIN AJ42 IOSTANDARD LVCMOS18 } [get_ports { DQ[25] }];
set_property -dict { PACKAGE_PIN AK42 IOSTANDARD LVCMOS18 } [get_ports { DQ[26] }];
set_property -dict { PACKAGE_PIN AD42 IOSTANDARD LVCMOS18 } [get_ports { DQ[27] }];
set_property -dict { PACKAGE_PIN AE42 IOSTANDARD LVCMOS18 } [get_ports { DQ[28] }];
set_property -dict { PACKAGE_PIN Y39  IOSTANDARD LVCMOS18 } [get_ports { DQ[29] }];
set_property -dict { PACKAGE_PIN AA39 IOSTANDARD LVCMOS18 } [get_ports { DQ[30] }];
set_property -dict { PACKAGE_PIN AJ40 IOSTANDARD LVCMOS18 } [get_ports { DQ[31] }];
set_property -dict { PACKAGE_PIN W33  IOSTANDARD LVCMOS18 } [get_ports { FLAGA }];
set_property -dict { PACKAGE_PIN R33  IOSTANDARD LVCMOS18 } [get_ports { FLAGB }];
set_property -dict { PACKAGE_PIN R34  IOSTANDARD LVCMOS18 } [get_ports { FLAGC }];
set_property -dict { PACKAGE_PIN W37  IOSTANDARD LVCMOS18 } [get_ports { FLAGD }];
set_property -dict { PACKAGE_PIN R37  IOSTANDARD LVCMOS18 } [get_ports { A[0] }];
set_property -dict { PACKAGE_PIN T36  IOSTANDARD LVCMOS18 } [get_ports { A[1] }];