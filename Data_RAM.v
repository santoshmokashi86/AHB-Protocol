module ram_ahb (
    input clk,
    input reset,
    input sel_1,
    input rd_en_ram,
    input wr_en_ram,
    input [31:0] wr_data,
    input [31:0] address_ram,
    output reg [31:0] rd_data
);

    reg [31:0] ram [0:4]; 
   
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ram[0] <= 32'h0000AAAA; 
            ram[1] <= 32'h0000BBBB;
            ram[2] <= 32'h0000CCCC;
            ram[3] <= 32'h0000DDDD;
            ram[4] <= 32'h0000EEEE;
            rd_data <= 32'b0; 
        end 
        else if (wr_en_ram&&sel_1) begin
            ram[address_ram[2:0]] <= wr_data;
        end 
        else if (rd_en_ram&&sel_1) begin
            rd_data <= ram[address_ram[2:0]];
        end
    end

endmodule
