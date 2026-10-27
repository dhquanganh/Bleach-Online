package Processors.Game.Marquee
{
   import Components.HyperStrings.*;
   import Externals.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Logics.HyperStrings.*;
   import Logics.HyperStrings.Atoms.*;
   import Logics.HyperStrings.Elements.*;
   import Processors.Game.*;
   import Processors.Game.Common.*;
   import Processors.Game.Marquee.Data.*;
   import Rendering.HyperStrings.Data.*;
   import Resources.Constants.*;
   import Utilities.UI.Marquees.*;
   import flash.utils.*;
   
   public class TProcessorMarquee extends TProcessorOverView
   {
      
      public static const SEQUENCEID_Default:uint = 0;
      
      protected static const CAPACITY_BARS:uint = 3;
      
      protected static const SIZE_MarqueeWidth:int = 800;
      
      protected static const SIZE_Marqueeheight:int = 30;
      
      protected var FHyperStrings:Vector.<THyperString>;
      
      protected var FFontSheet:THyperStringFontSheet;
      
      protected var FUIHyperStringMarquees:Vector.<TUIHyperStringMarquee>;
      
      public function TProcessorMarquee(param1:TUIComponent)
      {
         super(param1);
         FBoundsClient.Width = 0;
         FBoundsClient.Height = 0;
         this.ConstructorUIHyperStringMarquee();
         this.FHyperStrings = new Vector.<THyperString>();
         this.mouseEnabled = false;
      }
      
      protected function ConstructorUIHyperStringMarquee() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIHyperStringMarquee = null;
         this.FUIHyperStringMarquees = new Vector.<TUIHyperStringMarquee>(CAPACITY_BARS);
         this.FFontSheet = new THyperStringFontSheetMarquee();
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_BARS)
         {
            _loc2_ = new TUIHyperStringMarquee(this);
            _loc2_.X = 0;
            _loc2_.Y = SIZE_Marqueeheight * _loc1_;
            _loc2_.FontSheet = this.FFontSheet;
            _loc2_.UIMessageBypassing = true;
            _loc2_.mouseEnabled = false;
            this.FUIHyperStringMarquees[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfCommon.LoadPrimary(CONST_COMMON.RESOURCESID_SwfCommon_Common);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIHyperStringMarquee = null;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_BARS)
         {
            _loc2_ = this.FUIHyperStringMarquees[_loc1_];
            TUtilityUIMarquee.ResourcesDispatch(_loc2_);
            _loc1_++;
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:THyperString = null;
         super.LogicsPerform();
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_BARS)
         {
            if(this.FUIHyperStringMarquees[_loc1_].Animating)
            {
               if(!this.FUIHyperStringMarquees[_loc1_].Visible)
               {
                  this.FUIHyperStringMarquees[_loc1_].Visible = true;
               }
            }
            else if(this.FHyperStrings.length != 0)
            {
               _loc2_ = this.FHyperStrings.shift();
               this.FUIHyperStringMarquees[_loc1_].SpeedCoefficient = this.FHyperStrings.length;
               this.FUIHyperStringMarquees[_loc1_].Animate(_loc2_);
               _loc2_.StubReferences.Dereference(this);
               this.FUIHyperStringMarquees[_loc1_].Visible = true;
            }
            else
            {
               this.FUIHyperStringMarquees[_loc1_].Visible = false;
            }
            if(this.FUIHyperStringMarquees[_loc1_].Visible)
            {
               this.FUIHyperStringMarquees[_loc1_].UpdateRenderingPerform();
            }
            _loc1_++;
         }
      }
      
      protected function LinkOnClick(param1:Object, param2:THyperStringAtom) : void
      {
         var _loc3_:THyperStringElement = null;
         _loc3_ = param2.Element;
         if(_loc3_ is THyperStringElementLinkURL)
         {
            SExternalCore.NavigateToLinkUrl((_loc3_ as THyperStringElementLinkURL).HyperlinkAddress);
         }
      }
      
      public function StartMarquee(param1:Object) : void
      {
         var _loc2_:THyperString = null;
         if(param1 is THyperString)
         {
            _loc2_ = param1 as THyperString;
            _loc2_.StubReferences.Reference(this);
            this.FHyperStrings.push(_loc2_);
         }
      }
   }
}

