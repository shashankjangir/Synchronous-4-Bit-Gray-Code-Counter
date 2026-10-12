# Hardware notes: Helium v1.1

These settings are reconstructed from the board manual, not recovered from the original lab project. Confirm the physical board revision and chip marking before programming. Compilation and a new board run are pending.

## References

- [IIT Bombay Helium v1.1 user manual, hosted by DA-IICT](https://lab.daiict.ac.in/images/pdf/Helium%20User%20Manual.pdf): device, clock, pin table and programming procedure.
- [Altera device support matrix](https://www.altera.com/design/guidance/software/device-support): MAX 3000A support ends at Quartus II 13.0 SP1.
- [Quartus II 13.1 release notes](https://cdrdv2-public.intel.com/682216/rn_qts_131_dev_support.pdf): MAX 3000A support was removed in 13.1.

## Target and clock

The manual specifies EPM3064ALC44-10N, a MAX 3000A device. The project uses the EPM3064ALC44-10 identifier; verify the device entry in Quartus II 13.0 SP1. The manual documents USB power/programming using an FT2232 interface and an onboard 1 Hz clock selected with CKSEL pins 1-2. Confirm I/O voltage and LED polarity against the actual board; the settings currently request 3.3-V LVTTL.

## Pin assignments

The manual numbers LEDs LED1 through LED8. This reconstruction uses the first four:

| Signal | Pin | Manual resource |
| --- | --- | --- |
| clk | 43 | Global clock, onboard 1 Hz source |
| q0 | 24 | LED1 |
| q1 | 25 | LED2 |
| q2 | 26 | LED3 |
| q3 | 27 | LED4 |

Read the state as q3 q2 q1 q0, corresponding to LED4 LED3 LED2 LED1. This is a new documented mapping, not proof of the original lab mapping. Pin 14 is SW8; pins 16, 18 and 19 are external I/O, not onboard LED outputs.

## Compile and program

1. Confirm board revision, device, jumpers and I/O settings. Use Quartus II 13.0 SP1 with MAX 3000A support.
2. Open `quartus/gray_counter.qpf` and compile. Save actual synthesis/fitter reports and warnings; resource counts are not yet known.
3. The SDC describes intended 1 Hz clock timing. Confirm which timing analyzer supports this legacy device and whether it reads SDC. If the flow uses Classic Timing Analyzer, configure the real clock there. The QSF leaves timing setup pending rather than claiming the SDC is applied. Confirm constraints and results in the tool before claiming timing closure.
4. Follow the manual's Quartus Programmer procedure to generate an SVF file for the device.
5. Use the board's supported UrJTAG/FTDI driver setup. The manual uses `cable ft2232`, `detect`, `part 0`, then `svf <path-to-generated-file>`. Confirm detection before loading the file. Direct POF programming through Quartus is not assumed for this interface.
6. Record all 16 states and wraparound, using confirmed LED polarity to interpret lit/unlit outputs.

## Expected behavior, not measured results

At 1 Hz, a full 16-step cycle takes 16 seconds. The first states are 0000 -> 0001 -> 0011 -> 0010. The third transition changes q0 (LED1), not q1. See the main README for the full sequence.

## Startup

The RTL requests initial state 0000 and has no reset input. Check register power-up implementation in the target compiler/device documentation and fitted design; do not describe startup as inherently random or assume the initial block is necessarily simulation-only. All 16 known binary states belong to the same cycle, but this mathematical property does not replace checking physical startup behavior.
