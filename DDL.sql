-- Create Database

CREATE DATABASE IF NOT EXISTS `marsh`;
USE `marsh`;


-- Drop Tables and Views

DROP VIEW IF EXISTS `v_post`;
DROP VIEW IF EXISTS `v_comment`;
DROP TABLE IF EXISTS `tr_post_attachment_file`;
DROP TABLE IF EXISTS `t_comment`;
DROP TABLE IF EXISTS `t_post`;
DROP TABLE IF EXISTS `t_refresh_token`;
DROP TABLE IF EXISTS `t_admin`;
DROP TABLE IF EXISTS `t_user`;
DROP TABLE IF EXISTS `t_attachment_file`;


-- Create Tables

CREATE TABLE IF NOT EXISTS `t_attachment_file` (
    `id`           CHAR(36)      PRIMARY KEY DEFAULT (UUID()) COMMENT '첨부파일 ID',
    `stored_path`  VARCHAR(255)     NOT NULL COMMENT '저장 경로',
    `stored_name`  VARCHAR(255)     NOT NULL COMMENT '저장된 첨부파일명',
    `origin_name`  VARCHAR(255)     NOT NULL COMMENT '원본 첨부파일명',
    `type`         VARCHAR(255)     NOT NULL COMMENT '첨부파일 타입',
    `size`         BIGINT UNSIGNED  NOT NULL COMMENT '첨부파일 크기(바이트)',
    `register_dtm` TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
    `register_user` VARCHAR(100)  NULL COMMENT '등록자',
    `update_dtm`   TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    `update_user`  VARCHAR(100)  NULL COMMENT '수정자'
    ) COMMENT '첨부파일';

CREATE TABLE IF NOT EXISTS `t_user` (
    `id`             CHAR(36)      PRIMARY KEY DEFAULT (UUID()) COMMENT '사용자 ID',
    `profile_picture_id` CHAR(36)  NULL COMMENT '프로필 사진 첨부파일 ID',
    `username`       VARCHAR(50)   NULL UNIQUE COMMENT '사용자 이름',
    `email`          VARCHAR(100)  NULL UNIQUE COMMENT '이메일',
    `password`       VARCHAR(255)  NULL COMMENT '비밀번호',
    `deleted`        ENUM('Y', 'N') NOT NULL COMMENT '삭제 여부',
    `register_dtm`   TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
    `register_user`  VARCHAR(100)  NULL COMMENT '등록자',
    `update_dtm`     TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    `update_user`    VARCHAR(100)  NULL COMMENT '수정자'
    ) COMMENT '사용자';

CREATE TABLE IF NOT EXISTS `t_admin` (
    `id`             CHAR(36)      PRIMARY KEY DEFAULT (UUID()) COMMENT '관리자 ID',
    `username`       VARCHAR(50)   NULL UNIQUE COMMENT '관리자 이름',
    `email`          VARCHAR(100)  NULL UNIQUE COMMENT '이메일',
    `password`       VARCHAR(255)  NULL COMMENT '비밀번호',
    `role`           ENUM('SUPER', 'MODERATOR') DEFAULT 'MODERATOR' COMMENT '권한',
    `deleted`        ENUM('Y', 'N') NOT NULL COMMENT '삭제 여부',
    `register_dtm`   TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
    `register_user`  VARCHAR(100)  NULL COMMENT '등록자',
    `update_dtm`     TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    `update_user`    VARCHAR(100)  NULL COMMENT '수정자'
    ) COMMENT '관리자';

CREATE TABLE IF NOT EXISTS `t_refresh_token` (
    `id`             CHAR(36)      PRIMARY KEY DEFAULT (UUID()) COMMENT '토큰 고유 ID',
    `owner_type`     ENUM('USER', 'ADMIN') NOT NULL COMMENT '토큰 소유자 타입',
    `owner_id`       CHAR(36)      NOT NULL COMMENT '토큰 소유자 ID',
    `token`          VARCHAR(512)  NOT NULL COMMENT '리프레시 토큰 값',
    `expires_at`     TIMESTAMP     NOT NULL COMMENT '토큰 만료 시간',
    `revoked`        ENUM('Y','N') NOT NULL DEFAULT 'N' COMMENT '토큰 사용 중지 여부',
    `register_dtm`   TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
    `register_user`  VARCHAR(100)  NULL COMMENT '등록자',
    `update_dtm`     TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    `update_user`    VARCHAR(100)  NULL COMMENT '수정자'
    ) COMMENT '리프레시 토큰';

CREATE TABLE IF NOT EXISTS `t_post` (
    `id`             CHAR(36)      PRIMARY KEY DEFAULT (UUID()) COMMENT '게시글 ID',
    `user_id`        CHAR(36)      NULL COMMENT '작성자 ID',
    `title`          VARCHAR(150)  NULL COMMENT '제목',
    `content`        TEXT          NULL COMMENT '내용',
    `deleted`        ENUM('Y', 'N') NOT NULL COMMENT '삭제 여부',
    `register_dtm`   TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
    `register_user`  VARCHAR(100)  NULL COMMENT '등록자',
    `update_dtm`     TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    `update_user`    VARCHAR(100)  NULL COMMENT '수정자'
    ) COMMENT '게시글';

CREATE TABLE IF NOT EXISTS `t_comment` (
    `id`             CHAR(36)      PRIMARY KEY DEFAULT (UUID()) COMMENT '댓글 ID',
    `post_id`        CHAR(36)      NOT NULL COMMENT '게시글 ID',
    `user_id`        CHAR(36)      NULL COMMENT '작성자 ID',
    `content`        TEXT          NULL COMMENT '내용',
    `deleted`        ENUM('Y', 'N') NOT NULL COMMENT '삭제 여부',
    `register_dtm`   TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
    `register_user`  VARCHAR(100)  NULL COMMENT '등록자',
    `update_dtm`     TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    `update_user`    VARCHAR(100)  NULL COMMENT '수정자'
    ) COMMENT '댓글';

CREATE TABLE IF NOT EXISTS `tr_post_attachment_file` (
    `attachment_file_id`  CHAR(36)      DEFAULT (UUID()) COMMENT '첨부파일 ID',
    `post_id`             CHAR(36)      DEFAULT (UUID()) COMMENT '게시글 ID',
    PRIMARY KEY (`attachment_file_id`, `post_id`)
    ) COMMENT '첨부파일-게시글 관계';


-- Foreign Keys

ALTER TABLE `t_user`
    ADD FOREIGN KEY (`profile_picture_id`) REFERENCES `t_attachment_file`(`id`) ON DELETE SET NULL;

ALTER TABLE `t_post`
    ADD FOREIGN KEY (`user_id`) REFERENCES `t_user`(`id`) ON DELETE SET NULL;

ALTER TABLE `t_comment`
    ADD FOREIGN KEY (`post_id`) REFERENCES `t_post`(`id`) ON DELETE RESTRICT;

ALTER TABLE `t_comment`
    ADD FOREIGN KEY (`user_id`) REFERENCES `t_user`(`id`) ON DELETE SET NULL;

ALTER TABLE `tr_post_attachment_file`
    ADD FOREIGN KEY (`attachment_file_id`) REFERENCES `t_attachment_file`(`id`) ON DELETE RESTRICT,
    ADD FOREIGN KEY (`post_id`) REFERENCES `t_post`(`id`) ON DELETE RESTRICT;


-- Views

CREATE VIEW `v_post` AS
SELECT
  b.`id`,
  b.`user_id`,
  u.`username`       AS `username`,
  b.`title`,
  b.`content`,
  b.`register_dtm`,
  b.`register_user`,
  b.`update_dtm`,
  b.`update_user`
FROM `t_post` b
JOIN `t_user` u ON b.`user_id` = u.`id`;

CREATE VIEW `v_comment` AS
SELECT
  c.`id`,
  c.`post_id`,
  c.`user_id`,
  u.`username`       AS `username`,
  c.`content`,
  c.`register_dtm`,
  c.`register_user`,
  c.`update_dtm`,
  c.`update_user`
FROM `t_comment` c
JOIN `t_user` u ON c.`user_id` = u.`id`;
