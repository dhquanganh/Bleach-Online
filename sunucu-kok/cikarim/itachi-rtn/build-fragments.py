from pathlib import Path
import importlib.util
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fragments',BASE.parent/'ninja-fragments/build.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
m.FEATURES=[(11120960,14130960,41120960,'Itachi Uchiha [Road to Ninja]','../../asset/Itachi_Road_to_Ninja/assets/battle/role/head_45_45/11008581.png',7)]
m.ICON_IDS[14130960]=14130960+0x200000
if __name__=='__main__':m.main()
