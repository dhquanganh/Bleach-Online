package {
 import Foundation.Decoder.Pak.TPakDecoder;import flash.display.*;import flash.events.*;import flash.net.*;import flash.utils.*;import flash.geom.*;import flash.external.ExternalInterface;
 public class TApplication extends MovieClip {
  private var clips:Object={};private var decoders:Array=[];private var loaded:int=0;private var ready:int=-1;private var actor:Bitmap=new Bitmap();private var last:int=-1;
  public function TApplication(){if(stage)boot();else addEventListener(Event.ADDED_TO_STAGE,boot);}
  private function report(s:String):void{ExternalInterface.call("vfxProbe",s);}
  private function boot(e:Event=null):void{stage.scaleMode=StageScaleMode.NO_SCALE;stage.align=StageAlign.TOP_LEFT;stage.frameRate=25;graphics.beginFill(0x172027);graphics.drawRect(0,0,1250,650);graphics.endFill();graphics.lineStyle(1,0xFFD363);graphics.drawRect(400,80,450,500);graphics.moveTo(400,430);graphics.lineTo(850,430);actor.smoothing=true;addChild(actor);loadTexture("A9B1620E",["profile"]);addEventListener(Event.ENTER_FRAME,tick);}
  private function tick(event:Event):void{try{
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<1)return;
   var clip:Object=clips.profile;
   if(ready<0){ready=getTimer();actor.x=625-clip.meta[0].px;actor.y=450-clip.meta[0].py;report("CASE fixed-first-pivot partner idle, 34 frames");}
   var frame:int=int((getTimer()-ready)/80);if(frame>=clip.images.length){report("DONE profile idle; checked="+clip.images.length+" remaining=0");removeEventListener(Event.ENTER_FRAME,tick);return;}
   if(frame==last)return;last=frame;
   if(clip.meta[frame].px!=clip.meta[0].px || clip.meta[frame].py!=clip.meta[0].py)throw new Error("profile pivot drift");
   actor.bitmapData=clip.images[frame];var box:Rectangle=actor.bitmapData.getColorBoundsRect(0xFF000000,0,false);
   if(actor.y+box.bottom>430 || actor.y+box.top<80)throw new Error("idle overlaps stats or header");
   if(frame%8==0 || frame==33)saveFrame("profile-idle-"+frame);
  }catch(e:Error){report("ERROR "+e);removeEventListener(Event.ENTER_FRAME,tick);}}
  private function loadTexture(path:String,names:Array):void {
   var loader:URLLoader=new URLLoader();loader.dataFormat=URLLoaderDataFormat.BINARY;
   loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void {report("ERROR texture "+path+" "+e.text);});
   loader.addEventListener(Event.COMPLETE,function(e:Event):void {
    var bytes:ByteArray=loader.data as ByteArray;bytes.endian=Endian.LITTLE_ENDIAN;bytes.readUnsignedInt();
    var count:uint=bytes.readUnsignedInt();var seq:ByteArray=new ByteArray();seq.endian=Endian.LITTLE_ENDIAN;bytes.readBytes(seq,0,count);
    var total:uint=bytes.readUnsignedShort();var all:Array=[];
    for(var j:int=0;j<total;j++){
     seq.readUnsignedInt();seq.readUnsignedByte();count=seq.readUnsignedShort();var meta:Array=[];
     for(var k:int=0;k<count;k++){seq.readShort();seq.readShort();seq.readUnsignedShort();seq.readUnsignedShort();meta.push({px:seq.readShort(),py:seq.readShort(),duration:seq.readUnsignedShort()});}
     all.push(meta);
    }
    for(j=0;j<total;j++){
     count=bytes.readUnsignedInt();var pak:ByteArray=new ByteArray();bytes.readBytes(pak,0,count);
     decodeTexture(pak,String(names[j]),all[j]);
    }
   });
   loader.load(new URLRequest("/public/2026090619/Resources/Textures/Model/"+path+".TexClient"));
  }
  private function decodeTexture(pak:ByteArray,name:String,meta:Array):void {
   var decoder:TPakDecoder=new TPakDecoder();decoders.push(decoder);
   decoder.OnResourceUnstreamized=function(sender:Object,images:Vector.<BitmapData>,index:uint):void {
    clips[name]={images:images,meta:meta};loaded++;report("TEXTURE "+name+" frames="+images.length);
   };
   decoder.Unstreamize(pak,new Vector.<BitmapData>(),0);
  }
  private function saveFrame(name:String):void {
   var snapshot:BitmapData=new BitmapData(1250,650,false,0);
   snapshot.draw(this);
   var png:ByteArray=snapshot.encode(snapshot.rect,new JPEGEncoderOptions(88));
   var hex:String="";png.position=0;
   while(png.bytesAvailable){var value:String=png.readUnsignedByte().toString(16);hex+=value.length<2?"0"+value:value;}
   if(ExternalInterface.available)ExternalInterface.call("vfxSnapshot",name,hex);
   snapshot.dispose();
  }
 }
}