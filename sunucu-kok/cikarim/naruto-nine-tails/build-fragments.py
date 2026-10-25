from pathlib import Path
import importlib.util
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fragments',BASE.parent/'ninja-fragments/build.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
m.FEATURES=[(11120994,14130994,41120994,'Naruto [Nine-Tails Chakra]','../../asset/Naruto_Nine_Tails_Chakra_Full/assets/battle/role/head_45_45/11000131.png',5)]
m.ICON_IDS[14130994]=14130994+0x200000
if __name__=='__main__':m.main()
