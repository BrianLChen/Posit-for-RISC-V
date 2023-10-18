
module posit_classifier #(
  parameter posit_pkg::posit_format_e   pFormat = posit_pkg::posit_format_e'(0),
  parameter int unsigned             NumOperands = 1,
  localparam int unsigned WIDTH = posit_pkg::posit_width(pFormat)
) (
  input  logic                [NumOperands-1:0][WIDTH-1:0] operands_i,
  input  logic                [NumOperands-1:0]            is_boxed_i,
  output posit_pkg::posit_info_t [NumOperands-1:0]            info_o
);

  // Fixed exponent size
  localparam int unsigned EXP_BITS = posit_pkg::exp_bits(pFormat);

  // Iterate through all operands
  for (genvar op = 0; op < int'(NumOperands); op++) begin : gen_num_values
    logic is_boxed;
    logic is_zero;
    logic is_inf;
    logic is_NaR;
    logic is_pos;
    logic is_neg;
    logic sign;
    logic [31:0] regime, exponent, fraction;

    // ---------------
    // Classify Input
    // ---------------
    always_comb begin : classify_input
      // calculate the sizes for regime and fraction bits dynamically
      regime = posit_pkg::extract_regime(operands_i[op]);
      exponent = posit_pkg::extract_exponent(operands_i[op]);
      fraction = posit_pkg::extract_fraction(operands_i[op]);
      sign = operands_i[op][WIDTH-1];

      is_boxed      = is_boxed_i[op];
      is_zero       = is_boxed && (sign == '0) && (regime == '0) && (exponent == '0) && (fraction == '0);
      is_inf        = is_boxed && (sign == '1) && (regime == '0) && (exponent == '0) && (fraction == '0);
      is_NaR        = is_boxed && (operands_i[op] == {WIDTH{1'b1}});
      is_pos 		  = is_boxed && (sign == '0) && ~is_zero && ~is_NaR;
      is_neg		  = is_boxed && (sign == '1) && ~is_zero && ~is_NaR;
      // Assign output for current input
      info_o[op].is_zero = is_zero;
      info_o[op].is_inf = is_inf;
      info_o[op].is_NaR = is_NaR;
      info_o[op].is_pos = is_pos;
      info_o[op].is_neg = is_neg;
      
    end
  end
endmodule