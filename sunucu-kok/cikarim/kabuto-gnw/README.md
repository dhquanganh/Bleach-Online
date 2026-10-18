# Kabuto [Great Ninja War] — SSS Support, đánh cận chiến

## Original extracted assets - client 2026101813

Kabuto now uses `asset/Extracted_Kabuto_Great_Ninja_War`. All 14 input assets are checked against the supplied SHA-256 manifest. Older sections below describe the superseded generated artwork.

`prepare-assets.py` decodes the bitmap/XML MME character and showcase SWFs. It preserves layers, coordinates, rotations, scale, alpha and source poses, resampling the original 24 FPS timeline to the engine's 40 ms tick. Per-frame pivots and deduplicated row-packed TexClient atlases keep registration stable and bitmaps below 4096 px. The source pack contains only Kabuto's model; existing Edo guest character artwork is retained. The client decoder opts into explicit atlas rectangles only for the new PAK type 127; existing resource formats keep their sequential decoder path. Character frame bounds are computed from transformed artwork rather than a fixed canvas, so the large snake poses remain intact.

`prepare-vfx.py` rasterizes all eight original effect SWFs using FFDec. `SwfBounds.java` provides exact filtered bounds so every layer retains its original origin. Shared crops and deduplicated frames reduce atlas size. The three standard effects are variants, and coffin symbols are selected separately for Mu, guests and revival. Character animations wait for effects to finish; damage remains a single report hit. Both portraits, the bag preview, large image and decoded showcase are used by the UI.

Rebuild from the repository root:

```powershell
.tools/python/python.exe sunucu-kok/cikarim/kabuto-gnw/prepare-assets.py
.tools/python/python.exe sunucu-kok/cikarim/kabuto-gnw/prepare-vfx.py --ffdec .tools/ffdec/ffdec.jar
.tools/python/python.exe sunucu-kok/cikarim/kabuto-gnw/build.py --apply
.tools/python/python.exe sunucu-kok/cikarim/kabuto-gnw/build-client.py --ffdec .tools/ffdec/ffdec.jar --install
.tools/python/python.exe sunucu-kok/cikarim/kabuto-gnw/verify-assets.py
node/node.exe --test sunucu-kok/sunucu/tests/kabuto-combat.test.js
```

Previews are in `validation/extracted/`. Build the Flash component probe with `build-raster-probe.py --revival-check`, then run `runtime-raster.js` with `KABUTO_REVIVAL_PROBE=1`, followed by `verify-vfx.py`. Evidence is written to `validation/extracted/revival/` and `validation/extracted/verified.json`. This verifies renderer/components rather than a complete interactive battle. Restart the game to load the new client; saves and formations are preserved.

## Sửa tư thế trong màn hình nhân vật

Slot model `0E` đã bị gán nhầm `kabuto-die` (và hit cho Mu), khiến màn hình nhân vật hiển thị tư thế nằm. Đổi `0E` về idle đứng có loop cho cả năm model, khớp với slot showcase của Jiraiya. Kiểm tra native thêm ràng buộc `0E == 0A == idle`; 1.264 frame trong hai bộ resource đã được giải mã/đối chiếu. Animation chết trong trận vẫn dùng atlas PNG riêng của client 2026101812, nên Kabuto vẫn ngã/nằm khi chết trong trận và đứng trong giao diện nhân vật. Đây là thay đổi tài nguyên, không cần vá SWF hay thay đổi cooldown. Đóng/mở lại game để xóa cache model trong phiên.

## Giữ hình khi chết — client 2026101812

Nhánh `ActivePlay(TYPE_ACTIVE_DIE)` gốc làm mờ role về alpha 0 trong một giây; các bản trước chỉ khôi phục hình sau hồi sinh nên Kabuto vẫn biến mất trong lúc chết. Kabuto nay chạy riêng `PlayKabutoDeath`: hủy tween cũ, phát 7 frame ngã 25 FPS từ atlas `death.png`, rồi giữ nguyên frame nằm cuối với alpha 1. Thanh HP/bóng được ẩn, hình nhân vật được giữ tới hồi sinh/reset trận. Handler tách khỏi `UpdateActive` vì renderer gốc dừng update role đã chết. Hủy handler khi hồi sinh hoặc role rời stage, và callback hoàn thành chỉ chạy một lần. Mu/khách Edo giữ cách biến mất riêng như trước; không thay đổi HP hoặc cooldown hồi sinh.

Probe native gọi đúng helper chết, chờ 1,1 giây, kiểm tra bitmap vẫn là frame nằm cuối và vẫn hiện, rồi hồi sinh/ra chiêu. Gồm 12 lần chết giữ hình, 12 lần khôi phục ngay và 12 lần kiểm tra ổn định sau hồi sinh, cả hai phe. Ảnh bằng chứng: `validation/revival-visual/DEATH-camp-0-slot-0.jpg` và `DEATH-camp-1-slot-6.jpg`. Atlas chết thêm vào preload/cache chung; dựng lại bằng `prepare-vfx.py` rồi `build-client.py --install`. Đóng/mở lại game để nạp bản 2026101812.

## Rà soát animation — client 2026101811

Sửa fade VFX theo thời lượng clip để các chớp ngắn vẫn đạt độ sáng đầy đủ. Report triệu hồi chứa vị trí thật của Mu/khách Edo bằng bản ghi CMD_NONE, không làm thay đổi HP/sát thương; client đặt quan tài/khói tại vị trí đó thay vì cạnh caster. Bỏ quan tài vẽ sẵn trong pose Mu để không hiện hai quan tài ở hai nơi. Rút animation gọi khách Mu về 440 ms (return 400 ms), khớp với clip quan tài/khói 400 ms, tránh khoảng trống trước khi khách hiện hình. Đặt tên và dọn nhãn Kabuto khi reset trận cùng các lớp VFX. Các bản sửa hồi sinh, nhịp 25 FPS và cooldown tiếp tục được giữ.

Kiểm tra native asset: 299 frame nguồn, 21 clip, 1.164 frame đã giải mã ở hai bộ resource, đủ 5 model; đối chiếu pixel/alpha/pivot/timing/mốc hit. Test engine kiểm tra tọa độ role trong cả hai loại report triệu hồi. Probe Flash lifecycle tiếp tục kiểm tra sáu kỹ năng ở hai phe, 12 lượt khôi phục tức thì và 12 lượt kiểm tra sau 1,2 giây; thêm hai vị trí triệu hồi khác vị trí caster. Log có `VFX_ASSET summon ... at=550,440` và `at=700,440`. Đây là các kiểm tra renderer/component và engine riêng, chưa phải cam kết không còn mọi lỗi có thể xảy ra trong trận thực.

Khởi động lại backend và game để áp dụng đồng thời report triệu hồi mới, model và SWF.

## Sửa sprite sau hồi sinh — client 2026101810

Client cập nhật HP trước khi khôi phục hình, nhận diện cả trạng thái HP 0 chưa kịp đặt `FIsDie`. `RestoreKabutoAfterRevival` hủy tween chết, xóa `FWaitDie`, callback chết, cờ chờ command và các cờ khóa hình còn sót; khôi phục alpha/visible của role và bitmap, thanh HP/bóng, đặt lại vị trí và animation idle. Gán ngay surface/pivot frame idle đầu để không phải chờ tick sau mới có hình. ID kỹ năng và trạng thái ra chiêu cũ cũng được reset. Áp dụng riêng Kabuto/Mu/khách Edo khi HP chuyển từ chết sang sống; không thay đổi luật hoặc cooldown hồi sinh 4 round.

Kiểm tra Flash component dùng đúng `ChangeHP` và helper khôi phục của production với sprite native đã tải: cố tình làm mất bitmap, ẩn role/bitmap, đặt cờ chờ chết, khóa hình và tween chết; hồi 25% HP rồi tiếp tục sáu kỹ năng ở hai phe. Kiểm tra ngay và sau 1,2 giây để bắt tween chết ghi đè hình. Đây là kiểm tra lifecycle đồ họa tách biệt, không phải phát lại combat hoàn chỉnh. Bằng chứng nằm ở `validation/revival-visual/runtime.log`, `result.json` và các ảnh chụp. Dựng probe bằng `build-raster-probe.py --revival-check --ffdec PATH`; chạy `runtime-raster.js` với biến môi trường `KABUTO_REVIVAL_PROBE=1` và bỏ `ELECTRON_RUN_AS_NODE` cho tiến trình Electron.

Đóng/mở lại game để lấy SWF mới.

## Cooldown hồi sinh

Power of the White Snake có cooldown **4 round tính từ lúc hồi sinh**. Ví dụ hồi sinh round 2 thì sớm nhất được kích hoạt lại khi chết ở round 6 (hồi sinh đầu round 7). Chết trong round 2–5 sẽ không hồi sinh cho lần chết đó, kể cả Mu còn sống và trận kéo dài qua round 6; không giữ trận ở trạng thái chờ hồi sinh không hợp lệ. Lần hồi sinh đầu vẫn diễn ra đầu round sau khi chết, hồi 25% HP. Deidara vẫn khóa hồi sinh hoàn toàn. Thay đổi nằm ở server và mô tả kỹ năng, không cần dựng lại SWF; khởi động lại backend và game để nạp luật/mô tả mới.

## Tăng tốc và chống spam — client 2026101808

Giữ 25 FPS / 40 ms native, giảm khoảng một nửa số frame và thời lượng của các động tác không lặp cùng timeline VFX. Mystery 3.240 → **1.640 ms**; Standard 840 → **440 ms**; Chase 1.240 → **640 ms**; hồi máu 520 → **280 ms**. Idle/run không đổi. Đồng bộ mốc hit, return, cut-in và độ trễ rắn/độc (60/420 ms); VFX Mystery kết thúc trong 1.100 ms sau hit, trước return. Tổng mới: **307 frame nguồn / 21 clip / 1.184 frame native**.

Cooldown theo round: Mystery **3** và dùng primary action; Standard/Chase/hồi máu Kabuto **2**; hồi máu tối đa một lần trong round đủ điều kiện; từng loại khách Edo **3** riêng biệt; kết giới Mu **3**. Dùng ở round N với cooldown 3 thì sớm nhất dùng lại ở N+3. Hồi sinh không reset Mystery, Standard, Chase hay hồi máu; gọi lại Mu không reset cooldown khách/kết giới. Khi chưa đủ cooldown, không tạo thêm animation hồi máu/triệu hồi.

Mô tả kỹ năng trong JSON/bin các ngôn ngữ đã cập nhật cùng luật server. Test kiểm tra khoảng cách round trong battle report thực, Mystery không đi kèm Standard, giới hạn heal và chống bypass cooldown qua chết/triệu hồi. Hồi quy Kabuto/Naruto/Jiraiya và giải mã asset đạt; dùng các lệnh kiểm tra ở mục dưới để dựng lại. Các số liệu v3/v2 tiếp theo là lịch sử trước khi tăng tốc.

Khởi động lại backend và đóng/mở lại game để áp dụng cả cooldown lẫn animation.

## Hiệu ứng skill theo video — client 2026101807

Đã dùng built-in `image_gen` dựng **5 sheet PNG trong suốt / 39 ô hình / 9 clip hiệu ứng**, tách riêng khỏi sprite nhân vật. Nguồn và prompt chính xác lưu trong `asset/Browser Games - Naruto Online - Recruitable Characters - Kabuto (Great Ninja War)/vfx-v3/`. Các khung tham chiếu được lấy trực tiếp từ video đã lưu: đòn chakra xanh khoảng 0:29–0:30, cận mặt Kabuto 1:31, cụm rắn trắng và đất vỡ 1:32.5, năng lượng tím 1:33.5. Đây là asset gen theo hình tham chiếu, không phải bản trích xuất nguyên gốc.

Mystery: cut-in mắt vàng/lưỡi rắn → chớp vàng trắng → cụm rắn trắng dưới đội địch → cột/sóng tím → tan khói. Cụm rắn xuất hiện một lần theo vùng mục tiêu, nằm sau nhân vật và không bị việc sắp xếp độ sâu đẩy lên che đội hình. Vùng tím có mép alpha mềm. Đòn thường có chớp chakra xanh; Chase có bạch xà/hồng châu và lóe trắng; hồi máu có aura xanh; triệu hồi có quan tài và khói trắng. Các hiệu ứng phụ của khách Edo tiếp tục dùng phần renderer có sẵn.

`raster-vfx.as.txt` nạp trước sheet PNG, cache các ô, phát theo tick **40 ms / 25 FPS** như Jiraiya và dọn listener/layer khi kết thúc hoặc reset trận. `vfx.json` chứa atlas/timeline/pivot. Bỏ cụm rắn lớn đã vẽ trong pose caster để tránh xuất hiện rắn ở cả hai bên; giữ tư thế phóng chiêu đến hết chuỗi hiệu ứng 2.160 ms sau mốc hit. Mystery vẫn chỉ áp dụng tổng 100% HP report tại một mốc hit. Tổng animation nhân vật hiện là **515 frame nguồn, 21 clip, 1.726 frame native đã giải mã kiểm tra**.

Kiểm tra Flash component tách biệt tài khoản/backend: sáu kỹ năng ở cả hai phe, 12 trường hợp, 5 atlas tải thành công, 20 lần phát asset, không lỗi và không còn layer khi kết thúc. Đây là kiểm tra renderer bằng Flash 22, không phải phát lại một trận combat hoàn chỉnh. Bằng chứng: `validation/vfx-v3/native/result.json`, `runtime.log`, `validation/vfx-v3/verified.json`, `native-overview.jpg`. Test combat Kabuto và Jiraiya đều đạt.

```powershell
python sunucu-kok/cikarim/kabuto-gnw/prepare-assets.py
python sunucu-kok/cikarim/kabuto-gnw/prepare-vfx.py
python sunucu-kok/cikarim/kabuto-gnw/build.py --apply
python sunucu-kok/cikarim/kabuto-gnw/build-client.py --ffdec "E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar" --install
python sunucu-kok/cikarim/kabuto-gnw/verify-assets.py
python sunucu-kok/cikarim/kabuto-gnw/build-raster-probe.py --ffdec "E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar"
Remove-Item Env:ELECTRON_RUN_AS_NODE -ErrorAction SilentlyContinue
Start-Process -FilePath (Resolve-Path 'oyun/electron.exe') -ArgumentList 'sunucu-kok/cikarim/kabuto-gnw/runtime-raster.js' -WindowStyle Hidden -Wait
python sunucu-kok/cikarim/kabuto-gnw/verify-vfx.py
python sunucu-kok/cikarim/kabuto-gnw/make-vfx-preview.py
```

Đóng/mở lại game để lấy client mới. Các mục v1/v2 bên dưới được giữ làm lịch sử.

## Dựng lại asset v2 — 18/10/2026

Bốn atlas đã được thay mới bằng built-in `image_gen`: Kabuto movement/combat, Mu và Edo summons. Prompt set: `asset/Browser Games - Naruto Online - Recruitable Characters - Kabuto (Great Ninja War)/generation-prompts-v2.md`. Đây là art dựng lại theo video, không phải asset gốc trích xuất và không bảo đảm trùng từng pixel với Naruto Online.

Pipeline v2 có **480 frame, 21 clip, 25 FPS / 40 ms**, lấy FPS trực tiếp từ cấu hình Jiraiya. `motion.py` cache optical flow và loại vùng nội suy không khớp để giảm bóng kép. Giữ thành phần rời như chim đất sét, linh thể và cầu lửa. Sửa chuỗi chết sang nằm đất; hồi sinh bắt đầu từ đúng tư thế nằm; thêm các tư thế chuẩn bị và thu chiêu. Mốc hit được dựng lại cùng animation và chỉ phát tổng 100% sát thương.

Client v2 **2026101804** thêm quan tài trồi/khói triệu hồi, hai nhịp rắn trắng → độc tím, hồng châu/tia trắng cho Chase. Bản đóng gói đã kiểm tra từng pixel RGBA, pivot, thời gian và mốc hit trên **1.646 frame native** trong hai bộ tài nguyên. Test combat Kabuto và Jiraiya đạt. Kết quả v2 lưu tại `validation/rebuild-v2.json`; các log/GIF trận native và thống kê 513/1700 frame bên dưới thuộc bản v1, chưa phải bằng chứng phát trận của v2.

Đóng rồi mở lại game sau khi cài để tải client/resource mới.

Hero **11120910**, profession **3 (Support)**, quality **7 (SSS)**. Mu **11120911**, Deidara **11120912**, Dan Kato **11120913**, Pakura **11120914** chỉ dành cho triệu hồi, không nằm trong danh sách chiêu mộ hoặc đội bot Arena. Kabuto có Modify Fragment **14130910**, Mystic offer **41120910**, giá 100 mỗi mảnh theo giá hiện tại của các ninja custom; chỉ hiện khi đã sở hữu Kabuto. Không thay đổi save/đội hình người chơi.

## Đối chiếu video

Nguồn người dùng cung cấp: [Naruto Online — Kabuto Great Ninja War vs 3 Orochimaru, 5:02](https://www.youtube.com/watch?v=umIZbHpNYhQ). Đã tải bản video 720p để kiểm tra hình ảnh; các contact sheet nằm trong `reference/`. Đây là trận có cả Orochimaru bên đối phương, vì vậy không coi mọi hiệu ứng quan tài trong video là kỹ năng của Kabuto.

| Đoạn đã kiểm tra | Đặc điểm chuyển động | Áp dụng |
| --- | --- | --- |
| 0:03–0:06 | Đội hình, Kabuto da trắng/quần tím/rắn trắng trên vai, Mu ở phía sau; khói triệu hồi | Tạo riêng sprite Kabuto/Mu và trạng thái chờ triệu hồi |
| Khoảng 0:29–0:31 | Kabuto áp sát đội địch, ánh chakra xanh tại tay/điểm chém | Standard có `runPoint`, đòn tay cận chiến dù role Support |
| Khoảng 1:28–1:29 | Nhịp hồi phục màu xanh giữa hành động | Animation Self Healing riêng trước hành động |
| 1:30–1:31.5 | Kabuto lấy thế, đầu rắn vươn lên; cut-in khuôn mặt | Mystery có phần vận chiêu, giữ chân tại vị trí ban đầu |
| 1:32–1:33 | Rắn trắng lớn trồi tại vị trí đối phương | Burst rắn trắng tại các mục tiêu trúng đòn |
| 1:33.5–1:35 | Luồng năng lượng tím lan trên đội địch, số hit tăng | Sóng độc tím, tách mốc hình ảnh và logic 4 Combo |
| Toàn trận | Các đòn và triệu hồi nối tiếp; nhiều hiệu ứng thuộc đội Orochimaru | Không sao chép kỹ năng của đối phương vào Kabuto |

Sprite là bộ art mới do `imagegen` tạo theo hình ảnh/animation tham chiếu, không phải atlas trích xuất chính thức từ video. Icon dùng đúng ảnh gốc **68×69** người dùng gửi, được lấy từ bitmap đã sao chép, kiểm tra trực quan và giữ tại `gorsel/kabuto-icon-input.png` cùng `portrait.png` trong thư mục asset; bản dựng lại chỉ là preview và không được dùng trong game. Xem prompt set tại thư mục asset.

## Logic kỹ năng

`sunucu/kabuto-gnw.json` chứa thông số và ID; `kabuto-combat.js` chứa vòng đời/hiệu ứng; `savas.js`, `naruto-combat.js`, `hero-skills.js` và `reincarnation.js` tích hợp vào combat chung.

| Kỹ năng | Quy tắc |
| --- | --- |
| White Snake Assault — 13120931 | Prompt, 40 chakra, cooldown 2, battlefield cooldown 1. Đánh tối đa 9, 4 Combo, Level 2 Poison; Knockdown và Interruption mục tiêu chọn. Nếu mục tiêu đã có Poison/Strong Poison trước đòn: không thể né và thêm Level 2 Strong Poison. Prompt vẫn cho phép đánh thường trong cùng round. |
| Bracken Dance — 13120932 | Chọn địch ngẫu nhiên, chạy vào cận chiến, giảm Defense 12% cộng dồn. Nhánh có xác suất đánh cả hàng của mục tiêu mới tạo 6 Combo, Suppress Super Armor tới hết round và Low Float một mục tiêu trúng đòn ngẫu nhiên. Đòn đơn không tự tạo Float. Edo Tensei trúng đòn ở cả hai nhánh chịu Curse Binding tới hết round sau. |
| White Extreme Attack — 13120933 | Chase Low **hoặc** High Float, tạo Repulse, không né; đánh cả hàng mục tiêu. Suppress Immunity tới hết round và Level 2 Blindness trong round này. Chase một lần/round, nhận thêm lượt theo cơ chế tăng giới hạn Chase hiện có. |
| Self Healing — 13120934 | Trước hành động thực sự, hồi 12% max HP và 40 chakra chung, đưa chakra limit về 100. Tối đa 2 lần/round, kể cả Mystery/Standard/Chase. Hồi trước khi trừ chi phí Mystery. |
| Impure World Reincarnation — 13120936 | Đầu trận gọi Mu có 100% max HP Kabuto. Mu không biến mất khi Kabuto chết. Mu đánh thường gọi Deidara tối đa một lần/round; đầu round chẵn gọi Dan, round lẻ gọi Pakura. |
| Power of the White Snake — 13120935 | Kabuto miễn nhiễm debuff khi không bị Suppress Immunity. Chết thì round tiếp theo hồi 25% max HP, gọi lại Mu, reset Mystery cooldown về 0. Nếu bị Deidara kết liễu thì không hồi sinh. |
| Mu — 13120937/38/42 | Kết giới Light-Weighted Rock tồn tại round kích hoạt và round sau; cả hai phe chỉ Kabuto/Edo Tensei được Standard. Phe sở hữu dùng chung 2 lần thoát sát thương chí tử mỗi round kết giới còn hiệu lực, mỗi lần về 50% max HP. Không bị giải bằng cleanse; kết giới mới thay thế kết giới cũ. |
| Dan — 13120940 | Gây sát thương đơn vị trước mặt, Suppress Immunity trong 3 round và hút toàn bộ chakra địch vào pool phe mình, giới hạn 100. Sau đó biến mất. |
| Deidara — 13120939 | Đánh tối đa 12, Suppress Super Armor tới hết round, Knockdown đơn vị trước mặt. Đơn vị chết vì đòn này không được hồi sinh. Sau đó biến mất. |
| Pakura — 13120941 | Đánh/đốt tối đa 9. +80% sát thương nếu mục tiêu vẫn có Super Armor có hiệu lực. Sau đó biến mất. |

Suppress Immunity của Kabuto chỉ vô hiệu hóa miễn nhiễm debuff, **không** xóa Invincibility. Suppress Super Armor cho phép Low/High Float, Repulse, Knockdown trong thời hạn. Level 2 Blindness chặn Standard; Curse Binding chặn Mystery, Chase và Standard đa mục tiêu, còn Standard đơn mục tiêu chọn bất kỳ đơn vị nào ngoài bản thân. Interruption hủy lượt Mystery đang chờ trong round, kể cả các nhân vật Bleach dùng rage.

Ảnh không ghi hệ số sát thương, xác suất Standard diện rộng và thời hạn/sát thương Poison/Ignition. Bản port khai báo riêng: xác suất 35%, DOT 3 round, hệ số Poison 0.25, Strong Poison 0.4, Ignition 0.3 theo Ninjutsu của nguồn; các hệ số đòn có trong JSON. Đây là tham số cục bộ để kỹ năng chạy được, không khẳng định là công thức bí mật của Oasis/Tencent. Cách áp dụng hai lần cứu tử của Mu được hiểu là ngân sách chung của phe mỗi round kết giới còn hiệu lực, tránh nhân số lần theo số ninja.

## Asset và client

Nguồn: `asset/Browser Games - Naruto Online - Recruitable Characters - Kabuto (Great Ninja War)/`. Bốn atlas RGBA gốc được giữ nguyên. Pipeline tìm rãnh alpha cả hàng/cột, loại mảnh rời của ô bên cạnh, dùng một tỷ lệ chung theo từng atlas, căn đế chân và nội suy optical flow hai chiều. Có **513 frame ảnh**, **21 clip**, phát ở **25 FPS (40 ms/frame)**; kiểm tra **1700 frame native** do các sequence dùng chung idle trong hai bộ tài nguyên. Không đặt thời lượng dưới tick native để tránh mất sự kiện hit.

Kabuto model 0C: Mystery=0, Chase=1, Heal=2, Revival=3, Summon Mu=4. Mu model 0C: Summon=0, Barrier=1. Deidara/Dan/Pakura có model, idle và attack riêng. Standard Kabuto/Mu có `runPoint`; Dan/Pakura không di chuyển vào cận chiến. Mỗi kỹ năng chỉ áp dụng tổng 100% HP report tại mốc hit, không nhân sát thương bởi số frame.

Client **2026101803** giữ các bản vá Partner/Naruto/Jiraiya. `TBattleStage.SetBattle` tạo cả các role mới bắt đầu với 0 HP, giữ ẩn đến khi nhận hồi HP. Điều này cần thiết vì client gốc dừng dựng danh sách command khi gặp role chưa được tạo. `PrepareDormantKabuto` không thay đổi HP. `ChangeHP` khôi phục các model khi được triệu hồi/hồi sinh; marker Despawn ẩn khách sau chiêu. Các trạng thái riêng có float text và nhãn kết giới. Reset trận dọn nhãn còn lại. VFX native thêm rắn trồi, chakra xanh, sóng độc/tia trắng, linh thể, lửa và rung nhẹ khi va chạm.

`PassiveSkillPlay` chuyển riêng CMD_FLOAT tới `AddTextEffectByCMD`, để marker chakra/despawn trong nhánh nội tại không bị diễn giải thành một dòng hồi “+0”. Các dòng HP vẫn đi qua xử lý hồi/mất HP gốc; các mốc sát thương của animation không thay đổi.

## Dựng và kiểm tra

```powershell
python -m pip install -r sunucu-kok/cikarim/jiraiya-toads/requirements.txt
python sunucu-kok/cikarim/kabuto-gnw/prepare-assets.py
python sunucu-kok/cikarim/kabuto-gnw/build.py --apply
python sunucu-kok/cikarim/ninja-fragments/build.py --apply
python sunucu-kok/cikarim/kabuto-gnw/build-client.py --ffdec "E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar" --install
python sunucu-kok/cikarim/kabuto-gnw/verify-assets.py
.\node\node.exe sunucu-kok/sunucu/tests/kabuto-combat.test.js
```

Đóng/mở lại client và khởi động lại backend sau khi cài. Quy tắc combat chạy server-side; chỉ cập nhật SWF sẽ không đủ.

Đã kiểm tra: toàn bộ 1700 frame đã đóng gói được giải mã và đối chiếu từng pixel/alpha/pivot/thời gian; các test Kabuto, Naruto, Jiraiya, hero skills, hero talents, reincarnation và ba Modify Fragments đều đạt. Test Kabuto bao gồm cả trận engine thực có hồi sinh 25% và trận bị Deidara khóa hồi sinh. Mu/khách được làm sạch trạng thái cũ mỗi lần tái triệu hồi, gồm cả Freeze/Curse/Reflect/shield.

Đã phát fixture renderer ở cả hai phe qua Electron/Flash đến kết thúc, đủ 12 kỹ năng, 4 role chờ 0 HP, 5 nhân vật được kích hoạt/hồi sinh, và 3 loại khách biến mất sau chiêu; camera trả về `(0,0)`, không có lỗi Flash. Trận do engine tự tạo cũng phát đến WINS. Bằng chứng: `validation/native-final.log`, `native-final.png`, `native-engine.log`, `native-engine-final.png`, `engine-report.json`, `validation.json`. `native-renderer.mp4` ghi các mẫu từ trận thử; GIF từng kỹ năng là bản xem đầy đủ 25 FPS. Toàn bộ hook ghi log chỉ có trong SWF probe và không được cài vào client production.
