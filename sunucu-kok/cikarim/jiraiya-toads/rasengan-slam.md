# Aerial Rasengan — Jiraiya, client 2026101713

Thay riêng asset Giant Gallant Rasengan theo yêu cầu: lấy đà → bật lên → nâng cầu chakra trên đầu → chúi người lao tới → hạ tay xuống mục tiêu → tiếp đất → về idle.

- Nguồn tư thế: `assets/rasengan-slam/keyposes.png`, tạo bằng image_gen built-in từ `portrait.png`. Prompt đầy đủ tại `assets/rasengan-slam/prompt.txt`.
- Bảy tư thế được cắt theo vùng có alpha, giữ thành phần nhân vật, thu cùng tỷ lệ 0,40 và căn neo. Không có cầu chakra vẽ sẵn trong sprite để tránh lệch/nhân đôi với hiệu ứng native.
- 49 frame ở 40 ms/frame, nội suy optical flow trên RGBA premultiplied; mốc hit vẫn 30, return 48. Hai đầu animation dùng lại đúng idle đang cài.
- `motion.json` ghi tọa độ bàn tay cho từng frame. `JiraiyaRasenganPose()` dùng cùng dữ liệu cho bitmap và quả cầu: nâng lên, giữ ở đỉnh, lao tới vị trí mục tiêu rồi trở lại vị trí gốc. Chỉ dịch hình render, không thay đổi tọa độ combat, cooldown, sát thương hay callback.
- Giới hạn độ cao theo hàng đứng để quả cầu không văng khỏi chiến trường. Lật hướng bằng phép đổi tọa độ của actor; không giả định người chơi nằm bên trái.

`build-rasengan-slam.py --apply` chỉ đóng gói lại Model/A9B1070B.TexClient trong hai bộ 2017112917 và 2026090619. Script giải mã lại 98 frame, kiểm tra byte RGBA, pivot và timing. Các texture khác không được ghi. `prepare-assets.py` tự áp dụng lại bộ tư thế mới sau khi chuẩn bị atlas gốc, nên rebuild đầy đủ không trả về tư thế đẩy ngang cũ.

Client dựng bằng `build-client.py --ffdec PATH/ffdec.jar --install`, thay phần nhấc bitmap cũ bằng đường chuyển động/palm tracking mới và cập nhật manifest 2026101713. Các SWF tags ngoài bytecode vẫn được đối chiếu giữ nguyên.

Kiểm tra đã hoàn tất: native Flash 22 component probe ở hai phe, đủ 12 lượt cast/impact, 24 lần trả camera về (0,0), 5 tư thế lấy đà/đỉnh nhảy/lao xuống/va chạm/hồi phục ở mỗi phe; không lỗi runtime. Kết quả và ảnh nằm trong `validation/rasengan-slam/`. Đây là kiểm tra thành phần hiệu ứng với sprite native; chưa chạy lại replay đầy đủ có HUD.

Test `ninja-cooldowns.test.js` và `jiraiya-combat.test.js` PASS. Bộ luật cooldown vừa sửa vẫn được giữ nguyên.

Điều chỉnh tốc độ nhẹ ngày 18/10/2026: riêng Rasengan giảm từ 40 xuống 36 ms/frame, tổng 1960 → 1764 ms (ngắn hơn 10%). Vẫn đủ 49 frame, hit 30 và return 48; hiệu ứng bám frame nên giữ đồng bộ bàn tay/va chạm. Đã đọc lại và xác nhận timing/pixel/pivot của 98 frame native ở hai bộ tài nguyên.
