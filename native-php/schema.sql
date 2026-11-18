CREATE DATABASE IF NOT EXISTS humas_hub CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE humas_hub;

CREATE TABLE IF NOT EXISTS users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(80) NOT NULL UNIQUE,
  name VARCHAR(150) NOT NULL,
  role ENUM('superadmin','admin','editor') NOT NULL,
  password_ciphertext TEXT NOT NULL,
  password_nonce VARCHAR(64) NOT NULL,
  password_tag VARCHAR(64) NOT NULL,
  caption_access TINYINT(1) NOT NULL DEFAULT 0,
  allow_multiple_types TINYINT(1) NOT NULL DEFAULT 0,
  allow_multiple_ratios TINYINT(1) NOT NULL DEFAULT 0,
  active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS options (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  option_group ENUM('content_type','ratio','platform') NOT NULL,
  label VARCHAR(100) NOT NULL,
  active TINYINT(1) NOT NULL DEFAULT 1,
  UNIQUE KEY uq_option (option_group,label)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS requests (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  brief TEXT NOT NULL,
  requester_id BIGINT UNSIGNED NOT NULL,
  editor_id BIGINT UNSIGNED NOT NULL,
  deadline DATETIME NOT NULL,
  publish_at DATETIME NULL,
  status ENUM('scheduled','in_progress','revision','approved','published') NOT NULL DEFAULT 'scheduled',
  chat_open TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_req_owner FOREIGN KEY (requester_id) REFERENCES users(id),
  CONSTRAINT fk_req_editor FOREIGN KEY (editor_id) REFERENCES users(id),
  INDEX idx_deadline_status (deadline,status), INDEX idx_editor_status (editor_id,status)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS request_options (
  request_id BIGINT UNSIGNED NOT NULL,
  option_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (request_id,option_id),
  FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE,
  FOREIGN KEY (option_id) REFERENCES options(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS messages (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  request_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  body TEXT NULL,
  caption TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id), INDEX idx_messages (request_id,id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS files (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  request_id BIGINT UNSIGNED NOT NULL,
  message_id BIGINT UNSIGNED NULL,
  uploader_id BIGINT UNSIGNED NOT NULL,
  original_name VARCHAR(255) NOT NULL,
  stored_name VARCHAR(255) NOT NULL UNIQUE,
  mime_type VARCHAR(150) NOT NULL,
  file_size BIGINT UNSIGNED NOT NULL,
  file_kind ENUM('reference','draft','final') NOT NULL DEFAULT 'draft',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE,
  FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE SET NULL,
  FOREIGN KEY (uploader_id) REFERENCES users(id), INDEX idx_files_request (request_id,file_kind)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS notifications (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  request_id BIGINT UNSIGNED NULL,
  body VARCHAR(255) NOT NULL,
  read_at DATETIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE,
  INDEX idx_unread (user_id,read_at,id)
) ENGINE=InnoDB;

INSERT IGNORE INTO options(option_group,label) VALUES
 ('content_type','Grafis'),('content_type','Video'),('content_type','Carousel'),('content_type','Foto'),('content_type','Reels'),('content_type','Story'),
 ('ratio','1:1'),('ratio','4:5'),('ratio','9:16'),('ratio','16:9'),
 ('platform','Instagram'),('platform','TikTok');
