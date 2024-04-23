`ifndef __PIPES_SV
`define __PIPES_SV

package pipes;
    import common::*;
    
/* Define instruction decoding rules here */

    parameter u6 F6_R_TYPE = 6'b000000;

    //No operation instruction
    parameter u6 F6_NOP = 6'b000000;

    //Operational instructions
    parameter u6 F6_ADD = 6'b100000;
    parameter u6 F6_SUB = 6'b100010;
    parameter u6 F6_AND = 6'b100100;
    parameter u6 F6_OR = 6'b100101;
    parameter u6 F6_SLT = 6'b101010;
    parameter u6 F6_ADDI = 6'b001000;

    //Memory access instructions
    parameter u6 F6_LW = 6'b100011;
    parameter u6 F6_SW = 6'b101011;

    //Branch instructions
    parameter u6 F6_J = 6'b000010;
    parameter u6 F6_BEQ = 6'b000100;

    parameter u1 E = 1'b0;
    parameter u1 M = 1'b1;

/* Define pipeline structures here */

    typedef struct packed {
        u32 pc, instruction;
        logic jump;
    } fetch_data_t;

    typedef struct packed {
        u32 pc, instruction;
        u6 op, func;
        creg_addr_t rs, rt, rd;
        u32 signimm;
    } decode_data_t;

    typedef struct packed {
        u32 pc, instruction;
        logic mem_to_reg, mem_write, branch, alu_src, reg_write, reg_dst, equal;
        u6 alu_op;
        u32 branch_address;
        u32 alu_result;
        creg_addr_t rs, rt, rd;
    } execute_data_t;

    typedef struct packed {
        u32 pc, instruction;
        logic mem_to_reg, reg_dst, reg_write;
        u32 alu_result;
        creg_addr_t rs, rt, rd;
    } memory_data_t;

    typedef struct packed {
        u32 pc, instruction;
        logic reg_dst, reg_write;
        u32 alu_result, writeback_data;
        creg_addr_t rs, rt, rd;
    } writeback_data_t;

    typedef struct packed {
        logic fetch_enable, decode_enable, execute_enable, memory_enable, writeback_enable, m_or_e;
    } state_enable_t;

endpackage

`endif
