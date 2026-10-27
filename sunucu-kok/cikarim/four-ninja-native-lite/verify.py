"""Verify native source integrity, actor preservation and Flash probe gates."""
from pathlib import Path
import argparse,hashlib,json,math
from prepare import B,ROOT,PUBLIC,CHARACTERS,symbols

def verify(probes=False):
    metadata=json.loads((B/'native-manifest.json').read_text())
    audit=json.loads((B/'size-audit.json').read_text())
    actors=json.loads((B/'actor-baseline.json').read_text())
    for name,digest in actors.items():assert hashlib.sha256((PUBLIC/name).read_bytes()).hexdigest()==digest,name
    layers=0;sources=0
    for key,(prefix,folder,source) in CHARACTERS.items():
        original=json.loads((B/(key+'-manifest.json')).read_text())
        for name,meta in metadata[key]['clips'].items():
            before=original['clips'][name]
            assert meta['duration']==len(before['timeline'])*40
            assert meta['pivot']==before['pivot']
            assert math.isclose(meta['width'],before.get('worldWidth',before['width']/before['renderScale']))
            assert math.isclose(meta['height'],before.get('worldHeight',before['height']/before['renderScale']))
            assert meta['rate']==24
            layers+=1
        for name,item in audit[key]['sources'].items():
            source_file=ROOT.parent/'asset'/source/(name+'.swf')
            installed=PUBLIC.parent/item['url'].lstrip('/')
            assert hashlib.sha256(source_file.read_bytes()).hexdigest()==item['sha256']
            assert installed.read_bytes()==source_file.read_bytes()
            assert symbols(installed.read_bytes())==item['symbols']
            sources+=1
    cases=0;results=[]
    if probes:
        for key in CHARACTERS:
            work=B/'probes'/key;plan=json.loads((work/'plan.json').read_text())
            for speed in [1,2]:
                result=json.loads((work/'validation'/('x'+str(speed))/'result.json').read_text())
                assert result['completed'] and result['cases']==plan['cases'],result
                assert result['cancellations']==2 and result['remainingLayers']==0 and not result['errors'],result
                assert result['nativeLayers']>0
                assert not any(url.endswith(('.png','.argb')) for url in result['requests'])
                cases+=result['cases'];results.append(result)
        validation=json.loads((B/'client-validation.json').read_text())
        assert validation['unchangedMethods']==204 and len(validation['changedMethods'])==11
        assert hashlib.sha256((B/'compiled.swf').read_bytes()).hexdigest()==validation['sha256']
    result={'nativeSources':sources,'effectLayers':layers,'preservedActorTextures':len(actors),'probeCases':cases,'probes':results,'sizes':audit}
    (B/'verification.json').write_text(json.dumps(result,indent=2)+'\n')
    print('PASS',sources,'exact native SWFs;',layers,'effect geometries;',len(actors),'unchanged actor textures;',cases,'Flash cases')
    return result

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--probes',action='store_true');args=parser.parse_args();verify(args.probes)
