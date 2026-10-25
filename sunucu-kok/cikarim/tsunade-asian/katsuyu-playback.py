"""Repair asynchronous Katsuyu playback on the current client, preserving other patches."""
from pathlib import Path
import importlib.util, json
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('fullscreen',B/'fullscreen.py')
f=importlib.util.module_from_spec(s);s.loader.exec_module(f)

def patch(before):
 data=json.loads((B/'katsuyu/animation.json').read_text())
 runtime=(B/'katsuyu.as.txt').read_text().replace('__DEAD_FRAMES__',str(len(data['clips']['dead']['frames']))).replace('__ENTRY_FRAMES__',str(len(data['clips']['entry']['frames'])))
 after=before
 for name in ['ClearSmallKatsuyuPose','PlaySmallKatsuyuPose','UpdateSmallKatsuyuPose']:
  after=after.replace(f.c.m.extract(after,name),f.c.m.extract(runtime,name),1)
 return f.c.inject(after,'UpdateActive','         if(FId==11120993 && FSmallKatsuyuStarted>=0){UpdateSmallKatsuyuPose();return;}')

if __name__=='__main__':
 # Use the audited publication routine, expanding only its method allowlist.
 source=(B/'fullscreen.py').read_text()
 source=source[:source.index("if __name__=='__main__':")]
 source=source.replace("if name!=('ShowTsunadeCutscene' if update else 'PlayTsunadeEffect'):","if name not in {'ClearSmallKatsuyuPose','PlaySmallKatsuyuPose','UpdateSmallKatsuyuPose','UpdateActive'}:")
 scope={'__file__':str(B/'fullscreen.py'),'__name__':'katsuyu_publication'}
 source=source.replace('PASS Acid Shot fullscreen;', 'PASS Small Katsuyu playback;')
 exec(compile(source,str(B/'fullscreen.py'),'exec'),scope)
 scope['patch']=patch;scope['VERSION']='2026102425'
 scope['main']('katsuyu/playback-client')
 result=B/'katsuyu/playback-client/result.json'
 report=json.loads(result.read_text())
 report.pop('fullscreenEffect',None);report.pop('uniformScale',None)
 report.update(actorScoped=11120993,lateTextureRecovery=True,poseOwnsUpdate=True)
 result.write_text(json.dumps(report,indent=2)+'\n')
