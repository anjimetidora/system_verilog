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


//              File Name : apb_tb.v
//              File Type: Verilog                                 
//              Creation Date : 30-12-2016
//              Last Modified : Mon 27 Feb 2017 02:17:14 PM IST

                             
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
	module tb;
	parameter ADD_WIDTH=32;
	parameter DATA_WIDTH=32;
	parameter T_WIDTH=8;
	reg top_clk,top_rst,top_sel,top_enable,top_pwr;
	reg [ADD_WIDTH-1:0]top_add;
	reg [DATA_WIDTH-1:0]top_datain;
	wire [DATA_WIDTH-1:0]top_dataout;
	wire top_err,top_ready;


	apb_slave dut_insta(.pclk(top_clk),.prst(top_rst),.psel(top_rst),.penable(top_enable),.padd(top_add),.pwdata(top_datain),.pready(top_ready),.pslverr(top_err),.pwr(top_pwr),.prdata(top_dataout));

	initial
		begin:clk_blk
			top_clk='b0;
			forever #5 top_clk=~top_clk;
		end	//clk_blk


	initial
		begin:test_cases
			top_reset('b0);
			top_reset('b1);
			top_sel_enable_pwr_add_datain('b1,'b1,'b1,'d2,'d34);	//setup state for writting 
			top_sel_enable_pwr_add_datain('b1,'b1,'b1,'d2,'d35);	//access state for writting
			top_sel_enable_pwr_add_datain('b1,'b0,'b0,'d2,'d34);	//setup state for reading
			top_sel_enable_pwr_add_datain('b1,'b1,'b0,'d2,'d34);	//access state for reading
			top_sel_enable_pwr_add_datain('b1,'b0,'b1,'d5,'d4);	//setup state for writting
			top_sel_enable_pwr_add_datain('b1,'b1,'b1,'d5,'d4);	//access state for writting
			top_sel_enable_pwr_add_datain('b1,'b0,'b0,'d5,'d00);	//setup state for reading
			top_sel_enable_pwr_add_datain('b1,'b1,'b0,'d5,'d00);	//access state for reading
			top_sel_enable_pwr_add_datain('b1,'b0,'b1,'d2,'d34);	//setup state for writting 
			top_sel_enable_pwr_add_datain('b1,'b1,'b1,'d2,'d34);	//access state for writting
				$display("after=================================");
			top_sel_enable_pwr_add_datain('b0,'b0,'b1,'d4,'d34);	 
			top_sel_enable_pwr_add_datain('b0,'b0,'b1,'d4,'d34);	 
			top_sel_enable_pwr_add_datain('b0,'b0,'b1,'d4,'d34);	 
			top_sel_enable_pwr_add_datain('b0,'b0,'b1,'d4,'d34);	 
			top_sel_enable_pwr_add_datain('b1,'b0,'b1,'d4,'d34);	//setup state for writting 
			top_sel_enable_pwr_add_datain('b1,'b1,'b1,'d7,'d74);	//access state for writting
			top_sel_enable_pwr_add_datain('b1,'b0,'b0,'d7,'d00);	//setup state for reading
			top_sel_enable_pwr_add_datain('b1,'b0,'b0,'d1,'d00);	//access state for reading

		/*	top_sel_enable_pwr_add_datain('b1,'b1,'b1,'d2,'d34);
			top_sel_enable_pwr_add_datain('b1,'b1,'b1,'d3,'d35);
			top_sel_enable_pwr_add_datain('b1,'b1,'b1,'d4,'d36);
			top_sel_enable_pwr_add_datain('b1,'b1,'b1,'d5,'d37);
			top_sel_enable_pwr_add_datain('b1,'b1,'b1,'d6,'d38);
			top_sel_enable_pwr_add_datain('b1,'b1,'b1,'d7,'d39);
			top_sel_enable_pwr_add_datain('b1,'b1,'b0,'d2,'d39);
			top_sel_enable_pwr_add_datain('b1,'b1,'b0,'d4,'d39);
			top_sel_enable_pwr_add_datain('b1,'b1,'b0,'d3,'d39);
			top_sel_enable_pwr_add_datain('b1,'b1,'b0,'d4,'d39);
			top_sel_enable_pwr_add_datain('b1,'b1,'b0,'d5,'d39);*/
			#20 $finish;

		end	//test_cases

	task top_reset(input task_reset);
		begin:task_rst
			@(negedge top_clk) top_rst=task_reset;
		end	//task_rst
	endtask


	/*task top_add_data(input [ADD_WIDTH-1:0]task_add,task_data);
		begin:task_ad_dat
			@(negedge top_clk) top_add=task_add;top_datain=task_data;
		end
	endtask*/



	task top_sel_enable_pwr_add_datain(input task_sel,task_enable,task_pwr, input [ADD_WIDTH-1:0]task_add,task_data);
		begin
			@(negedge top_clk) top_sel=task_sel;top_enable=task_enable;top_pwr=task_pwr;top_add=task_add;top_datain=task_data;
		end
	endtask



	initial 
	begin
		@(negedge top_clk)
		$monitor("time=%0t,clk=%0b,rst=%0b,sel=%0b,enbl=%0b,addres=%0b,data=%0d,pwr=%0b,pwdata=%0d,prdata=%0d,ready=%0b,err=%0b",$time,top_clk,top_rst,top_sel,top_enable,top_add,top_datain,top_pwr,top_datain,top_dataout,top_ready,top_err);
	end	
	endmodule


	
