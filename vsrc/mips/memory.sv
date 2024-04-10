`ifndef __MEMORY_SV
`define __MEMORY_SV

module memory
    import common::*;
    import pipes::*;(
        input logic clk,
        input logic mem_write,
        input u32 alu_result, write_data,
        output u32 read_data
    );

endmodule

`endif
