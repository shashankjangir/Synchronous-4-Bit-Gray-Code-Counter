# Local implementation plan

All development stays in this folder. Do not push or publish without an explicit request.

## Scope

Reconstruct the SR-based Gray counter shown in the course project report, verify it, and organize a reproducible portfolio project. Preserve the original reports and photos in `experiment 5/`, `experiment 6/`, and `project report/`.

## Work packages

1. Reconstruct the original parity-based counter as readable Verilog modules. Retain its interface and initialization behavior; do not silently add reset or enable.
2. Add a self-checking SystemVerilog testbench for the exact sequence, wraparound, one-bit transitions, legal SR inputs, and clock-edge behavior. Test the SR module independently.
3. Add an exhaustive software check of all 16 states against independently generated reflected Gray code. This complements, but does not replace, HDL simulation.
4. Document the excitation table, K-map workflow, direct equations, and their relationship to the parity implementation.
5. Provide repeatable simulation commands and an interview revision guide.
6. Recover the board device, clock source, LED mapping, verified pin assignments, Quartus settings, and compilation reports before adding a hardware project. Never invent pin numbers.
7. Before publishing, the owner will edit names and entry numbers in the original reports and choose which reports/photos to include. Review the exact file list before any future upload.

## Original versus reconstructed work

The source is transcribed from the report's code screenshot. Comments, automated checks, scripts, and documentation are later additions. New local verification does not constitute a new CPLD demonstration. The original reports remain unchanged.

## Acceptance criteria

- All 16 states follow the expected cyclic Gray sequence.
- Exactly one output bit changes per rising clock edge.
- No SR pair equals 11 in any counter state.
- Counter outputs are known after initialization and stable between active edges.
- The SR module holds, sets, and resets correctly; illegal input produces X in simulation.
- Simulation and software-check results are reported separately and honestly.
- Board-specific files are added only when their settings can be verified.
