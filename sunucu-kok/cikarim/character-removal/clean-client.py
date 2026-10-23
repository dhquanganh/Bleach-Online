"""Remove both character renderers from the live client, preserving other methods."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,os,re,subprocess
BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1];PUBLIC=ROOT/'kaynak/login.gogames.me/public'
spec=importlib.util.spec_from_file_location('client_helpers',BASE.parent/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
CLASSES=['Processors/Game/Battle/Character/TRole.as','Processors/Game/Battle/Character/TActive.as','Processors/Game/Battle/TBattleStage.as','Processors/Game/Lobby/TacticalDeployment/Components/THeroDeployment.as','Foundation/Decoder/Pak/TPakDecoder.as']

def end_block(s,pos):
    pos=s.index('{',pos)+1;depth=1
    while depth:
        depth+=(s[pos]=='{')-(s[pos]=='}');pos+=1
    return pos

def remove_if(s,expression):
    pattern=re.compile(r'(?m)^\s*if\('+expression+r'\)\s*\{')
    while (match:=pattern.search(s)):
        end=end_block(s,match.start());s=s[:match.start()]+'\n'+s[end:]
    return s

def methods(s):
    return {m[1]:s[m.start():end_block(s,m.start())] for m in re.finditer(r'      (?:override )?(?:public|private|protected)(?: static)? function (\w+)\(',s)}

def role(s):
    for name,block in methods(s).items():
        if 'kabuto' in name.lower() and name!='PrepareDormantKabuto':s=s.replace(block,'')
    s=remove_if(s,r'FId >= 11120980 && FId <= 11120984')
    s=remove_if(s,r'FId == 11120980 && param1 == TYPE_ACTIVE_DIE')
    s=remove_if(s,r'param1 < 0 && \(FKabutoWarReviving \|\| FId >= 11120980 && FId <= 11120984\) && \(CurHealth <= 0 \|\| FIsDie \|\| FWaitDie\)')
    s=remove_if(s,r'FId >= 11120910 && FId <= 11120914(?:[^\n]*)')
    s=remove_if(s,r'FId == 11120910')
    s=remove_if(s,r'restoreKabuto')
    s=remove_if(s,r'param1.CMD == TTargetInfo.CMD_FLOAT && warMarker >= 19001401 && warMarker <= 19001418')
    s=remove_if(s,r'kabutoMarker >= 19000401 && kabutoMarker <= 19000418')
    s=remove_if(s,r'oldKabutoBarrier != null')
    s=s.replace(' || FId >= 11120910 && FId <= 11120914','')
    s='\n'.join(line for line in s.split('\n') if not re.search(r'\b(?:F?Kabuto\w*|kabuto\w*|restoreKabuto|oldKabutoBarrier)\b|this\.(?:UpdateKabuto\w*|FitKabuto\w*)\(',line))
    s=s.replace('         var warNames:Array;\n','').replace('         var warMarker:uint = uint(param1.ResultInfo.BuffId);\n','')
    return s.replace('PrepareDormantKabuto','PrepareBattleRole')

def active(s):
    # Remove exclusive sequence selectors, preserving the original default path.
    s=remove_if(s,r'this.FId == 11120980 && this.FTextureSkill.Count >= 5')
    s=remove_if(s,r'this.FId == 11120981 && this.FTextureSkill.Count >= 2')
    s=remove_if(s,r'this.FId == 11120910 && this.FTextureSkill.Count >= 5')
    s=remove_if(s,r'this.FId == 11120911 && this.FTextureSkill.Count >= 2')
    s=remove_if(s,r'this.FId >= 11120980 && this.FId <= 11120984[^\n]*')
    return s

def stage(s):
    s=s.replace('PrepareDormantKabuto','PrepareBattleRole')
    s=remove_if(s,r'kabutoResetBarrier != null')
    s=s.replace('var kabutoResetBarrier:DisplayObject = this.FBattleFiled.getChildByName("kabutoBarrierStatus");','')
    s=re.sub(r'(?:param[12])\.RoleBattleInfos\[_loc3_\]\.RoleId >= (?:11120980|11120910) && (?:param[12])\.RoleBattleInfos\[_loc3_\]\.RoleId <= (?:11120984|11120914) \|\| ','',s)
    s=re.sub(r' \|\| (?:param[12])\.RoleBattleInfos\[_loc3_\]\.RoleId >= 11120910 && (?:param[12])\.RoleBattleInfos\[_loc3_\]\.RoleId <= 11120914','',s)
    # Keep the reset host traversal for the remaining character effects.
    s=re.sub(r'kabutoRasterHost.getChildAt\(kabutoRasterIndex\).name == "kabuto(?:War)?(?:Skill|Status)Vfx" \|\| ','',s)
    s=s.replace('kabutoRaster','battleRaster')
    return s

def formation(s):
    return s.replace(' || this.FSelectHero.Identifier == 11120980','').replace(' && this.FSelectHero.Identifier != 11120980','')

def main():
    p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--reuse-export',action='store_true');a=p.parse_args()
    canonical=PUBLIC/'2026090619/TApplication.swf';original=canonical.read_bytes();decoded=h.swap(original)
    (BASE/'input.swf').write_bytes(decoded)
    home=BASE/'ffdec-home';home.mkdir(exist_ok=True)
    def ff(*args):subprocess.run(['java','-Xmx3g','-Duser.home='+str(home),'-jar',a.ffdec,*map(str,args)],check=True,stdout=subprocess.DEVNULL,env={**os.environ,'APPDATA':str(home)})
    names=','.join(x[:-3].replace('/','.') for x in CLASSES)
    if not a.reuse_export:ff('-selectclass',names,'-export','script',BASE/'original',BASE/'input.swf')
    transforms=[role,active,stage,formation,lambda s:s.replace('FKabutoSourceRects','FAtlasSourceRects')]
    report={}
    for path,transform in zip(CLASSES,transforms):
        before=(BASE/'original/scripts'/path).read_text(encoding='utf-8');after=transform(before)
        if re.search('kabuto',after,re.I):
            print('\n'.join(line for line in after.splitlines() if re.search('kabuto',line,re.I)))
            raise AssertionError('Remaining character integration in '+path)
        target=BASE/'patched'/path;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(after,encoding='utf-8')
        old=methods(before);new=methods(after)
        report[path]={'removedMethods':[n for n in old if n not in new], 'changedMethods':[n for n in new if n in old and new[n]!=old[n]], 'preservedMethods':sum(new.get(n)==block for n,block in old.items())}
    ff('-onerror','abort','-importScript',BASE/'input.swf',BASE/'cleaned.swf',BASE/'patched')
    rebuilt=(BASE/'cleaned.swf').read_bytes()
    assert [t for t in h.tags(decoded) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
    ff('-selectclass',names,'-export','script',BASE/'verify',BASE/'cleaned.swf')
    for path in CLASSES:
        verified=(BASE/'verify/scripts'/path).read_text(encoding='utf-8')
        assert not re.search('kabuto',verified,re.I),path
    assert canonical.read_bytes()==original,'Client changed during compilation'
    protected=h.swap(rebuilt);canonical.write_bytes(protected)
    (BASE/'client-verification.json').write_text(json.dumps({'version':'2026102310','sha256':hashlib.sha256(protected).hexdigest(),'classes':report},indent=2))
    print('PASS client renderers removed; other character methods preserved; canonical client installed')
if __name__=='__main__':main()
