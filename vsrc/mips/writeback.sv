`ifndef __WRITEBACK_SV
`define __WRITEBACK_SV

module writeback
    import common::*;
    import pipes::*;(
        input logic clk,
        input u32 read_data,
        input m_w_reg_t m_w_reg,
        output logic wb_reg_dst, wb_reg_write,
        output creg_addr_t wb_rd, wb_rt,
        output u32 writeback_data
    );

    m_w_reg_t m_w;

    always_ff @(posedge clk) begin
        m_w <= m_w_reg;
    end

    assign wb_reg_dst = m_w.reg_dst;
    assign wb_reg_write = m_w.reg_write;
    assign wb_rt = m_w.rt;
    assign wb_rd = m_w.rd;
    assign writeback_data = m_w.mem_to_reg ? read_data : m_w.alu_result;

endmodule

`endif
