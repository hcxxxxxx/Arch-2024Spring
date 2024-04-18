`ifndef __WRITEBACK_SV
`define __WRITEBACK_SV

module writeback
    import common::*;
    import pipes::*;(
        /*input logic mem_to_reg,
        input u32 alu_result, read_data,
        output u32 writeback_data*/
        input logic clk, writeback_enable, m_or_e,
        input u32 read_data,
        input execute_data_t execute_data_reg,
        input memory_data_t memory_data_reg,
        output writeback_data_t writeback_data_reg
    );

    execute_data_t dataEreg;
    memory_data_t dataMreg;

    always_ff @(posedge clk) begin
        if(writeback_enable) begin
            unique case(m_or_e)
                E: dataEreg <= execute_data_reg;
                M: dataMreg <= memory_data_reg;
                default: begin
                    dataEreg <= '0;
                    dataMreg <= '0;
                end
            endcase
        end
        else begin
            //dataEreg <= '0;
            //dataMreg <= '0;
        end
    end

    always_comb begin
        if(m_or_e == E) begin
            writeback_data_reg.pc = dataEreg.pc;
            writeback_data_reg.instruction = dataEreg.instruction;
            writeback_data_reg.reg_dst = dataEreg.reg_dst;
            writeback_data_reg.reg_write = dataEreg.reg_write;
            writeback_data_reg.alu_result = dataEreg.alu_result;
            writeback_data_reg.writeback_data = dataEreg.mem_to_reg ? read_data : dataEreg.alu_result;
            writeback_data_reg.rs = dataEreg.rs;
            writeback_data_reg.rt = dataEreg.rt;
            writeback_data_reg.rd = dataEreg.rd;
        end
        else begin
            writeback_data_reg.pc = dataMreg.pc;
            writeback_data_reg.instruction = dataMreg.instruction;
            writeback_data_reg.reg_dst = dataMreg.reg_dst;
            writeback_data_reg.reg_write = dataMreg.reg_write;
            writeback_data_reg.alu_result = dataMreg.alu_result;
            writeback_data_reg.writeback_data = dataMreg.mem_to_reg ? read_data : dataMreg.alu_result;
            writeback_data_reg.rs = dataMreg.rs;
            writeback_data_reg.rt = dataMreg.rt;
            writeback_data_reg.rd = dataMreg.rd;
        end
    end

endmodule

`endif
