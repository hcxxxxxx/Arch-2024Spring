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

/* Define pipeline structures here */

    /*typedef enum logic [2:0] {
        ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_SLT, ALU_ADDI
    } alu_func_t;

    typedef enum logic [3:0] {
        NOP, ADD, SUB, AND, OR, SLT, ADDI, LW, SW, J, BEQ
    } decode_op_t;*/

endpackage

`endif
