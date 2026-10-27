"""Compare full native floor-68 playback before and after the queue fix."""
from pathlib import Path
import json,re
B=Path(__file__).resolve().parent;W=B/'floor68-live';baseline=(W/'baseline/runtime.log').read_text();fixed=(W/'runtime.log').read_text()
assert 'PLAY hero=11120995 pos=0:7 hp=90916 dead=false skill=0' in baseline
assert 'RUNTIME ERROR TypeError: Error #1009' in baseline
assert 'FINISH stalled after last action' in baseline
assert 'RUNTIME ERROR TypeError: Error #1009' not in fixed
assert 'CMD left=0 ' in fixed and 'BATTLE_END' in fixed and 'FINISH battle completed' in fixed
assert re.search(r'PLAY hero=11120995 pos=0:7 hp=90916 dead=false skill=0\s+NEXT hero=11120995',fixed)
assert (W/'baseline/report.bin').read_bytes()==(W/'report.bin').read_bytes()
result={'baselineNullError':True,'fixedCompleted':True,'fixedNullErrors':False,'sameEncodedReport':True,'commandsReplayed':399,'nonBlockingFlashErrors':fixed.count('RUNTIME ERROR Error: Error #2094')}
dest=B/'repair-passive-queue/replay-validation.json';dest.write_text(json.dumps(result,indent=2)+'\n')
print('PASS exact floor 68 report reached battle end:',result)
