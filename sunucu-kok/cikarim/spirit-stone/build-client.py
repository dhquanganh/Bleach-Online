"""Insert newly received inventory types after native Ntf lookup misses all bags/mounts."""
from pathlib import Path
import importlib.util,shutil,struct,subprocess,zlib,re
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('m',BASE.parent/'mecha-naruto/build-client.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
h=m.h
JAR='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
REL=Path('Processors/Game/Lobby/Backpack/TProcessorBackpack.as')
def ff(*args):subprocess.run(['java','-Xmx3g','-jar',JAR,*map(str,args)],check=True,stdout=subprocess.DEVNULL)
def main():
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old);(BASE/'source.swf').write_bytes(decoded)
 before=(BASE/'original/scripts'/REL).read_text(encoding='utf-8');assert 'InsertNewlyReceivedInventory' not in before
 body=m.extract(before,'PerformPacket_SC_InventoryNtf');token='            _loc2_++;';assert body.count(token)==1
 after=before.replace(body,body.replace(token,'            if(!_loc4_)this.InsertNewlyReceivedInventory(_loc6_,_loc7_);\n'+token))
 helper='''      protected function InsertNewlyReceivedInventory(bag:uint, item:TInventory):Boolean
      {
         if(item==null || item.Quantity==0)return false;
         var target:TInventories=null;
         if(bag==TYPE_TEMP_BACKPACK)target=this.FCharacter.TemporaryInventories;
         else switch(item.Category)
         {
            case CATEGORY_Normal:target=this.FCharacter.Appliances;break;
            case CATEGORY_Equipment:target=this.FCharacter.Equipments;break;
            case CATEGORY_Ornament:target=this.FCharacter.Ornaments;break;
            case CATEGORY_Gem:target=this.FCharacter.Gems;break;
            case CATEGORY_Treasure:target=this.FCharacter.Treasures;break;
            case CATEGORY_Material:target=this.FCharacter.Materials;break;
            case CATEGORY_WakeEquip:target=this.FCharacter.WakeEquip;break;
         }
         if(target==null || target.GetInventoryByIdentifier(item.Identifier)!=null)return false;
         target.Add(item);
         target.Sort();
         return true;
      }
'''
 after=after.replace('      protected function GetKnifeCountByFCategorySecond()',helper+'\n      protected function GetKnifeCountByFCategorySecond()',1)
 dest=BASE/'patched'/REL;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(after,encoding='utf-8')
 ff('-onerror','abort','-importScript',BASE/'source.swf',BASE/'compiled.swf',BASE/'patched')
 rebuilt=(BASE/'compiled.swf').read_bytes();assert [x for x in h.tags(decoded) if x[0]!=82]==[x for x in h.tags(rebuilt) if x[0]!=82]
 ff('-selectclass','Processors.Game.Lobby.Backpack.TProcessorBackpack','-export','script',BASE/'verify',BASE/'compiled.swf')
 verified=(BASE/'verify/scripts'/REL).read_text(encoding='utf-8');assert 'InsertNewlyReceivedInventory' in verified
 for name in re.findall(r'      (?:override )?(?:public|private|protected) function (\w+)\(',before):
  if name!='PerformPacket_SC_InventoryNtf':assert m.extract(before,name)==m.extract(verified,name),name
 version=canonical.parent/'version.swf';raw=zlib.decompress(version.read_bytes());pos=2;parts=[raw[:2]];found=0
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
  if k==b'TApplication.swf':v=b'2026102012';found+=1
  parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
 assert found==1 and pos==len(raw) and canonical.read_bytes()==old
 backup=BASE/'backups';backup.mkdir(exist_ok=True)
 for original in [canonical,version]:
  if not (backup/original.name).exists():shutil.copy2(original,backup/original.name)
 protected=h.swap(rebuilt);dest=h.PUBLIC/'2026102012/TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(protected);canonical.write_bytes(protected);version.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS client 2026102012; only inventory notification handler changed')
if __name__=='__main__':main()
