"""Patch only freshly exported Soul Stone classes from the current client."""
from pathlib import Path
BASE=Path(__file__).resolve().parent
REL=Path('Processors/Game/Lobby/Jade')
def load(name):return (BASE/'original/scripts'/REL/(name+'.as')).read_text(encoding='utf8')
def save(name,s):
 p=BASE/'patched'/REL/(name+'.as');p.parent.mkdir(parents=True,exist_ok=True);p.write_text(s,encoding='utf8')
def section(s,name):
 a=s.index('function '+name+'(');a=s.index('{',a);b=a+1;depth=1
 while depth:
  depth+=(s[b]=='{')-(s[b]=='}');b+=1
 return a,b
def edit(s,name,fn):
 a,b=section(s,name);return s[:a]+fn(s[a:b])+s[b:]
def inject(s,name,code):return edit(s,name,lambda body:body.replace('{','{\n'+code,1))

s=load('TJadeMosaic')
for name in ['EquipmentJadeSlotClick','BackpackJadeSlotsOnClick']:
 s=inject(s,name,'         if(this.FCurrentState != STATE_READY || this.FCurrentShowEquipment == null || param2 == null)return;')
s=inject(s,'VerificationMosaic','         if(param1 == null)return false;')
s=edit(s,'SetSlotByEquipment',lambda b:b.replace('param1.HoleQuantity + param1.HoleAdditionalQuantity','Math.min(CONST_JADE.MAX_MosaicJadeCount,param1.HoleQuantity + param1.HoleAdditionalQuantity)'))
s=edit(s,'UpdateEquipmentJadeSlot',lambda b:b.replace('_loc2_ < _loc3_.Count','_loc2_ < Math.min(_loc3_.Count,this.FEquipmentJadeSlots.length)'))
for name in ['OnLevelSelect','OnTypeSelect']:
 s=inject(s,name,'         this.FPageIndex = 0;')
s=edit(s,'UpdateBackpackJade',lambda b:b.replace('         this.SetupJadePage(', '         this.FPageIndex = Math.max(0,Math.min(this.FPageIndex,Math.max(0,Math.ceil(this.FSelectJadeUsetoShow.Count / CONST_JADE.MAX_JadeSlotCount)-1)));\n         this.SetupJadePage(',1))
for name,state in [('BackpackJadeSlotsOnClick','STATE_MOSAIC'),('EquipmentJadeSlotClick','STATE_UNQUITE')]:
 s=edit(s,name,lambda b,state=state:b.replace('            this.FOn', '            this.FCurrentState = '+state+';\n            this.FOn',1))
save('TJadeMosaic',s)

s=load('TJadeCombin')
s=inject(s,'BackpackJadeSlotsOnClick','         if(param1 == null || param2 == null)return;')
s=inject(s,'CombineJadeSlotsOnClick','         if(this.FWaiting)return;')
s=inject(s,'UpdateCombineJadeShow', '''         if(this.FCurrentShowJade == null){this.ResetCombineJade();this.ResetCombine();return;}
         var sourceStone:TBaseStone = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseStone,this.FCurrentShowJade.IDTemplate) as TBaseStone;
         if(sourceStone == null || sourceStone.NextId == 0){this.ResetCombineJade();this.ResetCombine();return;}''')
s=edit(s,'UpdateCombineJadeShow',lambda b:b.replace('this.FCombineMaxNum = this.FCurrentCombineNum / 2;','this.FCombineMaxNum = Math.min(32767,Math.floor(this.FCurrentCombineNum / 2));'))
s=edit(s,'UpdateBackpackJade',lambda b:b.replace('         this.SetupJadePage(', '         this.FPageIndex = Math.max(0,Math.min(this.FPageIndex,Math.max(0,Math.ceil(this.FSelectJadeUsetoShow.Count / CONST_JADE.MAX_JadeCombineSlotCount)-1)));\n         this.SetupJadePage(',1))
s=edit(s,'SetButton',lambda b:b.replace('         this.FBTN_CombineAll.visible = false;','         this.FTF_VipTip.visible = true;\n         this.FBTN_CombineAll.visible = false;',1))
s=edit(s,'OnJadeCombineInputChange',lambda b:b.replace('if(_loc2_ < 1)','if(this.FCombineMaxNum < 1){this.FTF_CombineJadeNum.text = "0";return;}\n         if(_loc2_ < 1)'))
s=inject(s,'OnBtnCombineClick', '''         if(this.FOnCombine == null)return;
         if(param1.currentTarget == this.FBTN_Combine){
            if(this.FCurrentShowJade == null)return;
            this.FCurrentCombineNum = this.GetJadeNum(this.FCurrentShowJade);
            this.FCombineMaxNum = Math.min(32767,Math.floor(this.FCurrentCombineNum/2));
            this.OnJadeCombineInputChange(null);
            if(this.FCombineMaxNum < 1){this.ResetCombineJade();this.ResetCombine();return;}
         }''')
s=edit(s,'PopTipBack',lambda b:b.replace('this.FWaiting = false;','this.FWaiting = false;\n         this.FCurrentState = STATE_READY;'))
s=edit(s,'Update',lambda b:b.replace('this.FCurrentState = STATE_READY;','this.FCurrentState = STATE_READY;\n               this.FWaiting = false;',1))
s=edit(s,'Update',lambda b:b.replace('this.FCombineEffect.gotoAndPlay(1);','this.FWaiting = true;\n                  this.FCombineEffect.gotoAndPlay(1);',1))
# Only finish an animation while it is actually visible; the idle terminal frame
# must not clear a new request's waiting guard.
s=edit(s,'LogicsPerform',lambda b:b.replace('if(this.FCombineEffect.currentFrame == this.FCombineEffect.totalFrames)','if(this.FCombineEffect.visible && this.FCombineEffect.currentFrame == this.FCombineEffect.totalFrames)'))
save('TJadeCombin',s)

s=load('TProcessorWindowJade')
extra='''      public function ApplyMosaicResult(code:uint):void {
         this.FMosaicScene.ResultCode = code;this.FMosaicScene.Update();
      }
      public function ApplyCombineResult(code:uint):void {
         this.FCombineScene.ResultCode = code;this.FCombineScene.Update();
      }
'''
s=s.replace('      public function set ResultCode(',extra+'      public function set ResultCode(',1)
save('TProcessorWindowJade',s)
s=load('TProcessorJade')
for name,result in [('PacketPerform_SC_JadeCombine','ApplyCombineResult'),('PacketPerform_SC_EquitJadeMount','ApplyMosaicResult'),('PacketPerform_SC_EquitJadeUnmount','ApplyMosaicResult')]:
 def change(body):
  body=body.replace('         this.FProcessorWindowJade.ResultCode = _loc2_;\n','')
  body=body.replace('            EffectGenerateTextByErrorCode(_loc2_);','            this.FProcessorWindowJade.'+result+'(_loc2_);\n            EffectGenerateTextByErrorCode(_loc2_);',1)
  return body.replace('this.FProcessorWindowJade.Update();','this.FProcessorWindowJade.'+result+'(_loc2_);')
 s=edit(s,name,change)
save('TProcessorJade',s)
print('PASS prepared four isolated Soul Stone UI classes')
