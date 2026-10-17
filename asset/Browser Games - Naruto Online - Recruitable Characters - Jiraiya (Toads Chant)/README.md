# Jiraiya [Toads Chant]

Bộ asset tạo bằng imagegen tích hợp, dựa trên ảnh Jiraiya người dùng gửi, phong cách sprite Naruto có sẵn và bộ kỹ năng trong screenshot. Đây là asset mới do AI tạo, không phải sprite trích xuất từ Naruto Online. Cấu trúc `characters/<nhân vật> (Battle)` và tên `<số>_Asset_<id>.png` theo bộ Naruto. Bộ chiêu riêng của Jiraiya có 96 frame; không ánh xạ 1:1 với 166 frame Naruto.

- `atlases/`: 6 ảnh gốc RGBA, mỗi ảnh 1448×1086, lưới 4×4. Giữ nguyên ảnh và alpha do imagegen xuất.
- `characters/Jiraiya - Toads Chant (Battle)/`: 96 PNG 256×224 có nền trong suốt, thứ tự ID 0–95. Dùng một tỷ lệ thu nhỏ chung, giữ nguyên tỷ lệ hình thể.
- `animations.json`: ánh xạ frame, thời lượng, clip loop/one-shot và vùng cắt atlas. Pivot [128,222] là mốc ban đầu; cần căn chỉnh khi tích hợp renderer. Vùng cắt hàng được tìm theo khoảng trống alpha vì ảnh sinh không có hàng cách đều tuyệt đối.
- `previews/`: 9 GIF và `overview.png`. GIF lặp để xem; PNG nguồn giữ nền trong suốt.
- `prompts.json`: prompt đầy đủ, tham chiếu và SHA256 ảnh gốc. Chế độ tạo: built-in imagegen.
- `pack.py`: cắt/đóng gói lại từ atlas bằng Pillow, không vẽ lại nhân vật.

| Animation | Asset ID | Nội dung |
| --- | --- | --- |
| idle | 0–7 | Thế thủ, tóc và áo chuyển động nhẹ |
| run | 8–12 | Chạy ninja |
| hit | 13–15 | Trúng đòn, lấy lại thăng bằng |
| giant-gallant-rasengan | 16–31 | Tụ Rasengan lớn, lao tới và phát lực |
| toad-mouth-barrier | 32–47 | Kết ấn, triệu hồi kết giới miệng cóc |
| toad-confrontation-chant | 48–63 | Hai cóc tiên hát, sóng âm và chakra ảo thuật |
| raging-lions-mane | 64–79 | Tóc vươn dài, quấn rồi hất mục tiêu |
| senjutsu-power | 80–87 | Hào quang tiên thuật và chakra |
| tale-of-jiraiya-revival | 88–95 | Gục xuống, cuộn giấy phát sáng, đứng dậy |

Kỹ năng được thể hiện bằng hình ảnh. Các luật Chakra/Barrier/Chaos/Suppress Immunity/15 Combo/tăng Chase/hồi sinh 30% HP chưa được cài vào combat trong lần tạo asset này. Có thể dùng các clip để tích hợp ở bước tiếp theo; đây là keyframe AI, cần rà soát và căn neo từng frame khi đưa vào game.

Đóng gói lại: chạy `python pack.py` ngay trong thư mục này (cần Pillow). Không sửa hoặc ghi đè bộ Naruto.
