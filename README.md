# Synchronous 4-Bit Gray Code Counter

A digital logic course project implementing a synchronous 4-bit Gray code counter with clocked SR flip-flop behavior in Verilog.

## Overview

The counter cycles through 16 states, changing exactly one output bit on each counting transition, including the transition back to the initial state. All four state registers share the same clock.

This project was completed as a group exercise in the ELL201 course lab. The original project report documents the state table, SR excitation rules, Karnaugh maps, Verilog implementation, and photographs of the CPLD board demonstration.

## Counting sequence

Outputs are written in the order Q3 Q2 Q1 Q0.

```text
0000 -> 0001 -> 0011 -> 0010
     -> 0110 -> 0111 -> 0101 -> 0100
     -> 1100 -> 1101 -> 1111 -> 1110
     -> 1010 -> 1011 -> 1001 -> 1000 -> 0000
```

## Design approach

1. Specify the present-state and next-state table.
2. Determine the set and reset inputs required for each state bit.
3. Minimize the input expressions using Karnaugh maps.
4. Implement the counter in Verilog using four clocked SR modules.
5. Verify the sequence in simulation and compare it with board outputs.

The code shown in the original report uses state parity to generate per-bit toggle conditions, then converts those conditions into SR inputs. The relationship between that implementation and the direct K-map expressions will be documented when the source is added.

## Repository status

This repository has been initialized with documentation and ignore rules. Runnable Verilog, the testbench, and Quartus project files have not been added yet.

The local lab materials include:
- A 16-state Gray-code table and SR excitation table.
- Eight K-maps for the set and reset inputs.
- A screenshot of the Verilog implementation.
- Photographs of the board outputs.

A Gray-counter-specific testbench and waveform still need to be recovered or recreated for this repository. No automated test results are claimed at this stage.

## Planned layout

| Directory | Contents to add |
| --- | --- |
| `rtl/` | SR flip-flop and Gray counter Verilog modules |
| `tb/` | Self-checking simulation testbench |
| `docs/` | Design derivation, verification notes, and hardware setup |
| `images/` | Annotated waveform and selected board photographs |
| `quartus/` | Verified project settings, pin assignments, and timing constraints |

## Verification goals

- Check the exact 16-state sequence over multiple cycles.
- Check wraparound from `1000` to `0000`.
- Check that exactly one bit changes per counting transition.
- Check for unknown outputs after initialization.
- Check that no SR module receives simultaneous set and reset.
- Test reset and enable behavior if those interfaces are added.

## Implementation notes

- The report's first state-table row contains a transcription error: for `0000 -> 0001`, the correct `S0 R0` values are `10`.
- The original Verilog screenshot initializes each register with an `initial` block and has no explicit reset port. Device-specific power-up behavior must be checked before reproducing the hardware setup.
- Clocked SR behavior in RTL does not imply that the CPLD contains native SR flip-flops; synthesis maps the behavior onto the device's available resources.
- The exact board device, pin mapping, and clock source must be documented from the original setup.
- Later improvements will be identified separately from the original lab implementation.
