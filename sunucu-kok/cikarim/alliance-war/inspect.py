from pathlib import Path
import importlib.util,subprocess
B=Path('sunucu-kok/cikarim/alliance-war');s=importlib.util.spec_from_file_location('h',B.parent/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(s);s.loader.exec_module(h);(B/'source.swf').write_bytes(h.swap((h.PUBLIC/'2026090619/TApplication.swf').read_bytes()))
subprocess.run(['java','-Xmx3g','-jar','C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar','-selectclass','Processors.Game.Lobby.TeamBattle.++,Processors.Game.Lobby.TeamBattleHall.++,Processors.Game.Lobby.TeamBattleRoom.++,Logics.Streamization.TeamBattle.++,Logics.TeamBattle.++,Resources.Constants.CONST_NETWORK','-export','script',str(B/'original'),str(B/'source.swf')],check=True,stdout=subprocess.DEVNULL)
