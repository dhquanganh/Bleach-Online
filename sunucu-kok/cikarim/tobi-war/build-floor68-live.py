"""Instrument a private copy of the active client for the real floor 68 replay."""
from pathlib import Path
import importlib.util,json,shutil,re,sys
B=Path(__file__).resolve().parent;W=B/'floor68-live';ROOT=B.parents[2]
s=importlib.util.spec_from_file_location('client',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
PUB=c.h.PUBLIC
active=json.loads((PUB/'client-release.json').read_text())['version']
W.mkdir(exist_ok=True)
(W/'state').mkdir(exist_ok=True)
for name in ['oyuncu.json','veri.json']:
 if not (W/'state'/name).exists():shutil.copy2(ROOT/'.accounts/6ad4de542b68ce1713162e25'/name,W/'state'/name)
source=W/'source.swf';source.write_bytes((B/'repair-passive-queue/compiled.swf').read_bytes() if '--candidate' in sys.argv else c.h.swap((PUB/active/'TApplication.swf').read_bytes()))
short=Path('Processors/Game/Lobby/Shortcuts/TProcessorShortcuts.as');tower=Path('Processors/Game/Lobby/SkyTower/TProcessorSkyTower.as')
classes=[c.b.STAGE,c.b.ROLE,short,tower]
c.ff('-selectclass',','.join(str(x.with_suffix('')).replace('\\','.').replace('/','.') for x in classes),'-export','script',W/'original',source)
for rel in classes:
 text=(W/'original/scripts'/rel).read_text(encoding='utf-8')
 if rel==c.b.STAGE:
  text=text.replace('CommandObj = this.FCommandList.shift();','''CommandObj = this.FCommandList.shift();
         flash.external.ExternalInterface.call("bossProbe","CMD left="+FCommandList.length+" turn="+CommandObj.turnNumber+" skill="+CommandObj.skillid+" passive="+CommandObj.PassiveSkill+" die="+CommandObj.checkDie+" buff="+CommandObj.checkBuff+" actor="+(CommandObj.play?CommandObj.play.Camp+":"+CommandObj.play.Pos:"-"));''',1)
  text=c.inject(text,'ProcessorBattleSkip','         flash.external.ExternalInterface.call("bossProbe","BATTLE_END");')
 elif rel==c.b.ROLE:
  text=c.inject(text,'CommandPlay','         flash.external.ExternalInterface.call("bossProbe","PLAY hero="+FId+" pos="+Camp+":"+Pos+" hp="+CurHealth+" dead="+FIsDie+" skill="+param1);')
  text=c.inject(text,'OnNextCommand','         flash.external.ExternalInterface.call("bossProbe","NEXT hero="+FId+" pos="+Camp+":"+Pos);')
 elif rel==short:
  method=c.m.extract(text,'TProcessorShortcuts');at=method.rfind('}')
  changed=method[:at]+'''         flash.external.ExternalInterface.addCallback("goldProbeEnter",function():void{TProcessorSkyTower.GoldMode=true;if(FOnSkyTower!=null)FOnSkyTower(this);});
      '''+method[at:];text=text.replace(method,changed,1)
 else:
  method=c.m.extract(text,'TProcessorSkyTower');at=method.rfind('}')
  changed=method[:at]+'''         flash.external.ExternalInterface.addCallback("goldProbeFight",function():void{GoldChallenge(null);});
      '''+method[at:];text=text.replace(method,changed,1)
  method=c.m.extract(text,'GoldChallenge')
  changed=re.sub(r'p.Data.writeUTF\(.*?\);', 'p.Data.writeUTF("{\\\"floor\\\":68}");', method, flags=re.S)
  assert changed!=method
  text=text.replace(method,changed,1)
 dest=W/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(text,encoding='utf-8')
c.ff('-onerror','abort','-importScript',source,W/'probe.swf',W/'patched')
raw=bytearray((W/'probe.swf').read_bytes());raw[3]=21;(W/'probe.swf').write_bytes(raw)
(W/'source-version.json').write_text(json.dumps({'version':active,'candidate':'--candidate' in sys.argv})+'\n')
print('PASS private full-client floor 68 trace compiled',active)
