"""Incremental Minato dispatch. Keep every unrelated method bytecode intact."""
from pathlib import Path
import importlib.util,json,re,hashlib
B=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(spec);spec.loader.exec_module(c)
c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
TAGS=Path('Processors/Game/Lobby/HerosNew/TWindowAttribute.as');PROFILE=Path('Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as')

def main():
 original=B/'original/scripts';before=(original/c.b.ROLE).read_text(encoding='utf-8');assert 'UpdateMinatoVfx' not in before
 a=json.loads((B/'animation.json').read_text());helper=(B/'native.as.txt').read_text()
 clone=(B.parent/'tsunade-asian/katsuyu.as.txt').read_text().replace('SmallKatsuyu','MinatoClone').replace('11120993','11121004').replace('__DEAD_FRAMES__',str(len(a['clips']['dead']['assets']))).replace('__ENTRY_FRAMES__',str(len(a['clips']['entry']['assets']))).replace('dying ? 1 : 0','dying ? 7 : 6').replace('dying?1:0','dying?7:6').replace('FMinatoCloneDying ? 1 : 0','FMinatoCloneDying ? 7 : 6').replace('FMinatoCloneDying?1:0','FMinatoCloneDying?7:6').replace('FTextureSkill.Count>=2','FTextureSkill.Count>=8')
 role=before.replace('      override public function UpdateActive()',helper+'\n'+clone+'\n      override public function UpdateActive()',1)
 role=c.inject(role,'PrepareBattleRole','         if(FId==11121003 || FId==11121004)PreloadMinatoNative();\n         if(FId==11121004){ClearMinatoClonePose();FMinatoCloneSpawned=false;if(CurHealth<=0){FIsDie=true;visible=false;FHpBar.visible=false;FShaderBmp.visible=false;FBuffSprite.visible=false;}}')
 role=c.inject(role,'ActivePlay','         if(FId==11121003 || FId==11121004)ClearMinatoVfx();\n         if(FId==11121004){if(param1==TYPE_ACTIVE_DIE){PlayMinatoClonePose(true,param5,param6);return;}if(param1==TYPE_ACTIVE_ATTACK || param1==TYPE_ACTIVE_SKILL)ClearMinatoClonePose();}')
 role=c.inject(role,'Reset','         if(FId==11121003 || FId==11121004)ClearMinatoVfx();\n         if(FId==11121004){ClearMinatoClonePose();FMinatoCloneSpawned=false;}')
 role=c.inject(role,'UpdateActive','         if(FId==11121004 && FMinatoCloneStarted>=0){UpdateMinatoClonePose();return;}')
 role=role.replace('            PlayWaterClonePose(false);','            PlayWaterClonePose(false);',1)
 token='         if(FId == 11120998)\n         {\n            PlayWaterClonePose(false);\n         }';assert token in role
 role=role.replace(token,token+'\n         if(FId==11121004){FBitmap.transform.colorTransform=new ColorTransform(0.85,0.95,0.65,0.9,12,8,0);PlayMinatoClonePose(false);}',1)
 role=role.replace('         this.UpdateKakuzuVfx();','         this.UpdateKakuzuVfx();\n         this.UpdateMinatoVfx();',1)
 role=role.replace('               this.KakuzuStrikePose(_loc4_);','               this.KakuzuStrikePose(_loc4_);\n               this.MinatoStrikePose(_loc4_);',1)
 role=role.replace('FId == 11120998)','FId == 11120998 || FId == 11121003 || FId == 11121004)') if False else role
 active=(original/c.b.ACTIVE).read_text(encoding='utf-8')
 active=c.inject(active,'IsSkill','         if(FId==11121003 || FId==11121004)return param1>=13122101 && param1<=13122110 && param1!=13122102 && param1!=13122103 && param1!=13122104;')
 token='         this.FCurSequence = this.FTextureAttack.GetAnimationSequenceByIndex(_loc1_);';assert token in active
 active=active.replace(token,'         if(FId==11121003 || FId==11121004)_loc1_=FSkillId==13122103?1:FSkillId==13122104?2:0;\n'+token,1)
 token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);';assert token in active
 dispatch={str(i):['mystery','enhanced-mystery','counter','summon','prowess','evade'].index(name) for i,name in a['moves'].items() if name not in ['standard','standard-2','standard-3']}
 active=active.replace(token,'         if(FId==11121003 || FId==11121004)_loc1_=int(JSON.parse('+json.dumps(json.dumps(dispatch,separators=(',',':')))+')[String(FSkillId)]);\n'+token,1)
 stage=(original/c.b.STAGE).read_text(encoding='utf-8')
 for param in ['param1','param2']:
  token=param+'.RoleBattleInfos[_loc3_].RoleId == 11120998';assert token in stage
  stage=stage.replace(token,'('+token+' || '+token.replace('11120998','11121004')+')',1)
 token='battleRasterHost.getChildAt(battleRasterIndex).name == "kakuzuEdoSkillVfx"';assert token in stage
 stage=stage.replace(token,'('+token+' || battleRasterHost.getChildAt(battleRasterIndex).name == "minatoNewYearSkillVfx")')
 formation=(original/c.b.FORMATION).read_text(encoding='utf-8').replace('this.FSelectHero.Identifier == 11120997','(this.FSelectHero.Identifier == 11120997 || this.FSelectHero.Identifier == 11121003)').replace('this.FSelectHero.Identifier != 11120997','(this.FSelectHero.Identifier != 11120997 && this.FSelectHero.Identifier != 11121003)')
 outputs={c.b.ROLE:role,c.b.ACTIVE:active,c.b.STAGE:stage,c.b.FORMATION:formation}
 for rel in [TAGS,PROFILE]:
  text=(original/rel).read_text(encoding='utf-8');method=c.m.extract(text,'InitCharacterTags');match=re.search(r'JSON.parse\(("(?:\\.|[^"\\])*")\)',method);assert match
  data=json.loads(json.loads(match[1]));data['heroes']['11121003']=[27,62,52,1,18,58];data['tags']['62']={'name':'New Year','icon':'/public/character-tags/62.png'}
  replacement=json.dumps(json.dumps(data,separators=(',',':')))
  outputs[rel]=text.replace(method,method[:match.start(1)]+replacement+method[match.end(1):],1)
  (B/'tags.json').write_text(json.dumps(data,indent=2)+'\n')
 for rel,text in outputs.items():
  dest=B/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(text,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 raw=(B/'compiled.swf').read_bytes();assert [t for t in c.h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags(raw) if t[0]!=82]
 classes=','.join(str(rel.with_suffix('')).replace('\\','.').replace('/','.') for rel in outputs)
 c.ff('-selectclass',classes,'-export','script',B/'verify',B/'compiled.swf')
 allowed={c.b.ROLE:{'PrepareBattleRole','ActivePlay','Reset','UpdateActive','UpdateHealth','RestoreTsunadeAfterRevival'},c.b.ACTIVE:{'IsSkill','PlayAttack','PlaySkill'},c.b.STAGE:{'SetBattle','Reset'},TAGS:{'InitCharacterTags'},PROFILE:{'InitCharacterTags'}}
 counts={}
 for rel in outputs:
  if rel==c.b.FORMATION:continue
  old=(original/rel).read_text(encoding='utf-8');new=(B/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
  for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',old):
   if name not in allowed[rel]:assert c.m.extract(old,name)==c.m.extract(new,name),str(rel)+':'+name;count+=1
  counts[rel.stem]=count
 (B/'client-validation.json').write_text(json.dumps({'unchangedMethods':counts,'sha256':hashlib.sha256(raw).hexdigest()},indent=2)+'\n')
 print('PASS isolated Minato client',counts)
if __name__=='__main__':main()
