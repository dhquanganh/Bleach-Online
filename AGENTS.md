# Quy ước nhân vật do người dùng yêu cầu

- Mọi nhân vật mới được yêu cầu tạo từ nay mặc định gây sát thương vật lý ở toàn bộ đòn đánh, talent, Mystery, truy kích, đòn phụ, triệu hồi gây sát thương và sát thương lan.
- Với mỗi chiêu gây sát thương, đặt `attackStat: "atk"` và `damageType: "physical"`. Sát thương lấy Physical ATK đã áp dụng buff/debuff; giảm sát thương theo Physical DEF, không theo Magic ATK, Ninjutsu hay Resistance. Giữ các quy tắc xuyên giáp, chí mạng và giảm sát thương chung của chiêu.
- Quy ước này đã áp dụng cho Obito Rage, Pain Tendo Six Paths Rinnegan và Hashirama Final Battle. Không đổi ngược về mixed/ninjutsu nếu người dùng chưa yêu cầu.
- HP tiêu hao để dùng chiêu, hồi máu/hút máu và hiệu ứng mất phần trăm HP được mô tả riêng không phải hệ số sát thương đòn đánh; giữ công thức riêng của chúng, không tự biến chúng thành đòn đánh mới.
- Đồng bộ cấu hình backend, mô tả frontend và script tạo dữ liệu. Kiểm tra rằng tăng Physical ATK làm tăng sát thương, tăng Physical DEF làm giảm sát thương, còn Magic ATK/Resistance không thay đổi sát thương.
