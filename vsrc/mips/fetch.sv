`ifndef __FETCH_SV
`define __FETCH_SV


module fetch
    import common::*;
    import pipes::*;(
        input logic clk,
        input u32 instr_addr,
        output u32 instruction
    );

    Imem imem(
        .pc(instr_addr),
        .instruction(instruction)
    );

endmodule

/*module pcselect
    import common::*;
    import pipes::*;(
        input logic clk, reset,
        input u32 pc_nxt,
        input u32 branch_address,
        input logic branch, equal, jump,
        output u32 pc_selected
    );

    always_ff @(posedge clk) begin
        
    end

endmodule*/

`endif
