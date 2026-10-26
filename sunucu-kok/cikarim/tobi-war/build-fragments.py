from pathlib import Path
import importlib.util
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fragments',BASE.parent/'ninja-fragments/build.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
m.FEATURES=[(11120995,14130995,41120995,'Tobi [Great Ninja War]','../../asset/Tobi_Great_Ninja_War_Full/assets/battle/role/head_45_45/11015511.png',7)]
m.ICON_IDS[14130995]=14130995+0x200000
if __name__=='__main__':m.main()
