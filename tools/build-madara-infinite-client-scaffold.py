from pathlib import Path
import json
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/madara-infinite';T=B.parent/'minato-new-year'
mapping={13122201:'yuehziyan_aoyi1',13122202:'yuehziyan_pugong4',13122203:'yuehziyan_pugong1',13122204:'yuehziyan_pugong2',13122205:'yuehziyan_pugong3',13122206:'yuehziyan_aoyi2',13122207:'yuehziyan_jineng4',13122208:'yuehziyan_jineng5',13122209:'yuehziyan_jineng5',13122210:'yuehziyan_jineng3',13122211:'yuehziyan_jineng6'}
s=(T/'native.as.txt').read_text().replace('Minato','Infinite').replace('minatoNewYear','madaraInfinite').replace('minato-new-year','madara-infinite').replace('11121003','11121005').replace('11121004','11121005')
start=s.index('         for each(var effect:String in ');end=s.index('LoadInfiniteNative(effect);',start)
s=s[:start]+'         for each(var effect:String in '+json.dumps(list(json.loads((B/'symbols.json').read_text())))+')'+s[end:]
start=s.index('         if(FSkillId==13122109)');end=s.index('\n      private function InfiniteContactOffset()',start)
s=s[:start]+'''         if(FSkillId==13122212){PlayInfiniteNative("DASHEWAN_tongyongfuhuo","tyfh");return;}
         var mapping:Object=JSON.parse('''+json.dumps(json.dumps(mapping,separators=(',',':')))+''');var effect:String=mapping[String(FSkillId)];
         if(FSkillId==13122201)PlayInfiniteNative("yuehziyan_aoyi1texie","texie");
         if(FSkillId==13122206)PlayInfiniteNative("yuehziyan_aoyi2texie","texie");
         if(effect!=null){PlayInfiniteNative(effect,"xia");PlayInfiniteNative(effect,"shang");}
         if(FTargets!=null && FResults!=null && FSkillId>=13122207 && FSkillId<=13122209){
            for(var i:int=0;i<FTargets.length&&i<FResults.length;i++)if(FTargets[i]!=null&&FTargets[i].Camp!=Camp&&FResults[i].CMD==1&&FResults[i].ResultInfo.HurtHp>0)
               PlayInfiniteNative("yuehziyan_jinengshoujileidian","shang",FTargets[i],14);
         }
      }
'''+s[end:]
start=s.index('         if((FId!=11121005',s.index('private function InfiniteContactOffset'));end=s.index('\n      private function InfiniteStrikePose',start)
a=json.loads((B/'animation.json').read_text());ends={i:a['clips'][n]['returnFrame'] for i,n in a['moves'].items()}
s=s[:start]+'''         if(FId!=11121005 || FSkillId<13122202 || FSkillId>13122205 || FTargets==null || FResults==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return new Point();
         var enemy:TRole=null;
         for(var i:int=0;i<FTargets.length && i<FResults.length;i++)if(FTargets[i]!=null && FTargets[i].Camp!=Camp && FResults[i].CMD==1){enemy=FTargets[i];break;}
         if(enemy==null)return new Point();
         var contact:Point=globalToLocal(enemy.localToGlobal(new Point()));
         var distance:Number=(FSkillId==13122202?520:150)*0.84;
         var end:Number=Number(JSON.parse('''+json.dumps(json.dumps(ends,separators=(',',':')))+''')[String(FSkillId)]);var phase:Number=Math.min(1,Math.max(0,FFrameIndex/9),Math.max(0,(end-FFrameIndex)/9));phase=phase*phase*(3-2*phase);
         return new Point((contact.x-distance)*phase,contact.y*phase);
      }
'''+s[end:]
s=s.replace('layer.mouseChildren=false;', 'layer.mouseChildren=false;\n         if(effect=="yuehziyan_aoyi2" || effect=="yuehziyan_aoyi2texie")layer.blendMode="screen";',1)
(B/'native.as.txt').write_text(s)
