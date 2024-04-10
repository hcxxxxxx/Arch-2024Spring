`ifndef __EXECUTE_SV
`define __EXECUTE_SV

module execute
    import common::*;
    import pipes::*;(
        input u6 op, func,
        input u26 jump_index,
        input u32 branch_tmp,
        input u32 pc, signimm,
        input logic delay_slot,
        output logic mem_to_reg, mem_write, branch, alu_src, reg_write, reg_dst, jump,
        output u6 alu_op,
        output u32 branch_address
    );

    always_comb begin
        if(op == 6'b000000) begin //r-type
            mem_to_reg = 0;
            mem_write = 0;
            branch = 0;
            alu_src = 0;
            branch_address = branch_tmp;
            alu_op = func;
            reg_dst = 1;
            jump = 0;
            reg_write = (func != F6_NOP);
        end
        else begin
            mem_to_reg = (op == F6_LW);
            mem_write = (op == F6_SW);
            branch = (op == F6_J || op == F6_BEQ);
            alu_src = (op == F6_ADDI || op == F6_LW || op == F6_SW);
            alu_op = op;
            reg_dst = 0;
            reg_write = (op == F6_ADDI || op == F6_LW);
            jump = (op == F6_J);
            if(op == F6_J && ! delay_slot) begin
                branch_address = {pc[31:28], jump_index[25:0], 2'b00}; //from jump_index to legal address
            end
            else if(op == F6_BEQ && ! delay_slot) begin
                branch_address = pc + signimm;
            end
            else branch_address = branch_tmp;
        end
    end

endmodule

module sign_extend
    import common::*;
    import pipes::*;(
        input u6 op,
        input u16 imm,
        output u32 signimm
    );
    
    always_comb begin
        if(op == F6_BEQ) signimm = {{14{imm[15]}}, imm[15:0], 2'b00};
        else signimm = {{16{imm[15]}}, imm[15:0]};
    end

endmodule

module regdst
    import common::*;
    import pipes::*;(
        input logic reg_dst,
        input creg_addr_t rt, rd,
        output creg_addr_t wa
    );

    assign wa = reg_dst ? rd : rt;

endmodule

module alusrc
    import common::*;
    import pipes::*;(
        input logic alu_src,
        input u32 rd2, signimm,
        output u32 src_b
    );

    assign src_b = alu_src ? signimm : rd2;

endmodule

`endif 
