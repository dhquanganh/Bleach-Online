# Cooldown và giới hạn chuỗi chiêu Naruto / Jiraiya

Thay đổi cân bằng cục bộ theo yêu cầu người dùng ngày 17/10/2026; thay thế các mô tả cooldown và hồi sinh cũ trong tài liệu nhân vật.

| Nhóm chiêu | Khoảng cách tối thiểu | Ví dụ |
| --- | --- | --- |
| Naruto Rasen Shuriken / Jiraiya Toad Mouth + Chant đi kèm | 3 round | Dùng round 1 → sớm nhất round 4 |
| Jiraiya Giant Rasengan / Naruto Barrage hoặc gọi phân thân | 2 round | Dùng round 1 → sớm nhất round 3 |
| Chase của cả hai nhân vật | 2 round, tối đa 1 lần mỗi round | Dùng round 1 → sớm nhất round 3 |

Mystery dùng lượt hành động chính của nhân vật; không thêm một đòn standard ngay trong cùng round. Khi standard đang hồi, bỏ qua lần sử dụng standard đó; nhân vật chờ lượt tiếp theo. Chase là phản ứng riêng nhưng vẫn có cooldown và không nhận thêm lần dùng từ Chase bonus. Barrage và gọi phân thân dùng chung cooldown, nên phân thân chết hoặc hồi lại không tạo thêm lượt.

Toad Chant gây Suppress Immunity / Extreme Chaos trong round trúng chiêu. Mục tiêu có bảo vệ chống tái áp dụng hai hiệu ứng đó tới hết round kế tiếp, kể cả khi có nhiều Jiraiya. Sát thương Chant vẫn áp dụng bình thường. Kết giới vẫn tồn tại hai round. Hồi sinh giữ nguyên cooldown và không cấp thêm lượt chính trong round hồi sinh; bỏ cơ chế cộng dồn giảm hồi Mystery.

Cooldown trong `naruto-sage.json` và `jiraiya-toads.json` do server thi hành; phần hình ảnh không thay đổi. `update-descriptions.py --apply` đồng bộ mô tả SkillConfig/HeroTalent tới JSON, bin đơn và các gói ngôn ngữ native mà không xây lại texture hoặc thay đổi chỉ số/record ngoài phạm vi. Script kiểm tra byte các record khác và đọc lại các bản cài để kiểm tra tính idempotent. Các script build nhân vật cũng dùng mô tả mới để không ghi đè về luật cũ khi dựng lại.

Kiểm tra đã PASS:

- `tests/ninja-cooldowns.test.js`: cả hai phe, lặp cast/chase, shared cooldown, Chakra của cast bị từ chối, cooldown qua hồi sinh, chống khóa Chaos nối tiếp và trận 24 round qua codec native với đối thủ vẫn hành động.
- `tests/naruto-combat.test.js`, `tests/jiraiya-combat.test.js`.
- `tests/hero-skills.test.js`, `tests/hero-talents.test.js`, `tests/battlefield-formation.test.js`, `tests/protect-balance.test.js`.

Không có backend lắng nghe port 10025 lúc cài thay đổi. Luật mới được nạp khi mở backend/game; replay cũ vẫn phát báo cáo đã lưu, cần tạo trận mới để xem logic mới.
