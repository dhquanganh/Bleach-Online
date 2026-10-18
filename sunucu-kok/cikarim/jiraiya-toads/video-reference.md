# Jiraiya — đối chiếu video và bản dựng 2026101712

Tham chiếu: https://www.youtube.com/watch?v=BzjBof3qT4A — Naruto Online, Eggboy | NARUTO GAMES.

Đã tải bản 720p để xem từng frame, không chỉ dựa trên thumbnail. Các mốc tham khảo:

- Khoảng 12–13 giây: Jiraiya hạ người; mép miệng cóc che trên/dưới, lóe sáng rồi chuyển chiến trường sang thực quản đỏ. Nền duy trì trong thời gian kết giới.
- Khoảng 14–15 giây: luồng sáng vàng/cam hướng sang đội đối phương. Dùng tông vàng cho Chant, thay cho các vòng tím của bản trước.
- Khoảng 182–184 giây: Rasengan xanh lớn được nâng cao; va chạm tạo cầu sáng, cột lóe dọc, vành xung kích và mảnh văng trên mặt đất.
- Cảnh lớn tại khoảng 176 giây là cổng triệu hồi của nhân vật khác, không phải hai cóc tiên nhân. Không thêm cảnh đó vào Jiraiya.

## Triển khai

`skill-vfx.as.txt` là nguồn hiệu ứng Flash Graphics. Phần vận chiêu bám theo frame hiện tại tới hit marker thay vì biến mất sau một timer ngắn; phần va chạm vẫn tự dọn trong 560–1050 ms. Chant có luồng sóng vàng hướng theo phe. Rasengan có gradient cầu sáng, xoáy trắng, vành shockwave, lóe dọc và mảnh văng; bitmap nhân vật nhấc lên rồi hạ xuống quanh hit marker, không di chuyển tọa độ combat.

`assets/toad-esophagus-source.png` được tạo bằng image_gen built-in dựa trên khung hình nền trong video. Prompt đầy đủ: `assets/prompt.txt`; metadata: `assets/generation.json`. `assets/toad-esophagus-v1.jpg` là bản runtime 1250×650, cài tại `/public/jiraiya-vfx/toad-esophagus-v1.jpg`. Đây là tranh dựng lại, không phải asset gốc trích xuất từ Naruto Online.

Backdrop nằm sau lớp actor, không tham gia sắp xếp chiều sâu của các role. Marker 19000301 bật nền; marker 19000309 tắt nền; TBattleStage.Reset xóa nền khi thoát/chuyển trận. Loader xử lý lỗi tải và dọn listener khi bị tháo. Chiêu Barrier có hai mép miệng khép/mở và lóe sáng ngắn. Không đổi sát thương, mục tiêu, hit marker, thời gian animation hoặc âm thanh.

## Xác nhận

`build-client.py --install` biên dịch rồi decompile đối chiếu các patch, giữ nguyên toàn bộ SWF tags ngoài bytecode và cập nhật manifest 2026101712. Test Jiraiya combat PASS.

`build-vfx-probe.py` / `runtime-vfx.js` dựng bản xem thử thành phần bằng Flash 22 với các method hiệu ứng dùng chung và TexClient đang cài. Đây là kiểm tra thành phần đồ họa, không phải replay combat đầy đủ. Kết quả chạy và ảnh được ghi riêng trong `validation/video-reference/`.

Lượt kiểm tra thành phần cuối đã hoàn tất: sáu kỹ năng ở cả hai phe, 12 lượt vận chiêu và 12 va chạm; camera trả về (0,0) 24 lần; nền tải 2 lần và được xóa ở cuối; không có lỗi runtime hoặc 404. Ảnh JPG được lấy trực tiếp bằng BitmapData.draw trong Flash; các PNG và log có tiền tố initial là các lần thử trình chụp trước đó. `runtime-result.json` và `build-result.json` ghi kết quả cuối. Chưa chạy lại replay combat đầy đủ với HUD sau thay đổi này.
