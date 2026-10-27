package Components.Slots
{
   import Foundation.Common.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUISlot extends TUIComponent
   {
      
      protected static const RENDERINGSTATE_Normal:int = 0;
      
      protected static const RENDERINGSTATE_Hovering:int = 1;
      
      protected static const RENDERINGSTATE_Pressed:int = 2;
      
      protected static const RENDERINGSTATE_Disabled:int = 3;
      
      protected static const FRAME_Index:uint = 1;
      
      public static const RESOURCE_Link_MC_AdvancedEquip:String = CONST_BACKPACK.RESOURCE_Link_MC_AdvancedEquip;
      
      public static const RESOURCE_Link_MC_Bmp_Icon:String = CONST_BACKPACK.RESOURCE_Link_MC_Bmp_Icon;
      
      public static const RESOURCE_Link_MC_Bmp_IconHighLight:String = CONST_BACKPACK.RESOURCE_Link_MC_Bmp_IconHighLight;
      
      public static const RESOURCE_Link_TF_Subscript:String = CONST_BACKPACK.RESOURCE_Link_TF_Subscript;
      
      public static const RESOURCE_Link_TF_EquipLevel:String = CONST_BACKPACK.RESOURCE_Link_TF_EquipLevel;
      
      public static const RESOURCE_Link_MC_SelectedBox:String = CONST_BACKPACK.RESOURCE_Link_MC_SelectedBox;
      
      public static const SIZE_Slot_Width:uint = 42;
      
      public static const SIZE_Slot_Height:uint = 42;
      
      public static const SIZE_DefaultIcon_Width:uint = 40;
      
      public static const SIZE_DefaultIcon_Height:uint = 40;
      
      protected var FLayerIcon:Sprite;
      
      protected var FMC_AdvancedEquip:SimpleButton;
      
      protected var FMC_SelectedBox:Sprite;
      
      protected var FBmpIcon:Bitmap;
      
      protected var FBmpAdvancedEffect:Bitmap;
      
      protected var FLayerHighLight:Sprite;
      
      protected var FLayerSubscript:TextField;
      
      protected var FEquipLevel:TextField;
      
      protected var FSequenceDefaultIcon:TAnimationSequence;
      
      protected var FSequenceContext:TAnimationSequence;
      
      protected var FTextureAdvancedEffect:TTexture;
      
      protected var FQuerySequence:TQueryAnimationSequence;
      
      protected var FQuerySubscript:TQueryString;
      
      protected var FQueryLevel:TQueryString;
      
      protected var FQueryAdvancedEquip:TQueryBoolean;
      
      protected var FQueryEdgeColor:TQueryUInt;
      
      protected var FQueryDragAccept:TQueryBoolean;
      
      protected var FQuerySelectedBox:TQueryBoolean;
      
      protected var FRenderingHoveringState:int;
      
      protected var FMousePressed:Boolean;
      
      protected var FDragging:Boolean;
      
      protected var FDraggingReference:TCoordinate;
      
      protected var FDraggingAccept:Boolean;
      
      protected var FInitialization:Boolean;
      
      protected var FResource:Sprite;
      
      protected var FContext:Object;
      
      protected var FMountPointsBounds:TBounds;
      
      protected var FMountPointsPivot:TCoordinate;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FOnQuerySubscript:Function;
      
      protected var FOnQueryEuqipLevel:Function;
      
      protected var FOnQueryAdvancedEquip:Function;
      
      protected var FOnQueryEdgeColor:Function;
      
      protected var FOnClick:Function;
      
      protected var FOnAdvancedEquipClick:Function;
      
      protected var FOnDown:Function;
      
      protected var FOnUp:Function;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnDragBegin:Function;
      
      protected var FOnDragEnd:Function;
      
      protected var FOnDragReject:Function;
      
      protected var FOnDragQuery:Function;
      
      protected var FOnDragDrop:Function;
      
      protected var FOnQuerySelectedContext:Function;
      
      protected var FDraggingEnabled:Boolean;
      
      protected var FDraggingActiveQuery:Boolean;
      
      protected var FIsSelected:Boolean;
      
      public function TUISlot(param1:TUIComponent)
      {
         super(param1);
         this.FMountPointsBounds = new TBounds();
         this.FMountPointsPivot = new TCoordinate();
         this.FQuerySequence = new TQueryAnimationSequence();
         this.FQuerySubscript = new TQueryString();
         this.FQueryLevel = new TQueryString();
         this.FQueryAdvancedEquip = new TQueryBoolean();
         this.FQueryEdgeColor = new TQueryUInt();
         this.FQueryDragAccept = new TQueryBoolean();
         this.FQuerySelectedBox = new TQueryBoolean();
         this.FDraggingReference = new TCoordinate();
         mouseEnabled = true;
         this.FDraggingEnabled = false;
         this.FIsSelected = false;
         this.FInitialization = false;
      }
      
      protected function Initialization() : void
      {
         this.FLayerIcon = this.FResource[RESOURCE_Link_MC_Bmp_Icon];
         this.FLayerIcon.mouseEnabled = false;
         this.FBmpIcon = new Bitmap();
         this.FLayerIcon.addChild(this.FBmpIcon);
         this.FBmpAdvancedEffect = new Bitmap();
         this.FLayerIcon.addChild(this.FBmpAdvancedEffect);
         this.FLayerHighLight = this.FResource[RESOURCE_Link_MC_Bmp_IconHighLight];
         if(this.FLayerHighLight != null)
         {
            this.FLayerHighLight.mouseEnabled = false;
            this.FLayerHighLight.visible = false;
         }
         this.FLayerSubscript = this.FResource[RESOURCE_Link_TF_Subscript];
         if(this.FLayerSubscript != null)
         {
            this.FLayerSubscript.mouseEnabled = false;
            this.FLayerSubscript.text = "";
         }
         this.FEquipLevel = this.FResource[RESOURCE_Link_TF_EquipLevel];
         if(this.FEquipLevel != null)
         {
            this.FEquipLevel.mouseEnabled = false;
            this.FEquipLevel.text = "";
         }
         this.FMC_AdvancedEquip = this.FResource[RESOURCE_Link_MC_AdvancedEquip] as SimpleButton;
         if(this.FMC_AdvancedEquip != null)
         {
            this.FMC_AdvancedEquip.visible = false;
         }
         this.FMC_SelectedBox = this.FResource[RESOURCE_Link_MC_SelectedBox] as Sprite;
         if(this.FMC_SelectedBox != null)
         {
            this.FMC_SelectedBox.mouseEnabled = false;
            this.FMC_SelectedBox.visible = false;
         }
         this.FResource.addEventListener(MouseEvent.MOUSE_OVER,this.SlotOnOver,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_OUT,this.SlotOnOut,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_MOVE,this.SlotOnMove,false,0,true);
         this.FResource.addEventListener(MouseEvent.CLICK,this.SlotOnClick,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_DOWN,this.SlotOnDown,false,0,true);
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.SlotOnUp,false,0,true);
         this.FInitialization = true;
      }
      
      protected function UpdateRenderingState() : void
      {
         this.UpdateRenderingOverState();
      }
      
      protected function UpdateRenderingOverState() : void
      {
         if(this.FLayerHighLight == null)
         {
            return;
         }
         if(FBacktrackedEnabled)
         {
            if(!this.FDragging)
            {
               if(FUICore.DragSource != null)
               {
                  if(this.FDraggingActiveQuery)
                  {
                     this.DraggingQuery(true);
                  }
               }
            }
         }
         if(this.FRenderingHoveringState == RENDERINGSTATE_Hovering)
         {
            this.FLayerHighLight.visible = true;
         }
         else
         {
            this.FLayerHighLight.visible = false;
         }
         if(this.FMC_SelectedBox != null && this.FIsSelected != this.FMC_SelectedBox.visible)
         {
            this.FMC_SelectedBox.visible = this.FIsSelected;
         }
      }
      
      protected function RenderingPerform() : void
      {
         if(this.Context != null)
         {
            this.RenderingPerform_Context();
            this.RenderingPerform_Subscript();
            this.RenderingPerform_EquipLevel();
            this.RenderingPerform_AdvancedEffect();
         }
      }
      
      protected function RenderingPerform_Context() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TAnimationFrame = null;
         var _loc3_:BitmapData = null;
         var _loc4_:BitmapData = null;
         if(this.FContext == null)
         {
            return;
         }
         if(this.FSequenceContext == null || this.FSequenceContext.Count == 0)
         {
            if(this.FOnQuerySequenceContext != null)
            {
               this.FQuerySequence.Value = null;
               this.FOnQuerySequenceContext(this,this.FContext,this.FQuerySequence);
               this.FSequenceContext = this.FQuerySequence.Value;
               this.FQuerySequence.Value = null;
            }
         }
         _loc1_ = int(STimingCore.TickCount);
         if(this.FSequenceContext != null)
         {
            _loc2_ = this.FSequenceContext.GetAnimationFrameByTick(_loc1_);
         }
         if(_loc2_ == null)
         {
            _loc2_ = this.FSequenceDefaultIcon.GetAnimationFrameByTick(_loc1_);
         }
         _loc3_ = this.FBmpIcon.bitmapData;
         _loc4_ = _loc2_.Surface;
         if(_loc3_ != _loc4_)
         {
            this.FBmpIcon.bitmapData = _loc4_;
            this.FBmpIcon.x = (SIZE_Slot_Width - _loc4_.width) / 2;
            this.FBmpIcon.y = (SIZE_Slot_Height - _loc4_.height) / 2;
         }
      }
      
      protected function RenderingPerform_Subscript() : void
      {
         var _loc1_:String = null;
         if(this.FContext == null)
         {
            return;
         }
         if(this.FOnQuerySubscript != null)
         {
            this.FQuerySubscript.Value = "";
            this.FOnQuerySubscript(this,this.FContext,this.FQuerySubscript);
            _loc1_ = this.FQuerySubscript.Value;
            if(TUtilityString.Empty(_loc1_))
            {
               return;
            }
            if(this.FLayerSubscript != null)
            {
               this.FLayerSubscript.text = _loc1_;
            }
            return;
         }
      }
      
      protected function RenderingPerform_EquipLevel() : void
      {
         var _loc1_:String = null;
         if(this.FContext == null)
         {
            return;
         }
         if(this.FOnQueryEuqipLevel != null)
         {
            this.FQueryLevel.Value = "";
            this.FOnQueryEuqipLevel(this,this.FContext,this.FQueryLevel);
            _loc1_ = this.FQueryLevel.Value;
            if(TUtilityString.Empty(_loc1_))
            {
               return;
            }
            if(this.FEquipLevel != null)
            {
               this.FEquipLevel.text = _loc1_;
            }
            return;
         }
      }
      
      protected function RenderingPerform_AdvancedEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:TAnimationFrame = null;
         var _loc4_:BitmapData = null;
         var _loc5_:BitmapData = null;
         var _loc6_:int = 0;
         var _loc7_:TAnimationSequence = null;
         if(this.FContext == null)
         {
            return;
         }
         if(this.FOnQueryEdgeColor != null)
         {
            this.FQueryEdgeColor.Value = 0;
            this.FOnQueryEdgeColor(this,this.FContext,this.FQueryEdgeColor);
            _loc2_ = false;
            if(this.FQueryEdgeColor.Value > 0)
            {
               _loc2_ = true;
            }
            if(_loc2_)
            {
               if(this.FBmpAdvancedEffect.visible != _loc2_)
               {
                  this.FBmpAdvancedEffect.visible = _loc2_;
               }
               _loc6_ = int(this.FQueryEdgeColor.Value);
               if(this.FTextureAdvancedEffect == null)
               {
                  return;
               }
               _loc7_ = this.FTextureAdvancedEffect.GetAnimationSequenceByIndex(_loc6_ - 1);
               if(_loc7_ == null)
               {
                  return;
               }
               _loc7_.Evaluate(this.FMountPointsPivot,this.FMountPointsBounds);
               _loc1_ = int(STimingCore.TickCount);
               if(_loc7_ != null)
               {
                  _loc3_ = _loc7_.GetAnimationFrameByTick(_loc1_);
               }
               if(_loc3_ == null)
               {
                  return;
               }
               _loc4_ = this.FBmpAdvancedEffect.bitmapData;
               _loc5_ = _loc3_.Surface;
               if(_loc4_ != _loc5_)
               {
                  this.FBmpAdvancedEffect.bitmapData = _loc5_;
                  this.FBmpAdvancedEffect.x = this.FMountPointsBounds.X + this.FLayerIcon.x;
                  this.FBmpAdvancedEffect.y = this.FMountPointsBounds.Y + this.FLayerIcon.y;
               }
               return;
            }
            if(this.FBmpAdvancedEffect.visible != _loc2_)
            {
               this.FBmpAdvancedEffect.visible = _loc2_;
            }
            return;
         }
      }
      
      protected function RenderingPerform_Overlay() : void
      {
         var _loc1_:Boolean = false;
         if(!this.FDragging)
         {
            if(FUICore.DragSource != null)
            {
               return;
            }
            _loc1_ = FUICore.MouseHovering(this);
            if(_loc1_)
            {
               if(this.FOnOver != null)
               {
                  this.FOnOver(this,this.Context);
               }
            }
         }
      }
      
      protected function DraggingIntialize() : void
      {
         FUICore.DragSource = this;
         FUICore.DragObject = this.FContext;
         FUICore.DragAccept = false;
         this.FDragging = true;
         if(this.FOnDragBegin != null)
         {
            this.FOnDragBegin(this);
         }
      }
      
      protected function DraggingDrop() : void
      {
         if(this.FOnDragDrop != null)
         {
            this.FOnDragDrop(FUICore.MouseHoveringComponent,FUICore.DragSource,FUICore.DragObject);
         }
      }
      
      protected function DraggingReject(param1:TUIComponent) : void
      {
         if(this.FOnDragReject != null)
         {
            this.FOnDragReject(this,param1,this.FContext);
         }
      }
      
      protected function DraggingQuery(param1:Boolean) : void
      {
         if(FBacktrackedEnabled)
         {
            this.FQueryDragAccept.Value = false;
            if(this.FOnDragQuery != null)
            {
               this.FOnDragQuery(this,FUICore.DragSource,FUICore.DragObject,this.FQueryDragAccept);
            }
            this.FDraggingAccept = this.FQueryDragAccept.Value;
         }
         else
         {
            this.FDraggingAccept = false;
         }
         if(param1)
         {
            FUICore.DragAccept = this.FDraggingAccept;
         }
      }
      
      protected function DraggingReset() : void
      {
         if(this.FDragging)
         {
            FUICore.DragSource = null;
            FUICore.DragObject = null;
            FUICore.DragAccept = false;
            FUICore.MouseHoverRelease();
            if(this.FOnDragEnd != null)
            {
               this.FOnDragEnd(this);
            }
         }
         this.FDragging = false;
      }
      
      protected function SlotOnOver(param1:MouseEvent) : void
      {
         var _loc2_:SimpleButton = null;
         FUICore.MouseHoverSet(this);
         if(this.Context == null)
         {
            return;
         }
         if(param1.target is SimpleButton)
         {
            _loc2_ = param1.target as SimpleButton;
            if(this.FMC_AdvancedEquip == _loc2_)
            {
               this.FRenderingHoveringState = RENDERINGSTATE_Normal;
               return;
            }
         }
         this.FRenderingHoveringState = RENDERINGSTATE_Hovering;
      }
      
      protected function SlotOnOut(param1:MouseEvent) : void
      {
         FUICore.MouseHoverRelease();
         this.FRenderingHoveringState = RENDERINGSTATE_Normal;
         if(this.Context == null)
         {
            return;
         }
         if(this.FOnOut != null)
         {
            this.FOnOut(this,this.Context);
         }
      }
      
      protected function SlotOnMove(param1:MouseEvent) : void
      {
         if(!this.FDragging)
         {
            if(this.FMousePressed && this.FDraggingEnabled && this.FContext != null)
            {
               this.DraggingIntialize();
            }
            if(this.Context == null)
            {
               return;
            }
            this.RenderingPerform_Overlay();
         }
      }
      
      protected function SlotOnClick(param1:MouseEvent) : void
      {
         var _loc2_:SimpleButton = null;
         if(this.Context == null)
         {
            return;
         }
         if(param1.target is SimpleButton)
         {
            _loc2_ = param1.target as SimpleButton;
            if(this.FMC_AdvancedEquip == _loc2_)
            {
               if(this.FOnAdvancedEquipClick != null)
               {
                  this.FOnAdvancedEquipClick(this,this.Context);
               }
               return;
            }
         }
         if(this.FOnClick != null)
         {
            this.FOnClick(this,this.Context);
         }
         if(this.FMC_SelectedBox != null)
         {
            if(this.FOnQuerySelectedContext != null)
            {
               this.FQuerySelectedBox.Value = false;
               this.FOnQuerySelectedContext(this,this.Context,this.FQuerySelectedBox);
               this.FIsSelected = this.FQuerySelectedBox.Value;
            }
         }
      }
      
      protected function SlotOnDown(param1:MouseEvent) : void
      {
         if(this.Context == null)
         {
            return;
         }
         if(!this.FMousePressed)
         {
            this.FMousePressed = !this.FMousePressed;
            this.FDraggingReference.Assign(FUICore.MouseCoordinate);
         }
      }
      
      protected function SlotOnUp(param1:MouseEvent) : void
      {
         var _loc2_:TUIComponent = null;
         var _loc3_:Boolean = false;
         if(this.Context == null)
         {
            return;
         }
         if(this.FDragging)
         {
            _loc2_ = FUICore.MouseHoveringComponent;
            if(_loc2_ != this)
            {
               if(_loc2_ != null)
               {
                  this.DraggingQuery(false);
                  _loc3_ = FUICore.DragAccept;
               }
               else
               {
                  _loc3_ = false;
               }
               if(_loc3_)
               {
                  this.DraggingDrop();
               }
               else
               {
                  this.DraggingReject(_loc2_);
               }
            }
            this.DraggingReset();
         }
         this.FMousePressed = false;
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function get SequenceDefaultIcon() : TAnimationSequence
      {
         return this.FSequenceDefaultIcon;
      }
      
      public function set SequenceDefaultIcon(param1:TAnimationSequence) : void
      {
         this.FSequenceDefaultIcon = param1;
      }
      
      public function get TextureAdvancedEffect() : TTexture
      {
         return this.FTextureAdvancedEffect;
      }
      
      public function set TextureAdvancedEffect(param1:TTexture) : void
      {
         this.FTextureAdvancedEffect = param1;
      }
      
      public function get SequenceContext() : TAnimationSequence
      {
         return this.FSequenceContext;
      }
      
      public function get Context() : Object
      {
         return this.FContext;
      }
      
      public function set Context(param1:Object) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this.FContext;
         if(param1 != this.FContext)
         {
            this.FSequenceContext = null;
            if(this.FMC_AdvancedEquip != null)
            {
               this.FMC_AdvancedEquip.visible = false;
            }
            if(this.FMC_SelectedBox != null)
            {
               this.FMC_SelectedBox.visible = false;
            }
            if(this.FLayerSubscript != null)
            {
               this.FLayerSubscript.text = "";
            }
            if(this.FEquipLevel != null)
            {
               this.FEquipLevel.text = "";
            }
            this.FBmpIcon.bitmapData = null;
            if(this.FBmpAdvancedEffect.bitmapData != null)
            {
               this.FBmpAdvancedEffect.bitmapData = null;
               this.FBmpAdvancedEffect.visible = false;
            }
            this.FContext = param1;
         }
         if(param1 == null && _loc2_ != null)
         {
            if(this.FRenderingHoveringState == RENDERINGSTATE_Hovering)
            {
               this.FRenderingHoveringState = RENDERINGSTATE_Normal;
               if(this.FOnOut != null)
               {
                  this.FOnOut(this,_loc2_);
               }
            }
         }
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get OnQuerySubscript() : Function
      {
         return this.FOnQuerySubscript;
      }
      
      public function set OnQuerySubscript(param1:Function) : void
      {
         this.FOnQuerySubscript = param1;
      }
      
      public function get OnQueryAdvancedEquip() : Function
      {
         return this.FOnQueryAdvancedEquip;
      }
      
      public function set OnQueryAdvancedEquip(param1:Function) : void
      {
         this.FOnQueryAdvancedEquip = param1;
      }
      
      public function get OnQueryEdgeColor() : Function
      {
         return this.FOnQueryEdgeColor;
      }
      
      public function set OnQueryEdgeColor(param1:Function) : void
      {
         this.FOnQueryEdgeColor = param1;
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get OnAdvancedEquipClick() : Function
      {
         return this.FOnAdvancedEquipClick;
      }
      
      public function set OnAdvancedEquipClick(param1:Function) : void
      {
         this.FOnAdvancedEquipClick = param1;
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function get DraggingEnabled() : Boolean
      {
         return this.FDraggingEnabled;
      }
      
      public function set DraggingEnabled(param1:Boolean) : void
      {
         this.FDraggingEnabled = param1;
      }
      
      public function get DraggingActiveQuery() : Boolean
      {
         return this.FDraggingActiveQuery;
      }
      
      public function set DraggingActiveQuery(param1:Boolean) : void
      {
         this.FDraggingActiveQuery = param1;
      }
      
      public function get OnDragBegin() : Function
      {
         return this.FOnDragBegin;
      }
      
      public function set OnDragBegin(param1:Function) : void
      {
         this.FOnDragBegin = param1;
      }
      
      public function get OnDragEnd() : Function
      {
         return this.FOnDragEnd;
      }
      
      public function set OnDragEnd(param1:Function) : void
      {
         this.FOnDragEnd = param1;
      }
      
      public function get OnDragReject() : Function
      {
         return this.FOnDragReject;
      }
      
      public function set OnDragReject(param1:Function) : void
      {
         this.FOnDragReject = param1;
      }
      
      public function get OnDragQuery() : Function
      {
         return this.FOnDragQuery;
      }
      
      public function set OnDragQuery(param1:Function) : void
      {
         this.FOnDragQuery = param1;
      }
      
      public function get OnDragDrop() : Function
      {
         return this.FOnDragDrop;
      }
      
      public function set OnDragDrop(param1:Function) : void
      {
         this.FOnDragDrop = param1;
      }
      
      public function get SelectBox() : Boolean
      {
         return this.FMC_SelectedBox.visible;
      }
      
      public function set SelectBox(param1:Boolean) : void
      {
         if(param1 != this.FMC_SelectedBox.visible)
         {
            this.FMC_SelectedBox.visible = param1;
         }
      }
      
      public function get OnQuerySelectedContext() : Function
      {
         return this.FOnQuerySelectedContext;
      }
      
      public function set OnQuerySelectedContext(param1:Function) : void
      {
         this.FOnQuerySelectedContext = param1;
      }
      
      public function get OnQueryEuqipLevel() : Function
      {
         return this.FOnQueryEuqipLevel;
      }
      
      public function set OnQueryEuqipLevel(param1:Function) : void
      {
         this.FOnQueryEuqipLevel = param1;
      }
      
      public function get IsSelected() : Boolean
      {
         return this.FIsSelected;
      }
      
      public function set IsSelected(param1:Boolean) : void
      {
         this.FIsSelected = param1;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(!this.FInitialization)
         {
            return;
         }
         this.FResource.visible = param1;
      }
      
      public function Init() : void
      {
         if(this.FInitialization)
         {
            return;
         }
         this.Initialization();
      }
      
      override public function Dispose() : void
      {
         this.FLayerIcon = null;
         this.FMC_AdvancedEquip = null;
         this.FMC_SelectedBox = null;
         if(this.FBmpIcon != null)
         {
            if(this.FBmpIcon.bitmapData != null)
            {
               this.FBmpIcon.bitmapData = null;
            }
            this.FBmpIcon = null;
         }
         if(this.FBmpAdvancedEffect != null)
         {
            if(this.FBmpAdvancedEffect.bitmapData != null)
            {
               this.FBmpAdvancedEffect.bitmapData = null;
            }
            this.FBmpAdvancedEffect = null;
         }
         this.FLayerHighLight = null;
         this.FLayerSubscript = null;
         this.FEquipLevel = null;
         this.FSequenceDefaultIcon = null;
         this.FSequenceContext = null;
         this.FTextureAdvancedEffect = null;
         this.FQuerySequence = null;
         this.FResource = null;
         this.FContext = null;
         this.FMountPointsBounds = null;
         this.FMountPointsPivot = null;
         this.FOnQuerySequenceContext = null;
         this.FOnQuerySubscript = null;
         this.FOnQueryEuqipLevel = null;
         this.FOnQueryAdvancedEquip = null;
         this.FOnQueryEdgeColor = null;
         this.FOnClick = null;
         this.FOnAdvancedEquipClick = null;
         this.FOnDown = null;
         this.FOnUp = null;
         this.FOnOver = null;
         this.FOnOut = null;
         this.FOnDragBegin = null;
         this.FOnDragEnd = null;
         this.FOnDragReject = null;
         this.FOnDragQuery = null;
         this.FOnDragDrop = null;
         this.FOnQuerySelectedContext = null;
         if(this.Parent != null)
         {
            this.Parent.removeChild(this);
         }
      }
      
      public function Update() : void
      {
         this.UpdateRenderingState();
         this.RenderingPerform();
      }
      
      public function SetDefaultFilters(param1:Boolean) : void
      {
         if(param1)
         {
            this.FLayerIcon.filters = [TUtilityFilter.gBlackFilters];
         }
         else
         {
            this.FLayerIcon.filters = [];
         }
      }
      
      public function SetHighLightFilters(param1:Boolean) : void
      {
         if(param1)
         {
            this.FResource.filters = [TUtilityFilter.highLightFilters];
         }
         else
         {
            this.FResource.filters = [];
         }
      }
   }
}

