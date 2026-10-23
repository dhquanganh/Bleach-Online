from pathlib import Path
BASE=Path(__file__).resolve().parent;REL=Path('Processors/Game/Lobby/VoidSoulWorld')
def load(n):return (BASE/'original/scripts'/REL/(n+'.as')).read_text(encoding='utf8')
def save(n,s):
 p=BASE/'patched'/REL/(n+'.as');p.parent.mkdir(parents=True,exist_ok=True);p.write_text(s,encoding='utf8')
def bounds(s,n):
 a=s.index('function '+n+'(');a=s.index('{',a);b=a+1;d=1
 while d:d+=(s[b]=='{')-(s[b]=='}');b+=1
 return a,b
def edit(s,n,f):
 a,b=bounds(s,n);return s[:a]+f(s[a:b])+s[b:]
def inject(s,n,c):return edit(s,n,lambda b:b.replace('{','{\n'+c,1))
s=load('TProcessorVoidSoulWorld')
s=edit(s,'PacketPerform_SC_InitRet',lambda b:b.replace('this.FUnstreamizer.InitRet(param1.Data);','''this.FUnstreamizer.InitRet(param1.Data);
         if(param1.Data.bytesAvailable > 0){try{this.FMainWin.ApplyBossConfig(JSON.parse(param1.Data.readUTF()));}catch(error:Error){EffectGenerateText("Void Region: invalid boss configuration");}}''',1))
a,b=bounds(s,'PacketPerform_SC_FightEnterRet')
s=s[:a]+'''{
         var code:uint = param1.Data.readUnsignedInt();
         this.FMainWin.EntryPending = false;
         if(code != 0){EffectGenerateTextByErrorCode(code);return;}
         var cursor:uint = param1.Data.position;
         var high:uint = param1.Data.readUnsignedInt();var low:uint = param1.Data.readUnsignedInt();param1.Data.position = cursor;
         var front:uint = this.FUnstreamizer.FightEnterRet(param1.Data);
         if(FIsResourcesLoadCompleted)this.FMainWin.AddLast(front);
         if(high != SLogicsCore.Character.Identifier1 || low != SLogicsCore.Character.Identifier0)return;
         this.FMainWin.Visible = false;
         if(this.FOnSetBattleStatus != null)this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_VoidSoulWorld,CONST_MUSIC.ID_SCENE_OrganizationalWar);
         if(this.FOnInitBattle != null)this.FOnInitBattle(this);
      }'''+s[b:]
save('TProcessorVoidSoulWorld',s)
s=load('TProcessorVoidSoulWorldMainWin')
s=s.replace('   import flash.display.Sprite;','   import flash.display.Sprite;\n   import flash.display.DisplayObjectContainer;')
s=s.replace('      protected var FBossTotalHP:Number;','      protected var FBossTotalHP:Number;\n      protected var FServerBoss:Object;\n      protected var FRenderedBossRevision:int = 0;\n      protected var FEntryPending:Boolean = false;')
extra='''      public function ApplyBossConfig(value:Object):void {this.FServerBoss = value;this.FEntryPending = false;}
      public function set EntryPending(value:Boolean):void {this.FEntryPending = value;}
      protected function SetServerBossName(node:DisplayObjectContainer):void {
         for(var i:int=0;i<node.numChildren;i++){var text:TextField=node.getChildAt(i) as TextField;if(text != null)text.text=String(this.FServerBoss.name);else if(node.getChildAt(i) is DisplayObjectContainer)this.SetServerBossName(node.getChildAt(i) as DisplayObjectContainer);}
      }
      protected function OnBattlePointerClick(event:MouseEvent):void {
         event.stopImmediatePropagation();
         for(var i:int=0;i<this.FFrontControllerList.length;i++)if(event.currentTarget == this.FMainUI["MC_Pointer_"+i]){this.FFrontControllerList[i].RequestFight();return;}
      }
'''
s=s.replace('      protected function UpdateBossModel()',extra+'      protected function UpdateBossModel()',1)
s=inject(s,'UpdateBossModel','''         if(this.FServerBoss != null){
            this.FBossTotalHP = Number(this.FServerBoss.hp);
            if(this.FRenderedBossRevision == int(this.FServerBoss.revision))return;
            var role:TRoleModel = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,uint(this.FServerBoss.roleId)) as TRoleModel;
            if(role == null)return;
            TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,role.Model,this.FQureyMoudleInfor);
            this.FSpriteMoudle.ChangeRoleMoudle(this.FQureyMoudleInfor.TextureID,this.FQureyMoudleInfor.Scalx);
            this.FBossHead.bitmapData = null;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(role.RoleHead,this.BossHeadLoadOK);
            this.FMonsterHead.UpdateBoss(uint(this.FServerBoss.enemyId));
            this.SetServerBossName(this.FMainUI.MC_BossHead);
            this.FRenderedBossRevision = int(this.FServerBoss.revision);return;
         }''')
s=edit(s,'UpdatePlayGuide',lambda b:b.replace('_loc1_ = this.FMainUI["MC_Pointer_" + _loc2_];','''_loc1_ = this.FMainUI["MC_Pointer_" + _loc2_];
            _loc1_.mouseEnabled = true;_loc1_.mouseChildren = false;_loc1_.buttonMode = true;
            _loc1_.addEventListener(MouseEvent.CLICK,this.OnBattlePointerClick,false,0,true);''',1))
s=inject(s,'Play','         if(this.FEntryPending)return;')
s=edit(s,'Play',lambda b:b.replace('this.FUnstreamizer.FightEnterReq(_loc3_);','this.FEntryPending = true;\n         this.FUnstreamizer.FightEnterReq(_loc3_);',1))
s=inject(s,'BossHeadLoadOK','''         if(param2 == null)return;
         if(this.FServerBoss != null){var role:TRoleModel = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,uint(this.FServerBoss.roleId)) as TRoleModel;if(role == null || role.RoleHead != param3)return;}''')
save('TProcessorVoidSoulWorldMainWin',s)
s=load('TFrontController')
s=s.replace('      public function set FrontVO(','''      public function RequestFight():void {this.OnEntranceClick(null);}
      public function set FrontVO(''',1)
save('TFrontController',s)
s=load('TProcessorMonsterHead').replace('      protected var FEnemyArmy:TEnemyArmy;','      protected var FEnemyArmy:TEnemyArmy;\n      protected var FSingleEnemy:uint = 0;')
s=inject(s,'EnemyArmyPicArrive','''         if(this.FSingleEnemy != 0){
            var enemy:TEnemy = this.FEnemyBins.GetDatebaseByIdentifier(this.FSingleEnemy) as TEnemy;
            var role:TRoleModel = enemy != null ? this.FRoleModel.GetDatebaseByIdentifier(enemy.HeroIcon) as TRoleModel : null;
            if(role != null && param2 != null && role.RoleHead == param3)this.FBtms[1].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            return;
         }''')
s=inject(s,'Update','         this.FSingleEnemy = 0;')
extra='''      public function UpdateBoss(enemyId:uint):void {
         this.FSingleEnemy = enemyId;this.FEnemyArmy = null;
         for(var i:int=0;i<this.SlotCount;i++){this.FBtms[i].bitmapData = null;this.FMainUI[this.ArmySlotNameVect[i]].Enemy = null;}
         var enemy:TEnemy = this.FEnemyBins.GetDatebaseByIdentifier(enemyId) as TEnemy;
         if(enemy == null)return;var role:TRoleModel = this.FRoleModel.GetDatebaseByIdentifier(enemy.HeroIcon) as TRoleModel;
         if(role == null)return;this.FMainUI.MC_Slot_6.Enemy = enemy;
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(role.RoleHead,this.EnemyArmyPicArrive);
      }
'''
s=s.replace('      public function Update(',extra+'      public function Update(',1)
save('TProcessorMonsterHead',s)
print('PASS four Void classes: clickable pointers, decoded admission, native battle and server-selected boss')
