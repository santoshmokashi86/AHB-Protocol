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
    input is_signed, 
    output reg [31:0] rd_data
);

    reg [7:0] ram [0:63]; 
    wire [5:0] addr = address_ram[5:0]; 63
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 64; i = i + 1)
                ram[i] <= 8'h00;

            // Sample memory init
            ram[0] <= 8'hAA;
            ram[1] <= 8'hBB;
            ram[2] <= 8'hCC;
            ram[3] <= 8'hDD;
            ram[4] <= 8'hEE;

            rd_data <= 32'b0;
        end
        else if (wr_en_ram && sel_1) begin
            case (hsize)
                3'b000: ram[addr]     <= wr_data[7:0];                 
                3'b001: begin                                           
                    ram[addr]     <= wr_data[7:0];
                    ram[addr + 1] <= wr_data[15:8];
                end
                3'b010: begin                                           
                    ram[addr]     <= wr_data[7:0];
                    ram[addr + 1] <= wr_data[15:8];
                    ram[addr + 2] <= wr_data[23:16];
                    ram[addr + 3] <= wr_data[31:24];
                end
            endcase
        end
        else if (rd_en_ram && sel_1) begin
            case (hsize)
                3'b000: rd_data <= is_signed ? 
                                {{24{ram[addr][7]}}, ram[addr]} :       
                                {24'b0, ram[addr]};                     

                3'b001: rd_data <= is_signed ?
                                {{16{ram[addr + 1][7]}}, ram[addr + 1], ram[addr]} :  
                                {16'b0, ram[addr + 1], ram[addr]};                    

                3'b010: rd_data <= {ram[addr + 3], ram[addr + 2], ram[addr + 1], ram[addr]}; 
                default: rd_data <= 32'b0;
            endcase
        end
    end

endmodule
