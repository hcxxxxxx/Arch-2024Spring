`ifndef COMMON_SV
`define COMMON_SV

package common;
	// parameters
	parameter PC_SUCCESS = 32'h0000_ffff;
	parameter PC_FAILED = 32'h0000_fffc;

	// typedefs
	typedef logic[128:0] u129;
	typedef logic[127:0] u128;
	typedef logic[64:0] u65;
	typedef logic[63:0] u64;
	// typedef logic[62:0] u63;
	typedef logic[43:0] u44;
	typedef logic[31:0] u32;
	typedef logic[19:0] u20;
	typedef logic[15:0] u16;
	typedef logic[14:0] u15;
	typedef logic[13:0] u14;
	typedef logic[12:0] u13;
	typedef logic[11:0] u12;
	typedef logic[10:0] u11;
	typedef logic[9:0]  u10;
	typedef logic[8:0]  u9;
	typedef logic[7:0]  u8;
	typedef logic[6:0]  u7;
	typedef logic[5:0]  u6;
	typedef logic[4:0]  u5;
	typedef logic[3:0]  u4;
	typedef logic[2:0]  u3;
	typedef logic[1:0]  u2;
	typedef logic 	    u1;
    
    typedef u5 creg_addr_t;
    typedef u32 word_t;
    
	
endpackage

`endif
