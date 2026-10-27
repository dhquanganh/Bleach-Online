"""Incremental native-effect conversion of four characters in the active client."""
from pathlib import Path
import hashlib,importlib.util,json,re
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py')
c=importlib.util.module_from_spec(s);s.loader.exec_module(c)

def main():
    active=json.loads((c.h.PUBLIC/'client-release.json').read_text())['version']
    assert c.h.swap((c.h.PUBLIC/active/'TApplication.swf').read_bytes())==(B/'source.swf').read_bytes(),'Active client changed'
    rel=c.b.ROLE;old=(B/'original/scripts'/rel).read_text(encoding='utf-8')
    assert 'PlayFourNinjaNative' not in old
    helper=(B/'native.as.txt').read_text().replace('__MANIFEST__',json.dumps((B/'native-manifest.json').read_text()))
    new=old.replace('      override public function UpdateActive()',helper+'\n      override public function UpdateActive()',1)
    allowed=set()
    for key,prefix in [('sasuke','Sasuke'),('mecha','Mecha'),('itachi','Itachi'),('gaara','Gaara')]:
        name='Preload'+prefix+'Vfx'
        code='      private static function '+name+'() : void {\n'
        if key=='sasuke':code+='         var data:Object=SasukeVfxManifest();for(var cinematic:String in data.cinematics)LoadSasukeCinematic(cinematic,data.cinematics[cinematic]);\n'
        code+='         PreloadFourNinjaNative("'+key+'");\n      }'
        new=new.replace(c.m.extract(new,name),code,1);allowed.add(name)
        name='Play'+prefix+'VfxAsset'
        code='''      private function __METHOD__(name:String,host:DisplayObjectContainer,point:Point,width:Number,height:Number,delay:int=0,mirrored:Boolean=false,follow:Boolean=false,behind:Boolean=false,angle:Number=0) : void {
         PlayFourNinjaNative("__KEY__",name,host,point,width,height,delay,mirrored,follow,behind,angle,F__PREFIX__ActiveVfx);
      }'''.replace('__METHOD__',name).replace('__KEY__',key).replace('__PREFIX__',prefix)
        new=new.replace(c.m.extract(new,name),code,1);allowed.add(name)
    # Flash forbids reparenting timeline children during REMOVED_FROM_STAGE.
    # Interrupted Kirin layers are stopped and released; normal completion still
    # returns instances to the existing pool.
    for name in ['PlaySasukeNativeImpact','PlaySasukeCinematic']:
        method=c.m.extract(new,name)
        anchor='            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);'
        assert anchor in method
        if name=='PlaySasukeNativeImpact':
            code='''
            if(event!=null && event.type==Event.REMOVED_FROM_STAGE){
               if(movies!=null)for each(var aborted:MovieClip in movies)aborted.stop();
               movies=null;return;
            }'''
        else:
            code='''
            if(event!=null && event.type==Event.REMOVED_FROM_STAGE){
               if(movie!=null)movie.stop();movie=null;return;
            }'''
        new=new.replace(method,method.replace(anchor,anchor+code,1),1);allowed.add(name)
    name='ShowSasukeScreenFlash';method=c.m.extract(new,name)
    updated=method.replace('            if(layer.parent != null)','            if(layer.parent != null && (event == null || event.type != Event.REMOVED_FROM_STAGE))',1)
    assert updated!=method;new=new.replace(method,updated,1);allowed.add(name)
    assert len(allowed)==11
    for key,prefix in [('sasuke','Sasuke'),('mecha','Mecha'),('itachi','Itachi'),('gaara','Gaara')]:
        assert 'PlayFourNinjaNative("'+key+'"' in c.m.extract(new,'Play'+prefix+'VfxAsset')
    output=B/'patched'/rel;output.parent.mkdir(parents=True,exist_ok=True);output.write_text(new,encoding='utf-8')
    c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
    raw=(B/'compiled.swf').read_bytes();source=(B/'source.swf').read_bytes()
    assert [t for t in c.h.tags(source) if t[0]!=82]==[t for t in c.h.tags(raw) if t[0]!=82]
    cls=str(rel.with_suffix('')).replace('\\','.').replace('/','.')
    c.ff('-selectclass',cls,'-export','script',B/'verify',B/'compiled.swf')
    check=(B/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
    for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',old):
        if name not in allowed:
            assert c.m.extract(old,name)==c.m.extract(check,name),name
            count+=1
    for name in ['ShowSasukeVfx','ShowMechaVfx','ShowItachiVfx','ShowGaaraVfx','RestoreTsunadeAfterRevival','HashiramaNativeLayer','PlayTobiNative','PlayKakuzuNative']:
        assert c.m.extract(old,name)==c.m.extract(check,name),name
    (B/'client-validation.json').write_text(json.dumps({'sourceVersion':active,'sha256':hashlib.sha256(raw).hexdigest(),'unchangedMethods':count,'changedMethods':sorted(allowed)},indent=2)+'\n')
    print('PASS four native characters;',count,'unrelated methods unchanged')

if __name__=='__main__':main()
