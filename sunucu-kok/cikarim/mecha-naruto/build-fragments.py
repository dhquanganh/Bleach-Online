from pathlib import Path
import importlib.util
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fragments',BASE.parent/'ninja-fragments/build.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
m.FEATURES=[(11120950,14130950,41120950,'Mecha-Naruto','../../asset/Mecha_Naruto/assets/battle/role/head_45_45/11015001.png',7)]
m.ICON_IDS[14130950]=14130950+0x200000
if __name__=='__main__':m.main()
