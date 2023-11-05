module test_classifier;

  localparam posit_pkg::posit_format_e TEST_FORMAT = posit_pkg::posit_format_e'(0);  
  localparam int unsigned NUM_TEST_OPERANDS = 5;   // Number of test operands

  // Instantiate the DUT (Device Under Test)
  logic [NUM_TEST_OPERANDS-1:0][posit_pkg::posit_width(TEST_FORMAT)-1:0] test_operands;
  posit_pkg::posit_info_t [NUM_TEST_OPERANDS-1:0] test_info;

  posit_classifier #(.pFormat(TEST_FORMAT), .NumOperands(NUM_TEST_OPERANDS)) DUT (.operands_i(test_operands),.info_o(test_info));

  initial begin
    test_operands[0] = 32'b00000000000000000000000000000000; // zero
    test_operands[1] = 32'b10000000000000000000000000000000; // NaR
    test_operands[2] = 32'b11111111111111111111111111111111; // ones
    test_operands[3] = 32'b10000000000000000000000000000001; // neg
    test_operands[4] = 32'b01100000000000000000000000000001; // pos

    #10;

    $display("Classification Results:");
    for (int i = 0; i < NUM_TEST_OPERANDS; i++) begin
      $display("Operand %0d: is_zero=%b, is_NaR=%b, is_pos=%b, is_neg=%b", 
               i, test_info[i].is_zero, test_info[i].is_NaR, test_info[i].is_pos, test_info[i].is_neg);
    end

    $stop;
  end
endmodule