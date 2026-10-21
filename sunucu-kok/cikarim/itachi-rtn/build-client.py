"""Incremental native Itachi actor dispatch and lossless paged effect runtime."""
from pathlib import Path
import importlib.util,json,re,subprocess,shutil,struct,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('m',BASE.parent/'mecha-naruto/build-client.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
h=m.h;b=m.b
JAR='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
BACKPACK=Path('Processors/Game/Lobby/Backpack/TProcessorBackpack.as')
def ff(*args):subprocess.run(['java','-Xmx3g','-jar',JAR,*map(str,args)],check=True,stdout=subprocess.DEVNULL)
def inject(s,name,text):start=s.index('function '+name+'(');p=s.index('{',start)+1;return s[:p]+'\n'+text+'\n'+s[p:]
def main():
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old)
 if (BASE/'compiled.swf').exists() and old==h.swap((BASE/'compiled.swf').read_bytes()):decoded=h.swap((BASE/'client-backups/TApplication.swf').read_bytes())
 (BASE/'source.swf').write_bytes(decoded)
 classes=','.join(str(x.with_suffix('')).replace('\\','.').replace('/','.') for x in [b.ROLE,b.ACTIVE,b.STAGE,b.FORMATION,BACKPACK])
 ff('-selectclass',classes,'-export','script',BASE/'original',BASE/'source.swf')
 before=(BASE/'original/scripts'/b.ROLE).read_text(encoding='utf-8');assert 'UpdateItachiVfx' not in before,'Already installed; refusing an unreviewed rebuild'
 role=before.replace('      private var FMechaVfxStarted:', '      private var FItachiVfxStarted:Boolean=false;\n      private var FItachiActiveVfx:Array=[];\n      private static var FItachiFxCache:Object={};\n      private static var FItachiFxLoading:Object={};\n      private var FMechaVfxStarted:',1)
 names=['PreloadMechaVfx','MechaPinPages','PumpMechaVfxQueue','LoadMechaVfxAtlas','TrimMechaVfxCache','MechaFirstAtlas','PlayMechaVfxAsset','FitMechaPose','MechaBackdrop']
 runtime='\n'.join(m.extract(before,n).replace('Mecha','Itachi').replace('mecha','itachi').replace('11120950','11120960') for n in names)
 manifest=json.loads((BASE/'vfx.json').read_text());anim=json.loads((BASE/'animation.json').read_text());manifest.update(moves=anim['moves'],actions=anim['effects'])
 runtime=re.sub(r'for each\(var effect:String in \[[^\]]+\]\)', 'for each(var effect:String in '+json.dumps(sorted(set(e for es in anim['effects'].values() for e in es)))+')',runtime,count=1)
 runtime+='''
      private static function ItachiVfxManifest():Object {
         if(FItachiFxLoading["_manifest"]!=null)return FItachiFxLoading["_manifest"];
         var manifest:Object=JSON.parse(__MANIFEST__);manifest.firstAtlases={};
         for(var name:String in manifest.clips){var clip:Object=manifest.clips[name];
            if(clip.width*clip.height<150000 && (name.indexOf("Yafenshen")>=0 || name.indexOf("Huanshuxielunyan-")>=0))manifest.firstAtlases[clip.atlas]=true;
            clip.nextAtlases=[];var next:String=null;
            for(var i:int=clip.frameAtlases.length-1;i>=0;i--){if(i+1<clip.frameAtlases.length && String(clip.frameAtlases[i])!=String(clip.frameAtlases[i+1]))next=String(clip.frameAtlases[i+1]);clip.nextAtlases[i]=next;}
            clip.aheadPages=[];
            for(var tick:int=0;tick<clip.timeline.length;tick++){var pages:Array=[];var seen:Object={};for(var j:int=tick;j<Math.min(tick+21,clip.timeline.length);j++){var page:String=String(clip.frameAtlases[j]);if(!seen[page]){seen[page]=true;pages.push(page);}}clip.aheadPages[tick]=pages;}
         }
         FItachiFxLoading["_manifest"]=manifest;return manifest;
      }
      private function UpdateItachiVfx():void {
         if(FId!=11120960 || FSkillId<13121201 || FSkillId>13121207 || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL) || FItachiVfxStarted)return;
         for each(var old:Sprite in FItachiActiveVfx)if(old.parent!=null)old.parent.removeChild(old);
         FItachiActiveVfx=[];FItachiVfxStarted=true;ShowItachiVfx(FSkillId);
      }
      private function ShowItachiVfx(skill:int):void {
         var host:DisplayObjectContainer=FBattleStage;if(host==null || host.stage==null)return;
         var origin:Point=host.globalToLocal(localToGlobal(new Point()));var center:Point=new Point();var count:int=0;var targets:Array=[];var seen:Object={};
         if(FTargets!=null && FResults!=null)for(var i:int=0;i<FTargets.length && i<FResults.length;i++){var enemy:TRole=FTargets[i];if(enemy==null || enemy==this || enemy.Camp==Camp || FResults[i].CMD!=TTargetInfo.CMD_ATTACK)continue;var key:String=enemy.Camp+"_"+enemy.Pos;if(seen[key])continue;seen[key]=true;var pt:Point=host.globalToLocal(enemy.localToGlobal(new Point()));targets.push(pt);center.x+=pt.x;center.y+=pt.y;count++;}
         if(count){center.x/=count;center.y/=count;}else center=origin.clone();
         var tl:Point=host.globalToLocal(stage.localToGlobal(new Point()));var br:Point=host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));var unit:Number=Math.abs(br.x-tl.x)/1250;
         if(skill==13121201 || skill==13121202)ItachiBackdrop(host);
         var data:Object=ItachiVfxManifest();var clipName:String=String(data.moves[skill]);var effects:Array=data.actions[clipName] as Array;
         if(effects!=null)for each(var effect:String in effects)PlayItachiEffect(effect,host,(skill==13121203 || skill==13121207)?origin:center,skill==13121207?360:skill==13121203?450:1150,unit,0);
         if(skill==13121203)for each(pt in targets)PlayItachiEffect("YuzhiboyoRZZL_Huanshuxielunyan_shouji",host,pt,360,unit,1250);
         if(skill==13121206)for each(pt in targets){PlayItachiEffect("YuzhiboyoRZZL_Yongbingjituan_SB_zhen",host,pt,240,unit,500);PlayItachiEffect("YuzhiboyoRZZL_Yongbingjituan_SB_shouji",host,pt,500,unit,3250);}
      }
      private function PlayItachiEffect(effect:String,host:DisplayObjectContainer,at:Point,limit:Number,unit:Number,delay:int):void {
         var data:Object=ItachiVfxManifest();var layers:Array=data.effects[effect] as Array;if(layers==null)return;
         if(layers.length>0 && data.clips[String(layers[0])].cameraClip){
            var screenTL:Point=host.globalToLocal(stage.localToGlobal(new Point()));var screenBR:Point=host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
            var sw:Number=screenBR.x-screenTL.x;var sh:Number=screenBR.y-screenTL.y;var scale:Number=Math.min(sw/1250,sh/650);var px:Number=scaleX<0?925:325;
            var cameraAt:Point=new Point(screenTL.x+(sw-1250*scale)/2+px*scale,screenTL.y+(sh-650*scale)/2+450*scale);
            for each(var cameraKey:String in layers)PlayItachiVfxAsset(cameraKey,host,cameraAt,1250*scale,650*scale,delay,scaleX<0,false,false);
            return;
         }
         var left:Number=0;var right:Number=0;var top:Number=0;var bottom:Number=0;
         for each(var key:String in layers){var c:Object=data.clips[key];var w:Number=c.width/c.renderScale;var h:Number=c.height/c.renderScale;left=Math.min(left,-Number(c.pivot[0])*w);right=Math.max(right,(1-Number(c.pivot[0]))*w);top=Math.min(top,-Number(c.pivot[1])*h);bottom=Math.max(bottom,(1-Number(c.pivot[1]))*h);}
         var tl:Point=host.globalToLocal(stage.localToGlobal(new Point()));var br:Point=host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         var width:Number=Math.max(1,right-left);var height:Number=Math.max(1,bottom-top);
         var fit:Number=Math.min(1.5*unit,limit*unit/Math.max(width,height),(br.x-tl.x-24*unit)/width,(br.y-tl.y-36*unit)/height);
         var mirrored:Boolean=scaleX<0;var low:Number=mirrored?-right:left;var high:Number=mirrored?-left:right;
         at=at.clone();at.x=Math.max(tl.x+12*unit-low*fit,Math.min(br.x-12*unit-high*fit,at.x));at.y=Math.max(tl.y+18*unit-top*fit,Math.min(br.y-18*unit-bottom*fit,at.y));
         for each(key in layers){c=data.clips[key];PlayItachiVfxAsset(key,host,at,c.width/c.renderScale*fit,c.height/c.renderScale*fit,delay,scaleX<0,false,false);}
      }
'''.replace('__MANIFEST__',json.dumps(json.dumps(manifest,separators=(',',':'))))
 role=role.replace('      override public function UpdateActive()',runtime+'\n      override public function UpdateActive()',1)
 role=role.replace('         ++FCombatVfxSerial;','         ++FCombatVfxSerial;\n         if(FId==11120960)FItachiVfxStarted=false;',1)
 role=role.replace('         this.UpdateMechaVfx();','         this.UpdateMechaVfx();\n         this.UpdateItachiVfx();',1)
 role=role.replace('            this.FitMechaPose();','            this.FitMechaPose();\n            this.FitItachiPose();',1)
 role=inject(role,'PrepareDormantKabuto','         if(FId==11120960)PreloadItachiVfx();')
 role=inject(role,'AddTextEffectByCMD','''         var itachiMarker:uint=uint(param1.ResultInfo.BuffId);
         if(param1.CMD==TTargetInfo.CMD_FLOAT && itachiMarker>19001200 && itachiMarker<19001220){var notices:Array=["","SUPPRESS IMMUNITY","SUPPRESS SUPER ARMOR","CRITICAL GROWTH / HP +15%","CHAKRA DRAIN / LIMIT "+param1.ResultInfo.BuffTurn,"EXTREME CHAOS","MYSTERY CHAKRA COST +"+param1.ResultInfo.BuffTurn,"LEVEL 2 IGNITION / PARALYSIS","DEBUFF CANCELLED / HIDING"];ShowHashiramaStatusText(String(notices[itachiMarker-19001200]),0xFFCC66);return;}''')
 active=(BASE/'original/scripts'/b.ACTIVE).read_text(encoding='utf-8')
 active=inject(active,'IsSkill','         if(this.FId==11120960 && param1>=13121201 && param1<=13121207)return param1!=13121203;')
 active=inject(active,'PlaySkill','         if(this.FId==11120960 && this.FSkillId==13121203){this.FCallBackDict[TYPE_ACTIVE_ATTACK]=this.FCallBackDict[TYPE_ACTIVE_SKILL];this.FTimeDict[TYPE_ACTIVE_ATTACK]=this.FTimeDict[TYPE_ACTIVE_SKILL];this.PlayAttack();return;}')
 token='         this.FCurSequence = this.FTextureAttack.GetAnimationSequenceByIndex(_loc1_);';assert token in active;active=active.replace(token,'         if(this.FId==11120960)_loc1_=0;\n'+token,1)
 token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);';assert token in active;active=active.replace(token,'         if(this.FId==11120960 && this.FSkillId>=13121201 && this.FSkillId<=13121207)_loc1_=uint(this.FSkillId==13121207?5:this.FSkillId>=13121204?this.FSkillId-13121202:this.FSkillId-13121201);\n'+token,1)
 formation=(BASE/'original/scripts'/b.FORMATION).read_text(encoding='utf-8').replace('this.FSelectHero.Identifier == 11120950','(this.FSelectHero.Identifier == 11120950 || this.FSelectHero.Identifier == 11120960)').replace('this.FSelectHero.Identifier != 11120950','(this.FSelectHero.Identifier != 11120950 && this.FSelectHero.Identifier != 11120960)')
 stage=(BASE/'original/scripts'/b.STAGE).read_text(encoding='utf-8').replace('kabutoRasterHost.getChildAt(kabutoRasterIndex).name == "mechaSkillVfx"','(kabutoRasterHost.getChildAt(kabutoRasterIndex).name == "mechaSkillVfx" || kabutoRasterHost.getChildAt(kabutoRasterIndex).name == "itachiSkillVfx")')
 inventory=(BASE/'original/scripts'/BACKPACK).read_text(encoding='utf-8')
 for name in ['ProcessorInventoryUpdateByBackpack','InsertNewlyReceivedInventory']:
  original=m.extract(inventory,name);inventory=inventory.replace(original,original.replace('case CATEGORY_Normal:','case 21:\n               case CATEGORY_Normal:'))
 for rel,text in [(b.ROLE,role),(b.ACTIVE,active),(b.STAGE,stage),(b.FORMATION,formation),(BACKPACK,inventory)]:dest=BASE/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(text,encoding='utf-8')
 ff('-onerror','abort','-importScript',BASE/'source.swf',BASE/'compiled.swf',BASE/'patched');rebuilt=(BASE/'compiled.swf').read_bytes()
 assert [x for x in h.tags(decoded) if x[0]!=82]==[x for x in h.tags(rebuilt) if x[0]!=82]
 ff('-selectclass',classes,'-export','script',BASE/'verify',BASE/'compiled.swf')
 verified=(BASE/'verify/scripts'/b.ROLE).read_text(encoding='utf-8');changed={'PrepareDormantKabuto','ActivePlay','UpdateActive','UpdateAnimationFrame','AddTextEffectByCMD'}
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name not in changed:assert m.extract(before,name)==m.extract(verified,name),name
 version=canonical.parent/'version.swf';raw=zlib.decompress(version.read_bytes());pos=2;parts=[raw[:2]];found=0
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
  if k==b'TApplication.swf':v=b'2026102104';found+=1
  parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
 assert found==1 and pos==len(raw) and canonical.read_bytes()==old
 backup=BASE/'client-backups';backup.mkdir(exist_ok=True)
 for f in [canonical,version]:
  if not (backup/f.name).exists():shutil.copy2(f,backup/f.name)
 protected=h.swap(rebuilt);alias=h.PUBLIC/'2026102104/TApplication.swf';alias.parent.mkdir(exist_ok=True);alias.write_bytes(protected);canonical.write_bytes(protected);version.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS Itachi native actor/VFX/formation client 2026102104')
if __name__=='__main__':main()
