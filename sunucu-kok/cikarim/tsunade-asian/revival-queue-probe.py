"""Native Flash registration test using real encoded revival/summon fixtures."""
from pathlib import Path
import importlib.util,json
B=Path(__file__).resolve().parent;W=B/'revival-queue'
s=importlib.util.spec_from_file_location('repair',B/'revival-queue.py');r=importlib.util.module_from_spec(s);s.loader.exec_module(r)
stage=(W/'original/scripts'/r.STAGE).read_text(encoding='utf-8')
role=r.patch_role((W/'original/scripts'/r.ROLE).read_text(encoding='utf-8'))
def registration(source):
 m=r.c.m.extract(source,'SetBattle');part=m[m.index('         _loc3_ = 0;'):m.index('         this.ZBufferSort();')]
 return part.replace('TPoolRole.GetRole','ProbePool.GetRole')
prepare=r.c.m.extract(role,'PrepareBattleRole')
prepare=prepare[prepare.index('         if(FId == 11120993)'):prepare.index('         if(FId == 11120992)')]
cases=json.loads((W/'cases.json').read_text())
source='''package {
 import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;
 public class TApplication extends MovieClip {
  public function TApplication(){if(stage)run();else addEventListener(Event.ADDED_TO_STAGE,run);}
  private function check(ok:Boolean,label:String):void{if(!ok)throw new Error(label);}
  private function report(s:String):void{ExternalInterface.call("vfxProbe",s);}
  private function run(event:Event=null):void{try{
   var cases:Array=__CASES__;var checked:int=0;
   for each(var test:Object in cases){
    var players:Array=[{RoleCount:0,RoleBattleInfos:[]},{RoleCount:0,RoleBattleInfos:[]}];
    for each(var info:Object in test.roles){players[info.camp].RoleBattleInfos.push({RoleId:info.roleId,CurHealth:info.curHealth,Pos:info.pos});players[info.camp].RoleCount++;}
    var baseline:ProbeStage=new ProbeStage();baseline.oldRegister(players[0],players[1]);
    var repaired:ProbeStage=new ProbeStage();repaired.register(players[0],players[1]);
    check(baseline.addressable(test.events)==test.oldQueued,"baseline exact truncation point");checked++;
    check(repaired.addressable(test.events)==test.fullQueued,"repaired queue reaches all rounds");checked++;
    var hidden:int=0;for each(var actor:ProbeRole in repaired.FPlayerRoleMgr)if(actor.FId==11120993){check(!actor.visible&&actor.FIsDie,"reserved actor hidden before spawn");hidden++;checked++;}
    check(hidden==3,"all three reserved actors exist");checked++;
    report("CASE camp="+test.camp+" old="+test.oldQueued+" complete="+test.fullQueued+" hidden="+hidden);
   }
   report("DONE native revival queue; checks="+checked+" remaining=0");
  }catch(e:Error){report("ERROR "+e+" "+e.getStackTrace());}}
 }
 internal class ProbeStage {
  public var FPlayerRole_0:Array=[];public var FPlayerRole_1:Array=[];public var FPlayerRoleMgr:Array=[];public var FBattleFiled:Object=null;
  public function SetEffectText():void{}public function NextCommand():void{}public function OnBuffMouseMove():void{}public function OnBuffMouseRollOut():void{}
  public function oldRegister(param1:Object,param2:Object):void{var _loc3_:uint;var _loc4_:ProbeRole;__OLD__}
  public function register(param1:Object,param2:Object):void{var _loc3_:uint;var _loc4_:ProbeRole;__NEW__}
  public function addressable(events:Array):int {
   for(var i:int=0;i<events.length;i++){
    var active:Object=events[i];if(this["FPlayerRole_"+active.activeCamp][active.activePos]==null)return i;
    for each(var target:Object in active.targets)if(this["FPlayerRole_"+target.targetCamp][target.targetPos]==null)return i;
   }return events.length;
  }
 }
 internal class ProbePool {public static function GetRole(field:Object,info:Object,owner:Object,text:Object):ProbeRole{return new ProbeRole(info);}}
 internal class ProbeRole extends Sprite {
  public var FId:int;public var Pos:int;public var CurHealth:Number;public var FSmallKatsuyuSpawned:Boolean=true;public var FIsDie:Boolean=false;
  public var FHpBar:Sprite=new Sprite();public var FShaderBmp:Sprite=new Sprite();public var FBuffSprite:Sprite=new Sprite();
  public var OnEffectEnd:Function;public var OnBuffMouseMove:Function;public var OnBuffMouseRollOut:Function;
  public function ProbeRole(info:Object){FId=info.RoleId;Pos=info.Pos;CurHealth=info.CurHealth;}
  public function ClearSmallKatsuyuPose():void{}
  public function PrepareBattleRole():void{__PREPARE__}
 }
}'''
for key,value in {'__CASES__':json.dumps(cases,separators=(',',':')),'__OLD__':registration(stage),'__NEW__':registration(r.patch_stage(stage)),'__PREPARE__':prepare}.items():source=source.replace(key,value)
dest=W/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source,encoding='utf-8')
r.c.ff('-onerror','abort','-importScript',W/'source.swf',W/'raster-probe.swf',dest.parent)
raw=bytearray((W/'raster-probe.swf').read_bytes());raw[3]=21;(W/'raster-probe.swf').write_bytes(raw)
js=(B/'katsuyu/runtime-raster.js').read_text().replace('7478','7484').replace('7479','7485')
(W/'runtime-raster.js').write_text(js);(W/'validation/native').mkdir(parents=True,exist_ok=True)
print('PASS native revival registration probe compiled')
