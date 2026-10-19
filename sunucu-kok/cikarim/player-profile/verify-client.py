from pathlib import Path
import importlib.util,struct,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('builder',BASE/'build-client.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
canonical=b.h.h.PUBLIC/'2026090619/TApplication.swf'
assert canonical.read_bytes()==(b.h.h.PUBLIC/'2026101965/TApplication.swf').read_bytes()
assert b.h.h.swap(canonical.read_bytes())==(BASE/'compiled.swf').read_bytes()
source=(BASE/'verify/scripts'/b.FILE).read_text()
start=source.index('      public function RequestShowHero(');end=b.h.method_end(source,start);method=source[start:end]
for token in ['FProcessorWindowPlayerAssets.Hide()','FProcessorWindowInventoryInfor.Hide()','FHeros.Clear()', 'writeUnsignedInt(param1)','writeUnsignedInt(param2)']:
 assert token in method,token
assert 'if(this.FProcessorWindowPlayerAssets.Visible)' not in method
assert 'FProcessorWindowInventoryInfor.Inventory = null' not in method
assert method.index('FHeros.Clear()')<method.index('PacketTransmit(')
handle=Path('Processors/Game/Battle/TBattleHandle.as')
assert (BASE/'verify/scripts'/handle).read_text()==(BASE.parent/'battle-speed/style-verify/scripts'/handle).read_text()
raw=zlib.decompress((canonical.parent/'version.swf').read_bytes());pos=2;found=False
for _ in range(struct.unpack_from('<H',raw)[0]):
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;key=raw[pos:pos+n];pos+=n
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;value=raw[pos:pos+n];pos+=n
 if key==b'TApplication.swf':assert value==b'2026101965';found=True
assert found
print('PASS installed Inspector 2026101965: target switching/reset, exact role ID request, version manifest and unchanged native x1/x2/Skip controls')
