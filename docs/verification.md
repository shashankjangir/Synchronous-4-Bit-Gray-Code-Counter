# Verification

## Recorded local status

On 2026-10-11, `scripts/check_logic.py` passed the exhaustive 16-state mathematical check. This script does not parse or execute Verilog. It cannot detect RTL syntax, simulator scheduling, or synthesis errors.

The two HDL testbenches are provided but have not been executed locally because Icarus Verilog was not found. HDL simulation, waveform review, and hardware reproduction remain pending. No synthesis, resource, or timing results are claimed.

## HDL tests

`tb_sr_ff` checks startup, holding zero, set, holding one, reset, the illegal 11 input, and recovery by set/reset. X behavior is a simulation diagnostic, not a hardware feature.

`tb_gray_counter_4bit` checks 64 transitions (four full cycles), comparing each state with an independently generated Gray reference. It checks initialization, one-bit changes, SR legality before each edge, falling-edge stability, and unexpected output changes between rising edges. Sampling occurs after nonblocking updates. Both tests include a timeout and terminate with a nonzero result on failure.

Run `scripts/simulate.ps1` from PowerShell after installing a compatible simulator. On success, retain the console output and review `build/gray_counter.vcd` with clk and Q3..Q0 displayed together. Annotate one full cycle and wraparound for the portfolio.

## Remaining checks

- Run both HDL tests and save their actual results here.
- Deliberately change one toggle condition in a temporary copy and confirm the counter test fails; restore the source afterward.
- Review the waveform and confirm bit labels match the displayed vector order.
- Compile for the verified board device, inspect warnings, and check timing constraints/results.
- Compare physical LED observations with the same state sequence.

There is no reset test because the original design has no reset input. If reset or enable is introduced later, label it as an extension and expand the tests.

## Software-model illustration

`scripts/generate_vcd.py` checks all 64 transitions before writing `build/gray_counter_model.vcd`. Incorrect transitions raise errors rather than printing PASS. The VCD header identifies a Python model and its initialization block ends before subsequent timestamps. It does not execute RTL. The legacy `build/gray_counter.vcd` present before this repair was Python-generated and is not evidence of a successful HDL run.

On 2026-10-12, the repaired generator passed all 64 transitions. In-memory fault injection tested a stuck-at-zero model and a model failing at transition 33: both exited nonzero, printed no PASS, and left the existing model file unchanged. The legacy HDL-path file's SHA-256 was unchanged before and after these checks. Initialization-block closure and the 129-event count were checked. The independent 16-state equation check also passed. These are software checks only; HDL simulation remains pending.
