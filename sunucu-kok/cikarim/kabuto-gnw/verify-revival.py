"""Check compiled resurrection recovery and the isolated native lifecycle probe."""
from pathlib import Path
import json
import re

BASE=Path(__file__).resolve().parent
role=(BASE/'verify/scripts/Processors/Game/Battle/Character/TRole.as').read_text(encoding='utf-8')
start=role.index('public function ChangeHP(')
hp=role[start:role.index('protected function OnMouseMove(',start)]
assert hp.index('CurHealth -= param1;') < hp.index('RestoreKabutoAfterRevival();')
start=role.index('private function RestoreKabutoAfterRevival(')
restore=role[start:role.index('override public function UpdateActive()',start)]
death=role[role.index('private function PlayKabutoDeath('):role.index('override public function UpdateActive()',start)]
assert 'FKabutoFxCache.death' in death and 'alpha = 0' not in death
assert 'PlayKabutoDeath(Callback,Time);' in role
for token in ['FWaitDie = false','FWaitNextCommand = false','FHasFrozen = false',
              'FBitmap.visible = true','FBitmap.alpha = 1','FBitmap.bitmapData =',
              'FSkillId = 0','FSkilling = false','TYPE_ACTIVE_DIE','PlayFightIdle()']:
    assert token in restore, token
result=json.loads((BASE/'validation/revival-visual/result.json').read_text())
log=(BASE/'validation/revival-visual/runtime.log').read_text()
assert 'VFX_ASSET summon delay=0 mirror=false at=550,440' in log
assert 'VFX_ASSET summon delay=0 mirror=true at=700,440' in log
stage=(BASE/'verify/scripts/Processors/Game/Battle/TBattleStage.as').read_text(encoding='utf-8')
assert 'kabutoStatusVfx' in stage and 'kabutoStatusVfx' in role
assert result['completed'] and result['restores']==result['stableRestores']==result['cases']==12
assert result['assetPlays']==20 and result['atlasesLoaded']==6 and result['deathHolds']==12
assert result['remainingLayers']==0 and not result['errors']
result['clientVersion']=re.search("VERSION=b'([0-9]+)'",(BASE/'build-client.py').read_text())[1]
(BASE/'validation/revival-visual/verified.json').write_text(json.dumps(result,indent=2))
print('PASS compiled HP-before-restore order, sprite/idle recovery, cleared death locks; 12 immediate + delayed native recovery checks, both camps, 20 VFX plays, no errors.')
