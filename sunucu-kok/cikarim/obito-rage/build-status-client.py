"""Update status text on the live client without reverting newer client patches."""
from pathlib import Path
import argparse,ast,hashlib,importlib.util,re,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('client',BASE.parent/'naruto-sage/verify-client.py');helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
ROLE=Path('Processors/Game/Battle/Character/TRole.as');STAGE=Path('Processors/Game/Battle/TBattleStage.as');VERSION=b'2026101923'
def end_block(text,start):
    p=text.index('{',start)+1;depth=1
    while depth:
        depth+=(text[p]=='{')-(text[p]=='}');p+=1
    return p
def main():
    p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--install',action='store_true');args=p.parse_args()
    canonical=helper.PUBLIC/'2026090619/TApplication.swf';original=canonical.read_bytes();decoded=helper.swap(original)
    source=BASE/'status-source.swf';source.write_bytes(decoded)
    def ffdec(*a):subprocess.run(['java','-Xmx2g','-jar',args.ffdec,*map(str,a)],check=True)
    ffdec('-selectclass','Processors.Game.Battle.Character.TRole,Processors.Game.Battle.TBattleStage','-export','script',BASE/'status-original',source)
    text=(BASE/'status-original/scripts'/ROLE).read_text(encoding='utf-8')
    assert 'function ShowObitoStatusText(' not in text,'Status patch already installed'
    helper_text=(BASE/'status-text.as.txt').read_text(encoding='utf-8')
    text=text.replace('      override public function UpdateActive()',helper_text+'      override public function UpdateActive()')
    tree=ast.parse((BASE/'build-client.py').read_text())
    labels=next(ast.literal_eval(n.value) for n in ast.walk(tree) if isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='labels' for t in n.targets))
    labels=labels.replace('obitoNames','obitoNoticeNames')
    start=text.index('         if(param1.CMD == TTargetInfo.CMD_FLOAT && param1.ResultInfo.BuffId >= 19000501')
    end=end_block(text,start);text=text[:start]+labels+text[end:]
    token='               _loc8_ = uint(param2[_loc3_].ResultInfo.BuffTurn);';assert text.count(token)==1
    text=text.replace(token,token+'''
               if(FId == 11120920 && _loc7_ > 0)
               {
                  var obitoBuff:TBuffEffect=this.FBuffBins.GetDatebaseByIdentifier(_loc7_) as TBuffEffect;
                  if(obitoBuff != null) ShowObitoStatusText(obitoBuff.Name+(_loc8_ == 0?" / ENDED":""),obitoBuff.BuffType == 8?0xFFAA88:0xB9F47A);
               }
''')
    start=text.index('      public function ShieldOP(');body=text.index('      {',start)+len('      {')
    text=text[:body]+'\n         if(FId == 11120920) ShowObitoStatusText(param1.ResultInfo.BuffTurn > 0 ? "SHIELD "+param1.ResultInfo.BuffTurn : "SHIELD ENDED",0x85DDFF);'+text[body:]
    start=text.index('            chaseLabel.text = isJiraiyaLabel ?');end=text.index('\n',start)
    text=text[:end]+'''
            if(FId == 11120920)
            {
               ShowObitoStatusText(chaseLabel.text.replace("\\n"," / "),stateColors[stateIndex]);
               return;
            }
'''+text[end:]
    stage=(BASE/'status-original/scripts'/STAGE).read_text(encoding='utf-8')
    token='kabutoRasterHost.getChildAt(kabutoRasterIndex).name == "obitoSkillVfx"';assert token in stage
    stage=stage.replace(token,'('+token+' || kabutoRasterHost.getChildAt(kabutoRasterIndex).name.indexOf("obitoStatus_") == 0)')
    for name,value in [(ROLE,text),(STAGE,stage)]:
        f=BASE/'status-patched'/name;f.parent.mkdir(parents=True,exist_ok=True);f.write_text(value,encoding='utf-8')
    output=BASE/'status-compiled.swf';ffdec('-onerror','abort','-importScript',source,output,BASE/'status-patched');rebuilt=output.read_bytes()
    assert [t for t in helper.tags(decoded) if t[0]!=82]==[t for t in helper.tags(rebuilt) if t[0]!=82]
    ffdec('-selectclass','Processors.Game.Battle.Character.TRole,Processors.Game.Battle.TBattleStage','-export','script',BASE/'status-verify',output)
    verified=(BASE/'status-verify/scripts'/ROLE).read_text(encoding='utf-8')
    assert all(t in verified for t in ['ShowObitoStatusText','3200','2600','LIFE STEAL','KAMUI FATAL GUARD','UpdateObitoVfx'])
    if args.install:
        assert canonical.read_bytes()==original
        manifest=helper.PUBLIC/'2026090619/version.swf';raw=zlib.decompress(manifest.read_bytes());p=2;parts=[raw[:2]]
        for _ in range(struct.unpack_from('<H',raw)[0]):
            n=struct.unpack_from('<H',raw,p)[0];p+=2;k=raw[p:p+n];p+=n;n=struct.unpack_from('<H',raw,p)[0];p+=2;v=raw[p:p+n];p+=n
            if k==b'TApplication.swf':v=VERSION
            parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
        for f in [canonical,manifest]:
            backup=BASE/'status-backups'/f.relative_to(helper.ROOT);backup.parent.mkdir(parents=True,exist_ok=True)
            if not backup.exists():shutil.copy2(f,backup)
        dest=helper.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(helper.swap(rebuilt));canonical.write_bytes(helper.swap(rebuilt));manifest.write_bytes(zlib.compress(b''.join(parts)))
    print('PASS 3.2s stacked Obito status text, incoming buffs/shields, combo labels and cleanup; installed',args.install)
if __name__=='__main__':main()
