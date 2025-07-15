`timescale 1ns / 1ps

module ram_ahb (
    input clk,
    input reset,
    input sel_1,
    input rd_en_ram,
    input wr_en_ram,
    input [31:0] wr_data,
    input [31:0] address_ram,
    input [2:0]  hsize,
    output reg [31:0] rd_data
);

    reg [7:0] ram [0:63]; 
    wire [5:0] addr = address_ram[5:0]; // address range 0 to 63
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
            for (i = 0; i < 64; i = i + 1)
                ram[i] <= 8'h00;

            
            ram[0] <= 8'hAA;
            ram[1] <= 8'hBB;
            ram[2] <= 8'hCC;
            ram[3] <= 8'hDD;
            ram[4] <= 8'hEE;

            rd_data <= 32'b0;
        end
        else if (wr_en_ram && sel_1) begin
            case (hsize)
                3'b000: ram[addr]     <= wr_data[7:0];                      // Byte write
                3'b001: begin                                             // Halfword write
                    ram[addr]     <= wr_data[7:0];
                    ram[addr + 1] <= wr_data[15:8];
                end
                3'b010: begin                                             // Word write
                    ram[addr]     <= wr_data[7:0];
                    ram[addr + 1] <= wr_data[15:8];
                    ram[addr + 2] <= wr_data[23:16];
                    ram[addr + 3] <= wr_data[31:24];
                end
            endcase
        end
        else if (rd_en_ram && sel_1) begin
            case (hsize)
                3'b000: rd_data <= {24'b0, ram[addr]};                                   // Byte read
                3'b001: rd_data <= {16'b0, ram[addr + 1], ram[addr]};                   // Halfword read
                3'b010: rd_data <= {ram[addr + 3], ram[addr + 2], ram[addr + 1], ram[addr]}; // Word read
                default: rd_data <= 32'b0;
            endcase
        end
    end

endmodule
