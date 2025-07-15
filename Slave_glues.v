`timescale 1ns / 1ps
module slave_glue(
    input [31:0] haddr,
    input [31:0] hwdata,
    input [1:0]  htrans,
    input [3:0]  hprot,
    input        hwrite,
    input [2:0]  hsize,
    output reg   wr_en_ram,
    output reg   rd_en_ram,
    output reg   rd_en_rom,
    output reg [31:0] wr_data_ram,
    output reg [31:0] address_rom,
    output reg [31:0] address_ram,
    output reg        hready_1,
    output reg        hresp_1,
    output reg        hresp_2,
    output reg        hready_2
);

always@(*) begin

    wr_en_ram   = 0;
    rd_en_ram   = 0;
    rd_en_rom   = 0;
    wr_data_ram = 32'b0;
    address_ram = 32'b0;
    address_rom = 32'b0;
    hready_1     = 1;
    hready_2     = 1;
    hresp_1       = 0;
    hresp_2       = 0;
if (haddr[31:24] == 8'hB0) begin  // RAM access (changed from A0 to B0)
        address_ram = haddr;
        if (hwrite) begin             // Write to RAM
            wr_en_ram   = 1;
            wr_data_ram = hwdata;
        end else begin                // Read from RAM
            rd_en_ram = 1;
        end
        hresp_2 = 0;
        hready_2 = 1;
        
    end 
    else if (haddr[31:24] == 8'hA0) begin // ROM access (changed from B0 to A0)
        address_rom = haddr;
        if (hwrite) begin                 // Write to ROM not allowed
            hresp_1    = 1;
            hready_1   = 1;
            
        end else if (hprot[0]) begin      // Opcode access (not allowed here)
            hresp_1   = 1;
            hready_1   = 1;
            
        end else begin                    // Read from ROM allowed
            rd_en_rom = 1;
            hresp_1    = 0;
            hready_1   = 1;
            
        end
    end
end

endmodule
