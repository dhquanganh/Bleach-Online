from pathlib import Path
import json,shutil
R=Path.cwd();B=R/'sunucu-kok/cikarim/asura-guardian';T=B.parent/'guy-gate';A=json.loads((B/'animation.json').read_text())
s=(T/'native.as.txt').read_text()
for a,b in [('GuyGate','Asura'),('guyGate','asura'),('guy-gate','asura-guardian'),('11121007','11121008'),('131224','131225')]:s=s.replace(a,b)
effects=list(json.loads((B/'symbols.json').read_text()))+['DASHEWAN_tongyongfuhuo'];start=s.index('         for each(var effect:String in ');end=s.index('LoadAsuraNative(effect);',start);s=s[:start]+'         for each(var effect:String in '+json.dumps(effects)+')'+s[end:]
start=s.index('         if(FSkillId==13122506)');end=s.index('\n      private function AsuraContactOffset',start)
mp={13122501:'Axiuluo_jiuwei_liudaowuyuaoyi1',13122502:'Axiuluo_jiuwei_pugong1',13122503:'Axiuluo_jiuwei_pugong2',13122504:'Axiuluo_jiuwei_pugong3',13122505:'Axiuluo_jiuwei_mulongjizhuida1',13122506:'Axiuluo_jiuwei_mulongjizhuida2',13122507:'Axiuluo_jiuwei_shouhuaoyi2',13122508:'Axiuluo_jiuwei_mulongyuchufa1',13122509:'Axiuluo_jiuwei_shudanchufa2'}
s=s[:start]+'''         if(FSkillId==13122510){PlayAsuraNative("DASHEWAN_tongyongfuhuo","tyfh");return;}
         var mapping:Object=JSON.parse('''+json.dumps(json.dumps(mp,separators=(',',':')))+''');var effect:String=mapping[String(FSkillId)];
         if(effect!=null){PlayAsuraNative(effect,"xia");PlayAsuraNative(effect,"shang");}
         if(FSkillId==13122501)PlayAsuraNative("Axiuluo_jiuwei_liudaowuyuaoyi1texie","texie");
         if(FSkillId==13122507)PlayAsuraNative("Axiuluo_jiuwei_shouhuaoyi2texie","texie");
      }
'''+s[end:]
start=s.index('         if(FId!=11121008',s.index('private function AsuraContactOffset'));end=s.index('\n      private function AsuraStrikePose',start)
ends={i:A['clips'][name]['returnFrame'] for i,name in A['moves'].items()}
s=s[:start]+'''         if(FId!=11121008 || FSkillId<13122502 || FSkillId>13122504 || FTargets==null || FResults==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return new Point();
         var enemy:TRole=null;
         for(var i:int=0;i<FTargets.length&&i<FResults.length;i++)if(FTargets[i]!=null&&FTargets[i].Camp!=Camp&&FResults[i].CMD==1){enemy=FTargets[i];break;}
         if(enemy==null)return new Point();
         var contact:Point=globalToLocal(enemy.localToGlobal(new Point()));var distance:Number=350*.84;
         var end:Number=Number(JSON.parse('''+json.dumps(json.dumps(ends,separators=(',',':')))+''')[String(FSkillId)]);var phase:Number=Math.min(1,Math.max(0,FFrameIndex/6),Math.max(0,(end-FFrameIndex)/6));phase=phase*phase*(3-2*phase);
         return new Point((contact.x-distance)*phase,contact.y*phase);
      }
'''+s[end:]
# A cut-in is deliberately centered; battle effects preserve original pivots and camp-facing transforms.
s=s.replace('      private static var FAsuraNative:Object={};','      private static var FAsuraNative:Object={};\n      private var FAsuraBanished:Boolean=false;')
(B/'native.as.txt').write_text(s)
public=R/'sunucu-kok/kaynak/login.gogames.me/public/asura-guardian-vfx/native';shutil.copy2(R/'asset/Guy_Gate_of_Death_Full/assets/battle/effect/DASHEWAN_tongyongfuhuo.swf',public/'DASHEWAN_tongyongfuhuo.swf')
p=B/'build-client.py';s=p.read_text().replace("this.UpdateMinatoVfx();","this.UpdateGuyGateVfx();").replace("this.MinatoStrikePose(_loc4_);","this.GuyGateStrikePose(_loc4_);");p.write_text(s)
# Source support clips have positive HP records on their cast; never send them through damage append markers.
p=B/'build.py';s=p.read_text().replace("if name=='revive':", "if name in ['revive','dragon']:");p.write_text(s)
print([(k,len(v['assets']),v.get('hitFrames')) for k,v in A['clips'].items()])
