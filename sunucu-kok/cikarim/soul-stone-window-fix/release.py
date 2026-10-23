from pathlib import Path
import importlib.util,shutil
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('publisher',BASE.parent/'sasuke-shinden/release.py')
publisher=importlib.util.module_from_spec(spec);spec.loader.exec_module(publisher)
publisher.VERSION='2026102235';publisher.main()
shutil.copy2(publisher.BASE/'release.json',BASE/'release.json')
