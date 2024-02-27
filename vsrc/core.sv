`ifndef __CORE_SV
`define __CORE_SV

module core
    import common::*;
    import pipes::*;(
        input logic clk, reset,
        output u32 output_pc
    );
    
    u32 pc, pc_next;
    assign output_pc = pc;
    
    /* TODO: Add your design here. */
    
endmodule

`endif
