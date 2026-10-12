# Synchronous 4-Bit Gray Code Counter

Verilog reconstruction of the ELL201 course lab project: a synchronous 16-state Gray counter using clocked SR flip-flop behavior.

## Status

- Original lab reports and photos are preserved in their existing folders.
- Verilog source is reconstructed from the code screenshot in the project report.
- Two self-checking HDL testbenches and a Windows simulation script are included.
- The exhaustive software-model check passes all 16 transitions.
- **HDL simulation has not yet been run locally:** Icarus Verilog was not available during setup.
- Quartus settings are reconstructed from the Helium v1.1 manual; physical board confirmation, compilation and timing analysis remain pending.
- This is a documented reconstruction in progress, not a fully hardware-validated release.

## Sequence

Bit order is `Q3 Q2 Q1 Q0`.

```text
0000 -> 0001 -> 0011 -> 0010 -> 0110 -> 0111 -> 0101 -> 0100
     -> 1100 -> 1101 -> 1111 -> 1110 -> 1010 -> 1011 -> 1001 -> 1000 -> 0000
```

All four registers use the same rising clock edge. Exactly one state bit changes at each edge.

## Files

| Path | Purpose |
| --- | --- |
| `rtl/` | SR module and report-derived parity counter |
| `tb/` | SR unit test and 64-transition counter test |
| `scripts/simulate.ps1` | Compile and run both HDL tests with Icarus Verilog |
| `scripts/check_logic.py` | Exhaustive mathematical check independent of an HDL simulator |
| `docs/design.md` | Excitation rules, direct equations, and parity explanation |
| `docs/verification.md` | Test coverage and verification status |
| `docs/hardware.md` | Manual-derived hardware setup and remaining validation |
| `docs/interview_revision.md` | Focused revision questions and answers |
| `docs/publishing_checklist.md` | Owner's report-editing and publication checklist |
| `IMPLEMENTATION_PLAN.md` | Scope, work packages, and acceptance criteria |
| `experiment 5/`, `experiment 6/`, `project report/` | Unchanged original reference materials |

## Run the checks

From the project root, with Python 3.10+:

```powershell
python scripts/check_logic.py
```

With `iverilog` and `vvp` on PATH:

```powershell
powershell -NoProfile -File scripts/simulate.ps1
```

The counter test writes `build/gray_counter.vcd`, which can be opened in a waveform viewer. Both HDL tests must print PASS and exit successfully before claiming HDL verification.

Alternatively, compile the two files in `rtl/` and one testbench in a simulator supporting SystemVerilog. Select `tb_gray_counter_4bit` or `tb_sr_ff` as the simulation top, and create a `build` directory for waveform output.

## Provenance and limitations

This was a group course lab exercise. The reports document state-table/K-map work, Verilog, and board photographs. The source transcription, automated tests, and explanatory documentation here are later additions; they are not evidence of a new hardware run. Individual contributions should be stated by the owner before publication.

The original interface has no reset or enable. Its `initial` value models startup in simulation; hardware support must be checked for the actual target. Modeling SR behavior does not require native SR registers inside the CPLD. Pins are manual-derived; actual board setup and timing results remain unverified.

The original reports contain personal details. They are excluded from Git by default until the owner edits and deliberately selects the files to publish. No license has been selected yet.

## Optional software-model waveform

Run `python scripts/generate_vcd.py` to create `build/gray_counter_model.vcd`. This checks 64 mathematical transitions and labels the waveform as a Python model. It does not replace HDL simulation and never writes the HDL output path `build/gray_counter.vcd`.
