`ifndef __FETCH_SV
`define __FETCH_SV


module fetch
    import common::*;
    import pipes::*;(
        input logic clk, reset, fetch_enable,
        input u32 instruction,
        input u32 pc_nxt,
        input logic branch_judge, jump_judge,
        input u32 branch_address, jump_address,
        output fetch_data_t fetch_data_reg
    );

    logic delay_slot;
    u32 pc_fetch;
    logic jump;
    logic branch;

    assign fetch_data_reg.instruction = instruction;
    assign fetch_data_reg.pc = pc_fetch;

    always_ff @(posedge clk) begin
        if(instruction[31:26] == F6_J) jump <= 1'b1;
        if(instruction[31:26] == F6_BEQ) branch <= 1'b1;
        if(reset) begin
            pc_fetch <= 32'b0;
            delay_slot <= 1'b0;
        end
        else begin
            if(fetch_enable) begin
                if(delay_slot) begin
                    delay_slot <= 1'b0;
                    if(branch_judge && branch) begin
                        pc_fetch <= branch_address;
                        branch <= 1'b0;
                    end
                    else if(jump_judge && jump) begin
                        pc_fetch <= jump_address;
                        jump <= 1'b0;
                    end
                    else pc_fetch <= pc_nxt;
                end
                else begin
                    pc_fetch <= pc_nxt;
                    if(branch || jump) delay_slot <= 1'b1;
                end
            end
        end
    end

endmodule

`endif
