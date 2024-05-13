`ifndef __EXECUTE_SV
`define __EXECUTE_SV

module execute
    import common::*;
    import pipes::*;(
        input logic clk,
        input d_e_reg_t d_e_reg,
        output e_m_reg_t e_m_reg
    );

    d_e_reg_t d_e;
    u32 src_b, alu_result;
    u32 signimm32, zeroimm32;

    always_ff @(posedge clk) begin
        d_e <= d_e_reg;
    end

    always_comb begin
        if(d_e.op == F6_R_TYPE) begin
            e_m_reg.mem_to_reg = 1'b0;
            e_m_reg.mem_write = 1'b0;
            e_m_reg.alu_src = 1'b0;
            e_m_reg.reg_write = (d_e.func != F6_NOP);
            e_m_reg.reg_dst = 1'b1;
        end
        else begin
            e_m_reg.mem_to_reg = (d_e.op == F6_LW);
            e_m_reg.mem_write = (d_e.op == F6_SW);
            e_m_reg.alu_src = (d_e.op == F6_ADDI || d_e.op == F6_LW || d_e.op == F6_SW);
            e_m_reg.reg_write = (d_e.op == F6_ADDI || d_e.op == F6_LW);
            e_m_reg.reg_dst = 1'b0;
        end
    end

    assign src_b = e_m_reg.alu_src ? signimm32 : d_e.rt_word;
    assign e_m_reg.alu_result = alu_result;
    assign e_m_reg.rs = d_e.rs;
    assign e_m_reg.rt = d_e.rt;
    assign e_m_reg.rd = d_e.rd;
    assign e_m_reg.pc = d_e.pc;
    assign e_m_reg.pc_plus_4 = d_e.pc_plus_4;
    assign e_m_reg.instruction = d_e.instruction;

    alu alu(.alu_op(d_e.func),
            .src_a(d_e.rs_word),
            .src_b(src_b),
            .zero(e_m_reg.zero),
            .alu_result(alu_result));

endmodule

`endif 
