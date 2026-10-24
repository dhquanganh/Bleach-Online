"""Run the client's actual allied-health dispatch block against installed heal metadata."""
from pathlib import Path
import importlib.util,json
B=Path(__file__).resolve().parent
sp=importlib.util.spec_from_file_location('client',B/'build-client.py');c=importlib.util.module_from_spec(sp);sp.loader.exec_module(c)
role=(B/'katsuyu/client/verify/scripts'/c.b.ROLE).read_text(encoding='utf-8')
voice=role.index('            if(_loc1_.voice != null)',role.index('         _loc1_ = FAttackEffect[FSkillId];'))
start=role.index('            if(FTargets != null)',voice)
end=c.b.method_end(role,start)
dispatch=role[start:end].replace(':TRole',':ProbeRole').replace('Vector.<TTargetInfo>','Vector.<Object>')
# Include the production one-shot friendhp event consumption after the target loop.
start=role.index('            if(Boolean(_loc1_.friendhp)',end);end=c.b.method_end(role,start)
dispatch+='\n'+role[start:end]
rows=json.loads((B.parent/'veri-json/BaseHero.json').read_text(encoding='utf-8'))
cases=[]
for h in rows:
 if int(h['id'],16) not in [11120992,11120993]:continue
 for skill,node in json.loads(h['attackEffect']).items():
  if 'friendhp' in node:cases.append({'skill':skill,'node':node,'frame':int(next(iter(node['friendhp'])))})
assert len(cases)==6
source='''package {
 import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;
 import Resources.Constants.*;import Processors.Game.Battle.TBattleStage;import Processors.Game.Battle.Effect.TEffectControl;import Processors.Game.Battle.Character.TActive;
 public class TApplication extends MovieClip {
  public function TApplication(){if(stage)run();else addEventListener(Event.ADDED_TO_STAGE,run);}
  private function check(ok:Boolean,label:String):void{if(!ok)throw new Error(label);}
  private function report(text:String):void{if(ExternalInterface.available)ExternalInterface.call("vfxProbe",text);}
  private function run(e:Event=null):void {
   try{
    var cases:Array=__CASES__;var checks:int=0;
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
__DISPATCH__
  }
 }
}'''.replace('__CASES__',json.dumps(cases,separators=(',',':'))).replace('__DISPATCH__',dispatch)
W=B/'healing-visibility/probe';dest=W/'probe-source/TApplication.as';dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(source)
c.ff('-onerror','abort','-importScript',B/'source.swf',W/'raster-probe.swf',dest.parent)
raw=bytearray((W/'raster-probe.swf').read_bytes());raw[3]=21;(W/'raster-probe.swf').write_bytes(raw)
runner=(B/'runtime-raster.js').read_text().replace("path.resolve(base,'../../..')","path.resolve(base,'../../../../..')").replace('7474','7480').replace('7475','7481')
(W/'runtime-raster.js').write_text(runner);(W/'validation/native').mkdir(parents=True,exist_ok=True)
print('PASS native heal dispatcher probe compiled with six installed support mappings')
