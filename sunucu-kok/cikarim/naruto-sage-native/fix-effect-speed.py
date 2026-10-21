"""Make native battle effects follow the selected playback speed."""
from pathlib import Path
import importlib.util,re
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('h',B/'build-client.py');h=importlib.util.module_from_spec(s);s.loader.exec_module(h)
R=Path('Processors/Game/Battle/Effect/TEffectControl.as')
def main():
 c=h.h.PUBLIC/'2026090619/TApplication.swf';old=c.read_bytes();raw=h.h.swap(old);src=B/'effect-speed-source.swf';src.write_bytes(raw)
 h.ff('-selectclass','Processors.Game.Battle.Effect.TEffectControl','-export','script',B/'effect-speed-original',src)
 before=(B/'effect-speed-original/scripts'/R).read_text(encoding='utf8');code=before
 for name in ['UpdataRoleEffect','UpdataPublicEffect']:
  method=h.m.extract(code,name)
  changed=re.sub(r'(\+= 1000 / \([^;]+\))\s*;',r'\1 * Math.max(0.1,TBattleHandle.PlaybackRate);',method)
  assert changed!=method,name
  code=code.replace(method,changed,1)
 dest=B/'effect-speed-patched'/R;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(code,encoding='utf8')
 out=B/'effect-speed-fixed.swf';h.ff('-onerror','abort','-importScript',src,out,B/'effect-speed-patched');rebuilt=out.read_bytes()
 assert [t for t in h.h.tags(raw) if t[0]!=82]==[t for t in h.h.tags(rebuilt) if t[0]!=82]
 backup=B/'backups/TApplication-before-effect-speed.swf'
 if not backup.exists():backup.write_bytes(old)
 c.write_bytes(h.h.swap(rebuilt));print('PASS native role/public effect clocks follow current battle playback speed')
if __name__=='__main__':main()
