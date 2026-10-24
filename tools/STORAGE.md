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

## Dọn các gói backup cũ và sandbox test

Khi đã chấp nhận bỏ khả năng rollback bằng các gói dữ liệu backup cũ:

```powershell
python tools/prune-old-storage.py
python tools/prune-old-storage.py --apply
```

Công cụ chỉ xóa `.binPackage` bên trong các thư mục backup của `cikarim` và ba sandbox `.battlefield-runtime-test`, `.boss-runtime-test`, `.partner-runtime-test`. Các junction trong sandbox được gỡ bằng `rmdir`, không duyệt hay xóa thư mục đích. Các file SWF nền, backup JSON và tài nguyên đang chạy được giữ. Đối chiếu SHA-256 toàn bộ file tĩnh trong tài nguyên game, nhân vật nguồn, backend và hai thư mục bảng dữ liệu trước/sau khi xóa; database được giữ ngoài vùng xóa và không hash vì có thể đang được server cập nhật.

Báo cáo thao tác này: `tools/prune-report.json`. Không chạy khi đang dùng các sandbox test.

## Nén dữ liệu VFX nhân vật Naruto

```powershell
python tools/compress-vfx.py --apply
```

Công cụ nén lại các file `.argb` trong `public/*-vfx` bằng zlib mức 9. Giữ file cũ nếu bản mới không nhỏ hơn; kiểm tra toàn bộ byte sau giải nén trước khi ghi và đọc lại sau khi ghi. Đây là nén không mất dữ liệu trong định dạng Flash đã dùng sẵn. Không thay đổi PNG, kích thước ảnh, màu, alpha, đường dẫn hoặc mã phát hiệu ứng.

Checksum file nén và số byte trong manifest được cập nhật; checksum pixel và PNG nguồn giữ nguyên. Các script `prepare-streaming.py` cũng dùng mức 9 cho lần build sau. Báo cáo: `tools/vfx-compression-report.json`; bản sao metadata streaming trước thao tác: `tools/vfx-streaming-before.json`. Lưu ý nén mạnh hơn làm thời gian build lâu hơn; mức giảm tùy loại hiệu ứng. Dung lượng lịch sử Git chỉ thay đổi khi xử lý lịch sử riêng.

Nén thêm PNG trong các thư mục VFX, giữ nguyên dữ liệu scanline sau giải nén và toàn bộ chunk ngoài IDAT:

```powershell
python tools/compress-vfx-png.py --apply
python tools/verify-vfx-storage.py
```

Công cụ PNG kiểm tra CRC, gộp/nén lại IDAT bằng zlib mức 9, chỉ ghi nếu file nhỏ hơn. Checksum PNG nguồn trong manifest được cập nhật theo byte file mới; checksum pixel ARGB giữ nguyên. Lần build tạo lại PNG có thể ghi lại mức nén của công cụ xuất ảnh, khi đó chạy lại bước nén PNG sau build. Báo cáo PNG: `tools/vfx-png-compression-report.json`. Kết quả kiểm tra toàn bộ file đã xử lý và các manifest đang dùng: `tools/vfx-storage-verification.json`. Nên chạy hai công cụ nén nối tiếp, không đồng thời, vì cả hai cùng cập nhật manifest.
