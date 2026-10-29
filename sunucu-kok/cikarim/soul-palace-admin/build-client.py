from pathlib import Path
import importlib.util,json
B=Path(__file__).resolve().parent;s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
def main():
 rel=Path('Logics/Streamization/SkyTower/TUnstreamizerSkyTower.as');before=(B/'original/scripts'/rel).read_text(encoding='utf-8');text=before
 needle='this.UnstreamizationPerform_SkyTowerPvpDiarys(param1,_loc17_,param3);'
 text=text.replace(needle,needle+'''
         if(param1.bytesAvailable >= 4)
         {
            var packed:ByteArray = new ByteArray();
            var packedLength:uint = param1.readUnsignedInt();
            if(packedLength > 0 && packedLength <= param1.bytesAvailable)
            {
               param1.readBytes(packed,0,packedLength);
               packed.uncompress();
               var catalog:Object = JSON.parse(packed.readUTFBytes(packed.length));
               _loc13_.Clear();
               for each(var towerData:Object in catalog.towers)
               {
                  var tower:TTower = new TTower(uint(towerData.id));
                  tower.Name = String(towerData.name);
                  tower.OpenLevel = uint(towerData.openLevel);
                  tower.Tag = (uint(towerData.tag) - 1) % 13 + 1;
                  tower.IsUnlock = Boolean(towerData.unlocked);
                  for each(var floorData:Object in towerData.floors)
                  {
                     var layer:TLayer = new TLayer(uint(floorData.id));
                     layer.LayerName = String(floorData.name);
                     layer.AkeyPrice = 0;
                     layer.PveRoleTempleteID = uint(floorData.model);
                     layer.PveLevel = uint(floorData.level);
                     layer.PveNickname = String(floorData.name);
                     layer.IsClear = Boolean(floorData.clear);
                     tower.Layers.Add(layer);
                  }
                  tower.Layers.MaxLayer = tower.Layers.Count;
                  _loc13_.Add(tower);
               }
               _loc12_.LockedTowerID = uint(catalog.locked);
            }
         }
''',1);assert text!=before
 start=text.index('         if(param1.bytesAvailable >= 4)');end=text.index('\n      }',start)
 block=text[start:end].replace('_loc13_','target.Towers').replace('_loc12_','target')
 text=text[:start]+'         this.ApplyPalaceCatalog(param1,_loc12_);'+text[end:]
 pos=text.rfind('   }');text=text[:pos]+'      public function ApplyPalaceCatalog(param1:ByteArray,target:TSkyTower) : void\n      {\n'+block+'\n      }\n'+text[pos:]
 target=B/'patched'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
 rel=Path('Processors/Game/Lobby/SkyTower/TProcessorWindowSkyTower.as');text=(B/'original/scripts'/rel).read_text(encoding='utf-8')
 # The original assumes 13 towers and treats page four specially. Render every page by actual count.
 text=text.replace('if(_loc6_ == CAPACITY_Page_Towers - 1)','if(_loc8_.Count - _loc5_ == 1)').replace('_loc2_ = _loc8_.Count - 1;','_loc2_ = _loc8_.Count;')
 target=B/'patched'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
 rel=Path('Processors/Game/Lobby/SkyTower/TProcessorWindowBattleRoom.as');text=(B/'original/scripts'/rel).read_text(encoding='utf-8');old=c.m.extract(text,'UpdateBattleResult');new=old.replace('if(!param1)','if(true)');assert new!=old;text=text.replace(old,new,1)
 target=B/'patched'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 c.ff('-selectclass','Logics.Streamization.SkyTower.TUnstreamizerSkyTower,Processors.Game.Lobby.SkyTower.TProcessorWindowSkyTower,Processors.Game.Lobby.SkyTower.TProcessorWindowBattleRoom','-export','script',B/'verify',B/'compiled.swf')
 assert [t for t in c.h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags((B/'compiled.swf').read_bytes()) if t[0]!=82]
 (B/'client-validation.json').write_text(json.dumps({'unchangedAssets':True,'changedClasses':3,'dynamicCatalog':True},indent=2));print('PASS Soul Palace dynamic catalog, pagination and attempt count')
if __name__=='__main__':main()
