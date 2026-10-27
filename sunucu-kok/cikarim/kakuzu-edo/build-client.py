from pathlib import Path
import importlib.util,json,re,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c)
TAGS=Path('Processors/Game/Lobby/HerosNew/TWindowAttribute.as');PROFILE=Path('Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as')
def main():
 original=B/'original/scripts';before=(original/c.b.ROLE).read_text(encoding='utf-8');assert 'UpdateKakuzuVfx' not in before
 a=json.loads((B/'animation.json').read_text());helper=(B/'native.as.txt').read_text();ends={str(i):a['clips'][name]['returnFrame'] for i,name in a['moves'].items()}
 helper=helper.replace('FCurSequence.FrameCount-1','Number(JSON.parse('+json.dumps(json.dumps(ends,separators=(',',':')))+')[String(FSkillId)])')
 helper=helper.replace('__REATTACH_HIT__',str(a['clips']['reattach']['hitFrames'][0]))
 z=(B.parent/'tsunade-asian/katsuyu.as.txt').read_text().replace('SmallKatsuyu','WaterClone').replace('11120993','11120998').replace('__DEAD_FRAMES__',str(len(a['clips']['dead']['assets']))).replace('__ENTRY_FRAMES__',str(len(a['clips']['entry']['assets']))).replace('dying ? 1 : 0','dying ? 8 : 7').replace('dying?1:0','dying?8:7').replace('FWaterCloneDying ? 1 : 0','FWaterCloneDying ? 8 : 7').replace('FWaterCloneDying?1:0','FWaterCloneDying?8:7').replace('FTextureSkill.Count>=2','FTextureSkill.Count>=9')
 role=before.replace('      override public function UpdateActive()',helper+'\n'+z+'\n      override public function UpdateActive()',1)
 role=c.inject(role,'PrepareBattleRole','         if(FId==11120997 || FId==11120998)PreloadKakuzuNative();\n         if(FId==11120998){ClearWaterClonePose();FWaterCloneSpawned=false;if(CurHealth<=0){FIsDie=true;visible=false;FHpBar.visible=false;FShaderBmp.visible=false;FBuffSprite.visible=false;}}')
 role=c.inject(role,'ActivePlay','         if(FId==11120997 || FId==11120998)ClearKakuzuVfx();\n         if(FId==11120998){if(param1==TYPE_ACTIVE_DIE){PlayWaterClonePose(true,param5,param6);return;}if(param1==TYPE_ACTIVE_ATTACK || param1==TYPE_ACTIVE_SKILL)ClearWaterClonePose();}')
 role=c.inject(role,'Reset','         if(FId==11120997 || FId==11120998)ClearKakuzuVfx();\n         if(FId==11120998){ClearWaterClonePose();FWaterCloneSpawned=false;}')
 role=c.inject(role,'UpdateActive','         if(FId==11120998 && FWaterCloneStarted>=0){UpdateWaterClonePose();return;}')
 role=c.inject(role,'CommandPlay','         if(param1==0 && param3==null){this.OnNextCommand(param4);return;}')
 # Reattachment may revive any allied hero, including one whose death tween
 # already hid the role. The shared restore routine resets that visual state.
 role=role.replace('(FId == 11120992 || FId == 11120993 || FId == 11120995 || FId == 11120996) && param1 < 0 && (CurHealth <= 0 || FIsDie || FWaitDie)', 'param1 < 0 && (CurHealth <= 0 || FIsDie || FWaitDie)',1)
 role=role.replace('               RestoreTsunadeAfterRevival();','               if(FId==11120930)RestorePainAfterRevival();else RestoreTsunadeAfterRevival();',1)
 role=role.replace('         this.UpdateNineTailsVfx();','         this.UpdateNineTailsVfx();\n         this.UpdateKakuzuVfx();',1)
 role=role.replace('               this.ObitoStandardPose(_loc4_);','               this.ObitoStandardPose(_loc4_);\n               this.KakuzuStrikePose(_loc4_);',1)
 role=role.replace('(FId == 11120992 || FId == 11120993 || FId == 11120995 || FId == 11120996)','(FId == 11120992 || FId == 11120993 || FId == 11120995 || FId == 11120996 || FId == 11120997 || FId == 11120998)',1)
 method=c.m.extract(role,'RestoreTsunadeAfterRevival');i=method.rfind('}');role=role.replace(method,method[:i]+'         if(FId==11120998)PlayWaterClonePose(false);\n      '+method[i:],1)
 active=(original/c.b.ACTIVE).read_text(encoding='utf-8');active=c.inject(active,'IsSkill','         if(FId==11120997)return param1>=13121901 && param1<=13121909 && param1!=13121902 && param1!=13121903;\n         if(FId==11120998)return param1==13121908 || param1==13121907;')
 token='         this.FCurSequence = this.FTextureAttack.GetAnimationSequenceByIndex(_loc1_);';assert token in active;active=active.replace(token,'         if(FId==11120997)_loc1_=0;\n         if(FId==11120998)_loc1_=0;\n'+token,1)
 token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);';assert token in active;active=active.replace(token,'         if(FId==11120997)_loc1_=FSkillId==13121904?1:FSkillId==13121905?2:FSkillId==13121906?3:FSkillId==13121907?4:FSkillId==13121908?5:FSkillId==13121909?6:0;\n         if(FId==11120998)_loc1_=FSkillId==13121908?5:FSkillId==13121907?4:0;\n'+token,1)
 formation=(original/c.b.FORMATION).read_text(encoding='utf-8').replace('this.FSelectHero.Identifier == 11120994','(this.FSelectHero.Identifier == 11120994 || this.FSelectHero.Identifier == 11120995 || this.FSelectHero.Identifier == 11120997)').replace('this.FSelectHero.Identifier != 11120994','(this.FSelectHero.Identifier != 11120994 && this.FSelectHero.Identifier != 11120995 && this.FSelectHero.Identifier != 11120997)')
 stage=(original/c.b.STAGE).read_text(encoding='utf-8')
 for param in ['param1','param2']:
  token=param+'.RoleBattleInfos[_loc3_].RoleId == 11120993';assert token in stage;stage=stage.replace(token,'('+token+' || '+token.replace('11120993','11120998')+')',1)
 stage=stage.replace('battleRasterHost.getChildAt(battleRasterIndex).name == "tobiWarSkillVfx"','(battleRasterHost.getChildAt(battleRasterIndex).name == "tobiWarSkillVfx" || battleRasterHost.getChildAt(battleRasterIndex).name == "kakuzuEdoSkillVfx")')
 outputs={c.b.ROLE:role,c.b.ACTIVE:active,c.b.STAGE:stage,c.b.FORMATION:formation}
 for rel in [TAGS,PROFILE]:
  text=(original/rel).read_text(encoding='utf-8');method=c.m.extract(text,'InitCharacterTags');match=re.search(r'JSON.parse\(("(?:\\.|[^"\\])*")\)',method);assert match;data=json.loads(json.loads(match.group(1)));data['heroes']['11120997']=[30,52,7,11,48,51];data['tags']['7']={'name':'Hidden Waterfall','icon':'/public/character-tags/7.png'};data['tags']['51']={'name':'Edo Tensei','icon':'/public/character-tags/51.png'};updated=method[:match.start(1)]+json.dumps(json.dumps(data,separators=(',',':')))+method[match.end(1):];outputs[rel]=text.replace(method,updated,1);(B/'tags.json').write_text(json.dumps(data,indent=2)+'\n')
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
 (B/'client-validation.json').write_text(json.dumps({'unchangedMethods':counts,'sha256':hashlib.sha256(raw).hexdigest()},indent=2)+'\n');print('PASS Kakuzu/Zetsu native client',counts)
if __name__=='__main__':main()
