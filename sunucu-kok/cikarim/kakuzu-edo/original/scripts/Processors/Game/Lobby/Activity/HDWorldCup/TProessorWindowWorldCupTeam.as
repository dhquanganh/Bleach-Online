package Processors.Game.Lobby.Activity.HDWorldCup
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProessorWindowWorldCupTeam extends TProcessorHDSingleWindowBase
   {
      
      protected var FIsInitWindow:Boolean;
      
      protected var FTeams:Vector.<Sprite>;
      
      protected var FMC_Flags:Vector.<TUIButton>;
      
      protected var FMC_SelectBoxs:Vector.<TUIButton>;
      
      protected var FMC_UnSelectBoxs:Vector.<TUIButton>;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FBtn_Return:TUIButton;
      
      protected var FCurTeam:int;
      
      protected var FTeamConfirm:Function;
      
      public function TProessorWindowWorldCupTeam(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "MC_Teams";
         FActivityID = CONST_ACTIVITY_MODE.Activity_WorldCup;
         this.FIsInitWindow = false;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         _loc2_ = 32;
         this.FTeams = new Vector.<Sprite>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FTeams[_loc3_] = FScene["MC_Team_" + _loc3_];
            _loc3_++;
         }
         this.FMC_Flags = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FMC_Flags[_loc3_] = new TUIButton();
            this.FMC_Flags[_loc3_].Substrate = FScene["MC_Flag_" + _loc3_];
            this.FMC_Flags[_loc3_].OnClick = this.ProcessorSelect;
            _loc3_++;
         }
         this.FMC_SelectBoxs = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FMC_SelectBoxs[_loc3_] = new TUIButton();
            this.FMC_SelectBoxs[_loc3_].Substrate = this.FTeams[_loc3_]["MC_SelectBox"]["MC_Selected"];
            this.FMC_SelectBoxs[_loc3_].Visible = false;
            this.FMC_SelectBoxs[_loc3_].OnClick = this.ProcessorSelect;
            _loc3_++;
         }
         this.FMC_UnSelectBoxs = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FMC_UnSelectBoxs[_loc3_] = new TUIButton();
            this.FMC_UnSelectBoxs[_loc3_].Substrate = this.FTeams[_loc3_]["MC_SelectBox"]["MC_Unselected"];
            this.FMC_UnSelectBoxs[_loc3_].OnClick = this.ProcessorSelect;
            _loc3_++;
         }
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = FScene["Btn_OK"];
         this.FBtn_OK.OnClick = this.ProcessorOnClick;
         this.FBtn_Return = new TUIButton();
         this.FBtn_Return.Substrate = FScene["btn_return"];
         this.FBtn_Return.OnClick = this.ProcessorOnClick;
         this.FIsInitWindow = true;
      }
      
      protected function ProcessorOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(param2.currentTarget.name == "Btn_OK")
         {
            if(this.FTeamConfirm != null)
            {
               this.FTeamConfirm(this.FCurTeam);
            }
         }
         else
         {
            this.Hide();
         }
      }
      
      protected function ProcessorSelect(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         _loc6_ = param2.currentTarget.name;
         if(_loc6_.indexOf("Flag") != -1)
         {
            _loc5_ = uint(param2.currentTarget.name.split("_")[2]);
         }
         else
         {
            _loc5_ = uint(param2.currentTarget.parent.parent.name.split("_")[2]);
         }
         _loc3_ = 32;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            this.FMC_SelectBoxs[_loc4_].Visible = false;
            _loc4_++;
         }
         this.FMC_SelectBoxs[_loc5_].Visible = true;
         this.FCurTeam = _loc5_;
      }
      
      override protected function Reset() : void
      {
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick();
         }
      }
      
      public function get TeamConfirm() : Function
      {
         return this.FTeamConfirm;
      }
      
      public function set TeamConfirm(param1:Function) : void
      {
         this.FTeamConfirm = param1;
      }
   }
}

