"""Create an isolated instrumented renderer; never install diagnostic code publicly."""
from pathlib import Path
import argparse,subprocess
BASE=Path(__file__).resolve().parent
def main():
    p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);args=p.parse_args()
    def ffdec(*items):subprocess.run(['java','-Xmx2g','-jar',args.ffdec,*map(str,items)],check=True)
    role=Path('Processors/Game/Battle/Character/TRole.as');root=Path('Processors/Game/TProcessorGameRoot.as')
    ffdec('-selectclass','Processors.Game.TProcessorGameRoot','-export','script',BASE/'frames/probe-original',BASE/'compiled.swf')
    s=(BASE/'verify/scripts'/role).read_text(encoding='utf-8')
    start=s.index('private function ShowKabutoVfx(');at=s.index('         if(targets.length == 0)',start)
    s=s[:at]+'''         if(flash.external.ExternalInterface.available) flash.external.ExternalInterface.call("bossProbe","KABUTO_VFX skill=" + skill + " impact=" + impact + " camp=" + Camp + " targets=" + targets.length);
'''+s[at:]
    s=s.replace('            host.y = originY;', '''            host.y = originY;
            if(flash.external.ExternalInterface.available) flash.external.ExternalInterface.call("bossProbe","KABUTO_CAMERA restored=" + host.x + "," + host.y);''')
    for name,token,label in [('public function ChangeHP(', '               FIsDie = false;', 'KABUTO_RESTORE'),
                             ('public function PrepareDormantKabuto(', '            this.visible = false;', 'KABUTO_DORMANT'),
                             ('public function AddTextEffectByCMD(', '            FIsDie = true;', 'KABUTO_DESPAWN')]:
        start=s.index(name);at=s.index(token,start)+len(token)
        s=s[:at]+'\n            if(flash.external.ExternalInterface.available) flash.external.ExternalInterface.call("bossProbe","'+label+' id=" + FId);'+s[at:]
    out=BASE/'frames/probe-scripts'/role;out.parent.mkdir(parents=True,exist_ok=True);out.write_text(s,encoding='utf-8')
    s=(BASE/'frames/probe-original/scripts'/root).read_text(encoding='utf-8')
    start=s.index('function PacketPerform_ProcessorBattle(');at=s.index('this.FProcessorBattle.PacketProcess(param1);',start)
    s=s[:at]+'''this.FProcessorBattle.SetStatusType(100,0);
         this.FProcessorBattle.Visible = true;
         '''+s[at:]
    out=BASE/'frames/probe-scripts'/root;out.parent.mkdir(parents=True,exist_ok=True);out.write_text(s,encoding='utf-8')
    ffdec('-onerror','abort','-importScript',BASE/'compiled.swf',BASE/'probe.swf',BASE/'frames/probe-scripts')
    print('PASS isolated probe built; production SWF untouched.')
if __name__=='__main__':main()
