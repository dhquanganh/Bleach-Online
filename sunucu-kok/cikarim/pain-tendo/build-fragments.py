from pathlib import Path
import importlib.util
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fragments',BASE.parent/'ninja-fragments/build.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
m.FEATURES=[(11120930,14130930,41120930,'Pain - Tendo [Six Paths Rinnegan]','../../asset/Pain_Tendo_Six_Paths_Rinnegan/assets/battle/role/head_45_45/11006531.png',7)]
if __name__=='__main__':m.main()
