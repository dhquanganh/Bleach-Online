"""Run production Hashirama poses and original VFX in isolated Flash 22."""
from pathlib import Path
import argparse,json,re,subprocess
BASE=Path(__file__).resolve().parent
def method(source,name):
 start=re.search(r'      private (?:static )?function '+name+r'\(',source).start();end=source.index('{',start)+1;depth=1
 while depth:depth+=(source[end]=='{')-(source[end]=='}');end+=1
 return source[start:end]
def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--stress-only',action='store_true');p.add_argument('--forest-only',action='store_true');p.add_argument('--cinematic-only',action='store_true');args=p.parse_args()
 data=json.loads((BASE/'animation.json').read_text());production=(BASE/'patched/Processors/Game/Battle/Character/TRole.as').read_text()
 methods='\n'.join(method(production,n) for n in ['HashiramaVfxManifest','PreloadHashiramaVfx','LoadHashiramaVfxAtlas','TrimHashiramaVfxCache','PlayHashiramaVfxAsset','UpdateHashiramaVfx','ShowHashiramaVfx','HashiramaStrikePose','ShowHashiramaImpact','ShowHashiramaStatusText'])
 methods=methods.replace('TRole','ProbeRole').replace('frame:TAnimationFrame','frame:Object').replace('private function','public function').replace('private static function','public static function')
 # The isolated component has no battle handle; its clock runs at normal speed.
 methods=re.sub(r'TBattleHandle\.PlaybackTime(?:\(\))?','getTimer()',methods)
 methods=methods.replace('FHashiramaFxCache[name] = frames;','FHashiramaFxCache[name] = frames;if(ExternalInterface.available)ExternalInterface.call("vfxProbe","ATLAS "+name);')
 methods=methods.replace('LoadHashiramaVfxAtlas(String(clip.atlas),manifest.atlases[clip.atlas]);','LoadHashiramaVfxAtlas(String(clip.atlas),manifest.atlases[clip.atlas]);if(ExternalInterface.available)ExternalInterface.call("vfxProbe","VFX_ASSET "+name);')
 methods=methods.replace('PlayHashiramaVfxAsset(name,host,at,w,h,','report("ANCHOR skill="+skill+" layer="+name+" camp="+Camp+" x="+at.x+" y="+at.y+" width="+w+" height="+h);PlayHashiramaVfxAsset(name,host,at,w,h,')
 s=(BASE.parent/'jiraiya-toads/vfx-probe.as.txt').read_text(encoding='utf-8-sig').replace('11120903','11120940').replace('Jiraiya','Hashirama')
 s=s.replace('  private static var FHashiramaShake:Object=null;','  private static var FHashiramaFxCache:Object={};\n  private static var FHashiramaFxLoading:Object={};')
 s=s.replace('stage.frameRate=30;','stage.frameRate=25;')
 moves=list(data['moves'])+['13121004','13121004'];names=list(data['moves'].values())+['severe','severe'];bounds=[0]
 if args.stress_only:moves=['13121004','13121004'];names=['severe','severe']
 if args.forest_only:moves=['13121009','13121009'];names=['forest','forest']
 if args.cinematic_only:moves=['13121002','13121002'];names=['rumbling','rumbling']
 for index,name in enumerate(names*2):bounds.append(bounds[-1]+(960 if not args.forest_only and not args.cinematic_only and index%len(names)==len(names)-2 else len(data['clips'][name]['assets'])*40+1000))
 s=re.sub(r'private var skills:Array=\[.*?\];','private var skills:Array='+json.dumps(list(map(int,moves)))+';',s)
 s=re.sub(r'private var clipNames:Array=\[.*?\];','private var clipNames:Array='+json.dumps(names)+';',s)
 s=s.replace('__METADATA__',json.dumps(data['clips'],separators=(',',':')))
 s=s.replace('00A9B107',f'{11120940:08X}').replace('A9B1070B',f'{11120940:X}0B').replace('A9B1070C',f'{11120940:X}0C')
 s=s.replace('["giant-gallant-rasengan"]','["taijutsu","sword"]')
 s=s.replace('["toad-mouth-barrier","toad-confrontation-chant","raging-lions-mane","senjutsu-power","tale-of-jiraiya-revival"]','["deity","rumbling","adamantine","severe","burst-severe","golem","forest","burst"]')
 s=s.replace('if(loaded<7)return;','if(loaded<11)return;')
 s=s.replace('var slot:int=int(age/4000);','var slots:Array='+json.dumps(bounds)+';var slot:int=0;while(slot<24 && age>=slots[slot+1])slot++;')
 s=s.replace('slot>=12','slot>=24').replace('slot<6?0:1','slot<12?0:1').replace('slot%6','slot%12').replace('int((age%4000)/40)','int((age-slots[slot])/40)')
 s=s.replace('    caster.FSkillId=skills[index];','    ++caster.FCombatVfxSerial;caster.FSkillId=skills[index];')
 s=s.replace('    if(slot==6)SetHashiramaBarrier(battle,false);','')
 s=s.replace('SetHashiramaBarrier(battle,false);report("DONE shared native component; background cleared="+(battle.getChildByName("jiraiyaEsophagusBackdrop")==null));','var remaining:int=0;var hosts:Array=[battle];while(hosts.length){var host:DisplayObjectContainer=hosts.pop() as DisplayObjectContainer;for(var q:int=0;q<host.numChildren;q++){var child:DisplayObject=host.getChildAt(q);if(child.name=="hashiramaSkillVfx")remaining++;if(child is DisplayObjectContainer)hosts.push(child);}}report("DONE Hashirama native component; remaining="+remaining);')
 s=s.replace('if(leap){var pose:Object=role.HashiramaRasenganPose();role.actor.x+=Number(pose.x);role.actor.y+=Number(pose.y);}','role.HashiramaStrikePose({Surface:clip.images[index],Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});')
 s=s.replace('var hit:int=index==0?24:(metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):8);','var hit:int=metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):8;')
 s=s.replace('   var pose:String=','   var hitKey:String="HIT-"+skills[index]+"-camp-"+side;if(frame>=hit && !captured[hitKey]){captured[hitKey]=true;saveFrame(hitKey);}\n   var pose:String=')
 s=s.replace('   var hit:int=', '   var layerKey:String="LAYER-CHECK-"+slot;\n   if(frame>=3 && !captured[layerKey]){\n    captured[layerKey]=true;var fxCount:int=0;var fxHosts:Array=[battle];\n    while(fxHosts.length){var fxHost:DisplayObjectContainer=fxHosts.pop() as DisplayObjectContainer;for(var fi:int=0;fi<fxHost.numChildren;fi++){var fx:DisplayObject=fxHost.getChildAt(fi);if(fx.name=="hashiramaSkillVfx")fxCount++;if(fx is DisplayObjectContainer)fxHosts.push(fx);}}\n    var bound:int=(skills[index]==13121001 || skills[index]==13121002)?4:(skills[index]==13121004 || skills[index]==13121005 || skills[index]==13121008)?3:skills[index]==13121009?2:1;\n    report((fxCount>bound?"ERROR overlapping layers ":"LAYERS_OK ")+"slot="+slot+" skill="+skills[index]+" count="+fxCount+" bound="+bound);\n   }\n   var hit:int=')
 if args.stress_only or args.forest_only or args.cinematic_only:s=s.replace('slot<24 &&','slot<4 &&').replace('slot>=24','slot>=4').replace('slot<12?0:1','slot<2?0:1').replace('slot%12','slot%2')
 if args.cinematic_only:
  s=s.replace('    ++caster.FCombatVfxSerial;', '    battle.x=index==0?0:90;battle.y=index==0?0:55;battle.scaleX=index==0?1:.68;battle.scaleY=index==0?1:.68;\n    ++caster.FCombatVfxSerial;')
  s=s.replace('   var pose:String=', '   if(frame>=12 && !captured["CLOSEUP-"+slot]){captured["CLOSEUP-"+slot]=true;saveFrame("CLOSEUP-"+slot);}\n   if(frame>=140 && !captured["BARRAGE-"+slot]){captured["BARRAGE-"+slot]=true;saveFrame("BARRAGE-"+slot);}\n   var pose:String=')
  s=s.replace('   var hit:int=', '   if(frame>=12 && !captured["SCREEN-"+slot]){captured["SCREEN-"+slot]=true;var screenLayer:DisplayObject=battle.getChildByName("hashiramaSkillVfx");var screenRect:Rectangle=screenLayer==null?new Rectangle():screenLayer.getBounds(stage);var fitted:Boolean=Math.abs(screenRect.x)<2 && Math.abs(screenRect.y)<2 && Math.abs(screenRect.width-stage.stageWidth)<2 && Math.abs(screenRect.height-stage.stageHeight)<2;report((fitted?"SCREEN_BOUNDS_OK ":"ERROR screen bounds ")+slot+" "+screenRect);}\n   var hit:int=')
 if args.forest_only:
  s=s.replace('    ++caster.FCombatVfxSerial;', '    caster.FResults=[];caster.y=index==0?470:300;caster.x=side==0?(index==0?360:230):(index==0?900:1020);\n    ++caster.FCombatVfxSerial;')
  s=s.replace('int(hit*0.55)', 'int(40*.55)').replace('var hit:int=metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):8;', 'var hit:int=40;')
 s=s.replace('   if(index==2){','   if(skills[index]==13121008){').replace('[6,16,27,30,42]','[6,16,19,30,42]')
 # Unequal row heights and scaled parent exercise coordinate conversions in both camps.
 s=s.replace('var actors:Sprite=new Sprite();battle.addChild(actors);','var actors:Sprite=new Sprite();battle.addChild(actors);actors.x=35;actors.scaleX=.94;actors.scaleY=.94;')
 s=s.replace('right.y=470;','right.y=420;')
 fields=s[s.index('  private var FId:'):s.index('  private var clips:')].replace('private var','public var').replace('private const','public const').replace('private static var','public static var')+'\n public var FBitmap:Bitmap=actor;\n public var FCombatVfxSerial:uint=0;\n public var FHashiramaActiveVfx:Array=[];'
 s=s.replace('left=new TApplication(false);right=new TApplication(false);','left=new ProbeRole();right=new ProbeRole();ProbeRole.PreloadHashiramaVfx();')
 s=s.replace('left:TApplication','left:ProbeRole').replace('right:TApplication','right:ProbeRole').replace('role:TApplication','role:ProbeRole').replace('caster:TApplication','caster:ProbeRole').replace('victim:TApplication','victim:ProbeRole')
 s=s.replace('__METHODS__','').rstrip();s=s[:-1]+'\n internal class ProbeRole extends Sprite {\n'+fields+'\n public function ProbeRole(){actor.smoothing=true;addChild(actor);}\n public function report(text:String):void{if(ExternalInterface.available)ExternalInterface.call("vfxProbe",text);}\n'+methods+'\n}\n}\n'
 dest=BASE/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(s)
 subprocess.run(['java','-Xmx2g','-jar',args.ffdec,'-onerror','abort','-importScript',str(BASE/'source.swf'),str(BASE/'raster-probe.swf'),str(dest.parent)],check=True)
 raw=bytearray((BASE/'raster-probe.swf').read_bytes());raw[3]=21;(BASE/'raster-probe.swf').write_bytes(raw)
 print('PASS',len(names)*2,'case Hashirama Flash probe compiled; duration',bounds[-1]/1000,'seconds')
if __name__=='__main__':main()
