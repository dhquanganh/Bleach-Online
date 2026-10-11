from pathlib import Path
BASE=Path(__file__).resolve().parent
names=['Processors/Game/Lobby/DailyActivity/TProcessorDailyActivity.as','Processors/Game/Lobby/TProcessorLobby.as']
daily=(BASE/'original/scripts'/names[0]).read_text(encoding='utf-8')
daily=daily.replace('   import flash.display.*;', '   import Processors.Game.Battle.TBattleHandle;\n   import flash.display.*;')
daily=daily.replace('   import flash.events.*;', '   import flash.events.*;\n   import flash.net.URLRequest;\n   import flash.external.ExternalInterface;')
daily=daily.replace('   import flash.text.*;', '   import flash.text.*;\n   import flash.filters.GlowFilter;\n   import flash.geom.Rectangle;')
daily=daily.replace('   import Foundation.Resources.Textures.TTexture;', '   import Foundation.Resources.Textures.TTexture;\n   import Foundation.Resources.Textures.TAnimationSequence;\n   import Foundation.Resources.Textures.TAnimationFrame;')
daily=daily.replace('      protected var FScene:MovieClip;',(BASE/'methods.as.txt').read_text(encoding='utf-8')+'\n      protected var FScene:MovieClip;')
daily=daily.replace('         this.FUITab.OnSwitch = this.ProcessorTabOnSwitch;','         this.InitField();\n         this.FUITab.OnSwitch = this.ProcessorTabOnSwitch;')
daily=daily.replace('         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyActivity_AutomaticStatusRet', '''         FPacketRoutines.Register(0x0118ed00,this.FieldReply);
         FPacketRoutines.Register(0x0118ed01,this.FieldReply);
         FPacketRoutines.Register(0x0118ed02,this.FieldFightReply);
         FPacketRoutines.Register(0x0118ed03,this.FieldReply);
         FPacketRoutines.Register(0x0118ed04,this.FieldReply);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyActivity_AutomaticStatusRet''')
needle='         if(this.FSelectTabIndex > this.FDailyActivityBins.Count)'
daily=daily.replace(needle,'''         if(this.FFieldPanel!=null) {
            this.FFieldPanel.visible=this.FSelectTabIndex==7;
            this.FScene.btn_join.visible=this.FSelectTabIndex!=7;
            this.FScene.MC_VoidSoulWorldDesc.visible=false;
         }
         if(this.FSelectTabIndex==7) { this.DrawField(); return; }
'''+needle)
daily=daily.replace('      protected function TabSelectAutoFight() : void\n      {','''      protected function TabSelectAutoFight() : void
      {
         if(this.FSelectTabIndex==7) {
            if(this.FMC_JoinConfig!=null) this.FMC_JoinConfig.visible=false;
            if(this.FTF_AutoJoining!=null) this.FTF_AutoJoining.visible=false;
            return;
         }''')
daily=daily.replace('         this.FSelectTabIndex = this.FTabIndex;','''         this.FSelectTabIndex = this.FTabIndex;
         if(this.FSelectTabIndex==7) { this.UpdataUI(); this.FieldSend(0x0181ed00); return; }''')
translations={
    'Chien truong':'Chiến trường','CHIEN TRUONG HAI TAC':'CHIẾN TRƯỜNG HẢI TẶC',
    'Mo ca ngay | Moi cap do | Thang +30 / Thua +10':'Mở cả ngày | Mọi cấp độ | Thắng +30 / Thua +10',
    'Diem: ':'Điểm: ','   Thang: ':'   Thắng: ','Dang tai chien truong...':'Đang tải chiến trường...',
    'Roi chien truong':'Rời chiến trường','Tham gia':'Tham gia','Ve chien truong':'Về chiến trường',
    'Shop doi qua':'Shop đổi quà','SHOP DIEM CHIEN TRUONG':'SHOP ĐIỂM CHIẾN TRƯỜNG',
    'Goi bac Lv10':'Gói bạc Lv10','Su dung nhan 100.000 bac':'Sử dụng nhận 100.000 bạc',
    'Gia: ':'Giá: ',' diem / goi':' điểm / gói','Qua vao tui ngay khi doi.':'Quà vào túi ngay khi đổi.',
    'Doi 1 goi':'Đổi 1 gói','Phe do (ta)':'Phe đỏ (ta)','Phe xanh':'Phe xanh',
    'Bam bot phe xanh de danh. Bot hoi sinh sau 10 giay.':'Bấm bot phe xanh để đánh. Bot hồi sinh sau 10 giây.',
    'Bam Tham gia de vao tran. Diem duoc giu qua moi lan vao.':'Bấm Tham gia để vào trận. Điểm được giữ qua mỗi lần vào.',
    'Dang xu ly...':'Đang xử lý...'
}
for old,new in translations.items():daily=daily.replace(old,new)
lobby=(BASE/'original/scripts'/names[1]).read_text(encoding='utf-8')
lobby=lobby.replace('         this.FProcessorDailyActivity.OnClose =', '''         this.FProcessorDailyActivity.OnFieldBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorDailyActivity.OnFieldInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorDailyActivity.OnClose =''')
lobby=lobby.replace('         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_DailyActivity_Base', '''         FPacketRoutines.RegisterRange(0x0118ed00,0x0118ed04,this.PacketPerform_ProcessorDailyActivity);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_DailyActivity_Base''')
needle='      public function ProcessorOnBattleReturn(param1:Object, param2:int, param3:int, param4:Boolean) : void'
before,after=lobby.split(needle)
after=after.replace('         switch(param2)\n         {','''         if(this.FProcessorDailyActivity.FieldBattleActive && param2 == CONST_BATTLE.BattleType_Replay) {
            this.ProcessorsOnReturnTown(param1);
            this.ProcessorWindowsSwitch(this.FProcessorDailyActivity);
            this.FProcessorDailyActivity.FieldBattleReturn();
            return;
         }
         switch(param2)
         {
            case 199:
               this.ProcessorsOnReturnTown(param1);
               this.ProcessorWindowsSwitch(this.FProcessorDailyActivity);
               this.FProcessorDailyActivity.FieldBattleReturn();
               break;''',1)
lobby=before+needle+after
for name,source in zip(names,[daily,lobby]):
    p=BASE/'patched'/name;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(source,encoding='utf-8')
