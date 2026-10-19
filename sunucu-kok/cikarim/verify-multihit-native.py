"""Run the actual installed AS3 partition helper in native Flash 22."""
from pathlib import Path
import argparse,json,subprocess
BASE=Path(__file__).resolve().parent

def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);a=p.parse_args()
 work=BASE/'hashirama-final/multihit-build';cases=[]
 heroes=json.loads((BASE/'veri-json/BaseHero.json').read_text(encoding='utf-8'))
 for hero in heroes:
  if int(hero['id'],16) not in [11120930,11120940]:continue
  for skill,effect in json.loads(hero['attackEffect']).items():
   if 'appendEffect' not in effect:continue
   for camp in [0,1]:cases.append({'skill':skill,'camp':camp,'effects':list(effect['appendEffect'].values())})
 source='''package {
 import flash.display.MovieClip;
 import flash.events.Event;
 import flash.external.ExternalInterface;
 import flash.text.TextField;
 import Processors.Game.Battle.Effect.TEffectControl;
 public class TApplication extends MovieClip {
  public function TApplication(){addEventListener(Event.ADDED_TO_STAGE,run);}
  private function report(s:String):void{if(ExternalInterface.available)ExternalInterface.call("probe",s);}
  private function run(e:Event):void{
   removeEventListener(Event.ADDED_TO_STAGE,run);
   try{
    var cases:Array=__CASES__;
    var totals:Array=[0,1,3,4,5,101,95079,2147483647,-101];
    var tested:int=0;
    for each(var c:Object in cases)for each(var total:Number in totals){
     var sum:Number=0;var hp:Number=3000000000;var initial:Number=hp;
     for(var i:int=0;i<c.effects.length;i++){
      var value:Number=TEffectControl.ConsecutiveHitDamage(total,c.effects[i],0);
      if(value!=Math.floor(value))throw new Error("fractional hit");
      sum+=value;hp-=value;
     }
     if(sum!=total||initial-hp!=total)throw new Error("HP mismatch "+c.skill+" total="+total+" sum="+sum);
     tested++;
    }
    var legacy:Object={anmyhp:{"0":35}};
    if(TEffectControl.ConsecutiveHitDamage(100,legacy,0)!=35)throw new Error("legacy changed");
    var text:TextField=new TextField();text.width=1000;text.text="PASS native Flash: "+tested+" exact damage partitions across both camps";addChild(text);
    report("PASS "+tested);
   }catch(error:Error){report("ERROR "+error.toString()+" "+error.getStackTrace());}
  }
 }
}'''.replace('__CASES__',json.dumps(cases))
 dest=work/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source)
 subprocess.run(['java','-Xmx2g','-jar',a.ffdec,'-onerror','abort','-importScript',str(work/'compiled.swf'),str(work/'probe.swf'),str(dest.parent)],check=True)
 binary=bytearray((work/'probe.swf').read_bytes());binary[3]=21;(work/'probe.swf').write_bytes(binary)
 print('PASS native numeric probe compiled: 30 skill/camp cases')

if __name__=='__main__':main()
