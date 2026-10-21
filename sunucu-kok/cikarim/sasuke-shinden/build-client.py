"""Install isolated Sasuke native dispatch and paged VFX; preserve other heroes."""
from pathlib import Path
import importlib.util,json,re,shutil
from presentation import configure
BASE=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('helper',BASE.parent/'itachi-rtn/build-client.py');h=importlib.util.module_from_spec(s);s.loader.exec_module(h)
b=h.b;m=h.m;ff=h.ff
ROLE=h.b.ROLE;ACTIVE=h.b.ACTIVE;STAGE=h.b.STAGE;FORMATION=h.b.FORMATION
def main():
 canonical=h.h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();raw=h.h.swap(old)
 if (BASE/'compiled.swf').exists() and old==h.h.swap((BASE/'compiled.swf').read_bytes()):raw=h.h.swap((BASE/'backups/TApplication.swf').read_bytes())
 source=BASE/'source.swf';source.write_bytes(raw)
 classes=','.join(str(r.with_suffix('')).replace('\\','.').replace('/','.') for r in [ROLE,ACTIVE,STAGE,FORMATION])
 h.ff('-selectclass',classes,'-export','script',BASE/'original',source)
 before=(BASE/'original/scripts'/ROLE).read_text(encoding='utf8');assert 'UpdateSasukeVfx' not in before
 role=before.replace('      private var FItachiVfxStarted:', '      private var FSasukeVfxStarted:Boolean=false;\n      private var FSasukeActiveVfx:Array=[];\n      private static var FSasukeFxCache:Object={};\n      private static var FSasukeFxLoading:Object={};\n      private var FItachiVfxStarted:',1)
 names=['PreloadItachiVfx','ItachiPinPages','PumpItachiVfxQueue','LoadItachiVfxAtlas','TrimItachiVfxCache','ItachiFirstAtlas','PlayItachiVfxAsset','FitItachiPose','ItachiBackdrop']
 runtime='\n'.join(h.m.extract(before,n).replace('Itachi','Sasuke').replace('itachi','sasuke').replace('11120960','11120970') for n in names)
 # Keep the Mecha-style pooled BitmapData + copyPixels renderer, but copy only
 # each frame's visible rectangle. All positions stay in original clip space.
 start=runtime.index('      private function PlaySasukeVfxAsset(')
 end=runtime.index('      private function FitSasukePose(',start)
 player=runtime[start:end]
 old_block=re.search(r'               var cellW:int.*?               if\(clip.tint != null\)',player,re.S)
 assert old_block,'Sasuke frame renderer changed'
 player=player[:old_block.start()]+'''               var rect:Array = clip.frameRects[frame];
               if(buffer == null)
               {
                  buffer = new BitmapData(int(clip.bufferWidth),int(clip.bufferHeight),true,0);
                  image.bitmapData = buffer;
               }
               // Clear the reusable trimmed surface atomically so smaller
               // frames cannot retain pixels from preceding larger frames.
               buffer.lock();buffer.fillRect(buffer.rect,0);
               copyRect.x = int(rect[0]);copyRect.y = int(rect[1]);
               copyRect.width = int(rect[2]);copyRect.height = int(rect[3]);
               buffer.copyPixels(atlas,copyRect,copyOrigin);
               buffer.unlock();
               image.scaleX = width / Number(clip.width);
               image.scaleY = height / Number(clip.height);
               image.x = (Number(rect[4])-Number(clip.pivot[0])*Number(clip.width))*image.scaleX;
               image.y = (Number(rect[5])-Number(clip.pivot[1])*Number(clip.height))*image.scaleY;
               if(clip.tint != null)'''+player[old_block.end():]
 # Do not repeat pinning, sorting and transform work when x1 has not advanced
 # the animation frame. A missing page is retried because lastFrame stays old.
 player=player.replace('            var frameAtlas:String =','            if(frame == lastFrame)return;\n            var frameAtlas:String =',1)
 runtime=runtime[:start]+player+runtime[end:]
 runtime=runtime.replace('>= 6','>= 2').replace('pixels > 40000000','pixels > 32000000')
 manifest=json.loads((BASE/'vfx.json').read_text());anim=json.loads((BASE/'animation.json').read_text());manifest.update(moves=anim['moves'],actions=anim['effects'])
 profiles=configure(manifest,anim,h.h.PUBLIC.parent)
 (BASE/'presentation.json').write_text(json.dumps(profiles,indent=2)+'\n')
 manifest['cinematics']=json.loads((BASE/'cinematics.json').read_text())
 for effect in manifest['cinematics']:
  for key in manifest['effects'][effect]:manifest['clips'].pop(key,None)
  manifest['effects'][effect]=[]
 used={page for clip in manifest['clips'].values() for page in clip['frameAtlases']}
 manifest['atlases']={key:value for key,value in manifest['atlases'].items() if key in used}
 runtime=runtime.replace('         var manifest:Object = SasukeVfxManifest();','         var manifest:Object = SasukeVfxManifest();\n         for(var cinematic:String in manifest.cinematics)LoadSasukeCinematic(cinematic,manifest.cinematics[cinematic]);',1)
 runtime=re.sub(r'for each\(var effect:String in \[[^\]]+\]\)','for each(var effect:String in '+json.dumps(sorted(set(e for es in anim['effects'].values() for e in es)))+')',runtime,count=1)
 runtime+='''
      private static function SasukeVfxManifest():Object {
         if(FSasukeFxLoading["_manifest"]!=null)return FSasukeFxLoading["_manifest"];
         var manifest:Object=JSON.parse(__MANIFEST__);manifest.firstAtlases={};
         for(var key:String in manifest.clips){var clip:Object=manifest.clips[key];
            // Keep exactly the preloaded five opening frames resident. Evicting
            // these between casts caused visible cold-start gaps at x2.
            for(var head:int=0;head<Math.min(5,clip.timeline.length);head++)manifest.firstAtlases[String(clip.frameAtlases[head])]=true;
            clip.aheadPages=[];
            for(var tick:int=0;tick<clip.timeline.length;tick++){var pages:Array=[];var seen:Object={};for(var j:int=tick;j<Math.min(tick+40,clip.timeline.length);j++){var page:String=String(clip.frameAtlases[j]);if(!seen[page]){seen[page]=true;pages.push(page);}}clip.aheadPages[tick]=pages;}
         }
         FSasukeFxLoading["_manifest"]=manifest;return manifest;
      }
      private function UpdateSasukeVfx():void {
         if(FId!=11120970 || FSkillId<13121301 || FSkillId>13121309 || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL) || FSasukeVfxStarted)return;
         for each(var old:Sprite in FSasukeActiveVfx)if(old.parent!=null)old.parent.removeChild(old);
         FSasukeActiveVfx=[];FSasukeVfxStarted=true;ShowSasukeVfx(FSkillId);
      }
      private function ShowSasukeVfx(skill:int):void {
         var host:DisplayObjectContainer=FBattleStage;if(host==null || host.stage==null)return;
         var origin:Point=host.globalToLocal(localToGlobal(new Point()));var center:Point=new Point();var count:int=0;var seen:Object={};
         if(FTargets!=null && FResults!=null)for(var i:int=0;i<FTargets.length && i<FResults.length;i++){var enemy:TRole=FTargets[i];if(enemy==null || enemy==this || enemy.Camp==Camp || FResults[i].CMD!=TTargetInfo.CMD_ATTACK)continue;var key:String=enemy.Camp+"_"+enemy.Pos;if(seen[key])continue;seen[key]=true;var pt:Point=host.globalToLocal(enemy.localToGlobal(new Point()));center.x+=pt.x;center.y+=pt.y;count++;}
         if(count){center.x/=count;center.y/=count;}else center=origin.clone();
         if(skill==13121307 || skill==13121308){ShowSasukeGenjutsu(host,center,skill==13121308);return;}
         var tl:Point=host.globalToLocal(stage.localToGlobal(new Point()));var br:Point=host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));var unit:Number=Math.abs(br.x-tl.x)/1250;
         var data:Object=SasukeVfxManifest();var effects:Array=data.actions[String(data.moves[skill])] as Array;
         if(skill<=13121302){SasukeBackdrop(host);ShowSasukeScreenFlash(host,skill);}
         if(effects!=null)for each(var effect:String in effects){
            var cutin:Boolean=effect.indexOf("texie")>=0;
            if(cutin){PlaySasukeCinematic(effect,host);continue;}
            var at:Point=cutin?new Point((tl.x+br.x)/2,(tl.y+br.y)/2):(skill==13121309?origin.clone():center.clone());
            PlaySasukeEffect(effect,host,at,cutin?1220:skill==13121309?340:skill<=13121302?1000:880,unit,0,cutin);
         }
      }
      private function PlaySasukeEffect(effect:String,host:DisplayObjectContainer,at:Point,limit:Number,unit:Number,delay:int,cutin:Boolean=false):void {
         var data:Object=SasukeVfxManifest();var layers:Array=data.effects[effect] as Array;if(layers==null)return;
         var left:Number=0;var right:Number=0;var top:Number=0;var bottom:Number=0;
         for each(var key:String in layers){var c:Object=data.clips[key];var w:Number=c.width/c.renderScale;var h:Number=c.height/c.renderScale;left=Math.min(left,-Number(c.pivot[0])*w);right=Math.max(right,(1-Number(c.pivot[0]))*w);top=Math.min(top,-Number(c.pivot[1])*h);bottom=Math.max(bottom,(1-Number(c.pivot[1]))*h);}
         var tl:Point=host.globalToLocal(stage.localToGlobal(new Point()));var br:Point=host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         var width:Number=Math.max(1,right-left);var height:Number=Math.max(1,bottom-top);
         var fit:Number=Math.min(limit*unit/Math.max(width,height),(br.x-tl.x-24*unit)/width,(br.y-tl.y-24*unit)/height);
         if(!cutin){
            var lightning:Boolean=effect.indexOf("qilin")>=0;
            var dragon:Boolean=effect.indexOf("haolonghuo")>=0;
            var sword:Boolean=effect.indexOf("qianniaodao")>=0;
            var gain:Number=lightning?1.55:dragon?1.7:sword?1.35:1.25;
            fit*=gain;
            // Bright central action remains prominent; only distant particles
            // may reach the viewport edge. Cap size without the old shrink-to-fit.
            fit=Math.min(fit,(br.x-tl.x)*1.15/width,(br.y-tl.y)*1.55/height);
         }
         if(cutin){
            fit=Math.max((br.x-tl.x)/width,(br.y-tl.y)/height);
            var camera:Point=new Point((tl.x+br.x)/2-(left+right)/2*fit*(scaleX<0?-1:1),(tl.y+br.y)/2-(top+bottom)/2*fit);
            for each(var cameraKey:String in layers){var cameraClip:Object=data.clips[cameraKey];PlaySasukeVfxAsset(cameraKey,host,camera,cameraClip.width/cameraClip.renderScale*fit,cameraClip.height/cameraClip.renderScale*fit,delay,scaleX<0,false,false);}
            return;
         }
         // Source hit anchors keep the visible strike on the victim. Smoke and
         // distant sparks must neither shrink nor recenter the main artwork.
         var profile:Object=data.presentation[effect];
         if(profile!=null){
            fit=Number(profile.displayWidth)*unit/Number(profile.coreWidth);
            // Avoid magnifying a raster layer beyond 1.55 screen pixels per
            // source pixel at the game's native 1250-wide presentation.
            if(profile.sharpScale!=null)fit=Math.min(fit,Number(profile.sharpScale)*1.4*unit);
            else for each(var sharpKey:String in layers){var sharp:Object=data.clips[sharpKey];fit=Math.min(fit,Number(sharp.renderScale)*1.55*unit);}
            var impact:Point=at.clone();var facing:Number=scaleX<0?-1:1;
            impact.x-=Number(profile.anchorX)*fit*facing;
            impact.y-=Number(profile.heightAboveGround)*unit+Number(profile.anchorY)*fit;
            for each(var placedKey:String in layers){var placed:Object=data.clips[placedKey];PlaySasukeVfxAsset(placedKey,host,impact,placed.width/placed.renderScale*fit,placed.height/placed.renderScale*fit,delay,scaleX<0,false,false);}
            return;
         }
         // Center visible source bounds on the enemy field; arbitrary SWF origins
         // must not displace the rendered dragon or slash beyond the battlefield.
         at=at.clone();var mirror:Boolean=scaleX<0;
         var cx:Number=(left+right)/2;var cy:Number=(top+bottom)/2;
         var desiredY:Number=at.y-Math.min(height*fit*.28,150*unit);
         at.x-=cx*fit*(mirror?-1:1);at.y=desiredY-cy*fit;
         var low:Number=mirror?-right:left;var high:Number=mirror?-left:right;
         if(width*fit<br.x-tl.x-24*unit)at.x=Math.max(tl.x+12*unit-low*fit,Math.min(br.x-12*unit-high*fit,at.x));
         else at.x=(tl.x+br.x)/2-cx*fit*(mirror?-1:1);
         if(height*fit<br.y-tl.y-24*unit)at.y=Math.max(tl.y+12*unit-top*fit,Math.min(br.y-12*unit-bottom*fit,at.y));
         else at.y=(tl.y+br.y)/2-cy*fit;
         for each(key in layers){c=data.clips[key];PlaySasukeVfxAsset(key,host,at,c.width/c.renderScale*fit,c.height/c.renderScale*fit,delay,mirror,false,false);}
      }
      private function ShowSasukeScreenFlash(host:DisplayObjectContainer,skill:int):void {
         var data:Object=SasukeVfxManifest();var frames:Array=data.screenFlashes[skill==13121301?"ZuozhuZZZZ_qilin":"ZuozhuZZZZ_qilin_yan"] as Array;
         if(frames==null)return;
         var tl:Point=host.globalToLocal(stage.localToGlobal(new Point()));var br:Point=host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         var layer:Sprite=new Sprite();layer.name="sasukeSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         layer.graphics.beginFill(0xFFFFFF);layer.graphics.drawRect(tl.x,tl.y,br.x-tl.x,br.y-tl.y);layer.graphics.endFill();layer.alpha=0;host.addChild(layer);FSasukeActiveVfx.push(layer);
         var caster:TRole=this;var serial:uint=FCombatVfxSerial;var castSkill:int=FSkillId;var started:int=Math.max(0,FFrameIndex);var tick:Function;var cleanup:Function;
         cleanup=function(event:Event=null):void{layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);if(layer.parent!=null)layer.parent.removeChild(layer);};
         tick=function(event:Event):void{var age:int=Math.max(0,caster.FFrameIndex)-started;if(layer.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=castSkill || age>=frames.length){cleanup();return;}layer.alpha=Number(frames[Math.max(0,age)]);};
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);
      }
      private function ShowSasukeGenjutsu(host:DisplayObjectContainer,at:Point,rinnegan:Boolean):void {
         var layer:Sprite=new Sprite();layer.name="sasukeSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         var color:uint=rinnegan?0xA477FF:0xE53448;
         layer.graphics.beginFill(0x160B2D,.5);layer.graphics.drawCircle(0,0,100);layer.graphics.endFill();
         for(var ring:int=0;ring<5;ring++){layer.graphics.lineStyle(2,color,.85);layer.graphics.drawCircle(0,0,18+ring*17);}
         layer.graphics.beginFill(color,.95);layer.graphics.drawCircle(0,0,12);layer.graphics.endFill();
         if(!rinnegan)for(var n:int=0;n<3;n++){var angle:Number=n*Math.PI*2/3;var x:Number=Math.cos(angle)*48;var y:Number=Math.sin(angle)*48;layer.graphics.beginFill(0x100B20,1);layer.graphics.drawCircle(x,y,13);layer.graphics.endFill();}
         layer.filters=[new GlowFilter(color,.9,18,18,2,1)];layer.x=at.x;layer.y=at.y-85;host.addChild(layer);FSasukeActiveVfx.push(layer);
         var caster:TRole=this;var serial:uint=FCombatVfxSerial;var started:int=FFrameIndex;var tick:Function;
         tick=function(event:Event):void{var age:int=Math.max(0,caster.FFrameIndex-started);if(layer.stage==null || caster.FCombatVfxSerial!=serial || age>44){layer.removeEventListener(Event.ENTER_FRAME,tick);if(layer.parent!=null)layer.parent.removeChild(layer);return;}layer.rotation=age*(rinnegan?-5:7);var size:Number=.35+Math.min(1,age/10)*1.2;layer.scaleX=layer.scaleY=size;layer.alpha=Math.min(1,age/5)*Math.min(1,(44-age)/12);};
         layer.addEventListener(Event.ENTER_FRAME,tick);
      }
'''.replace('__MANIFEST__',json.dumps(json.dumps(manifest,separators=(',',':'))))
 runtime+='\n'+(BASE/'cinematic.as.txt').read_text(encoding='utf8')
 role=role.replace('      override public function UpdateActive()',runtime+'\n      override public function UpdateActive()',1)
 role=role.replace('         ++FCombatVfxSerial;','         ++FCombatVfxSerial;\n         if(FId==11120970)FSasukeVfxStarted=false;',1)
 role=role.replace('         this.UpdateItachiVfx();','         this.UpdateItachiVfx();\n         this.UpdateSasukeVfx();',1)
 role=role.replace('            this.FitItachiPose();','            this.FitItachiPose();\n            this.FitSasukePose();',1)
 role=h.inject(role,'PrepareDormantKabuto','         if(FId==11120970)PreloadSasukeVfx();')
 role=h.inject(role,'AddTextEffectByCMD','''         var sasukeMarker:uint=uint(param1.ResultInfo.BuffId);
         if(param1.CMD==TTargetInfo.CMD_FLOAT && sasukeMarker>19001400 && sasukeMarker<19001410){var notices:Array=["","AMATERASU BLAZE","ELECTROCUTION","STATIC","DISORDER","EXTREME FEAR","LEVEL 2 IGNITION","VISUAL JUTSU"];ShowHashiramaStatusText(String(notices[sasukeMarker-19001400]),0xB488FF);return;}''')
 active=(BASE/'original/scripts'/ACTIVE).read_text(encoding='utf8')
 active=h.inject(active,'IsSkill','         if(this.FId==11120970 && param1>=13121301 && param1<=13121309)return param1!=13121303 && param1!=13121304;')
 active=h.inject(active,'PlaySkill','         if(this.FId==11120970 && (this.FSkillId==13121303 || this.FSkillId==13121304)){this.FCallBackDict[TYPE_ACTIVE_ATTACK]=this.FCallBackDict[TYPE_ACTIVE_SKILL];this.FTimeDict[TYPE_ACTIVE_ATTACK]=this.FTimeDict[TYPE_ACTIVE_SKILL];this.PlayAttack();return;}')
 token='         this.FCurSequence = this.FTextureAttack.GetAnimationSequenceByIndex(_loc1_);';active=active.replace(token,'         if(this.FId==11120970)_loc1_=uint(this.FSkillId==13121304?1:0);\n'+token,1)
 token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);';active=active.replace(token,'         if(this.FId==11120970 && this.FSkillId>=13121301 && this.FSkillId<=13121309)_loc1_=uint(this.FSkillId<=13121302?this.FSkillId-13121301:this.FSkillId-13121303);\n'+token,1)
 formation=(BASE/'original/scripts'/FORMATION).read_text(encoding='utf8').replace('this.FSelectHero.Identifier == 11120960','(this.FSelectHero.Identifier == 11120960 || this.FSelectHero.Identifier == 11120970)').replace('this.FSelectHero.Identifier != 11120960','(this.FSelectHero.Identifier != 11120960 && this.FSelectHero.Identifier != 11120970)')
 stage=(BASE/'original/scripts'/STAGE).read_text(encoding='utf8').replace('kabutoRasterHost.getChildAt(kabutoRasterIndex).name == "itachiSkillVfx"','(kabutoRasterHost.getChildAt(kabutoRasterIndex).name == "itachiSkillVfx" || kabutoRasterHost.getChildAt(kabutoRasterIndex).name == "sasukeSkillVfx")')
 for rel,code in [(ROLE,role),(ACTIVE,active),(FORMATION,formation),(STAGE,stage)]:
  dest=BASE/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(code,encoding='utf8')
 output=BASE/'compiled.swf';h.ff('-onerror','abort','-importScript',source,output,BASE/'patched');rebuilt=output.read_bytes()
 assert [t for t in h.h.tags(raw) if t[0]!=82]==[t for t in h.h.tags(rebuilt) if t[0]!=82]
 h.ff('-selectclass',classes,'-export','script',BASE/'verify',output)
 after=(BASE/'verify/scripts'/ROLE).read_text(encoding='utf8')
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name not in {'PrepareDormantKabuto','ActivePlay','UpdateActive','UpdateAnimationFrame','AddTextEffectByCMD'}:assert h.m.extract(before,name)==h.m.extract(after,name),name
 backup=BASE/'backups/TApplication.swf';backup.parent.mkdir(exist_ok=True)
 if not backup.exists():backup.write_bytes(old)
 canonical.write_bytes(h.h.swap(rebuilt));print('PASS isolated Sasuke native dispatch, VFX streaming, all formation positions and float damage layer')
if __name__=='__main__':main()
