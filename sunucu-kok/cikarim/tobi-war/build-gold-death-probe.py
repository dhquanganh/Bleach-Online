"""Run the released White Zetsu death methods with two concurrent deaths."""
from pathlib import Path
import importlib.util

B = Path(__file__).resolve().parent
W = B / 'repair-gold-zetsu/gold-probe'
spec = importlib.util.spec_from_file_location('client', B / 'build-client.py')
client = importlib.util.module_from_spec(spec)
spec.loader.exec_module(client)
c = client.c
role = (B / 'repair-gold-zetsu/patched' / c.b.ROLE).read_text(encoding='utf-8')
methods = '\n'.join(c.m.extract(role, name) for name in ('ClearWhiteZetsuPose', 'PlayWhiteZetsuPose', 'UpdateWhiteZetsuPose'))
methods = methods.replace('private function', 'public function').replace(':TAnimationSequence', ':Object').replace(':TAnimationFrame', ':Object')
source = '''package {
 import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;import flash.utils.*;
 public class TApplication extends MovieClip {
  private var actors:Array=[];private var callbacks:Array=[0,0];private var begun:int=0;
  public function TApplication(){if(stage)boot();else addEventListener(Event.ADDED_TO_STAGE,boot);}
  private function report(s:String):void{ExternalInterface.call("vfxProbe",s);}
  private function check(v:Boolean,s:String):void{if(!v)throw new Error(s);}
  private function boot(e:Event=null):void{try{
   for(var i:int=0;i<2;i++){var z:SmallActor=new SmallActor();z.FTextureSkill=i==0?{Count:2,GetAnimationSequenceByIndex:function(index:int):Object{return null;}}:{Count:2,GetAnimationSequenceByIndex:function(index:int):Object{return {GetAnimationFrameByIndex:function(frame:int):Object{return null;}};}};addChild(z);actors.push(z);}
   // First actor loses an in-flight attack; the second is a normal death.
   actors[0].FIndex=SmallActor.TYPE_ACTIVE_ATTACK;
   actors[0].FCallBackDict[SmallActor.TYPE_ACTIVE_ATTACK]=function(t:uint):void{callbacks[0]++;};
   actors[0].PlayWhiteZetsuPose(true,null,11);
   actors[1].PlayWhiteZetsuPose(true,function(t:uint):void{callbacks[1]++;},12);
   begun=getTimer();addEventListener(Event.ENTER_FRAME,tick);report("CASE floor 68 two Zetsu die concurrently");
  }catch(err:Error){report("ERROR "+err+" "+err.getStackTrace());}}
  private function tick(e:Event):void{try{
   for each(var z:SmallActor in actors)z.UpdateWhiteZetsuPose();
   if(getTimer()-begun<2400)return;
   check(callbacks[0]==1&&callbacks[1]==1,"both death callbacks exactly once");
   for each(z in actors)check(z.FWhiteZetsuStarted<0&&z.FIsDie&&!z.visible,"death pose completed and hidden");
   report("DONE two deaths; callbacks="+callbacks.join(",")+" remaining=0");removeEventListener(Event.ENTER_FRAME,tick);
  }catch(err:Error){report("ERROR "+err+" "+err.getStackTrace());removeEventListener(Event.ENTER_FRAME,tick);}}
 }
 internal class TBattleHandle {public static var PlaybackTime:Number=0;}
 internal class SmallActor extends Sprite {
  public static const TYPE_ACTIVE_ATTACK:int=1;public static const TYPE_ACTIVE_SKILL:int=2;
  public var FId:int=11120996;public var FTextureSkill:Object;public var FDefaultRoleTexture:Object=null;
  public var FWhiteZetsuSequence:Object;public var FWhiteZetsuStarted:Number=-1;public var FWhiteZetsuWallStarted:int=-1;
  public var FWhiteZetsuFrames:int=0;public var FWhiteZetsuDying:Boolean=false;public var FWhiteZetsuSpawned:Boolean=true;
  public var FWhiteZetsuCallback:Function;public var FWhiteZetsuTime:uint=0;
  public var FIndex:int=0;public var FWaitNextCommand:Boolean=false;public var FActiveCallBack:Function;public var FCallBackDict:Array=[];
  public var FIsDie:Boolean=false;public var FWaitDie:Boolean=false;public var FHideFrame:int=-1;
  public var FBitmap:Bitmap=new Bitmap();public var FShaderBmp:Sprite=new Sprite();public var FHpBar:Sprite=new Sprite();public var FBuffSprite:Sprite=new Sprite();
  public function SmallActor(){addChild(FBitmap);}
__METHODS__
 }
}'''.replace('__METHODS__', methods)
dest = W / 'probe-source/TApplication.as'
dest.parent.mkdir(parents=True, exist_ok=True)
dest.write_text(source, encoding='utf-8')
c.ff('-onerror', 'abort', '-importScript', B / 'repair-gold-zetsu/source.swf', W / 'raster-probe.swf', dest.parent)
raw = bytearray((W / 'raster-probe.swf').read_bytes());raw[3] = 21;(W / 'raster-probe.swf').write_bytes(raw)
js = (B / 'zetsu-lifecycle/runtime-raster.js').read_text().replace("path.resolve(base,'../../../..')", "path.resolve(base,'../../../../..')").replace('7492', '7496').replace('7493', '7497')
(W / 'runtime-raster.js').write_text(js)
(W / 'validation/native').mkdir(parents=True, exist_ok=True)
print('PASS compiled real White Zetsu methods into dual-death native probe')
