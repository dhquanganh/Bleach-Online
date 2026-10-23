"""Show the registration roster first; reveal the bracket only after the cutoff."""
from pathlib import Path
BASE=Path(__file__).resolve().parent
rel=Path('Processors/Game/Lobby/KingChallenge/TProcessorWindowKingChallenge.as')
text=(BASE/'registration-verify/scripts'/rel).read_text(encoding='utf-8')
text=text.replace('protected var FRegistrationInfo:TextField;', 'protected var FRegistrationInfo:TextField;\n      protected var FRegistrationList:Sprite;\n      protected var FRegistrationTitle:TextField;\n      protected var FRegistrationNames:Vector.<TextField>;')
anchor='this.FMainScene.addChild(this.FRegistrationInfo);'
assert anchor in text
text=text.replace(anchor,anchor+r'''
         this.FRegistrationList = new Sprite();
         this.FRegistrationList.x = 270; this.FRegistrationList.y = 175;
         this.FRegistrationList.graphics.lineStyle(1,0x8a7046);
         this.FRegistrationList.graphics.beginFill(0x101a23,0.97);
         this.FRegistrationList.graphics.drawRoundRect(0,0,710,340,12,12);
         this.FRegistrationList.graphics.endFill();
         this.FRegistrationTitle = new TextField();
         this.FRegistrationTitle.defaultTextFormat = new TextFormat("Tahoma",18,0xffcc66,true,null,null,null,null,"center");
         this.FRegistrationTitle.x = 15; this.FRegistrationTitle.y = 16;
         this.FRegistrationTitle.width = 680; this.FRegistrationTitle.height = 28;
         this.FRegistrationTitle.mouseEnabled = false;
         this.FRegistrationList.addChild(this.FRegistrationTitle);
         var guidance:TextField = new TextField();
         guidance.defaultTextFormat = new TextFormat("Tahoma",12,0xeeeecc,false,null,null,null,null,"center");
         guidance.text = "Hết hạn đăng ký mới chốt danh sách và xếp trận.";
         guidance.x = 15; guidance.y = 48; guidance.width = 680; guidance.height = 22;
         guidance.mouseEnabled = false; this.FRegistrationList.addChild(guidance);
         this.FRegistrationNames = new Vector.<TextField>();
         for(var row:uint = 0; row < 8; row++)
         {
            var entry:TextField = new TextField();
            entry.defaultTextFormat = new TextFormat("Tahoma",14,0xffffff);
            entry.x = 20 + row % 2 * 345; entry.y = 85 + int(row / 2) * 58;
            entry.width = 325; entry.height = 40;
            entry.background = true; entry.backgroundColor = 0x1b2933;
            entry.border = true; entry.borderColor = 0x504933;
            entry.mouseEnabled = false; this.FRegistrationNames.push(entry);
            this.FRegistrationList.addChild(entry);
         }
         this.FMainScene.addChild(this.FRegistrationList);''')
helper=r'''      protected function UpdateRegistrationPhase() : void
      {
         var registration:Boolean = this.FData.SeasonStatus == 0;
         this.FRegistrationList.visible = registration;
         this.FMainScene["MC_Table"].visible = !registration;
         this.FMainScene["MC_HeadPoint"].visible = !registration;
         this.FMainScene["Name"].visible = !registration;
         this.FMainScene["MC_JackPiont"].visible = !registration;
         this.FBtn_ShowGamble.Enabled = !registration;
         this.FRegistrationTitle.text = "DANH SÁCH ĐĂNG KÝ (" + this.FData.PlayersInfo.length + "/8)";
         for(var index:uint = 0; index < 8; index++)
            this.FRegistrationNames[index].text = (index + 1) + ". " + (index < this.FData.PlayersInfo.length ? this.FData.PlayersInfo[index].UserName : "Chưa đăng ký");
         this.FRegistrationInfo.text = registration
            ? (this.FData.UserBaseInfo.Permission ? "Đã đăng ký" : "Chưa đăng ký") + " | Hết giờ sẽ chốt danh sách và xếp trận"
            : "Đã chốt danh sách | Thiếu đối thủ: thắng miễn đấu";
         if(registration) this.FDetailWin.Visible = false;
      }

'''
anchor='      protected function UpdateUI() : void'
assert anchor in text;text=text.replace(anchor,helper+anchor)
lines=text.splitlines()
for i,line in enumerate(lines):
 if 'this.FRegistrationInfo.text =' in line and 'this.FData.UserBaseInfo.Permission' in line:
  lines[i]='         this.UpdateRegistrationPhase();'
 if 'this.FBtn_UpLoad.Caption =' in line:
  lines[i]=r'         this.FBtn_UpLoad.Caption = this.FData.UserBaseInfo.Permission ? "Cập nhật" : "Đăng ký";'
 if 'this.FHint.Caption =' in line:
  lines[i]=r'         this.FHint.Caption = "Đăng ký trước 21:05 thứ Hai, Tư, Sáu (UTC+7). Hết hạn mới chốt danh sách và xếp trận theo thứ tự đăng ký. Mỗi nhóm tối đa 8 người. Cặp đủ hai người có 1 phút chuẩn bị trước trận đầu. Thiếu đối thủ được thắng miễn đấu đến vô địch.";'
text='\n'.join(lines)+'\n'
# Raw strings above preserve AS3 unicode escapes while keeping shell encodings out of labels.
text=text.replace(r'\"','"')
target=BASE/'phase-patched'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
print('Prepared registration-first tournament UI')
