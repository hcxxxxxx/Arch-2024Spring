`ifndef __TEST_SV
`define __TEST_SV

module TopTest
    import common::*;(
        input logic clk, reset,
        output u2 result
    );
    
    u32 pc;
    
    core core(
        .clk(clk),
        .reset(reset),
        .output_pc(pc)
    );
    
    always_comb begin
        case (pc)
            PC_SUCCESS: result = 2'b10;
            PC_FAILED: result = 2'b01;
            default: result = 2'b00;
        endcase
    end
    
endmodule

`endif
