from pathlib import Path
import importlib.util,subprocess,shutil,json,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('h',B.parent/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(s);s.loader.exec_module(h)
s=importlib.util.spec_from_file_location('r',B.parent/'tsunade-asian/release.py');r=importlib.util.module_from_spec(s);s.loader.exec_module(r)
JAR='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
paths=[]
def patch(rel,text):
 p=B/'patched'/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8');paths.append(rel)
rel=Path('Logics/Streamization/Characters/TUnstreamizerRoleCanControlTwo.as');t=(B/'original/scripts'/rel).read_text();old='''            _loc8_ = int(param1.readUnsignedShort());
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc12_ = param1.readUnsignedInt();
               if(_loc12_ != 0)
               {
                  _loc5_.TitlesID.push(_loc12_);
               }
               _loc9_++;
            }''';assert old in t;t=t.replace(old,'''            var titleCount:int=int(param1.readUnsignedShort());
            var titleIndex:int=0;
            while(titleIndex<titleCount){
               _loc12_=param1.readUnsignedInt();
               if(_loc12_!=0)_loc5_.TitlesID.push(_loc12_);
               titleIndex++;
            }''',1);patch(rel,t)
rel=Path('Processors/Game/Lobby/MainSceneTwo/TProcessorMainScene.as');t=(B/'original/scripts'/rel).read_text()
for method in ['PacketPerform_SC_TOWN_NewRole','PacketPerform_SC_TOWN_RoleMove','PacketPerform_SC_RemoveTownRole','PacketPerform_UpdateTownRole']:
 start=t.index('function '+method+'(');pos=t.index('{',start)+1;t=t[:pos]+'\n         if(!this.FMapDataLoadOver)return;'+t[pos:]
needle='         this.FMapDataLoadOver = true;';assert needle in t;t=t.replace(needle,needle+'''
         this.FPlayerManager.Clear();
         this.SendMainRolePositionToServer(this.FMainPlayerManager.MainRole.MapCoordinate);
         var presence:TPacket=SNetworkCore.PacketAcquire(0x01810302);
         SNetworkCore.Transceiver.PacketTransmit(presence);
''',1)
start=t.index('function CreateCoordinateByBirthID(');pos=t.index('{',start)+1;t=t[:pos]+'''\n         if(param1<0){param2.X=(uint(param1)>>>15)&32767;param2.Y=uint(param1)&32767;return;}
'''+t[pos:];patch(rel,t)
def ff(*args):subprocess.run(['java','-Xmx3g','-jar',JAR,*map(str,args)],check=True,stdout=subprocess.DEVNULL)
ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
raw=(B/'compiled.swf').read_bytes();source=(B/'source.swf').read_bytes();assert [x for x in h.tags(source) if x[0]!=82]==[x for x in h.tags(raw) if x[0]!=82]
ff('-selectclass',','.join(str(x.with_suffix('')).replace('\\','.').replace('/','.') for x in paths),'-export','script',B/'verify',B/'compiled.swf')
for rel in paths:assert (B/'verify/scripts'/rel).exists()
version='2026102516';canonical=h.PUBLIC/'2026090619';old=(canonical/'TApplication.swf').read_bytes();assert h.swap(old) in [source,raw],'Current client changed; refusing overwrite'
backup=B/'backups';backup.mkdir(exist_ok=True)
for f in [canonical/'TApplication.swf',canonical/'version.swf',h.PUBLIC/'client-release.json']:
 if not (backup/f.name).exists():shutil.copy2(f,backup/f.name)
manifest=r.rows((canonical/'version.swf').read_bytes());found=0
for row in manifest:
 if row[0]==b'TApplication.swf':row[1]=version.encode();found+=1
assert found==1
out=h.PUBLIC/version;out.mkdir(exist_ok=True);protected=h.swap(raw)
(out/'TApplication.swf').write_bytes(protected);(canonical/'TApplication.swf').write_bytes(protected)
data=r.encode(manifest);(canonical/'version.swf').write_bytes(data);(out/'version.swf').write_bytes(data)
shutil.copy2(canonical/'index.swf',out/'index.swf');(h.PUBLIC/'client-release.json').write_text(json.dumps({'version':version})+'\n')
(B/'release.json').write_text(json.dumps({'version':version,'classes':[str(x) for x in paths],'sha256':hashlib.sha256(protected).hexdigest()},indent=2))
print('PASS real town presence client',version)
