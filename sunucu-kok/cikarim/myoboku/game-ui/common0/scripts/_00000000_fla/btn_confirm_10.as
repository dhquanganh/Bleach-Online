package _00000000_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol320")]
   public dynamic class btn_confirm_10 extends MovieClip
   {
      
      public var TF_BtnOkCaption:TextField;
      
      public function btn_confirm_10()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

