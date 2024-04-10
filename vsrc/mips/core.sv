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
        output u1 write_enable//,
        /*output logic delay_slot,
        output logic branch, equal*/
        //output word_t [31:0] regs_tmp
    );

    /* Wires */
    u6 op, func; //func for r-type instructions
    creg_addr_t rs, rt, rd, wa;
    u16 imm;
    logic mem_to_reg, branch, equal, jump, alu_src, reg_write, reg_dst;
    logic delay_slot = 0; //=1 if branch on next posedge
    u6 alu_op;
    u26 jump_index;
    u32 alu_result, writeback_data;
    u32 branch_address, branch_tmp;// branch address register
    u32 pc, pc_nxt;
    u32 pc_selected;
    u32 src_a, src_b, signimm; //sign-extended imm
    u32 rd2;

    assign data_addr = alu_result;
    assign instr_addr = pc;
    assign pc_nxt = pc + 4;
    assign write_data = rd2;
    //assign branch_tmp = branch_address;
    
    //
    //delay_slot = 0;
    //
    
    always_ff @(posedge clk/*, posedge reset*/) begin
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
    end

    decode decode(
        .instruction(instruction),
        .op(op), .func(func),
        .rs(rs), .rt(rt), .rd(rd),
        .imm(imm),
        .jump_index(jump_index)
    );

    execute execute(
        .op(op), .func(func),
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
        .branch_address(branch_address)
    );
    
    writeback writeback(
        .mem_to_reg(mem_to_reg),
        .alu_result(alu_result),
        .read_data(read_data),
        .writeback_data(writeback_data)
    );

    alu alu(
        .alu_op(alu_op),
        .src_a(src_a),
        .src_b(src_b),
        .equal(equal),
        .alu_result(alu_result)
    );

    sign_extend sign_extend(
        .op(op),
        .imm(imm), .signimm(signimm)
    );

    regdst regdst(
        .reg_dst(reg_dst),
        .rt(rt), .rd(rd),
        .wa(wa)
    );

    alusrc alusrc(
        .alu_src(alu_src),
        .rd2(rd2),
        .signimm(signimm),
        .src_b(src_b)
    );
    
    regfile regfile(
        .clk(clk), .reset(reset),
        .ra1(rs), .ra2(rt),
        .rd1(src_a), .rd2(rd2),
        .wa(wa),
        .wd(writeback_data),
        .we(reg_write)
        //.regs_tmp(regs_tmp)
    );

endmodule

`endif
