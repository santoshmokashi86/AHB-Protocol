module ahbmux(
    input        hready_1, hready_2, hresp_1, hresp_2,
    input [31:0] rd_data1, rd_data2,
    input        muxsel,  // 0: RAM, 1: ROM
    output reg [31:0] data_out_mux,
    output reg        hready,
    output reg        hresp
);

always @(*) begin
    // Default values
    data_out_mux = 32'b0;
    hready       = 1;
    hresp        = 0;

    if (muxsel) begin
        // ROM selected
        data_out_mux = rd_data1;
        hready       = hready_1;
        hresp        = hresp_1;
    end else begin
        // RAM selected
        data_out_mux = rd_data2;
        hready       = hready_2;
        hresp        = hresp_2;
    end
end
endmodule
