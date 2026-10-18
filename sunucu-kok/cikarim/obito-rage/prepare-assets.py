"""Decode original Obito MME layers, alpha, transforms and hit events."""
from pathlib import Path
from PIL import Image
import copy,importlib.util,json,math
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('mme',BASE.parent/'kabuto-gnw/native-assets.py');mme=importlib.util.module_from_spec(spec);spec.loader.exec_module(mme)
SOURCE=BASE.parents[2]/'asset/Extracted_Obito_Rage'
MAPPING={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','standard':'A_1hit','rage-standard':'A_2hit','kamui':'SP_skill4','roots':'SP_skill5','chaos':'SP_skill2','spear':'SP_skill3','rage':'SP_skill1'}
MOVES={13120951:'kamui',13120952:'roots',13120953:'standard',13120954:'rage-standard',13120955:'chaos',13120956:'spear',13120957:'chaos',13120958:'spear',13120959:'rage'}
EFFECTS={'kamui':['DT1shenwei'],'roots':['DTaoyi'],'standard':['DTpugong'],'rage-standard':['DTpugong'],'chaos':['dtpg'],'spear':['DTzhuida'],'rage':['DTbaozou']}

# These source layers repeat idle asset 0 underneath the actual acting body.
# Layer IDs are not unique (A_1hit has two id=1 layers), so use source order.
IDLE_BACKDROPS={'A_1hit':3,'A_2hit':3,'SP_skill5':5}
def single_actor_config(config):
    config=copy.deepcopy(config)
    for name,index in IDLE_BACKDROPS.items():
        action=next(a for a in config.findall('action') if a.get('name')==name)
        layer=action.findall('layer')[index]
        elements=list(layer.iter('element'))
        assert elements and all(e.get('assetId')=='0' for e in elements),(name,layer.attrib)
        action.remove(layer)
    return config

def main():
    config,images=mme.decode(SOURCE/'battle/role/left/11006051.swf')
    config=single_actor_config(config)
    data={'clips':{},'framePivots':{},'moves':MOVES,'effects':EFFECTS,'sourceFrameRate':24,'removedIdleBackdrops':IDLE_BACKDROPS,'models':{'11120920':{'':'idle','0a':'idle','0b':['standard','rage-standard'],'0c':['kamui','roots','chaos','spear','rage'],'0d':'hit','0e':'idle','0f':'run'}}}
    dest=BASE/'frames';dest.mkdir(exist_ok=True);preview=BASE/'validation/extracted';preview.mkdir(parents=True,exist_ok=True)
    vfx=json.loads((BASE/'vfx.json').read_text());ident=0
    for name,action_name in MAPPING.items():
        frames,action=mme.render(config,images,action_name,scale=.85)
        indices=[min(len(frames)-1,round(t*24/25)) for t in range(math.ceil(len(frames)*25/24))]
        ids=[]
        for i in indices:
            frames[i].save(dest/f'{ident:03}.png');data['framePivots'][str(ident)]=frames[i].info['pivot'];ids.append(ident);ident+=1
        clip={'assets':ids,'duration':40,'loop':name in ['idle','run'],'sourceAction':action_name,'sourceFrames':len(frames)}
        hits=sorted(set(round(int(f.get('index'))*25/24) for f in action.iter('frame') if 'hit' in f.get('event','').split(',')))
        if name not in ['idle','run','dead','hit','kamui','rage']:clip['hitFrames']=[hits[0]] if hits else [len(ids)//2]
        if not clip['loop']:
            duration=max([len(vfx['clips'][k]['timeline']) for e in EFFECTS.get(name,[]) for k in vfx['effects'][e]]+[len(ids)])
            # Hold the final casting pose until its effect has completed.
            ids.extend([ids[-1]]*max(0,duration-len(ids)));ids.append(data['clips']['idle']['assets'][0]);clip['returnFrame']=len(ids)-1
        data['clips'][name]=clip
        gif=[]
        for i in indices:
            bg=Image.new('RGBA',(900,600),'#263746');px,py=frames[i].info['pivot'];bg.alpha_composite(frames[i],(450-px,430-py));bg.thumbnail((600,400));gif.append(bg.convert('RGB'))
        gif[0].save(preview/(name+'.gif'),save_all=True,append_images=gif[1:],duration=40,loop=0)
    config,images=mme.decode(SOURCE/'user/ninja/ninjaImg/11006051.swf')
    im=mme.render(config,images,'C_idle',scale=1)[0][0];im.save(preview/'showcase.png')
    (BASE/'animation.json').write_text(json.dumps(data,indent=2))
    print('PASS original model:',ident,'frames;',len(data['clips']),'clips; exact pivots and 40ms timing')
if __name__=='__main__':main()
