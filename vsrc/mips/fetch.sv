`ifndef __FETCH_SV
`define __FETCH_SV

module fetch
    import common::*;
    import pipes::*;(
        input logic clk, reset,
        input u32 instruction,
        input logic branch_judge, jump_judge,
        input u32 branch_address, jump_address,
        input u32 pc_plus_4,
        output f_d_reg_t f_d_reg
    );

    u32 pc_fetch;

    assign f_d_reg.instruction = instruction;
    assign f_d_reg.pc = pc_fetch;
    assign f_d_reg.pc_plus_4 = pc_fetch + 4;

    always_ff @(posedge clk) begin
        if(reset) begin
            pc_fetch <= 32'b0;
        end
        else begin
            if(branch_judge) pc_fetch <= branch_address;
            else if(jump_judge) pc_fetch <= jump_address;
            else pc_fetch <= pc_plus_4;
        end
    end
endmodule

`endif
