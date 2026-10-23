"""Retarget remaining build/test references to shared engine helpers."""
from pathlib import Path
BASE=Path(__file__).resolve().parent;C=BASE.parent
s=(C/'kabuto-gnw-new/build-fragment.py').read_text();start=s.index('def records(');end=s.index('\ndef main():',start)
(C/'shared-animation/inventory-tables.py').write_text('"""Native inventory, upgrade and market record boundaries."""\nimport struct\n'+s[start:end],encoding='utf-8')
f=BASE/'clean-data.py';s=f.read_text().replace("BASE.parent/'kabuto-gnw-new/build-fragment.py'","BASE.parent/'shared-animation/inventory-tables.py'");f.write_text(s,encoding='utf-8')
for f in C.rglob('*.py'):
 if any(x in f.parts for x in ['kabuto-gnw','kabuto-gnw-new','character-removal','backups','original','verify','patched']):continue
 s=f.read_text(encoding='utf-8');old=s
 s=s.replace('"kabutoSkillVfx",','').replace("'UpdateKabutoVfx',",'').replace(" and 'UpdateKabutoVfx' in checked",'')
 s=s.replace('"kabutoStatusVfx"','"hashiramaSkillVfx"').replace('"kabutoSkillVfx"','"mechaSkillVfx"')
 s=s.replace('      public function RestoreKabutoAfterRevival():void {report("ERROR wrong hero recovery");}\n','')
 if f==C/'pain-tendo/build-client.py':
  a=s.index(" role=rep(role,'            var restoreKabuto:Boolean ='");b=s.index(" start=role.index('      public function PrepareBattleRole()')",a)
  s=s[:a]+''' start=role.index('      public function ChangeHP(');body=role.index('{',start)+1
 role=role[:body]+\'\'\'
         if(param1 < 0 && FId == 11120930 && (CurHealth <= 0 || FIsDie || FWaitDie)) {
            CurHealth -= param1;
            if(CurHealth > 0) RestorePainAfterRevival();
            return;
         }
\'\'\'+role[body:]
'''+s[b:]
 if s!=old:f.write_text(s,encoding='utf-8')
f=C.parent/'sunucu/tests/physical-scaling.test.js';s=f.read_text().replace('Hashirama and Kabuto','Hashirama');f.write_text(s,encoding='utf-8')
print('PASS shared inventory codec, remaining renderer anchors and regression imports updated')
