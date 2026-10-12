# Reference timing intent only; not automatically loaded by the QSF.
# Confirm which timing analyzer the legacy MAX 3000A flow supports.
# If using Classic Timing Analyzer, configure the equivalent clock there.
# The manual specifies a 1 Hz onboard clock: period = 1e9 ns.
create_clock -name clk -period 1000000000 [get_ports clk]

# No invented data-input delay on the clock or external LED timing requirements.
# Accepted constraints and actual timing results remain pending.
