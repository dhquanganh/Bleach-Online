"""Patch the active client, preserving later Hashirama and other fixes."""
from pathlib import Path
import hashlib, importlib.util, json, re, shutil

B=Path(__file__).resolve().parent
W=B/'revival-repair'
s=importlib.util.spec_from_file_location('shared',B/'build-client.py')
shared=importlib.util.module_from_spec(s);s.loader.exec_module(shared)
c=shared.c

def main():
    W.mkdir(exist_ok=True)
    version=json.loads((c.h.PUBLIC/'client-release.json').read_text())['version']
    raw=(c.h.PUBLIC/version/'TApplication.swf').read_bytes()
    assert raw==(c.h.PUBLIC/'2026090619/TApplication.swf').read_bytes()
    source=c.h.swap(raw);(W/'source.swf').write_bytes(source)
    rel=c.b.ROLE;cls=str(rel.with_suffix('')).replace('\\','.').replace('/','.')
    c.ff('-selectclass',cls,'-export','script',W/'original',W/'source.swf')
    old=(W/'original/scripts'/rel).read_text(encoding='utf-8')
    assert 'HashiramaNativeLayer' in old
    hp=c.m.extract(old,'ChangeHP')
    hp_new=re.sub(r'\(FId == 11120992 \|\| FId == 11120993 \|\| FId == 11120995 \|\| FId == 11120996 \|\| FId == 11120997 \|\| FId == 11120998\) && ', '', hp, count=1)
    assert hp_new!=hp or 'if(param1 < 0 && (CurHealth <= 0 || FIsDie || FWaitDie))' in hp
    if hp_new!=hp:
        hp_new=hp_new.replace('RestoreTsunadeAfterRevival();','if(FId==11120930)RestorePainAfterRevival();else RestoreTsunadeAfterRevival();',1)
    new=old.replace(hp,hp_new,1)
    anim=json.loads((B/'animation.json').read_text())
    ends={str(i):anim['clips'][name]['returnFrame'] for i,name in anim['moves'].items()}
    helper=(B/'native.as.txt').read_text().replace('FCurSequence.FrameCount-1','Number(JSON.parse('+json.dumps(json.dumps(ends,separators=(',',':')))+')[String(FSkillId)])')
    helper=helper.replace('__REATTACH_HIT__',str(anim['clips']['reattach']['hitFrames'][0]))
    changed={'ChangeHP','PreloadKakuzuNative','UpdateKakuzuVfx','KakuzuContactOffset','PlayKakuzuNative'}
    for name in changed-{'ChangeHP'}:
        new=new.replace(c.m.extract(new,name),c.m.extract(helper,name),1)
    dest=W/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(new,encoding='utf-8')
    c.ff('-onerror','abort','-importScript',W/'source.swf',W/'compiled.swf',W/'patched')
    compiled=(W/'compiled.swf').read_bytes()
    assert [t for t in c.h.tags(source) if t[0]!=82]==[t for t in c.h.tags(compiled) if t[0]!=82]
    c.ff('-selectclass',cls,'-export','script',W/'verify',W/'compiled.swf')
    verify=(W/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
    for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',old):
        if name not in changed:
            assert c.m.extract(old,name)==c.m.extract(verify,name),name
            count+=1
    assert 'HashiramaNativeLayer' in verify
    assert 'if(param1 < 0 && (CurHealth <= 0 || FIsDie || FWaitDie))' in verify
    shutil.copy2(B.parents[2]/'asset/Kakuzu_Edo_Tensei_Full/assets/battle/effect/DASHEWAN_tongyongfuhuo.swf',c.h.PUBLIC/'kakuzu-edo-vfx/native/DASHEWAN_tongyongfuhuo.swf')
    result={'sourceVersion':version,'sourceSha256':hashlib.sha256(source).hexdigest(),'sha256':hashlib.sha256(compiled).hexdigest(),'unchangedMethods':count,'changedMethods':sorted(changed)}
    (W/'client-validation.json').write_text(json.dumps(result,indent=2)+'\n')
    print('PASS current client preserved;',count,'unchanged methods; version',version)

if __name__=='__main__':main()
