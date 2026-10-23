"""Extract reusable codecs before deleting a character's build workspace."""
from pathlib import Path
import re
BASE=Path(__file__).resolve().parent
C=BASE.parent
old=C/'kabuto-gnw';shared=C/'shared-animation';shared.mkdir(exist_ok=True)
s=(old/'native-assets.py').read_text()
s=s[:s.index('\ndef main():')]
s=s.replace("SOURCE = BASE.parents[2] / 'asset/Kabuto_Great_Ninja_War_Full/assets'",'')
(shared/'mme.py').write_text(s,encoding='utf-8')
s=(old/'build.py').read_text();func=s[s.index('def packed_sequence('):s.index('\nnative.texture_sequence=')]
header='''"""Shared native table serializer and compact animation packing."""
from pathlib import Path
from PIL import Image
import hashlib,importlib.util,io,struct,sys,zlib
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
spec=importlib.util.spec_from_file_location('native_animation',BASE.parent/'naruto-sage/build.py')
native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)
'''
(shared/'packing.py').write_text(header+func+'\nnative.texture_sequence=packed_sequence\n',encoding='utf-8')
s=(old/'raster-vfx.as.txt').read_text();s=s[:s.index('      private function UpdateKabutoVfx(')]
start=s.index('      private static function PreloadKabutoVfx(');end=s.index('      private static function LoadKabutoVfxAtlas(',start)
s=s[:start]+'''      private static function PreloadRasterTemplateVfx(heroId:int=0):void {
         var manifest:Object=RasterTemplateVfxManifest();
         for(var key:String in manifest.atlases)LoadRasterTemplateVfxAtlas(key,manifest.atlases[key]);
      }

'''+s[end:]
s=s.replace('Kabuto','RasterTemplate').replace('kabuto','rasterTemplate').replace('__KABUTO_VFX_MANIFEST__','__RASTER_VFX_MANIFEST__')
(shared/'raster-vfx.as.txt').write_text(s,encoding='utf-8')
for file in C.rglob('*.py'):
    if any(part in {'kabuto-gnw','kabuto-gnw-new','character-removal','backups'} for part in file.parts):continue
    s=file.read_text(encoding='utf-8');original=s
    s=s.replace("kabuto-gnw/native-assets.py","shared-animation/mme.py").replace("kabuto-gnw/build.py","shared-animation/packing.py")
    s=s.replace("kabuto-gnw/raster-vfx.as.txt","shared-animation/raster-vfx.as.txt")
    s=s.replace("runtime[:runtime.index('      private function UpdateKabutoVfx(')]","runtime")
    s=s.replace(".replace('Kabuto','Pain').replace('kabuto','pain')",".replace('RasterTemplate','Pain').replace('rasterTemplate','pain')")
    s=s.replace(".replace('Kabuto','Obito').replace('kabuto','obito')",".replace('RasterTemplate','Obito').replace('rasterTemplate','obito')")
    s=s.replace('__KABUTO_VFX_MANIFEST__','__RASTER_VFX_MANIFEST__')
    s=s.replace('PrepareDormantKabuto','PrepareBattleRole').replace('kabutoRasterHost','battleRasterHost').replace('kabutoRasterIndex','battleRasterIndex')
    s=s.replace("private var FKabutoVfxStarted:Boolean","private var FJiraiyaVfxStarted:Boolean").replace('this.UpdateKabutoVfx();','this.UpdateJiraiyaVfx();')
    if file==C/'sasuke-shinden/release.py':
        a=s.index(" kabuto_manifest=");b=s.index(" for p in (CANON/",a);s=s[:a]+s[b:]
    if s!=original:file.write_text(s,encoding='utf-8')
print('PASS shared decoding/packing/raster templates extracted; other builders migrated')
