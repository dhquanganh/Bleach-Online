"""Publish Katsuyu textures/table metadata without replacing the current client."""
from pathlib import Path
import importlib.util,json
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('release',B/'release.py');release=importlib.util.module_from_spec(s);s.loader.exec_module(release)
if __name__=='__main__':
 release.VERSION='2026102421'
 assert json.loads((release.P/'client-release.json').read_text())['version']=='2026102421','Install the Katsuyu client first'
 release.main()
