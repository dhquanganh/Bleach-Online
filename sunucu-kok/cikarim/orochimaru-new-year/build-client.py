"""Add isolated Orochimaru Tsukuyomi dispatch to the currently published client."""
from pathlib import Path
import importlib.util,json,re,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c)
c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
TAGS=Path('Processors/Game/Lobby/HerosNew/TWindowAttribute.as');PROFILE=Path('Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as')
def capture():
 raw=c.h.swap((c.h.PUBLIC/'2026090619/TApplication.swf').read_bytes());(B/'source.swf').write_bytes(raw)
 classes=','.join(str(p.with_suffix('')).replace('\\','.').replace('/','.') for p in [c.b.ROLE,c.b.ACTIVE,c.b.STAGE,c.b.FORMATION,TAGS,PROFILE])
 c.ff('-selectclass',classes,'-export','script',B/'original',B/'source.swf')
def main():
 if not (B/'source.swf').exists():capture()
 original=B/'original/scripts';before=(original/c.b.ROLE).read_text(encoding='utf-8');assert 'UpdateOrochimaruVfx' not in before
 a=json.loads((B/'animation.json').read_text());helper=(B/'native.as.txt').read_text()
 role=before.replace('      override public function UpdateActive()',helper+'\n      override public function UpdateActive()',1)
 role=c.inject(role,'PrepareBattleRole','         if(FId==11121009)PreloadOrochimaruNative();')
 for name in ['ActivePlay','Reset']:role=c.inject(role,name,'         if(FId==11121009)ClearOrochimaruVfx();')
 role=role.replace('         this.UpdateAsuraVfx();','         this.UpdateAsuraVfx();\n         this.UpdateOrochimaruVfx();',1)
 role=role.replace('               this.AsuraStrikePose(_loc4_);','               this.AsuraStrikePose(_loc4_);\n               this.OrochimaruStrikePose(_loc4_);',1)
 active=(original/c.b.ACTIVE).read_text(encoding='utf-8')
 active=c.inject(active,'IsSkill','         if(FId==11121009)return param1>=13122601 && param1<=13122611 && !(param1>=13122602 && param1<=13122604);')
 token='         this.FCurSequence = this.FTextureAttack.GetAnimationSequenceByIndex(_loc1_);';assert token in active
 active=active.replace(token,'         if(FId==11121009)_loc1_=FSkillId>=13122602&&FSkillId<=13122604?FSkillId-13122602:0;\n'+token,1)
 token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);';assert token in active
 dispatch={str(i):a['models']['11121009']['0c'].index(name) for i,name in a['moves'].items() if name not in ['standard','standard2','standard3']}
 active=active.replace(token,'         if(FId==11121009)_loc1_=int(JSON.parse('+json.dumps(json.dumps(dispatch,separators=(',',':')))+')[String(FSkillId)]);\n'+token,1)
 stage=(original/c.b.STAGE).read_text(encoding='utf-8');token='battleRasterHost.getChildAt(battleRasterIndex).name == "minatoNewYearSkillVfx"';assert token in stage
 stage=stage.replace(token,'('+token+' || battleRasterHost.getChildAt(battleRasterIndex).name == "orochimaruSkillVfx")')
 formation=(original/c.b.FORMATION).read_text(encoding='utf-8').replace('this.FSelectHero.Identifier == 11121003','(this.FSelectHero.Identifier == 11121003 || this.FSelectHero.Identifier == 11121009)').replace('this.FSelectHero.Identifier != 11121003','(this.FSelectHero.Identifier != 11121003 && this.FSelectHero.Identifier != 11121009)')
 outputs={c.b.ROLE:role,c.b.ACTIVE:active,c.b.STAGE:stage,c.b.FORMATION:formation}
 for rel in [TAGS,PROFILE]:
  text=(original/rel).read_text(encoding='utf-8');method=c.m.extract(text,'InitCharacterTags');match=re.search(r'JSON.parse\(("(?:\\.|[^"\\])*")\)',method);assert match
  data=json.loads(json.loads(match[1]));data['heroes']['11121009']=[27,62,52,1,3,11,14,15,49];data['tags']['15']={'name':'Curse Mark','icon':'/public/character-tags/15.png'}
  outputs[rel]=text.replace(method,method[:match.start(1)]+json.dumps(json.dumps(data,separators=(',',':')))+method[match.end(1):],1)
  (B/'tags.json').write_text(json.dumps(data,indent=2)+'\n')
 for rel,text in outputs.items():
  dest=B/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(text,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 raw=(B/'compiled.swf').read_bytes();assert [t for t in c.h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags(raw) if t[0]!=82]
 classes=','.join(str(rel.with_suffix('')).replace('\\','.').replace('/','.') for rel in outputs)
 c.ff('-selectclass',classes,'-export','script',B/'verify',B/'compiled.swf')
 allowed={c.b.ROLE:{'PrepareBattleRole','ActivePlay','Reset','UpdateActive'},c.b.ACTIVE:{'IsSkill','PlayAttack','PlaySkill'},c.b.STAGE:{'Reset'},TAGS:{'InitCharacterTags'},PROFILE:{'InitCharacterTags'}};counts={}
 for rel in outputs:
  if rel==c.b.FORMATION:continue
  old=(original/rel).read_text(encoding='utf-8');new=(B/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
  for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',old):
   if name not in allowed[rel]:assert c.m.extract(old,name)==c.m.extract(new,name),str(rel)+':'+name;count+=1
  counts[rel.stem]=count
 (B/'client-validation.json').write_text(json.dumps({'unchangedMethods':counts,'sha256':hashlib.sha256(raw).hexdigest()},indent=2)+'\n')
 print('PASS isolated Orochimaru client',counts)
if __name__=='__main__':main()
