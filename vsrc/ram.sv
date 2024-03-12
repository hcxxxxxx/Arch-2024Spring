`ifndef __RAM_SV
`define __RAM_SV

module imem
    import common::*;
    import pipes::*;
    #(parameter VALID_ADDR_WIDTH = 8)(
        input u32 pc,
        output u32 instruction
    );

    u8 mem [2**VALID_ADDR_WIDTH-1:0];

    assign instruction = {
        mem[pc[VALID_ADDR_WIDTH-1:0]],
        mem[pc[VALID_ADDR_WIDTH-1:0]+1],
        mem[pc[VALID_ADDR_WIDTH-1:0]+2],
        mem[pc[VALID_ADDR_WIDTH-1:0]+3]
    };

    initial begin
        $readmemh("instructions.mem", mem);
    end

endmodule

module dmem
    import common::*;
    import pipes::*;
    #(parameter VALID_ADDR_WIDTH = 8)(
        input logic clk,
        input logic we,
        input u32 addr,
        input word_t write_data,
        output word_t read_data
    );

    u32 mem [2**VALID_ADDR_WIDTH-1:0];

    // read port
    assign data = mem[addr[VALID_ADDR_WIDTH-1:0]];

    // write port
    always_ff @(posedge clk) begin
        if (we) begin
            mem[addr[VALID_ADDR_WIDTH-1:0]] <= write_data;
        end
    end

endmodule

`endif
