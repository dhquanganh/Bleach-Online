"""Give only the Sage Shadow Clone a white HP fill without touching battle animation dispatch."""
from pathlib import Path
import importlib.util, re, shutil, subprocess

BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1]
JAR='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
helper_spec=importlib.util.spec_from_file_location('itachi_client',BASE.parent/'itachi-rtn/build-client.py')
helper=importlib.util.module_from_spec(helper_spec);helper_spec.loader.exec_module(helper)
h=helper.h;m=helper.m
ROLE=Path('Processors/Game/Battle/Character/TBaseRole.as')

def ff(*args):
 subprocess.run(['java','-Xmx3g','-jar',JAR,*map(str,args)],check=True,stdout=subprocess.DEVNULL)

def main():
 canonical=h.PUBLIC/'2026090619/TApplication.swf'
 protected=canonical.read_bytes();decoded=h.swap(protected)
 source=BASE/'clone-hp-source.swf';source.write_bytes(decoded)
 original=BASE/'clone-hp-original';patched=BASE/'clone-hp-patched';verified=BASE/'clone-hp-verified'
 for folder in (original,patched,verified):
  if folder.exists():shutil.rmtree(folder)
 ff('-selectclass',str(ROLE.with_suffix('')).replace('\\','.'),'-export','script',original,source)
 before=(original/'scripts'/ROLE).read_text(encoding='utf-8')
 assert '11120902' not in m.extract(before,'InitBaseRole'),'Sage clone HP color is already installed'
 code=before.replace('   import flash.text.*;','   import flash.text.*;\n   import flash.geom.ColorTransform;',1)
 marker='''            FHpBar.y = INIT_HpBar_Y;
         }
         if(this.CharacterName != null'''
 insert='''            FHpBar.y = INIT_HpBar_Y;
         }
         // Reset first because battle display instances may be recycled.
         var _healthColor:ColorTransform = new ColorTransform();
         if(this.FInfo.RoleId == 11120902)
         {
            _healthColor = new ColorTransform(0,0,0,1,255,255,255,0);
         }
         FHpBar.mc_hp.transform.colorTransform = _healthColor;
         this.FHp_Effect.transform.colorTransform = _healthColor;
         if(this.CharacterName != null'''
 assert marker in code
 code=code.replace(marker,insert,1)
 dest=patched/'scripts'/ROLE;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(code,encoding='utf-8')
 compiled=BASE/'clone-hp-compiled.swf'
 ff('-onerror','abort','-importScript',source,compiled,patched)
 rebuilt=compiled.read_bytes()
 assert [tag for tag in h.tags(decoded) if tag[0]!=82]==[tag for tag in h.tags(rebuilt) if tag[0]!=82], 'Non-ABC SWF tags changed'
 ff('-selectclass',str(ROLE.with_suffix('')).replace('\\','.'),'-export','script',verified,compiled)
 after=(verified/'scripts'/ROLE).read_text(encoding='utf-8')
 assert 'this.FInfo.RoleId == 11120902' in after
 assert 'new ColorTransform(0,0,0,1,255,255,255,0)' in after
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name!='InitBaseRole':assert m.extract(before,name)==m.extract(after,name),name
 backup=BASE/'backups/TApplication-before-clone-white-hp.swf';backup.parent.mkdir(parents=True,exist_ok=True)
 if not backup.exists():backup.write_bytes(protected)
 canonical.write_bytes(h.swap(rebuilt))
 print('PASS Sage clone white HP bar patch; animation bytecode outside TBaseRole.InitBaseRole is untouched')

if __name__=='__main__':main()
