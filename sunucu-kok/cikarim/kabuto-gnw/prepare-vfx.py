"""Prepare original SWF effects; see native-vfx.py for caching and provenance."""
from pathlib import Path
import runpy

if __name__ == '__main__':
    runpy.run_path(str(Path(__file__).with_name('native-vfx.py')), run_name='__main__')
