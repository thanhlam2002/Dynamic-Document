# Dynamic Document Workflow (ZK 7.0.5)

Hệ thống quản lý Văn bản Đi – Đến với luồng xử lý động, xây dựng trên ZK 7.0.5 (MVVM), Java 8+, MySQL (JDBC), JWT và chạy demo bằng Jetty qua Maven.

---

## Mục lục
- [Tính năng](#tính-năng)
- [Kiến trúc & Công nghệ](#kiến-trúc--công-nghệ)
- [Cấu trúc thư mục](#cấu-trúc-thư-mục)
- [Chuẩn bị môi trường](#chuẩn-bị-môi-trường)
- [Thiết lập Database](#thiết-lập-database)
- [Chạy dự án (Jetty)](#chạy-dự-án-jetty)
- [Luồng sử dụng nhanh](#luồng-sử-dụng-nhanh)
- [Phân quyền & Ràng buộc](#phân-quyền--ràng-buộc)
- [Biến môi trường](#biến-môi-trường)
- [Troubleshooting](#troubleshooting)
- [Lộ trình mở rộng](#lộ-trình-mở-rộng)
- [License](#license)
- [Tác giả & Đóng góp](#tác-giả--đóng-góp)

---

## Tính năng

- Quản lý văn bản: Đi (OUTGOING) / Đến (INCOMING), số hiệu, tiêu đề, nội dung, ngày ban hành/nhận, nơi gửi/nhận.
- Luồng xử lý động:
  - Phê duyệt / Từ chối (Leader)
  - Chuyển tiếp (chọn người xử lý tiếp theo tại runtime)
  - Lưu toàn bộ lịch sử vào `document_history`
- Tìm kiếm & lọc theo từ khóa, loại, trạng thái, khoảng thời gian; hỗ trợ phân trang.
- Đính kèm tệp:
  - Upload khi tạo văn bản (nhiều tệp)
  - Tải xuống tại màn chi tiết
- Dashboard thống kê theo trạng thái và loại văn bản.
- Xác thực & phân quyền: JWT + session đơn giản; vai trò `EMPLOYEE`, `LEADER`; khóa nút thao tác theo role + trạng thái.

---

## Kiến trúc & Công nghệ

- UI: ZUL + ViewModel (MVVM). Thành phần: Grid, Combobox, Datebox, Paging, Groupbox, Notification...
- Service layer: `JdbcDocumentService` (JDBC thuần), `ServiceFactory` cấp `DataSource`.
- Bảo mật: `JwtAuthFilter`, helper `Authz.requireRole(...)`.
- Lưu file: metadata trong MySQL (`document_file`), nội dung lưu trên đĩa (`disk_path`), tải qua `FileDownloadServlet`.

---

## Cấu trúc thư mục

```text
src/
 ├─ main/java/com/example/docflow/
 │   ├─ domain/                    # Entity đơn giản (POJO)
 │   ├─ domain/enums/              # DocumentType/Status, ActionType
 │   ├─ service/                   # Interface + ServiceFactory
 │   │   └─ impl/                  # JdbcDocumentService, ...
 │   ├─ security/                  # JwtAuthFilter, Authz helper
 │   ├─ util/                      # SimpleDataSource
 │   └─ vm/                        # DocumentListVM, DocumentDetailVM, NewDocumentVM, DashboardVM
 │
 ├─ main/webapp/
 │   ├─ index.zul                  # (nếu có) trang root
 │   ├─ login.zul                  # (nếu có) đăng nhập
 │   ├─ documents.zul              # Danh sách + tìm kiếm
 │   ├─ document_detail.zul        # Chi tiết + lịch sử + tải file
 │   ├─ new_document.zul           # Tạo mới + upload file
 │   └─ dashboard.zul              # Thống kê
 │
 └─ resources/
     └─ schema-mysql.sql           # Tạo bảng + seed
```

---

## Chuẩn bị môi trường

- Java: 8 hoặc 11+
- Maven: 3.6+
- MySQL: 5.7/8.0 (khuyến nghị 8.0)

---

## Thiết lập Database

Tạo database:

```sql
CREATE DATABASE docflow
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
```

Chạy script khởi tạo bảng (và seed nếu có):
- `src/main/resources/schema-mysql.sql`
- Hoặc dùng file `.sql` của bạn trong MySQL Workbench

Seed user mặc định (ví dụ):
- `employee / 123` → role `EMPLOYEE`
- `leader / 123` → role `LEADER`

---

## Chạy dự án (Jetty)

Trong thư mục dự án, chạy:

```bash
mvn -U clean package
mvn -U jetty:run \
  "-Ddb.user=docflow" \
  "-Ddb.pass=docflow123" \
  "-Ddb.url=jdbc:mysql://localhost:3306/docflow?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Bangkok&useSSL=false&allowPublicKeyRetrieval=true"
```

- Mặc định Jetty chạy tại: http://localhost:8080/
- Có thể đặt `db.url`, `db.user`, `db.pass` vào `MAVEN_OPTS` hoặc cấu hình Maven profile để ngắn gọn hơn.

---

## Luồng sử dụng nhanh

1. Đăng nhập (tuỳ cách làm login UI/JWT).
2. Vào **Documents** → lọc theo keyword/loại/trạng thái/ngày.
3. Tạo mới:
   - Chọn Loại: Đi/Đến → hiện trường Nơi nhận / Nơi gửi phù hợp.
   - Nhập số hiệu, tiêu đề, nội dung.
   - Upload file (nhiều tệp).
   - Lưu → trạng thái khởi tạo thường là `PENDING`.
4. Màn chi tiết văn bản:
   - Xem lịch sử xử lý.
   - Leader có thể Duyệt/Từ chối/Chuyển tiếp (tuỳ trạng thái hiện tại).
   - Tải file đính kèm.
5. Dashboard: xem thống kê tổng quan.

---

## Phân quyền & Ràng buộc

| Vai trò    | Quyền chính | Ghi chú |
|------------|-------------|--------|
| EMPLOYEE   | Tạo văn bản mới | Không thể phê duyệt / từ chối |
| LEADER     | Phê duyệt, Từ chối, Chuyển tiếp | Áp dụng khi trạng thái là `PENDING` hoặc `IN_PROGRESS` |

UI tự vô hiệu hoá nút theo vai trò (session/Claims/JWT) và trạng thái tài liệu (đã `APPROVED`/`REJECTED` thì không thao tác tiếp).

---

## Biến môi trường

Các system properties (hoặc biến môi trường tương đương):

- `db.url` – JDBC URL MySQL
- `db.user` – username
- `db.pass` – password

Ví dụ `.env` (nếu bạn dùng wrapper):

```env
DB_URL=jdbc:mysql://localhost:3306/docflow?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Bangkok&useSSL=false&allowPublicKeyRetrieval=true
DB_USER=docflow
DB_PASS=docflow123
```

---

## Troubleshooting

- `java.sql.SQLException: The url cannot be null`  
  Chưa truyền `-Ddb.url` (hoặc `ServiceFactory` không đọc được). Kiểm tra lệnh `jetty:run` hoặc cách bạn set system properties.

- Non-fast-forward khi push Git
  ```bash
  git fetch origin
  git pull --rebase origin main
  git push -u origin main
  # hoặc (thận trọng)
  git push origin main --force-with-lease
  ```

- Upload OK nhưng không thấy ở chi tiết  
  Upload chỉ cho phép khi tạo. Tải xuống hiển thị ở màn chi tiết.

- Nút thao tác không hiện  
  Kiểm tra session/role (`LEADER`) và trạng thái (`PENDING`/`IN_PROGRESS`).

---

## Lộ trình mở rộng

- Component timeline lịch sử xử lý (custom ZK).
- Thông báo (notification) có lưu DB + counter badge.
- Full-text search (MySQL FULLTEXT hoặc Elasticsearch).
- Phân quyền chi tiết theo bước luồng/đơn vị.
- Đa tệp đính kèm nâng cao (xóa/thêm trong edit).
- Gửi email khi chuyển tiếp / phê duyệt.

---

## License

MIT (hoặc cập nhật theo nhu cầu của bạn).

---

## Tác giả & Đóng góp

- Chủ repo: @thanhlam2002  
- Mở PR/Issue để đóng góp tính năng, sửa lỗi hoặc tài liệu.
