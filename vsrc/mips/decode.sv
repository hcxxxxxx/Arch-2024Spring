`ifndef __DECODE_SV
`define __DECODE_SV

module decode
    import common::*;
    import pipes::*;(
        input clk,
        input f_d_reg_t f_d_reg,
        input u32 src_a, rd2,
        output logic branch_judge, jump_judge,
        output u32 branch_address, jump_address,
        output d_e_reg_t d_e_reg
    );

    f_d_reg_t f_d;
    u16 imm16;
    u32 offset;

    always_ff @(posedge clk) begin
        f_d <= f_d_reg;
    end

    assign imm16 = f_d.instruction[15:0];
    assign offset = {{14{imm16[15]}}, imm16[15:0], 2'b00};

    assign d_e_reg.pc = f_d.pc;
    assign d_e_reg.pc_plus_4 = f_d.pc_plus_4;
    assign d_e_reg.instruction = f_d.instruction;
    assign d_e_reg.op = f_d.instruction[31:26];
    assign d_e_reg.func = f_d.instruction[5:0];
    assign d_e_reg.rs = f_d.rs;
    assign d_e_reg.rt = f_d.rt;
    assign d_e_reg.rd = f_d.instruction[15:11];
    assign d_e_reg.rs_word = src_a;
    assign d_e_reg.rt_word = rd2;

    always_comb begin
        if(src_a == rd2 && d_e_reg.op == F6_BEQ) begin
            branch_judge = 1'b1;
            branch_address = f_d.pc + offset;
        end
        else begin
            branch_judge = 1'b0;
            branch_address = 32'b0;
        end

        if(d_e_reg.op == F6_J) begin
            jump_judge = 1'b1;
            jump_address = {f_d.pc[31:28], f_d.instruction[25:0], 2'b00};
        end
        else begin
            jump_judge = 1'b0;
            jump_address = 32'b0;
        end
    end

endmodule

module imm_extend
    import common::*;
    import pipes::*;(
        input logic extop,
        input u16 imm16,
        output u32 imm32
    );
    
    always_comb begin
        if(extop == 1'b0) imm32 = {16'b0, imm16[15:0]};
        else imm32 = {{16{imm16[15]}}, imm16[15:0]};
    end

endmodule

`endif
