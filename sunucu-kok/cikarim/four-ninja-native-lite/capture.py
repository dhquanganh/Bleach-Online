"""Capture the actual active client before applying the isolated animation patch."""
from pathlib import Path
import importlib.util,json,re
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('client',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c

def main():
    active=json.loads((c.h.PUBLIC/'client-release.json').read_text())['version']
    client=(c.h.PUBLIC/active/'TApplication.swf').read_bytes()
    assert client==(c.h.PUBLIC/'2026090619/TApplication.swf').read_bytes()
    raw=c.h.swap(client)
    if (B/'source.swf').exists():assert (B/'source.swf').read_bytes()==raw,'Snapshot differs; do not overwrite an existing baseline'
    else:(B/'source.swf').write_bytes(raw)
    rel=c.b.ROLE
    if not (B/'original/scripts'/rel).exists():
        cls=str(rel.with_suffix('')).replace('\\','.').replace('/','.')
        c.ff('-selectclass',cls,'-export','script',B/'original',B/'source.swf')
    role=(B/'original/scripts'/rel).read_text(encoding='utf-8');assert 'PlayFourNinjaNative' not in role
    for prefix in ['Sasuke','Mecha','Itachi','Gaara']:
        method=c.m.extract(role,prefix+'VfxManifest')
        match=re.search(r'JSON.parse\(("(?:\\.|[^"\\])*")\)',method);assert match
        data=json.loads(json.loads(match[1]))
        (B/(prefix.lower()+'-manifest.json')).write_text(json.dumps(data,indent=2)+'\n')
    print('PASS captured active animation client',active)

if __name__=='__main__':main()
