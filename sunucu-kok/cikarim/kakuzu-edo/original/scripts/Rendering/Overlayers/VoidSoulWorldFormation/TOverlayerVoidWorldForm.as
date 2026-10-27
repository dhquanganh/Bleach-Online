package Rendering.Overlayers.VoidSoulWorldFormation
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.VoidSoulWorld.TVoidWorldForm;
   import Logics.VoidSoulWorld.VO.TFormHeroVO;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.TOverlayer;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   
   public class TOverlayerVoidWorldForm extends TOverlayer
   {
      
      protected const PosList:Vector.<uint> = Vector.<uint>([12,11,13,7,6,8,1]);
      
      protected var FSingleDesc:String;
      
      protected var FSingleAdd:uint;
      
      protected var FBtmList:Vector.<Bitmap>;
      
      protected var FMainUI:MovieClip;
      
      public function TOverlayerVoidWorldForm(param1:TUIComponent)
      {
         super(param1);
         FOvarlaySubstrate.visible = false;
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TVoidWorldForm;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:TVoidWorldForm = null;
         var _loc2_:TFormHeroVO = null;
         var _loc3_:Bitmap = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:MovieClip = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         _loc1_ = FContext as TVoidWorldForm;
         _loc5_ = this.PosList.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = this.FBtmList[_loc4_];
            _loc3_.bitmapData = null;
            _loc7_ = this.PosList[_loc4_];
            _loc6_ = this.FMainUI["MC_Pos_" + _loc7_];
            _loc6_.TF_Desc.text = "";
            _loc4_++;
         }
         _loc8_ = 0;
         for each(_loc2_ in _loc1_.Heros)
         {
            _loc6_ = this.FMainUI["MC_Pos_" + _loc2_.Pos];
            if(_loc1_.SpecialHeroID.indexOf(_loc2_.HeroID) != -1)
            {
               _loc6_.TF_Desc.text = TUtilityString.Format(this.FSingleDesc,this.FSingleAdd);
               _loc6_.TF_Desc.textColor = 65280;
               _loc8_ += this.FSingleAdd;
            }
            else
            {
               _loc6_.TF_Desc.text = TUtilityString.Format(this.FSingleDesc,0);
               _loc6_.TF_Desc.textColor = 16711680;
            }
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc2_.HeroID,this.LoadOK);
         }
         this.FMainUI.TF_AllAttAdd.text = _loc8_ + "%";
      }
      
      override protected function EvaluationPerform_Substrate() : void
      {
         TUtilityCartisian.BoundsSetSize(FBoundsSubstrate,width,height);
      }
      
      protected function LoadOK(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TVoidWorldForm = null;
         var _loc5_:TFormHeroVO = null;
         var _loc6_:uint = 0;
         var _loc7_:Bitmap = null;
         _loc4_ = FContext as TVoidWorldForm;
         if(_loc4_ == null)
         {
            return;
         }
         _loc5_ = _loc4_.GetHeroByID(param3);
         _loc6_ = this.PosList.indexOf(_loc5_.Pos);
         _loc7_ = this.FBtmList[_loc6_];
         _loc7_.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:Bitmap = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_VoidSoulWorldFormation") as MovieClip;
         addChild(this.FMainUI);
         this.FSingleDesc = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VoidSoulWorld_06);
         this.FSingleAdd = uint(TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_HeroAdd));
         this.FBtmList = new Vector.<Bitmap>();
         _loc2_ = this.PosList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.PosList[_loc1_];
            _loc4_ = this.FMainUI["MC_Pos_" + _loc3_];
            _loc5_ = new Bitmap();
            _loc4_.MC_Head.MC_Bmp_Icon.addChild(_loc5_);
            this.FBtmList.push(_loc5_);
            _loc1_++;
         }
      }
   }
}

