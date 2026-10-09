package Processors.Game.Lobby.HeroChange
{
   import Components.Standard.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Characters.*;
   import Logics.HeroChange.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.*;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_MAP;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   public class TProcessorWindowHeroChangeMainUI extends TProcessorLobbyWindow
   {
      
      public static var StarCounts:Object = {};
      public static var StarData:Object;
      public static var StarRequested:Boolean = false;
      public static var StarPending:Boolean = false;
      protected var StarPanel:Sprite;
      protected var StarTitle:TextField;
      protected var StarModels:Array = [];
      protected var StarPage:int = 0;
      protected var StarMode:Boolean = false;
      protected static const HeroTabNum:int = 4;
      
      protected static var FunctionTabNum:int = 2;
      
      protected static const HeroSourceID:Vector.<int> = Vector.<int>([1,2,3,4]);
      
      protected var FMainUI:Sprite;
      
      protected var FTabFunction:TUITab;
      
      protected var FTabHeros:TUITab;
      
      protected var FTabNames:Vector.<String>;
      
      protected var FProcessorWindowHeroChange:TProcessorWindowHeroChange;
      
      protected var FProcessorWindowTrainField:TProcessorWindowTrainField;
      
      protected var FProcessorWindowInheritance:TProcessorWindowInheritance;
      
      protected var FProcessorWindowSingleChange:TProcessorWindowSingleChange;
      
      protected var FProcessorWindowSingleTrain:TProcessorWindowSingleTrain;
      
      protected var FProcessorWindowMakePill:TProcessorWindowMakePill;
      
      protected var FProcessorWindowExchangePill:TProcessorWindowExchangePill;
      
      protected var FFunctionWindow:Vector.<TProcessorLobbyWindow>;
      
      protected var FCurrentSelectFunctionIndex:int;
      
      protected var FCurrentSelectHeros:THeros;
      
      protected var FLayerMask:Sprite;
      
      protected var FBtnMakePill:TUIButton;
      
      protected var FBtnClose:TUIButton;
      
      protected var FHeroChangeData:THeroChangeData;
      
      public function TProcessorWindowHeroChangeMainUI(param1:TUIComponent)
      {
         FunctionTabNum = 3;
         super(param1);
         this.FFunctionWindow = new Vector.<TProcessorLobbyWindow>();
         this.FProcessorWindowHeroChange = new TProcessorWindowHeroChange(this);
         this.FProcessorWindowHeroChange.OnJmpToHeroChange = this.ShowSingleHeroChange;
         this.FProcessorWindowHeroChange.OnJmpToHeroTrain = this.OpenSingleTrain;
         this.FProcessorWindowHeroChange.OnClose = this.BtnCloseOnClick;
         this.FProcessorWindowTrainField = new TProcessorWindowTrainField(this);
         this.FProcessorWindowTrainField.OnIntoSingleTrain = this.OpenSingleTrain;
         this.FFunctionWindow.push(this.FProcessorWindowHeroChange);
         this.FFunctionWindow.push(this.FProcessorWindowTrainField);
         this.FLayerMask = new Sprite();
         addChild(this.FLayerMask);
         this.FLayerMask.visible = false;
         this.FProcessorWindowSingleChange = new TProcessorWindowSingleChange(this);
         this.FProcessorWindowSingleChange.OnMakePill = this.OpenMakePillWindow;
         this.FProcessorWindowSingleChange.OnClose = this.CancleMouseLock;
         this.FProcessorWindowSingleTrain = new TProcessorWindowSingleTrain(this);
         this.FProcessorWindowSingleTrain.OnClose = this.CancleMouseLock;
         this.FProcessorWindowMakePill = new TProcessorWindowMakePill(this);
         this.FProcessorWindowMakePill.OnExchagne = this.OpenExchangePillWindow;
         this.FProcessorWindowMakePill.OnClose = this.CancleMouseLock;
         this.FProcessorWindowExchangePill = new TProcessorWindowExchangePill(this);
         this.FProcessorWindowExchangePill.OnClose = this.CancleMouseLock;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("HeroChangeMainUI") as Sprite;
         addChildAt(this.FMainUI,0);
         this.FMainUI.alpha = 1;
         this.FTabNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_12);
         _loc2_ = this.FMainUI["MainBoard"];
         this.FTabFunction = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < FunctionTabNum)
         {
            this.FTabFunction.SetTabByIndex(_loc2_["MC_Tab_" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FTabFunction.OnSwitch = this.FunctionTabOnSwitch;
         this.FTabFunction.Init();
         this.FTabHeros = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < HeroTabNum)
         {
            this.FTabHeros.SetTabByIndex(_loc2_["HeroTab" + _loc1_],_loc1_);
            this.FTabHeros.SetTabCaptionByIndex(this.FTabNames[_loc1_],_loc1_);
            _loc1_++;
         }
         this.FTabHeros.OnSwitch = this.HeroTabOnSwitch;
         this.FTabHeros.Init();
         this.FProcessorWindowHeroChange.UIDispatch(this.FMainUI["ChangeUI"]);
         this.FProcessorWindowHeroChange.UILocation();
         this.FProcessorWindowTrainField.UIDispatch(this.FMainUI["HeroTrain"]);
         this.FProcessorWindowTrainField.UILocation();
         this.FMainUI["InheritanceUI"].visible = false;
         _loc2_["MC_Tab_2"].visible = false;
         this.FProcessorWindowSingleChange.UIDispatch();
         this.FProcessorWindowSingleChange.UILocation();
         addChild(this.FProcessorWindowSingleChange);
         this.FProcessorWindowSingleChange.x = (this.FMainUI.width - this.FProcessorWindowSingleChange.width) / 2;
         this.FProcessorWindowSingleChange.y = (this.FMainUI.height - this.FProcessorWindowSingleChange.height) / 2;
         this.FProcessorWindowSingleTrain.UIDispatch();
         this.FProcessorWindowSingleTrain.UILocation();
         addChild(this.FProcessorWindowSingleTrain);
         this.FProcessorWindowSingleTrain.x = (this.FMainUI.width - this.FProcessorWindowSingleTrain.width) / 2;
         this.FProcessorWindowSingleTrain.y = (this.FMainUI.height - this.FProcessorWindowSingleTrain.height) / 2;
         this.FProcessorWindowMakePill.UIDispatch();
         this.FProcessorWindowMakePill.UILocation();
         addChild(this.FProcessorWindowMakePill);
         this.FProcessorWindowMakePill.x = (this.FMainUI.width - this.FProcessorWindowMakePill.width) / 2;
         this.FProcessorWindowMakePill.y = (this.FMainUI.height - this.FProcessorWindowMakePill.height) / 2;
         this.FProcessorWindowExchangePill.UIDispatch();
         this.FProcessorWindowExchangePill.UILocation();
         addChild(this.FProcessorWindowExchangePill);
         this.FProcessorWindowExchangePill.x = (this.FMainUI.width - this.FProcessorWindowExchangePill.width) / 2;
         this.FProcessorWindowExchangePill.y = (this.FMainUI.height - this.FProcessorWindowExchangePill.height) / 2;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = _loc2_["Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FBtnMakePill = new TUIButton();
         this.FBtnMakePill.Substrate = this.FMainUI["MakePill"];
         this.FBtnMakePill.OnClick = this.BtnMakePillOnClick;
         this.FLayerMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FLayerMask.x = -x;
         this.FLayerMask.y = -y;
         var starEntry:Sprite = new Sprite();
         starEntry.graphics.lineStyle(1,0xC9973D);starEntry.graphics.beginFill(0x663710);starEntry.graphics.drawRoundRect(0,0,108,31,5);starEntry.graphics.endFill();
         starEntry.x=_loc2_["HeroTab3"].getBounds(this.FMainUI).x;starEntry.y=_loc2_["HeroTab3"].getBounds(this.FMainUI).bottom+9;
         this.StarText(starEntry,"Nâng sao",17,5,95,14);starEntry.buttonMode=true;starEntry.mouseChildren=false;starEntry.addEventListener(MouseEvent.CLICK,this.ShowStars,false,0,true);this.FMainUI.addChild(starEntry);
         this.StarPanel=new Sprite();this.StarPanel.x=148;this.StarPanel.y=80;this.StarPanel.visible=false;addChild(this.StarPanel);
         this.StarTitle=new TextField();this.StarTitle.defaultTextFormat=new TextFormat("Arial",13,0xFFD77D,true);this.StarTitle.text="Nâng sao  |  Mỗi sao +20% chỉ số";this.StarTitle.x=155;this.StarTitle.y=49;this.StarTitle.width=400;this.StarTitle.height=24;this.StarTitle.mouseEnabled=false;this.StarTitle.visible=false;addChild(this.StarTitle);
         addEventListener(Event.ENTER_FRAME,this.StarTick,false,0,true);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function ResetHeroTab() : void
      {
         this.FTabHeros.SwithTagManual(0);
      }
      
      protected function HeroTabOnSwitch(param1:int) : void
      {
         this.LeaveStars();
         var _loc2_:* = undefined;
         _loc2_ = this.FFunctionWindow[this.FCurrentSelectFunctionIndex];
         _loc2_.ChangeHeroList(this.FHeroChangeData.AllHeroRegistry.GetInstanceByIdentifier(HeroSourceID[param1]),param1);
      }
      
      protected function FunctionTabOnSwitch(param1:int) : void
      {
         this.LeaveStars();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FFunctionWindow.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FFunctionWindow[_loc2_].Visible = false;
            _loc2_++;
         }
         this.FFunctionWindow[param1].Visible = true;
         this.FCurrentSelectFunctionIndex = param1;
         this.ResetHeroTab();
      }
      
      protected function ShowSingleHeroChange(param1:Vector.<THeroChange>, param2:int) : void
      {
         this.FLayerMask.visible = true;
         this.FProcessorWindowSingleChange.Show(param1,param2);
      }
      
      protected function OpenMakePillWindow(param1:Object) : void
      {
         this.FLayerMask.visible = true;
         this.FProcessorWindowMakePill.Show();
      }
      
      protected function CancleMouseLock(param1:Object) : void
      {
         this.FLayerMask.visible = false;
      }
      
      protected function OpenExchangePillWindow(param1:Object) : void
      {
         this.FLayerMask.visible = true;
         this.FProcessorWindowExchangePill.Show();
      }
      
      protected function OpenSingleTrain(param1:Object) : void
      {
         this.FLayerMask.visible = true;
         this.FProcessorWindowSingleTrain.Show(param1 as THeroChange);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent = null) : void
      {
         ProcessorWindowClose();
      }
      
      protected function BtnMakePillOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.OpenMakePillWindow(param1);
      }
      
      public function set HeroChangeData(param1:THeroChangeData) : void
      {
         this.FHeroChangeData = param1;
         this.FProcessorWindowHeroChange.HeroChangeData = param1;
         this.FProcessorWindowSingleChange.HeroChangeData = param1;
         this.FProcessorWindowMakePill.HeroChangeData = param1;
         this.FProcessorWindowExchangePill.HeroChangeData = param1;
         this.FProcessorWindowTrainField.HeroChangeData = param1;
         this.FProcessorWindowSingleTrain.HeroChangeData = param1;
      }
      
      public function Show() : void
      {
         Visible = true;
         this.FTabFunction.SwithTagManual(0);
         if(this.FProcessorWindowSingleTrain.Visible)
         {
            this.FProcessorWindowSingleTrain.FightNotify();
         }
      }
      
      public function ChangeNotify() : void
      {
         this.FProcessorWindowHeroChange.ChangeNotify();
         this.FProcessorWindowSingleChange.ChangeNotify();
      }
      
      public function MakePillNotify() : void
      {
         this.FProcessorWindowMakePill.MakePillNotify();
         this.FProcessorWindowHeroChange.MakePillNotify();
      }
      
      public function ExchangePillNotify() : void
      {
         this.FProcessorWindowExchangePill.ExchangePillNotify();
      }
      
      public function CommonMaterialUpdateNotify() : void
      {
         if(this.FProcessorWindowHeroChange.Visible)
         {
            this.FProcessorWindowHeroChange.CommonMaterialUpdateNotify();
         }
      }
      
      public function GradeMaterialUpdateNotify() : void
      {
         if(this.FProcessorWindowSingleTrain.Visible)
         {
            this.FProcessorWindowSingleTrain.GradeMaterialUpdateNotify();
         }
         if(this.FProcessorWindowTrainField.Visible)
         {
            this.FProcessorWindowTrainField.GradeMaterialUpdateNotify();
         }
      }
      
      public function BuyTimeNotify() : void
      {
         this.FProcessorWindowTrainField.BuyTimeNotify();
      }
      
      public function FightNotify() : void
      {
         if(this.FProcessorWindowTrainField.Visible)
         {
            this.FProcessorWindowTrainField.FightNotify();
         }
         if(this.FProcessorWindowSingleTrain)
         {
            this.FProcessorWindowSingleTrain.FightNotify();
         }
      }
      
      public function OneKeyFightNotify() : void
      {
         this.FProcessorWindowSingleTrain.OneKeyFightNotify();
         if(this.FProcessorWindowTrainField.Visible)
         {
            this.FProcessorWindowTrainField.FightNotify();
         }
      }
      
      public function ReliveNotify() : void
      {
         this.FProcessorWindowSingleTrain.ReliveNotify();
      }
      protected function StarText(root:Sprite,text:String,x:Number,y:Number,w:Number=175,size:int=12,color:uint=0xFFD77D) : TextField
      {
         var t:TextField=new TextField();t.defaultTextFormat=new TextFormat("Arial",size,color,true);t.text=text;t.x=x;t.y=y;t.width=w;t.height=40;t.wordWrap=true;t.mouseEnabled=false;root.addChild(t);return t;
      }
      protected function HideStarSkinText(root:DisplayObjectContainer) : void
      {
         if(root==null)return;
         for(var i:int=0;i<root.numChildren;i++){
            var child:DisplayObject=root.getChildAt(i);
            if(child is TextField)child.visible=false;
            if(child is DisplayObjectContainer)this.HideStarSkinText(child as DisplayObjectContainer);
         }
      }
      protected function StarNativeArt(button:Boolean,w:Number,h:Number) : Bitmap
      {
         var template:Sprite=TUtilityReflection.CreateDisplayObjectInstance("HeroChangeMainUI") as Sprite;
         var area:Sprite=template["ChangeUI"] as Sprite;
         var source:DisplayObject;
         if(button){source=area["MC_Heros_0"]["Btn_OK"];this.HideStarSkinText(source as DisplayObjectContainer);}
         else{
            area["ChipPanle"].visible=false;area["PagePanel"].visible=false;
            for(var i:int=0;i<3;i++)area["MC_Heros_"+i].visible=false;
            source=area;
         }
         var rect:Rectangle=source.getBounds(source);
         var image:BitmapData=new BitmapData(Math.max(1,Math.ceil(rect.width)),Math.max(1,Math.ceil(rect.height)),true,0);
         var matrix:Matrix=new Matrix();matrix.translate(-rect.x,-rect.y);image.draw(source,matrix);
         var result:Bitmap=new Bitmap(image);result.width=w;result.height=h;result.smoothing=true;return result;
      }
      protected function StarBox(root:Sprite,x:Number,y:Number,w:Number,h:Number,color:uint) : void
      {
         root.graphics.lineStyle(1,0x9B7538);root.graphics.beginFill(color,0.96);root.graphics.drawRoundRect(x,y,w,h,7);root.graphics.endFill();
      }
      public static function RequestStarInfo() : void
      {
         StarRequested=true;var p:TPacket=SNetworkCore.PacketAcquire(0x0181f200);SNetworkCore.Transceiver.PacketTransmit(p);
      }
      protected function ShowStars(e:MouseEvent) : void
      {
         this.StarMode=true;
         for(var i:int=0;i<this.FFunctionWindow.length;i++)this.FFunctionWindow[i].Visible=false;
         for(i=0;i<3;i++)this.FMainUI["MainBoard"]["MC_Tab_"+i].visible=false;
         this.FBtnMakePill.Visible=false;this.StarPanel.visible=true;this.StarTitle.visible=true;
         this.RenderStars();RequestStarInfo();
      }
      protected function LeaveStars() : void
      {
         if(!this.StarMode)return;this.StarMode=false;
         if(this.StarPanel!=null)this.StarPanel.visible=false;
         if(this.StarTitle!=null)this.StarTitle.visible=false;
         this.FMainUI["MainBoard"]["MC_Tab_0"].visible=true;this.FMainUI["MainBoard"]["MC_Tab_1"].visible=true;this.FBtnMakePill.Visible=true;
      }
      public function StarStateUpdated() : void
      {
         if(this.StarMode && this.StarPanel!=null)this.RenderStars();
      }
      protected function StarTick(e:Event) : void
      {
         if(Visible && this.StarMode)for each(var model:TSceneSpriteMoudle in this.StarModels)model.UpdateView();
      }
      protected function RenderStars() : void
      {
         while(this.StarPanel.numChildren>0)this.StarPanel.removeChildAt(0);this.StarPanel.graphics.clear();this.StarModels=[];
         this.StarBox(this.StarPanel,0,0,580,355,0x111719);
         this.StarPanel.addChild(this.StarNativeArt(false,580,320));
         if(StarData==null){this.StarText(this.StarPanel,"Đang tải danh sách tướng...",20,20,350,15);return;}
         var rows:Array=StarData.heroes as Array;var pages:int=Math.max(1,Math.ceil(rows.length/3));this.StarPage=Math.min(this.StarPage,pages-1);
         if(rows.length==0)this.StarText(this.StarPanel,"Chiêu mộ tướng và thu thập mảnh để nâng sao.",20,80,530,15);
         for(var i:int=0;i<3;i++)
         {
            var index:int=this.StarPage*3+i;if(index>=rows.length)break;var hero:Object=rows[index];
            var card:Sprite=new Sprite();card.x=8+i*190;card.y=8;card.graphics.lineStyle(1,0xA77B36,0.4);card.graphics.beginFill(0x080C0E,0.25);card.graphics.drawRect(0,0,182,310);card.graphics.endFill();this.StarPanel.addChild(card);
            this.StarText(card,String(hero.name),8,8,167,12,0xF7C334);
            var mount:Sprite=new Sprite();card.addChild(mount);var maskShape:Sprite=new Sprite();maskShape.graphics.beginFill(0);maskShape.graphics.drawRect(5,36,172,168);maskShape.graphics.endFill();card.addChild(maskShape);mount.mask=maskShape;
            var model:TSceneSpriteMoudle=new TSceneSpriteMoudle();model.x=90;model.y=198;mount.addChild(model);
            var query:TMoudleInfor=new TMoudleInfor();TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,uint(hero.id),query);model.ChangeRoleMoudle(query.TextureID,query.Scalx);this.StarModels.push(model);
            this.StarText(card,"★ x "+hero.stars+" / 50",45,207,135,15,0xFFCA54);
            this.StarText(card,"Chỉ số +"+(int(hero.stars)*20)+"%",40,229,145,11,0xA5DAB9);
            this.StarText(card,hero.stars>=50?"Đã đạt sao tối đa":("Mảnh tướng: "+hero.owned+" / "+hero.cost),12,251,170,10,uint(hero.owned)>=uint(hero.cost)?0x96E7AD:0xFF8B79);
            var button:Sprite=new Sprite();button.addChild(this.StarNativeArt(true,158,30));this.StarText(button,"Nâng sao",47,5,100,12,0xFFFFFF);button.x=12;button.y=274;button.name=String(hero.id);button.buttonMode=true;button.mouseChildren=false;
            button.alpha=!StarPending&&hero.stars<50&&hero.owned>=hero.cost?1:0.45;button.addEventListener(MouseEvent.CLICK,this.StarUpgrade,false,0,true);card.addChild(button);
         }
         var left:Sprite=new Sprite();var right:Sprite=new Sprite();this.StarBox(left,0,0,30,25,0x58351A);this.StarBox(right,0,0,30,25,0x58351A);this.StarText(left,"<",9,2,24,16);this.StarText(right,">",9,2,24,16);
         left.x=205;right.x=345;left.y=right.y=324;left.buttonMode=right.buttonMode=true;left.mouseChildren=right.mouseChildren=false;left.name="previous";right.name="next";left.addEventListener(MouseEvent.CLICK,this.StarChangePage,false,0,true);right.addEventListener(MouseEvent.CLICK,this.StarChangePage,false,0,true);this.StarPanel.addChild(left);this.StarPanel.addChild(right);
         this.StarText(this.StarPanel,(this.StarPage+1)+" / "+pages,255,328,80,12);
      }
      protected function StarChangePage(e:MouseEvent) : void
      {
         if(StarData==null)return;var pages:int=Math.max(1,Math.ceil(StarData.heroes.length/3));this.StarPage=Math.max(0,Math.min(pages-1,this.StarPage+(e.currentTarget.name=="next"?1:-1)));this.RenderStars();
      }
      protected function StarUpgrade(e:MouseEvent) : void
      {
         if(StarPending||StarData==null)return;var id:uint=uint(e.currentTarget.name);var hero:Object=null;
         for each(var row:Object in StarData.heroes)if(uint(row.id)==id)hero=row;
         if(hero==null||hero.stars>=50||hero.owned<hero.cost)return;
         StarPending=true;var p:TPacket=SNetworkCore.PacketAcquire(0x0181f201);p.Data.writeUnsignedInt(id);p.Data.writeUnsignedInt(uint(hero.stars));SNetworkCore.Transceiver.PacketTransmit(p);this.RenderStars();
      }
   }
}

