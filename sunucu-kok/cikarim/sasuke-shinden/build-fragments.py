from pathlib import Path
import importlib.util
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fragments',BASE.parent/'ninja-fragments/build.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
m.FEATURES=[(11120970,14130970,41120970,'Sasuke Uchiha [Sasuke Shinden]','../../asset/Sasuke_Shinden_Full/assets/bag/item/11014821.png',7)]
m.ICON_IDS[14130970]=14130970+0x200000
if __name__=='__main__':m.main()
