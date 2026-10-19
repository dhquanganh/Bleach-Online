from pathlib import Path
import argparse,json,subprocess
import build
BASE=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);args=p.parse_args()
features=[dict(item=item,icon=build.icon_id(item),name=name,slot=slot) for slot,(item,name) in enumerate([(14130920,'Obito Rage'),(14130930,'Pain Tendo'),(14130940,'Hashirama Final Battle')])]
s=(BASE/'icon-probe.as.txt').read_text().replace('__FEATURES__',json.dumps(features))
dest=BASE/'icon-probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(s)
subprocess.run(['java','-Xmx2g','-jar',args.ffdec,'-onerror','abort','-importScript',str(BASE.parent/'player-profile/source.swf'),str(BASE/'icon-probe.swf'),str(dest.parent)],check=True)
data=bytearray((BASE/'icon-probe.swf').read_bytes());data[3]=21;(BASE/'icon-probe.swf').write_bytes(data)
print('PASS native icon probe compiled')
