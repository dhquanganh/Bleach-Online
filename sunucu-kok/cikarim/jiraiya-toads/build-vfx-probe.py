"""Compile a native Flash component preview using the exact production VFX methods.
This is a graphics/lifecycle probe with real installed sprites, not a combat replay.
"""
from pathlib import Path
import argparse,json,subprocess
BASE=Path(__file__).resolve().parent
parser=argparse.ArgumentParser();parser.add_argument('--ffdec',required=True);args=parser.parse_args()
anim=json.loads((BASE/'animation.json').read_text())['clips']
hits={13120911:6*anim['toad-mouth-barrier']['interpolationSteps'],13120912:anim['toad-confrontation-chant']['hitFrames'][0],13120913:anim['giant-gallant-rasengan']['hitFrames'][0],13120914:anim['raging-lions-mane']['hitFrames'][0],13120915:2*anim['senjutsu-power']['interpolationSteps'],13120916:4*anim['tale-of-jiraiya-revival']['interpolationSteps']}
methods=(BASE/'skill-vfx.as.txt').read_text().replace('__JIRAIYA_VFX_FRAMES__',json.dumps(hits)).replace('TRole','ProbeRole').replace('private function','public function').replace('private static function','public static function')
methods=methods.replace('__JIRAIYA_RASENGAN_HANDS__',json.dumps(json.loads((BASE/'assets/rasengan-slam/motion.json').read_text())['hands']))
methods=methods.replace('         var caster:ProbeRole = this;','         var caster:ProbeRole = this;\n         report("VFX skill="+skill+" impact="+impact+" camp="+Camp);')
methods=methods.replace('            host.x = originX;host.y = originY;','            host.x = originX;host.y = originY;\n            if(ExternalInterface.available) ExternalInterface.call("vfxProbe","CAMERA "+host.x+","+host.y);')
methods=methods.replace('            backdrop.addChild(loader);','            backdrop.addChild(loader);\n            if(ExternalInterface.available) ExternalInterface.call("vfxProbe","BACKDROP loaded 1250x650");')
source=(BASE/'vfx-probe.as.txt').read_text(encoding='utf-8-sig').replace('__METADATA__',json.dumps(anim,separators=(',',':')))
source=source.replace('private var left:TApplication;','private var left:ProbeRole;').replace('private var right:TApplication;','private var right:ProbeRole;').replace('new TApplication(false)','new ProbeRole()').replace('role:TApplication','role:ProbeRole').replace('caster:TApplication','caster:ProbeRole').replace('victim:TApplication','victim:ProbeRole')
source=source.replace('SetJiraiyaBarrier(battle,','ProbeRole.SetJiraiyaBarrier(battle,')
fields=source[source.index('  private var FId:'):source.index('  private var clips:')].replace('private var','public var').replace('private const','public const')
role='''
 internal class ProbeRole extends Sprite {
'''+fields+'''
  public function ProbeRole(){super();actor.smoothing=true;addChild(actor);}
  public function report(text:String):void {if(ExternalInterface.available)ExternalInterface.call("vfxProbe",text);}
'''+methods+'\n }\n'
source=source.replace('__METHODS__','').rstrip()
source=source[:-1]+role+'}\n'
target=BASE/'probe-source/TApplication.as';target.parent.mkdir(exist_ok=True);target.write_text(source,encoding='utf-8')
subprocess.run(['java','-Xmx2g','-jar',args.ffdec,'-onerror','abort','-importScript',str(BASE/'source.swf'),str(BASE/'vfx-probe.swf'),str(target.parent)],check=True)
# PNGEncoderOptions is available to SWF 16+; production keeps its original SWF version.
probe=BASE/'vfx-probe.swf';binary=bytearray(probe.read_bytes());binary[3]=21;probe.write_bytes(binary)
