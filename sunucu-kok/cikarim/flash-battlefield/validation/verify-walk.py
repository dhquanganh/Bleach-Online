"""Verify observed native Flash playback, rather than a simulated renderer."""
from pathlib import Path
import re

trace = (Path(__file__).parent / 'void-walk-runtime.log').read_text(encoding='utf-8')
rows = [tuple(map(int, row)) for row in re.findall(
    r'walk frame=(\d+) tick=(\d+) x=(\d+) y=(\d+)', trace)]
assert len(rows) > 20, 'No sustained native walk trace'
assert len({row[0] for row in rows}) >= 8, 'Native walk frame is stuck'
assert all(b[1] >= a[1] for a, b in zip(rows, rows[1:])), 'Animation restarted across snapshots'
assert rows[-1][1] - rows[0][1] > 4000, 'Insufficient snapshot boundaries observed'
assert len({(row[2], row[3]) for row in rows}) > 20, 'Actor position is stationary'
assert 'RUNTIME ERROR' not in trace, 'Uncaught native Flash error'
print('PASS:', len(rows), 'native samples; frames', sorted({row[0] for row in rows}),
      '; continuous clock', rows[0][1], 'through', rows[-1][1])
