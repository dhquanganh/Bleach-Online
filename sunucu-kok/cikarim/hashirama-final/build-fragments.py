from pathlib import Path
import importlib.util
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fragments',BASE.parent/'ninja-fragments/build.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
m.FEATURES=[(11120940,14130940,41120940,'Hashirama Senju [The Final Battle]','../../asset/Hashirama_Senju_Final_Battle/assets/battle/role/head_45_45/11003341.png',7)]
if __name__=='__main__':m.main()
