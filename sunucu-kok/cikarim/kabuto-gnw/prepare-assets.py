"""Prepare Kabuto from the user-supplied extracted pack."""
from pathlib import Path
import runpy

if __name__ == '__main__':
    runpy.run_path(str(Path(__file__).with_name('native-assets.py')), run_name='__main__')
