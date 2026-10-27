from pathlib import Path
import importlib.util,json,re,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c)
TAGS=Path('Processors/Game/Lobby/HerosNew/TWindowAttribute.as');PROFILE=Path('Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as')
def main():
 original=B/'original/scripts';before=(original/c.b.ROLE).read_text(encoding='utf-8');assert 'UpdateTobiVfx' not in before
 a=json.loads((B/'animation.json').read_text());helper=(B/'native.as.txt').read_text();ends={str(i):a['clips'][name]['returnFrame'] for i,name in a['moves'].items()}
 helper=helper.replace('FCurSequence.FrameCount-1','Number(JSON.parse('+json.dumps(json.dumps(ends,separators=(',',':')))+')[String(FSkillId)])')
 z=(B.parent/'tsunade-asian/katsuyu.as.txt').read_text().replace('SmallKatsuyu','WhiteZetsu').replace('11120993','11120996').replace('__DEAD_FRAMES__',str(len(a['clips']['zetsu-dead']['assets']))).replace('__ENTRY_FRAMES__',str(len(a['clips']['zetsu-entry']['assets'])))
 role=before.replace('      override public function UpdateActive()',helper+'\n'+z+'\n      override public function UpdateActive()',1)
 role=c.inject(role,'PrepareBattleRole','         if(FId==11120995)PreloadTobiNative();\n         if(FId==11120996){ClearWhiteZetsuPose();FWhiteZetsuSpawned=false;if(CurHealth<=0){FIsDie=true;visible=false;FHpBar.visible=false;FShaderBmp.visible=false;FBuffSprite.visible=false;}}')
 role=c.inject(role,'ActivePlay','         if(FId==11120995)ClearTobiVfx();\n         if(FId==11120996){if(param1==TYPE_ACTIVE_DIE){PlayWhiteZetsuPose(true,param5,param6);return;}if(param1==TYPE_ACTIVE_ATTACK || param1==TYPE_ACTIVE_SKILL)ClearWhiteZetsuPose();}')
 role=c.inject(role,'Reset','         if(FId==11120995)ClearTobiVfx();\n         if(FId==11120996){ClearWhiteZetsuPose();FWhiteZetsuSpawned=false;}')
 role=c.inject(role,'UpdateActive','         if(FId==11120996 && FWhiteZetsuStarted>=0){UpdateWhiteZetsuPose();return;}')
 role=c.inject(role,'CommandPlay','         if(param1==0 && param3==null){this.OnNextCommand(param4);return;}')
 role=role.replace('         this.UpdateNineTailsVfx();','         this.UpdateNineTailsVfx();\n         this.UpdateTobiVfx();',1)
 role=role.replace('               this.ObitoStandardPose(_loc4_);','               this.ObitoStandardPose(_loc4_);\n               this.TobiStrikePose(_loc4_);',1)
 role=role.replace('(FId == 11120992 || FId == 11120993)','(FId == 11120992 || FId == 11120993 || FId == 11120995 || FId == 11120996)',1)
 method=c.m.extract(role,'RestoreTsunadeAfterRevival');i=method.rfind('}');role=role.replace(method,method[:i]+'         if(FId==11120996)PlayWhiteZetsuPose(false);\n      '+method[i:],1)
 active=(original/c.b.ACTIVE).read_text(encoding='utf-8');active=c.inject(active,'IsSkill','         if(FId==11120995)return param1>=13121801 && param1<=13121807 && param1!=13121802 && param1!=13121803;\n         if(FId==11120996)return param1==13121809;')
 token='         this.FCurSequence = this.FTextureAttack.GetAnimationSequenceByIndex(_loc1_);';assert token in active;active=active.replace(token,'         if(FId==11120995)_loc1_=FSkillId==13121803?1:0;\n         if(FId==11120996)_loc1_=0;\n'+token,1)
 token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);';assert token in active;active=active.replace(token,'         if(FId==11120995)_loc1_=FSkillId==13121804?1:FSkillId==13121805?2:FSkillId==13121806?3:FSkillId==13121807?4:0;\n         if(FId==11120996)_loc1_=2;\n'+token,1)
 formation=(original/c.b.FORMATION).read_text(encoding='utf-8').replace('this.FSelectHero.Identifier == 11120994','(this.FSelectHero.Identifier == 11120994 || this.FSelectHero.Identifier == 11120995)').replace('this.FSelectHero.Identifier != 11120994','(this.FSelectHero.Identifier != 11120994 && this.FSelectHero.Identifier != 11120995)')
 stage=(original/c.b.STAGE).read_text(encoding='utf-8')
 for param in ['param1','param2']:
  token=param+'.RoleBattleInfos[_loc3_].RoleId == 11120993';assert token in stage;stage=stage.replace(token,'('+token+' || '+token.replace('11120993','11120996')+')',1)
 stage=stage.replace('battleRasterHost.getChildAt(battleRasterIndex).name == "nineTailsSkillVfx"','(battleRasterHost.getChildAt(battleRasterIndex).name == "nineTailsSkillVfx" || battleRasterHost.getChildAt(battleRasterIndex).name == "tobiWarSkillVfx")')
 outputs={c.b.ROLE:role,c.b.ACTIVE:active,c.b.STAGE:stage,c.b.FORMATION:formation}
 for rel in [TAGS,PROFILE]:
  text=(original/rel).read_text(encoding='utf-8');method=c.m.extract(text,'InitCharacterTags');match=re.search(r'JSON.parse\(("(?:\\.|[^"\\])*")\)',method);assert match;data=json.loads(json.loads(match.group(1)));data['heroes']['11120995']=[30,52,11,12,14];updated=method[:match.start(1)]+json.dumps(json.dumps(data,separators=(',',':')))+method[match.end(1):];outputs[rel]=text.replace(method,updated,1);(B/'tags.json').write_text(json.dumps(data,indent=2)+'\n')
 for rel,text in outputs.items():
  dest=B/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(text,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 raw=(B/'compiled.swf').read_bytes();assert [t for t in c.h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags(raw) if t[0]!=82]
 classes=','.join(str(rel.with_suffix('')).replace('\\','.').replace('/','.') for rel in outputs);c.ff('-selectclass',classes,'-export','script',B/'verify',B/'compiled.swf')
 allowed={c.b.ROLE:{'PrepareBattleRole','ActivePlay','Reset','UpdateActive','RestoreTsunadeAfterRevival','UpdateHealth','ChangeHP','CommandPlay'},c.b.ACTIVE:{'IsSkill','PlayAttack','PlaySkill'},c.b.STAGE:{'SetBattle','Reset'},TAGS:{'InitCharacterTags'},PROFILE:{'InitCharacterTags'}};counts={}
 for rel in outputs:
  old=(original/rel).read_text(encoding='utf-8');new=(B/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
  if rel==c.b.FORMATION:continue
  for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',old):
   if name not in allowed[rel]:assert c.m.extract(old,name)==c.m.extract(new,name),str(rel)+':'+name;count+=1
  counts[rel.stem]=count
 (B/'client-validation.json').write_text(json.dumps({'unchangedMethods':counts,'sha256':hashlib.sha256(raw).hexdigest()},indent=2)+'\n');print('PASS Tobi/Zetsu native client',counts)
if __name__=='__main__':main()
