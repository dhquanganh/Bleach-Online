"""Gaara-only source-distance movement; support shields stay pinned to allies."""
METHODS='''
      private function GaaraStrikeOffset():Point {
         if(FId!=11120991 || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL) || FSkillId==13121502 || FTargets==null || FResults==null)return new Point();
         var data:Object=GaaraVfxManifest();var clip:Object=data.clips;
         var timing:Object=data.poseTiming[String(FSkillId)];if(timing==null)return new Point();
         var distance:Number=FSkillId==13121503?460:400;
         var t:Number=Math.min(1,Math.max(0,FFrameIndex/8));var back:Number=Math.min(1,Math.max(0,(Number(timing.end)-FFrameIndex)/12));
         var weight:Number=t*t*(3-2*t)*back*back*(3-2*back);
         for(var i:int=0;i<FTargets.length && i<FResults.length;i++){
            var enemy:TRole=FTargets[i];if(enemy==null || enemy==this || enemy.Camp==Camp || FResults[i].CMD!=TTargetInfo.CMD_ATTACK)continue;
            var pt:Point=globalToLocal(enemy.localToGlobal(new Point()));return new Point(Math.max(0,pt.x-distance)*weight,pt.y*weight);
         }return new Point();
      }
      private function GaaraStrikePose(frame:TAnimationFrame):void {
         if(FId!=11120991 || frame==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         var offset:Point=GaaraStrikeOffset();FBitmap.x=-frame.Pivot.X+offset.x;FBitmap.y=-frame.Pivot.Y+offset.y;
      }
      private function ShowGaaraVfx(skill:int):void {
         var host:DisplayObjectContainer=FBattleStage;if(host==null || host.stage==null)return;
         var offset:Point=GaaraStrikeOffset();var origin:Point=host.globalToLocal(localToGlobal(new Point(offset.x+70,offset.y)));
         var zero:Point=host.globalToLocal(localToGlobal(new Point()));var one:Point=host.globalToLocal(localToGlobal(new Point(1,0)));var unit:Number=Point.distance(zero,one);
         var data:Object=GaaraVfxManifest();var name:String=String(data.moves[skill]);var effects:Array=data.actions[name] as Array;
         if(skill==13121501)GaaraBackdrop(host);
         if(effects!=null)for each(var effect:String in effects)PlayGaaraEffect(effect,host,origin,skill==13121501?1600:1050,unit,0);
         if(skill==13121502 && FTargets!=null && FResults!=null)for(var i:int=0;i<FTargets.length && i<FResults.length;i++){
            if(FTargets[i]!=null && FResults[i].CMD==8){var at:Point=host.globalToLocal(FTargets[i].localToGlobal(new Point()));PlayGaaraEffect("GAR_shazhidun",host,at,300,unit,0);}
         }
      }
      private function PlayGaaraEffect(effect:String,host:DisplayObjectContainer,at:Point,limit:Number,unit:Number,delay:int):void {
         var data:Object=GaaraVfxManifest();var layers:Array=data.effects[effect] as Array;if(layers==null)return;
         var left:Number=0;var right:Number=0;var top:Number=0;var bottom:Number=0;
         for each(var key:String in layers){var c:Object=data.clips[key];var w:Number=(c.worldWidth!=null?Number(c.worldWidth):c.width/c.renderScale);var h:Number=(c.worldHeight!=null?Number(c.worldHeight):c.height/c.renderScale);left=Math.min(left,-Number(c.pivot[0])*w);right=Math.max(right,(1-Number(c.pivot[0]))*w);top=Math.min(top,-Number(c.pivot[1])*h);bottom=Math.max(bottom,(1-Number(c.pivot[1]))*h);}
         var fit:Number=Math.min(unit,limit*unit/Math.max(1,right-left,bottom-top));
         if(effect=="Yzwoailuo_aoyi")fit*=2;
         for each(key in layers){c=data.clips[key];PlayGaaraVfxAsset(key,host,at,(c.worldWidth!=null?Number(c.worldWidth):c.width/c.renderScale)*fit,(c.worldHeight!=null?Number(c.worldHeight):c.height/c.renderScale)*fit,delay,scaleX<0,effect!="GAR_shazhidun",false);}
      }
'''
def refine(role,extract):
 for name in ['ShowGaaraVfx','PlayGaaraEffect']:role=role.replace(extract(role,name),extract(METHODS,name))
 if 'function GaaraStrikeOffset(' not in role:
  marker='      override public function UpdateActive()';assert marker in role
  role=role.replace(marker,extract(METHODS,'GaaraStrikeOffset')+'\n'+extract(METHODS,'GaaraStrikePose')+'\n'+marker,1)
 if 'this.GaaraStrikePose(_loc4_);' not in role:
  marker='            this.FitGaaraPose();';assert marker in role;role=role.replace(marker,'            this.GaaraStrikePose(_loc4_);\n'+marker,1)
 player=extract(role,'PlayGaaraVfxAsset');old='point = host.globalToLocal(caster.localToGlobal(new Point(0,0)));';assert old in player
 role=role.replace(player,player.replace(old,'var gaaraOffset:Point=caster.GaaraStrikeOffset();\n               point = host.globalToLocal(caster.localToGlobal(new Point(gaaraOffset.x+70,gaaraOffset.y)));'))
 return role
