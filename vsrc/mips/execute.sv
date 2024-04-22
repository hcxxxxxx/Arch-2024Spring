`ifndef __EXECUTE_SV
`define __EXECUTE_SV

module execute
    import common::*;
    import pipes::*;(
        input logic clk, execute_enable,
        input u32 src_a, rd2,
        input u32 instruction,
        input decode_data_t decode_data_reg,
        output execute_data_t execute_data_reg,
        output u32 branch_address,
        output logic branch_judge
    );
    
    decode_data_t dataDreg;
    u32 src_b, alu_result;
    logic equal;

    always_ff @(posedge clk) begin
        branch_judge <= (decode_data_reg.op == F6_BEQ) && equal;
        if(execute_enable) begin
            dataDreg <= decode_data_reg;
            branch_address <= decode_data_reg.pc + decode_data_reg.signimm;
        end
        else dataDreg <= '0;
    end

    always_comb begin
        if(dataDreg.op == 6'b000000) begin //r-type
            execute_data_reg.mem_to_reg = 1'b0;
            execute_data_reg.mem_write = 1'b0;
            execute_data_reg.branch = 1'b0;
            execute_data_reg.alu_src = 1'b0;
            execute_data_reg.branch_address = 32'b0;
            execute_data_reg.alu_op = dataDreg.func;
            execute_data_reg.reg_dst = 1'b1;
            execute_data_reg.reg_write = (dataDreg.func != F6_NOP);
        end
        else begin
            execute_data_reg.mem_to_reg = (dataDreg.op == F6_LW);
            execute_data_reg.mem_write = (dataDreg.op == F6_SW);
            execute_data_reg.branch = (dataDreg.op == F6_J || dataDreg.op == F6_BEQ);
            execute_data_reg.alu_src = (dataDreg.op == F6_ADDI || dataDreg.op == F6_LW || dataDreg.op == F6_SW);
            execute_data_reg.alu_op = dataDreg.op;
            execute_data_reg.reg_dst = 1'b0;
            execute_data_reg.reg_write = (dataDreg.op == F6_ADDI || dataDreg.op == F6_LW);
            execute_data_reg.branch_address = dataDreg.pc + dataDreg.signimm;
        end
    end

    assign src_b = execute_data_reg.alu_src ? dataDreg.signimm : rd2;
    assign execute_data_reg.alu_result = alu_result;
    assign execute_data_reg.equal = equal;
    assign execute_data_reg.rs = dataDreg.rs;
    assign execute_data_reg.rt = dataDreg.rt;
    assign execute_data_reg.rd = dataDreg.rd;
    assign execute_data_reg.pc = dataDreg.pc;
    assign execute_data_reg.instruction = dataDreg.instruction;

    alu alu(
        .alu_op(execute_data_reg.alu_op),
        .src_a(src_a),
        .src_b(src_b),
        .equal(equal),
        .alu_result(alu_result)
    );

endmodule

`endif 
