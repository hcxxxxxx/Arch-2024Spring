`ifndef __MEMORY_SV
`define __MEMORY_SV

module memory
    import common::*;
    import pipes::*;(
        input logic clk,
        input e_m_reg_t e_m_reg,
        output m_w_reg_t m_w_reg
    );

    e_m_reg_t e_m;

    always_ff @(posedge clk) begin
        e_m <= e_m_reg;
    end

    assign m_w_reg.pc = e_m.pc;
    assign m_w_reg.pc_plus_4 = e_m.pc_plus_4;
    assign m_w_reg.instruction = e_m.instruction;
    assign m_w_reg.mem_to_reg = e_m.mem_to_reg;
    assign m_w_reg.reg_dst = e_m.reg_dst;
    assign m_w_reg.alu_result = e_m.alu_result;
    //assign m_w_reg.rs = e_m.rs;
    assign m_w_reg.rt = e_m.rt;
    assign m_w_reg.rd = e_m.rd;
    //assign m_w_reg.rs_word = e_m.rs_word;
    //assign m_w_reg.rt_word = e_m.rt_word;

endmodule

`endif
