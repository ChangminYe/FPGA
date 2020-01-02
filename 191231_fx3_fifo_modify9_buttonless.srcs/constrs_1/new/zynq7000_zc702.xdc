# Clock #
set_property -dict { PACKAGE_PIN Y8   IOSTANDARD LVDS_25 } [get_ports { USRCLK_N }];
set_property -dict { PACKAGE_PIN Y9   IOSTANDARD LVDS_25 } [get_ports { USRCLK_P }];
set_property -dict { PACKAGE_PIN Y19  IOSTANDARD LVCMOS25} [get_ports { PCLK }];

# Button #
set_property -dict { PACKAGE_PIN G19  IOSTANDARD LVCMOS25} [get_ports { RESET }];

# FMC #
set_property -dict { PACKAGE_PIN AB15 IOSTANDARD LVCMOS25 } [get_ports { SLCS_N }];
set_property -dict { PACKAGE_PIN T4   IOSTANDARD LVCMOS25 } [get_ports { SLWR_N }];
set_property -dict { PACKAGE_PIN U10  IOSTANDARD LVCMOS25 } [get_ports { SLRD_N }];
set_property -dict { PACKAGE_PIN U4   IOSTANDARD LVCMOS25 } [get_ports { SLOE_N }];
set_property -dict { PACKAGE_PIN AA11 IOSTANDARD LVCMOS25 } [get_ports { PKTEND_N }];
set_property -dict { PACKAGE_PIN Y18  IOSTANDARD LVCMOS25 } [get_ports { DQ[0] }];
set_property -dict { PACKAGE_PIN V14  IOSTANDARD LVCMOS25 } [get_ports { DQ[1] }];
set_property -dict { PACKAGE_PIN V15  IOSTANDARD LVCMOS25 } [get_ports { DQ[2] }];
set_property -dict { PACKAGE_PIN V13  IOSTANDARD LVCMOS25 } [get_ports { DQ[3] }];
set_property -dict { PACKAGE_PIN W13  IOSTANDARD LVCMOS25 } [get_ports { DQ[4] }];
set_property -dict { PACKAGE_PIN T21  IOSTANDARD LVCMOS25 } [get_ports { DQ[5] }];
set_property -dict { PACKAGE_PIN U21  IOSTANDARD LVCMOS25 } [get_ports { DQ[6] }];
set_property -dict { PACKAGE_PIN Y14  IOSTANDARD LVCMOS25 } [get_ports { DQ[7] }];
set_property -dict { PACKAGE_PIN AA14 IOSTANDARD LVCMOS25 } [get_ports { DQ[8] }];
set_property -dict { PACKAGE_PIN Y13  IOSTANDARD LVCMOS25 } [get_ports { DQ[9] }];
set_property -dict { PACKAGE_PIN AA13 IOSTANDARD LVCMOS25 } [get_ports { DQ[10] }];
set_property -dict { PACKAGE_PIN R6   IOSTANDARD LVCMOS25 } [get_ports { DQ[11] }];
set_property -dict { PACKAGE_PIN T6   IOSTANDARD LVCMOS25 } [get_ports { DQ[12] }];
set_property -dict { PACKAGE_PIN V5   IOSTANDARD LVCMOS25 } [get_ports { DQ[13] }];
set_property -dict { PACKAGE_PIN V4   IOSTANDARD LVCMOS25 } [get_ports { DQ[14] }];
set_property -dict { PACKAGE_PIN U6   IOSTANDARD LVCMOS25 } [get_ports { DQ[15] }];
set_property -dict { PACKAGE_PIN U5   IOSTANDARD LVCMOS25 } [get_ports { DQ[16] }];
set_property -dict { PACKAGE_PIN AB5  IOSTANDARD LVCMOS25 } [get_ports { DQ[17] }];
set_property -dict { PACKAGE_PIN AB4  IOSTANDARD LVCMOS25 } [get_ports { DQ[18] }];
set_property -dict { PACKAGE_PIN AB7  IOSTANDARD LVCMOS25 } [get_ports { DQ[19] }];
set_property -dict { PACKAGE_PIN AB6  IOSTANDARD LVCMOS25 } [get_ports { DQ[20] }];
set_property -dict { PACKAGE_PIN Y4   IOSTANDARD LVCMOS25 } [get_ports { DQ[21] }];
set_property -dict { PACKAGE_PIN AA4  IOSTANDARD LVCMOS25 } [get_ports { DQ[22] }];
set_property -dict { PACKAGE_PIN Y6   IOSTANDARD LVCMOS25 } [get_ports { DQ[23] }];
set_property -dict { PACKAGE_PIN Y5   IOSTANDARD LVCMOS25 } [get_ports { DQ[24] }];
set_property -dict { PACKAGE_PIN AA16 IOSTANDARD LVCMOS25 } [get_ports { DQ[25] }];
set_property -dict { PACKAGE_PIN AB16 IOSTANDARD LVCMOS25 } [get_ports { DQ[26] }];
set_property -dict { PACKAGE_PIN AA17 IOSTANDARD LVCMOS25 } [get_ports { DQ[27] }];
set_property -dict { PACKAGE_PIN AB17 IOSTANDARD LVCMOS25 } [get_ports { DQ[28] }];
set_property -dict { PACKAGE_PIN W15  IOSTANDARD LVCMOS25 } [get_ports { DQ[29] }];
set_property -dict { PACKAGE_PIN Y15  IOSTANDARD LVCMOS25 } [get_ports { DQ[30] }];
set_property -dict { PACKAGE_PIN AB14 IOSTANDARD LVCMOS25 } [get_ports { DQ[31] }];
set_property -dict { PACKAGE_PIN U9   IOSTANDARD LVCMOS25 } [get_ports { FLAGA }];
set_property -dict { PACKAGE_PIN AA12 IOSTANDARD LVCMOS25 } [get_ports { FLAGB }];
set_property -dict { PACKAGE_PIN AB12 IOSTANDARD LVCMOS25 } [get_ports { FLAGC }];
set_property -dict { PACKAGE_PIN AB11 IOSTANDARD LVCMOS25 } [get_ports { FLAGD }];
set_property -dict { PACKAGE_PIN Y10  IOSTANDARD LVCMOS25 } [get_ports { A[0] }];
set_property -dict { PACKAGE_PIN Y11  IOSTANDARD LVCMOS25 } [get_ports { A[1] }];

# LED #
set_property -dict { PACKAGE_PIN E15  IOSTANDARD LVCMOS25 } [get_ports { LED[0] }];
set_property -dict { PACKAGE_PIN D15  IOSTANDARD LVCMOS25 } [get_ports { LED[1] }];
set_property -dict { PACKAGE_PIN W17  IOSTANDARD LVCMOS25 } [get_ports { LED[2] }];
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS25 } [get_ports { LED[3] }];
set_property -dict { PACKAGE_PIN V7   IOSTANDARD LVCMOS25 } [get_ports { LED[4] }];
set_property -dict { PACKAGE_PIN W10  IOSTANDARD LVCMOS25 } [get_ports { LED[5] }];
set_property -dict { PACKAGE_PIN P18  IOSTANDARD LVCMOS25 } [get_ports { LED[6] }];
set_property -dict { PACKAGE_PIN P17  IOSTANDARD LVCMOS25 } [get_ports { LED[7] }];