# Naruto Sage Mode và Chase / Combo

Naruto `[Sage Mode]`, ID **11120901**, xuất hiện trong cửa hàng nhân vật hiện có. Mua/thêm nhân vật, đăng nhập lại và đưa vào Formation. Khởi động lại server và client để nạp dữ liệu mới. Phân thân ID **11120902** chỉ là đơn vị triệu hồi, không bán trong cửa hàng và không chiếm lượt đánh thường của đội.

Asset nguồn: 166 PNG trong `asset/Browser Games - Naruto Online - Recruitable Characters - Naruto Uzumaki (Sage Mode)`. `build.py` chuyển các tư thế đã chọn thành TexClient đúng định dạng native: idle, fight idle, attack, skill, hit, run, portrait và hiệu ứng. Vì PNG rời không chứa timeline/pivot gốc, thứ tự khung và điểm neo là bản dựng lại cho client Bleach.

Thumbnail và chân dung dùng đúng ảnh người dùng cung cấp, lưu tại `gorsel/naruto-sage-thumb.png` (363 × 352). `HeadIcon`/`SmallIcon` được thu về 64 × 64; `LargeIcon`/`MiddlePicture` giữ tỷ lệ ảnh gốc. Áp dụng cho cả hai bộ tài nguyên 2017112917 và 2026090619; animation chiến đấu vẫn dùng PNG sprite ban đầu.

## Bộ kỹ năng theo ảnh

| Kỹ năng | Hành vi |
| --- | --- |
| True Wind Style – Rasen Shuriken | Prompt, sát thương Phong toàn đội địch; 10 hit trong chuỗi; Repulse riêng mục tiêu chính. Tốn 40 chakra, cooldown 2 round, battlefield cooldown 1: sớm nhất round 2, rồi round 4. Không dùng mất lượt đánh thường. |
| Sage Jutsu Shadow Clone | Có phân thân lúc bắt đầu trận nếu còn ô trống. Khi không có phân thân hoạt động, lượt thường triệu hồi lại phân thân đã bị hạ. Phân thân có HP và vị trí riêng; kháng Lôi. |
| Sage Art – Rasengan Barrage | Khi có phân thân hoạt động, thay lượt triệu hồi bằng đòn kết hợp Taijutsu/Ninjutsu, gây Low Float khi đánh trúng. |
| Rasengan – Shoot down | Chase Repulse → Knockdown, tối đa 1 lần mỗi round. |
| Sage Jutsu Chakra | +20 chakra chung của đội trước lượt đầu tiên mỗi round; Naruto đã chết không cấp chakra. |

Các con số không có trong ảnh được cấu hình công khai trong `sunucu/naruto-sage.json`: hệ số sát thương Mystery 1.8, Barrage/Chase 1.2, Barrage 3 hit, HP clone 30% chủ nhân, giảm sát thương Lôi 50%. Đây là thông số cân bằng bản port, không phải con số được xác nhận từ Tencent/Oasis.

## Một chuỗi combo hình thành từng bước

1. Đòn thường hoặc Mystery đánh trúng mục tiêu chính. Mỗi kỹ năng định nghĩa số hit và trạng thái tạo ra. Đánh trượt không mở Chase.
2. Tạo một chuỗi mới với bộ đếm hit riêng. Ví dụ Rasen Shuriken bắt đầu ở **10 hit + Repulse**; không cộng 10 lần nữa theo từng mục tiêu AoE.
3. Tìm ninja cùng đội còn sống, không bị khống chế, có Chase nhận trạng thái hiện tại và còn lượt dùng trong round.
4. Nếu nhiều ninja cùng đủ điều kiện, ưu tiên `moveOrder` nhỏ nhất; nếu không khai báo thì dùng vị trí Formation `pos` tăng dần. Trong cùng ninja, thứ tự khai báo kỹ năng quyết định ưu tiên. Không dùng tốc độ để tranh quyền Chase.
5. Ninja được chọn đánh ngay, trước lượt đánh thường tiếp theo. Trạng thái cũ được tiêu thụ và thay bằng trạng thái do Chase vừa tạo; số hit tăng theo kỹ năng. Xét lại từ ninja ưu tiên đầu tiên sau **mỗi mắt xích**.
6. Sau các Chase theo trạng thái, xét Chase yêu cầu **≥10 / ≥20 hit** (`minCombo`). Một Chase 10 hit có thể nâng tổng từ 10 lên 20, mở Chase ngưỡng 20 ngay trong chuỗi đó. Chase chỉ theo hit không tự xóa trạng thái nếu kỹ năng không thay trạng thái.
7. Dừng khi không còn Chase hợp lệ, mục tiêu chết hoặc đòn Chase trượt. Không chuyển chuỗi đang chạy sang một mục tiêu mới.
8. Mỗi kỹ năng Chase mặc định dùng **1 lần/round**, tính chung mọi chuỗi của round đó. Ngoại lệ dùng `maxPerRound`, ví dụ 2 lần. Sang round mới mới xóa bộ đếm sử dụng. Tổng số lần hữu hạn ngăn vòng lặp Low Float → Low Float vô tận.

Ví dụ với Naruto: **Rasen Shuriken (10, Repulse) → Naruto Shoot down (11, Knockdown) → đồng đội Chase Knockdown → … → Chase ngưỡng 20 khi đủ hit**. Chỉ Naruto được thêm từ asset hiện có; ví dụ đồng đội minh họa cách định nghĩa ninja tiếp theo, không tự gán Chase Naruto cho các nhân vật Bleach.

## Trạng thái

| Trạng thái | Vai trò |
| --- | --- |
| Low Float | Hất thấp; đầu vào cho Chase `lowFloat`. |
| High Float | Hất cao; đầu vào cho Chase `highFloat`. |
| Knockdown | Đánh ngã; đầu vào cho Chase `knockdown`. |
| Repulse | Đẩy lùi; đầu vào cho Chase `repulse`. |
| Immobile | Khống chế đến hết round hiện tại: không đánh thường, Mystery hoặc Chase. Có thể là điều kiện Chase khi kỹ năng định nghĩa rõ. Không coi đây là một trạng thái hất tung. |

Super Armor chặn bốn trạng thái dịch chuyển, nhưng không tự chặn Chase theo số hit. `immuneControl` chặn Immobile. Ninja bị paralysis không Chase. Các trạng thái stun/freeze/fossilize/void hiện có cũng được xét. Trạng thái dịch chuyển chỉ tồn tại trong chuỗi, không lưu đến đòn thường tiếp theo.

## Tích hợp

`sunucu/naruto-combat.js` quản lý điều kiện, ưu tiên, giới hạn, chakra, phân thân và trace. `savas.js` dùng cùng đường tính sát thương và tạo báo cáo native như combat cũ. `unit.naruto` có thể cung cấp profile cho ninja mới; từng Chase có `requires`, `causes`, `combo`, `minCombo`, `maxPerRound`, `multiplier` và `id`.

Kho chakra bản port khởi tạo mỗi round ở 20/40/60/80/100, cộng nội tại và chặn ở 100. Chỉ kỹ năng Naruto dùng chakra; kỹ năng Bleach giữ rage/Punch hiện có. Client Bleach chưa có thanh chakra đội hoặc giao diện chọn Mystery thủ công kiểu Naruto Online; Mystery Naruto hiện tự dùng khi đủ điều kiện, chọn đối thủ đầu tiên còn sống. Client hiển thị nhãn COMBO/trạng thái qua CMD.FLOAT và có bản vá hồi sinh riêng cho phân thân. Các chuyển động hất thấp/cao/đẩy lùi nguyên bản Naruto chưa được tái tạo; model và hiệu ứng là bản dựng từ PNG.

`kadroRapor()` trả thêm `chaseTrace` và `chakra` để kiểm tra server. Dữ liệu này không làm đổi cấu trúc binary battle report. Client mới: URL phiên bản **2026101701**, đồng thời cập nhật bản canonical; manifest giữ nguyên các mapping khác. Database JSON, bin đơn, package gộp và các gói ngôn ngữ được cập nhật nhất quán. Script xác nhận byte của các bản ghi ngoài phạm vi không đổi. Không sửa save tài khoản đang chơi.

## Xác minh và dựng lại

```powershell
.\node\node.exe sunucu-kok/sunucu/tests/naruto-combat.test.js
.\node\node.exe sunucu-kok/sunucu/tests/hero-talents.test.js
.\node\node.exe sunucu-kok/sunucu/tests/hero-skills.test.js
python sunucu-kok/cikarim/naruto-sage/build.py --apply
python sunucu-kok/cikarim/naruto-sage/build-client.py --ffdec "path/to/ffdec.jar" --install
```

`build-client.py` đọc client hiện tại, xuất đúng lớp cần sửa, thêm bản vá và biên dịch; chạy lại trên client đã vá sẽ bỏ qua. `verify-client.py` kiểm tra bản biên dịch bằng decompile và đối chiếu toàn bộ SWF tag ngoài bytecode. Backup nằm trong thư mục `backups/` cục bộ. Không dùng `verify-client.py --install` trực tiếp sau khi baseline đã thay đổi.

Kiểm thử bao gồm tranh quyền Chase, chuỗi nhiều trạng thái, ngưỡng 10/20, reset mỗi round, ngoại lệ 2 lần, Super Armor, Immobile, paralysis, trượt/chết, chakra/cooldown, phân thân/kháng Lôi, AoE, packet round trip và khả năng tuyển Naruto. Hai bộ hồi quy hiện có xác minh talent/skill Bleach. `runtime-electron.js` chạy probe PAK bằng Flash 22 của game, độc lập với backend/tài khoản, ghi bằng chứng vào `validation/`.

Kết quả ngày 17/10/2026: cả ba bộ kiểm thử trên đều PASS. Probe Flash 22 xác nhận 6 nhóm sprite có pixel hiển thị: idle 1 frame, fight idle 4, Barrage 10, jutsu 10, hit reaction 5, run 6. Xem `validation/native-assets.png` và `validation/native.log`. Probe xác minh tài nguyên native; chưa xác minh trực quan một trận hoàn chỉnh sau đăng nhập hoặc hoạt ảnh hồi sinh clone trong trận. Logic hồi sinh và nhãn Combo đã qua kiểm tra biên dịch/decompile, còn combat đi qua kiểm thử server và binary round trip.

## Nguồn đối chiếu

- [Chases Guide – diễn đàn Naruto Online](https://forum-narutoen.narutowebgame.com/page/show-post-31236-1.html): thứ tự Chase theo vị trí, mắt xích trạng thái, giới hạn và ngoại lệ.
- [Naruto Sage Mode – Ninja Discussion](https://forum-narutoen.narutowebgame.com/page/show-post-6459-1.html?thread_anchor=18): phân thân kháng Lôi và bộ chiêu Sage. Thông số cooldown/bộ chiêu của bản port ưu tiên ảnh người dùng gửi vì phiên bản game có thể khác.

Đây là cơ chế Naruto được tích hợp vào client Bleach hiện có; các thông số và phần giao diện chưa khớp bản gốc được nêu rõ ở trên.

## Sửa Partner đứng ở Loading resources 100% — 17/10/2026

Client `TWakeHeroAttributes.SetProperties` gọi `AddPropertiesByEquip` cho mọi partner. Naruto chưa có bảng Awakening; client đọc cấu hình null, gây Error #1009 sau khi đã thêm ID vào vector. Lượt thử tiếp theo truy cập các vector chưa khởi tạo xong, gây Error #1125 và lặp yêu cầu stat mỗi frame; màn loading không thoát.

`fix-partner.py` sửa ba helper tính Awakening để cấu hình không tồn tại mang nghĩa không có bonus Awakening. Việc khởi tạo các vector của từng hero hoàn thành bình thường; không thêm cấu hình nâng cấp giả và không bắt/bỏ qua mọi exception. Đồng thời `build.py` bổ sung model `A9B1050E.TexClient`, đúng chỉ số showcase 14 mà màn Partner yêu cầu.

Đã biên dịch, decompile xác minh và cài client **2026101702** qua manifest; giữ nguyên các tag SWF ngoài bytecode. Bản này kế thừa các sửa Naruto/clone/Combo trước đó. Đóng và mở lại client để nạp bản sửa.

Xác minh native trong Electron/Flash 22, dùng backend và save sao chép tại `.partner-runtime-test`: tái hiện được lỗi trước sửa; sau sửa mở Partner, chọn Naruto và chuyển sang Accessories thành công, không còn exception. Bằng chứng: `validation/partner-before.log`, `validation/partner-after.log`, `validation/partner-fixed-main.png`, `validation/partner-fixed-naruto.png`, `validation/partner-fixed-accessories.png`. Không sửa save thật.

```powershell
python sunucu-kok/cikarim/naruto-sage/fix-partner.py --ffdec "path/to/ffdec.jar" --install
```

Sau khi dựng lại từ một baseline cũ bằng `build-client.py`, chạy lệnh này để giữ bản sửa Partner. `partner-runtime.js` chạy kiểm tra trực quan trên backend thử ở cổng 10035 và HTTP 7438; các lệnh click/reload/quit được đọc từ `validation/partner-control.json`.

## Sửa animation Naruto — 17/10/2026

Bản dựng ban đầu trộn frame do dùng số đầu tên file xuất ra. Thứ tự nhóm chuyển động nằm ở số cuối `Asset_<n>`; đó là khóa của `animation.json` mới. Idle/showcase dùng nhóm 51–59, chạy 18–22, Barrage 0–17 rồi về idle. Các tư thế bị đánh, triệu hồi, ném và Chase được tách riêng. Mỗi frame có điểm neo thân/chân đã căn lại; không lấy giữa chiều rộng ảnh làm điểm neo và không co giãn riêng từng frame. Nhóm idle giữ đường chân cố định, độ dao động ngang của tâm tóc sau căn neo nhỏ hơn 2 pixel.

Model `0c` chứa ba sequence: Mystery = 0, Summon = 1, Chase = 2. `fix-animation.py` sửa `TActive.PlaySkill` để Naruto/chân thân chọn đúng sequence theo skill ID, thay cho chọn ngẫu nhiên. Các nhân vật khác giữ cách chọn hiện tại. Dữ liệu `attackEffect` của Naruto/clone được cập nhật đồng bộ trong JSON, bin và package ngôn ngữ: Barrage đánh ở frame 5/9/12, Mystery ở 8, Chase ở 6; các phần sát thương cộng đủ 100%. Summon không chạy tới địch hoặc phát hiệu ứng đánh nhầm mục tiêu. Mỗi chiêu có frame trở về đúng độ dài animation; clip một lần kết thúc ở tư thế idle.

Đã cài client **2026101703**, giữ bản sửa Partner, clone và nhãn Combo. Ảnh thumbnail người dùng cung cấp vẫn được giữ nguyên. Đóng và mở lại client sau khi cập nhật.

Xác minh mới:

- `verify-animation.py`: 186 frame trong hai phiên bản có pixel/alpha đúng PNG nguồn, không lệch vùng atlas, pivot và duration đúng; kiểm tra frame đánh/trở về khớp dữ liệu kỹ năng.
- Probe Flash 22 đọc đúng cả 9 mục hiển thị, gồm 3 sequence chiêu riêng; kiểm tra điểm neo và hướng trái/phải. `validation/native-assets.png` / `validation/native.log` là bằng chứng mới.
- Phát toàn bộ battle report 16 round qua bộ render native, có đủ bốn ID kỹ năng 13120901–13120904 ở hai phe, phân thân chết/triệu hồi và kết thúc tại WINS. Không có uncaught Flash exception. `validation/animation-battle-final.png`, `validation/animation-battle.gif`, `validation/animation-runtime.log`.
- Kiểm thử `tests/naruto-combat.test.js` vẫn PASS.

`validation/animation-preview.gif` là preview các chuỗi theo cùng frame, pivot và duration dùng để đóng gói. Để dựng lại từ baseline cũ, chạy `build-client.py`, `fix-partner.py`, rồi `fix-animation.py` theo thứ tự; `build.py --apply` dựng tài nguyên và timeline kỹ năng.

```powershell
python sunucu-kok/cikarim/naruto-sage/build.py --apply
python sunucu-kok/cikarim/naruto-sage/fix-animation.py --ffdec "path/to/ffdec.jar" --install
python sunucu-kok/cikarim/naruto-sage/verify-animation.py
python sunucu-kok/cikarim/naruto-sage/preview-animation.py
```

## Hiệu ứng Rasengan / Rasen Shuriken — 17/10/2026

Hai atlas RGBA mới nằm tại `gorsel/naruto-vfx/`, tạo bằng công cụ imagegen tích hợp. Prompt đầy đủ được lưu trong `gorsel/naruto-vfx/PROMPTS.md`. PNG gốc được giữ nguyên alpha; `vfx.py` cắt theo lưới 4×4 và đóng gói qua `build.py` thành TexClient native, gồm lớp RGB và alpha riêng đúng định dạng Flash.

`vfx.json` quản lý sáu hiệu ứng: tụ Rasengan và nổ cho Barrage, tụ Rasen Shuriken và nổ gió cho Mystery, tụ Rasengan và nổ lớn cho Chase. ID 13621901–13621906 được cài trong cả hai bộ tài nguyên 2017112917/2026090619. Pivot từng frame đặt chakra theo bàn tay; hiệu ứng trúng đòn neo vào thân mục tiêu và được lật theo phe bởi renderer native. Kích thước, duration, danh sách frame và vị trí có thể chỉnh tại `vfx.json`, sau đó chạy lại `build.py --apply`.

Các sự kiện tụ chakra chỉ vẽ trên người dùng chiêu, không gây thêm sát thương. Các lần trúng đòn dùng hiệu ứng mới trên mục tiêu; phần trừ máu nằm ở frame va chạm của hiệu ứng và tổng tỷ lệ vẫn là 100% cho mỗi chiêu. Naruto và phân thân dùng cùng cấu hình. Không cần đổi bytecode client 2026101703.

Xác minh: `verify-vfx.py` giải mã 84 frame hiệu ứng đã cài trong hai phiên bản, so sánh pixel/alpha với frame nguồn, kiểm tra pivot, duration, liên kết người ra đòn/mục tiêu và tỷ lệ sát thương. `verify-animation.py` và kiểm thử combat Naruto đều PASS. Đã chạy hiệu ứng qua battle report native trong Electron/Flash 22 trên backend/save thử riêng; hiệu ứng trong suốt hiển thị trên cả hai phe. Bằng chứng: `validation/vfx-native-battle.gif`, `validation/vfx-native-impact.png`. Preview có nhịp frame đầy đủ: `validation/naruto-vfx-preview.gif`.

```powershell
python sunucu-kok/cikarim/naruto-sage/build.py --apply
python sunucu-kok/cikarim/naruto-sage/verify-vfx.py
python sunucu-kok/cikarim/naruto-sage/preview-vfx.py
```

## Chữ nổi trạng thái Chase — 17/10/2026

Client **2026101704** hiển thị trạng thái Low Float, High Float, Knockdown, Repulse và Immobile bằng màu riêng trên mục tiêu. Dòng thứ hai ghi số COMBO hiện tại. Đòn truy kích có tiền tố CHASE; đòn mở chỉ ghi trạng thái. Chữ bay lên 58 px trong 1,4 giây và mờ dần ở cuối. Một mục tiêu chỉ giữ nhãn mới nhất để chuỗi nhanh không chồng chữ; hai mục tiêu vẫn hiển thị độc lập. Chữ nằm trên lớp chiến trường, không bị lật theo hướng ninja. Listener hoạt ảnh được tháo khi chữ hết hạn, bị thay hoặc rời sân.

Đã kiểm tra chữ nổi trực tiếp trong trận native Electron/Flash 22 trên backend/save thử riêng. Bằng chứng được lưu tại `validation/chase-text-native.gif` và `validation/chase-text-runtime.log`.

Server giữ FLOAT marker 19000100–19000105 cho đòn mở và dùng 19000200–19000205 cho Chase trúng đích. Hai dải có cùng thứ tự trạng thái; buffTurn chứa combo count. Đây là bản ghi hiển thị, không thêm buff hoặc thay đổi luật sát thương. Khi không áp được trạng thái, nhãn chỉ ghi combo và CHASE nếu có. Test combat kiểm tra kết quả từng mắt xích và cả marker/count sau binary round trip.

`fix-chase-text.py` chỉ thay phần nhãn trong `TRole.AddTextEffectByCMD`, giữ nhánh chữ nổi gốc cho các ID khác, xác minh các bản vá Partner/animation/clone trước đó và giữ nguyên tag SWF ngoài bytecode. Chạy sau các script vá client cũ khi dựng lại. Cần khởi động lại backend và client để dùng đồng bộ hai dải marker.

```powershell
python sunucu-kok/cikarim/naruto-sage/fix-chase-text.py --ffdec "path/to/ffdec.jar" --install
.\node\node.exe sunucu-kok/sunucu/tests/naruto-combat.test.js
```
