`ifndef __MEMORY_SV
`define __MEMORY_SV

module memory
    import common::*;
    import pipes::*;(
        input logic clk,
        input logic flushM,
        input e_m_reg_t e_m_reg,
        output m_w_reg_t m_w_reg,
        output u32 aluoutM, writedataM
    );

    //register
    e_m_reg_t e_m;
    always_ff @(posedge clk) begin
        if(flushM) e_m <= '0;
        else e_m <= e_m_reg;
    end

    assign m_w_reg.alu_result = e_m.alu_result;
    assign m_w_reg.mem_to_reg = e_m.mem_to_reg;
    assign m_w_reg.reg_write = e_m.reg_write;
    assign m_w_reg.write_reg = e_m.write_reg;

    assign aluoutM = e_m.alu_result;
    assign writedataM = e_m.write_data;

endmodule

`endif
