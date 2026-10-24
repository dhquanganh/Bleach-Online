from pathlib import Path
import importlib.util
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fragments',BASE.parent/'ninja-fragments/build.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
m.FEATURES=[(11120991,14130991,41120991,'Gaara [Swimsuit]','../../asset/Gaara_Swimsuit_Full/assets/battle/role/head_45_45/11001361.png',7)]
m.ICON_IDS[14130991]=14130991+0x200000
if __name__=='__main__':m.main()
