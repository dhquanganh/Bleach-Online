package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Rebirth.TRebirthData;
   import Logics.Unlocks.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.filters.*;
   import flash.text.*;
   
   public class TWindowMainFunction extends TWindowBase
   {
      
      protected static const TYPE_Function_Return:uint = CONST_SHORTCUTS.TYPE_MainFunction_ReturnCity;
      
      protected static const COORDINATE_Shortcut_X:int = 610;
      
      protected static const COORDINATE_Shortcut_Y:int = 55;
      
      protected static const COORDINATE_MainFunctionBtn:Vector.<int> = Vector.<int>([0,-25]);
      
      protected var FBackground:Sprite;
      
      protected var FMC_ProgressBarExp:Sprite;
      
      protected var FTF_Experience:TextField;
      
      protected var FEffectsBaseGlow:Vector.<TEffectBaseGlow>;
      
      protected var FCharacter:TCharacter;
      
      protected var FGlowFilter:GlowFilter;
      
      protected var FWidth:int;
      
      protected var FHeight:int;
      
      protected var FRebirthData:TRebirthData;
      
      public function TWindowMainFunction(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FEffectsBaseGlow = new Vector.<TEffectBaseGlow>();
         this.FGlowFilter = new GlowFilter(8453888,0.6,3,3,8,10,false,false);
         FShortcutsPosition = CONST_SHORTCUTS.POSITION_MainFunction;
         FShortcutsTypes = CONST_SHORTCUTS.TYPE_MAINFUNCTIONS;
         FBtnCoordinates = COORDINATE_MainFunctionBtn;
         this.FWidth = 0;
         this.Visible = false;
         this.mouseEnabled = false;
         this.FRebirthData = SLogicsCore.RebirthData;
      }
      
      override protected function Resources_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Sprite = null;
         var _loc5_:SimpleButton = null;
         var _loc6_:THint = null;
         var _loc7_:Vector.<String> = null;
         FClassNameBmpLeft = CONST_SHORTCUTS.RESOURCE_ClassName_Function_Bmp_Left;
         FClassNameBmpMiddle = CONST_SHORTCUTS.RESOURCE_ClassName_Function_Bmp_Middle;
         FClassNameBmpRight = CONST_SHORTCUTS.RESOURCE_ClassName_Function_Bmp_Right;
         FResourceClassNameBtns = CONST_SHORTCUTS.RESOURCE_ClassName_Function_Btns;
         super.Resources_UIDispatch();
         this.FBackground = TUtilityReflection.CreateDisplayObjectInstance(CONST_SHORTCUTS.RESOURCE_ClassName_Function_MC_Background) as Sprite;
         addChild(this.FBackground);
         this.FBackground.y = -1;
         this.FBackground.mouseEnabled = false;
         this.FBackground.mouseChildren = false;
         _loc4_ = this.FBackground[CONST_SHORTCUTS.RESOURCE_Link_MC_ProgressBarExpMountPoint];
         _loc4_.mouseEnabled = false;
         _loc4_.mouseChildren = false;
         this.FMC_ProgressBarExp = TUtilityReflection.CreateDisplayObjectInstance(CONST_SHORTCUTS.RESOURCE_Link_MC_ProgressBarExp) as Sprite;
         _loc4_.addChild(this.FMC_ProgressBarExp);
         this.FTF_Experience = this.FBackground[CONST_SHORTCUTS.RESOURCE_Link_TF_Exp];
      }
      
      override protected function Resources_UILocations() : void
      {
         FUIShortcut.OnOver = this.BtnOnOver;
         FUIShortcut.OnOut = this.BtnOnOut;
         FUIShortcut.OnDown = this.BtnOnDown;
         FUIShortcut.OnUp = this.BtnOnUp;
         FUIShortcut.X = COORDINATE_Shortcut_X;
         FUIShortcut.Y = COORDINATE_Shortcut_Y;
         super.Resources_UILocations();
      }
      
      override protected function UpdateShortcuts() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:SimpleButton = null;
         if(!FUIShortcut.IsInitialization)
         {
            return;
         }
         _loc2_ = int(FUIShortcut.Capacity);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FUIShortcut.GetBmp_Middle(_loc1_);
            _loc4_ = FUIShortcut.GetButtonByIndex(_loc1_);
            _loc3_.visible = _loc4_.visible;
            _loc1_++;
         }
         FUIShortcut.UpdateComponentsLocation();
         FUIShortcut.X = 729 - 110 - FUIShortcut.Bounds.Width;
         FUIShortcut.Y = 55;
      }
      
      protected function UpdateEffectsGlow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEffectBaseGlow = null;
         _loc2_ = int(this.FEffectsBaseGlow.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FEffectsBaseGlow[_loc1_];
            _loc3_.Run();
            _loc1_++;
         }
      }
      
      protected function UpdateCharacterInfo() : void
      {
         var _loc1_:THero = null;
         var _loc2_:THeroExp = null;
         var _loc3_:UInt64 = null;
         var _loc4_:UInt64 = null;
         var _loc5_:Number = NaN;
         if(FInitialization)
         {
            _loc1_ = this.FCharacter.MainHero;
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroExp,_loc1_.RebirthLevel) as THeroExp;
            _loc3_ = _loc1_.Experience;
            _loc4_ = this.FRebirthData.CalNeedExpByUInt64(_loc2_.NeedExp,_loc1_.RebirthNum);
            this.FTF_Experience.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_08),_loc3_.ToString(),_loc4_.ToString());
            _loc5_ = _loc3_.ToNumber() / _loc4_.ToNumber();
            if(_loc5_ > 1)
            {
               _loc5_ = 1;
            }
            this.FMC_ProgressBarExp.scaleX = _loc5_;
         }
      }
      
      protected function Reset() : void
      {
         this.FTF_Experience.text = "EXP: 0/0";
      }
      
      protected function UpdateBounds() : void
      {
         if(!FInitialization)
         {
            return;
         }
         if(FUIShortcut.Bounds.Width > 0)
         {
            this.FWidth = this.FBackground.width;
            this.FHeight = this.FBackground.height;
         }
         else
         {
            this.FWidth = 0;
            this.FHeight = 0;
         }
      }
      
      override protected function ProcessorShortcutShowEffect(param1:uint, param2:Boolean) : void
      {
         var _loc3_:Boolean = false;
         _loc3_ = FUIShortcut.GetIsEffectByIndex(param1);
         if(_loc3_ != param2)
         {
            FUIShortcut.SetIsEffectByIndex(param2,param1);
         }
         if(param2)
         {
            this.OpenButtonEffect(param1);
         }
         else
         {
            this.TerminationButtonEffect(param1);
         }
      }
      
      protected function OpenButtonEffect(param1:int) : void
      {
         var _loc2_:SimpleButton = null;
         var _loc3_:TEffectBaseGlow = null;
         if(!FUIShortcut.IsInitialization)
         {
            return;
         }
         _loc2_ = FUIShortcut.GetButtonByIndex(param1);
         if(_loc2_.filters != null && _loc2_.filters.length == 0)
         {
            _loc3_ = new TEffectBaseGlow();
            _loc3_.SetParameters(_loc2_,16724787,1);
            _loc3_.Run();
            this.FEffectsBaseGlow.push(_loc3_);
         }
      }
      
      protected function TerminationButtonEffect(param1:int) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:SimpleButton = null;
         var _loc5_:TEffectBaseGlow = null;
         if(!FUIShortcut.IsInitialization)
         {
            return;
         }
         _loc4_ = FUIShortcut.GetButtonByIndex(param1);
         _loc3_ = int(this.FEffectsBaseGlow.length);
         _loc2_ = int(_loc3_ - 1);
         while(_loc2_ >= 0)
         {
            _loc5_ = this.FEffectsBaseGlow[_loc2_];
            if(_loc5_ == null)
            {
               break;
            }
            if(_loc4_ == _loc5_.Source)
            {
               _loc5_.Stop();
               this.FEffectsBaseGlow.splice(_loc2_,1);
               _loc5_.Dispose();
               _loc5_ = null;
               break;
            }
            _loc2_--;
         }
      }
      
      protected function BtnOnOver(param1:Object, param2:int) : void
      {
         var _loc3_:SimpleButton = null;
         _loc3_ = FUIShortcut.GetButtonByIndex(param2);
         if(_loc3_.filters.length == 0)
         {
            _loc3_.filters = [this.FGlowFilter];
         }
      }
      
      protected function BtnOnOut(param1:Object, param2:int) : void
      {
         var _loc3_:SimpleButton = null;
         _loc3_ = FUIShortcut.GetButtonByIndex(param2);
         _loc3_.filters = [];
      }
      
      protected function BtnOnDown(param1:Object, param2:int) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:SimpleButton = null;
         _loc4_ = param1 as SimpleButton;
         if(_loc4_.filters.length > 0)
         {
            _loc4_.filters = [];
         }
         _loc3_ = FUIShortcut.GetIsEffectByIndex(param2);
         if(_loc3_)
         {
            this.ProcessorShortcutShowEffect(param2,false);
         }
      }
      
      protected function BtnOnUp(param1:Object, param2:int) : void
      {
         var _loc3_:SimpleButton = null;
         _loc3_ = param1 as SimpleButton;
         if(_loc3_.filters.length == 0)
         {
            _loc3_.filters = [this.FGlowFilter];
         }
      }
      
      override public function get ShortcutWidth() : int
      {
         this.UpdateBounds();
         return this.FWidth;
      }
      
      public function get ShortcutHeight() : int
      {
         this.UpdateBounds();
         return this.FHeight;
      }
      
      override public function Perform_UIDispatch() : void
      {
         this.Resources_UIDispatch();
         this.Resources_UILocations();
         this.Reset();
         FInitialization = true;
      }
      
      override public function Update() : void
      {
         this.UpdateEffectsGlow();
      }
      
      override public function UpdateShortcutsState(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:SimpleButton = null;
         _loc3_ = int(FShortcutsTypes.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = FUIShortcut.GetButtonByIndex(_loc2_);
            if(FOnQueryShortcutUnlock != null)
            {
               FQueryShortcut.Value = false;
               FOnQueryShortcutUnlock(this,FShortcutsPosition,_loc2_,FQueryShortcut);
            }
            _loc4_.visible = FQueryShortcut.Value;
            if(_loc2_ == TYPE_Function_Return)
            {
               _loc4_.visible = false;
            }
            _loc2_++;
         }
         this.UpdateShortcuts();
      }
      
      override public function UnlockingNotification(param1:TUnlock) : void
      {
         var _loc2_:SimpleButton = null;
         var _loc3_:TCoordinate = null;
         var _loc4_:TBounds = null;
         _loc2_ = FUIShortcut.GetButtonByIndex(param1.Index);
         _loc2_.alpha = 0;
         _loc2_.visible = true;
         this.UpdateShortcuts();
         if(FOnUnlockResponse != null)
         {
            _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc2_);
            _loc4_ = new TBounds();
            _loc4_.Assign(_loc3_);
            _loc4_.Width = _loc2_.width;
            _loc4_.Height = _loc2_.height;
            FOnUnlockResponse(this,_loc4_,_loc2_);
         }
         this.ProcessorShortcutShowEffect(param1.Index,true);
      }
      
      public function UserUpdateCharBaseInfo() : void
      {
         this.UpdateCharacterInfo();
      }
      
      override public function QueryShortcutCoordinate(param1:Object, param2:uint, param3:TQueryCoordinate) : void
      {
         var _loc4_:SimpleButton = null;
         var _loc5_:TCoordinate = null;
         _loc4_ = FUIShortcut.GetButtonByIndex(param2);
         _loc5_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc4_);
         _loc5_.X += _loc4_.width - 20;
         _loc5_.Y += _loc4_.height - 20;
         param3.Value.Assign(_loc5_);
      }
   }
}

