"""Verify installed speed controls, battle lifecycle wiring and retained animation fixes."""
from pathlib import Path
import importlib.util,json,re,struct,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('b',BASE/'build.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
result=json.loads((BASE/'validation/result.json').read_text())
assert result['completed'] and result['checks']>=19 and not result['errors'],result
log=(BASE/'validation/runtime.log').read_text()
assert 'pending timer follows both toggles' in log and 'ERROR' not in log
verified=BASE/'verify/scripts';original=BASE/'original/scripts'
handle=(BASE/'style-verify/scripts'/b.HANDLE).read_text()
def body(source,name):
    match=re.search(r'      (?:(?:override|public|private|protected|static) )+function '+name+r'\(',source)
    assert match,name
    return source[match.start():b.h.method_end(source,match.start())]
assert 'CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_BTN_Skip)' in body(handle,'CreatePlaybackButton')
assert 'FPlaybackNativeControl.OnClick = PlaybackNativeClick' in body(handle,'CreatePlaybackButton')
assert 'drawRoundRect' not in body(handle,'UpdatePlaybackButton')
assert 'FindPlaybackCaption' in body(handle,'UpdatePlaybackButton')
assert 'StartPlaybackSpeed();' in body(handle,'ProcessorOnCloseLoad')
assert 'PulsePlaybackTimers();' in body(handle,'LogicsPerform')
for name in ['Reset','ButtonSkipOnClick','ProcessorOnBattleEnd','PlaybackRemoved']:
    assert 'StopPlaybackSpeed();' in body(handle,name),name
assert 'if(!param1)' in handle and 'StopPlaybackSpeed();' in handle[handle.index('override public function set Visible('):]
assert 'FPlaybackBaseFps * FPlaybackRate' in body(handle,'SetPlaybackRate')
assert 'FPlaybackClock = PlaybackTime;' in body(handle,'SetPlaybackRate')
assert 'task.callback.apply(null,task.args)' in body(handle,'PulsePlaybackTimers')
assert 'delete FPlaybackTasks[key]' in body(handle,'PulsePlaybackTimers')
assert 'FIsCanSkip' not in body(handle,'TogglePlaybackSpeed'),'Speed must not depend on VIP Skip access'
assert 'FPlaybackTasks = {}' in body(handle,'StopPlaybackSpeed')
role=Path('Processors/Game/Battle/Character/TRole.as')
before=(original/role).read_text();after=(verified/role).read_text()
for name in ['ShowHashiramaVfx','HashiramaStrikePose','PainStrikePose','RestorePainAfterRevival','PainFlightPose',
             'ShowObitoStatusText','ShowPainStatusText','ShowHashiramaStatusText']:
    assert body(before,name)==body(after,name),('Prior animation/status behavior changed',name)
assert 'TBattleHandle.PlaybackTime' in after and 'castSerial' in after and 'rodSerial' in after
for path in ['TBattleStage.as','Components/TBigSkill.as','Effect/TEffectControl.as','Character/TRole.as']:
    source=(verified/'Processors/Game/Battle'/path).read_text()
    assert 'TBattleHandle.PlaybackTimeout' in source,path
    assert not re.search(r'(?<![.\w])setTimeout\(',source),path
assert 'FTickReference += SIZE_FrameRatePerSecond;' in after,'Every native damage marker must still be visited'
canonical=b.h.h.PUBLIC/'2026090619/TApplication.swf'
assert canonical.read_bytes()==(b.h.h.PUBLIC/'2026101963/TApplication.swf').read_bytes()
assert b.h.h.swap(canonical.read_bytes())==(BASE/'style-compiled.swf').read_bytes()
raw=zlib.decompress((canonical.parent/'version.swf').read_bytes());pos=2;entries={}
for _ in range(struct.unpack_from('<H',raw)[0]):
    n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n
    n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n;entries[k]=v
assert entries[b'TApplication.swf']==b'2026101963'
result.update(client='2026101963',retainedAnimationFixes=True,preservesDamageMarkers=True)
(BASE/'validation/verified.json').write_text(json.dumps(result,indent=2))
print('PASS client 2026101963: 19 native Flash checks including native Skip skin/hover/caption, real FPS/timers/toggles/cleanup, all exit hooks, unrestricted speed control, retained Pain/Obito/Hashirama fixes and native damage markers')
