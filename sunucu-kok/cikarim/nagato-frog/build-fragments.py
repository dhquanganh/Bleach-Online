from pathlib import Path
import importlib.util
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fragments',BASE.parent/'ninja-fragments/build.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
m.FEATURES=[(11120990,14130990,41120990,'Nagato [Frog Squad]','../../asset/Nagato_Frog_Squad_Full/assets/battle/role/head_45_45/11009621.png',6)]
m.ICON_IDS[14130990]=14130990+0x200000
if __name__=='__main__':m.main()
