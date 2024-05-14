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

    //wires for forward
    u2 forwardA, forwardB;

    //wires for fetch & pc_select
    u32 pc, pc_plus_4;

    assign instr_addr = pc;
    assign pc_plus_4 = f_d_reg.pc_plus_4;

    //wires for decode
    u32 rd1, rd2;

    //wires for execute & forward
    execute_forward_data_t execute_forward_data;
    assign execute_forward_data.aluout = aluoutM;

    //wires for memory
    u32 writedataM, aluoutM;
    logic pcsrcM;

    assign write_enable = e_m_reg.mem_write;
    assign data_addr = aluoutM;
    assign write_data = writedataM;
    assign m_w_reg.read_data = read_data;

    //wires for writeback
    u32 resultW;
    creg_addr_t write_reg;
    logic reg_write;

    //registers
    f_d_reg_t f_d_reg;
    d_e_reg_t d_e_reg;
    e_m_reg_t e_m_reg;
    m_w_reg_t m_w_reg;

    /* instruction */
    /*u32 pc, pc_nxt, src_a, rd2;
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
    assign write_enable = e_m_reg.mem_write;*/

    pc_select pc_select(

    );

    fetch fetch(
        .clk(clk), .pc(pc),
        .instruction(instruction),
        .f_d_reg(f_d_reg)
    );

    decode decode(
        .clk(clk),
        .rd1(rd1), .rd2(rd2),
        .f_d_reg(f_d_reg),
        .d_e_reg(d_e_reg)
    );

    execute execute(
        .clk(clk),
        .d_e_reg(d_e_reg),
        .execute_forward_data(execute_forward_data),
        .e_m_reg(e_m_reg)
    );

    memory memory(
        .clk(clk),
        .e_m_reg(e_m_reg),
        .m_w_reg(m_w_reg),
        .aluoutM(aluoutM),
        .writedataM(writedataM),
        .pcsrcM(pcsrcM)
    );

    writeback writeback(
        .clk(clk),
        .m_w_reg(m_w_reg),
        .reg_write(reg_write),
        .write_reg(write_reg),
        .resultW(resultW)
    );

    hazard hazard(

    );

    forward forward(

    );

    regfile regfile(
        .clk(clk), .reset(reset),
        .ra1(d_e_reg.rs), .ra2(d_e_reg.rt),
        .rd1(rd1), .rd2(rd2),
        .wa(write_reg),
        .wd(writeback_data),
        .we(reg_write)
    );

endmodule

`endif
