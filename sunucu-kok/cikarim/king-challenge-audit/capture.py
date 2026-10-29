from pathlib import Path
import importlib.util
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
paths=[Path('Processors/Game/Lobby/KingChallenge/'+name+'.as') for name in ['TProcessorWindowKingChallenge','TProcessorKingChallenge','TUIDetail','TUIMyGamble','TUIPrizeList']]+[Path('Logics/Streamization/KingChallenge/TUnsteamizerKingChallenge.as'),Path('Logics/KingChallenge/TKingChallenge.as')]
def main():
 (B/'source.swf').write_bytes(c.h.swap((c.h.PUBLIC/'2026090619/TApplication.swf').read_bytes()))
 classes=','.join(str(p.with_suffix('')).replace('\\','.').replace('/','.') for p in paths);c.ff('-selectclass',classes,'-export','script',B/'original',B/'source.swf');print('PASS captured current tournament client')
if __name__=='__main__':main()
