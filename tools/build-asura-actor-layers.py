from pathlib import Path
import importlib.util,json,shutil
R=Path.cwd();B=R/'sunucu-kok/cikarim/asura-guardian';s=importlib.util.spec_from_file_location('p',B.parent/'pain-tendo/prepare-assets.py');p=importlib.util.module_from_spec(s);s.loader.exec_module(p);root,images=p.decode(R/'asset/Asura_Guardian_of_the_Land_Full/assets/battle/role/left/11014011.swf');assets={a.get('id'):a for a in root.findall('asset')}
mp={13122501:('SP_skill5',[4]),13122505:('SP_skill2',[0]),13122506:('SP_skill3',[0,1,2]),13122508:('SP_skill6',[0,1]),13122509:('SP_skill4',[0])};data={}
for ident,(action,indices) in mp.items():
 a=next(x for x in root.findall('action') if x.get('name')==action);layers=[]
 for i in reversed(indices):
  frames=[]
  for f in a.findall('layer')[i].findall('frame'):
   es=[]
   for el in f.findall('element'):
    asset=assets[el.get('assetId')];e={**el.attrib,'bitmap':asset.get('className'),'ax':float(asset.get('x',0)),'ay':float(asset.get('y',0))};es.append(e)
   frames.append({'start':int(f.get('index')),'length':int(f.get('length')),'elements':es})
  layers.append(frames)
 data[str(ident)]=layers
public=R/'sunucu-kok/kaynak/login.gogames.me/public/asura-guardian-vfx/native';shutil.copy2(R/'asset/Asura_Guardian_of_the_Land_Full/assets/battle/role/left/11014011.swf',public/'AsuraActor.swf')
f=B/'native.as.txt';text=f.read_text().replace('LoadAsuraNative(effect);\n      }','LoadAsuraNative(effect);LoadAsuraNative("AsuraActor");\n      }',1).replace('         FAsuraVfxStarted=true;','         FAsuraVfxStarted=true;PlayAsuraActor();',1)
helper='''
      private static var FAsuraBitmaps:Object={};
      private static function AsuraActorData():Object {return JSON.parse(__DATA__);}
      private function PlayAsuraActor():void {
         var layers:Array=AsuraActorData()[String(FSkillId)] as Array;if(layers==null)return;
         LoadAsuraNative("AsuraActor");var caster:TRole=this;var host:DisplayObjectContainer=FBattleStage;if(host==null||stage==null)return;
         var layer:Sprite=new Sprite();layer.name="asuraSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;host.addChild(layer);FAsuraLayers.push(layer);
         var serial:uint=FCombatVfxSerial;var skill:uint=FSkillId;var last:int=-1;var tick:Function;var clear:Function;var cleaned:Boolean=false;
         clear=function(e:Event=null):void {if(cleaned||e!=null&&e.target!=layer)return;cleaned=true;layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,clear);if(layer.parent)layer.parent.removeChild(layer);};
         tick=function(e:Event=null):void {
            if(host.stage==null||caster.stage==null||caster.FCombatVfxSerial!=serial||caster.FSkillId!=skill||(caster.FIndex!=TYPE_ACTIVE_ATTACK&&caster.FIndex!=TYPE_ACTIVE_SKILL)){clear();return;}
            var state:Object=FAsuraNative["AsuraActor"];if(state==null||state.domain==null)return;
            var frame:int=Math.floor(caster.FFrameIndex*24/25);if(frame==last)return;last=frame;
            while(layer.numChildren)layer.removeChildAt(0);
            for each(var frames:Array in layers)for each(var node:Object in frames)if(frame>=node.start&&frame<node.start+node.length)for each(var part:Object in node.elements){
               var bitmap:BitmapData=FAsuraBitmaps[part.bitmap] as BitmapData;
               if(bitmap==null&&state.domain.hasDefinition(part.bitmap)){var type:Class=state.domain.getDefinition(part.bitmap) as Class;bitmap=new type() as BitmapData;FAsuraBitmaps[part.bitmap]=bitmap;}
               if(bitmap==null)continue;
               var image:Bitmap=new Bitmap(bitmap,"auto",true);var matrix:flash.geom.Matrix=new flash.geom.Matrix();matrix.translate(Number(part.ax),Number(part.ay));matrix.scale(part.scaleX==null?1:Number(part.scaleX),part.scaleY==null?1:Number(part.scaleY));matrix.rotate(Number(part.rotation||0)*Math.PI/180);matrix.translate(Number(part.x||0),Number(part.y||0));image.transform.matrix=matrix;image.alpha=part.alpha==null?1:Number(part.alpha);layer.addChild(image);
            }
            var at:Point=host.globalToLocal(caster.localToGlobal(new Point()));layer.x=at.x;layer.y=at.y;layer.scaleX=caster.scaleX<0?-.84:.84;layer.scaleY=.84;
            if(skill==13122501){var fit:Number=Math.min(host.stage.stageWidth*.56/2483,host.stage.stageHeight*.72/1776);var direction:Number=caster.scaleX<0?-1:1;layer.scaleX=fit*direction;layer.scaleY=fit;layer.x=at.x+197.5*fit*direction;layer.y=at.y-161*fit;}

         };
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,clear);tick();
      }
'''.replace('__DATA__',json.dumps(json.dumps(data,separators=(',',':'))))
f.write_text(text+helper)
print('Native Asura actor overlays',len(data),'skills; original bitmap SWF 3.6 MiB')
