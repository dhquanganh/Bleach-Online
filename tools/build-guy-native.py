from pathlib import Path
import json
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/guy-gate';T=B.parent/'minato-new-year'
C=json.loads((R/'sunucu-kok/sunucu/guy-gate.json').read_text());A=json.loads((B/'animation.json').read_text())
mapping={13122401:'Kaisimen_wusuaoyi1',13122402:'Kaisimen_pugong',13122403:'Kaisimen_pugong',13122404:'Kaisimen_yekaiaoyi',13122405:'Kaisimen_yekaibeidong'}
s=(T/'native.as.txt').read_text().replace('Minato','GuyGate').replace('minatoNewYear','guyGate').replace('minato-new-year','guy-gate').replace('11121003','11121007').replace('11121004','11121007')
start=s.index('         for each(var effect:String in ');end=s.index('LoadGuyGateNative(effect);',start)
s=s[:start]+'         for each(var effect:String in '+json.dumps(list(json.loads((B/'symbols.json').read_text())))+')'+s[end:]
start=s.index('         if(FSkillId==13122109)');end=s.index('\n      private function GuyGateContactOffset()',start)
s=s[:start]+'''         if(FSkillId==13122406){PlayGuyGateNative("DASHEWAN_tongyongfuhuo","tyfh");return;}
         var mapping:Object=JSON.parse('''+json.dumps(json.dumps(mapping,separators=(',',':')))+''');var effect:String=mapping[String(FSkillId)];
         if(effect!=null){PlayGuyGateNative(effect,"xia");PlayGuyGateNative(effect,"shang");}
      }
'''+s[end:]
start=s.index('         if((FId!=11121007',s.index('private function GuyGateContactOffset'));end=s.index('\n      private function GuyGateStrikePose',start)
ends={i:A['clips'][name]['returnFrame'] for i,name in A['moves'].items()}
s=s[:start]+'''         if(FId!=11121007 || FSkillId<13122401 || FSkillId>13122404 || FTargets==null || FResults==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return new Point();
         var enemy:TRole=null;
         for(var i:int=0;i<FTargets.length&&i<FResults.length;i++)if(FTargets[i]!=null&&FTargets[i].Camp!=Camp&&FResults[i].CMD==1){enemy=FTargets[i];break;}
         if(enemy==null)return new Point();
         var contact:Point=globalToLocal(enemy.localToGlobal(new Point()));var distance:Number=(FSkillId==13122401?450:510)*.84;
         var end:Number=Number(JSON.parse('''+json.dumps(json.dumps(ends,separators=(',',':')))+''')[String(FSkillId)]);var phase:Number=Math.min(1,Math.max(0,FFrameIndex/9),Math.max(0,(end-FFrameIndex)/9));phase=phase*phase*(3-2*phase);
         return new Point((contact.x-distance)*phase,contact.y*phase);
      }
'''+s[end:]
s=s.replace('layer.mouseChildren=false;', 'layer.mouseChildren=false;\n         if(effect!="DASHEWAN_tongyongfuhuo")layer.blendMode="screen";',1)
(B/'native.as.txt').write_text(s)
