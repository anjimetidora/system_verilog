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


//              File Name : apb_final.v
//              File Type: Verilog                                 
//              Creation Date : 25-02-2017
//              Last Modified : Fri 03 Mar 2017 02:21:29 PM IST

                             
//***************************************************************************//
//***************************************************************************//
                             

//              Author:
//              Reviewer:
//              Manager:
                             

//***************************************************************************//
//***************************************************************************//




		module apb_slave #(parameter IDLE=2'b00,
											parameter SETUP=2'b01,
											parameter ACCESS=2'b10,
											parameter ADD_WIDTH=5,
											parameter DATA_WIDTH=32,
											parameter T_WIDTH=8,
											parameter MAX_VAL=15)
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
			reg [DATA_WIDTH-1:0] mem [MAX_VAL-1:0];

			always @(posedge pclk)
				begin	//alw_seq_blk
					if(!prst)
						begin	//reset_blk_0
							nst<=IDLE;
							pready<='b1;
							pslverr<='b0;
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
			always @(*)
				begin	//alw_comb_blk
					case(cst)
						IDLE:
							begin	//idle_blk
										nst=SETUP;
										$display("idle state");
							end	//end_idle_blk
						SETUP:
							begin	//setup_blk
								if(psel=='b1)
									begin	//psel_penable_1
										nst=ACCESS;
										temp_add=padd;
										temp_data=pwdata;
										$display("setup state");
									end	//psel_penable_1
								else
									begin	//psel_penable_0_x
										nst=SETUP;
									end	//psel_penable_0_x
							end
						ACCESS:
							begin	//access_blk
								if((psel=='b0 &&penable=='b0))
									begin	//pready_1_penable_0
										nst=IDLE;
										$display("both penable and psel is 0 and pready is 1--------");
									end	//pready_1_penable_0
								else if((penable=='b1) && (psel=='b1))
									begin
										if(pready=='b1)
											begin
												if(pwr=='b1)
													begin
														if(temp_add>=MAX_VAL)
															begin	//slave_error
																pslverr='b1;
																nst=SETUP;
																$display("write error in access");
															end	//slave_error
														else
															begin	//slave_err_0
																mem[temp_add]=temp_data;
																pready='b1;
																pslverr='b0;
																$display("write data in access");
															//	nst=SETUP;
															end
													end	//pwr_1
												else if(pwr =='b0)
													begin	//pwr_0	//read the data from memory
														if(temp_add>=MAX_VAL)
															begin	//slve_error
																pslverr='b1;
																nst=SETUP;
															end	//slve_error
														else
															begin	//slav_errorr_0
																temp_rdata=mem[temp_add];
																$display("read memory in access");
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
									end	//pen & psel is otherthan 1
								else if((psel=='b1)&&(penable=='b0))
									begin		//pready_penable_1
										nst=SETUP;
										$display("else setup ,psel=%b,penable=%b",psel,penable);
									end	//pready_penable_1
								else
									begin
										nst=ACCESS;
										$display("else part of if enable is 0------------------");
									end
							end	//end_access
						endcase	//end_cases
						end	//alw_comb_blk





			endmodule

