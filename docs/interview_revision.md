# Focused interview revision

Goal: explain every line and design decision, and derive forgotten details. No finite question list guarantees an answer to every interview question.

## Six study sessions

1. Revisit Experiment 5: latches, edge-triggered registers, SR/JK/D/T behavior, and master-slave operation.
2. Revisit Experiment 6: synchronous versus ripple counters, mod-N counting, state tables, and D-input K-maps.
3. Rebuild the Gray sequence and SR excitation table. Derive S3/R3 and S2/R2 first, then S1/R1 and S0/R0.
4. Trace the reconstructed Verilog for 0000, 0001, 0011, 0100, and 1000. Explain every operator and signal.
5. Run the tests, read a waveform, and introduce a deliberate logic error to see the checker catch it.
6. Review the real board setup and give a two-minute explanation followed by the questions below.

## Core answers

**Why Gray code?** Adjacent values differ by one bit, unlike binary transitions such as 0111 -> 1000. It is useful where multi-bit transition ambiguity matters. It does not eliminate metastability or replace synchronization and timing constraints.

**Why four flip-flops?** Four state bits represent 16 distinct states; three bits represent only eight.

**What makes it synchronous?** Every state register uses the same clock edge. In a ripple counter, one stage's output clocks another stage.

**Latch versus flip-flop?** A latch is transparent during its active level; an edge-triggered flip-flop samples at an edge. A module named master-slave is not proof that two explicit latch stages were structurally instantiated.

**Characteristic versus excitation table?** A characteristic table gives next Q from current Q and inputs. An excitation table gives inputs that achieve a required Q-to-next-Q transition.

**What does an excitation don't-care mean?** More than one input choice achieves the required state transition. Choose a binary value during minimization; do not drive simulation X as a normal control value.

**Why is SR=11 forbidden here?** This model defines simultaneous set and reset as invalid and produces X in simulation. Different physical set/reset circuits have polarity-specific behavior; explain the active-high convention used here.

**How do you know only one bit changes?** Even parity selects f0. Odd parity selects exactly one of f1, f2, f3 according to Q0 and Q1. The selected bit toggles, and all others hold.

**Why S=f & !Q and R=f & Q?** They translate a toggle request into set for a zero and reset for a one; f=0 holds. They cannot assert both for binary Q.

**Why are K-map and parity SR inputs different?** Excitation don't-cares allow redundant set/reset instead of hold. Compare resulting next states, not literal control signals.

**Why <= in clocked logic?** Nonblocking assignments schedule updates after the old-state expressions are evaluated, modeling simultaneous register updates. Blocking assignments in dependent sequential processes can cause simulation races.

**What do wire, reg and assign mean?** A wire is a net driven by a continuous assignment or module output. A Verilog reg is a procedural variable; the word alone does not guarantee a physical register. `assign` continuously models combinational logic.

**Does initial guarantee board reset?** No general guarantee. It initializes simulation; hardware support depends on the target and tool. The reconstructed design has no reset input.

**Does X become a physical voltage?** No. It is a simulation value; synthesis may treat it as a don't-care. Prevent illegal inputs rather than relying on X as a hardware alarm.

**What does the testbench prove?** Under the modeled clock and initialization, the simulated RTL should match every expected transition, preserve one-bit changes, and use legal SR inputs. It does not establish board timing, correct physical pins, or operation at an arbitrary frequency.

**What are synthesis, fitting, and programming?** Synthesis maps RTL into logic/register structures; fitting places/routes them into the selected device; programming loads the generated device configuration using the supported interface.

**Setup and hold?** Data must be stable for specified intervals before and after the sampling edge. A synchronous path must allow clock-to-Q delay, combinational delay, setup time, and clock effects within the clock period; hold is a separate minimum-delay check.

**What limits maximum frequency?** Device timing and the longest constrained register-to-register path, including clock effects. A fast simulation clock is not proof of timing closure.

**Why not binary-to-Gray conversion?** It is a valid alternative. The assignment exercised direct state-machine design using SR excitation and K-maps. Compare resource/timing reports before claiming an implementation is better.

**What if power-up state is not zero?** Every binary 4-bit state belongs to this cycle, so a known binary state would enter the same sequence at another position. Unknown simulation values may propagate; that is not a reliable startup mechanism.

**What did you personally do?** Answer from your actual group contribution. Separate deriving equations, writing code, running tests, pin planning, and observing the board. Do not claim teammates' work as solely yours.

## Blank-page readiness check

- Write the complete cyclic sequence and explain the wraparound.
- Derive an SR input expression from its excitation column.
- Explain each line in both RTL modules without looking at notes.
- Predict three clock edges by hand, then compare with the waveform.
- Explain why sampling immediately at posedge can see old values in a testbench.
- Describe the actual board, pin map, clock, and LED order once recovered.
- State one limitation and one improvement: for example, device-dependent startup and an explicit reset extension.

If you forget an expression, derive it from the state table. If a measurement was never made, say so and explain how you would measure it.
