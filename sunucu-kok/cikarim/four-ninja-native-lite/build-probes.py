"""Compile actor/VFX previews from the installed production methods."""
from pathlib import Path
import argparse,importlib.util,json,re
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('client',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
CONFIG={'sasuke':('Sasuke','sasuke-shinden',11120970),'mecha':('Mecha','mecha-naruto',11120950),'itachi':('Itachi','itachi-rtn',11120960),'gaara':('Gaara','gaara-swimsuit',11120991)}

def root_method(text,name):
    start=re.search(r'[^\n]*function '+name+r'\(',text).start()
    return text[start:c.b.method_end(text,start)]

def main():
    parser=argparse.ArgumentParser();parser.add_argument('character',choices=CONFIG);args=parser.parse_args()
    key=args.character;prefix,folder,hero=CONFIG[key];W=B/'probes'/key;W.mkdir(parents=True,exist_ok=True)
    role=(B/'patched'/c.b.ROLE).read_text(encoding='utf-8')
    base=(B.parent/'tsunade-asian/probe-source/TApplication.as').read_text(encoding='utf-8')
    root='\n'.join(root_method(base,n) for n in ['loadTexture','decodeTexture','saveFrame'])
    anim=json.loads((B.parent/folder/'animation.json').read_text())
    model=anim['models'][str(hero)];loads=[];expected=0
    idle=model.get('0a',model[''])
    for suffix,names in [('0a' if '0a' in model else '',idle),('0b',model['0b']),('0c',model['0c'])]:
        if isinstance(names,str):names=[names]
        ident=int(f'{hero:X}'+suffix,16);loads.append('   loadTexture("'+f'{ident:08X}'+'",'+json.dumps(names)+');');expected+=len(names)
    plan=[{'skill':0,'name':'idle'}]+[{'skill':int(i),'name':name} for i,name in anim['moves'].items()]
    first=next(iter(anim['moves'].items()));plan += [{'skill':int(first[0]),'name':first[1],'cancel':True},{'skill':int(first[0]),'name':first[1]}]
    bounds=[0]
    for entry in plan*2:
        frames=45 if entry.get('cancel') else 30 if entry['skill']==0 else len(anim['clips'][entry['name']]['assets'])
        bounds.append(bounds[-1]+frames*40+700)
    names=['Preload'+prefix+'Vfx',prefix+'VfxManifest','Play'+prefix+'VfxAsset','Update'+prefix+'Vfx','Show'+prefix+'Vfx','Fit'+prefix+'Pose',prefix+'Backdrop']
    extras={'sasuke':['PlaySasukeEffect','LoadSasukeCinematic','PlaySasukeCinematic','PlaySasukeNativeImpact','ShowSasukeScreenFlash','ShowSasukeGenjutsu'],
            'mecha':['MechaStrikePose'],
            'itachi':['PlayItachiEffect','ShowItachiCrowClone','ClearItachiCrowClone'],
            'gaara':['PlayGaaraEffect','GaaraStrikeOffset','GaaraStrikePose']}[key]
    names+=extras+['FourNinjaNativeManifest','PreloadFourNinjaNative','LoadFourNinjaNative','PlayFourNinjaNative']
    methods='\n'.join(c.m.extract(role,n) for n in names)
    methods=methods.replace(':TRole',':ProbeRole').replace(':TAnimationFrame',':Object').replace('private static function','public static function').replace('private function','public function')
    methods=re.sub(r'TBattleHandle\.PlaybackTime(?:\(\))?','getTimer()',methods)
    methods=methods.replace('movie=new type() as MovieClip;', 'movie=new type() as MovieClip;if(ExternalInterface.available)ExternalInterface.call("vfxProbe","NATIVE_LAYER "+character+" "+name);')
    # The shared runtime follows Gaara movement only for Gaara callers.
    if key!='gaara':methods+='\n public function GaaraStrikeOffset():Point{return new Point();}\n'
    fields='''
 public static var FFourNinjaNativeCache:Object={};public static var FFourNinjaNativeManifest:Object;
 public var FId:int=__HERO__;public var FSkillId:int=0;public var FIndex:int=1;public var FFrameIndex:int=0;
 public const TYPE_ACTIVE_ATTACK:int=1;public const TYPE_ACTIVE_SKILL:int=2;
 public var FCombatVfxSerial:uint=0;public var FBattleStage:Sprite;public var FTargets:Array=[];public var FResults:Array=[];public var Camp:int=0;public var Pos:int=1;
 public var actor:Bitmap=new Bitmap();public function get FBitmap():Bitmap{return actor;}
 public static var F__PREFIX__FxLoading:Object={};public static var F__PREFIX__FxCache:Object={};public var F__PREFIX__ActiveVfx:Array=[];public var F__PREFIX__VfxStarted:Boolean=false;
 public var FMechaBeast:Boolean=false;public var FIsDie:Boolean=false;public var CurHealth:Number=1000;public var FTextureFightIdle:Object;
 public var FItachiCrowClone:Sprite;public var FItachiCrowCloneTick:Function;public var FItachiCrowCloneRemoved:Function;
 public function ProbeRole(){actor.smoothing=true;addChild(actor);}
'''.replace('__HERO__',str(hero)).replace('__PREFIX__',prefix)
    pose=''
    if key=='mecha':pose='role.MechaStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});'
    if key=='gaara':pose='role.GaaraStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});'
    source='''package {
 import Foundation.Decoder.Pak.TPakDecoder;import Logics.Battle.model.*;import ghostcat.util.easing.TweenUtil;
 import flash.display.*;import flash.events.*;import flash.net.*;import flash.geom.*;import flash.utils.*;import flash.text.*;import flash.filters.*;import flash.system.*;import flash.external.ExternalInterface;
 public class TApplication extends MovieClip {
  private var clips:Object={};private var decoders:Array=[];private var loaded:int=0;private var readyAt:int=-1;private var lastSlot:int=-1;private var captured:Object={};private var cancelled:Object={};
  private var battle:Sprite=new Sprite();private var left:ProbeRole;private var right:ProbeRole;private var label:TextField=new TextField();
  private var metadata:Object=__METADATA__;private var plan:Array=__PLAN__;private var bounds:Array=__BOUNDS__;
  public function TApplication(){if(stage)boot();else addEventListener(Event.ADDED_TO_STAGE,boot);}
  private function report(s:String):void{ExternalInterface.call("vfxProbe",s);}
  private function boot(event:Event=null):void {
   removeEventListener(Event.ADDED_TO_STAGE,boot);stage.scaleMode=StageScaleMode.NO_SCALE;stage.align=StageAlign.TOP_LEFT;stage.frameRate=25;
   loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{report("ERROR "+e.error+(e.error is Error?" "+Error(e.error).getStackTrace():""));});
   addChild(battle);battle.graphics.beginFill(0x344b38);battle.graphics.drawRect(0,0,1250,650);battle.graphics.endFill();
   battle.graphics.lineStyle(1,0x59734a,.5);for(var i:int=0;i<12;i++){battle.graphics.moveTo(0,300+i*30);battle.graphics.lineTo(1250,300+i*30);}
   left=new ProbeRole();right=new ProbeRole();left.x=320;right.x=900;left.y=450;right.y=450;right.scaleX=-1;left.Camp=0;right.Camp=1;
   left.FBattleStage=battle;right.FBattleStage=battle;battle.addChild(left);battle.addChild(right);
   label.defaultTextFormat=new TextFormat("_sans",20,0xffffff,true);label.width=1240;label.height=35;label.x=15;label.y=12;addChild(label);
__LOADS__
   addEventListener(Event.ENTER_FRAME,tick);
  }
  private function idleTexture():Object{var idle:Object=clips.idle;return {GetAnimationSequenceByIndex:function(i:int):Object{return {GetAnimationFrameByIndex:function(j:int):Object{j=j%idle.images.length;return {Surface:idle.images[j],Pivot:{X:idle.meta[j].px,Y:idle.meta[j].py}};}};}};}
  private function clear(role:ProbeRole):void {
   role.FSkillId=0;role.FCombatVfxSerial++;
   for each(var layer:Sprite in role.F__PREFIX__ActiveVfx)if(layer.parent!=null)layer.parent.removeChild(layer);
   role.F__PREFIX__ActiveVfx=[];
__CROW_CLEAR__
  }
  private function renderRole(role:ProbeRole,name:String,index:int):void {
   var clip:Object=clips[name];if(clip==null)clip=clips.idle;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;
   if(role.FSkillId>0){__POSE__role.Fit__PREFIX__Pose();}
  }
  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<__EXPECTED__)return;
   if(readyAt<0){left.FTextureFightIdle=idleTexture();right.FTextureFightIdle=idleTexture();readyAt=getTimer()+3500;ProbeRole.Preload__PREFIX__Vfx();}if(getTimer()<readyAt)return;
   var speed:Number=Number(loaderInfo.parameters.speed);if(speed!=2)speed=1;
   var age:int=(getTimer()-readyAt)*speed;var slot:int=0;while(slot<plan.length*2 && age>=bounds[slot+1])slot++;
   if(slot>=plan.length*2){clear(left);clear(right);var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name.indexOf("SkillVfx")>=0||battle.getChildAt(q).name=="itachiCrowClone")remaining++;report("DONE __KEY__; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<plan.length?0:1;var index:int=slot%plan.length;var entry:Object=plan[index];var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;
   if(lastSlot!=slot){clear(left);clear(right);caster.FSkillId=entry.skill;caster.FFrameIndex=0;caster.F__PREFIX__VfxStarted=false;caster.Pos=1+index%3*5;caster.y=350+index%3*75;victim.y=390+index%2*80;
    caster.FTargets=[caster,victim,caster];caster.FResults=[{CMD:0,ResultInfo:{HurtHp:0}},{CMD:1,ResultInfo:{HurtHp:10}},{CMD:8,ResultInfo:{HurtHp:0}}];
    if(entry.skill==0)caster.FMechaBeast=false;else if(entry.skill>=13121109&&entry.skill<=13121113)caster.FMechaBeast=true;
    lastSlot=slot;label.text="__KEY__ native | "+entry.name+" | camp "+side+" | x"+speed+(entry.cancel?" | interrupt":"");report("CASE "+slot+" skill="+entry.skill+" camp="+side);
   }
   var frame:int=int((age-bounds[slot])/40);caster.FFrameIndex=frame;
   if(entry.cancel && frame>=24){if(!cancelled[slot]){cancelled[slot]=true;clear(caster);report("CANCEL_OK "+slot);}renderRole(caster,"idle",frame%clips.idle.images.length);}
   else if(entry.skill>0 && frame<clips[entry.name].images.length){renderRole(caster,entry.name,frame);caster.Update__PREFIX__Vfx();}
   else {caster.FSkillId=0;renderRole(caster,caster.FMechaBeast&&clips["beast-idle"]!=null?"beast-idle":"idle",frame%clips.idle.images.length);}
   renderRole(victim,"idle",frame%clips.idle.images.length);
   var hit:int=metadata[entry.name].hitFrames!=null?int(metadata[entry.name].hitFrames[0]):12;
   var phases:Array=[Math.max(4,hit),int(metadata[entry.name].assets.length*.5),int(metadata[entry.name].assets.length*.78)];
   if(entry.skill==0)phases=[8,20];if(entry.cancel)phases=[12,30];
   for each(var phase:int in phases){var key:String="CASE-"+slot+"-skill-"+entry.skill+"-camp-"+side+"-frame-"+phase;if(frame>=phase&&!captured[key]){captured[key]=true;var started:int=getTimer();
    for(var flush:int=battle.numChildren-1;flush>=0;flush--)if(flush<battle.numChildren&&battle.getChildAt(flush).name.indexOf("SkillVfx")>=0)battle.getChildAt(flush).dispatchEvent(new Event(Event.ENTER_FRAME));
    saveFrame(key);readyAt+=getTimer()-started;}}
  }
__ROOT_METHODS__
 }
 internal class ProbeRole extends Sprite {
__FIELDS__
__METHODS__
 }
}'''
    replacements={'__HERO__':str(hero),'__PREFIX__':prefix,'__KEY__':key,'__METADATA__':json.dumps(anim['clips'],separators=(',',':')),'__PLAN__':json.dumps(plan),'__BOUNDS__':json.dumps(bounds),'__LOADS__':'\n'.join(loads),'__EXPECTED__':str(expected),'__POSE__':pose,'__CROW_CLEAR__':'   role.ClearItachiCrowClone();' if key=='itachi' else '', '__ROOT_METHODS__':root,'__FIELDS__':fields,'__METHODS__':methods}
    for token,value in replacements.items():source=source.replace(token,value)
    dest=W/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source,encoding='utf-8')
    c.ff('-onerror','abort','-importScript',B/'source.swf',W/'probe.swf',dest.parent)
    raw=bytearray((W/'probe.swf').read_bytes());raw[3]=21;(W/'probe.swf').write_bytes(raw)
    (W/'plan.json').write_text(json.dumps({'character':key,'cases':len(plan)*2,'modelSequences':expected,'plan':plan},indent=2)+'\n')
    print('PASS',key,len(plan)*2,'native cases compiled')

if __name__=='__main__':main()
