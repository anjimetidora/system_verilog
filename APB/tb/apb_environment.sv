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


//              File Name : apb.environment.sv
//              File Type: System Verilog                                 
//              Creation Date : 22-02-2017
//              Last Modified : Tue 28 Feb 2017 12:29:17 PM IST

                             
//***************************************************************************//
//***************************************************************************//
                             

//              Author:
//              Reviewer:
//              Manager:
                             

//***************************************************************************//
//***************************************************************************//

`include"apb_driver.sv"
`include"apb_generator.sv"
`include"apb_monitor.sv"
`include "apb_fc.sv"
//`include "apb_sb.sv"

class apb_environment;
apb_driver env_drv;
apb_generator env_gen;
apb_monitor env_mon;
//apb_scoreboard env_sb;
apb_fc env_fc;
virtual apb_interface env_inf;

mailbox#(apb_transaction) mbox,fmbox,smbox;

function new (virtual apb_interface env_inf);
this.env_inf=env_inf;
endfunction

extern virtual task main();
extern virtual function void build();
extern virtual task start();
endclass

task apb_environment::main();
build();
start();
#30;
$finish;
endtask

function void apb_environment::build();
mbox=new(1);
fmbox=new(1);
//smbox=new(1);
env_drv=new(env_inf,mbox);//gmbox
env_gen=new(mbox);
env_mon=new(env_inf,fmbox);//smbox,fmbox;
env_fc=new(fmbox);
//env_sb=new(smbox);
endfunction

task apb_environment::start();
fork
env_gen.main();
env_drv.main();
env_mon.main();
env_fc.main();
//env_sb.main();
join_any
endtask


