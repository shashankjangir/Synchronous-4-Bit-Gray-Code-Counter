"""Exhaustive mathematical model check; does not execute or parse the RTL."""
def next_state(q):
    q0, q1, q2, q3 = [(q >> i) & 1 for i in range(4)]
    even = 1 ^ q0 ^ q1 ^ q2 ^ q3
    toggles = [even, (1 ^ even) & q0,
               (1 ^ even) & (1 ^ q0) & q1,
               (1 ^ even) & (1 ^ q0) & (1 ^ q1)]
    assert sum(toggles) == 1
    result = 0
    for i, toggle in enumerate(toggles):
        bit = (q >> i) & 1
        s, r = toggle & (1 ^ bit), toggle & bit
        assert not (s and r)
        result |= (s | (bit & (1 ^ r))) << i
    return result

def main():
    sequence = [n ^ (n >> 1) for n in range(16)]
    assert len(set(sequence)) == 16
    for n, q in enumerate(sequence):
        actual = next_state(q)
        expected = sequence[(n + 1) % 16]
        assert actual == expected, (q, actual, expected)
        assert (q ^ actual).bit_count() == 1
        q0, q1, q2, q3 = [(q >> i) & 1 for i in range(4)]
        upper_even = 1 ^ q3 ^ q2 ^ q1
        direct_s = [upper_even, (1 ^ q3 ^ q2) & q0,
                    (1 ^ q3) & q1 & (1 ^ q0), q2 & (1 ^ q1) & (1 ^ q0)]
        direct_r = [1 ^ upper_even, (q3 ^ q2) & q0,
                    q3 & q1 & (1 ^ q0), (1 ^ q2) & (1 ^ q1) & (1 ^ q0)]
        direct_next = 0
        for i, (s, r) in enumerate(zip(direct_s, direct_r)):
            assert not (s and r)
            direct_next |= (s | (((q >> i) & 1) & (1 ^ r))) << i
        assert direct_next == expected, ('Direct equations', q, direct_next, expected)
        print(f'{q:04b} -> {actual:04b}')
    print('PASS: both equation sets, all 16 states, wraparound, one-bit transitions and legal SR inputs (software model only)')

if __name__ == '__main__':
    main()
