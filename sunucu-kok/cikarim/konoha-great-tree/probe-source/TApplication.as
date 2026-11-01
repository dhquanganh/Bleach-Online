package {
 import flash.display.Sprite;import flash.external.ExternalInterface;import flash.utils.ByteArray;
 import Logics.DatebaseVO.VO.TArticle;import Foundation.Resources.Spaces.ResourcesSpace;
 use namespace ResourcesSpace;
 public class TApplication extends Sprite {public function TApplication(){try{
  var hex:String="225be3000d00466f7274756e6520436f696e730100000060000000010000000500000001000000225be300ffff00000100000000000000a8003c703e466f7274756e6520436f696e733c2f703e3c703e5573656420746f2072656465656d207265776172647320696e204b6f6e6f686127732047726561742054726565202d20466f7274756e652053746f726520647572696e6720746865206576656e742e204578706972657320617420746865206576656e7420646561646c696e652e3c2f703e3c703e53656c6c696e672050726963653a2031302053696c7665723c2f703e225be3000700305f315f305f31000000000a0000000000000000000000";var b:ByteArray=new ByteArray();b.endian="littleEndian";for(var i:int=0;i<hex.length;i+=2)b.writeByte(parseInt(hex.substr(i,2),16));b.position=0;
  if(b.readUnsignedInt()!=14900002)throw Error("Wrong Fortune Coin identifier");var item:ProbeArticle=new ProbeArticle();item.Read(b);
  if(b.bytesAvailable!=0 || item.Name!="Fortune Coins" || item.Picture!=14900002 || item.SellPrice!=10 || item.ItemFunction!=0 || !item.ValidFlags())throw Error("Fortune Coin native metadata mismatch");
  ExternalInterface.call("vfxProbe","CASE Fortune Coin native Article decode, sale price, usability and icon OK");ExternalInterface.call("vfxProbe","DONE Fortune Coin native protocol");
 }catch(e:Error){ExternalInterface.call("vfxProbe","ERROR "+e);}}}
 class ProbeArticle extends TArticle {public function Read(data:ByteArray):void{ReadDataByStream(data);}public function ValidFlags():Boolean{return !FExpands[0]&&FExpands[1];}}
}