"""Incremental Madara dispatch. Keep every unrelated method bytecode intact."""
from pathlib import Path
import importlib.util,json,re,hashlib
B=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(spec);spec.loader.exec_module(c)
c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
TAGS=Path('Processors/Game/Lobby/HerosNew/TWindowAttribute.as');PROFILE=Path('Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as')

def main():
 original=B/'original/scripts';before=(original/c.b.ROLE).read_text(encoding='utf-8');assert 'UpdateMadaraVfx' not in before
 a=json.loads((B/'animation.json').read_text());helper=(B/'native.as.txt').read_text()
 clone=(B.parent/'tsunade-asian/katsuyu.as.txt').read_text().replace('SmallKatsuyu','MadaraClone').replace('11120993','11121002').replace('__DEAD_FRAMES__',str(len(a['clips']['dead']['assets']))).replace('__ENTRY_FRAMES__',str(len(a['clips']['entry']['assets']))).replace('dying ? 1 : 0','dying ? 10 : 9').replace('dying?1:0','dying?10:9').replace('FMadaraCloneDying ? 1 : 0','FMadaraCloneDying ? 10 : 9').replace('FMadaraCloneDying?1:0','FMadaraCloneDying?10:9').replace('FTextureSkill.Count>=2','FTextureSkill.Count>=11')
 role=before.replace('      override public function UpdateActive()',helper+'\n'+clone+'\n      override public function UpdateActive()',1)
 role=c.inject(role,'PrepareBattleRole','         if(FId==11121001 || FId==11121002)PreloadMadaraNative();\n         if(FId==11121002){ClearMadaraClonePose();FMadaraCloneSpawned=false;if(CurHealth<=0){FIsDie=true;visible=false;FHpBar.visible=false;FShaderBmp.visible=false;FBuffSprite.visible=false;}}')
 role=c.inject(role,'ActivePlay','         if(FId==11121001 || FId==11121002)ClearMadaraVfx();\n         if(FId==11121002){if(param1==TYPE_ACTIVE_DIE){PlayMadaraClonePose(true,param5,param6);return;}if(param1==TYPE_ACTIVE_ATTACK || param1==TYPE_ACTIVE_SKILL)ClearMadaraClonePose();}')
 role=c.inject(role,'Reset','         if(FId==11121001 || FId==11121002)ClearMadaraVfx();\n         if(FId==11121002){ClearMadaraClonePose();FMadaraCloneSpawned=false;}')
 role=c.inject(role,'UpdateActive','         if(FId==11121002 && FMadaraCloneStarted>=0){UpdateMadaraClonePose();return;}')
 role=role.replace('            PlayWaterClonePose(false);','            PlayWaterClonePose(false);',1)
 token='         if(FId == 11120998)\n         {\n            PlayWaterClonePose(false);\n         }';assert token in role
 role=role.replace(token,token+'\n         if(FId==11121002){FBitmap.transform.colorTransform=new ColorTransform(0.65,0.85,1,0.9,0,8,22);PlayMadaraClonePose(false);}',1)
 role=role.replace('         this.UpdateKakuzuVfx();','         this.UpdateKakuzuVfx();\n         this.UpdateMadaraVfx();',1)
 role=role.replace('               this.KakuzuStrikePose(_loc4_);','               this.KakuzuStrikePose(_loc4_);\n               this.MadaraStrikePose(_loc4_);',1)
 role=role.replace('FId == 11120998)','FId == 11120998 || FId == 11121001 || FId == 11121002)') if False else role
 active=(original/c.b.ACTIVE).read_text(encoding='utf-8')
 active=c.inject(active,'IsSkill','         if(FId==11121001 || FId==11121002)return param1>=13122001 && param1<=13122012 && param1!=13122002 && param1!=13122006;')
 token='         this.FCurSequence = this.FTextureAttack.GetAnimationSequenceByIndex(_loc1_);';assert token in active
 active=active.replace(token,'         if(FId==11121001 || FId==11121002)_loc1_=FSkillId==13122006?1:0;\n'+token,1)
 token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);';assert token in active
 dispatch={str(i):['mystery','chase','complete','burst-mystery','burst-chase','summon','clone-counter','reflection','burst'].index(name) for i,name in a['moves'].items() if name not in ['standard','burst-standard']}
 active=active.replace(token,'         if(FId==11121001 || FId==11121002)_loc1_=int(JSON.parse('+json.dumps(json.dumps(dispatch,separators=(',',':')))+')[String(FSkillId)]);\n'+token,1)
 stage=(original/c.b.STAGE).read_text(encoding='utf-8')
 for param in ['param1','param2']:
  token=param+'.RoleBattleInfos[_loc3_].RoleId == 11120998';assert token in stage
  stage=stage.replace(token,'('+token+' || '+token.replace('11120998','11121002')+')',1)
 token='battleRasterHost.getChildAt(battleRasterIndex).name == "kakuzuEdoSkillVfx"';assert token in stage
 stage=stage.replace(token,'('+token+' || battleRasterHost.getChildAt(battleRasterIndex).name == "madaraFinalSkillVfx")')
 formation=(original/c.b.FORMATION).read_text(encoding='utf-8').replace('this.FSelectHero.Identifier == 11120997','(this.FSelectHero.Identifier == 11120997 || this.FSelectHero.Identifier == 11121001)').replace('this.FSelectHero.Identifier != 11120997','(this.FSelectHero.Identifier != 11120997 && this.FSelectHero.Identifier != 11121001)')
 outputs={c.b.ROLE:role,c.b.ACTIVE:active,c.b.STAGE:stage,c.b.FORMATION:formation}
 for rel in [TAGS,PROFILE]:
  text=(original/rel).read_text(encoding='utf-8');method=c.m.extract(text,'InitCharacterTags');match=re.search(r'JSON.parse\(("(?:\\.|[^"\\])*")\)',method);assert match
  data=json.loads(json.loads(match[1]));data['heroes']['11121001']=[26,52,1,14,31,48,49]
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
 print('PASS isolated Madara client',counts)
if __name__=='__main__':main()
