`ifndef __CORE_SV
`define __CORE_SV

module core
    import common::*;
    import pipes::*;(
        input logic clk, reset,
        /* instruction memory */
        output u32 instr_addr,
        input u32 instruction,
        /* data memory */
        output u32 data_addr,
        input word_t read_data,
        output word_t write_data,
        output u1 write_enable
    );
    
    /* instruction */
    u32 pc, pc_nxt, src_a, rd2;
    u32 branch_address, jump_address;
    logic branch_judge, jump_judge;

    creg_addr_t wb_rt, wb_rd;
    logic wb_reg_dst, wb_reg_write;
    u32 writeback_data;

    f_d_reg_t f_d_reg;
    d_e_reg_t d_e_reg;
    e_m_reg_t e_m_reg;
    m_w_reg_t m_w_reg;

    assign instr_addr = pc;
    assign data_addr = m_w_reg.alu_result;

    assign pc = f_d_reg.pc;
    assign pc_nxt = pc + 4;
    assign write_data = e_m_reg.rt_word;
    assign write_enable = e_m_reg.mem_write;

    fetch fetch(
        .clk(clk), .reset(reset),
        .instruction(instruction),
        .branch_judge(branch_judge),
        .jump_judge(jump_judge),
        .branch_address(branch_address),
        .jump_address(jump_address),
        .pc_plus_4(pc + 4),
        .f_d_reg(f_d_reg)
    );

    decode decode(
        .clk(clk), .f_d_reg(f_d_reg),
        .src_a(src_a), .rd2(rd2),
        .branch_judge(branch_judge),
        .jump_judge(jump_judge),
        .branch_address(branch_address),
        .jump_address(jump_address),
        .d_e_reg(d_e_reg)
    );

    execute execute(
        .clk(clk),
        .d_e_reg(d_e_reg),
        .e_m_reg(e_m_reg)
    );

    memory memory(
        .clk(clk),
        .e_m_reg(e_m_reg),
        .m_w_reg(m_w_reg)
    );

    writeback writeback(
        .clk(clk), .read_data(read_data),
        .m_w_reg(m_w_reg),
        .wb_reg_dst(wb_reg_dst),
        .wb_reg_write(wb_reg_write),
        .wb_rd(wb_rd), .wb_rt(wb_rt),
        .writeback_data(writeback_data)
    );

    hazard hazard(

    );

    forward forward(

    );

    regfile regfile(
        .clk(clk), .reset(reset),
        .ra1(f_d_reg.rs), .ra2(f_d_reg.rt),
        .rd1(src_a), .rd2(rd2),
        .wa(wb_reg_dst ? wb_rd : wb_rt),
        .wd(writeback_data),
        //.we(wb_reg_write)
        .we(wb_reg_write && clk)
    );

endmodule

`endif
