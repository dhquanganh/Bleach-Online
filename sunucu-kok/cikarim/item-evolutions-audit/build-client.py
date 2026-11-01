from pathlib import Path
import importlib.util,json,re
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('c',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
def main():
 changed={}
 for p in (B/'original/scripts').rglob('*.as'):
  text=p.read_text(encoding='utf-8')
  if p.stem in ['TProcessorWinMakeEquip','TProcessorWinUpgradeEquip']:
   method='ProcessorForge' if p.stem=='TProcessorWinMakeEquip' else 'ProcessorAdvance'
   text=c.inject(text,method,'         if(this.FCurOld==null || this.FSlotOld.Context==null)return;\n         var selected:TInventory=SLogicsCore.Character.Equipments.GetInventoryByIdentifier(this.FCurOld.Identifier);\n         if(selected==null || selected.IDTemplate!=this.FCurOld.IDTemplate){this.Reset();return;}')
   old='_loc7_.Add(this.EquipFilter(SLogicsCore.Character.Equipments).GetInventoryByIndex(param3));'
   assert old in text;text=text.replace(old,'var selected:TInventory=SLogicsCore.Character.Equipments.GetInventoryByIdentifier(param1);\n         if(selected==null || selected.IDTemplate!=param2)return;\n         _loc7_.Add(selected);',1)
   name='TConfigEquipForge' if p.stem=='TProcessorWinMakeEquip' else 'TConfigEquipAdvance'
   token=' as '+name+';';at=text.index(token,text.index('function OnSelectItem'))+len(token);text=text[:at]+'\n         if(_loc4_==null){this.Reset();return;}'+text[at:]
   text=c.inject(text,'Reset','         this.FCurOld=null;')
  elif p.stem=='TProcessorWinShop':
   text=text.replace('      protected var FData:TEquipForge;','      protected var FData:TEquipForge;\n      private var FRefreshAt:Number=0;')
   old=c.m.extract(text,'LogicsPerform');new=old.replace('         _loc2_ = 4;','''         if(this.Visible && this.FData!=null && WorkExpired(this.FData.TimeStamp,STimingCore.ServerTick) && STimingCore.ServerTick>=this.FRefreshAt){
            this.FRefreshAt=STimingCore.ServerTick+5;
            var request:TPacket=SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_UltimateEquip_InitReq);
            SNetworkCore.Transceiver.PacketTransmit(request);
         }
         _loc2_ = 4;''',1);assert old!=new;text=text.replace(old,new,1)
   at=text.rfind('   }');text=text[:at]+'''      public static function WorkExpired(stamp:uint,tick:Number):Boolean {return stamp>0 && stamp<=tick;}
'''+text[at:]
  else:continue
  target=B/'patched'/p.relative_to(B/'original/scripts');target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8');changed[str(p.relative_to(B/'original/scripts'))]=text
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 c.ff('-selectclass',','.join(k[:-3].replace('\\','.').replace('/','.') for k in changed),'-export','script',B/'verify',B/'compiled.swf')
 unchanged=0;methods=[]
 for k in changed:
  before=(B/'original/scripts'/k).read_text(encoding='utf-8');after=(B/'verify/scripts'/k).read_text(encoding='utf-8')
  for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
   if name in ['ProcessorForge','ProcessorAdvance','OnSelectItem','Reset','LogicsPerform']:methods.append(name)
   else:assert c.m.extract(before,name)==c.m.extract(after,name),name;unchanged+=1
 assert [t for t in c.h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags((B/'compiled.swf').read_bytes()) if t[0]!=82]
 (B/'client-validation.json').write_text(json.dumps({'unchangedAssets':True,'unchangedMethods':unchanged,'changedMethods':methods},indent=2));print('PASS Item Evolutions native patches')
if __name__=='__main__':main()
