`timescale 1ns / 1ps

module imp1();
  wire        hready_1, hready_2, hresp_1, hresp_2;
  wire        hready, hresp;
  reg         mem_write, mem_read;
  reg  [2:0]  func3;
  reg  [31:0] rs2_data, alu_out, address;
  wire [1:0]  htrans;
  wire [31:0] haddr, hwdata;
  wire [3:0]  hprot;
  wire        hwrite;
  wire [2:0]  hsize;

  wire        wr_en_ram, rd_en_ram, rd_en_rom;
  wire [31:0] wr_data_ram;
  wire [31:0] address_rom, address_ram;
  wire [31:0] rd_data;
  wire [31:0] instr;
  reg         clk, reset;
  wire        sel_0, sel_1;
  wire        muxsel;
  wire [31:0] data_out;
  wire [31:0] data_out_mux;

  // Instantiate AHB Master
  assgn1 u_master (
    .hready(hready),
    .hresp(hresp),
    .func3(func3),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .rs2_data(rs2_data),
    .alu_out(alu_out),
    .address(address),
    .htrans(htrans),
    .hprot(hprot),
    .hwrite(hwrite),
    .hsize(hsize),
    .haddr(haddr),
    .hwdata(hwdata),
    .data_out_mux(data_out_mux),
    .data_out(data_out)
  );

  // Decoder to generate sel_0, sel_1, muxsel
  ahbdec u_dec (
    .address(address),
    .sel_0(sel_0),
    .sel_1(sel_1),
    .muxsel(muxsel)
  );

  // Slave Glue Logic
  slave_glue u_slave_glue (
    .haddr(haddr),
    .hwdata(hwdata),
    .htrans(htrans),
    .hprot(hprot),
    .hwrite(hwrite),
    .hsize(hsize),
    .wr_en_ram(wr_en_ram),
    .rd_en_ram(rd_en_ram),
    .rd_en_rom(rd_en_rom),
    .wr_data_ram(wr_data_ram),
    .address_rom(address_rom),
    .address_ram(address_ram),
    .hready_1(hready_1),
    .hready_2(hready_2),
    .hresp_1(hresp_1),
    .hresp_2(hresp_2)
  );

  // ROM Instance
  rom_sample u_rom (
    .clk(clk),
    .reset(reset),
    .sel_0(sel_0),
    .rd_en_rom(rd_en_rom),
    .address_rom(address_rom),
    .instr(instr)
  );

  // RAM Instance
  ram_ahb u_ram (
    .clk(clk),
    .reset(reset),
    .sel_1(sel_1),
    .rd_en_ram(rd_en_ram),
    .wr_en_ram(wr_en_ram),
    .wr_data(wr_data_ram),
    .address_ram(address_ram),
    .rd_data(rd_data)
  );

  // AHB Mux
  ahbmux u_mux (
    .hready_1(hready_1),
    .hready_2(hready_2),
    .hresp_1(hresp_1),
    .hresp_2(hresp_2),
    .rd_data1(instr),
    .rd_data2(rd_data),
    .muxsel(muxsel),
    .data_out_mux(data_out_mux),
    .hready(hready),
    .hresp(hresp)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test Scenario
  initial begin
    reset = 1;
    mem_read = 0;
    mem_write = 0;
    func3 = 3'b000;
    rs2_data = 32'b0;
    alu_out = 32'b0;
    address = 32'b0;

    #10 reset = 0;
end
      // Test Scenario
  initial begin
    reset = 1;
    mem_read = 0;
    mem_write = 0;
    func3 = 3'b000;
    rs2_data = 32'b0;
    alu_out = 32'b0;
    address = 32'b0;

    #10 reset = 0;

    // ------------------ ROM FETCH (Instruction) ------------------
    #10;
    address   = 32'hA000_0004;
    alu_out   = 32'h0000_0000;
    rs2_data  = 32'h0000_0000;
    mem_read  = 0;
    mem_write = 0;
    func3     = 3'b010;

    // ------------------ RAM WRITE 1 ------------------
    #20;
    address   = 32'hB000_0000;
    alu_out   = 32'hB000_0000;
    rs2_data  = 32'h12345678;
    mem_write = 1;
    mem_read  = 0;
    func3     = 3'b010;

    // ------------------ RAM WRITE 2 ------------------
    #20;
    address   = 32'hB000_0004;
    alu_out   = 32'hB000_0004;
    rs2_data  = 32'h87654321;
    mem_write = 1;
    mem_read  = 0;
    func3     = 3'b010;

    // ------------------ RAM READ 1 ------------------
    #20;
    address   = 32'hB000_0000;
    alu_out   = 32'hB000_0000;
    mem_write = 0;
    mem_read  = 1;
    func3     = 3'b010;

    // ------------------ RAM READ 2 ------------------
    #20;
    address   = 32'hB000_0004;
    alu_out   = 32'hB000_0004;
    mem_write = 0;
    mem_read  = 1;
    func3     = 3'b010;

    // ------------------ ROM FETCH 2 ------------------
    #20;
    address   = 32'hA000_0008;
    alu_out   = 32'h0000_0000;
    mem_write = 0;
    mem_read  = 0;
    func3     = 3'b010;

    // ------------------ RAM WRITE 3 ------------------
    #20;
    address   = 32'hB000_0008;
    alu_out   = 32'hB000_0008;
    rs2_data  = 32'hCAFEBABE;
    mem_write = 1;
    mem_read  = 0;
    func3     = 3'b010;

    // ------------------ RAM READ 3 ------------------
    #20;
    address   = 32'hB000_0008;
    alu_out   = 32'hB000_0008;
    mem_write = 0;
    mem_read  = 1;
    func3     = 3'b010;

    #40;

    $finish;
  end

endmodule
