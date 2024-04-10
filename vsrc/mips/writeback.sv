`ifndef __WRITEBACK_SV
`define __WRITEBACK_SV

module writeback
    import common::*;
    import pipes::*;(
        input logic mem_to_reg,
        input u32 alu_result, read_data,
        output u32 writeback_data
    );

    assign writeback_data = mem_to_reg ? read_data : alu_result;

endmodule

`endif
