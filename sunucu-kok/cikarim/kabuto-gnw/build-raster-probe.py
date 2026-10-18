"""Compile an isolated Flash graphics probe using the production raster VFX methods."""
from pathlib import Path
import argparse
import json
import re
import subprocess

BASE = Path(__file__).resolve().parent


def remove_block(source, start):
    body = source.index('{', start)+1
    depth = 1
    end = body
    while depth:
        depth += (source[end] == '{')-(source[end] == '}')
        end += 1
    return source[:start]+source[end:]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--ffdec', required=True)
    parser.add_argument('--revival-check',action='store_true')
    args = parser.parse_args()
    metadata = json.loads((BASE/'animation.json').read_text())['clips']
    manifest = json.loads((BASE/'vfx.json').read_text())
    names = ['white-snake-assault','bracken-dance','white-extreme-attack',
             'self-healing','white-snake-revival','impure-world-reincarnation']
    ids = [13120931,13120932,13120933,13120934,13120935,13120936]
    hits = {sid:metadata[name].get('hitFrames',[metadata[name]['steps']])[0] for sid,name in zip(ids,names)}
    methods = (BASE/'raster-vfx.as.txt').read_text()
    methods = methods.replace('__KABUTO_VFX_MANIFEST__', json.dumps(manifest,separators=(',',':')))
    methods = methods.replace('__KABUTO_VFX_FRAMES__', json.dumps(hits))
    methods = methods.replace('TRole','ProbeRole').replace('private function','public function').replace('private static function','public static function')
    methods = methods.replace('this.ShowKabutoSummonVfx(skill,impact);return;', 'return;')
    methods = methods.replace('FKabutoFxCache[name] = frames;', '''FKabutoFxCache[name] = frames;
            if(ExternalInterface.available)ExternalInterface.call("vfxProbe","ATLAS "+name+" cells="+frames.length);''')
    methods = methods.replace('failed = function(event:Event):void {release();loader.unload();};',
                              'failed = function(event:Event):void {if(ExternalInterface.available)ExternalInterface.call("vfxProbe","ERROR atlas "+name);release();loader.unload();};')
    methods = methods.replace('var caster:ProbeRole = this;', 'var caster:ProbeRole = this;\n         report("VFX_ASSET "+name+" delay="+delay+" mirror="+mirrored+" at="+point.x+","+point.y);')
    methods = methods.replace('var origin:Point = host.globalToLocal(localToGlobal(new Point(0,0)));',
                              'report("VFX skill="+skill+" impact="+impact+" camp="+Camp);\n         var origin:Point = host.globalToLocal(localToGlobal(new Point(0,0)));')
    jiraiya = (BASE.parent/'jiraiya-toads/skill-vfx.as.txt').read_text()
    start = jiraiya.index('      private static function ShakeJiraiyaBattle(')
    tail = jiraiya[start:]
    end = tail.index('      private function ', 1)
    methods += tail[:end].replace('private static function','public static function')
    source = (BASE.parent/'jiraiya-toads/vfx-probe.as.txt').read_text(encoding='utf-8-sig')
    source = source.replace('11120903','11120910').replace('FJiraiyaVfx','FKabutoVfx').replace('UpdateJiraiyaVfx','UpdateKabutoVfx')
    source = source.replace('stage.frameRate=30;', 'stage.frameRate=25;')
    source = source.replace('battle.graphics.', 'this.graphics.')
    source = source.replace('private var skills:Array=[13120911,13120912,13120913,13120914,13120915,13120916];',
                            'private var skills:Array='+json.dumps(ids)+';')
    source = re.sub(r'private var clipNames:Array=\[.*?\];', 'private var clipNames:Array='+json.dumps(names)+';', source)
    source = source.replace('__METADATA__', json.dumps(metadata,separators=(',',':')))
    source = source.replace('left=new TApplication(false);right=new TApplication(false);',
                            'left=new ProbeRole();right=new ProbeRole();ProbeRole.PreloadKabutoVfx();')
    source = source.replace('private var left:TApplication;', 'private var left:ProbeRole;').replace('private var right:TApplication;', 'private var right:ProbeRole;')
    source = source.replace('role:TApplication','role:ProbeRole').replace('caster:TApplication','caster:ProbeRole').replace('victim:TApplication','victim:ProbeRole')
    source = source.replace('actors.addChild(left);actors.addChild(right);','battle.addChild(left);battle.addChild(right);')
    source = source.replace('00A9B107','00A9B10E').replace('A9B1070B','A9B10E0B').replace('A9B1070C','A9B10E0C')
    source = source.replace('["giant-gallant-rasengan"]', '["bracken-dance"]')
    source = source.replace('["toad-mouth-barrier","toad-confrontation-chant","raging-lions-mane","senjutsu-power","tale-of-jiraiya-revival"]',
                            '["white-snake-assault","white-extreme-attack","self-healing","white-snake-revival","impure-world-reincarnation"]')
    source = source.replace('SetJiraiyaBarrier(battle,false);report("DONE shared native component; background cleared="+(battle.getChildByName("jiraiyaEsophagusBackdrop")==null));',
                            '''var remaining:int=0;
    for(var fxIndex:int=0;fxIndex<battle.numChildren;fxIndex++)if(battle.getChildAt(fxIndex).name=="kabutoSkillVfx")remaining++;
    for(fxIndex=0;fxIndex<numChildren;fxIndex++)if(getChildAt(fxIndex).name=="kabutoSkillVfx")remaining++;
    report("DONE native raster component; 12 cases across both camps; remaining="+remaining);''')
    source = source.replace('if(slot==6)SetJiraiyaBarrier(battle,false);', '')
    source = source.replace('Jiraiya video reconstruction', 'Kabuto video VFX reconstruction')
    source = source.replace('if(loaded<7)return;', 'if(loaded<7 || ProbeRole.FKabutoFxCache.snakes == null || ProbeRole.FKabutoFxCache.poison == null || ProbeRole.FKabutoFxCache.utility == null || ProbeRole.FKabutoFxCache.cutin == null || ProbeRole.FKabutoFxCache.impact == null || ProbeRole.FKabutoFxCache.death == null)return;')
    source = source.replace('4000', '3000')
    source = remove_block(source, source.index('   if(leap){'))
    source = source.replace('if(index==2){', 'if(index==0){').replace('[6,16,27,30,42]', '[4,16,20,26,32,38]')
    source = source.replace('SLAM-camp-', 'MYSTERY-camp-')
    source = source.replace('var hit:int=index==0?24:(metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):8);',
                            'var hit:int=metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):int(metadata[name].steps);')
    fields = source[source.index('  private var FId:'):source.index('  private var clips:')].replace('private var','public var').replace('private const','public const').replace('private static var','public static var')
    fields += '\n public static var FKabutoFxCache:Object={};\n public static var FKabutoFxLoading:Object={};\n'
    if args.revival_check:
        production=(BASE/'patched/Processors/Game/Battle/Character/TRole.as').read_text(encoding='utf-8')
        start=production.index('      public function ChangeHP(')
        hp=production[start:production.index('      protected function OnMouseMove(',start)]
        restore=(BASE/'revival-visual.as.txt').read_text().replace('private function','public function')
        restore+=(BASE/'death-visual.as.txt').read_text().replace('private function','public function').replace('TRole','ProbeRole')
        methods+=hp+restore+'''
      public function PlayFightIdle():void {
         if(CurHealth<=0)report("ERROR idle restored before HP");
         FIndex=3;FFrameIndex=-1;FTickReference=0;
      }
      public function SimulateRevival(surface:BitmapData, race:Boolean):void {
         FIdlePosition=[x,y];CurHealth=0;FIsDie=!race;FWaitDie=true;
         FWaitNextCommand=true;FHideFrame=7;FHasFrozen=true;
         FIsAntiColorBlackWhite=true;FIsRedAntiColor=true;
         FSkillId=13120932;FSkilling=true;
         FCallBackDict[TYPE_ACTIVE_DIE]=function():void {report("ERROR stale death callback");};FTimeDict[TYPE_ACTIVE_DIE]=55;
         visible=false;alpha=0;FBitmap.visible=false;FBitmap.alpha=0;FBitmap.bitmapData=null;
         FCurSequence={GetAnimationFrameByIndex:function(i:int):Object{return {Surface:surface,Pivot:{X:128,Y:210}};}};
         TweenUtil.to(this,1000,{alpha:0});
         ChangeHP(-2500);
         if(CurHealth!=2500 || FIsDie || FWaitDie || FWaitNextCommand || FHasFrozen || FIsAntiColorBlackWhite || FIsRedAntiColor || !visible || alpha!=1 || !FBitmap.visible || FBitmap.alpha!=1 || FBitmap.bitmapData!=surface || FFrameIndex!=-1 || FSkillId!=0 || FSkilling || FCallBackDict[TYPE_ACTIVE_DIE]!=null || FTimeDict[TYPE_ACTIVE_DIE]!=0)
            report("ERROR revival state camp="+Camp);
         else report("RESTORE_OK camp="+Camp+" race="+race);
         var self:ProbeRole=this;
         setTimeout(function():void {
            if(!self.visible || self.alpha!=1 || self.FBitmap.bitmapData==null)self.report("ERROR delayed death tween");
            else self.report("RESTORE_STABLE camp="+self.Camp);
         },1200);
      }
'''
        fields+='''
      public var FBitmap:Bitmap=actor;
      public var FIsDie:Boolean=false;
      public var FKabutoDeathStop:Function;
      public var FSkilling:Boolean=false;
      public var FWaitDie:Boolean=false;
      public var FWaitNextCommand:Boolean=false;
      public var FHideFrame:int=-1;
      public var FHasFrozen:Boolean=false;
      public var FIsAntiColorBlackWhite:Boolean=false;
      public var FIsRedAntiColor:Boolean=false;
      public var FCallBackDict:Object={};
      public var FTimeDict:Object={};
      public const TYPE_ACTIVE_DIE:int=9;
      public var FShaderBmp:Sprite=new Sprite();
      public var FHpBar:Sprite=new Sprite();
      public var FBuffSprite:Sprite=new Sprite();
      public var FFrozenBitmap:Bitmap=new Bitmap();
      public var FGiddyBitmap:Bitmap=new Bitmap();
      public var FIdlePosition:Array;
      public var CurHealth:Number=10000;
      public var FShieldBlood:Number=0;
      public var FShieldBitmap:Bitmap=new Bitmap();
      public var FTickReference:uint=0;
      public var FCurSequence:Object;
'''
        source=source.replace(' import flash.external.ExternalInterface;', ' import flash.external.ExternalInterface;\n import ghostcat.util.easing.TweenUtil;')
        source=source.replace('    left.FSkillId=0;right.FSkillId=0;', '''
    caster.SimulateRevival(clips.idle.images[0],slot%2==1);caster.FIndex=1;
    caster.FTargets=[caster,victim,victim];caster.FResults=resultsForProbe();
    if(index==5){
       var summonProbe:ProbeRole=new ProbeRole();summonProbe.FId=11120911;summonProbe.Camp=side;summonProbe.Pos=5;
       summonProbe.x=side==0?550:700;summonProbe.y=440;summonProbe.visible=false;battle.addChild(summonProbe);
       caster.FTargets=[caster,summonProbe];caster.FResults=[{CMD:0,ResultInfo:{HurtHp:0}},{CMD:0,ResultInfo:{HurtHp:0}}];
    }
    left.FSkillId=0;right.FSkillId=0;''')
        source=source.replace('  private function report(text:String):void', '''
  private function resultsForProbe():Array{return [{CMD:0,ResultInfo:{HurtHp:0}},{CMD:1,ResultInfo:{HurtHp:10}},{CMD:9,ResultInfo:{HurtHp:0}}];}
  private function report(text:String):void''',1)
        source=source.replace('  private var lastSlot:int=-1;', '  private var lastSlot:int=-1;\n  private var deathProbePending:Boolean=false;')
        source=source.replace('   if(readyAt<0)readyAt=getTimer();', '   if(readyAt<0)readyAt=getTimer();\n   if(deathProbePending)return;')
        source=source.replace('caster.SimulateRevival(clips.idle.images[0],slot%2==1);caster.FIndex=1;', '''
    deathProbePending=true;
    var deathProbeStarted:int=getTimer();
    caster.CurHealth=0;caster.FIsDie=false;caster.FIdlePosition=[caster.x,caster.y];
    caster.PlayKabutoDeath(null,0);
    setTimeout(function():void {
       var corpseFrames:Array=ProbeRole.FKabutoFxCache.death;
       if(!caster.FIsDie || !caster.visible || caster.alpha!=1 || !caster.FBitmap.visible || caster.FBitmap.alpha!=1 || caster.FBitmap.bitmapData!=corpseFrames[corpseFrames.length-1])report("ERROR corpse missing");
       else report("DEATH_HOLD_OK camp="+caster.Camp);
       saveFrame("DEATH-camp-"+caster.Camp+"-slot-"+slot);
       caster.SimulateRevival(clips.idle.images[0],slot%2==1);caster.FIndex=1;
       caster.FSkillId=skills[index];caster.FKabutoVfxStarted=false;caster.FKabutoVfxHit=false;
       readyAt+=getTimer()-deathProbeStarted;deathProbePending=false;
    },1100);''')
        source=source.replace('   var frame:int=int((age%3000)/40);', '   if(deathProbePending)return;\n   var frame:int=int((age%3000)/40);')
    role = '\n internal class ProbeRole extends Sprite {\n'+fields+'''
      public function ProbeRole(){super();actor.smoothing=true;addChild(actor);}
      public function report(text:String):void {if(ExternalInterface.available)ExternalInterface.call("vfxProbe",text);}
    '''+methods+'\n }\n'
    source = source.replace('__METHODS__','').rstrip()
    source = source[:-1]+role+'}\n'
    target = BASE/('revival-probe-source' if args.revival_check else 'raster-probe-source')/'TApplication.as'
    target.parent.mkdir(exist_ok=True)
    target.write_text(source)
    output = BASE/('revival-probe.swf' if args.revival_check else 'raster-probe.swf')
    subprocess.run(['java','-Xmx2g','-jar',args.ffdec,'-onerror','abort','-importScript',
                    str(BASE/'source.swf'),str(output),str(target.parent)],check=True)
    binary = bytearray(output.read_bytes())
    binary[3] = 21
    output.write_bytes(binary)
    print('PASS isolated native raster probe compiled; production client untouched')


if __name__ == '__main__':
    main()
