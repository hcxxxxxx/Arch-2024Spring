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

    /* Wires */
    //u6 op, func; //func for r-type instructions
    //creg_addr_t rs, rt, rd, wa;
    //u16 imm;
    //logic mem_to_reg, branch, equal, jump, alu_src, reg_write, reg_dst;
    //logic delay_slot = 0; //=1 if branch on next posedge
    //u6 alu_op;
    //u26 jump_index;
    //u32 alu_result, writeback_data;
    //u32 branch_address, branch_tmp;// branch address register
    u32 pc, pc_nxt, src_a, rd2;
    u32 branch_address;

    fetch_data_t fetch_data_reg;
    decode_data_t decode_data_reg;
    execute_data_t execute_data_reg;
    memory_data_t memory_data_reg;
    writeback_data_t writeback_data_reg;

    state_enable_t state_enable;

    logic fetch_enable, decode_enable, execute_enable, memory_enable, writeback_enable, m_or_e;
    logic branch_judge;

    assign fetch_enable = state_enable.fetch_enable;
    assign decode_enable = state_enable.decode_enable;
    assign execute_enable = state_enable.execute_enable;
    assign memory_enable = state_enable.memory_enable;
    assign writeback_enable = state_enable.writeback_enable;
    assign m_or_e = state_enable.m_or_e;

    assign data_addr = memory_data_reg.alu_result;
    assign pc = fetch_data_reg.pc;
    assign instr_addr = pc;
    assign pc_nxt = pc + 4;
    assign write_data = rd2;

    assign write_enable = execute_data_reg.mem_write;
    
    //
    //delay_slot = 0;
    //
    
    /*always_ff @(posedge clk) begin
        branch_tmp = branch_address;
        if(reset) begin
            pc <= 32'b0;
            delay_slot <= 0;
        end
        else begin
            if(delay_slot) begin
                pc <= branch_address;
                delay_slot <= 0;
            end
            else begin
                pc <= pc_nxt;
                if(branch && equal || jump) delay_slot <= 1;
            end
        end
    end*/

    FSM FSM(
        .clk(clk), .reset(reset),
        .instruction(instruction),
        .state_enable(state_enable)
    );

    fetch fetch(
        .clk(clk), .reset(reset), .fetch_enable(fetch_enable),
        .instruction(instruction),
        .pc_nxt(pc_nxt),
        .branch_judge(branch_judge),
        .jump_judge(decode_data_reg.jump),
        .branch_address(branch_address), .jump_address(decode_data_reg.jump_address),
        .fetch_data_reg(fetch_data_reg)
    );

    decode decode(
        /*.instruction(instruction),
        .op(op), .func(func),
        .rs(rs), .rt(rt), .rd(rd),
        .imm(imm),
        .jump_index(jump_index)*/
        .clk(clk), .decode_enable(decode_enable),
        .fetch_data_reg(fetch_data_reg),
        .decode_data_reg(decode_data_reg)
    );

    execute execute(
        /*.op(op), .func(func),
        .jump_index(jump_index),
        .branch_tmp(branch_tmp),
        .pc(pc), .signimm(signimm),
        .delay_slot(delay_slot),
        .mem_to_reg(mem_to_reg),
        .mem_write(write_enable),
        .branch(branch),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .reg_dst(reg_dst),
        .jump(jump),
        .alu_op(alu_op),
        .branch_address(branch_address)*/
        .clk(clk), .execute_enable(execute_enable),
        .src_a(src_a), .rd2(rd2),
        .instruction(instruction),
        .decode_data_reg(decode_data_reg),
        .execute_data_reg(execute_data_reg),
        .branch_address(branch_address),
        .branch_judge(branch_judge)
    );

    memory memory(
        .clk(clk), .memory_enable(memory_enable),
        .execute_data_reg(execute_data_reg),
        .memory_data_reg(memory_data_reg)
    );
    
    writeback writeback(
        /*.mem_to_reg(mem_to_reg),
        .alu_result(alu_result),
        .read_data(read_data),
        .writeback_data(writeback_data)*/
        .clk(clk), .writeback_enable(writeback_enable),
        .m_or_e(m_or_e),
        .read_data(read_data),
        .execute_data_reg(execute_data_reg),
        .memory_data_reg(memory_data_reg),
        .writeback_data_reg(writeback_data_reg)
    );

    /*alu alu(
        .alu_op(alu_op),
        .src_a(src_a),
        .src_b(src_b),
        .equal(equal),
        .alu_result(alu_result)
    );*/

    /*sign_extend sign_extend(
        .op(op),
        .imm(imm), .signimm(signimm)
    );*/

    /*regdst regdst(
        .reg_dst(reg_dst),
        .rt(rt), .rd(rd),
        .wa(wa)
    );*/

    /*alusrc alusrc(
        .alu_src(alu_src),
        .rd2(rd2),
        .signimm(signimm),
        .src_b(src_b)
    );*/
    
    regfile regfile(
        .clk(clk), .reset(reset),
        .ra1(writeback_data_reg.rs), .ra2(writeback_data_reg.rt),
        .rd1(src_a), .rd2(rd2),
        .wa(writeback_data_reg.reg_dst ? decode_data_reg.rd : decode_data_reg.rt),
        .wd(writeback_data_reg.writeback_data),
        .we(writeback_data_reg.reg_write)
    );

endmodule

`endif
