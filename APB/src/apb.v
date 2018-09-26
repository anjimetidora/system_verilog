//***************************************************************************//
//***************************************************************************//
//***************************************************************************//
//**************                                          *******************//
//**************                                          *******************//
//**************      (c) SASIC Technologies Pvt Ltd      *******************//
//**************          (c) Verilogic Solutions         *******************//
//**************                                          *******************//
//**************                                          *******************//
//**************                                          *******************//
//**************           www.sasictek.com               *******************//
//**************          www.verilog-ic.com              *******************//
//**************                                          *******************//
//**************           Twitter:@sasictek              *******************//
//**************                                          *******************//
//**************                                          *******************//
//**************                                          *******************//
//***************************************************************************//
//***************************************************************************//


//              File Name : apb.v
//              File Type: Verilog                                 
//              Creation Date : 30-12-2016
//              Last Modified : Mon 27 Feb 2017 06:06:05 PM IST

                             
//***************************************************************************//
//***************************************************************************//
                             

//              Author:
//              Reviewer:
//              Manager:
                             

//***************************************************************************//
//***************************************************************************//
//
//
//
//
		module apb_slave #(parameter IDLE=2'b00,
											parameter SETUP=2'b01,
											parameter ACCESS=2'b10,
											parameter ADD_WIDTH=32,
											parameter DATA_WIDTH=32,
											parameter T_WIDTH=8)
											(input pclk,
											 input prst,
											 input psel,
											 input penable,
											 input pwr,
										 	 input [ADD_WIDTH-1:0]padd,
										 	 input [DATA_WIDTH-1:0]pwdata,
										 	 output reg [DATA_WIDTH-1:0]prdata,
										 	 output reg pslverr,
										 	 output reg pready);

			reg [T_WIDTH-7:0]cst,nst;
			reg [ADD_WIDTH-1:0]temp_add;
			reg [DATA_WIDTH-1:0]temp_data;
			reg [DATA_WIDTH-1:0]temp_rdata;
			reg [T_WIDTH-1:0] mem [T_WIDTH-1:0];

			always @(posedge pclk)
				begin	//alw_seq_blk
					if(!prst)
						begin	//reset_blk_0
							//psel<='b0;
							//penable<='b0;
							//pslverr<='b0;
							//pready<='b1;
							nst<=IDLE;
							//prdata='b0;
							//[ADD_WIDTH-1:0]padd='b0;
							//[DATA_WIDTH-1:0]pwdata='b0;
							$display("reset_0");
						end	//reset_blk_0
					else
						begin	//reset_1
							cst<=nst;
							//padd<=temp_add;
							prdata<=temp_rdata;
							$display("reset_1");
						end	//reset_1
					end	//alw_seq_blk
			always @(cst)
				begin	//alw_comb_blk
					case(cst)
						IDLE:
							begin	//idle_blk
										nst=SETUP;
								/*if(psel=='b1)
									begin	//psel_1
										nst=SETUP;
									end	//psel_1
								else
									begin	//psel_0
										nst=IDLE;
									end	//psel_0*/
							end	//end_idle_blk
						SETUP:
							begin	//setup_blk
								if((psel=='b1)
									begin	//psel_penable_1
										nst=ACCESS;
										temp_add=padd;
										temp_data=pwdata;
										$display("setup state");
									end	//psel_penable_1
								/*else if((psel && penable)=='b0)
									begin	//psel_penable_0
										nst=IDLE;
									end	//psel_penable_0*/
								else
									begin	//psel_penable_0_x
										nst=SETUP;
									end	//psel_penable_0_x
							end
						ACCESS:
							begin	//access_blk
								if((penable && psel)=='b1)
									begin	//penable_psel_1
										if(pready=='b1)
											begin	//pready_1
												if(pwr== 'b1)
													begin	//pwr_1	//writing the data into memory
														if(temp_add>='b1000)
															begin	//slave_error
																pslverr='b1;
																nst=SETUP;
															end	//slave_error
														else
															begin	//slave_err_0
																mem[temp_add]=temp_data;
																pready='b1;
																pslverr='b0;
																//nst=SETUP;
															end
													end	//pwr_1
												{else if(pwr =='b0)
													begin	//pwr_0	//read the data from memory
														if(temp_add>='b1000)
															begin	//slve_error
																pslverr='b1;}
																nst=SETUP;
															end	//slve_error
														else
															begin	//slav_errorr_0
																temp_rdata=mem[temp_add];
																$display("read memory");
																pready='b1;
																pslverr='b0;
																//nst=SETUP;
															end	//slav_errorr_0
													end	//pwr_0
												else
													begin	//pwr_x

														nst=ACCESS;
													end	//pwdata_x
												end	//pready_1
										else
											begin	//pready_0
												nst=ACCESS;
											end	//pready_0	//if pready is 0,then it's going to wait state
									end
								else if((pready && psel)=='b1 && penable=='b0)
									begin		//pready_penable_1
										nst=SETUP;
									end	//pready_penable_1
								else if((pready =='b1) && (penable ==0 && psel==0))
									begin	//pready_1_penable_0
									 $display("IDLE");
										nst=IDLE;
									end	//pready_1_penable_0
								else
									begin
										nst=ACCESS;
									end
							end	//end_access
						endcase	//end_cases
						end	//alw_comb_blk
			endmodule





