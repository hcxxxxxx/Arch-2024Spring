`ifndef __FETCH_SV
`define __FETCH_SV

module fetch
    import common::*;
    import pipes::*;(
        input logic clk,
        input u32 pc, instruction,
        output f_d_reg_t f_d_reg
    );

    assign f_d_reg.instruction = instruction;
    assign f_d_reg.pc_plus_4 = pc + 4;

endmodule

module pc_select
    import common::*;
    import pipes::*;(
        input logic clk, reset,
        input logic stallF,
        input logic pcsrcE,
        input u32 pc_plus_4,
        input u32 pc_branch,
        output u32 pc_select
    );

    always_ff @(posedge clk) begin
        if(reset) pc_select <= 32'b0;
        else begin
            if(!stallF) begin
                pc_select <= (pcsrcE == 1'b1) ? pc_branch : pc_plus_4;
            end
        end
    end

endmodule

`endif

    //beq
    //addi
    //addi

    //F D E M W
    //  F D E M W
    //    F D E M W
