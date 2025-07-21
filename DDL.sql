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
DROP TABLE IF EXISTS `t_user`;
DROP TABLE IF EXISTS `t_attachment_file`;


-- Create Tables

CREATE TABLE IF NOT EXISTS `t_attachment_file` (
    `seq`           BIGINT      PRIMARY KEY DEFAULT (UUID()) COMMENT '첨부파일 식별번호',
    `uuid`         CHAR(36)         NOT NULL COMMENT '첨부파일 UUID',
    `stored_path`  VARCHAR(255)     NOT NULL COMMENT '저장 경로',
    `stored_name`  VARCHAR(255)     NOT NULL COMMENT '저장된 첨부파일명',
    `origin_name`  VARCHAR(255)     NOT NULL COMMENT '원본 첨부파일명',
    `type`         VARCHAR(255)     NOT NULL COMMENT '첨부파일 타입',
    `size`         BIGINT UNSIGNED  NOT NULL COMMENT '첨부파일 크기(바이트)',
    `deleted`        TINYINT(1) NULL DEFAULT 0 COMMENT '삭제 여부 (1: True, 2: False)',
    `register_dtm` TIMESTAMP        NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
    `register_user` VARCHAR(100)    NULL COMMENT '등록자',
    `update_dtm`   TIMESTAMP        NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    `update_user`  VARCHAR(100)     NULL COMMENT '수정자'
    ) COMMENT '첨부파일';

CREATE TABLE IF NOT EXISTS `t_user` (
    `seq`             BIGINT      PRIMARY KEY DEFAULT (UUID()) COMMENT '사용자 식별번호',
    `uuid`         CHAR(36)         NOT NULL COMMENT '사용자 UUID',
    `profile_picture_seq` CHAR(36)  NULL COMMENT '프로필 사진 첨부파일 식별번호',
    `username`       VARCHAR(50)   NULL UNIQUE COMMENT '사용자 이름',
    `email`          VARCHAR(100)  NULL UNIQUE COMMENT '이메일',
    `password`       VARCHAR(255)  NULL COMMENT '비밀번호',
    `deleted`        TINYINT(1) NULL DEFAULT 0 COMMENT '삭제 여부 (1: True, 2: False)',
    `register_dtm`   TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
    `register_user`  VARCHAR(100)  NULL COMMENT '등록자',
    `update_dtm`     TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    `update_user`    VARCHAR(100)  NULL COMMENT '수정자'
    ) COMMENT '사용자';

CREATE TABLE IF NOT EXISTS `t_refresh_token` (
    `seq`             BIGINT      PRIMARY KEY DEFAULT (UUID()) COMMENT '토큰 고유 식별번호',
    `user_seq`       CHAR(36)      NOT NULL COMMENT '토큰 소유자 식별번호',
    `token`          VARCHAR(512)  NOT NULL COMMENT '리프레시 토큰 값',
    `expires_at`     TIMESTAMP     NOT NULL COMMENT '토큰 만료 시간',
    `revoked`        TINYINT(1)    NULL DEFAULT 0 COMMENT '토큰 사용 중지 여부 (1: True, 2: False)',
    `register_dtm`   TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
    `register_user`  VARCHAR(100)  NULL COMMENT '등록자',
    `update_dtm`     TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    `update_user`    VARCHAR(100)  NULL COMMENT '수정자'
    ) COMMENT '리프레시 토큰';

CREATE TABLE IF NOT EXISTS `t_post` (
    `seq`             BIGINT      PRIMARY KEY DEFAULT (UUID()) COMMENT '게시글 식별번호',
    `uuid`           CHAR(36)      NOT NULL COMMENT '게시글 UUID',
    `user_seq`        CHAR(36)      NULL COMMENT '작성자 식별번호',
    `title`          VARCHAR(150)  NULL COMMENT '제목',
    `content`        TEXT          NULL COMMENT '내용',
    `deleted`        TINYINT(1)    NULL DEFAULT 0 COMMENT '삭제 여부 (1: True, 2: False)',
    `register_dtm`   TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
    `register_user`  VARCHAR(100)  NULL COMMENT '등록자',
    `update_dtm`     TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    `update_user`    VARCHAR(100)  NULL COMMENT '수정자'
    ) COMMENT '게시글';

CREATE TABLE IF NOT EXISTS `t_comment` (
    `seq`             BIGINT      PRIMARY KEY DEFAULT (UUID()) COMMENT '댓글 식별번호',
    `uuid`           CHAR(36)      NOT NULL COMMENT '댓글 UUID',
    `post_seq`        CHAR(36)      NOT NULL COMMENT '게시글 식별번호',
    `user_seq`        CHAR(36)      NULL COMMENT '작성자 식별번호',
    `content`        TEXT          NULL COMMENT '내용',
    `deleted`        TINYINT(1)    NULL DEFAULT 0 COMMENT '삭제 여부 (1: True, 2: False)',
    `register_dtm`   TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
    `register_user`  VARCHAR(100)  NULL COMMENT '등록자',
    `update_dtm`     TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    `update_user`    VARCHAR(100)  NULL COMMENT '수정자'
    ) COMMENT '댓글';

CREATE TABLE IF NOT EXISTS `tr_post_attachment_file` (
    `attachment_file_seq`  CHAR(36)      DEFAULT (UUID()) COMMENT '첨부파일 식별번호',
    `post_seq`             CHAR(36)      DEFAULT (UUID()) COMMENT '게시글 식별번호',
    PRIMARY KEY (`attachment_file_seq`, `post_seq`)
    ) COMMENT '첨부파일-게시글 관계';


-- Foreign Keys

ALTER TABLE `t_user`
    ADD FOREIGN KEY (`profile_picture_seq`) REFERENCES `t_attachment_file`(`seq`) ON DELETE SET NULL;

ALTER TABLE `t_refresh_token`
    ADD FOREIGN KEY (`user_seq`) REFERENCES `t_user`(`seq`) ON DELETE SET NULL;

ALTER TABLE `t_post`
    ADD FOREIGN KEY (`user_seq`) REFERENCES `t_user`(`seq`) ON DELETE SET NULL;

ALTER TABLE `t_comment`
    ADD FOREIGN KEY (`post_seq`) REFERENCES `t_post`(`seq`) ON DELETE RESTRICT;

ALTER TABLE `t_comment`
    ADD FOREIGN KEY (`user_seq`) REFERENCES `t_user`(`seq`) ON DELETE SET NULL;

ALTER TABLE `tr_post_attachment_file`
    ADD FOREIGN KEY (`attachment_file_seq`) REFERENCES `t_attachment_file`(`seq`) ON DELETE RESTRICT,
    ADD FOREIGN KEY (`post_seq`) REFERENCES `t_post`(`seq`) ON DELETE RESTRICT;

-- Views

CREATE VIEW `v_post` AS
SELECT
  b.`uuid`           AS `post_uuid`,
  u.`uuid`           AS `user_uuid`,
  u.`username`       AS `username`,
  b.`title`,
  b.`content`,
  b.`register_dtm`,
  b.`register_user`,
  b.`update_dtm`,
  b.`update_user`
FROM `t_post` b
JOIN `t_user` u ON b.`user_seq` = u.`seq`;

CREATE VIEW `v_comment` AS
SELECT
  c.`uuid`,
  c.`post_seq`,
  u.`uuid`,          AS `user_uuid`,
  u.`username`       AS `username`,
  c.`content`,
  c.`register_dtm`,
  c.`register_user`,
  c.`update_dtm`,
  c.`update_user`
FROM `t_comment` c
JOIN `t_user` u ON c.`user_seq` = u.`seq`;
