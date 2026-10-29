from pathlib import Path
import json
B=Path('sunucu-kok/cikarim/orochimaru-new-year');T=B.parent/'guy-gate';s=(T/'native.as.txt').read_text()
for a,b in [('GuyGate','Orochimaru'),('guyGate','orochimaru'),('guy-gate','orochimaru-new-year'),('11121007','11121009'),('131224','131226')]:s=s.replace(a,b)
effects=list(json.loads((B/'symbols.json').read_text()));a=s.index('         for each(var effect:String in ');z=s.index('LoadOrochimaruNative(effect);',a);s=s[:a]+'         for each(var effect:String in '+json.dumps(effects)+')'+s[z:]
mp={13122601:'Dashewanxinchun_tonglingzhishujushe',13122602:'Dashewanxinchun_qianyingduosheshou1',13122603:'Dashewanxinchun_qianyingduosheshou2',13122604:'Dashewanxinchun_qianyingduosheshou3',13122605:'Dashewanxinchun_fengdundatupo',13122606:'Dashewanxinchun_wuxingfengyin',13122607:'Dashewanxinchun_wuxingfengyin',13122608:'Dashewanxinchun_baqizhishu',13122609:'Dashewanxinchun_baqizhishu',13122610:'Dashewanxinchun_tutishenshu'}
a=s.index('         if(FSkillId==13122606)');z=s.index('\n      private function OrochimaruContactOffset',a)
s=s[:a]+'''         if(FSkillId==13122611){PlayOrochimaruNative("DASHEWAN_tongyongfuhuo","tyfh");return;}
         var mapping:Object=JSON.parse('''+json.dumps(json.dumps(mp,separators=(',',':')))+''');var effect:String=mapping[String(FSkillId)];
         if(effect!=null){PlayOrochimaruNative(effect,"xia");PlayOrochimaruNative(effect,"shang");}
         if(FSkillId==13122601)PlayOrochimaruNative("Dashewanxinchun_tonglingzhishujushe_texie","texie");
         if(FSkillId==13122608||FSkillId==13122609)PlayOrochimaruNative("Dashewanxinchun_baqizhishu_texie","texie");
      }
'''+s[z:]
a=s.index('         if(FId!=11121009',s.index('private function OrochimaruContactOffset'));z=s.index('\n      private function OrochimaruStrikePose',a)
# These are ranged source attacks; retain their actual source origin instead of moving the caster into its own projectiles.
s=s[:a]+'''         return new Point();
      }
'''+s[z:]
s=s.replace('         if(effect!="DASHEWAN_tongyongfuhuo")layer.blendMode="screen";','         layer.blendMode=symbol=="texie"?"screen":"normal";')
(B/'native.as.txt').write_text(s)
# Source support animation uses the shared revival VFX; all other original scenes are cast from the same stable origin.
print('Orochimaru native runtime generated')
