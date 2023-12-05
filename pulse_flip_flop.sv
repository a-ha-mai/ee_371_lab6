module pulse_flip_flop (
    input logic clk,
    input logic reset,
    input logic input_signal,
    output logic output_pulse
);
    logic prev_input_signal;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_input_signal <= 1'b0;
            output_pulse <= 1'b0;
        end else begin
            // Edge detection
            if (input_signal & ~prev_input_signal) begin
                output_pulse <= 1'b1;
            end else begin
                output_pulse <= 1'b0;
            end

            // Store the current state for the next cycle
            prev_input_signal <= input_signal;
        end
    end
endmodule