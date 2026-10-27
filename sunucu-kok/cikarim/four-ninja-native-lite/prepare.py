"""Prepare native SWFs and retain the installed effect geometry and timing."""
from pathlib import Path
import hashlib,json,re,shutil,struct,zlib

B=Path(__file__).resolve().parent
ROOT=B.parents[1]
PUBLIC=ROOT/'kaynak/login.gogames.me/public'
CHARACTERS={
 'sasuke':('Sasuke','sasuke-shinden','Sasuke_Shinden_Full/assets/battle/effect'),
 'mecha':('Mecha','mecha-naruto','Mecha_Naruto/effects'),
 'itachi':('Itachi','itachi-rtn','Itachi_Road_to_Ninja/effects'),
 'gaara':('Gaara','gaara-swimsuit','Gaara_Swimsuit_Full/assets/battle/effect'),
}

def symbols(data):
    raw=data[:8]+zlib.decompress(data[8:]) if data[:3]==b'CWS' else data
    pos=8+(5+4*(raw[8]>>3)+7)//8+4;result={}
    while pos<len(raw):
        header=struct.unpack_from('<H',raw,pos)[0];pos+=2;kind,size=header>>6,header&63
        if size==63:size=struct.unpack_from('<I',raw,pos)[0];pos+=4
        tag=raw[pos:pos+size];pos+=size
        if kind!=76:continue
        q=2
        for _ in range(struct.unpack_from('<H',tag)[0]):
            ident=struct.unpack_from('<H',tag,q)[0];q+=2;end=tag.index(0,q)
            name=tag[q:end].decode();q=end+1
            if ident:result[str(ident)]=name
    return result

def main():
    metadata={};audit={};models={}
    previous=json.loads((B/'size-audit.json').read_text()) if (B/'size-audit.json').exists() else {}
    for key,(prefix,folder,source) in CHARACTERS.items():
        installed=json.loads((B/(key+'-manifest.json')).read_text())
        animation=json.loads((B.parent/folder/'animation.json').read_text())
        for ident,variants in animation['models'].items():
            for suffix in variants:
                filename=f'{int(str(format(int(ident),"X"))+suffix,16):08X}.TexClient'
                file=PUBLIC/'2026090619/Resources/Textures/Model'/filename
                assert file.is_file(),file
                models[str(file.relative_to(PUBLIC))]=hashlib.sha256(file.read_bytes()).hexdigest()
        dest=PUBLIC/'ninja-native-lite/v1'/key;dest.mkdir(parents=True,exist_ok=True)
        sources={};clips={};old_files=set();new_files=set()
        for atlas in installed['atlases'].values():
            # The current loader uses ARGB when available, PNG otherwise.
            url=atlas.get('streamUrl') or atlas.get('argbUrl') or atlas.get('url')
            if url:
                file=PUBLIC.parent/url.lstrip('/')
                stream=file.with_suffix('.argb')
                old_files.add(stream if stream.is_file() else file)
        for name,clip in installed['clips'].items():
            effect,ident=name.rsplit('-',1)
            if effect not in sources:
                path=ROOT.parent/'asset'/source/(effect+'.swf')
                data=path.read_bytes();output=dest/path.name;shutil.copy2(path,output)
                sources[effect]={'url':'/public/ninja-native-lite/v1/'+key+'/'+path.name,'symbols':symbols(data),'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data)}
                new_files.add(output)
            entry=sources[effect];assert ident in entry['symbols'],name
            world_w=clip.get('worldWidth',clip['width']/clip['renderScale'])
            world_h=clip.get('worldHeight',clip['height']/clip['renderScale'])
            clips[name]={'url':entry['url'],'symbol':entry['symbols'][ident],'width':world_w,'height':world_h,'pivot':clip['pivot'],'duration':len(clip['timeline'])*40,'rate':24,
                         'soft':bool(clip.get('softEdges') or clip.get('bakedSoftEdges')),'additive':bool(clip.get('additive'))}
            if 'tint' in clip:clips[name]['tint']=clip['tint']
        # Sasuke's cleaned Kirin impacts and cinematics already use native SWFs.
        cinemas=set()
        for value in installed.get('cinematics',{}).values():
            path=PUBLIC.parent/value['url'].lstrip('/')
            if path.is_file():cinemas.add(path)
        metadata[key]={'clips':clips,'urls':list(dict.fromkeys(c['url'] for c in clips.values()))}
        old_bytes=sum(f.stat().st_size for f in old_files if f.is_file())+sum(f.stat().st_size for f in cinemas)
        if any(not f.is_file() for f in old_files):
            assert key in previous,'Missing legacy raster files without a recorded size baseline'
            old_bytes=previous[key]['oldRuntimeBytes']
        new_bytes=sum(f.stat().st_size for f in new_files)+sum(f.stat().st_size for f in cinemas)
        audit[key]={'oldRuntimeBytes':old_bytes,'nativeRuntimeBytes':new_bytes,'reductionPercent':round((1-new_bytes/old_bytes)*100,2),'oldRasterFiles':len(old_files),'nativeFiles':len(new_files),'unchangedNativeCinematics':len(cinemas),'clips':len(clips),'sources':sources}
        print(key,round(old_bytes/1048576,2),'->',round(new_bytes/1048576,2),'MiB;',audit[key]['reductionPercent'],'% reduction')
    (B/'native-manifest.json').write_text(json.dumps(metadata,indent=2)+'\n')
    (B/'size-audit.json').write_text(json.dumps(audit,indent=2)+'\n')
    if not (B/'actor-baseline.json').exists():(B/'actor-baseline.json').write_text(json.dumps(models,indent=2)+'\n')

if __name__=='__main__':main()
