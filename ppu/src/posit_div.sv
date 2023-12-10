/////////////////////////////////////////////////////////////////////
// Design unit: Posit Division Arithmetic
//            :
// File name  : DIV_Arithmetic.sv
//            :
// Description:
//            :
// Limitations:
//            :
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan(Jasper) He   Letian(Brian) Chen
//            : xh2g20@soton.ac.uk  lc1e20@soton.ac.uk
//
// Revision   : Version 1.0 25/10/2023
/////////////////////////////////////////////////////////////////////

module posit_div #(
  parameter posit_pkg::posit_format_e   pFormat = posit_pkg::posit_format_e'(0),
	localparam int unsigned N = posit_pkg::posit_width(pFormat), 
	localparam int unsigned ES = posit_pkg::exp_bits(pFormat), 
	localparam int unsigned RS = $clog2(N)
) (
	input logic Enable, 
	input  logic signed Sign1, Sign2,
  input  logic signed [N-2:0] InRemain1, InRemain2,
  input  logic signed [RS:0] k1,k2,
  input  logic [ES-1:0] Exponent1, Exponent2,
  input  logic [N-1:0] Mantissa1, Mantissa2,
  input  logic NaR1, NaR2,
  input  logic zero1, zero2,
  output logic [2*N-1:0] Div_Mant_N,
  output logic [ES-1:0] E_O,
  output logic signed [RS+4:0] R_O,
  output logic NaR, zero, Sign, OF, UF,
	output logic sign_Exponent_O
  );

  int i;
  logic [3*N-1:0] Div_Mant, Div_Mant_temp_large;
  logic [2*N-1:0] Div_Mant_temp;
  logic [3*N-1:0] dividend, divisor; 
  logic signed [1:0]sumE_Ovf;
  logic signed[ES+2:0] sumE; // 2 more bit: ES+1 for sign, ES for overflow
  logic [RS+ES+4:0] Total_EON, Total_EO;
	logic signed [RS+4:0] sumR;
  logic signed [ES+1:0]signed_E1, signed_E2;
  logic signed [1:0]Div_Mant_underflow;
	logic sign_Exponent_o;

  always_comb begin
	 Sign = 0;
	 R_O =  0;
	 E_O =  0;
	 Div_Mant_N = 0;
	 Total_EO =  0;
	 sumR = 0;
	 NaR = 0;
	 zero = 0;
	 OF = 0;
	 UF = 0;
   if (Enable) begin
     //  check NaR and zero
     NaR = NaR1 | NaR2;
     zero = zero1 | zero2;

     // DIVISION ARITHMETIC     
     Sign = Sign1 ^ Sign2;
     // dividend = {Mantissa1, {N-1{0}}};
     dividend = Mantissa1 << 2*N;
     divisor = Mantissa2;

     signed_E1 = {2'b00, Exponent1};
     signed_E2 = {2'b00, Exponent2};

     //  Mantissa Division Handling
     Div_Mant = dividend / divisor;
     Div_Mant_temp_large = Div_Mant << N-3;
     Div_Mant_temp = {Div_Mant_temp_large[3*N-1:N-1], |Div_Mant_temp_large[N:0]};

     if(Div_Mant_temp[2*N-1]) begin // DMT's MSB is 1 => divisor's fraction < dividend's
       Div_Mant_N = Div_Mant_temp;
       Div_Mant_underflow = '0;
     end else begin // divisor's fraction > dividend's
       Div_Mant_N = Div_Mant_temp << 1;  //  normalise it
       Div_Mant_underflow = 2'b11; //  will be taking 1 away from exponent
     end

     sumE = signed_E1 - signed_E2 + Div_Mant_underflow;  // signed 2'b11 is -1
     sumE_Ovf = {1'b0, sumE[ES]};
     sumR = k1-k2;

     Total_EO = (sumR<<ES)+ sumE;


     E_O = sumE[ES-1:0];

     sign_Exponent_O = Total_EO[RS+ES+4];

     if(Total_EO[RS+ES+4]) // negative Total_EO
       Total_EON = -Total_EO;
     else            // positive exponent
       Total_EON = Total_EO;

     if(~Total_EO[RS+ES+4])  //+ve Total_EO
       R_O = Total_EON[ES+RS+3:ES] + 1; // +1 due to K = m-1 w/1
     else if (Total_EO[RS+ES+4] & |(Total_EON[ES-1:0]))
       R_O = Total_EON[ES+RS+3:ES] + 1;
     else
     R_O = Total_EON[RS+ES+3:ES];

		 OF = (sumR > 31)? 1:0;
		 UF = (sumR < -30)? 1:0;
		end
	end
endmodule