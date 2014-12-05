`timescale 1ns / 1ns

module frquency_divider_by2(
  input      clk_input,
  output reg clk_divider_by2
);

always @ (posedge clk_input) begin

    clk_divider_by2 <= ~clk_divider_by2;

end

endmodule