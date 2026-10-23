from pathlib import Path
BASE=Path(__file__).resolve().parent
REL=Path('Processors/Game/Lobby/Jade')
def load(n):return (BASE/'original/scripts'/REL/(n+'.as')).read_text(encoding='utf8')
def save(n,s):
 p=BASE/'patched'/REL/(n+'.as');p.parent.mkdir(parents=True,exist_ok=True);p.write_text(s,encoding='utf8')
def bounds(s,n):
 a=s.index('function '+n+'(');a=s.index('{',a);b=a+1;d=1
 while d:d+=(s[b]=='{')-(s[b]=='}');b+=1
 return a,b
def edit(s,n,fn):
 a,b=bounds(s,n);return s[:a]+fn(s[a:b])+s[b:]
def inject(s,n,c):return edit(s,n,lambda b:b.replace('{','{\n'+c,1))
def body(s,n,c):return edit(s,n,lambda b:'{\n'+c+'\n      }')

for name in ['TJadeMosaic','TJadeCombin']:
 s=load(name)
 s=s.replace('      protected var FResultCode:int;','      protected var FResultCode:int;\n      protected var FReplyReady:Boolean = false;')
 # Accessor declaration includes "set" before its name, so locate by its body.
 marker='this.FResultCode = param1;';assert marker in s;s=s.replace(marker,marker+'\n         this.FReplyReady = true;',1)
 for state in (['STATE_MOSAIC','STATE_UNQUITE'] if name=='TJadeMosaic' else ['STATE_WAITBACK']):
  s=edit(s,'Update',lambda b,state=state:b.replace('case '+state+':','case '+state+':\n               if(!this.FReplyReady)break;\n               this.FReplyReady = false;',1))
 pending='this.FCurrentState != STATE_READY' if name=='TJadeMosaic' else 'this.FCurrentState == STATE_WAITBACK'
 extra='      public function get PendingRequest():Boolean {return '+pending+';}\n'
 s=s.replace('      public function Reset()',extra+'      public function Reset()',1)
 # Clear reply state for a new request; do not reuse an old result on tab refresh.
 for n in (['EquipmentJadeSlotClick','BackpackJadeSlotsOnClick'] if name=='TJadeMosaic' else ['OnBtnCombineClick']):
  s=inject(s,n,'         if(this.PendingRequest)return;\n         this.FReplyReady = false;')
 # Use the explicit gem collection and filter actual BaseStone definitions.
 s=s.replace('SLogicsCore.Character.GetBackpackByIndex(CONST_COMMON.INVENTORIESINDEX_Gems)','SLogicsCore.Character.Gems')
 if name=='TJadeMosaic':
  s=inject(s,'EquipmentClick','         if(param1 == null || param2 == null)return;')
  s=body(s,'HeroListPageOnChange','''         this.FPageIndexHeroList = Math.max(0,Math.min(param2,Math.max(0,Math.ceil((SLogicsCore.Character.Heros.Count+1)/CONST_JADE.MAX_HeroCount)-1)));
         this.FCurrentShowTagIndex = -1;
         this.FCurrentShowEquipment = null;
         this.UpdateHerosTag();
         this.FHeroNameTab.SwithTagManual(0);
         this.OnSwitchTab(0);
         this.ResetEquipmentJade();
         this.FCurrentShowEquipmentName.text = "";''')
  s=s.replace('      protected var FResultCode:int;', '      protected var FEmptyEquipmentText:TextField;\n      protected var FResultCode:int;',1)
  s=edit(s,'EquipmentUIDispath',lambda b:b[:-1]+'''         this.FEmptyEquipmentText = new TextField();
         this.FEmptyEquipmentText.defaultTextFormat = new TextFormat("Arial",12,0xFFE080);
         this.FEmptyEquipmentText.width = 145;this.FEmptyEquipmentText.height = 90;
         this.FEmptyEquipmentText.x = this.FMC_List.x+8;this.FEmptyEquipmentText.y = this.FMC_List.y+18;
         this.FEmptyEquipmentText.multiline = true;this.FEmptyEquipmentText.wordWrap = true;
         this.FEmptyEquipmentText.mouseEnabled = false;this.FEmptyEquipmentText.selectable = false;
         this.FEmptyEquipmentText.text = "No equipment.\nChoose another hero or the Backpack tab.";
         this.FEmptyEquipmentText.visible = false;param1.addChild(this.FEmptyEquipmentText);
      }'''.replace('No equipment.\nChoose','No equipment.\\nChoose'))
  # Clear stale rows and rebuild when a hero/backpack gains or loses equipment.
  s=inject(s,'UpdateEquipment','''         if(this.FList_SingleEquipment.length < Math.max(CONST_SMITHY.MinSingleEquipmentNum,this.FCurrentShowEquipmentBag.Count))this.ConstructScroolBar();
         for each(var row:TSingleEquip in this.FList_SingleEquipment)row.Release();
         if(this.FEmptyEquipmentText != null)this.FEmptyEquipmentText.visible = this.FCurrentShowEquipmentBag.Count == 0;''')
  s=edit(s,'UpdateEquipment',lambda b:b.replace('_loc5_.SetEquip(_loc3_,','if(_loc3_ != null)_loc5_.SetEquip(_loc3_,',1))
  s=edit(s,'UpdateEquipment',lambda b:b[:-1]+'''         if(this.FCurrentShowEquipment == null && this.FCurrentShowEquipmentBag.Count > 0){
            this.FCurrentShowEquipment = this.FCurrentShowEquipmentBag.GetInventoryByIndex(0) as TEquipment;
            this.FCurrentClickSingleEquip = this.FList_SingleEquipment[0];this.FCurrentClickSingleEquip.BClick = true;
            if(this.FCurrentShowEquipment != null){this.FCurrentShowEquipmentName.text = this.FCurrentShowEquipment.Name;this.UpdateEquipmentJadeSlot();}
         }
      }''')
  s=inject(s,'Reset','         this.FCurrentState = STATE_READY;this.FReplyReady = false;')
 else:
  s=inject(s,'Reset','         this.FRequestSent = false;if(this.FAutoPopTip != null)this.FAutoPopTip.PopTipVisible = false;')
  s=s.replace('      protected var FReplyReady:Boolean = false;','      protected var FReplyReady:Boolean = false;\n      protected var FRequestSent:Boolean = false;')
  s=s.replace('return this.FCurrentState == STATE_WAITBACK;','return this.FRequestSent;')
  s=edit(s,'OnBtnCombineClick',lambda b:b.replace('this.FOnCombine(this,0,','this.FRequestSent = true;\n               this.FOnCombine(this,0,',1))
  s=inject(s,'PopTipOk','         if(this.FRequestSent)return;\n         this.FReplyReady = false;')
  s=edit(s,'PopTipOk',lambda b:b.replace('this.FOnCombine(this,1,','this.FRequestSent = true;this.FCurrentState = STATE_WAITBACK;\n            this.FOnCombine(this,1,',1))
  s=edit(s,'Update',lambda b:b.replace('this.FReplyReady = false;','this.FReplyReady = false;\n               this.FRequestSent = false;',1))
  s=edit(s,'PopTipBack',lambda b:b.replace('this.FWaiting = false;','this.FWaiting = false;this.FRequestSent = false;',1))
  s=inject(s,'Reset','         this.FCurrentState = STATE_READY;this.FReplyReady = false;')
  s=inject(s,'UpdateCombineJadeShow','''         if(this.FCurrentShowJade != null && this.GetJadeNum(this.FCurrentShowJade) < 2){this.ResetCombineJade();this.ResetCombine();return;}''')
  s=edit(s,'UpdateCombineJadeShow',lambda b:b.replace('         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(', '         if(_loc3_ == null){this.ResetCombineJade();this.ResetCombine();return;}\n         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(',1).replace('         _loc3_.IDTexture = uint(_loc2_.Picture);','         if(_loc2_ == null){this.ResetCombineJade();this.ResetCombine();return;}\n         _loc3_.IDTexture = uint(_loc2_.Picture);'))
  # A failed synth clears stale output/counts and always releases the input guard.
  s=edit(s,'Update',lambda b:b.replace('         this.SetButton();','         if(this.FCurrentState == STATE_READY && this.FResultCode != 0 && !this.FWaiting){this.ResetCombineJade();this.ResetCombine();this.FSelectBox.visible = false;}\n         this.SetButton();',1))
  s=inject(s,'PopTipOk','         if(param2 < 1 || param2 > 12){this.PopTipBack();return;}')
 # Inventory pushes may arrive while this panel is already open. Refresh from
 # the live gem collection without consuming an outstanding command response.
 s=s.replace('      protected var FInitialization:Boolean;','      protected var FInitialization:Boolean;\n      protected var FLastGemRefresh:int = 0;\n      protected var FGemSignature:String = "";')
 s=s.replace('   import flash.events.*;','   import flash.events.*;\n   import flash.utils.getTimer;')
 refresh='''         if(this.FInitialization && this.Visible && !this.PendingRequest && getTimer()-this.FLastGemRefresh > 250){
            this.FLastGemRefresh = getTimer();var signature:String = TJadeCommon.GemSignature();
            if(signature != this.FGemSignature){this.FGemSignature = signature;this.UpdateBackpackJade();RESELECT}
         }
'''
 refresh=refresh.replace('RESELECT','' if name=='TJadeMosaic' else 'if(!this.FWaiting && this.FCurrentShowJade != null){this.FCurrentCombineNum = this.GetJadeNum(this.FCurrentShowJade);this.UpdateCombineJadeShow();}')
 s=edit(s,'LogicsPerform',lambda b:b[:-1]+refresh+'      }')
 save(name,s)

s=load('TJadeCommon').replace('   import Logics.Inventories.*;','   import Logics.Inventories.*;\n   import Logics.DatebaseVO.VO.TBaseStone;')
s=inject(s,'SlotsOnQuerySequenceContext','         if(param2 == null)return;')
s=inject(s,'GetSpecialJade','         if(param1 == null || param2 == null)return;')
s=edit(s,'GetSpecialJade',lambda b:b.replace('            if(!(param3', '''            if(_loc5_ == null || _loc5_.Quantity == 0 || SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseStone,_loc5_.IDTemplate) == null){_loc6_++;continue;}
            if(!(param3''',1))
s=s.replace('      public static function GetSpecialJade(','''      public static function GemSignature():String {
         var gems:TInventories = SLogicsCore.Character.Gems;var result:String = "";
         if(gems == null)return result;
         for(var i:int=0;i<gems.Count;i++){var gem:TInventory = gems.GetInventoryByIndex(i);if(gem != null)result += gem.IDTemplate+":"+gem.Quantity+";";}
         return result;
      }
      public static function GetSpecialJade(''',1)
s=s.replace('   import Logics.Inventories.*;','   import Logics.Inventories.*;\n   import Logics.SLogicsCore;')
save('TJadeCommon',s)

s=load('TProcessorWindowJade')
# Keep the existing live button above both reparented content panels. No opaque
# overlay or scene frame can intercept its mouse hit area.
s=s.replace('         this.FScene.btn_close.addEventListener(MouseEvent.CLICK,this.OnCloseWindow);','')
s=edit(s,'ResourcesPerform_UILocations',lambda b:b.replace('         this.Perform_Reset();','''         this.FBTN_Close.x += this.FScene.x;this.FBTN_Close.y += this.FScene.y;
         this.addChild(this.FBTN_Close);
         this.FBTN_Close.visible = true;this.FBTN_Close.mouseEnabled = true;
         this.Perform_Reset();''',1))
s=body(s,'OnCloseWindow','''         this.Visible = false;
         if(this.stage != null)this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.SoulStoneKeyDown);
         try{this.Reset();}finally{ProcessorWindowClose();}''')
s=body(s,'Reset','''         if(this.FMosaicScene != null && !this.FMosaicScene.PendingRequest)this.FMosaicScene.Reset();
         if(this.FCombineScene != null && !this.FCombineScene.PendingRequest)this.FCombineScene.Reset();''')
s=edit(s,'SwitchTab',lambda b:b.replace('         this.FCombineScene.Reset();','         if(!this.FCombineScene.PendingRequest)this.FCombineScene.Reset();',1))
extra='''      public function PrepareOpen():void {
         this.Visible = true;
         if(!this.FMosaicScene.PendingRequest && !this.FCombineScene.PendingRequest)this.Perform_Reset();
         else this.Update();
         if(this.FBTN_Close != null)this.setChildIndex(this.FBTN_Close,this.numChildren-1);
         if(this.stage != null)this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.SoulStoneKeyDown,false,0,true);
      }
      private function SoulStoneKeyDown(event:KeyboardEvent):void {if(this.Visible && event.keyCode == 27){event.stopImmediatePropagation();this.OnCloseWindow(null);}}
'''
s=s.replace('      public function ApplyMosaicResult(',extra+'      public function ApplyMosaicResult(',1)
save('TProcessorWindowJade',s)
s=load('TProcessorJade')
s=body(s,'ProcessorWindowJadeOnClose','''         this.FProcessorWindowJade.Visible = false;
         try{ProcessorClose();}finally{Visible = false;}''')
s=body(s,'Unmount','''         this.FProcessorWindowJade.Visible = false;
         try{this.FProcessorWindowJade.Reset();}finally{super.Unmount();}
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseJade);''')
s=edit(s,'Mount',lambda b:b.replace('         this.FProcessorWindowJade.visible = true;\n         this.FProcessorWindowJade.Update();','         this.FProcessorWindowJade.PrepareOpen();',1))
save('TProcessorJade',s)
print('PASS five Soul Stone window/collection/request-lifecycle classes prepared')
