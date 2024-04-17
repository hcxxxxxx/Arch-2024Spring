`ifndef __FETCH_SV
`define __FETCH_SV


module fetch
    import common::*;
    import pipes::*;(
        input logic clk, reset,
        input u32 instruction,
        input u32 pc_nxt,
        input logic branch_judge,
        input u32 branch_address,
        output fetch_data_t fetch_data_reg
    );

    logic delay_slot;
    u32 pc_fetch;

    assign fetch_data_reg.instruction = instruction;
    assign fetch_data_reg.pc = pc_fetch;

    always_ff @(posedge clk) begin
        //branch_tmp = branch_address;
        if(reset) begin
            pc_fetch <= 32'b0;
            delay_slot <= 1'b0;
        end
        else begin
            if(delay_slot) begin
                pc_fetch <= branch_address;
                delay_slot <= 1'b0;
            end
            else begin
                pc_fetch <= pc_nxt;
                if(branch_judge) delay_slot <= 1'b1;
            end
        end
    end

endmodule

`endif
