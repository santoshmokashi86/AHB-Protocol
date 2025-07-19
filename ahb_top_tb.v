`timescale 1ns / 1ps

module ahb_top_tb;

  reg clk;
  reg reset;
  reg mem_write, mem_read;
  reg [2:0] func3;
  reg [31:0] rs2_data, alu_out, address;
  wire [31:0] data_out;

  // Instantiate the DUT
  ahb_top dut (
    .clk(clk),
    .reset(reset),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .func3(func3),
    .rs2_data(rs2_data),
    .alu_out(alu_out),
    .address(address),
    .data_out(data_out)
  );

  // Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test Stimulus
  initial begin
    reset = 1;
    mem_read = 0;
    mem_write = 0;
    func3 = 3'b000;
    rs2_data = 32'b0;
    alu_out = 32'b0;
    address = 32'b0;

    #10 reset = 0;

    // ROM FETCH (Instruction)
    #10;
    address   = 32'hA000_0004;
    alu_out   = 32'h0000_0000;
    rs2_data  = 32'h0000_0000;
    mem_read  = 0;
    mem_write = 0;
    func3     = 3'b010;

    // RAM WRITE
    #20;
    address   = 32'hB000_0002;
    alu_out   = 32'hB000_0002;
    rs2_data  = 32'h12345678;
    mem_write = 1;
    mem_read  = 0;
    func3     = 3'b010;

    // RAM READ
    #20;
    address   = 32'hB000_0002;
    alu_out   = 32'hB000_0002;
    mem_write = 0;
    mem_read  = 1;
    func3     = 3'b010;

    // RAM READ BYTE
    #20;
    address   = 32'hB000_000C;
    alu_out   = 32'hB000_0000;
    mem_write = 0;
    mem_read  = 1;
    func3     = 3'b000;

    #40 $finish;
  end

endmodule
