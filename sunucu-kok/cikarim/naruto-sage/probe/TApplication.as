package {
 import Foundation.Decoder.Pak.TPakDecoder;
 import flash.display.*;
 import flash.events.*;
 import flash.net.*;
 import flash.text.*;
 import flash.utils.*;
 import flash.external.ExternalInterface;
 public class TApplication extends MovieClip {
  private var decoders:Array=[];
  private var sprites:Array=[];
  private var mirrors:Array=[];
  private var frames:Array=[];
  private var metadata:Array=[];
  private var names:Array=["Idle","Fight idle","Barrage","Mystery","Summon","Chase","Hit reaction","Run","Partner showcase"];
  private var paths:Array=["00A9B105","A9B1050A","A9B1050B","A9B1050C","A9B1050C","A9B1050C","A9B1050D","A9B1050F","A9B1050E"];
  private var sequences:Array=[0,0,0,0,1,2,0,0,0];
  public function TApplication(){super();addEventListener(Event.ADDED_TO_STAGE,boot);if(stage!=null)boot();}
  private function report(s:String):void {if(ExternalInterface.available)ExternalInterface.call("narutoProbe",s);}
  private function boot(e:Event=null):void {
   removeEventListener(Event.ADDED_TO_STAGE,boot);stage.scaleMode=StageScaleMode.NO_SCALE;stage.align=StageAlign.TOP_LEFT;
   report("BOOT native multi-sequence/pivot validation");
   graphics.beginFill(0x263544);graphics.drawRect(0,0,1000,730);graphics.endFill();
   for(var i:int=0;i<paths.length;i++){
    loadTexture(i);var t:TextField=new TextField();t.defaultTextFormat=new TextFormat("_sans",16,0xffffff);t.text=names[i]+" / left + right";t.width=330;t.x=10+(i%3)*330;t.y=15+int(i/3)*240;addChild(t);
    graphics.lineStyle(1,0x64798d);graphics.moveTo((i%3)*330+10,215+int(i/3)*240);graphics.lineTo((i%3)*330+325,215+int(i/3)*240);
   }
   addEventListener(Event.ENTER_FRAME,tick);
  }
  private function loadTexture(index:int):void {
   var loader:URLLoader=new URLLoader();loader.dataFormat=URLLoaderDataFormat.BINARY;
   loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void{report("FAIL load "+index+" "+e.text);});
   loader.addEventListener(Event.COMPLETE,function(e:Event):void{
    var b:ByteArray=loader.data as ByteArray;b.endian=Endian.LITTLE_ENDIAN;b.readUnsignedInt();
    var n:uint=b.readUnsignedInt();var seq:ByteArray=new ByteArray();seq.endian=Endian.LITTLE_ENDIAN;b.readBytes(seq,0,n);
    var pakCount:uint=b.readUnsignedShort();var all:Array=[];
    for(var j:int=0;j<pakCount;j++){
     seq.readUnsignedInt();seq.readUnsignedByte();var count:uint=seq.readUnsignedShort();var meta:Array=[];
     for(var k:int=0;k<count;k++){
      seq.readShort();seq.readShort();seq.readUnsignedShort();seq.readUnsignedShort();
      meta.push({px:seq.readShort(),py:seq.readShort(),duration:seq.readUnsignedShort()});
     }
     all.push(meta);
    }
    for(j=0;j<pakCount;j++){
     n=b.readUnsignedInt();var pak:ByteArray=new ByteArray();b.readBytes(pak,0,n);
     if(j==sequences[index]){
      metadata[index]=all[j];var d:TPakDecoder=new TPakDecoder();decoders.push(d);d.OnResourceUnstreamized=decoded;d.Unstreamize(pak,new Vector.<BitmapData>(),index);
     }
    }
    if(b.readUnsignedShort()!=pakCount)report("FAIL sequence count");
   });
   loader.load(new URLRequest("/public/2026090619/Resources/Textures/Model/"+paths[index]+".TexClient"));
  }
  private function decoded(sender:Object,images:Vector.<BitmapData>,index:uint):void {
   frames[index]=images;var pair:Array=[];
   for(var side:int=0;side<2;side++){
    var container:Sprite=new Sprite();container.x=(index%3)*330+(side==0?100:265);container.y=215+int(index/3)*240;container.scaleX=side == 0 ? 0.8 : -0.8;container.scaleY=.8;
    var bmp:Bitmap=new Bitmap(images[0]);container.addChild(bmp);addChild(container);pair.push(bmp);
   }
   sprites[index]=pair[0];mirrors[index]=pair[1];
   var visiblePixels:uint=0;
   for(var i:int=0;i<images.length;i++)for(var y:int=0;y<images[i].height;y++)for(var x:int=0;x<images[i].width;x++)if(images[i].getPixel32(x,y)>>>24)visiblePixels++;
   report((visiblePixels>0 && images.length==metadata[index].length?"PASS":"FAIL")+" native "+names[index]+" sequence="+sequences[index]+" frames="+images.length+" pivots="+metadata[index].length+" visiblePixels="+visiblePixels);
  }
  private function tick(e:Event):void {
   try {
    for each(var d:TPakDecoder in decoders)if(d.Unstreamizing)d.Process();
    for(var i:int=0;i<sprites.length;i++)if(sprites[i]!=null){
     var total:int=0;for each(var m:Object in metadata[i])total+=m.duration;
     var time:int=getTimer()%total;var frame:int=0;
     while(time>=metadata[i][frame].duration && frame<metadata[i].length-1){time-=metadata[i][frame].duration;frame++;}
     for each(var bmp:Bitmap in [sprites[i],mirrors[i]]){bmp.bitmapData=frames[i][frame];bmp.x=-metadata[i][frame].px;bmp.y=-metadata[i][frame].py;}
    }
   } catch(error:Error) {report("FAIL native animation "+error);removeEventListener(Event.ENTER_FRAME,tick);}
  }
 }
}

