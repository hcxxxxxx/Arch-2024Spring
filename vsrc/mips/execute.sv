`ifndef __EXECUTE_SV
`define __EXECUTE_SV

module execute
    import common::*;
    import pipes::*;(
        
    );

endmodule

module sign_extend
    import common::*;
    import pipes::*;(
        input logic ExtOp,
        input u16 imm16,
        output u32 imm32
    );
    
    always_comb begin
        if(ExtOp == 1'b0) imm32 = {16'b0, imm16[15:0]};
        else imm32 = {{16{imm16[15]}}, imm16[15:0]};
    end

endmodule

`endif 
