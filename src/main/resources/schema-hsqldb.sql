CREATE TABLE users (
  id BIGINT IDENTITY PRIMARY KEY,
  username VARCHAR(64) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(128),
  email VARCHAR(128),
  active BOOLEAN DEFAULT TRUE
);

CREATE TABLE roles (
  id BIGINT IDENTITY PRIMARY KEY,
  code VARCHAR(32) NOT NULL UNIQUE
);

CREATE TABLE user_roles (
  user_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  PRIMARY KEY(user_id, role_id)
);

CREATE TABLE documents (
  id BIGINT IDENTITY PRIMARY KEY,
  doc_no VARCHAR(64),
  title VARCHAR(255),
  content CLOB,
  type VARCHAR(16),
  issue_date TIMESTAMP,
  receive_date TIMESTAMP,
  receiver_org VARCHAR(255),
  sender_org VARCHAR(255),
  created_by BIGINT,
  status VARCHAR(32),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE document_history (
  id BIGINT IDENTITY PRIMARY KEY,
  document_id BIGINT NOT NULL,
  actor_id BIGINT NOT NULL,
  action VARCHAR(32),
  comment VARCHAR(1024),
  to_user_id BIGINT,
  status_after VARCHAR(32),
  at_time TIMESTAMP
);

CREATE TABLE document_attachments (
  id BIGINT IDENTITY PRIMARY KEY,
  document_id BIGINT NOT NULL,
  file_name VARCHAR(255),
  file_path VARCHAR(512),
  uploaded_at TIMESTAMP
);

INSERT INTO roles(code) VALUES ('EMPLOYEE'), ('LEADER');
