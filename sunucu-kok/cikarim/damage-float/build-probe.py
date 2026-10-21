"""Native Flash partition math plus production foreground-layer event ordering."""
from pathlib import Path
import importlib.util,json
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('build',B/'build.py');b=importlib.util.module_from_spec(s);s.loader.exec_module(b)

def main():
 heroes=json.loads((B.parent/'veri-json/BaseHero.json').read_text(encoding='utf-8'));cases=[]
 for hero in heroes:
  if int(hero['id'],16) not in [11120930,11120940,11120950,11120960]:continue
  for skill,effect in json.loads(hero['attackEffect']).items():
   if 'appendEffect' in effect:
    for camp in [0,1]:cases.append({'skill':skill,'camp':camp,'effects':list(effect['appendEffect'].values())})
 stage=(B/'verify/scripts'/b.STAGE).read_text(encoding='utf-8')
 helpers='\n'.join(b.client.m.extract(stage,name) for name in ['DamageFloatHost','KeepDamageFloatsOnTop','ResetDamageFloats'])
 source=r'''package {
 import flash.display.*;
 import flash.events.*;
 import flash.external.ExternalInterface;
 import flash.text.*;
 import Processors.Game.Battle.Effect.TEffectControl;
 public class TApplication extends MovieClip {
  private var owner:ProbeStage;
  private var numeric:int=0;
  private var overlays:int=0;
  private var step:int=0;
  private var resetDone:Boolean=false;
  private var names:Array=["kabutoSkillVfx","obitoSkillVfx","painSkillVfx","hashiramaSkillVfx","mechaSkillVfx","itachiSkillVfx","nativeWhiteFlash","nativeColorFlash"];
  public function TApplication(){addEventListener(Event.ADDED_TO_STAGE,run);}
  private function report(s:String):void{if(ExternalInterface.available)ExternalInterface.call("probe",s);}
  private function run(e:Event):void{
   removeEventListener(Event.ADDED_TO_STAGE,run);
   try{
    stage.frameRate=25;
    var cases:Array=__CASES__;
    for each(var c:Object in cases)for each(var total:Number in [0,1,3,4,5,101,95079,2147483647,-101]){
     var sum:Number=0;
     for(var i:int=0;i<c.effects.length;i++){
      var value:Number=TEffectControl.ConsecutiveHitDamage(total,c.effects[i],0);
      if(value!=Math.floor(value))throw new Error("fractional hit "+c.skill);
      sum+=value;
     }
     if(sum!=total)throw new Error("HP/text mismatch "+c.skill+" total="+total+" sum="+sum);
     numeric++;
    }
    for(var n:int=1;n<=64;n++){
     sum=0;for(i=0;i<n;i++)sum+=TEffectControl.ConsecutiveHitDamage(101,{hitCount:n,hitIndex:i,anmyhp:{"0":100/n}},0);
     if(sum!=101)throw new Error("generic count "+n);numeric++;
    }
    var legacy:Object={anmyhp:{"0":35}};
    if(TEffectControl.ConsecutiveHitDamage(100,legacy,0)!=35)throw new Error("legacy changed");
    var invalid:Object={hitCount:0,hitIndex:0,anmyhp:{"0":35}};
    if(TEffectControl.ConsecutiveHitDamage(100,invalid,0)!=35)throw new Error("invalid metadata fallback changed");
    owner=new ProbeStage();owner.x=35;owner.scaleX=.94;owner.scaleY=.94;addChild(owner);
    owner.graphics.beginFill(0x243646);owner.graphics.drawRect(0,0,1250,650);owner.graphics.endFill();
    addFloats();
    owner.addEventListener(Event.ENTER_FRAME,appendEffect,false,-100);
    owner.addEventListener(Event.RENDER,checkPaint,false,-100);
   }catch(error:Error){report("ERROR "+error.toString());}
  }
  private function addFloats():void{
   var layer:Sprite=owner.textHost();
   for(var camp:int=0;camp<2;camp++){
    var marker:Sprite=new Sprite();marker.graphics.beginFill(0xFFAA00);marker.graphics.drawRect(0,0,240,75);marker.graphics.endFill();marker.x=200+camp*500;marker.y=200;layer.addChild(marker);
    var text:TextField=new TextField();text.defaultTextFormat=new TextFormat("Arial",40,0xFFFFFF,true);text.text=camp==0?"-12,345":"-67,890";text.width=240;text.height=60;text.x=200+camp*500;text.y=210;layer.addChild(text);
   }
  }
  private function appendEffect(event:Event):void{
   if(step>=names.length)return;
   var fx:Sprite=new Sprite();fx.name=names[step];fx.graphics.beginFill(0x342064+step*0x080301);fx.graphics.drawRect(0,0,1250,650);fx.graphics.endFill();owner.addChild(fx);
   step++;stage.invalidate();
  }
  private function checkPaint(event:Event):void{
   try{
    if(step==0)return;
    var layer:Sprite=owner.getChildByName("battleDamageFloatLayer") as Sprite;
    if(owner.getChildIndex(layer)!=owner.numChildren-1)throw new Error("text behind "+names[step-1]);
    if(layer.mouseEnabled||layer.mouseChildren)throw new Error("damage layer blocks input");
    var picture:BitmapData=new BitmapData(1250,650,false,0);picture.draw(owner);
    if(picture.getPixel(205,205)!=0xFFAA00||picture.getPixel(705,205)!=0xFFAA00)throw new Error("damage covered in camp "+step);
    picture.dispose();overlays++;
    if(step==names.length){
     if(!resetDone){owner.clearFloats();if(owner.getChildByName("battleDamageFloatLayer")!=null)throw new Error("reset retained text");resetDone=true;step=0;addFloats();return;}
     owner.removeEventListener(Event.ENTER_FRAME,appendEffect);owner.removeEventListener(Event.RENDER,checkPaint);
     var title:TextField=new TextField();title.defaultTextFormat=new TextFormat("Arial",25,0xFFFFFF,true);title.text="PASS: damage above every VFX, both camps";title.width=1100;title.y=30;addChild(title);
     report("PASS "+JSON.stringify({numericCases:numeric,foregroundCases:overlays,camps:2,resetChecked:true}));
    }
   }catch(error:Error){owner.removeEventListener(Event.RENDER,checkPaint);report("ERROR "+error.toString());}
  }
 }
 internal class ProbeStage extends Sprite {
  private var FDamageFloatLayer:Sprite;
  public function textHost():Sprite{return DamageFloatHost();}
  public function clearFloats():void{ResetDamageFloats();}
  __HELPERS__
 }
}'''.replace('__CASES__',json.dumps(cases)).replace('__HELPERS__',helpers)
 path=B/'probe-source/TApplication.as';path.parent.mkdir(exist_ok=True);path.write_text(source,encoding='utf-8')
 b.client.ff('-onerror','abort','-importScript',B/'compiled.swf',B/'probe.swf',path.parent)
 raw=bytearray((B/'probe.swf').read_bytes());raw[3]=21;(B/'probe.swf').write_bytes(raw)
 print('PASS native partition/foreground probe compiled;',len(cases),'skill/camp combinations')
if __name__=='__main__':main()
