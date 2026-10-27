from pathlib import Path
import importlib.util
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fragments',BASE.parent/'ninja-fragments/build.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
m.FEATURES=[(11120997,14130997,41120997,'Kakuzu [Edo Tensei]','../../asset/Kakuzu_Edo_Tensei_Full/assets/battle/role/head_45_45/11005451.png',7)]
m.ICON_IDS[14130997]=14130997+0x200000
if __name__=='__main__':m.main()
