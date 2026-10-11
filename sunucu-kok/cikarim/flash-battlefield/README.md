# Chiến trường Hải tặc — bản đối chiếu video

Thay gameplay và màn hình tab **Chiến trường** trong Daily Activities theo [video tham chiếu](https://www.youtube.com/watch?v=CUBUbuLkdFA). Mặc định giữ **một nhân vật của bạn + 19 bot**, chia 10 đấu 10; không cần tài khoản đối thủ. Phân biệt điều quan sát được và công thức dựng lại trong [video-reference.md](video-reference.md).

## Luồng chơi

1. Đăng ký từ cấp 40, mở cả ngày. Chuẩn bị 90 giây, server cân cả nhân vật và bot theo chiến lực. Bot có tên và nhãn BOT, dùng đội hình thật từ kho bot hiện có.
2. Mỗi phe có **500 tài nguyên**, tổng **1.000**. Trận gồm **hai hiệp 15 phút**, nghỉ 30 giây. Hiệp 2 đổi vai Công/Thủ và vị trí căn cứ; tài nguyên và điểm cá nhân đi theo đội, không khởi tạo lại.
3. Bấm đất để đi, bấm đối thủ hoặc Tấn công để khiêu chiến đội hình. Server dùng `savas.kadroRapor` xác định thắng/thua và tạo chiến báo native v4. Người thắng lấy 1 tài nguyên từ phe thua; tổng hai bên vẫn 1.000.
4. Checkbox **Tự động tham chiến** giao di chuyển và khiêu chiến cho server; các trận tự động diễn ra trên bản đồ, không liên tục ép mở cửa sổ xem trận. Đối thủ có thể chủ động thách đấu nhân vật. Các chiến báo có nút **Xem** để mở trận native, rồi trở lại chiến trường. Xem lại không cộng điểm hoặc nhận thưởng lại.
5. Sau khi đấu, đóng băng tham chiến 25 giây. Người thua biến mất và hồi sinh sau 15 giây tại căn cứ, được bảo vệ 5 giây; hồi sinh không bỏ qua đóng băng. Native viewer vẫn gửi heartbeat để nhân vật không bị coi là mất kết nối khi xem trận.
6. Ba vòng cam ở căn cứ phe mình là vị trí xuất phát/hồi sinh. Bản video không thực hiện chiếm vòng, lính canh hay boss NPC. Các cơ chế đó tắt mặc định, giữ tùy chọn engine cũ để thử nghiệm riêng.
7. Chiến lược có ba lượt mỗi hiệp, hồi sử dụng 30 giây; mỗi lượt +2% công/thủ và +10 tích điểm. Bot cũng sử dụng chiến lược. Buff áp dụng sau cân bằng thống kê nền để không bị vô hiệu hóa bởi việc scale HP phe đối diện.
8. Mặc định thắng đấu +5 tích điểm và +1 Vinh Danh. Kết thúc trận: phe nhiều tài nguyên hơn thắng, bằng nhau hòa; một phe cạn tài nguyên thì thua sớm. Thưởng trận: tham gia 50 Vinh Danh / 10 hoạt động, phe thắng thêm 50, Top 10 thêm `[100,80,60,40,30,20,15,10,10,10]`. Người đứng đầu phe thắng nhận danh hiệu Vua Chiến trường. Bot có xếp hạng nhưng không có tài khoản hoặc ví thưởng.

**Các con số ngoài timer và tổng tài nguyên là cấu hình dựng lại:** video không hiển thị đầy đủ bảng luật, tooltip chiến lược và công thức thưởng. Không khẳng định +5/+10, 25 giây hay +2% là số liệu gốc 568 đã xác minh. Điều kiện cấp và thưởng kế thừa đặc tả trước đó.

## UI

Nền cảng được dựng lại từ khung hình video; HUD đỏ/xanh, thanh tài nguyên và timer góc trái; Vinh dự / Thắng liên tiếp / Chiếm tài nguyên / Đóng băng; nút Chiến lược và Tấn công; checkbox tự động; chiến báo góc phải có Xem; bảng Top 10 và điểm cá nhân bên phải; ba vòng căn cứ; các nút Trận hình / Đồng đội / Quay lại bên dưới. Quay lại đóng màn hình về thành; bảng Trận hình/Đồng đội đọc đội hình đang sử dụng. Đổi đội hình qua chức năng Formation của game hiện có.

Nhân vật dùng **sprite native đầy đủ có hoạt ảnh** thay cho hình đầu và thân hình vẽ đơn giản. Actor được nội suy vị trí giữa các snapshot một giây. Trận đội hình dùng renderer, hiệu ứng, kết quả và điều khiển xem trận native của client. Asset nhân vật/battle vẫn thuộc Bleach trong project, không phải bộ One Piece được trích xuất từ video.

Shop Vinh Danh vẫn có bạc Lv10, EXP, đá chuyển sinh và Nguyên thạch, mở từ màn hình kết quả. Catalog và giá ở `battlefield-shop.json`; đổi quà lưu số dư và inventory cùng một save, gửi cập nhật túi trước trả lời shop.

## Backend, protocol và lưu trữ

| Thành phần | File |
| --- | --- |
| Clock, matching, di chuyển, đóng băng, điểm, AI, xếp hạng | `sunucu/battlefield-engine.js` |
| Profile, packet, mô phỏng đội hình, chiến báo, honor/shop | `sunucu/battlefield.js` |
| Luật cấu hình | `sunucu/battlefield-config.json` |
| Đội hình và skill thực, buff chiến lược, phản đòn | `sunucu/savas.js` |
| Một arena singleton và scheduler mỗi giây | `sunucu/oyun-sunucu.js` |
| HTTP cache fallback cho map và âm thanh | `serve.mjs` |
| UI AS3 | `cikarim/flash-battlefield/methods.as.txt` |
| Route native viewer về chiến trường | `cikarim/flash-battlefield/PatchRoutes.java` |
| Nền / prompt | `gorsel/battlefield-harbor-video.png`, `asset-video-prompt.md` |

INFO / JOIN-command / FIGHT / SHOP / LEAVE giữ các opcode `0x0181ed00..04`. Snapshot INFO đồng bộ một giây; mọi client cùng hồ sơ điều khiển cùng nhân vật. Các lệnh ghi dùng token luân chuyển và sequence; client không được cung cấp kết quả thắng, chiến lực, sát thương, điểm, thời gian hoặc tọa độ tức thì. MOVE chỉ đặt đích, server tiến theo tốc độ. FIGHT trả chiến báo native; xem lại dùng FIGHT với bit cao của ID và không thay đổi sổ điểm. Chiến báo gần đây được giữ trong cache giới hạn 20 trận; restart sẽ hết hạn các replay cũ.

`battlefield-runtime.json` lưu state chung và bộ đếm honor/hoạt động đã kiếm; ghi temp + rename, mutation rollback nếu ghi thất bại. Hồ sơ lưu số dư và watermark cùng một lần save để reconnect/retry không nhận trùng thưởng. Trận realtime cũ đang chạy được chốt một lần khi chuyển sang bộ luật video, giữ điểm và sổ thưởng; trận tiếp theo dùng luật mới. Không xóa riêng file arena khi hồ sơ còn watermark.

`battlefield-audit.jsonl` log combat, nguồn điểm, kết quả và lệnh bị từ chối, rotate 8 MB. Event log có ý định trước commit; đối chiếu state durable nếu storage thất bại. Mất heartbeat trên 30 giây thì dừng nhân vật, không tiếp tục farm offline. Arena chỉ có một process owner; chế độ mặc định không cần tầng nhiều tài khoản. `botOnlyOpponents: false` dành cho engine nhiều ID khi có profile store riêng.

`combatMode: "formation"` là mặc định. Chế độ `"realtime"` cùng `guardsEnabled`, `captureEnabled`, lịch boss và các công thức điểm cũ vẫn được giữ để thử nghiệm; đây không phải preset video.

## Sửa tương thích native

Native renderer dùng `BattleType_Replay` có sẵn, không dùng mã 199 không được renderer hỗ trợ. Route trả về kiểm tra `FieldBattleActive`, nên xem chiến báo chiến trường quay đúng màn hình; các replay khác giữ đường về cũ.

Đã sửa chiến báo phản đòn: `TBattleStage` đưa hai tham chiếu actor vào animation nhưng backend từng chỉ gửi một result. Padding result thứ hai có sát thương/rage bằng 0, giữ đúng kết quả mô phỏng và tránh RangeError #1125. Sprite loader chờ texture có sequence trước khi đọc index 0. HTTP server tìm đúng map/MP3 đã có ở phiên bản cache khác, thay vì trả 404 cho URL phiên bản hiện tại; không tạo âm thanh hoặc map giả.

## Build và kiểm tra

```powershell
node sunucu-kok/sunucu/tests/battlefield.test.js
node sunucu-kok/sunucu/tests/battlefield-formation.test.js
node sunucu-kok/sunucu/tests/hero-skills.test.js
node sunucu-kok/sunucu/tests/protect-balance.test.js
python sunucu-kok/cikarim/flash-battlefield/prepare.py
python sunucu-kok/cikarim/flash-battlefield/build.py --install
python sunucu-kok/cikarim/flash-battlefield/loader.py --install
```

Full build cài UI, return route và guard sprite native; `--daily-only` chỉ dành cho rebuild UI sau khi đã cài các route/guard mới. Build giữ non-code SWF tags, kiểm tra các method không liên quan không đổi khi patch ASM, decompile xác minh và sao lưu trước khi thay client. Phải restart backend, HTTP server và game để dùng toàn bộ bản mới; config cũng đọc lại khi restart.

Native runtime kiểm tra bằng Electron/Pepper Flash trong bản portatif, với backend/hồ sơ/database sao chép tại `.battlefield-runtime-test`, không dùng tài khoản thật. Ảnh và log nằm trong `validation/`; các log debug trước sửa được giữ riêng để đối chiếu.
