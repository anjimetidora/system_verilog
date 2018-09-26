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


//              File Name : apb.driver.sv
//              File Type: System Verilog                                 
//              Creation Date : 22-02-2017
//              Last Modified : Thu 02 Mar 2017 05:26:32 PM IST

                             
//***************************************************************************//
//***************************************************************************//
                             

//              Author:
//              Reviewer:
//              Manager:
                             

//***************************************************************************//
//***************************************************************************//


class apb_driver;
	virtual apb_interface drv_inf;
	apb_transaction drv_tr;
	
	mailbox#(apb_transaction) dmbox;
	
	function new(virtual apb_interface drv_inf,mailbox#(apb_transaction) mbox);
		begin	//driver function construction
			dmbox=mbox;
			this.drv_inf=drv_inf;
		end		//end function
	endfunction
	
	extern virtual task main();
	extern virtual task rst_op();
	extern virtual task write_op(apb_transaction drv_tr);
	extern virtual task read_op(apb_transaction drv_tr);
	endclass
	
	
	task apb_driver::main();
	forever
		begin	//main task
			dmbox.get(drv_tr);
			$display("data at the driver=%p",drv_tr);
		case(drv_tr.kind)
				RST:
				rst_op();
				WRITE:
				write_op(drv_tr);
				READ:
				read_op(drv_tr);
		endcase	//end task
	end
	endtask

	task apb_driver::rst_op();
		begin	//reset operation
			@(drv_inf.drv_cb);
			drv_inf.drv_cb.prst<='b0;
		//	drv_inf.drv_cb.pready<='b1;
			//drv_inf.drv_cb.pslverr<='b0;
			@(drv_inf.drv_cb);
				drv_inf.drv_cb.prst<='b1;
				drv_inf.drv_cb.penable<='b0;
		end	//reset operation end
		endtask
	task apb_driver::write_op(apb_transaction drv_tr);
		begin	//write operation
			@(drv_inf.drv_cb);
			drv_inf.drv_cb.psel<='b1;
			drv_inf.drv_cb.penable<='b0;
			drv_inf.drv_cb.padd<=drv_tr.padd;
			drv_inf.drv_cb.pwdata<=drv_tr.pwdata;
			drv_inf.drv_cb.pwr<=1;
			@(drv_inf.drv_cb);
			drv_inf.drv_cb.penable<='b1;
		end	//write operation end
	endtask
	task apb_driver::read_op(apb_transaction drv_tr);
		begin	//read operation
			@(drv_inf.drv_cb);
			drv_inf.drv_cb.psel<='b1;
			drv_inf.drv_cb.penable<='b0;
			drv_inf.drv_cb.padd<=drv_tr.padd;
			drv_inf.drv_cb.pwdata<='b0;	//drv_tr.pwdata;
			drv_inf.drv_cb.pwr<='b0;
			@(drv_inf.drv_cb);
			drv_inf.drv_cb.penable<='b1;
		end	//read operation end
	endtask

