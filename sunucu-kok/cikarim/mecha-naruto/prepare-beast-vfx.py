"""Append the original Kurama claw and sweep without rebuilding prior HD effects."""
from pathlib import Path
import importlib.util,json
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('vfx',BASE/'prepare-vfx.py');v=importlib.util.module_from_spec(spec);spec.loader.exec_module(v)
old=json.loads((BASE/'vfx.json').read_text())
v.EFFECTS=['Jijiamingren_jiuweilama_zhuaji','Jijiamingren_jiuweilama_hengsao']
try:
 v.main();new=json.loads((BASE/'vfx.json').read_text())
 for field in ['atlases','clips','effects']:old[field].update(new[field])
 # Both effects use the original ground registration as their contact origin.
 for effect in v.EFFECTS:old.setdefault('effectAnchors',{})[effect]=[0,0]
 (BASE/'vfx.json').write_text(json.dumps(old,indent=2))
except BaseException:
 (BASE/'vfx.json').write_text(json.dumps(old,indent=2));raise
