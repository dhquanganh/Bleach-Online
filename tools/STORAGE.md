# Dọn dung lượng project (Windows)

Quét dung lượng, không đi theo junction và không chỉnh dữ liệu:

```powershell
python tools/maintain-storage.py
```

Dọn cache có thể tạo lại và nén NTFS các thư mục tài nguyên:

```powershell
python tools/maintain-storage.py --apply --compress
```

Script chỉ xóa `__pycache__` và các cache trình duyệt như `Cache`, `GPUCache`, `Code Cache` trong `sunucu-kok/cikarim`. Không xóa database, tài khoản, mã nguồn, bản sao lưu build hoặc lịch sử Git. Junction của các thư mục test không bị duyệt lặp hay xóa.

Nén NTFS giữ nguyên đường dẫn và nội dung file; game và script build đọc bình thường, không cần giải nén thủ công. Ảnh PNG, video và các gói đã nén thường tiết kiệm ít. Hiệu quả này áp dụng trên ổ NTFS hiện tại; khi copy sang ổ khác, dung lượng phụ thuộc chế độ nén của ổ đích. Đây không phải bản ZIP dùng để phân phối.

Kết quả gần nhất nằm trong `tools/storage-report.json`; log nén nằm trong `tools/compact-*.log`. Script đối chiếu SHA-256 toàn bộ file trong `asset` và một mẫu cố định từ hai thư mục dữ liệu trước/sau thao tác. Không chạy công cụ dọn cache khi đang mở công cụ preview nhân vật sử dụng các cache đó.

Để bỏ nén khi cần:

```powershell
compact /U /S:asset /I /Q
compact /U /S:sunucu-kok\cikarim /I /Q
compact /U /S:sunucu-kok\kaynak /I /Q
```

Không xóa các thư mục `extracted`, `frames`, `original`, `backups` chỉ dựa vào tên: nhiều script tạo nhân vật vẫn dùng chúng. Các file `.TexClient`, `.binPackage`, `.swf` cần giữ định dạng tương thích bộ tải Flash.
