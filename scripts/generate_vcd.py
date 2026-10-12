"""Generate a checked Python-model illustration, NOT an HDL simulation.
Run: python scripts/generate_vcd.py
Output: build/gray_counter_model.vcd (separate from the HDL testbench output).
"""
from pathlib import Path
from check_logic import next_state

OUTPUT_PATH = Path(__file__).resolve().parent.parent / 'build' / 'gray_counter_model.vcd'


def build_transitions():
    q = 0
    events = [(0, 0, 0, 0, 0, 0)]
    for cycle in range(1, 65):
        previous = q
        q = next_state(q)
        expected = (cycle % 16) ^ ((cycle % 16) >> 1)
        if q != expected:
            raise ValueError(f'Cycle {cycle}: expected {expected:04b}, got {q:04b}')
        if (q ^ previous).bit_count() != 1:
            raise ValueError(f'Cycle {cycle}: not a one-bit transition')
        bits = tuple((q >> i) & 1 for i in range(4))
        events.append(((2 * cycle - 1) * 5, 1, *bits))
        events.append((2 * cycle * 5, 0, *bits))
    return events


def write_vcd(path, events):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    identifiers = ('!', '"', '#', '$', '%')
    with path.open('w', encoding='ascii', newline='\n') as stream:
        stream.write('$comment Python software model only; not HDL simulation $end\n')
        stream.write('$timescale 1ns $end\n$scope module gray_counter_model $end\n')
        for identifier, name in zip(identifiers, ('clk', 'q0', 'q1', 'q2', 'q3')):
            stream.write(f'$var wire 1 {identifier} {name} $end\n')
        stream.write('$upscope $end\n$enddefinitions $end\n#0\n$dumpvars\n')
        previous = events[0][1:]
        for value, identifier in zip(previous, identifiers):
            stream.write(f'{value}{identifier}\n')
        stream.write('$end\n')  # Close initialization BEFORE later timestamps.
        for time_ns, *current in events[1:]:
            stream.write(f'#{time_ns}\n')
            for old, new, identifier in zip(previous, current, identifiers):
                if old != new:
                    stream.write(f'{new}{identifier}\n')
            previous = current


def main():
    events = build_transitions()  # Fail before writing if any check fails.
    write_vcd(OUTPUT_PATH, events)
    print('PASS: software model only; all 64 transitions checked, including four wraps.')
    print(f'Model illustration: {OUTPUT_PATH}')
    print('No Verilog was compiled or simulated.')


if __name__ == '__main__':
    main()
