"""Verify the installed resurrection fix and Flash lifecycle regression evidence."""
from pathlib import Path
import json,re
BASE=Path(__file__).resolve().parent

def method(source,name):
    start=source.index('function '+name+'(');body=source.index('{',start);end=body+1;depth=1
    while depth:
        depth+=(source[end]=='{')-(source[end]=='}');end+=1
    return re.sub(r'\s+','',source[body:end])

role=(BASE/'verify/scripts/Processors/Game/Battle/Character/TRole.as').read_text(encoding='utf-8')
hp=method(role,'ChangeHP')
assert 'FId==11120930&&(CurHealth<=0||FIsDie||FWaitDie)' in hp
assert hp.index('CurHealth-=param1;')<hp.index('RestorePainAfterRevival();')
restore=method(role,'RestorePainAfterRevival')
for token in ['TweenUtil.removeTween(this,false)','TweenUtil.removeTween(FBitmap,false)',
              'FIsDie=false','FWaitDie=false','FWaitNextCommand=false','FHasFrozen=false',
              'FHasGiddy=false','FHideFrame=-1','FCallBackDict[TYPE_ACTIVE_DIE]=null',
              'FTimeDict[TYPE_ACTIVE_DIE]=0','alpha=1','visible=true','FBitmap.alpha=1',
              'FBitmap.visible=true','FHpBar.visible=true','FBuffSprite.visible=true',
              'FPainFinal=true','PlayFightIdle()','FBitmap.bitmapData=idle.Surface']:
    assert token in restore,token
result=json.loads((BASE/'validation/revival-final/result.json').read_text())
assert result['completed'] and result['cases']==result['restores']==result['stableRestores']==12
assert result['assetPlays']==20 and result['atlasesLoaded']==11
assert result['remainingLayers']==0 and not result['errors']
animation=json.loads((BASE/'animation.json').read_text())
assert animation['clips']['super']['visibleHoldFrames']>100
active=(BASE/'verify/scripts/Processors/Game/Battle/Character/TActive.as').read_text(encoding='utf-8')
idle=method(active,'PlayFightIdle')
assert 'FPainFinal&&this.FTextureFightIdle.Count>1?1:0' in idle
assert 'this.FPainFinal=false' in method(active,'ResetActive')
assert animation['models']['11120930']['0a']==['idle','final-idle']
assert animation['clips']['final-idle']['loop'] and animation['clips']['final-idle']['sourceStartFrame']==23
assert f'FSkillId==13120973&&FFrameIndex=={animation["clips"]["extreme"]["returnFrame"]}' in re.sub(r'\s+','',role)
assert len(list((BASE/'validation/revival-final').glob('FINAL-IDLE-camp-*-slot-*.jpg')))==12
result.update(clientVersion='2026101952',compiledRecoveryVerified=True,finalIdleVerified=True,heldCinematicFrames=animation['clips']['super']['visibleHoldFrames'])
(BASE/'validation/revival-final/verified.json').write_text(json.dumps(result,indent=2))
print('PASS compiled Pain HP-before-restore, both revive forms, queued death, cancelled fade tweens, 12 immediate/delayed Flash checks and continuous Super Push actor')
