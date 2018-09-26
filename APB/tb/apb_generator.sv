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


//              File Name : apb.generator.sv
//              File Type: System Verilog                                 
//              Creation Date : 22-02-2017
//              Last Modified : Thu 02 Mar 2017 05:22:35 PM IST

                             
//***************************************************************************//
//***************************************************************************//
                             

//              Author:
//              Reviewer:
//              Manager:
                             

//***************************************************************************//
//***************************************************************************//


class apb_generator;

apb_transaction gen_tx;

mailbox#(apb_transaction) gmbox;

function new(mailbox#(apb_transaction) mbox);
	begin	//generator new constructor
		gmbox=mbox;
		gen_tx=new();
	end
endfunction	//end of generator function

extern virtual task main();
endclass


task apb_generator::main();
	begin	//main task
	repeat(2)
		begin:reset_operation
			if(gen_tx.randomize() with{kind==RST;})
				begin	//rst randomization
					$display("rst randomization success");
					$display("data put into mailbox=%p",gen_tx);
					gmbox.put(gen_tx);
				end	//rst randomization success
			else 
				begin:if_randomization_faill
					$display("randomization fail");
				end
			#10;
		end	//reset opeartion
	repeat(8)
		begin:write_operation
			if(gen_tx.randomize() with {kind==WRITE;})
				begin	//writer operation
					$display("write randomization success");
					$display("data put into mailbox=%p",gen_tx);
					gmbox.put(gen_tx);
				end	//end write operation
			else 
				begin:if_randomization_faill
					$display("randomization fail");
				end
			#5;
		end	//end write operation
	repeat(9)
		begin:read_operation
			if(gen_tx.randomize() with {kind==READ;})
				begin	//read operation
					$display("read randomization success");
					$display("data put into mailbox=%p",gen_tx);
					gmbox.put(gen_tx);
				end	//read operation end
				else 
					begin:if_randomization_faill
						$display("randomization fail");
					end
		#10;
		end	//end read operation
	end
endtask



