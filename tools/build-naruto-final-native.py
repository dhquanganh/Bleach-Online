from pathlib import Path
import json,xml.etree.ElementTree as E
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/naruto-final';T=B.parent/'madara-infinite'
C=json.loads((R/'sunucu-kok/sunucu/naruto-final.json').read_text());A=json.loads((B/'animation.json').read_text())
actions={int(e.get('id')):e for e in E.parse(R/'asset/Naruto_The_Final_Battle_Full/config_reference/assets/battle/SkillAction.xml').getroot()}
effects={int(e.get('id')):e for e in E.parse(R/'asset/Naruto_The_Final_Battle_Full/config_reference/assets/battle/Effect.xml').getroot()}
mapping={};cutins={};distances={}
for key in C['skillKeys']:
 m=C[key];src=m['sourceId'];src=21016217 if src in [21316217,21416217] else src
 node=actions[src]
 for e in node:
  if e.tag not in ['SkillEffect','FullScreenEffect']:continue
  effect=Path(effects[int(e.get('id'))].get('res')).stem
  (cutins if e.tag=='FullScreenEffect' else mapping)[str(m['id'])]=effect
 if node.get('moveType')=='1':distances[str(m['id'])]=float(node.get('attackDistance').split(',')[0])
s=(T/'native.as.txt').read_text().replace('Infinite','NarutoFinal').replace('madaraInfinite','narutoFinal').replace('madara-infinite','naruto-final').replace('11121005','11121006')
start=s.index('         for each(var effect:String in ');end=s.index('LoadNarutoFinalNative(effect);',start)
s=s[:start]+'         for each(var effect:String in '+json.dumps(list(json.loads((B/'symbols.json').read_text())))+')'+s[end:]
start=s.index('         if(FSkillId==13122212)');end=s.index('\n      private function NarutoFinalContactOffset()',start)
s=s[:start]+'''         var mapping:Object=JSON.parse('''+json.dumps(json.dumps(mapping,separators=(',',':')))+''');var effect:String=mapping[String(FSkillId)];
         var cutins:Object=JSON.parse('''+json.dumps(json.dumps(cutins,separators=(',',':')))+''');var cutin:String=cutins[String(FSkillId)];
         if(cutin!=null)PlayNarutoFinalNative(cutin,"texie");
         if(effect!=null){PlayNarutoFinalNative(effect,"xia");PlayNarutoFinalNative(effect,"shang");}
         if(FSkillId==13122315 && FTargets!=null && FResults!=null){
            for(var i:int=0;i<FTargets.length&&i<FResults.length;i++)if(FTargets[i]!=null&&FTargets[i].Camp!=Camp&&FResults[i].CMD==1&&FResults[i].ResultInfo.HurtHp>0)
               PlayNarutoFinalNative("MIngrenZyzz_Cidunfengyin_BUFF","shang",FTargets[i],20);
         }
      }
'''+s[end:]
start=s.index('         if(FId!=11121006',s.index('private function NarutoFinalContactOffset'));end=s.index('\n      private function NarutoFinalStrikePose',start)
ends={i:A['clips'][n]['returnFrame'] for i,n in A['moves'].items()}
s=s[:start]+'''         if(FId!=11121006 || FTargets==null || FResults==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return new Point();
         var distances:Object=JSON.parse('''+json.dumps(json.dumps(distances,separators=(',',':')))+''');if(distances[String(FSkillId)]==null)return new Point();
         var enemy:TRole=null;
         for(var i:int=0;i<FTargets.length && i<FResults.length;i++)if(FTargets[i]!=null && FTargets[i].Camp!=Camp && FResults[i].CMD==1){enemy=FTargets[i];break;}
         if(enemy==null)return new Point();
         var contact:Point=globalToLocal(enemy.localToGlobal(new Point()));var distance:Number=Number(distances[String(FSkillId)])*.84;
         var end:Number=Number(JSON.parse('''+json.dumps(json.dumps(ends,separators=(',',':')))+''')[String(FSkillId)]);var phase:Number=Math.min(1,Math.max(0,FFrameIndex/9),Math.max(0,(end-FFrameIndex)/9));phase=phase*phase*(3-2*phase);
         return new Point((contact.x-distance)*phase,contact.y*phase);
      }
'''+s[end:]
s=s.replace('if(effect=="yuehziyan_aoyi2" || effect=="yuehziyan_aoyi2texie")layer.blendMode="screen";', 'if(symbol=="texie")layer.blendMode="screen";')
s=s.replace('// These two source SWFs composite light over black. Screen removes\n         // their black matte while retaining the blue Susano\'o and lightning.', '// The cinematic light textures use a black matte; composite them transparently.')
s=s.replace('if(symbol=="texie")layer.blendMode="screen";', 'if(symbol=="texie" && FSkillId!=13122313)layer.blendMode="screen";')
s=s.replace('if(symbol=="texie"){','if(symbol=="texie" || skill==13122313){')
s=s.replace('var fit:Number=host.stage.stageWidth/bounds.width;', 'var fit:Number=skill==13122313?Math.max(host.stage.stageWidth/bounds.width,host.stage.stageHeight/bounds.height):host.stage.stageWidth/bounds.width;')
s=s.replace('host.stage.stageHeight*.4-', 'host.stage.stageHeight*(skill==13122313 ? 0.5 : 0.4)-')
override=B/'final-fullscreen/play-native.as.txt'
if override.exists():s=s[:s.index('      private function PlayNarutoFinalNative(')]+override.read_text()
(B/'native.as.txt').write_text(s)
p=B/'build-client.py';s=p.read_text().replace('madaraNarutoFinalSkillVfx','narutoFinalSkillVfx');p.write_text(s)
