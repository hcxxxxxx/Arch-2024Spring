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

    /*always_ff @(posedge clk) begin
        if(reset) begin
            pc_fetch <= 32'b0;
        end
        else begin
            if(branch_judge) pc_fetch <= branch_address;
            else if(jump_judge) pc_fetch <= jump_address;
            else pc_fetch <= pc_fetch + 4;
        end
    end*/
endmodule

module pc_select
    import common::*;
    import pipes::*;(
        
    );

endmodule

`endif
