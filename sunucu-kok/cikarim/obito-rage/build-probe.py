"""Exercise installed textures and production VFX in isolated native Flash 22."""
from pathlib import Path
import argparse,json,re,subprocess
BASE=Path(__file__).resolve().parent
def main():
    p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--status-check',action='store_true');args=p.parse_args()
    animation=json.loads((BASE/'animation.json').read_text())
    production=(BASE/('status-patched' if args.status_check else 'patched')/'Processors/Game/Battle/Character/TRole.as').read_text(encoding='utf-8')
    pieces=[]
    for name in ['ObitoVfxManifest','PreloadObitoVfx','LoadObitoVfxAtlas','PlayObitoVfxAsset','PlayObitoPowerFx','UpdateObitoVfx','ShowObitoVfx','ShowObitoStatusText']:
        signature=re.search(r'      private (?:static )?function '+name+r'\(',production)
        if signature is None:continue
        start=signature.start();end=production.index('{',start)+1;depth=1
        while depth:
            depth+=(production[end]=='{')-(production[end]=='}');end+=1
        pieces.append(production[start:end])
    methods='\n'.join(pieces).replace('TRole','TApplication')
    methods=methods.replace('FObitoFxCache[name] = frames;','FObitoFxCache[name] = frames; report("ATLAS "+name);')
    methods=methods.replace('failed = function(event:Event):void {release();loader.unload();};','failed = function(event:Event):void {report("ERROR atlas "+name);release();loader.unload();};')
    # Static atlas loader cannot call instance report.
    methods=methods.replace('report("ATLAS "+name);','if(ExternalInterface.available)ExternalInterface.call("vfxProbe","ATLAS "+name);').replace('report("ERROR atlas "+name);','if(ExternalInterface.available)ExternalInterface.call("vfxProbe","ERROR atlas "+name);')
    methods=methods.replace('var caster:TApplication = this;','var caster:TApplication = this; report("VFX_ASSET "+name+" mirror="+mirrored);')
    methods=methods.replace('var wood:Boolean =','report("POWER_FX "+skill+" phase="+(charge?"charge":"impact")+" delay="+delay);\n         var wood:Boolean =')
    source=(BASE.parent/'jiraiya-toads/vfx-probe.as.txt').read_text(encoding='utf-8-sig')
    source=source.replace('11120903','11120920').replace('Jiraiya','Obito').replace('FObitoVfxHit','FUnusedVfxHit')
    source=source.replace('  private static var FObitoShake:Object=null;','  private static var FObitoFxCache:Object={};\n  private static var FObitoFxLoading:Object={};')
    source=source.replace('stage.frameRate=30;','stage.frameRate=25;')
    ids=list(map(int,animation['moves']));names=list(animation['moves'].values())
    source=re.sub(r'private var skills:Array=\[.*?\];','private var skills:Array='+json.dumps(ids)+';',source)
    source=re.sub(r'private var clipNames:Array=\[.*?\];','private var clipNames:Array='+json.dumps(names)+';',source)
    source=source.replace('__METADATA__',json.dumps(animation['clips'],separators=(',',':')))
    source=source.replace('right=new TApplication(false);','right=new TApplication(false);PreloadObitoVfx();')
    hero=11120920
    source=source.replace('00A9B107',f'{hero:08X}').replace('A9B1070B',f'{hero:X}0B').replace('A9B1070C',f'{hero:X}0C')
    source=source.replace('["giant-gallant-rasengan"]','["standard","rage-standard"]')
    source=source.replace('["toad-mouth-barrier","toad-confrontation-chant","raging-lions-mane","senjutsu-power","tale-of-jiraiya-revival"]','["kamui","roots","chaos","spear","rage"]')
    source=source.replace('if(leap){var pose:Object=role.ObitoRasenganPose();role.actor.x+=Number(pose.x);role.actor.y+=Number(pose.y);}','')
    source=source.replace('if(loaded<7)return;','if(loaded<8)return;')
    source=source.replace('4000','5000').replace('slot>=12','slot>=18').replace('slot<6?0:1','slot<9?0:1').replace('slot%6','slot%9')
    source=source.replace('    if(slot==6)SetObitoBarrier(battle,false);','')
    source=source.replace('SetObitoBarrier(battle,false);report("DONE shared native component; background cleared="+(battle.getChildByName("jiraiyaEsophagusBackdrop")==null));','var remaining:int=0; for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="obitoSkillVfx")remaining++; report("DONE Obito native component; remaining="+remaining);')
    source=source.replace('var hit:int=index==0?24:(metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):8);','var hit:int=metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):10;')
    source=source.replace('   var pose:String=', '''   var hitKey:String="HIT-"+skills[index]+"-camp-"+side;
   if(frame>=hit && !captured[hitKey]){captured[hitKey]=true;var hitStarted:int=getTimer();saveFrame(hitKey);readyAt+=getTimer()-hitStarted;}
   var pose:String=''')
    fields=source[source.index('  private var FId:'):source.index('  private var clips:')].replace('private var','public var').replace('private const','public const').replace('private static var','public static var')
    methods=methods.replace('TApplication','ProbeRole').replace('private function','public function').replace('private static function','public static function')
    source=source.replace('left=new TApplication(false);right=new TApplication(false);PreloadObitoVfx();','left=new ProbeRole();right=new ProbeRole();ProbeRole.PreloadObitoVfx();')
    source=source.replace('private var left:TApplication;','private var left:ProbeRole;').replace('private var right:TApplication;','private var right:ProbeRole;')
    source=source.replace('role:TApplication','role:ProbeRole').replace('caster:TApplication','caster:ProbeRole').replace('victim:TApplication','victim:ProbeRole')
    if args.status_check:
        start=source.index('   if(loaded<8)return;');end=source.index('  private function saveFrame(',start)
        source=source[:start]+"""
   if(loaded<8)return;
   if(readyAt<0){
      readyAt=getTimer();
      left.ShowObitoStatusText("KAMUI",0xB9F47A);
      left.ShowObitoStatusText("IMMOBILE",0xFFAA88);
      left.ShowObitoStatusText("LIFE STEAL +120 HP",0xB9F47A);
      right.ShowObitoStatusText("KAMUI TAG II",0xB9F47A);
      right.ShowObitoStatusText("KNOCKDOWN",0xFFE299);
   }
   var age:int=getTimer()-readyAt;
   renderRole(left,"idle",int(age/100)%clips.idle.images.length);
   renderRole(right,"idle",int(age/100)%clips.idle.images.length);
   for each(var checkpoint:int in [1000,2400,3000,3500]){
      var tag:String="TEXT-"+checkpoint;
      if(age>=checkpoint&&!captured[tag]){
         captured[tag]=true;
         var count:int=0;
         var labelHost:DisplayObjectContainer=left.parent;
         for(var i:int=0;i<labelHost.numChildren;i++)if(labelHost.getChildAt(i).name.indexOf("obitoStatus_")==0)count++;
         if(count!=(checkpoint<3200?5:0))report("ERROR status lifetime at "+checkpoint+" count="+count);
         report("TEXT_CHECK "+checkpoint+" count="+count);saveFrame(tag);
      }
   }
   if(age>=3700){report("DONE status text; remaining=0");removeEventListener(Event.ENTER_FRAME,tick);}
  }
"""+source[end:]
    source=source.replace('__METHODS__','').rstrip()
    source=source[:-1]+'\n internal class ProbeRole extends Sprite {\n'+fields+'\n public function ProbeRole(){actor.smoothing=true;addChild(actor);}\n public function report(text:String):void{if(ExternalInterface.available)ExternalInterface.call("vfxProbe",text);}\n'+methods+'\n}\n}\n'
    dest=BASE/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source,encoding='utf-8')
    output=BASE/('status-probe.swf' if args.status_check else 'raster-probe.swf')
    subprocess.run(['java','-Xmx2g','-jar',args.ffdec,'-onerror','abort','-importScript',str(BASE/'source.swf'),str(output),str(dest.parent)],check=True)
    binary=bytearray(output.read_bytes());binary[3]=21;output.write_bytes(binary)
    print('PASS Obito component probe compiled')
if __name__=='__main__':main()
