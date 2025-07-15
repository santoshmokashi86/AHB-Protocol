`timescale 1ns / 1ps

module ahbdec(address,sel_0,sel_1,muxsel);
input [31:0]address;
output reg sel_0;
output reg sel_1;
output reg muxsel;

always@(*)
begin
        sel_1=0;
        sel_0=0;
        muxsel=0;
    if(address[31:24]==8'hA0)//ROM
    begin
        sel_0=1;
        muxsel=1;
    end
    else if(address[31:24]==8'hB0)//RAM
    begin
         sel_1=1;
         muxsel=0;
    end
     
end
endmodule
