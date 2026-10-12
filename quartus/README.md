# Quartus project: reconstruction pending validation

These files target the Helium v1.1 board described in the [IIT Bombay manual](https://lab.daiict.ac.in/images/pdf/Helium%20User%20Manual.pdf). They have not been compiled or programmed locally.

Use **Quartus II 13.0 SP1**, the latest MAX 3000A release listed in the [Altera support matrix](https://www.altera.com/design/guidance/software/device-support).

- `gray_counter.qpf`: reconstructed project descriptor.
- `gray_counter.qsf`: source paths and manual-derived mapping: clk=43, q0=24, q1=25, q2=26, q3=27. Confirm the board revision and electrical settings.
- `gray_counter.sdc`: reference 1 Hz clock intent, not auto-loaded. Configure and verify the supported legacy timing-analyzer flow before claiming timing results.
- `compilation_summary.txt`: pending-results template, not a compilation report.

Follow [hardware instructions](../docs/hardware.md) for SVF generation and UrJTAG programming. Resource counts, warnings, timing and board operation remain pending actual execution.
