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


//              File Name : apb_fc.sv
//              File Type: System Verilog                                 
//              Creation Date : 22-02-2017
//              Last Modified : Fri 03 Mar 2017 03:27:33 PM IST

                             
//***************************************************************************//
//***************************************************************************//
                             

//              Author:
//              Reviewer:
//              Manager:
                             

//***************************************************************************//
//***************************************************************************//


class apb_fc;
apb_transaction f_tra;

mailbox#(apb_transaction) fmbox;

covergroup cg;

option.per_instance=1;
cp_psel: coverpoint f_tra.psel{
																bins psel={1};
															}
																
cp_penable: coverpoint f_tra.penable{
																			bins penable={1};
																		}

cp_pwr: coverpoint f_tra.pwr{ 
															bins pwr={1,0};
														}
cp_padd: coverpoint f_tra.padd{
																bins low={[0:2]};
																bins medim={[3:6]};
																bins high={[7:9]};
															}
cp_pwdata: coverpoint f_tra.pwdata{
																		bins low={[0:20]};
																		bins medim={[21:50]};
																		bins high={[51:100]};
																	}
cp_prdata: coverpoint f_tra.prdata{
																		bins low={[0:20]};
																		bins medim={[21:50]};
																		bins high={[51:100]};
																		}
cp_pslverr: coverpoint f_tra.pslverr{
																			bins pslverr={1};
																		}
cp_pready: coverpoint f_tra.pready{
																		bins pready={1};
																	}
cp_rst: coverpoint f_tra.prst;
endgroup 

	function new(mailbox#(apb_transaction) fmbox);
		begin
			this.f_tra=new();
			cg=new();
			this.fmbox=fmbox;
		end
	endfunction
	extern virtual task main();
	endclass
	
	task apb_fc::main();
		forever
			begin
				this.fmbox.get(f_tra);
				cg.sample();
				$display("data in the functional coverage=%p",f_tra);
				end
				endtask
