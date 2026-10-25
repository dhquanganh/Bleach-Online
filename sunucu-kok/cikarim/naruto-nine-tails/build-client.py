"""Add isolated Naruto dispatch and Mecha's paged lossless VFX runtime."""
from pathlib import Path
import importlib.util,json,re,shutil,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c)
TAGS=Path('Processors/Game/Lobby/HerosNew/TWindowAttribute.as');PROFILE=Path('Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as')
def main():
 original=B/'original/scripts';before=(original/c.b.ROLE).read_text(encoding='utf-8');assert 'UpdateNineTailsVfx' not in before
 fields='''      private var FNineTailsVfxStarted:Boolean=false;
      private var FNineTailsActiveVfx:Array=[];
      private static var FNineTailsFxCache:Object={};
      private static var FNineTailsFxLoading:Object={};
'''
 names=['PreloadTsunadeVfx','TsunadePinPages','PumpTsunadeVfxQueue','LoadTsunadeVfxAtlas','TrimTsunadeVfxCache','TsunadeFirstAtlas','PlayTsunadeVfxAsset','FitTsunadePose','TsunadeBackdrop','PlayTsunadeEffect']
 runtime='\n'.join(c.m.extract(before,name) for name in names)
 # Only the Tsunade portrait has this special fullscreen route.
 runtime=re.sub(r'         if\(effect == "gangshou_aoyi1_niansuantexie"\)\s*\{.*?\n         \}', '',runtime,flags=re.S)
 runtime=runtime.replace('Tsunade','NineTails').replace('tsunade','nineTails').replace('11120992','11120994')
 effects=['1nrvDaji_lizi_quan','1nrv_luoxuanwan','MRzy']
 runtime=re.sub(r'for each\(var effect:String in \[[^\]]+\]\)', 'for each(var effect:String in '+json.dumps(effects)+')',runtime,count=1)
 a=json.loads((B/'animation.json').read_text());manifest=json.loads((B/'vfx.json').read_text());manifest.update(moves=a['moves'],actions=a['effects'])
 # Keep each effect's original relative layer scale and a single shared mirror.
 runtime+='''
      private static function NineTailsVfxManifest():Object {
         if(FNineTailsFxLoading["_manifest"]!=null)return FNineTailsFxLoading["_manifest"];
         var data:Object=JSON.parse(__MANIFEST__);data.firstAtlases={};
         for(var key:String in data.clips){var clip:Object=data.clips[key];data.firstAtlases[clip.atlas]=true;clip.nextAtlases=[];var next:String=null;
            for(var i:int=clip.frameAtlases.length-1;i>=0;i--){if(i+1<clip.frameAtlases.length && String(clip.frameAtlases[i])!=String(clip.frameAtlases[i+1]))next=String(clip.frameAtlases[i+1]);clip.nextAtlases[i]=next;}
            clip.aheadPages=[];for(var tick:int=0;tick<clip.timeline.length;tick++){var pages:Array=[];var seen:Object={};for(var j:int=tick;j<Math.min(tick+21,clip.timeline.length);j++){var page:String=String(clip.frameAtlases[j]);if(!seen[page]){seen[page]=true;pages.push(page);}}clip.aheadPages[tick]=pages;}
         }FNineTailsFxLoading["_manifest"]=data;return data;
      }
      private function UpdateNineTailsVfx():void {
         if(FId!=11120994 || (FSkillId!=13121701 && FSkillId!=13121702 && FSkillId!=13121703 && FSkillId!=13121704 && FSkillId!=13121706) || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL) || FNineTailsVfxStarted)return;
         for each(var old:Sprite in FNineTailsActiveVfx)if(old.parent!=null)old.parent.removeChild(old);
         FNineTailsActiveVfx=[];FNineTailsVfxStarted=true;ShowNineTailsVfx(FSkillId);
      }
      private function ShowNineTailsVfx(skill:int):void {
         var host:DisplayObjectContainer=FBattleStage;if(host==null || stage==null)return;
         var origin:Point=host.globalToLocal(localToGlobal(new Point()));var center:Point=origin.clone();var count:int=0;
         if(skill!=13121706 && FTargets!=null && FResults!=null){center=new Point();var seen:Object={};
            for(var i:int=0;i<FTargets.length && i<FResults.length;i++){var enemy:TRole=FTargets[i];if(enemy==null || enemy.Camp==Camp || FResults[i].CMD!=1)continue;var key:String=enemy.Camp+"_"+enemy.Pos;if(seen[key])continue;seen[key]=true;var pt:Point=host.globalToLocal(enemy.localToGlobal(new Point()));center.x+=pt.x;center.y+=pt.y;count++;}
            if(count){center.x/=count;center.y/=count;}else center=origin.clone();
         }
         var data:Object=NineTailsVfxManifest();var effects:Array=data.actions[String(data.moves[skill])] as Array;
         var unit:Number=stage.stageWidth/1250;
         if(effects!=null)for each(var effect:String in effects)PlayNineTailsEffect(effect,host,skill==13121706?origin:center,skill==13121701?1150:skill==13121706?440:400,unit,0);
      }
'''.replace('__MANIFEST__',json.dumps(json.dumps(manifest,separators=(',',':'))))
 role=before.replace('      override public function UpdateActive()',fields+runtime+'\n      override public function UpdateActive()',1)
 role=role.replace('         ++FCombatVfxSerial;','         ++FCombatVfxSerial;\n         if(FId==11120994)FNineTailsVfxStarted=false;',1)
 role=role.replace('         this.UpdateTsunadeVfx();','         this.UpdateTsunadeVfx();\n         this.UpdateNineTailsVfx();',1)
 role=role.replace('            this.FitTsunadePose();','            this.FitTsunadePose();\n            this.FitNineTailsPose();',1)
 role=c.inject(role,'PrepareBattleRole','         if(FId==11120994)PreloadNineTailsVfx();')
 role=c.inject(role,'AddTextEffectByCMD','         if(param1.CMD==TTargetInfo.CMD_FLOAT && uint(param1.ResultInfo.BuffId)==19001801){TEffectControl.ShowPublicEffect(FEffectSprite,13622702,0,0,null);ShowHashiramaStatusText("IGNITION",0xFF8035);return;}')
 alignment_spec=importlib.util.spec_from_file_location('naruto_alignment',B/'repair-alignment.py');alignment=importlib.util.module_from_spec(alignment_spec);alignment_spec.loader.exec_module(alignment);role=alignment.patch(role)
 native_spec=importlib.util.spec_from_file_location('naruto_native',B/'repair-profile-rasengan.py');native=importlib.util.module_from_spec(native_spec);native_spec.loader.exec_module(native);role=native.patch(role)
 active=(original/c.b.ACTIVE).read_text(encoding='utf-8')
 active=c.inject(active,'IsSkill','         if(this.FId==11120994)return param1==13121701 || param1==13121706;')
 token='         this.FCurSequence = this.FTextureAttack.GetAnimationSequenceByIndex(_loc1_);';assert token in active
 active=active.replace(token,'         if(this.FId==11120994)_loc1_=this.FSkillId==13121704?2:this.FSkillId==13121703?1:0;\n'+token,1)
 token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);';assert token in active
 active=active.replace(token,'         if(this.FId==11120994)_loc1_=this.FSkillId==13121706?1:0;\n'+token,1)
 formation=(original/c.b.FORMATION).read_text(encoding='utf-8').replace('this.FSelectHero.Identifier == 11120992','(this.FSelectHero.Identifier == 11120992 || this.FSelectHero.Identifier == 11120994)').replace('this.FSelectHero.Identifier != 11120992','(this.FSelectHero.Identifier != 11120992 && this.FSelectHero.Identifier != 11120994)')
 assert formation!=(original/c.b.FORMATION).read_text(encoding='utf-8')
 stage=(original/c.b.STAGE).read_text(encoding='utf-8').replace('battleRasterHost.getChildAt(battleRasterIndex).name == "tsunadeSkillVfx"','(battleRasterHost.getChildAt(battleRasterIndex).name == "tsunadeSkillVfx" || battleRasterHost.getChildAt(battleRasterIndex).name == "nineTailsSkillVfx")')
 outputs={c.b.ROLE:role,c.b.ACTIVE:active,c.b.FORMATION:formation,c.b.STAGE:stage}
 for rel in [TAGS,PROFILE]:
  text=(original/rel).read_text(encoding='utf-8');method=c.m.extract(text,'InitCharacterTags')
  match=re.search(r'JSON.parse\(("(?:\\.|[^"\\])*")\)',method);assert match
  data=json.loads(json.loads(match.group(1)));data['heroes']['11120994']=[27,52,1,13,47,58]
  updated=method[:match.start(1)]+json.dumps(json.dumps(data,separators=(',',':')))+method[match.end(1):]
  outputs[rel]=text.replace(method,updated,1)
  if rel==TAGS:(B/'tags.json').write_text(json.dumps(data,indent=2)+'\n')
 for rel,text in outputs.items():
  dest=B/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(text,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 raw=(B/'compiled.swf').read_bytes();assert [t for t in c.h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags(raw) if t[0]!=82]
 classes=','.join(str(rel.with_suffix('')).replace('\\','.').replace('/','.') for rel in outputs)
 c.ff('-selectclass',classes,'-export','script',B/'verify',B/'compiled.swf')
 allowed={c.b.ROLE:{'PrepareBattleRole','ActivePlay','UpdateActive','AddTextEffectByCMD'},c.b.ACTIVE:{'IsSkill','PlayAttack','PlaySkill'},c.b.STAGE:{'Reset'},TAGS:{'InitCharacterTags'},PROFILE:{'InitCharacterTags'}}
 counts={}
 for rel in outputs:
  old=(original/rel).read_text(encoding='utf-8');new=(B/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
  if rel==c.b.FORMATION:continue
  for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',old):
   if name not in allowed[rel]:assert c.m.extract(old,name)==c.m.extract(new,name),str(rel)+':'+name;count+=1
  counts[rel.stem]=count
 (B/'client-validation.json').write_text(json.dumps({'unchangedMethods':counts,'sha256':hashlib.sha256(raw).hexdigest()},indent=2)+'\n')
 print('PASS isolated Naruto client compiled and unrelated methods preserved',counts)
if __name__=='__main__':main()
