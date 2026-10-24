"""Install data-driven hero tags in the native hero attribute tab header."""
from pathlib import Path
import hashlib, importlib.util, json, re, shutil, struct, zlib

B = Path(__file__).resolve().parent
ROOT = B.parents[1]
spec = importlib.util.spec_from_file_location('tag_client', B.parent/'itachi-rtn/build-client.py')
c = importlib.util.module_from_spec(spec)
spec.loader.exec_module(c)
REL = Path('Processors/Game/Lobby/HerosNew/TWindowAttribute.as')
CLASS = 'Processors.Game.Lobby.HerosNew.TWindowAttribute'
PROFILE = Path('Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as')
PROFILE_CLASS = 'Processors.Game.Lobby.Common.Players.TProcessorWindowPlayerAssets'
VERSION = '2026102418'

def profile_patch(before, runtime):
    runtime = runtime.replace('host["MC_PVP"]', 'host["BtnPvP"]')
    runtime = runtime.replace('this.TFOnOut', 'this.TFHintOnOut')
    runtime = runtime.replace('SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);', 'this.TFHintOnOut(null);')
    runtime = runtime.replace('SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);', 'if(this.FHintOnOver != null)this.FHintOnOver(this,FHint);')
    runtime = runtime.replace('         var ids:Array = FHero == null ? null : FCharacterTagData.heroes[String(FHero.Identifier)] as Array;',
        '         var hero:THero = FHeros == null || FTabHeroIndex >= FHeros.Count ? null : FHeros.GetHeroByIndex(FTabHeroIndex);\n'
        '         var ids:Array = hero == null ? null : FCharacterTagData.heroes[String(hero.Identifier)] as Array;')
    runtime = runtime.replace('ids != null && FShowType != ShowType_WakeUp', 'ids != null')
    if 'InitCharacterTags' in before:
        after = before
        for name in ['InitCharacterTags', 'RenderCharacterTags']:
            after = after.replace(c.m.extract(before, name), c.m.extract('package P {\n'+runtime+'\n}', name), 1)
        return after, {'InitCharacterTags', 'RenderCharacterTags'}
    runtime += '''
      private function ClearProfileCharacterTags() : void
      {
         if(FCharacterTagRow == null)return;
         this.TFHintOnOut(null);
         while(FCharacterTagRow.numChildren > 0)FCharacterTagRow.removeChildAt(0);
         FCharacterTagRow.visible = false;
      }
'''
    after = before.replace('      public function TProcessorWindowPlayerAssets(', runtime+'\n      public function TProcessorWindowPlayerAssets(', 1)
    token = '         this.FAttributeTab.Init();'
    assert after.count(token) == 1
    after = after.replace(token, token+'\n         InitCharacterTags(_loc3_);', 1)
    token = '         this.FUIHero.Context = _loc1_;'
    assert after.count(token) == 1
    after = after.replace(token, token+'\n         RenderCharacterTags();', 1)
    after = c.inject(after, 'Reset', '         ClearProfileCharacterTags();')
    return after, {'Resources_UIDispatch', 'UpdateRoleModel', 'Reset'}

def main():
    public = c.h.PUBLIC
    configs = [json.loads((ROOT/('sunucu/'+name+'.json')).read_text()) for name in ['itachi-rtn', 'mecha-naruto', 'sasuke-shinden', 'obito-rage', 'gaara-swimsuit', 'hashirama-final', 'pain-tendo', 'naruto-sage', 'nagato-frog', 'tsunade-asian']]
    assets = ROOT.parent/'asset/All_Character_Tag_Assets'
    definitions = {t['id']: t for t in json.loads((assets/'tags.json').read_text(encoding='utf-8'))}
    ids = list(dict.fromkeys(i for cfg in configs for i in cfg['tags']))
    names = {key: value for cfg in configs for key, value in cfg.get('tagNames', {}).items()}
    data = {'heroes': {str(cfg['heroId']): cfg['tags'] for cfg in configs}, 'tags': {
        str(i): {'name': names.get(str(i), definitions[i]['name_en_translated']), 'icon': '/public/character-tags/'+str(i)+'.png'} for i in ids}}
    canonical = public/'2026090619/TApplication.swf'
    old = canonical.read_bytes()
    source = c.h.swap(old)
    work = B/VERSION
    work.mkdir(exist_ok=True)
    (work/'source.swf').write_bytes(source)
    classes = CLASS+','+PROFILE_CLASS
    c.ff('-selectclass', classes, '-export', 'script', work/'original', work/'source.swf')
    before = (work/'original/scripts'/REL).read_text(encoding='utf-8')
    runtime = (B/'runtime.as.txt').read_text().replace('__TAG_DATA__', json.dumps(json.dumps(data, separators=(',', ':'))))
    updating = 'InitCharacterTags' in before
    if updating:
        after = before
        for method in ['InitCharacterTags', 'RenderCharacterTags']:
            replacement = c.m.extract('package P {\n'+runtime+'\n}', method)
            after = after.replace(c.m.extract(before, method), replacement, 1)
    else:
        after = before.replace('      public function TWindowAttribute(', runtime+'\n      public function TWindowAttribute(', 1)
    if not updating:
        after = c.inject(after, 'UIDispatch', '         InitCharacterTags(param1);')
    token = '         this.FHero = param1;'
    assert after.count(token) == 1
    if not updating:
        after = after.replace(token, token+'\n         RenderCharacterTags();', 1)
    target = work/'patched'/REL
    target.parent.mkdir(parents=True, exist_ok=True)
    cached = target.exists() and target.read_text(encoding='utf-8') == after and (work/'compiled.swf').exists()
    target.write_text(after, encoding='utf-8')
    profile_before = (work/'original/scripts'/PROFILE).read_text(encoding='utf-8')
    profile_after, profile_allowed = profile_patch(profile_before, runtime)
    profile_target = work/'patched'/PROFILE
    profile_target.parent.mkdir(parents=True, exist_ok=True)
    profile_cached = profile_target.exists() and profile_target.read_text(encoding='utf-8') == profile_after
    profile_target.write_text(profile_after, encoding='utf-8')
    cached = cached and profile_cached
    if not cached:
        c.ff('-onerror', 'abort', '-importScript', work/'source.swf', work/'compiled.swf', work/'patched')
    rebuilt = (work/'compiled.swf').read_bytes()
    assert [t for t in c.h.tags(source) if t[0] != 82] == [t for t in c.h.tags(rebuilt) if t[0] != 82]
    c.ff('-selectclass', classes, '-export', 'script', work/'verify', work/'compiled.swf')
    verified = (work/'verify/scripts'/REL).read_text(encoding='utf-8')
    checked = 0
    for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(', before):
        if name not in ({'InitCharacterTags', 'RenderCharacterTags'} if updating else {'UIDispatch', 'SwitchAttribute'}):
            def normalized(method):
                # FFDec simplifies these redundant Number casts on recompilation.
                return method.replace('Number(NaN)', 'NaN').replace('Number(_loc6_ * 100)', '(_loc6_ * 100)').replace('String((parseFloat(_loc11_.Value[_loc6_]) * 100).toFixed(0))', '(parseFloat(_loc11_.Value[_loc6_]) * 100).toFixed(0)')
            assert normalized(c.m.extract(before, name)) == normalized(c.m.extract(verified, name)), name
            checked += 1
    assert 'RenderCharacterTags' in c.m.extract(verified, 'SwitchAttribute')
    assert 'CharacterTagOnOver' in c.m.extract(verified, 'AddCharacterTag')
    profile_verified = (work/'verify/scripts'/PROFILE).read_text(encoding='utf-8')
    profile_checked = 0
    for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(', profile_before):
        if name not in profile_allowed:
            assert normalized(c.m.extract(profile_before, name)) == normalized(c.m.extract(profile_verified, name)), 'profile:'+name
            profile_checked += 1
    assert 'RenderCharacterTags' in c.m.extract(profile_verified, 'UpdateRoleModel')
    assert 'ClearProfileCharacterTags' in c.m.extract(profile_verified, 'Reset')
    assert 'FHeros.GetHeroByIndex' in c.m.extract(profile_verified, 'RenderCharacterTags')
    manifest = canonical.parent/'version.swf'
    raw = zlib.decompress(manifest.read_bytes())
    pos = 2
    parts = [raw[:2]]
    found = 0
    for _ in range(struct.unpack_from('<H', raw)[0]):
        n = struct.unpack_from('<H', raw, pos)[0]; pos += 2
        k = raw[pos:pos+n]; pos += n
        n = struct.unpack_from('<H', raw, pos)[0]; pos += 2
        v = raw[pos:pos+n]; pos += n
        if k == b'TApplication.swf':
            v = VERSION.encode(); found += 1
        parts.extend([struct.pack('<H', len(k)), k, struct.pack('<H', len(v)), v])
    assert pos == len(raw) and found == 1 and canonical.read_bytes() == old
    # Preserve the fixed binary hero schema; tag IDs live in the JSON record
    # and generated client metadata, both sourced from the combat configuration.
    base_path = ROOT/'cikarim/veri-json/BaseHero.json'
    heroes = json.loads(base_path.read_text(encoding='utf-8'))
    for cfg in configs:
        hero = next(h for h in heroes if int(h['id'], 16) == cfg['heroId'])
        hero['tags'] = cfg['tags'][:]
    backup = work/'backups'
    backup.mkdir(exist_ok=True)
    release = public/'client-release.json'
    for path in [canonical, manifest, base_path, release]:
        assert not (backup/path.name).exists(), 'Backup already exists; inspect before rebuilding.'
        shutil.copy2(path, backup/path.name)
    dest = public/'character-tags'
    dest.mkdir(exist_ok=True)
    for i in ids:
        shutil.copy2(assets/definitions[i]['icon'], dest/f'{i}.png')
        assert (dest/f'{i}.png').read_bytes() == (assets/definitions[i]['icon']).read_bytes()
    (dest/'heroes.json').write_text(json.dumps(data, indent=2)+'\n')
    base_path.write_text(json.dumps(heroes, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    protected = c.h.swap(rebuilt)
    alias = public/VERSION/'TApplication.swf'
    alias.parent.mkdir(exist_ok=True)
    alias.write_bytes(protected)
    canonical.write_bytes(protected)
    manifest.write_bytes(zlib.compress(b''.join(parts)))
    for name in ['index.swf', 'version.swf']:
        shutil.copy2(canonical.parent/name, alias.parent/name)
    temp = public/'client-release.tmp'
    temp.write_text(json.dumps({'version': VERSION})+'\n')
    temp.replace(release)
    result = {'version': VERSION, 'heroIds': [cfg['heroId'] for cfg in configs], 'tags': data, 'unchangedMethods': checked,
              'sha256': hashlib.sha256(protected).hexdigest(), 'unchangedNonScriptTags': True,
              'profileUnchangedMethods': profile_checked, 'profileTags': True}
    (work/'result.json').write_text(json.dumps(result, indent=2)+'\n')
    print('PASS:', len(ids), 'original icons, hero data, native hover handlers;', checked, 'existing methods preserved; client', VERSION)

if __name__ == '__main__':
    main()
