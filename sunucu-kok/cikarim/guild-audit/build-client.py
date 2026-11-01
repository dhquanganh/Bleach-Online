from pathlib import Path
import importlib.util,json,re
B=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(spec);spec.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
def main():
 changes={}
 for rel in (B/'original/scripts').rglob('*.as'):
  before=rel.read_text(encoding='utf-8');text=before
  if rel.stem=='TProcessorWindowOrgDonate':
   old='this.FDonateMoney = uint(this.FTF_DonateGold.text);';assert text.count(old)==1;text=text.replace(old,'this.FDonateMoney = uint(this.FTF_DonateMoney.text);')
  elif rel.stem=='TUnstreamizerOrganizationNew':
   text=c.inject(text,'UnstreamizerCopyConfig','         this.FData.SingleCopys.length=0;\n         this.FData.GroupCopys.length=0;')
   old=c.m.extract(text,'SingleEnterRet');new=old.replace('_loc4_ = this.FData.CurrentCopy.PointInfoVOs[_loc3_];','_loc4_ = this.FData.CurrentCopy.PointInfoVOs[_loc3_];\n            _loc4_.FightCount=0;\n            _loc4_.ResetCount=0;',1);assert old!=new;text=text.replace(old,new,1)
  elif rel.stem=='TUnstreamizerOrganization':
   text=c.inject(text,'Unstreamization_OrgMembersList','         if(SLogicsCore.Organization.OrgMemberList!=null)SLogicsCore.Organization.OrgMemberList.Clear();\n         if(param2!=null)Vector.<TBaseOrganizationMember>(param2).length=0;')
  else:continue
  target=B/'patched'/rel.relative_to(B/'original/scripts');target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8');changes[str(rel.relative_to(B/'original/scripts'))]=text
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 c.ff('-selectclass',','.join(k[:-3].replace('\\','.').replace('/','.') for k in changes),'-export','script',B/'verify',B/'compiled.swf')
 checked=0;changed=[]
 for k in changes:
  before=(B/'original/scripts'/k).read_text(encoding='utf-8');after=(B/'verify/scripts'/k).read_text(encoding='utf-8')
  for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
   if name not in ['OnChangeText_Money','UnstreamizerCopyConfig','SingleEnterRet','Unstreamization_OrgMembersList']:
    old=c.m.extract(before,name);new=c.m.extract(after,name)
    if name=='UpdateUI':old=old.replace('uint(this.FLimitMoney)','this.FLimitMoney').replace('String(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_58) + this.FLimitMoney)','TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_58) + this.FLimitMoney')
    assert old==new,name;checked+=1
   else:changed.append(name)
 assert [t for t in c.h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags((B/'compiled.swf').read_bytes()) if t[0]!=82]
 (B/'client-validation.json').write_text(json.dumps({'unchangedAssets':True,'unchangedMethods':checked,'changedMethods':changed},indent=2));print('PASS native guild patches',changed)
if __name__=='__main__':main()
