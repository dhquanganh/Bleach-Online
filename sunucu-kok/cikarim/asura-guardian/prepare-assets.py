from pathlib import Path
import importlib.util,json,math,shutil,struct,zlib
B=Path(__file__).resolve().parent
SOURCE=B.parents[2]/'asset/Asura_Guardian_of_the_Land_Full'
s=importlib.util.spec_from_file_location('mme',B.parent/'pain-tendo/prepare-assets.py')
p=importlib.util.module_from_spec(s);s.loader.exec_module(p)

def main():
    mapping={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','entry':'C_entry','mystery':'SP_skill5','standard':'A_1hit','standard2':'A_2hit','standard3':'A_3hit','chase':'SP_skill2','modified':'SP_skill3','protection':'SP_skill1','dragon':'SP_skill6','barrier':'SP_skill4','revive':'SP_skill7'}
    C=json.loads((B.parents[1]/'sunucu/asura-guardian.json').read_text());moves={C[k]['id']:C[k]['asuraMove'] for k in C['skillKeys']}
    data={'clips':{},'moves':moves,'framePivots':{},'models':{}}
    dest=B/'frames';dest.mkdir(parents=True,exist_ok=True)
    root,images=p.decode(SOURCE/'assets/battle/role/left/11014011.swf');index=0
    for name,action in mapping.items():
        rendered,node=p.mme.render(root,images,action,scale=1,skip_layers={'mystery':[4],'chase':[0],'modified':[0,1,2],'dragon':[0,1],'barrier':[0]}.get(name,[]));rendered=rendered[:1] if name=='splash' else rendered;ids=[]
        for tick in range(math.ceil(len(rendered)*25/24)):
            image=rendered[min(len(rendered)-1,round(tick*24/25))]
            image.save(dest/f'{index:04}.png');data['framePivots'][str(index)]=[round(v) for v in image.info['pivot']]
            ids.append(index);index+=1
        hit=sorted(set(round(int(f.get('index'))*25/24) for f in node.iter('frame') if any(e.startswith('hit') for e in f.get('event','').split(','))))
        clip={'assets':ids,'loop':name in ('idle','run'),'duration':40,'sourceAction':action,'hitFrames':hit or [max(1,len(ids)//2)]}
        if not clip['loop']:
            ids.append(ids[-1] if name=='dead' else data['clips']['idle']['assets'][0]);clip['returnFrame']=len(ids)-1
        data['clips'][name]=clip
    data['models']={'11121008':{'':'idle','0a':'idle','0b':['standard','standard2','standard3'],'0c':['mystery','chase','modified','protection','dragon','barrier','revive','entry','dead'],'0d':'hit','0e':'idle','0f':'run'}}
    (B/'animation.json').write_text(json.dumps(data,indent=2)+'\n')
    public=B.parents[1]/'kaynak/login.gogames.me/public/asura-guardian-vfx/native';public.mkdir(parents=True,exist_ok=True)
    effects=[p.stem for p in (SOURCE/'assets/battle/effect').glob('Axiuluo*.swf')]
    symbols={}
    for name in effects:
        src=SOURCE/'assets/battle/effect'/f'{name}.swf';raw=src.read_bytes();body=raw[:8]+zlib.decompress(raw[8:]) if raw[:3]==b'CWS' else raw
        pos=8+(5+4*(body[8]>>3)+7)//8+4;names=[]
        while pos<len(body):
            header=struct.unpack_from('<H',body,pos)[0];pos+=2;kind,size=header>>6,header&63
            if size==63:size=struct.unpack_from('<I',body,pos)[0];pos+=4
            tag=body[pos:pos+size];pos+=size
            if kind==76:
                q=2
                for _ in range(struct.unpack_from('<H',tag)[0]):
                    i=struct.unpack_from('<H',tag,q)[0];q+=2;end=tag.index(0,q);value=tag[q:end].decode();q=end+1
                    if i:names.append(value)
        symbols[name]=names;shutil.copy2(src,public/src.name)
    (B/'symbols.json').write_text(json.dumps(symbols,indent=2)+'\n')
    print('PASS',index,'source frames',len(effects),'native effects')
if __name__=='__main__':main()
