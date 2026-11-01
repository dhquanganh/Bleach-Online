"""Live reward tooltip configuration for the 12 native Soul Palace daily chests."""
from pathlib import Path
import importlib.util,json,shutil,hashlib
B=Path(__file__).resolve().parent;B.mkdir(exist_ok=True)
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
s=importlib.util.spec_from_file_location('manifest',B.parent/'kakuzu-edo/release.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
P=c.h.PUBLIC;C=P/'2026090619';SHOP=Path('Processors/Game/Lobby/SkyTower/TProcessorWindowChest.as');MAIN=Path('Processors/Game/Lobby/SkyTower/TProcessorSkyTower.as')
source=(C/'TApplication.swf').read_bytes();(B/'source.swf').write_bytes(c.h.swap(source))
classes=','.join(str(p.with_suffix('')).replace('\\','.').replace('/','.') for p in [SHOP,MAIN]);c.ff('-selectclass',classes,'-export','script',B/'original',B/'source.swf')
text=(B/'original/scripts'/SHOP).read_text(encoding='utf-8');assert 'PalaceChestRewards' not in text
text=text.replace('      protected var FSkyTower:', '      public static var PalaceChestRewards:Object = {};\n\n      protected var FSkyTower:',1)
old=c.m.extract(text,'UIChestOnMove');new=old.replace('            SToolReward.GetAwardsByAwardID(_loc3_.AwardID,this.FInventories);','''            if(PalaceChestRewards[String(param2)] != null)
            {
               for each(var chestReward:Object in PalaceChestRewards[String(param2)])
               {
                  SToolReward.GetInventoryByIDAmount(CONST_COMMON.RewardIDToTemplateID(uint(chestReward.type),uint(chestReward.code)),int(chestReward.amount),this.FInventories);
               }
            }
            else SToolReward.GetAwardsByAwardID(_loc3_.AwardID,this.FInventories);''');assert old!=new;text=text.replace(old,new,1)
text=c.inject(text,'UIChestOnClick','         if(this.FSkyTower.ReceiveChestID > 0) return;')
text=c.inject(text,'Btn_ReceiveOnClick','''         if(this.FSelectChestID == 0 || this.FSkyTower.ReceiveChestID > 0) return;
         var chestRow:TTemplePliesNumber = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TemplePliesNumber,this.FSelectChestID) as TTemplePliesNumber;
         if(chestRow == null || this.FSkyTower.CurIntrgral < chestRow.NumberPlies) return;
         if(PalaceChestRewards[String(this.FSelectChestID)] != null && PalaceChestRewards[String(this.FSelectChestID)].length == 0) return;''')
text=c.inject(text,'Reset','         this.FSelectChestID = 0;')
old=c.m.extract(text,'ProcessorUpdateChest');new=old.replace('''            if(_loc3_ >= CHEST_INTEGRALS[_loc1_])
            {
               this.FSP_Progresss[_loc1_].visible = true;
            }''','            this.FSP_Progresss[_loc1_].visible = _loc3_ >= CHEST_INTEGRALS[_loc1_];');assert old!=new;text=text.replace(old,new,1)
text=c.inject(text,'UpdateUIChestState','''         var selectedChest:TTemplePliesNumber = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TemplePliesNumber,this.FSelectChestID) as TTemplePliesNumber;
         this.FBtn_Receive.Enabled = this.FSkyTower.ReceiveChestID == 0 && selectedChest != null && this.FSkyTower.CurIntrgral >= selectedChest.NumberPlies;''')
out=B/'patched'/SHOP;out.parent.mkdir(parents=True,exist_ok=True);out.write_text(text,encoding='utf-8')
text=(B/'original/scripts'/MAIN).read_text(encoding='utf-8');old=c.m.extract(text,'PacketPerform_SC_ChestInfo_Ret');token='         if(this.FProcessorWindowChest.Visible)';assert token in old
new=old.replace(token,'''         if(_loc3_.bytesAvailable >= 4)
         {
            var chestSize:uint = _loc3_.readUnsignedInt();
            if(chestSize > 0 && chestSize <= _loc3_.bytesAvailable)
            {
               var chestBytes:ByteArray = new ByteArray();
               _loc3_.readBytes(chestBytes,0,chestSize);
               chestBytes.uncompress();
               var chestConfig:Object = JSON.parse(chestBytes.readUTFBytes(chestBytes.length));
               TProcessorWindowChest.PalaceChestRewards = {};
               for each(var chestEntry:Object in chestConfig.chests) TProcessorWindowChest.PalaceChestRewards[String(chestEntry.id)] = chestEntry.rewards;
            }
         }
'''+token,1);text=text.replace(old,new,1)
out=B/'patched'/MAIN;out.parent.mkdir(parents=True,exist_ok=True);out.write_text(text,encoding='utf-8')
c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
c.ff('-selectclass',classes,'-export','script',B/'verify',B/'compiled.swf')
assert [t for t in c.h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags((B/'compiled.swf').read_bytes()) if t[0]!=82]
assert 'PalaceChestRewards' in (B/'verify/scripts'/SHOP).read_text(encoding='utf-8')
active=json.loads((P/'client-release.json').read_text())['version'];assert active=='2026103106';assert (P/active/'TApplication.swf').read_bytes()==source
version='2026103107';dest=P/version;assert not dest.exists();dest.mkdir();backup=B/'backup';backup.mkdir(exist_ok=True)
for name in ['TApplication.swf','version.swf']:shutil.copy2(C/name,backup/name)
shutil.copy2(P/'client-release.json',backup/'client-release.json');rows=m.rows((C/'version.swf').read_bytes())
for row in rows:
 if row[0]==b'TApplication.swf':row[1]=version.encode()
client=c.h.swap((B/'compiled.swf').read_bytes());manifest=m.encode(rows)
for base in [C,dest]:(base/'TApplication.swf').write_bytes(client);(base/'version.swf').write_bytes(manifest)
shutil.copy2(C/'index.swf',dest/'index.swf');(P/'client-release.json').write_text(json.dumps({'version':version})+'\n')
(B/'validation.json').write_text(json.dumps({'version':version,'artworkUnchanged':True,'clientSha256':hashlib.sha256(client).hexdigest(),'dynamicRewardTooltips':True},indent=2))
print('PASS live Palace Chest tooltips and native UI guards, release',version)
