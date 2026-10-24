package {
 import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;
 import Resources.Constants.*;import Processors.Game.Battle.TBattleStage;import Processors.Game.Battle.Effect.TEffectControl;import Processors.Game.Battle.Character.TActive;
 public class TApplication extends MovieClip {
  public function TApplication(){if(stage)run();else addEventListener(Event.ADDED_TO_STAGE,run);}
  private function check(ok:Boolean,label:String):void{if(!ok)throw new Error(label);}
  private function report(text:String):void{if(ExternalInterface.available)ExternalInterface.call("vfxProbe",text);}
  private function run(e:Event=null):void {
   try{
    var cases:Array=[{"skill":"13121602","node":{"target":1,"backPoint":{"45":1},"friendhp":{"16":100}},"frame":16},{"skill":"13121603","node":{"target":1,"backPoint":{"138":1},"friendhp":{"84":100}},"frame":84},{"skill":"13121604","node":{"target":1,"backPoint":{"49":1},"friendhp":{"17":100}},"frame":17},{"skill":"13121605","node":{"target":1,"backPoint":{"104":1},"friendhp":{"48":100}},"frame":48},{"skill":"13121606","node":{"target":1,"backPoint":{"138":1},"friendhp":{"84":100}},"frame":84},{"skill":"13121609","node":{"target":1,"backPoint":{"32":1},"friendhp":{"10":100}},"frame":10}];var checks:int=0;
    for(var camp:int=0;camp<2;camp++)for each(var test:Object in cases){
     var source:ProbeRole=new ProbeRole();source.Camp=camp;source.hp=100;
     var ally:ProbeRole=new ProbeRole();ally.Camp=camp;ally.hp=100;
     var enemy:ProbeRole=new ProbeRole();enemy.Camp=1-camp;enemy.hp=100;
     var records:Array=[{TargetStatus:2,HealthGaining:0,ResultInfo:{HurtHp:-150}},{TargetStatus:2,HealthGaining:0,ResultInfo:{HurtHp:-300}},{TargetStatus:2,HealthGaining:0,ResultInfo:{HurtHp:-999}}];
     source.FTargets=[source,ally,enemy];source.FResults=records;
     var baseline:Object=JSON.parse(JSON.stringify(test.node));delete baseline.friendhp;
     source.apply(baseline,test.frame);check(ally.hp==100,"baseline reproduces missing ally heal");checks++;
     var node:Object=JSON.parse(JSON.stringify(test.node));source.apply(node,test.frame-1);check(ally.hp==100,"heal timing");checks++;
     source.apply(node,test.frame);check(ally.hp==400,"ally receives HP: "+test.skill);check(source.hp==250,"self receives HP");check(enemy.hp==100,"no enemy heal");checks+=3;
     source.apply(node,test.frame);check(ally.hp==400&&source.hp==250,"no double heal");check(records[1].HealthGaining==100,"client HealthGaining consumed");checks+=2;
     report("CASE heal "+test.skill+" camp="+camp+" allyHP="+ally.hp);
    }
    report("DONE native allied HP dispatch; checks="+checks+" remaining=0");
   }catch(error:Error){report("ERROR "+error+" "+error.getStackTrace());}
  }
 }
 internal class ProbeRole extends Sprite {
  public var Camp:int=0;public var Pos:int=1;public var hp:Number=100;public var RoleHeight:Number=100;
  public var FTargets:Array;public var FResults:Array;public var FTextFunction:Function=null;
  public var FBattleStage:Object={IsCrit:false,CriticalUI:function():void{}};
  public function ChangeHP(amount:Number):void{hp-=amount;}
  public function CheckTextEffect(info:Object):void{}
  public function AddTextEffect(info:Object):void{}
  public function CheckDie():void{}
  public function ActivePlay(...args):void{}
  public function apply(_loc1_:Object,FFrameIndex:int):void{
   var _loc3_:int=0;var _loc6_:ProbeRole;var _loc7_:Number=0;var _loc8_:Boolean=false;
            if(FTargets != null)
            {
               _loc3_ = 0;
               while(_loc3_ < FTargets.length)
               {
                  _loc6_ = FTargets[_loc3_];
                  _loc8_ = (FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Crit) != 0;
                  _loc6_.CheckTextEffect(FResults[_loc3_]);
                  if(_loc6_.Camp == Camp)
                  {
                     if(Boolean(_loc1_.friendhp) && _loc1_.friendhp[FFrameIndex] != null && FResults[_loc3_].HealthGaining < 100)
                     {
                        _loc7_ = FResults[_loc3_].ResultInfo.HurtHp * _loc1_.friendhp[FFrameIndex] / 100;
                        _loc6_.ChangeHP(_loc7_);
                        if(_loc7_ != 0)
                        {
                           FResults[_loc3_].HealthGaining += _loc1_.friendhp[FFrameIndex];
                        }
                        if(this.FTextFunction != null)
                        {
                           this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc6_.Camp == 0 ? -1 : 1,_loc6_.x,_loc6_.y - _loc6_.RoleHeight,"+" + int(Math.abs(_loc7_)),_loc8_);
                        }
                     }
                  }
                  else if(Boolean(_loc1_.anmyhp) && _loc1_.anmyhp[FFrameIndex] != null)
                  {
                     _loc7_ = FResults[_loc3_].ResultInfo.HurtHp * _loc1_.anmyhp[FFrameIndex] / 100;
                     if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Hit)
                     {
                        if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Help)
                        {
                           FResults[_loc3_].TargetStatus -= CONST_BATTLE.ActiveType_Help;
                           _loc6_.AddTextEffect(CONST_BATTLE.ActiveType_Help);
                        }
                        if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_ImmCtrl)
                        {
                           FResults[_loc3_].TargetStatus -= CONST_BATTLE.ActiveType_ImmCtrl;
                           _loc6_.AddTextEffect(CONST_BATTLE.ActiveType_ImmCtrl);
                        }
                        if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_ImmCalm)
                        {
                           FResults[_loc3_].TargetStatus -= CONST_BATTLE.ActiveType_ImmCalm;
                           _loc6_.AddTextEffect(CONST_BATTLE.ActiveType_ImmCalm);
                        }
                        if(_loc7_ != 0)
                        {
                           _loc6_.ChangeHP(_loc7_);
                           _loc6_.ActivePlay(TActive.TYPE_ACTIVE_ATTACKED,0,null,Vector.<Object>([FResults[_loc3_]]));
                           if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Block)
                           {
                              TEffectControl.ShowPublicEffect(_loc6_,CONST_BATTLE.Public_Effect_Smoke,0,0);
                           }
                           if(this.FTextFunction != null)
                           {
                              this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc6_.Camp == 0 ? -1 : 1,_loc6_.x,_loc6_.y - _loc6_.RoleHeight,String(int(_loc7_)),_loc8_,FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Block ? CONST_BATTLE.TEXT_FIGHT_STATUS_Block : 0);
                           }
                        }
                        if(Boolean(_loc1_.anmyhp.checkDie) && !(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Block))
                        {
                           _loc6_.CheckDie();
                        }
                     }
                     else if(Boolean(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_ImmCtrl) || Boolean(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_ImmCalm))
                     {
                        if(this.FTextFunction != null)
                        {
                           this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc6_.Camp == 0 ? -1 : 1,_loc6_.x,_loc6_.y - _loc6_.RoleHeight,0,false,CONST_BATTLE.TEXT_FIGHT_STATUS_Lost);
                        }
                     }
                     else if(!(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Punch))
                     {
                        _loc6_.ActivePlay(TActive.TYPE_ACTIVE_DODGE,0,null,null,null,0,FResults[_loc3_].CMD == 0);
                     }
                     if(this.FBattleStage.IsCrit)
                     {
                        this.FBattleStage.IsCrit = false;
                        this.FBattleStage.CriticalUI();
                     }
                  }
                  _loc3_++;
               }
            }
            if(Boolean(_loc1_.friendhp) && _loc1_.friendhp[FFrameIndex] != null)
            {
               _loc1_.friendhp[FFrameIndex] = null;
            }
  }
 }
}