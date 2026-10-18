# Jiraiya [Toads Chant] — SSS / Assaulter

Hero ID **11120903**, profession **4 (Strength/Assaulter)**, quality **7**, assess **SSS**. Có trong cửa hàng nhân vật dựa trên danh sách BaseHero hợp lệ; không tự thay đổi save hoặc đội hình đang chơi. Client **2026101710** giữ các bản vá Partner, Naruto, Combo/Chase cũ và xử lý chết sau sát thương nội tại. Icon nhỏ dùng ảnh người dùng cung cấp, kích thước 48×48. Xem thêm `../ninja-fragments/README.md` về Modify Fragments và bản sửa Rasen Shuriken.

## Bộ chiêu

| ID | Kỹ năng | Cơ chế |
| --- | --- | --- |
| 13120911 | Summoning Jutsu – Toad Mouth | Prompt, 20 chakra, cooldown 2, battlefield cooldown 0. Toad Esophagus tồn tại round hiện tại và round sau. Cấm Mystery tạo/phá kết giới ở cả hai phe, kể cả Jiraiya. Sau đó thực hiện ngay chiêu bổ sung. |
| 13120912 | Demonic Illusion – Toad Confrontation Chant | Đánh tối đa 2 mục tiêu. Suppress Immunity và Extreme Chaos qua hết round tiếp theo. Extreme Chaos bỏ qua kháng control/shield và chuyển đòn thường sang đồng đội. |
| 13120913 | Giant Gallant Rasengan | Không né được, đánh toàn bộ phe đối phương, 5 combo. Giảm 10% Resistance gốc mỗi lần trúng, cộng dồn tối đa giảm 100%; xác suất Knockdown lên mục tiêu chọn. |
| 13120914 | Ninja Art – Raging Lion's Mane | Cần combo ≥15; đánh tối đa 4 mục tiêu, Repulse mục tiêu chọn. +1 giới hạn Chase cho phe mình trong round, không cộng dồn. Bao gồm Jiraiya; reset ở đầu round. |
| 13120915 | Senjutsu Power | Đầu round hồi giới hạn chakra về 100, tăng Initiative cả đội thêm 2%, cộng dồn tối đa 10%. Xóa debuff cho Jiraiya và tối đa 2 đồng đội Senjutsu; mỗi người nhận 20 vào pool chakra chung. Naruto Sage được nhận diện là Senjutsu. |
| 13120916 | Tale of Jiraiya the Gallant | Sau khi chết, đếm đúng 3 Mystery tiếp theo của phe mình rồi hồi sinh 30% HP. Lần hồi sinh giảm cooldown Mystery của Jiraiya đi 1, tối thiểu cách 1 round. Có thể bắt đầu đếm lại khi chết lần tiếp theo. |

Ảnh không nêu hệ số sát thương hoặc xác suất cụ thể của “high chance”. Bản port dùng hệ số Chant 1.5, Rasengan 1.3, Chase 1.2 và Knockdown 70%, khai báo tại `sunucu/jiraiya-toads.json`. Các trạng thái đặc biệt được xử lý trên server và truyền nhãn FLOAT riêng; không giả làm buff ID Bleach. Kết giới được thể hiện qua animation triệu hồi và nhãn Toad Esophagus; chưa có lớp phông kết giới duy trì toàn chiến trường. Các hero tương lai có thể khai báo `mystery.barrier`, `createsBarrier` hoặc `destroysBarrier` để chịu luật khóa kết giới.

## Cắt và căn animation

Nguồn: `asset/Browser Games - Naruto Online - Recruitable Characters - Jiraiya (Toads Chant)/atlases/`. Giữ nguyên sáu atlas gốc do imagegen tạo. `pack.py` ở thư mục nguồn tìm khoảng trống alpha giữa các hàng thay vì chia Y cứng; dùng một tỷ lệ chung, không kéo giãn frame. `prepare-assets.py` bỏ các mảnh rời dưới 8 pixel, tìm đế guốc đỏ và ghi pivot từng frame. Các frame idle có đầu/vai nhảy ngang bị loại; loop dùng 0→1→2→1 và căn điểm mặt tương ứng. Các clip một lần đều kết thúc bằng cùng frame idle 0. Run bỏ tư thế chuẩn bị để có vòng chạy 9→10→11→12→11→10.

`animation.json` lưu đầy đủ vùng cắt nguồn, pivot, thời gian và mốc hit/return. Model 0C có năm sequence: Barrier=0, Chant=1, Chase=2, Senjutsu=3, Revival=4; client chọn theo skill ID, không random. Rasengan dùng model 0B. Trừ máu ở frame 30 Rasengan, 32 Chant, 27 Chase; mỗi chiêu đúng 100% sát thương report. Hiệu ứng nằm trong sprite nhân vật; PAK impact trong suốt chỉ điều khiển thời điểm HP, không vẽ chồng hiệu ứng Naruto.

Nguồn AI có một số viền chakra/tóc chạm mép ô; bước cắt giữ phần hình có trong atlas và không tự vẽ bù vùng bị thiếu. GIF đã căn neo nằm trong `validation/`. Pivot và kiểu gói native đã được kiểm tra sau khi đóng gói.

## Điều chỉnh kích thước và nhịp chuyển động

Sprite chiến đấu thu đều xuống **70%**, neo chân tại `(128, 210)`. Portrait và icon UI giữ kích thước riêng. Nội suy optical flow hai chiều trên RGBA premultiplied tạo 369 frame ảnh, phát ở **25 FPS (40 ms/frame)**. Tick renderer native khoảng 30 ms; thời lượng frame không được thấp hơn tick để tránh bỏ lỡ hit/return. Mốc trừ máu mới: Rasengan frame 30, Chant frame 32, Chase frame 27. BackPoint cũng được ánh xạ lại; các chiêu kết thúc bằng cùng tư thế idle.

| Động tác | Trước | Sau |
| --- | --- | --- |
| Idle | 400 ms | 1280 ms |
| Chạy | 450 ms | 720 ms |
| Rasengan / Chase | 1360 ms | 1960 ms |
| Barrier / Chant | 1700 ms | 2600 ms |
| Senjutsu | 1080 ms | 1320 ms |
| Hồi sinh | 1350 ms | 1960 ms |

Ảnh trung gian được suy từ atlas sẵn có; không bổ sung được phần tóc/chakra đã bị cắt trong atlas gốc. `portrait.png` lưu ảnh UI trước khi thu sprite. Cài phụ thuộc bằng `python -m pip install -r sunucu-kok/cikarim/jiraiya-toads/requirements.txt` trước khi dựng lại.

Bản sprite mới đã qua kiểm tra 874 frame native trong hai bộ tài nguyên, test combat Jiraiya và fixture Flash/Electron có chết → hồi sinh → ra chiêu tới WINS. Ảnh đối chiếu: `validation/resized-native-battle.png`, `validation/resized-native-final.png`; log `validation/resized-native-runtime.log` không có uncaught exception. GIF từng động tác là bản xem 25 FPS; GIF chụp trận chỉ lấy mẫu một giây/lần để ghi nhận tiến trình, không dùng đánh giá độ mượt.

## Hiệu ứng kỹ năng và rung màn hình

Client **2026101710** thêm lớp hiệu ứng vector native trong `skill-vfx.as.txt`: xoáy chakra và tia va chạm Rasengan; vòng miệng cóc với răng và bụi cho Barrier; sóng tím Chant trên từng mục tiêu; dải tóc trắng nối tới các mục tiêu Chase; hào quang vàng và hạt chakra bay lên cho Senjutsu/hồi sinh. Cả hai phe dùng chung logic và tọa độ được chuyển về lớp chiến trường, không giả định phe trái. Hiệu ứng mục tiêu chỉ lấy dòng ATTACK/ATTACKEX, loại người thi triển, hồi máu và các dòng trạng thái trùng vị trí.

Hiệu ứng gồm tụ chakra khi bắt đầu động tác và bùng nổ theo frame animation. Rasengan/Chant/Chase dùng đúng mốc hit đã đóng gói; các chiêu còn lại ánh xạ theo bước nội suy. Rung nhẹ lúc vận chiêu, mạnh hơn lúc Rasengan (8 px), Barrier (7 px), Chase (5 px), Chant (3,5 px); hỗ trợ rung nhẹ 2 px. Rung suy giảm trong 160–360 ms, có một bộ điều khiển camera chung, trả chính xác tọa độ cũ khi hết hạn hoặc đóng trận. Overlay tự xóa trong 640–850 ms, không giữ hoặc chặn callback combat.

Các hiệu ứng vẽ bằng Graphics/GlowFilter của Flash, không cần ảnh Rasengan hay atlas mới. Dựng lại bằng `build-client.py` sau khi chạy pipeline animation để lấy đúng mốc frame mới.

Đã chạy fixture native ở cả hai phe đến WINS: đủ sáu kỹ năng, 32 sự kiện tụ/bùng hiệu ứng và 32 lần trả camera về `(0,0)`, đúng một mục tiêu sát thương trong fixture, không có lỗi Flash. Bằng chứng ở `validation/skill-vfx-native.gif`, `skill-vfx-both-sides.log`, `skill-vfx-right-final.png` và `skill-vfx-validation.json`. Probe ghi log chỉ tồn tại trong SWF thử nghiệm; client cài đặt không có hook chẩn đoán. Có thể dựng fixture phe phải bằng `make-native-fixture.js <output.bin> --mirror`.

## Dựng và kiểm tra

```powershell
python sunucu-kok/cikarim/jiraiya-toads/prepare-assets.py
python sunucu-kok/cikarim/jiraiya-toads/build.py --apply
python sunucu-kok/cikarim/jiraiya-toads/build-client.py --ffdec "path/to/ffdec.jar" --install
python sunucu-kok/cikarim/jiraiya-toads/verify-assets.py
.\node\node.exe sunucu-kok/sunucu/tests/jiraiya-combat.test.js
```

`build.py` cập nhật JSON, bin đơn và mọi package ngôn ngữ tương ứng, kiểm tra byte các bản ghi ngoài phạm vi được giữ nguyên. `verify-assets.py` giải mã 874 frame đã cài trong hai phiên bản, đối chiếu từng pixel/alpha, pivot, timing và mốc sát thương. `build-client.py` decompile đối chiếu patch, giữ nguyên các tag SWF ngoài bytecode, cập nhật manifest tới 2026101710. Chạy bản vá này sau các script vá Naruto cũ nếu dựng lại client.

Kiểm thử Jiraiya gồm giới hạn mục tiêu, hit không né, thời hạn kết giới hai phe, chiêu bổ sung, 15 combo và ngân sách Chase hữu hạn, reset mỗi round, cleanse/chakra/Initiative cap, Suppress Immunity/Chaos, đếm hồi sinh theo phe và chiến đấu thực sinh record hồi 30% HP. Hồi quy Naruto, hero skills và hero talents đều PASS. Khởi động lại backend và client sau cập nhật.

Đã phát battle report 10 round qua client native Electron/Flash 22 tới WINS, gồm Jiraiya hai phe, Naruto và Chase tóc Sư Tử. Fixture render riêng ép 3 Mystery đồng đội để kiểm tra chuỗi chết → hồi 30% HP → nằm/đứng hồi sinh → tiếp tục sử dụng chiêu; kết giới có nhãn duy trì rồi xóa ở round 3. Fixture này chỉ kiểm tra renderer; luật cooldown và đếm Mystery chính xác được kiểm tra bằng trận mô phỏng trong test server. Bằng chứng: `validation/native-battle.gif`, `validation/engine-battle-final.png`, `validation/native-revival.gif`, `validation/native-revival-final.png` và log không có uncaught exception. Không sửa save thật.

## Hiệu ứng phóng lớn — client 2026101711

Rasengan có cầu chakra tụ ở tay (bán kính tối đa 65 px), lõi sáng, xoáy va chạm tăng từ 76 lên 182 px và sóng xung kích rộng. Sóng Chant trên mục tiêu tăng bán kính từ khoảng 100 lên 215 px, thêm năm vòng âm lan từ người thi triển tới 305 px. Barrier tăng bán kính tối đa từ 115 lên 185 px. Rung khi trúng Rasengan/Chant lần lượt 13/10 px, giảm dần trong 480 ms; overlay Rasengan/Chant tồn tại 1000/1100 ms và tự dọn như trước. Không thay đổi sát thương, mục tiêu, frame hit hay thời gian lượt đánh. Đây là thay đổi hiệu ứng hình ảnh; không bổ sung âm thanh gầm.

## Dựng lại theo video — client 2026101712

Chi tiết đối chiếu, asset, giới hạn và cách kiểm tra nằm tại [video-reference.md](video-reference.md). Bản mới có nền thực quản cóc duy trì theo marker kết giới, chuyển cảnh bằng mép miệng khép/mở, luồng Chant vàng theo hướng phe và Rasengan có nhấc sprite, cầu xoáy xanh trắng, lóe dọc, shockwave và mảnh văng. Dựng lại bằng `build-client.py --install`; script cài luôn asset JPG ngoài SWF. Asset nguồn AI và prompt được lưu trong `assets/`.

## Asset Rasengan nhảy và đập xuống — client 2026101713

Bộ tư thế, đường nhảy/lao xuống và cách dựng được ghi tại [rasengan-slam.md](rasengan-slam.md). Chạy `build-rasengan-slam.py --apply` để chỉ cập nhật texture Rasengan; sau đó dựng client bằng `build-client.py --ffdec PATH/ffdec.jar --install` để đồng bộ bàn tay/quả cầu. Mốc hit 30 và return 48 không đổi; cooldown dùng luật mới trong `../ninja-cooldowns/README.md`.
