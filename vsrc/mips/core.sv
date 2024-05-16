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

    //pcs
    pcs_t pcs;
    assign pcs.pc_f = pc;
    always_ff @(posedge clk) begin
        pcs.pc_w <= pcs.pc_m;
        pcs.pc_m <= pcs.pc_e;
        pcs.pc_e <= pcs.pc_d;
        pcs.pc_d <= pcs.pc_f;
    end

    //wires for hazard
    hazard_data_t hazard_data;

    //wires for fetch & pc_select
    u32 pc, pc_plus_4;

    assign instr_addr = pc;
    assign pc_plus_4 = pc + 4;

    //wires for decode
    u32 rd1, rd2;

    //wires for execute & forward
    execute_forward_data_t execute_forward_data;
    creg_addr_t rsE, rtE;
    assign execute_forward_data.aluout = aluoutM;
    assign execute_forward_data.resultW = resultW;
    assign execute_forward_data.resultM = read_data;

    //wires for memory
    u32 writedataM, aluoutM;
    logic pcsrcE, mem_write_M;

    assign pcsrcE = (e_m_reg.zero && e_m_reg.branch) || e_m_reg.jump;
    assign write_enable = mem_write_M;
    assign data_addr = aluoutM;
    assign write_data = writedataM;
    assign m_w_reg.read_data = read_data;

    //wires for writeback
    u32 resultW;
    creg_addr_t write_reg;
    logic reg_write, mem_to_reg;

    //registers
    f_d_reg_t f_d_reg;
    d_e_reg_t d_e_reg;
    e_m_reg_t e_m_reg;
    m_w_reg_t m_w_reg;

    initial begin
        f_d_reg = '0;
        d_e_reg = '0;
        e_m_reg = '0;
        m_w_reg = '0;
    end

    pc_select pc_select(
        .clk(clk), .reset(reset),
        .stallF(hazard_data.stallF),
        .pcsrcE(pcsrcE),
        .pc_plus_4(pc_plus_4),
        .pc_branch(e_m_reg.pc_branch),
        .pc_select(pc)
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
        .stallD(hazard_data.stallD),
        .flushD(pcsrcE),
        .d_e_reg(d_e_reg)
    );

    execute execute(
        .clk(clk),
        .d_e_reg(d_e_reg),
        .execute_forward_data(execute_forward_data),
        .hazard_data(hazard_data),
        .e_m_reg(e_m_reg),
        .rsE(rsE), .rtE(rtE)
    );

    memory memory(
        .clk(clk),
        .flushM(hazard_data.flushM),
        .e_m_reg(e_m_reg),
        .m_w_reg(m_w_reg),
        .aluoutM(aluoutM),
        .writedataM(writedataM),
        .mem_write_M(mem_write_M)
    );

    writeback writeback(
        .clk(clk),
        .m_w_reg(m_w_reg),
        .reg_write(reg_write),
        .mem_to_reg(mem_to_reg),
        .write_reg(write_reg),
        .resultW(resultW)
    );

    hazard hazard(
        .rsD(d_e_reg.rs), .rtD(d_e_reg.rt),
        .rsE(rsE), .rtE(rtE),
        .write_reg_M(m_w_reg.write_reg),
        .write_reg_W(write_reg),
        .mem_to_reg_E(e_m_reg.mem_to_reg),
        .mem_to_reg_M(m_w_reg.mem_to_reg),
        .mem_to_reg_W(mem_to_reg),
        .reg_write_M(m_w_reg.reg_write),
        .reg_write_W(reg_write),
        .hazard_data(hazard_data)
    );

    regfile regfile(
        .clk(clk), .reset(reset),
        .ra1(d_e_reg.rs), .ra2(d_e_reg.rt),
        .rd1(rd1), .rd2(rd2),
        .wa(write_reg),
        .wd(resultW),
        .we(reg_write)
    );

endmodule

`endif
