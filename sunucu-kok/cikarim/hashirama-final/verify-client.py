"""Check the installed client, native preview, shop exclusion and source provenance."""
from pathlib import Path
import importlib.util,json,re,struct,zlib,hashlib
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
spec=importlib.util.spec_from_file_location('h',BASE.parent/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
result=json.loads((BASE/'validation/native/result.json').read_text())
assert result['completed'] and result['cases']==24 and result['assetPlays']==32
forest=json.loads((BASE/'validation/forest/result.json').read_text())
assert forest['completed'] and forest['cases']==4 and forest['assetPlays']==8 and not forest['errors'] and forest['remainingLayers']==0
assert result['atlasesLoaded']==12 and result['remainingLayers']==0 and not result['errors'],result
log=(BASE/'validation/native/runtime.log').read_text()
cases=re.findall(r'CASE (131210\d\d) camp=(\d)',log)
assert set(cases)=={(str(i),str(c)) for i in range(13121001,13121011) for c in [0,1]}
for sid,camp in cases:assert (BASE/'validation/native'/f'HIT-{sid}-camp-{camp}.jpg').exists()
role=(BASE/'verify/scripts/Processors/Game/Battle/Character/TRole.as').read_text()
for token in ['HashiramaStrikePose','effectAnchors','UpdateHashiramaVfx','ShowHashiramaStatusText','PainFlightPose','RestorePainAfterRevival','ShowPainLaserImpact','UpdateObitoVfx']:assert token in role,token
start=role.index('private function HashiramaStrikePose(')
pose=role[start:role.index('override public function UpdateActive()',start)]
assert 'gap' in pose and 'point.x - gap' in pose and 'frame.Surface.width / 2' not in pose
active=(BASE/'verify/scripts/Processors/Game/Battle/Character/TActive.as').read_text()
assert '13121006' in active and '13121007' in active and '13121010' in active and 'FPainFinal' in active
formation=(BASE/'verify/scripts/Processors/Game/Lobby/TacticalDeployment/Components/THeroDeployment.as').read_text()
assert formation.count('11120940')==7 and 'FMaxPlay <= this.FHeroDeployment.Count' in formation
stage=(BASE/'verify/scripts/Processors/Game/Battle/TBattleStage.as').read_text()
assert 'hashiramaSkillVfx' in stage and 'hashiramaStatus_' in stage and 'painSkillVfx' in stage
tower=(BASE/'verify/scripts/Processors/Game/Lobby/SkyTower/TProcessorSkyTower.as').read_text()
assert 'GoldPrimogem' in tower and 'current.atk' in tower
canonical=h.PUBLIC/'2026090619/TApplication.swf';installed=h.PUBLIC/'2026101961/TApplication.swf'
assert canonical.read_bytes()==installed.read_bytes()==h.swap((BASE/'compiled.swf').read_bytes())
raw=zlib.decompress((canonical.parent/'version.swf').read_bytes());pos=2;entries={}
for _ in range(struct.unpack_from('<H',raw)[0]):
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n;entries[k]=v
assert entries[b'TApplication.swf']==b'2026101961'
assert 'filter(h => h.id !== 11120940)' in (ROOT/'sunucu/admin.js').read_text(encoding='utf-8')
assert 'const h = heroListesi().find(x => x.id === id)' in (ROOT/'sunucu/admin.js').read_text(encoding='utf-8')
assert 'h.id !== 11120940' in (ROOT/'launcher.html').read_text(encoding='utf-8')
source=ROOT.parent/'asset/Hashirama_Senju_Final_Battle'
for item in json.loads((source/'manifest.json').read_text()):assert hashlib.sha256((source/item['file']).read_bytes()).hexdigest()==item['sha256']
result.update(clientVersion='2026101961',allFormationRows=True,goldShopExcluded=True,sourceChecksums=True)
(BASE/'validation/native/verified.json').write_text(json.dumps(result,indent=2))
print('PASS installed client 2026101961, 24 Flash cases, 32 raster plays, 12 atlases, no errors/leftovers; all formation-row guards, shop exclusion, source SHA256, preserved Pain/Obito/Tower and correct manifest')
