"""Source-space motion and hand-anchored effects, matched to the reference testplay."""
METHODS='''
      private function NagatoStrikeOffset():Point {
         if(FId!=11120990 || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL) || FTargets==null || FResults==null)return new Point();
         var timing:Object=NagatoVfxManifest().poseTiming[String(FSkillId)];
         if(timing==null)return new Point();
         var t:Number=Math.min(1,Math.max(0,FFrameIndex/10));
         var back:Number=Math.min(1,Math.max(0,(Number(timing.end)-FFrameIndex)/10));
         var weight:Number=t*t*(3-2*t)*back*back*(3-2*back);
         for(var i:int=0;i<FTargets.length && i<FResults.length;i++){
            var enemy:TRole=FTargets[i];
            if(enemy==null || enemy==this || enemy.Camp==Camp || FResults[i].CMD!=TTargetInfo.CMD_ATTACK)continue;
            var target:Point=globalToLocal(enemy.localToGlobal(new Point()));
            return new Point(Math.max(0,target.x-Number(timing.distance))*weight,target.y*weight);
         }
         return new Point();
      }
      private function NagatoStrikePose(frame:TAnimationFrame):void {
         if(FId!=11120990 || frame==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         var offset:Point=NagatoStrikeOffset();
         FBitmap.x=-frame.Pivot.X+offset.x;FBitmap.y=-frame.Pivot.Y+offset.y;
      }
      private function ShowNagatoVfx(skill:int):void {
         var host:DisplayObjectContainer=FBattleStage;if(host==null || host.stage==null)return;
         var offset:Point=NagatoStrikeOffset();
         var origin:Point=host.globalToLocal(localToGlobal(new Point(offset.x+70,offset.y)));
         var zero:Point=host.globalToLocal(localToGlobal(new Point()));
         var one:Point=host.globalToLocal(localToGlobal(new Point(1,0)));
         var scale:Number=Point.distance(zero,one);
         var data:Object=NagatoVfxManifest();var clip:String=String(data.moves[skill]);var effects:Array=data.actions[clip] as Array;
         if(skill==13121401)NagatoBackdrop(host);
         if(effects!=null)for each(var effect:String in effects)PlayNagatoEffect(effect,host,origin,skill==13121401?2475:650,scale,0);
      }
      private function PlayNagatoEffect(effect:String,host:DisplayObjectContainer,at:Point,limit:Number,unit:Number,delay:int):void {
         var data:Object=NagatoVfxManifest();var layers:Array=data.effects[effect] as Array;if(layers==null)return;
         var left:Number=0;var right:Number=0;var top:Number=0;var bottom:Number=0;
         for each(var key:String in layers){var c:Object=data.clips[key];var w:Number=c.width/c.renderScale;var h:Number=c.height/c.renderScale;left=Math.min(left,-Number(c.pivot[0])*w);right=Math.max(right,(1-Number(c.pivot[0]))*w);top=Math.min(top,-Number(c.pivot[1])*h);bottom=Math.max(bottom,(1-Number(c.pivot[1]))*h);}
         var width:Number=Math.max(1,right-left);var height:Number=Math.max(1,bottom-top);
         var fit:Number=Math.min(unit*(effect=="QWCMaoyi"?2.25:1),limit*unit/Math.max(width,height));
         for each(key in layers){c=data.clips[key];PlayNagatoVfxAsset(key,host,at,c.width/c.renderScale*fit,c.height/c.renderScale*fit,delay,scaleX<0,true,false);}
      }
'''
def refine(role,extract):
 for name in ['ShowNagatoVfx','PlayNagatoEffect']:
  role=role.replace(extract(role,name),extract(METHODS,name))
 if 'function NagatoStrikeOffset(' not in role:
  extra=extract(METHODS,'NagatoStrikeOffset')+'\n'+extract(METHODS,'NagatoStrikePose')
  marker='      override public function UpdateActive()';assert marker in role
  role=role.replace(marker,extra+'\n'+marker,1)
 if 'this.NagatoStrikePose(_loc4_);' not in role:
  marker='            this.FitNagatoPose();';assert marker in role
  role=role.replace(marker,'            this.NagatoStrikePose(_loc4_);\n'+marker,1)
 old='point = host.globalToLocal(caster.localToGlobal(new Point(0,0)));'
 player=extract(role,'PlayNagatoVfxAsset');assert old in player
 revised=player.replace(old,'var strikeOffset:Point=caster.NagatoStrikeOffset();\n               point = host.globalToLocal(caster.localToGlobal(new Point(strikeOffset.x+70,strikeOffset.y)));')
 role=role.replace(player,revised)
 return role
