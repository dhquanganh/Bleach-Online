from pathlib import Path
import importlib.util,json,math,shutil,struct,zlib
B=Path(__file__).resolve().parent
SOURCE=B.parents[2]/'asset/Kakuzu_Edo_Tensei_Full'
s=importlib.util.spec_from_file_location('mme',B.parent/'pain-tendo/prepare-assets.py')
p=importlib.util.module_from_spec(s);s.loader.exec_module(p)

def main():
    mapping={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','entry':'C_entry',
             'standard':'A_3hit','mystery':'SP_skill1','reattach':'SP_skill2','pressure':'SP_skill3',
             'darkness':'SP_skill4','migraine':'SP_skill5','summon':'SP_skill6','water-hiding':'SP_skill9',
             'reincarnation':'SP_skill10'}
    moves={13121901:'mystery',13121902:'standard',13121903:'clone-standard',13121904:'pressure',
           13121905:'darkness',13121906:'migraine',13121907:'summon',13121908:'reattach',13121909:'reincarnation'}
    data={'clips':{},'moves':moves,'framePivots':{},'models':{}}
    dest=B/'frames';dest.mkdir(parents=True,exist_ok=True)
    root,images=p.decode(SOURCE/'assets/battle/role/left/11005451.swf');index=0
    for name,action in mapping.items():
        rendered,node=p.mme.render(root,images,action,scale=1);ids=[]
        for tick in range(math.ceil(len(rendered)*25/24)):
            image=rendered[min(len(rendered)-1,round(tick*24/25))]
            image.save(dest/f'{index:04}.png');data['framePivots'][str(index)]=[round(v) for v in image.info['pivot']]
            ids.append(index);index+=1
        hit=sorted(set(round(int(f.get('index'))*25/24) for f in node.iter('frame') if any(e.startswith('hit') for e in f.get('event','').split(','))))
        clip={'assets':ids,'loop':name in ('idle','run'),'duration':40,'sourceAction':action,'hitFrames':hit or [max(1,len(ids)//2)]}
        if not clip['loop']:
            ids.append(ids[-1] if name=='dead' else data['clips']['idle']['assets'][0]);clip['returnFrame']=len(ids)-1
        data['clips'][name]=clip
    data['clips']['clone-standard']=data['clips']['standard']
    # RoleModel points the Water Clone at this same native model. Its entry and
    # death poses live at the end of the shared skill atlas; no duplicate art.
    data['models']={str(11120997):{'':'idle','0a':'idle','0b':'standard','0c':['mystery','pressure','darkness','migraine','summon','reattach','reincarnation','entry','dead'],'0d':'hit','0e':'idle','0f':'run'}}
    (B/'animation.json').write_text(json.dumps(data,indent=2)+'\n')
    public=B.parents[1]/'kaynak/login.gogames.me/public/kakuzu-edo-vfx/native';public.mkdir(parents=True,exist_ok=True)
    effects=['HuituJiaodu_xinzangduoqu','HuituJiaodu_tishugongji3','HuituJiaodu_fengdunyahai','HuituJiaodu_leidunweian',
             'HuituJiaodu_huoduntoukeku','HuituJiaodu_shuifenshenzhishu','HuituJiaodu_diyuanyufenghe','HuituJiaodu_diyuanyufenghe_shouji']
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
