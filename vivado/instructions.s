0000_0000, nope
0000_0004, addi $1, $0, #10, 001000_00000_00001_0000000000001010
0000_0008, addi $2, $0, #10, 001000_00000_00010_0000000000001010
0000_000c, beq $1, $2, true_label(#c), 000100_00001_00010_0000000000000011
0000_0010, nope
0000_0014, j failed_pc, 000010_00000000000000000000111100
0000_0018, nope
0000_001c, add $3, $1, $0   # true_label 000000_00001_00000_00011_00000_100000
0000_0020, beq $3, $2, true_label(#c), 000100_00011_00010_0000000000000011
0000_0024, nope
0000_0028, j failed_pc, 000010_00000000000000000000111100
0000_002c, nope
0000_0030, sub $3, $3, $1   # true_label 000000_00011_00001_00011_00000_100010
0000_0034, beq $3, $0, true_label(#c), 000100_00011_00000_0000000000000011
0000_0038, nope
0000_003c, j failed_pc, 000010_00000000000000000000111100
0000_0040, nope
0000_0044, addi $1, $1, #2 # true_label, 001000_00001_00001_0000000000000010
0000_0048, and $3, $1, $2, 000000_00001_00010_00011_00000_100100
0000_004c, addi $4, $0, #8, 001000_00000_00100_0000000000001000
0000_0050, beq $3, $4, true_label(#c), 000100_00011_00100_0000000000000011
0000_0054, nope
0000_0058, j failed_pc, 000010_00000000000000000000111100
0000_005c, nope
0000_0060, or $5, $1, $2 # true_label, 000000_00001_00010_00101_00000_100101
0000_0064, addi $6, $0, #14, 001000_00000_00110_0000000000001110
0000_0068, beq $5, $6, true_label(#c), 000100_00101_00110_0000000000000011
0000_006c, nope
0000_0070, j failed_pc, 000010_00000000000000000000111100
0000_0074, nope
0000_0078, slt $7, $3, $4 # true_label, 000000_00011_00100_00111_00000_101010
0000_007c, beq $7, $0, true_label(#c), 000100_00111_00000_0000000000000011
0000_0080, nope
0000_0084, j failed_pc, 000010_00000000000000000000111100
0000_0088, nope
0000_008c, slt $8, $4, $6 # true_label, 000000_00100_00110_01000_00000_101010
0000_0090, addi $9, $0, #1, 001000_00000_01001_0000000000000001
0000_0094, beq $8, $9, true_label(#c), 000100_01000_01001_0000000000000011
0000_0098, nope
0000_009c, j failed_pc, 000010_00000000000000000000111100
0000_00a0, nope
0000_00a4, sw $5, #0($0), # true_label, 101011_00000_00101_0000000000000000
0000_00a8, sw $3, #4($0), 101011_00000_00011_0000000000000100
0000_00ac, lw $11, #4($0), 100011_00000_01011_0000000000000100
0000_00b0, lw $10, #0($0), 100011_00000_01010_0000000000000000
0000_00b4, beq $10, $5, true_label(#c), 000100_01010_00101_0000000000000011
0000_00b8, nope
0000_00bc, j failed_pc, 000010_00000000000000000000111100
0000_00c0, nope
0000_00c4, beq $11, $3, true_label(#c), 000100_01011_00011_0000000000000011
0000_00c8, nope
0000_00cc, j failed_pc, 000010_00000000000000000000111100
0000_00d0, nope
0000_00d4, j true_pc, 000010_00000000000000000000111110
0000_00d8, nope
0000_00dc, nope
0000_00e0, nope
0000_00e4, nope
0000_00e8, nope
0000_00ec, nope
0000_00f0, j failed_pc, 000010_00000000000000000000111100
0000_00f4, nope
0000_00f8, j true_pc, 000010_00000000000000000000111110
0000_00fc, nope