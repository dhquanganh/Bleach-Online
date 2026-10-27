from pathlib import Path
import importlib.util,re,json,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py')
c=importlib.util.module_from_spec(s);s.loader.exec_module(c)

def main():
    rel=c.b.ROLE
    old=(B/'original/scripts'/rel).read_text(encoding='utf-8')
    helper=(B/'native.as.txt').read_text(encoding='utf-8')
    assert 'HashiramaNativeLayer' not in old
    new=old.replace('      override public function UpdateActive()',helper+'\n      override public function UpdateActive()',1)
    new=new.replace('            PreloadHashiramaVfx();','            PreloadHashiramaNative();',1)
    replacement='''      private function PlayHashiramaVfxAsset(name:String,host:DisplayObjectContainer,point:Point,width:Number,height:Number,delay:int=0,mirrored:Boolean=false,follow:Boolean=false,behind:Boolean=false,angle:Number=0) : void {
         if(host==null || host.stage==null)return;
         if(name=="Hashirama-thousand-hands-cinematic"){
            HashiramaNativeLayer("Zhujianzhongyandingshanghuafo","xia",host,point,width,height,delay,false,true,true);
            HashiramaNativeLayer("Zhujianzhongyandingshanghuafo","shang",host,point,width,height,delay,false,true);
            HashiramaNativeLayer("Zhujianzhongyandingshanghuafo_texie","texie",host,point,width,height,delay,false,true);
            return;
         }
         var cut:int=name.lastIndexOf("-");if(cut<0)return;
         var effect:String=name.substring(0,cut);var sprite:int=int(name.substring(cut+1));
         var symbol:String=effect.indexOf("_texie")>=0?"texie":sprite==364||sprite==281||sprite==688?"shang":"xia";
         HashiramaNativeLayer(effect,symbol,host,point,width,height,delay,mirrored,effect.indexOf("_texie")>=0,behind && FSkillId!=13121009);
      }'''
    method=c.m.extract(new,'PlayHashiramaVfxAsset')
    new=new.replace(method,replacement,1)
    dest=B/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(new,encoding='utf-8')
    c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
    source=(B/'source.swf').read_bytes();raw=(B/'compiled.swf').read_bytes()
    assert [x for x in c.h.tags(source) if x[0]!=82]==[x for x in c.h.tags(raw) if x[0]!=82]
    cls=str(rel.with_suffix('')).replace('\\','.').replace('/','.')
    c.ff('-selectclass',cls,'-export','script',B/'verify',B/'compiled.swf')
    check=(B/'verify/scripts'/rel).read_text(encoding='utf-8')
    allowed={'PrepareBattleRole','PlayHashiramaVfxAsset'};count=0
    for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',old):
        if name not in allowed:assert c.m.extract(old,name)==c.m.extract(check,name),name;count+=1
    assert 'PreloadHashiramaNative();' in c.m.extract(check,'PrepareBattleRole')
    assert '/public/hashirama-vfx/native/' in check
    (B/'client-validation.json').write_text(json.dumps({'sourceVersion':json.loads((c.h.PUBLIC/'client-release.json').read_text())['version'],'unchangedMethods':count,'changedMethods':sorted(allowed),'sha256':hashlib.sha256(raw).hexdigest()},indent=2)+'\n')
    print('PASS native Hashirama client;',count,'other TRole methods unchanged')
if __name__=='__main__':main()
