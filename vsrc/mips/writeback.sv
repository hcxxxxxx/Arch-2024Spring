`ifndef __WRITEBACK_SV
`define __WRITEBACK_SV

module writeback
    import common::*;
    import pipes::*;(
        input logic clk,
        input m_w_reg_t m_w_reg,
        output logic reg_write,
        output creg_addr_t write_reg,
        output u32 resultW
    );

    //register
    m_w_reg_t m_w;
    always_ff @(posedge clk) begin
        m_w <= m_w_reg;
    end

    assign reg_write = m_w.reg_write;
    assign write_reg = m_w.write_reg;

    Mux2 Mux2C(.in0(m_w.alu_result), .in1(m_w.read_data),
               .Muxsel(m_w.mem_to_reg), .out(resultW));

endmodule

`endif
