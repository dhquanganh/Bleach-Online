# MongoDB và tài khoản

Mở `OYUNU-BASLAT.bat` để chơi, đăng nhập bằng **admin / admin**. Tài khoản này sở hữu nhân vật và tiến trình có sẵn. Chọn **Đăng ký** để tạo tài khoản riêng, sau đó tạo nhân vật trong game. Nút **Đăng xuất** nằm ở góc dưới bên trái.

Mở `ADMIN-PANEL.bat` hoặc `http://127.0.0.1:7420/admin` để quản trị. Trình duyệt và ứng dụng game có phiên đăng nhập riêng; nếu mở trang quản trị bằng trình duyệt, đăng nhập admin tại đó.

## Cài đặt

Node đi kèm nằm ở `node/node.exe` (24.x). Dùng runtime này vì máy chủ cần `node:sqlite`. Sau khi tải mã nguồn mới, chạy `npm ci` một lần để cài driver MongoDB.

Thông tin kết nối nằm trong `.env` tại thư mục gốc, đã được loại khỏi Git. Mẫu cấu hình ở `.env.example`. Database mặc định là `bleach_online`. `MONGODB_DNS_SERVERS` là tùy chọn khi DNS hệ thống không phân giải được địa chỉ SRV của Atlas.

Nhập dữ liệu ban đầu bằng PowerShell:

```powershell
.\node\node.exe sunucu-kok/migrate-mongo.cjs
```

Lệnh nhập có thể chạy lại: chỉ bổ sung dữ liệu thiếu, không đặt lại mật khẩu hay ghi đè tiến trình tài khoản đã có. Không chạy hai lệnh nhập đồng thời.

Bản SQLite hiện có báo `database disk image is malformed` khi đọc bảng lịch sử gói tin `t_olay`. Các bảng đọc được và dữ liệu nhân vật đã nhập; riêng bảng log hỏng được ghi trong collection `migration_status` với trạng thái `source_error`. Lệnh nhập trả mã lỗi khi còn bảng không đọc được và tiếp tục nhập các bảng lành. Không sửa hay xóa SQLite gốc.

Khởi động riêng máy chủ:

```powershell
.\node\node.exe sunucu-kok/serve.mjs --ozel --fetch-missing
```

## Lưu dữ liệu

- `accounts`: tên đăng nhập duy nhất, mật khẩu băm bằng scrypt và quyền `admin`/`player`.
- `sessions`: phiên 24 giờ; token trong MongoDB được băm SHA-256, cookie có HttpOnly và SameSite=Strict. Đăng nhập lần mới thu hồi phiên cũ của cùng tài khoản.
- `players`: trạng thái, tiền tệ, vật phẩm, đội hình và tiến trình theo ID tài khoản.
- `game_config`: bản nhập các JSON cấu hình hiện có.
- `legacy_*`: các bảng SQLite được nhập, gồm 326 bảng dữ liệu game trong `legacy_veri`.

Mỗi tài khoản chạy một máy chủ game riêng với thư mục đệm `.accounts/<id>`. Tiến trình được đồng bộ lên MongoDB mỗi hai giây và khi đăng xuất. Nếu mạng mất hoặc tiến trình bị dừng, bản lưu cục bộ chưa đồng bộ được gửi lại ở lần đăng nhập sau trên cùng máy. Giữ thư mục `.accounts` khi còn dữ liệu chưa đồng bộ. Các bảng cấu hình tĩnh vẫn được engine đọc từ JSON/SQLite cục bộ để tương thích với mã game đồng bộ hiện có; MongoDB giữ bản nhập của chúng. Đây là máy chủ game cục bộ, không có phối hợp tiến trình giữa nhiều máy chủ cùng chạy.

Quản trị, nạp vàng mô phỏng và sửa vật phẩm yêu cầu quyền admin. Cửa hàng dùng phiên của người chơi. Socket game kiểm tra token riêng của tài khoản. Không chạy trực tiếp `sunucu/admin.js` hay `sunucu/oyun-sunucu.js`; máy chủ chính tự mở và đóng chúng theo phiên đăng nhập.

## Kiểm tra

Naruto Sage Mode, Jiraiya Toads Chant, Kabuto Great Ninja War và các phân thân/triệu hồi liên quan đã được gỡ khỏi danh sách sử dụng, chiêu mộ, cửa hàng và đội hình bot. `sunucu/retired-heroes.js` chặn khôi phục chúng từ dữ liệu cũ. Đã dọn dữ liệu sở hữu ở MongoDB và bản lưu cục bộ; tài nguyên/định nghĩa cũ vẫn được giữ cho chiến báo lịch sử.

Khi áp dụng thay đổi này lên một bản cài cũ khác, đóng game và máy chủ trước rồi chạy `.\node\node.exe sunucu-kok/retire-characters.cjs`; dùng Python có Pillow chạy `sunucu-kok/cikarim/retire-characters.py` để dọn các mục Modify Lab/cửa hàng trong dữ liệu client. Hai lệnh đều có thể chạy lại và tạo bản sao lưu trước khi thay đổi.

```powershell
.\node\node.exe --test sunucu-kok/auth.test.cjs
```

Kiểm tra tích hợp dùng MongoDB đã cấu hình, tạo hai tài khoản tạm và dọn chúng sau kiểm tra; xác nhận phân quyền, token game, CORS, dữ liệu riêng, lưu khi đăng xuất và đăng nhập lại.
# Arena dùng tài khoản thật

Arena chỉ hiển thị các tài khoản đã tạo nhân vật trong MongoDB, loại tài khoản của chính mình và không thêm bot khi thiếu người. Trận đấu dùng đội hình, cấp, trang bị và kỹ năng đã lưu của đối thủ; người phòng thủ có thể ngoại tuyến. Danh sách cập nhật mỗi 5 giây, client hiển thị tối đa 8 đối thủ. Vị trí danh sách hiện sắp theo cấp, chưa phải bảng điểm PvP.

Nút Challenge trong game và Arena Matching ở launcher dùng chung luồng chiến đấu. Server gửi kết quả kèm chiến báo trong `0x01181904`, sau đó gửi `0x01181907` (FightOk). Đối thủ không hợp lệ bị từ chối trước khi tăng bộ đếm nhiệm vụ Arena.

Kiểm tra tích hợp: `node/node.exe --test --test-concurrency=1 sunucu-kok/arena.test.cjs sunucu-kok/auth.test.cjs` (cần kết nối MongoDB).

# Quản trị tất cả tài khoản

Mở `http://127.0.0.1:7420/admin` hoặc `ADMIN-PANEL.bat`, đăng nhập bằng tài khoản có quyền admin. Chọn tài khoản ở cột trái để sửa tên nhân vật, tiền tệ, cấp, VIP và linh hồn. Khung **Thêm hero** hỗ trợ tìm theo tên/ID và chọn cấp; chỉ cho thêm hero hợp lệ, chưa sở hữu, vào tài khoản đã tạo nhân vật. Hero được thêm vào danh sách sở hữu để người chơi tự xếp đội hình.

Thay đổi lưu vào MongoDB, đồng bộ bản lưu cục bộ và ghi lịch sử quản trị trong tài liệu player. Nếu tài khoản đang mở game, phiên game sẽ ngắt; tải lại game để áp dụng. Khi dữ liệu thay đổi trong lúc chỉnh sửa, trang yêu cầu tải lại để tránh ghi đè. Các công cụ admin cũ vẫn ở `/admin/legacy` và chỉ thao tác tài khoản admin đang đăng nhập.

Kiểm tra: `node/node.exe --test --test-concurrency=1 sunucu-kok/admin-accounts.test.cjs sunucu-kok/auth.test.cjs`.

