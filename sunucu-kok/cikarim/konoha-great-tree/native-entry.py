"""Put the event entrance in the native shortcut layer, behind native windows."""
from pathlib import Path
import importlib.util,json,shutil,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
s=importlib.util.spec_from_file_location('manifest',B.parent/'kakuzu-edo/release.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
W=B/'native-entry';W.mkdir(exist_ok=True);P=c.h.PUBLIC;canonical=P/'2026090619';rel=Path('Processors/Game/Lobby/TProcessorLobby.as')
original=(canonical/'TApplication.swf').read_bytes();(W/'source.swf').write_bytes(c.h.swap(original))
c.ff('-selectclass','Processors.Game.Lobby.TProcessorLobby','-export','script',W/'original',W/'source.swf')
before=(W/'original/scripts'/rel).read_text(encoding='utf-8');assert 'FKonohaTreeIcon' not in before
after=before.replace('      private var FMyobokuIcon:Sprite;', '      private var FKonohaTreeIcon:Sprite;\n      private var FMyobokuIcon:Sprite;',1)
code='''
         if(this.FKonohaTreeIcon == null && this.FMyobokuIcon != null)
         {
            this.FKonohaTreeIcon = new Sprite();
            this.FMountPointIcons.addChild(this.FKonohaTreeIcon);
            this.IllusionImage(this.FKonohaTreeIcon,"konoha-tree/event.png",2,0,60,60);
            this.IllusionText(this.FKonohaTreeIcon,"Konoha's",0,56,70,11,16770187,true);
            this.IllusionText(this.FKonohaTreeIcon,"Great Tree",0,68,70,11,16770187,true);
            this.FKonohaTreeIcon.buttonMode = true;
            this.FKonohaTreeIcon.mouseChildren = false;
            this.FKonohaTreeIcon.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void {
               if(ExternalInterface.available) ExternalInterface.call("openKonohaGreatTree");
            });
            this.FKonohaTreeIcon.addEventListener(MouseEvent.ROLL_OVER,function(event:MouseEvent):void {
               event.currentTarget.filters = [new flash.filters.GlowFilter(16711680,1,4,4,3)];
            });
            this.FKonohaTreeIcon.addEventListener(MouseEvent.ROLL_OUT,function(event:MouseEvent):void {
               event.currentTarget.filters = [];
            });
         }
         if(this.FKonohaTreeIcon != null)
         {
            this.FKonohaTreeIcon.visible = this.FMyobokuIcon.visible;
            this.FKonohaTreeIcon.x = this.FMyobokuIcon.x - 74;
            this.FKonohaTreeIcon.y = this.FMyobokuIcon.y;
         }
'''
method=c.m.extract(after,'IllusionUpdate');token='         if(this.FIllusionPending';assert token in method
updated=method.replace(token,code+'\n'+token,1);after=after.replace(method,updated,1)
assert after.replace(updated,method,1).replace('      private var FKonohaTreeIcon:Sprite;\n','',1)==before
target=W/'patched'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(after,encoding='utf-8')
c.ff('-onerror','abort','-importScript',W/'source.swf',W/'compiled.swf',W/'patched')
c.ff('-selectclass','Processors.Game.Lobby.TProcessorLobby','-export','script',W/'verify',W/'compiled.swf')
verified=(W/'verify/scripts'/rel).read_text(encoding='utf-8');assert 'this.FMyobokuIcon.x - 74' in verified and 'openKonohaGreatTree' in verified
active=json.loads((P/'client-release.json').read_text())['version'];assert active=='2026103103';assert original==(P/active/'TApplication.swf').read_bytes()
version='2026103104';dest=P/version;assert not dest.exists();dest.mkdir()
backup=W/'backup';backup.mkdir(exist_ok=True)
for name in ['TApplication.swf','version.swf']:shutil.copy2(canonical/name,backup/name)
shutil.copy2(P/'client-release.json',backup/'client-release.json')
rows=m.rows((canonical/'version.swf').read_bytes())
for row in rows:
 if row[0]==b'TApplication.swf':row[1]=version.encode()
client=c.h.swap((W/'compiled.swf').read_bytes());manifest=m.encode(rows)
for base in [canonical,dest]:(base/'TApplication.swf').write_bytes(client);(base/'version.swf').write_bytes(manifest)
shutil.copy2(canonical/'index.swf',dest/'index.swf');(P/'client-release.json').write_text(json.dumps({'version':version})+'\n')
(W/'validation.json').write_text(json.dumps({'version':version,'onlyChangedMethod':'IllusionUpdate','nativeShortcutLayer':True,'anchoredToMyoboku':True,'clientSha256':hashlib.sha256(client).hexdigest()},indent=2))
print('PASS native event entry: native shortcut layer, Myoboku anchor, red hover; release',version)
