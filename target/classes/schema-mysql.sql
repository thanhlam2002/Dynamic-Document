-- Active: 1727270994892@@127.0.0.1@3306@docflow
-- Bảng người dùng
CREATE TABLE IF NOT EXISTS users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(200),
  role VARCHAR(30) NOT NULL,         -- EMPLOYEE | LEADER
  active TINYINT(1) NOT NULL DEFAULT 1
);

-- Văn bản
CREATE TABLE IF NOT EXISTS document (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  doc_no VARCHAR(100) NOT NULL,
  title VARCHAR(500) NOT NULL,
  content TEXT,
  type VARCHAR(20) NOT NULL,         -- INCOMING | OUTGOING
  status VARCHAR(20) NOT NULL,       -- PENDING | IN_PROGRESS | APPROVED | REJECTED | COMPLETED
  issue_date DATETIME NULL,
  receive_date DATETIME NULL,
  receiver_org VARCHAR(255),
  sender_org   VARCHAR(255),
  created_by BIGINT,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
);

-- Lịch sử xử lý
CREATE TABLE IF NOT EXISTS document_history (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  document_id BIGINT NOT NULL,
  actor_id BIGINT,
  action VARCHAR(30) NOT NULL,       -- APPROVE | REJECT | FORWARD
  comment VARCHAR(1000),
  to_user_id BIGINT,
  status_after VARCHAR(20) NOT NULL,
  at_time DATETIME NOT NULL,
  INDEX idx_doc (document_id),
  CONSTRAINT fk_hist_doc FOREIGN KEY (document_id) REFERENCES document(id) ON DELETE CASCADE
);

-- Seed demo users
INSERT INTO users (username,password_hash,full_name,role,active) VALUES
('employee','123','Nhân viên A','EMPLOYEE',1),
('leader','123','Lãnh đạo B','LEADER',1),
('thu-ky','123','Thư ký C','EMPLOYEE',1),
('chuyen-vien','123','Chuyên viên D','EMPLOYEE',1)
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

-- src/main/resources/schema-mysql.sql (bổ sung cuối file)
CREATE TABLE IF NOT EXISTS document_file (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  document_id BIGINT NOT NULL,
  filename VARCHAR(255) NOT NULL,
  content_type VARCHAR(200),
  size_bytes BIGINT NOT NULL,
  disk_path VARCHAR(1000) NOT NULL,
  uploaded_by BIGINT,
  uploaded_at DATETIME NOT NULL,
  INDEX idx_docfile_doc (document_id),
  CONSTRAINT fk_docfile_doc FOREIGN KEY (document_id) REFERENCES document(id) ON DELETE CASCADE
);

-- 1) Đảm bảo bảng đích dùng InnoDB và cùng charset/collation
ALTER TABLE `users`     ENGINE=InnoDB, CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `document` ENGINE=InnoDB, CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2) Tạo bảng notification (chưa gắn FK)
CREATE TABLE IF NOT EXISTS `notification` (
  `id`        BIGINT NOT NULL AUTO_INCREMENT,
  `user_id`   BIGINT NOT NULL,
  `doc_id`    BIGINT NULL,
  `type`      VARCHAR(50) NULL,      -- APPROVED / REJECTED / FORWARDED ...
  `message`   TEXT NOT NULL,
  `created_at` DATETIME NOT NULL,
  `read_at`    DATETIME NULL,
  PRIMARY KEY (`id`),
  KEY `idx_notif_user_created` (`user_id`,`created_at`),
  KEY `idx_notif_user_unread`  (`user_id`,`read_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Phòng trường hợp đã lỡ thêm FK sai tên trước đó
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE `notification` DROP FOREIGN KEY `fk_notif_user`;
ALTER TABLE `notification` DROP FOREIGN KEY `fk_notif_doc`;
SET FOREIGN_KEY_CHECKS=1;

-- Đảm bảo kiểu khớp với PK đích (cả 3 đều BIGINT nên giữ BIGINT)
ALTER TABLE `notification`
  MODIFY `user_id` BIGINT NOT NULL,
  MODIFY `doc_id`  BIGINT NULL;

-- (khuyến nghị) thêm index cho doc_id để join nhanh
ALTER TABLE `notification`
  ADD INDEX `idx_notif_doc` (`doc_id`);

-- Thêm lại khóa ngoại với đúng tên bảng `users`
ALTER TABLE `notification`
  ADD CONSTRAINT `fk_notif_user`
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
    ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `fk_notif_doc`
    FOREIGN KEY (`doc_id`) REFERENCES `document`(`id`)
    ON DELETE SET NULL ON UPDATE RESTRICT;

-- users đã tồn tại rồi; chỉ update seed:
UPDATE users SET password_hash='$2a$10$Gqk8t6rKk4sZ9dP0c1RrFuo2rKZbJ5E4zQXkzWZp2B4d9Y.5C1m8u' WHERE username='employee';
UPDATE users SET password_hash='$2a$10$Gqk8t6rKk4sZ9dP0c1RrFuo2rKZbJ5E4zQXkzWZp2B4d9Y.5C1m8u' WHERE username='leader';
UPDATE users SET password_hash='$2a$10$Gqk8t6rKk4sZ9dP0c1RrFuo2rKZbJ5E4zQXkzWZp2B4d9Y.5C1m8u' WHERE username='thu-ky';
UPDATE users SET password_hash='$2a$10$Gqk8t6rKk4sZ9dP0c1RrFuo2rKZbJ5E4zQXkzWZp2B4d9Y.5C1m8u' WHERE username='chuyen-vien';
-- hash trên tương ứng mật khẩu ""

ALTER TABLE document ADD COLUMN current_assignee BIGINT NULL;

-- (khuyến nghị) gán tạm người tạo làm assignee ban đầu
UPDATE document SET current_assignee = created_by WHERE current_assignee IS NULL;
