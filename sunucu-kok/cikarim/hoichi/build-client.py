from pathlib import Path
import importlib.util,json,re,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
TAGS=Path('Processors/Game/Lobby/HerosNew/TWindowAttribute.as');PROFILE=Path('Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as')
def main():
 source=c.h.swap((c.h.PUBLIC/'2026090619/TApplication.swf').read_bytes());(B/'source.swf').write_bytes(source)
 rels=[c.b.ROLE,c.b.ACTIVE,c.b.STAGE,c.b.FORMATION,TAGS,PROFILE];classes=','.join(str(p.with_suffix('')).replace('\\','.').replace('/','.') for p in rels)
 c.ff('-selectclass',classes,'-export','script',B/'original',B/'source.swf')
 before=(B/'original/scripts'/c.b.ROLE).read_text(encoding='utf-8');assert 'UpdateHoichiVfx' not in before
 animation=json.loads((B/'animation.json').read_text());ends={str(i):animation['clips'][name]['returnFrame'] for i,name in animation['moves'].items()}
 helper=(B/'native.as.txt').read_text().replace('__ENDS__',json.dumps(ends,separators=(',',':')))
 # FFDec's decompiled nested for-each/break loop is not round-trip safe.
 # Reuse the exact checked-in source that produced the current Naruto method.
 composite=(B.parent/'naruto-mid-autumn/composite.as.txt').read_text().replace('__COMPOSITE__',json.dumps((B.parent/'naruto-mid-autumn/composite.json').read_text()))
 role=before.replace(c.m.extract(before,'PlayMidAutumnComposite'),c.m.extract(composite,'PlayMidAutumnComposite'),1)
 role=role.replace('      override public function UpdateActive()',helper+'\n      override public function UpdateActive()',1)
 role=c.inject(role,'PrepareBattleRole','         if(FId==11121012)PreloadHoichiNative();')
 for name in ['ActivePlay','Reset']:role=c.inject(role,name,'         if(FId==11121012)ClearHoichiVfx();')
 role=role.replace('         this.UpdateMidAutumnVfx();','         this.UpdateMidAutumnVfx();\n         this.UpdateHoichiVfx();',1)
 role=role.replace('               this.MidAutumnStrikePose(_loc4_);','               this.MidAutumnStrikePose(_loc4_);\n               this.HoichiStrikePose(_loc4_);',1)
 assert role!=before
 active=(B/'original/scripts'/c.b.ACTIVE).read_text(encoding='utf-8');active=c.inject(active,'IsSkill','         if(FId==11121012)return param1>=13122901 && param1<=13122905 && param1!=13122902;')
 token='         this.FCurSequence = this.FTextureAttack.GetAnimationSequenceByIndex(_loc1_);';assert token in active;active=active.replace(token,'         if(FId==11121012)_loc1_=0;\n'+token,1)
 token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);';assert token in active;active=active.replace(token,'         if(FId==11121012)_loc1_=FSkillId==13122903?1:FSkillId==13122904?2:0;\n'+token,1)
 stage=(B/'original/scripts'/c.b.STAGE).read_text(encoding='utf-8');token='battleRasterHost.getChildAt(battleRasterIndex).name == "midAutumnSkillVfx"';assert token in stage;stage=stage.replace(token,'('+token+' || battleRasterHost.getChildAt(battleRasterIndex).name == "hoichiSkillVfx")')
 formation=(B/'original/scripts'/c.b.FORMATION).read_text(encoding='utf-8').replace('this.FSelectHero.Identifier == 11121011','(this.FSelectHero.Identifier == 11121011 || this.FSelectHero.Identifier == 11121012)').replace('this.FSelectHero.Identifier != 11121011','(this.FSelectHero.Identifier != 11121011 && this.FSelectHero.Identifier != 11121012)')
 assert formation!=(B/'original/scripts'/c.b.FORMATION).read_text(encoding='utf-8')
 # Reuse the existing wall-clock notice renderer for Hoichi's status names.
 method=c.m.extract(role,'ShowBuffNoticeText');match=re.search(r'JSON.parse\(("(?:\\.|[^"\\])*")\)',method);assert match
 messages=json.loads(json.loads(match[1]));messages.update({str(19002500+i):v for i,v in enumerate(['Level 2 - Acupuncture','Dharma Seal','Endurance','Perseverance','Suppress Immunity'],1)})
 role=role.replace(method,method[:match.start(1)]+json.dumps(json.dumps(messages,separators=(',',':')))+method[match.end(1):],1)
 role=c.inject(role,'AddTextEffectByCMD','         if(param1.CMD==TTargetInfo.CMD_FLOAT && param1.ResultInfo.BuffId>=19002501 && param1.ResultInfo.BuffId<=19002505){ShowBuffNoticeText(param1.ResultInfo.BuffId);return;}')
 outputs={c.b.ROLE:role,c.b.ACTIVE:active,c.b.STAGE:stage,c.b.FORMATION:formation}
 for rel in [TAGS,PROFILE]:
  text=(B/'original/scripts'/rel).read_text(encoding='utf-8');method=c.m.extract(text,'InitCharacterTags');match=re.search(r'JSON.parse\(("(?:\\.|[^"\\])*")\)',method);assert match
  data=json.loads(json.loads(match[1]));data['heroes']['11121012']=[27,52,2,15,48];outputs[rel]=text.replace(method,method[:match.start(1)]+json.dumps(json.dumps(data,separators=(',',':')))+method[match.end(1):],1);(B/'tags.json').write_text(json.dumps(data,indent=2)+'\n')
 for rel,text in outputs.items():
  dest=B/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(text,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 raw=(B/'compiled.swf').read_bytes();assert [t for t in c.h.tags(source) if t[0]!=82]==[t for t in c.h.tags(raw) if t[0]!=82]
 c.ff('-selectclass',classes,'-export','script',B/'verify',B/'compiled.swf')
 allowed={c.b.ROLE:{'PrepareBattleRole','ActivePlay','Reset','UpdateActive','ShowBuffNoticeText','AddTextEffectByCMD'},c.b.ACTIVE:{'IsSkill','PlayAttack','PlaySkill'},c.b.STAGE:{'Reset'},TAGS:{'InitCharacterTags'},PROFILE:{'InitCharacterTags'}};counts={}
 for rel in outputs:
  if rel==c.b.FORMATION:continue
  old=(B/'original/scripts'/rel).read_text(encoding='utf-8');new=(B/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
  for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',old):
   if name not in allowed[rel]:assert c.m.extract(old,name)==c.m.extract(new,name),str(rel)+':'+name;count+=1
  counts[rel.stem]=count
 (B/'client-validation.json').write_text(json.dumps({'unchangedMethods':counts,'sha256':hashlib.sha256(raw).hexdigest()},indent=2)+'\n');print('PASS isolated Hoichi native client',counts)
if __name__=='__main__':main()
