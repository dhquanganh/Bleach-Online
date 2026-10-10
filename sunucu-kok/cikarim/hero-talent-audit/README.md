# Kiểm tra talent và đồng bộ nhân vật

Đã đọc toàn bộ 148 BaseHero, 203 HeroTalent, 7.999 SkillConfig và 20.171 RoleModel. `report.json` chứa kết quả cho từng nhân vật: tên, talent, mô tả gốc, hiệu ứng có hệ số rõ ràng, tỷ lệ cơ bản và tham chiếu lỗi. Audit đọc trực tiếp tài nguyên frontend và so sánh tất cả trường BaseHero cùng tên/mô tả HeroTalent với JSON backend. Cả ba bản BaseHero frontend đã được đối chiếu.

## Thay đổi

- `sunucu/hero-talents.js` là bảng hiệu ứng dùng chung. Những tỷ lệ được mô tả cụ thể được áp dụng một lần vào cả PvE/PvP trước trang bị, sao và tái sinh. Tỷ lệ riêng của nhân vật và tốc độ tăng theo level thay thế các trường từng bị sao chép từ nhân vật chính. Chỉ số chiến đấu đọc lại chính gói stat gửi client.
- Engine dùng hit/dodge/crit/block/combo, break defense, damage/reduction và tỷ lệ Enemy trong dữ liệu. Block có bản ghi phản ứng `Active_Block` mà frontend yêu cầu. Fury 0 được giữ nguyên, kể cả khi ghi thông tin đầu trận. Extra attack không sinh fury và không combo đệ quy.
- Các talent có đòn thường đặc biệt: skill thay đòn thường, đòn thường 200%, đánh hai mục tiêu ATK cao nhất với hit bảo đảm, ưu tiên hàng Assaulter. Animation dự phòng cho bot không xóa logic skill.
- Talent bắt đầu ở level 159 chỉ áp dụng khi tạo bản ghi mới; không ghi đè level bị giảm do tái sinh. Gói tuyển nhân vật trả về level thực đã lưu.
- Attack/Defense percentage không còn ghi nhầm vào ControlRate/ControlAnti; bonus được chuyển vào chỉ số ATK/DEF tương ứng.
- Sửa 9 bản ghi thiếu animation ở cả JSON và các file `01000005.bin`. Một active tìm được animation theo đúng skill ID; tám active khác dùng animation đòn thường dự phòng. Không thay skill ID/talent ID. `animation-repairs.json` liệt kê từng trường hợp; bản gốc ở `backups/`.

## Giới hạn dữ liệu

Frontend `THeroTalent.ReadDataByStream` chỉ đọc tên và mô tả, không chứa công thức talent. 126 nhân vật có mô tả thiếu hệ số như “certain percent”, “massive”, hoặc “small chance of Combo”. Các phần đó tiếp tục dùng BaseHero base/growth/rates; không tự đặt thêm phần trăm. Vì vậy chưa thể khẳng định tái tạo đầy đủ công thức server gốc. Cần dữ liệu công thức hoặc battle log gốc để xác định các hệ số chưa có.

Công thức đổi primary stat sang ATK/HP/FightingPower vẫn dựa vào mô hình hiệu chỉnh hiện có của server local. Quy tắc local: crit x1.5, block giảm một nửa sát thương, Aid chia đôi một đòn thường với đồng đội còn sống. Frontend nhận đủ các biến động HP/Shield/heal và cờ animation tương ứng; các quy tắc này không phải công thức server gốc đã được xác minh. Cơ chế scale stage và force-win cũ được giữ nguyên.

## Kiểm tra

```powershell
node sunucu-kok/cikarim/hero-talent-audit/audit.js --write
node sunucu-kok/sunucu/tests/hero-talents.test.js
node sunucu-kok/cikarim/hero-talent-audit/verify.js
```

`hero-talents.test.js` kiểm tra tất cả 148 nhân vật, chỉ số frontend/combat, cả hai block PvE/PvP, các đòn thường đặc biệt, fury, hit/crit/block/Aid/counter, level tuyển ban đầu, phần trăm trang bị và decode/encode báo cáo.

`verify.js` chạy bộ test và đối chứng các bài lỗi bằng code HEAD trong bộ nhớ; không checkout, không khôi phục hoặc ghi lại save người chơi. Kết quả được ghi vào `test-results.json`. Bảy bài kiểm tra cũ đang lỗi cả trước thay đổi: chest-live-sync, conquest, cross-server, hollow-soul-stats, soul-stone, usable-items, void-entry. Một số bài phụ thuộc level, đội hình hoặc trang bị của save đang chơi; những lỗi khác cần xử lý riêng, không được đánh dấu là đã qua.

Đóng/mở lại game và server để nạp code và tài nguyên mới. Chưa kiểm tra thao tác/animation trực tiếp trong cửa sổ Flash; bằng chứng hiện tại là đối chiếu tài nguyên, kiểm tra engine và kiểm tra cấu trúc packet.
