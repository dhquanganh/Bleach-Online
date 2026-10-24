"""Gaara-only zero-copy atlas playback, preserving source frame coordinates."""
from pathlib import Path
import importlib.util
B=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('mecha',B.parent/'mecha-naruto/build-client.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)

def optimize(role):
 player=m.extract(role,'PlayGaaraVfxAsset')
 player=player.replace('var buffer:BitmapData;','var displayedAtlas:String;\n         var displayedCell:String;')
 player=player.replace('layer.visible = buffer != null;','layer.visible = image.bitmapData != null;')
 start=player.index('            if(buffer != null)');end=player.index('            TrimGaaraVfxCache',start)
 player=player[:start]+'''            image.scrollRect = null;
            if(displayedAtlas != null){GaaraPinPages([displayedAtlas],[]);displayedAtlas=null;}
'''+player[end:]
 start=player.index('               var atlas:BitmapData');end=player.index('               if(clip.tint != null)',start)
 player=player[:start]+'''               var rect:Array=clip.frameRects[frame];
               var cellKey:String=frameAtlas+":"+rect[0]+":"+rect[1];
               if(displayedCell!=cellKey){
                  GaaraPinPages(displayedAtlas==null?[]:[displayedAtlas],[frameAtlas]);
                  displayedAtlas=frameAtlas;displayedCell=cellKey;
                  image.bitmapData=BitmapData(frames[0]);
                  image.scrollRect=new Rectangle(rect[0],rect[1],rect[2],rect[3]);
                  image.scaleX=width/Number(clip.width);image.scaleY=height/Number(clip.height);
                  image.x=-width*Number(clip.pivot[0])+Number(rect[4])*image.scaleX;
                  image.y=-height*Number(clip.pivot[1])+Number(rect[5])*image.scaleY;
               }
'''+player[end:]
 assert 'buffer' not in player and 'copyPixels' not in player
 role=role.replace(m.extract(role,'PlayGaaraVfxAsset'),player)
 pump=m.extract(role,'PumpGaaraVfxQueue');assert '>= 6' in pump;role=role.replace(pump,pump.replace('>= 6','>= 2'))
 manifest=m.extract(role,'GaaraVfxManifest');assert 'tick + 21' in manifest;role=role.replace(manifest,manifest.replace('tick + 21','tick + 13'))
 return role
