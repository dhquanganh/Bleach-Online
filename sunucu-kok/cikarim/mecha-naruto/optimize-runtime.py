"""Lossless runtime optimization: no image, placement or animation timing changes."""
import re
from pathlib import Path

def optimize(role, extract):
    old = extract(role, 'MechaVfxManifest')
    expression = re.search(r'return (JSON.parse\(.*\));', old).group(1)
    new = '''      private static function MechaVfxManifest() : Object
      {
         if(FMechaFxLoading["_manifest"] != null)return FMechaFxLoading["_manifest"];
         var manifest:Object = __EXPRESSION__;
         manifest.firstAtlases = {};
         for each(var clip:Object in manifest.clips)
         {
            manifest.firstAtlases[String(clip.atlas)] = true;
            if(clip.frameAtlases != null)
            {
               clip.nextAtlases = [];
               var next:String = null;
               for(var i:int = clip.frameAtlases.length - 1; i >= 0; i--)
               {
                  if(i + 1 < clip.frameAtlases.length && String(clip.frameAtlases[i]) != String(clip.frameAtlases[i + 1]))next = String(clip.frameAtlases[i + 1]);
                  clip.nextAtlases[i] = next;
               }
            }
         }
         FMechaFxLoading["_manifest"] = manifest;
         return manifest;
      }'''.replace('__EXPRESSION__', expression)
    role = role.replace(old, new)
    old = extract(role, 'MechaFirstAtlas')
    role = role.replace(old, '      private static function MechaFirstAtlas(key:String):Boolean{return MechaVfxManifest().firstAtlases[key] === true;}')
    old = extract(role, 'PlayMechaVfxAsset')
    start = old.index('            if(clip.frameAtlases != null)', old.index('var frameAtlas:'))
    end = old.index('            if(frames == null)', start)
    new = old[:start] + '''            var nextAtlas:String = clip.nextAtlases != null ? clip.nextAtlases[frame] : null;
            if(nextAtlas != null)LoadMechaVfxAtlas(nextAtlas,manifest.atlases[nextAtlas]);
''' + old[end:]
    role = role.replace(old, new)
    old = extract(role, 'LoadMechaVfxAtlas')
    new = old.replace('            var i:int = 0;', '            var rect:Rectangle = new Rectangle(0,0,w,h);\n            var origin:Point = new Point();\n            var i:int = 0;')
    new = new.replace('               cell.copyPixels(source.bitmapData,new Rectangle(i % int(meta.columns) * w,int(i / int(meta.columns)) * h,w,h),new Point());', '               rect.x = i % int(meta.columns) * w;\n               rect.y = int(i / int(meta.columns)) * h;\n               cell.copyPixels(source.bitmapData,rect,origin);')
    # Cells own independent copies; release the decoded PNG immediately rather than waiting for GC.
    new = new.replace('            FMechaFxCache[name] = frames;', '            source.bitmapData.dispose();\n            FMechaFxCache[name] = frames;')
    assert new != old
    role = role.replace(old, new)
    return stream(role, extract)

def stream(role, extract):
    # Bound decoding work and retain the active look-ahead window. Shared cache owns
    # the atlas; each live layer owns just one reusable, exact-size frame buffer.
    text = (Path(__file__).parent / 'streaming.as.txt').read_text()
    old = extract(role, 'PreloadMechaVfx')
    new = old.replace('               LoadMechaVfxAtlas(String(clip.atlas),manifest.atlases[clip.atlas]);', '''               var seen:Object={};
               for(var head:int=0;head<Math.min(5,clip.timeline.length);head++)
               {
                  var page:String=clip.frameAtlases!=null?String(clip.frameAtlases[head]):String(clip.atlas);
                  if(!seen[page]){seen[page]=true;LoadMechaVfxAtlas(page,manifest.atlases[page]);}
               }''')
    assert new != old
    role = role.replace(old, new)
    for name in ['LoadMechaVfxAtlas', 'TrimMechaVfxCache']:
        role = role.replace(extract(role, name), extract(text, name))
    role = role.replace('      private static function LoadMechaVfxAtlas(', extract(text, 'MechaPinPages') + '\n' + extract(text, 'PumpMechaVfxQueue') + '\n      private static function LoadMechaVfxAtlas(', 1)
    old = extract(role, 'MechaVfxManifest')
    new = old.replace('         FMechaFxLoading["_manifest"] = manifest;', '''         for each(var windowClip:Object in manifest.clips)
         {
            windowClip.aheadPages = [];
            for(var tick:int=0;tick<windowClip.timeline.length;tick++)
            {
               var pages:Array=[];
               var seen:Object={};
               for(var j:int=tick;j<Math.min(tick+21,windowClip.timeline.length);j++)
               {
                  var page:String=windowClip.frameAtlases!=null?String(windowClip.frameAtlases[j]):String(windowClip.atlas);
                  if(!seen[page]){seen[page]=true;pages.push(page);}
               }
               windowClip.aheadPages[tick]=pages;
            }
         }
         // Keep only Bomb's opening and the small evasion layers permanently warm.
         // Pinning the first atlas of every large skill consumed almost the entire
         // LRU budget before a single explosion started.
         manifest.firstAtlases = {};
         for each(var warmName:String in ["Jijiamingren_aoyi-1343","Jijiamingren_aoyi-139","Jijiamingren_shanbi-154","Jijiamingren_shanbi-90"])
         {
            var warm:Object=manifest.clips[warmName];
            if(warm!=null)for(var head:int=0;head<Math.min(5,warm.timeline.length);head++)manifest.firstAtlases[String(warm.frameAtlases[head])]=true;
         }
         FMechaFxLoading["_manifest"] = manifest;''')
    role = role.replace(old, new)
    old = extract(role, 'PlayMechaVfxAsset')
    new = old.replace('         var animate:Function;', '''         var buffer:BitmapData;
         var copyRect:Rectangle = new Rectangle();
         var copyOrigin:Point = new Point();
         var pinned:Array = [];
         var cleaned:Boolean = false;
         var animate:Function;''')
    new = new.replace('         LoadMechaVfxAtlas(String(clip.atlas),manifest.atlases[clip.atlas]);', '''         pinned = clip.aheadPages[0];
         MechaPinPages([],pinned);
         for(var pre:int=0;pre<pinned.length;pre++){var preload:String=String(pinned[pre]);LoadMechaVfxAtlas(preload,manifest.atlases[preload],pre==0,pre*2);}''')
    new = new.replace('            layer.removeEventListener(Event.ENTER_FRAME,animate);', '''            if(cleaned)return;
            cleaned=true;
            MechaPinPages(pinned,[]);
            pinned=[];
            layer.removeEventListener(Event.ENTER_FRAME,animate);''')
    new = new.replace('            image.bitmapData = null;', '''            image.bitmapData = null;
            if(buffer!=null){buffer.dispose();buffer=null;}
            TrimMechaVfxCache("");''')
    start = new.index('            LoadMechaVfxAtlas(frameAtlas,')
    end = new.index('            if(frames == null)', start)
    new = new[:start] + '''            var wanted:Array=clip.aheadPages[frame];
            if(pinned!=wanted){MechaPinPages(pinned,wanted);pinned=wanted;}
            for(var ahead:int=0;ahead<wanted.length;ahead++){var page:String=String(wanted[ahead]);LoadMechaVfxAtlas(page,manifest.atlases[page],ahead==0,ahead*2);}
            var frames:Array = FMechaFxCache[frameAtlas] as Array;
''' + new[end:]
    new = new.replace('''            if(frames == null)
            {
               layer.visible = false;
               return;
            }''', '''            if(frames == null)
            {
               // A slow disk must not alternate a visible explosion with an empty layer.
               // Keep the last complete frame until the requested page arrives.
               layer.visible = buffer != null;
               return;
            }''')
    new = new.replace('               image.bitmapData = frames[int(clip.timeline[frame])];', '''               var atlas:BitmapData=BitmapData(frames[0]);
               var meta:Object=manifest.atlases[frameAtlas];
               var cellW:int=int(atlas.width/int(meta.columns));
               var cellH:int=int(atlas.height/int(meta.rows));
               if(buffer==null){buffer=new BitmapData(cellW,cellH,true,0);image.bitmapData=buffer;}
               var cell:int=int(clip.timeline[frame]);
               copyRect.x=cell%int(meta.columns)*cellW;
               copyRect.y=int(cell/int(meta.columns))*cellH;
               copyRect.width=cellW;copyRect.height=cellH;
               buffer.copyPixels(atlas,copyRect,copyOrigin);''')
    assert new != old
    return role.replace(old, new)
