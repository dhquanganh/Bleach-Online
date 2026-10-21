"""Correct live Sage standard/skill dispatch for both hero and clone."""
from pathlib import Path
import importlib.util,re
BASE=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('helper',BASE/'build-client.py');h=importlib.util.module_from_spec(s);s.loader.exec_module(h)
REL=Path('Processors/Game/Battle/Character/TActive.as')
def main():
 canonical=h.h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.h.swap(old)
 source=BASE/'dispatch-source.swf';source.write_bytes(decoded)
 h.ff('-selectclass','Processors.Game.Battle.Character.TActive','-export','script',BASE/'dispatch-original',source)
 before=(BASE/'dispatch-original/scripts'/REL).read_text(encoding='utf8');code=before
 anchor='      public function IsSkill(param1:int) : Boolean\n      {'
 assert anchor in code
 code=code.replace(anchor,anchor+'''
         if((this.FId == 11120901 || this.FId == 11120902) && param1 >= 13120901 && param1 <= 13120904)
         {
            return param1 != 13120903;
         }
''',1)
 anchor='      protected function PlaySkill() : void\n      {'
 assert anchor in code
 code=code.replace(anchor,anchor+'''
         if((this.FId == 11120901 || this.FId == 11120902) && this.FSkillId == 13120903)
         {
            this.FCallBackDict[TYPE_ACTIVE_ATTACK] = this.FCallBackDict[TYPE_ACTIVE_SKILL];
            this.FTimeDict[TYPE_ACTIVE_ATTACK] = this.FTimeDict[TYPE_ACTIVE_SKILL];
            this.PlayAttack();
            return;
         }
''',1)
 dest=BASE/'dispatch-patched'/REL;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(code,encoding='utf8')
 output=BASE/'dispatch-fixed.swf';h.ff('-onerror','abort','-importScript',source,output,BASE/'dispatch-patched')
 rebuilt=output.read_bytes();assert [t for t in h.h.tags(decoded) if t[0]!=82]==[t for t in h.h.tags(rebuilt) if t[0]!=82]
 h.ff('-selectclass','Processors.Game.Battle.Character.TActive','-export','script',BASE/'dispatch-verify',output)
 after=(BASE/'dispatch-verify/scripts'/REL).read_text(encoding='utf8')
 assert 'return param1 != 13120903;' in after
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name not in ('PlaySkill','IsSkill'):assert h.m.extract(before,name)==h.m.extract(after,name),name
 backup=BASE/'backups/TApplication-before-sage-dispatch.swf'
 if not backup.exists():backup.write_bytes(old)
 canonical.write_bytes(h.h.swap(rebuilt))
 print('PASS live TActive dispatch: Sage hero and clone Barrage use attack atlas; Mystery/summon/chase use their own skill sequences')
if __name__=='__main__':main()
