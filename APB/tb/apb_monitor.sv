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


//              File Name : apb.monitor.sv
//              File Type: System Verilog                                 
//              Creation Date : 22-02-2017
//              Last Modified : Fri 03 Mar 2017 11:16:39 AM IST

                             
//***************************************************************************//
//***************************************************************************//
                             

//              Author:
//              Reviewer:
//              Manager:
                             

//***************************************************************************//
//***************************************************************************//

class apb_monitor;

	virtual apb_interface mon_inf;
	apb_transaction mon_tx;
	mailbox#(apb_transaction) fmbox,smbox;
	
	function new(virtual apb_interface mon_inf,mailbox#(apb_transaction) fmbox);
		begin	//monitor function 
			this.mon_inf=mon_inf;
			this.fmbox=fmbox;
			this.mon_tx=new();
		end	//end monitor function
	endfunction

	extern virtual task main();
endclass
	
	task apb_monitor::main();
		forever
			begin	//monitor main task start
				@(mon_inf.drv_cb);
					mon_tx.kind=op'(mon_inf.pwr);
					mon_tx.prst=mon_inf.prst;
					mon_tx.penable=mon_inf.penable;
					mon_tx.psel=mon_inf.psel;
					mon_tx.pwr=mon_inf.pwr;
					mon_tx.padd=mon_inf.padd;
					mon_tx.pwdata=mon_inf.pwdata;
					mon_tx.prdata=mon_inf.prdata;
					mon_tx.pslverr=mon_inf.pslverr;
					mon_tx.pready=mon_inf.pready;
					$display("data at monitor=%p",mon_tx);
					fmbox.put(mon_tx);
			end	//end monitor task
	endtask

					




