"""Exercise production profile tag methods in native Flash without an account."""
from pathlib import Path
import importlib.util
B = Path(__file__).resolve().parent
s = importlib.util.spec_from_file_location('tag_build', B/'build.py')
b = importlib.util.module_from_spec(s); s.loader.exec_module(b)
W = B/b.VERSION
source = (W/'patched'/b.PROFILE).read_text(encoding='utf-8')
methods = '\n'.join(b.c.m.extract(source, name) for name in ['InitCharacterTags', 'RenderCharacterTags', 'AddCharacterTag', 'CharacterTagOnOver', 'ClearProfileCharacterTags'])
methods = methods.replace('var hero:THero', 'var hero:Object')
probe = '''package {
 import flash.display.*;
 import flash.events.*;
 import flash.external.ExternalInterface;
 import flash.utils.*;
 public class TApplication extends Sprite {
  private var FCharacterTagRow:Sprite;
  private var FCharacterTagData:Object;
  private var FHint:Object = {Caption:""};
  private var FHintOnOver:Function;
  private var FHeros:Object;
  private var FTabHeroIndex:int = 0;
  private var captions:Array = [];
  private var heroes:Array = [{Identifier:11120930},{Identifier:11120940},{Identifier:11120970},{Identifier:11100001}];
  private var checked:int = 0;
  public function TApplication() {
   if(stage)run();else addEventListener(Event.ADDED_TO_STAGE,run);
  }
  private function check(ok:Boolean,label:String):void {if(!ok)throw new Error(label);checked++;}
  private function TFHintOnOut(event:Object):void {FHint.Caption="";}
  private function report(text:String):void {if(ExternalInterface.available)ExternalInterface.call("probe",text);}
  private function run(event:Event=null):void {
   try {
    var host:MovieClip = new MovieClip();addChild(host);
    var tab:Sprite = new Sprite();tab.graphics.beginFill(0x553322);tab.graphics.drawRect(0,0,68,22);tab.graphics.endFill();tab.x=172;tab.y=380;host["BtnPvP"]=tab;host.addChild(tab);
    FHintOnOver=function(owner:Object,hint:Object):void {captions.push(hint.Caption);};
    FHeros={Count:heroes.length,GetHeroByIndex:function(i:int):Object{return heroes[i];}};
    InitCharacterTags(host);
    check(FCharacterTagRow.parent==host,"profile header parent");
    check(FCharacterTagRow.x==244 && FCharacterTagRow.y==381,"tab-relative placement");
    RenderCharacterTags();
    check(FCharacterTagRow.numChildren==6,"Pain profile tags");
    var expected:Array=["Lightning","Male","Hidden Rain","Akatsuki","Blood Limit","Rinnegan"];
    for(var i:int=0;i<6;i++){
     var slot:Sprite=FCharacterTagRow.getChildAt(i) as Sprite;
     check(slot.name==expected[i],"Pain tag order");
     slot.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));check(FHint.Caption==expected[i],"native hover handler");
     slot.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));check(FHint.Caption=="","native mouse out");
    }
    FTabHeroIndex=1;RenderCharacterTags();check(FCharacterTagRow.numChildren==9,"Hashirama switch");
    FTabHeroIndex=2;RenderCharacterTags();check(FCharacterTagRow.numChildren==11,"Sasuke switch");
    check(Math.abs(FCharacterTagRow.width-140)<0.01,"long row fits 140px");
    FTabHeroIndex=3;RenderCharacterTags();check(!FCharacterTagRow.visible && FCharacterTagRow.numChildren==0,"untagged hero clears");
    FHeros=null;RenderCharacterTags();check(!FCharacterTagRow.visible,"null profile safe");
    FHeros={Count:heroes.length,GetHeroByIndex:function(i:int):Object{return heroes[i];}};
    FTabHeroIndex=0;RenderCharacterTags();ClearProfileCharacterTags();check(!FCharacterTagRow.visible && FCharacterTagRow.numChildren==0,"reset clears row");
    RenderCharacterTags();
    setTimeout(finish,1500);
   }catch(error:Error){report("ERROR "+error+" "+error.getStackTrace());}
  }
  private function finish():void {
   try {
    for(var i:int=0;i<FCharacterTagRow.numChildren;i++){
     var icon:Loader=Sprite(FCharacterTagRow.getChildAt(i)).getChildAt(0) as Loader;
     check(icon.content!=null,"profile PNG loaded");
    }
    report("PASS "+checked+" profile tag checks: selection, names, hover/out, empty/null/reset, reopen, layout and PNG loads");
   }catch(error:Error){report("ERROR "+error+" "+error.getStackTrace());}
  }
 __METHODS__
 }
}'''.replace('__METHODS__',methods)
dest = W/'probe-source/TApplication.as'; dest.parent.mkdir(exist_ok=True); dest.write_text(probe)
b.c.ff('-onerror','abort','-importScript',W/'source.swf',W/'probe.swf',dest.parent)
raw=bytearray((W/'probe.swf').read_bytes());raw[3]=21;(W/'probe.swf').write_bytes(raw)
print('PASS: profile component probe compiled')
