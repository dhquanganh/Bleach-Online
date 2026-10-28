"""Character-independent, wall-clock four-second buff labels."""
from pathlib import Path
import importlib.util,json,re
B=Path(__file__).resolve().parent;ROOT=B.parents[1]
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
def main():
 P=c.h.PUBLIC;assert json.loads((P/'client-release.json').read_text())['version']=='2026102808'
 (B/'source.swf').write_bytes(c.h.swap((P/'2026090619/TApplication.swf').read_bytes()))
 rel=c.b.ROLE;cls=str(rel.with_suffix('')).replace('\\','.').replace('/','.')
 c.ff('-selectclass',cls,'-export','script',B/'original',B/'source.swf')
 before=(B/'original/scripts'/rel).read_text(encoding='utf-8');assert 'ShowBuffNoticeText' not in before
 cfg=json.loads((ROOT/'sunucu/buff-notices.json').read_text());names={**cfg['stats'],**cfg['states']};messages={str(cfg['baseId']+i+1):v for i,v in enumerate(names.values())}
 runtime=(B/'runtime.as.txt').read_text().replace('__MESSAGES__',json.dumps(json.dumps(messages,separators=(',',':'))))
 role=before.replace('      override public function UpdateActive()',runtime+'\n      override public function UpdateActive()',1)
 for name in ['Reset','PrepareBattleRole']:role=c.inject(role,name,'         ClearBuffNoticeText();')
 role=c.inject(role,'AddTextEffectByCMD','         if(param1.CMD==TTargetInfo.CMD_FLOAT && param1.ResultInfo.BuffId>'+str(cfg['baseId'])+' && param1.ResultInfo.BuffId<='+str(cfg['baseId']+len(names))+'){ShowBuffNoticeText(param1.ResultInfo.BuffId);return;}')
 dest=B/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(role,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 c.ff('-selectclass',cls,'-export','script',B/'verify',B/'compiled.swf')
 after=(B/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name not in ['Reset','PrepareBattleRole','AddTextEffectByCMD']:assert c.m.extract(before,name)==c.m.extract(after,name),name;count+=1
 (B/'validation.json').write_text(json.dumps({'unchangedMethods':count,'changedMethods':['Reset','PrepareBattleRole','AddTextEffectByCMD'],'markers':messages,'durationMs':4000},indent=2)+'\n')
 print('PASS generic buff labels;',count,'unrelated methods unchanged')
if __name__=='__main__':main()
