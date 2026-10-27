package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class TDecorationName extends TDecoration
   {
      
      protected var FTextFiledNameFormat:TextFormat;
      
      protected var FTextFiledName:TextField;
      
      public function TDecorationName()
      {
         super();
         this.Init();
      }
      
      protected function Init() : void
      {
         this.FTextFiledNameFormat = new TextFormat();
         this.FTextFiledName = new TextField();
         this.FTextFiledName.width = 177;
         this.FTextFiledName.autoSize = TextFieldAutoSize.CENTER;
         this.FTextFiledName.selectable = false;
         this.InitFilters();
         this.addChild(this.FTextFiledName);
      }
      
      protected function SetNameColor(param1:uint) : void
      {
         this.FTextFiledName.textColor = param1;
      }
      
      protected function SetName(param1:String) : void
      {
         this.FTextFiledName.text = param1;
      }
      
      protected function InitFilters() : void
      {
      }
   }
}

