# Design derivation

## State and storage

A 4-bit register has 16 possible states. This counter visits all of them in reflected Gray-code order. Four flip-flops store Q3 through Q0. Each samples its own S/R inputs on the same rising clock edge; the combinational logic uses the current state to determine those inputs.

The independent reference sequence is `gray(n) = n XOR (n >> 1)` for n=0..15. This formula is used for verification; the implementation is not a binary counter followed by a converter.

## SR excitation table

| Q | Next Q | S | R |
| --- | --- | --- | --- |
| 0 | 0 | 0 | X |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 1 |
| 1 | 1 | X | 0 |

X here is a minimization don't-care, not a value to drive into the physical circuit. For example, when Q=0 and the next Q=0, either hold (00) or reset (01) is acceptable.

The handwritten report's first row should have S0 R0 = 10 for 0000 -> 0001. This documentation corrects the transcription; the original PDF is unchanged.

## K-map workflow and direct equations

Make eight four-variable maps, one for each S/R input. Use Q3 Q2 on the rows and Q1 Q0 on the columns, both ordered 00, 01, 11, 10. Place the excitation values at every current state. Group ones with useful don't-cares in powers of two; wrapping across opposite edges is allowed. Every one must be covered and no zero may be included.

One compact set of direct equations is below. `!` means NOT, juxtaposition/`&` means AND, and `^` means XOR. E is the even parity of the upper three bits.

```text
E  = !(Q3 ^ Q2 ^ Q1)
S0 = E                       R0 = !E
S1 = !(Q3 ^ Q2) & Q0         R1 = (Q3 ^ Q2) & Q0
S2 = !Q3 & Q1 & !Q0          R2 = Q3 & Q1 & !Q0
S3 = Q2 & !Q1 & !Q0          R3 = !Q2 & !Q1 & !Q0
```

For SOP expansion, `!(A ^ B) = !A !B + A B`. E expands to `!Q3 !Q2 !Q1 + !Q3 Q2 Q1 + Q3 !Q2 Q1 + Q3 Q2 !Q1`. Minimizing SOP expressions is not proof of minimum CPLD resource use; that requires synthesis results for a target device.

## The report's parity/toggle implementation

The reconstructed RTL follows the screenshot, using parity over all four bits:

```text
p_even = !(Q3 ^ Q2 ^ Q1 ^ Q0)
f0 = p_even
f1 = !p_even & Q0
f2 = !p_even & !Q0 & Q1
f3 = !p_even & !Q0 & !Q1
Si = fi & !Qi
Ri = fi & Qi
```

When parity is even, only f0 is true. When parity is odd, Q0 and then Q1 select exactly one of f1, f2, f3. The cases are mutually exclusive and exhaustive. Thus exactly one bit toggles.

If fi=0, Si=Ri=0 and the bit holds. If fi=1, a zero is set and a one is reset. Si and Ri cannot both be one for known binary inputs.

The direct equations and toggle equations need not produce identical S/R signals: redundant set/reset operations can implement the same next state as holding. Their required equivalence is the resulting next state for every present state. The software checker compares both with the independent Gray sequence.

## Clock and startup

Nonblocking assignments make each register update from the old state. Combinational inputs then settle for the next edge. The original code initializes to 0000 and has no external reset. The default branch added to the SR case makes unknown simulation inputs explicit; all binary-input behavior follows the report.

The testbench clock period is 10 ns solely as a simulation stimulus. It is not a measured hardware frequency limit or a board timing constraint.
