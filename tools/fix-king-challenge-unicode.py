from pathlib import Path
p=Path('sunucu-kok/cikarim/king-challenge-audit/patch-client.py');s=p.read_text(encoding='utf-8')
fixes={'DANH S?CH ??NG K?':'DANH SÁCH ĐĂNG KÝ','??NG K? - ':'ĐĂNG KÝ - ','S? c?p':'Sơ cấp','Trung c?p':'Trung cấp','Cao c?p':'Cao cấp','Chuy?n sinh':'Chuyển sinh','Ch?a ??ng k?':'Chưa đăng ký','V? tr? tr?ng':'Vị trí trống','B?n ?? ??ng k? nh?m ':'Bạn đã đăng ký nhóm ','; ?ang xem nh?m kh?c.':'; đang xem nhóm khác.','Ph?n th??ng':'Phần thưởng','C?p nh?t':'Cập nhật','?ng k?':'Đăng ký','C??c c?a t?i':'Cược của tôi','C??c (':'Cược ('}
# Correct generated captions and source match strings before applying the patch.
for a,b in fixes.items():s=s.replace(a,b)
lines=s.splitlines()
for i,line in enumerate(lines):
 if "old=c.m.extract(text,'PacketPerform_SC_KingChallenge_UploadRet')" in line:
  lines[i]="old=c.m.extract(text,'PacketPerform_SC_KingChallenge_UploadRet');old=old.replace('Kh?ng th? ??ng k?. H?y th? l?i.','Không thể đăng ký. Hãy thử lại.').replace('??ng k?/c?p nh?t ??i h?nh th?nh c?ng.','Đăng ký/cập nhật đội hình thành công.');end=old.rfind('}');old=old[:end]+'         this.FMainWin.FollowRegistration=true;this.FUnstreamizer.BaseReq();\\n      }';text=replace(text,'PacketPerform_SC_KingChallenge_UploadRet',old)"
 # This line is executable Python; use one literal newline escape in its string.
  lines[i]=lines[i].replace('\\\\n','\\n')
p.write_text('\n'.join(lines)+'\n',encoding='utf-8')
p=Path('sunucu-kok/cikarim/king-challenge-audit/build-probe.py');s=p.read_text(encoding='utf-8').replace('Ng??i ch?i','Người chơi');p.write_text(s,encoding='utf-8')
