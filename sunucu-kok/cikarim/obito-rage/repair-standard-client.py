"""Repair Obito standard playback on the current client without rebuilding other patches."""
from pathlib import Path
import argparse
import hashlib
import shutil
import subprocess
import sys
from datetime import datetime

BASE = Path(__file__).resolve().parent
sys.path.insert(0, str(BASE.parent / 'flash-hero-stars'))
from build import swap, tags, CLIENT
from loader import publish_client


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--ffdec', required=True)
    parser.add_argument('--install', action='store_true')
    args = parser.parse_args()
    original = CLIENT.read_bytes()
    decoded = swap(original)
    work = BASE / 'standard-repair'
    work.mkdir(exist_ok=True)
    source = work / 'source.swf'
    source.write_bytes(decoded)
    classes = 'Processors.Game.Battle.Character.TActive,Processors.Game.Battle.Character.TRole'

    def ffdec(*params):
        subprocess.run(['java', '-Xmx2g', '-jar', args.ffdec, *map(str, params)], check=True)

    ffdec('-selectclass', classes, '-export', 'script', work / 'original', source)
    relative = Path('Processors/Game/Battle/Character')
    active = (work / 'original/scripts' / relative / 'TActive.as').read_text(encoding='utf-8')
    role = (work / 'original/scripts' / relative / 'TRole.as').read_text(encoding='utf-8')
    assert 'ObitoStandardPose' not in role, 'Repair is already installed'
    old = 'if(this.FId == 11120920 && param1 == 13120954)'
    assert active.count(old) == 1
    active = active.replace(old, 'if(this.FId == 11120920 && (param1 == 13120953 || param1 == 13120954))')
    start = active.index('      protected function PlaySkill() : void')
    position = active.index('         this.FTickReference = 0;', start)
    active = active[:position] + '''         // Standards must never fall through to skill sequence zero (Kamui).
         if(this.FId == 11120920 && (this.FSkillId == 13120953 || this.FSkillId == 13120954))
         {
            this.FCallBackDict[TYPE_ACTIVE_ATTACK] = this.FCallBackDict[TYPE_ACTIVE_SKILL];
            this.FTimeDict[TYPE_ACTIVE_ATTACK] = this.FTimeDict[TYPE_ACTIVE_SKILL];
            this.PlayAttack();
            return;
         }
''' + active[position:]
    marker = '               FBitmap.y = -_loc4_.Pivot.Y;'
    assert role.count(marker) == 1
    role = role.replace(marker, marker + '''
               this.ObitoStandardPose(_loc4_);
''')
    marker = '      private function UpdateObitoVfx() : void'
    assert role.count(marker) == 1
    role = role.replace(marker, '''      private function ObitoStandardPose(frame:TAnimationFrame) : void
      {
         if(FId != 11120920 || (FSkillId != 13120953 && FSkillId != 13120954) || FIndex != TYPE_ACTIVE_ATTACK) return;
         // Source A_1hit/A_2hit disappear, then reappear at a source-specific X.
         // Resolve the real report target instead of retaining that source travel.
         if(FFrameIndex < 14 || FFrameIndex >= 50 || frame.Surface.width <= 1 || FTargets == null || FResults == null) return;
         for(var i:int=0;i<FTargets.length && i<FResults.length;i++)
         {
            var enemy:TRole=FTargets[i];
            if(enemy == null || enemy == this || enemy.Camp == Camp || FResults[i].CMD != TTargetInfo.CMD_ATTACK) continue;
            var point:Point=globalToLocal(enemy.localToGlobal(new Point()));
            FBitmap.x=point.x-70-frame.Surface.width/2;
            FBitmap.y=point.y-frame.Pivot.Y;
            return;
         }
      }

''' + marker)
    phase = work / 'patched' / relative
    phase.mkdir(parents=True, exist_ok=True)
    (phase / 'TActive.as').write_text(active, encoding='utf-8')
    (phase / 'TRole.as').write_text(role, encoding='utf-8')
    output = work / 'compiled.swf'
    ffdec('-onerror', 'abort', '-importScript', source, output, work / 'patched')
    rebuilt = output.read_bytes()
    assert [t for t in tags(decoded) if t[0] != 82] == [t for t in tags(rebuilt) if t[0] != 82]
    ffdec('-selectclass', classes, '-export', 'script', work / 'verify', output)
    checked = (work / 'verify/scripts' / relative / 'TActive.as').read_text(encoding='utf-8')
    assert 'param1 == 13120953 || param1 == 13120954' in checked
    assert 'this.FCallBackDict[TYPE_ACTIVE_ATTACK] = this.FCallBackDict[TYPE_ACTIVE_SKILL]' in checked
    checked = (work / 'verify/scripts' / relative / 'TRole.as').read_text(encoding='utf-8')
    assert 'this.ObitoStandardPose(_loc4_)' in checked and 'UpdateJiraiyaVfx' in checked
    protected = swap(rebuilt)
    print('Verified Obito standard repair:', hashlib.sha256(protected).hexdigest())
    if args.install:
        assert CLIENT.read_bytes() == original, 'Client changed during compilation'
        backup = BASE / 'backups' / (datetime.now().strftime('%Y%m%d-%H%M%S-%f') + '-before-standard-repair.swf.bak')
        backup.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(CLIENT, backup)
        CLIENT.write_bytes(protected)
        publish_client(protected)
        print('Installed Obito standard repair. Backup:', backup)


if __name__ == '__main__':
    main()
