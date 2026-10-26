"""Keep White Zetsu death playback finite in Tower of Gold replays."""
from pathlib import Path
import importlib.util, hashlib, json, re, shutil

B = Path(__file__).resolve().parent
W = B / 'repair-gold-zetsu'
VERSION = '2026102608'
spec = importlib.util.spec_from_file_location('client', B / 'build-client.py')
client = importlib.util.module_from_spec(spec)
spec.loader.exec_module(client)
c = client.c
spec = importlib.util.spec_from_file_location('release', B / 'release.py')
release = importlib.util.module_from_spec(spec)
spec.loader.exec_module(release)


def patch_role(source):
    marker = '      private var FWhiteZetsuStarted:Number = -1;'
    assert source.count(marker) == 1
    source = source.replace(marker, marker + '\n\n      private var FWhiteZetsuWallStarted:int = -1;', 1)
    method = c.m.extract(source, 'ClearWhiteZetsuPose')
    assert 'FWhiteZetsuStarted = -1;' in method
    source = source.replace(method, method.replace('FWhiteZetsuStarted = -1;', 'FWhiteZetsuStarted = -1;\n         FWhiteZetsuWallStarted = -1;', 1), 1)
    method = c.m.extract(source, 'PlayWhiteZetsuPose')
    assert 'FWhiteZetsuStarted = TBattleHandle.PlaybackTime;' in method
    fixed = method.replace('FWhiteZetsuStarted = TBattleHandle.PlaybackTime;', 'FWhiteZetsuStarted = TBattleHandle.PlaybackTime;\n         FWhiteZetsuWallStarted = getTimer();', 1)
    fixed = fixed.replace('FWhiteZetsuCallback = callback;', '''FWhiteZetsuCallback = callback;
         // A fatal counter can interrupt Zetsu's own action before its normal
         // completion callback. Carry that callback through the death pose.
         if(dying && FWhiteZetsuCallback == null && (FIndex == TYPE_ACTIVE_ATTACK || FIndex == TYPE_ACTIVE_SKILL))
         {
            FWhiteZetsuCallback = FWaitNextCommand && FActiveCallBack != null ? FActiveCallBack : FCallBackDict[FIndex];
            FWaitNextCommand = false;
         }''', 1)
    source = source.replace(method, fixed, 1)
    method = c.m.extract(source, 'UpdateWhiteZetsuPose')
    begin = '''         if(FWhiteZetsuSequence == null && FTextureSkill != null && FTextureSkill != FDefaultRoleTexture && FTextureSkill.Count >= 2)'''
    end = '''         if(index >= FWhiteZetsuFrames)'''
    assert method.count(begin) == 1 and method.count(end) == 1
    prefix, rest = method.split(begin, 1)
    _, suffix = rest.split(end, 1)
    replacement = '''         // A partially loaded texture can report two sequences while the death
         // sequence is still null. Never restart its timeout on every frame.
         if(FWhiteZetsuSequence == null && FTextureSkill != null && FTextureSkill != FDefaultRoleTexture && FTextureSkill.Count >= 2)
         {
            var ready:TAnimationSequence = FTextureSkill.GetAnimationSequenceByIndex(FWhiteZetsuDying ? 1 : 0);
            if(ready != null)
            {
               FWhiteZetsuSequence = ready;
               FWhiteZetsuStarted = TBattleHandle.PlaybackTime;
               FWhiteZetsuWallStarted = getTimer();
            }
         }
         // PlaybackTime may pause while the battle waits on this actor. The
         // wall clock guarantees that two simultaneous deaths finish.
         var elapsed:Number = Math.max(TBattleHandle.PlaybackTime - FWhiteZetsuStarted,getTimer() - FWhiteZetsuWallStarted);
         if(FWhiteZetsuSequence == null && elapsed < 2000)
         {
            return;
         }
         var index:int = FWhiteZetsuSequence == null ? FWhiteZetsuFrames : Math.max(0,int(elapsed / 40));
'''
    fixed = prefix + replacement + end + suffix
    source = source.replace(method, fixed, 1)
    return source


def compile_client():
    pub = c.h.PUBLIC
    active = json.loads((pub / 'client-release.json').read_text())['version']
    assert active == '2026102607'
    old = (pub / active / 'TApplication.swf').read_bytes()
    assert old == (pub / '2026090619/TApplication.swf').read_bytes()
    W.mkdir(exist_ok=True)
    source = W / 'source.swf'
    source.write_bytes(c.h.swap(old))
    rel = c.b.ROLE
    cls = str(rel.with_suffix('')).replace('\\', '.').replace('/', '.')
    c.ff('-selectclass', cls, '-export', 'script', W / 'original', source)
    before = (W / 'original/scripts' / rel).read_text(encoding='utf-8')
    after = patch_role(before)
    dest = W / 'patched' / rel
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_text(after, encoding='utf-8')
    c.ff('-onerror', 'abort', '-importScript', source, W / 'compiled.swf', W / 'patched')
    raw = (W / 'compiled.swf').read_bytes()
    assert [t for t in c.h.tags(source.read_bytes()) if t[0] != 82] == [t for t in c.h.tags(raw) if t[0] != 82]
    c.ff('-selectclass', cls, '-export', 'script', W / 'verify', W / 'compiled.swf')
    verified = (W / 'verify/scripts' / rel).read_text(encoding='utf-8')
    changed = {'ClearWhiteZetsuPose', 'PlayWhiteZetsuPose', 'UpdateWhiteZetsuPose'}
    untouched = 0
    for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(', before):
        if name not in changed:
            assert c.m.extract(before, name) == c.m.extract(verified, name), name
            untouched += 1
    assert 'FWhiteZetsuWallStarted' in verified
    assert 'FWhiteZetsuSequence == null ? FWhiteZetsuFrames' in c.m.extract(verified, 'UpdateWhiteZetsuPose')
    (W / 'validation.json').write_text(json.dumps({'sourceVersion': active, 'unchangedMethods': untouched, 'sha256': hashlib.sha256(raw).hexdigest()}, indent=2) + '\n')
    print('PASS White Zetsu bounded death playback; unchanged methods', untouched)


def publish():
    assert (W / 'compiled.swf').is_file() and (W / 'validation.json').is_file()
    pub = c.h.PUBLIC
    active = json.loads((pub / 'client-release.json').read_text())['version']
    assert active == '2026102607'
    canonical = pub / '2026090619'
    old = (pub / active / 'TApplication.swf').read_bytes()
    assert old == (canonical / 'TApplication.swf').read_bytes()
    assert c.h.swap(old) == (W / 'source.swf').read_bytes()
    manifest = (pub / active / 'version.swf').read_bytes()
    assert manifest == (canonical / 'version.swf').read_bytes()
    dest = pub / VERSION
    assert not dest.exists()
    backup = W / 'backup'
    backup.mkdir(exist_ok=True)
    for path in (canonical / 'TApplication.swf', canonical / 'version.swf', pub / 'client-release.json'):
        shutil.copy2(path, backup / path.name)
    rows = release.rows(manifest)
    for row in rows:
        if row[0] == b'TApplication.swf':
            row[1] = VERSION.encode()
    binary = c.h.swap((W / 'compiled.swf').read_bytes())
    new_manifest = release.encode(rows)
    dest.mkdir()
    for target in (dest, canonical):
        (target / 'TApplication.swf').write_bytes(binary)
        (target / 'version.swf').write_bytes(new_manifest)
    shutil.copy2(pub / active / 'index.swf', dest / 'index.swf')
    (pub / 'client-release.json').write_text(json.dumps({'version': VERSION}) + '\n')
    assert (canonical / 'TApplication.swf').read_bytes() == (dest / 'TApplication.swf').read_bytes()
    assert (canonical / 'version.swf').read_bytes() == (dest / 'version.swf').read_bytes()
    (W / 'result.json').write_text(json.dumps({'version': VERSION, 'floor': 68, 'fix': 'White Zetsu death pose timeout and interrupted-action callback', 'clientSha256': hashlib.sha256(binary).hexdigest()}, indent=2) + '\n')
    print('PASS published', VERSION)


if __name__ == '__main__':
    import sys
    publish() if '--publish' in sys.argv else compile_client()
