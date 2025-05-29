-- Create Database

CREATE DATABASE IF NOT EXISTS `marsh`;
USE `marsh`;


-- Drop Tables and Views

DROP VIEW IF EXISTS `v_board`;
DROP VIEW IF EXISTS `v_comment`;
DROP TABLE IF EXISTS `t_comment`;
DROP TABLE IF EXISTS `t_board`;
DROP TABLE IF EXISTS `t_admin`;
DROP TABLE IF EXISTS `t_user`;


-- Create Tables

CREATE TABLE IF NOT EXISTS `t_user` (
  `id`             CHAR(36)      PRIMARY KEY DEFAULT (UUID()),
  `username`       VARCHAR(50)   NOT NULL UNIQUE,
  `email`          VARCHAR(100)  NOT NULL UNIQUE,
  `password`       VARCHAR(255)  NOT NULL,
  `register_dtm`   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
  `register_user`  VARCHAR(100),
  `update_dtm`     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_user`    VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS `t_admin` (
  `id`             CHAR(36)      PRIMARY KEY DEFAULT (UUID()),
  `username`       VARCHAR(50)   NOT NULL UNIQUE,
  `email`          VARCHAR(100)  NOT NULL UNIQUE,
  `password`       VARCHAR(255)  NOT NULL,
  `role`           ENUM('super', 'moderator') DEFAULT 'moderator',
  `register_dtm`   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
  `register_user`  VARCHAR(100),
  `update_dtm`     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_user`    VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS `t_board` (
  `id`             CHAR(36)      PRIMARY KEY DEFAULT (UUID()),
  `user_id`        CHAR(36)      NOT NULL,
  `title`          VARCHAR(150)  NOT NULL,
  `content`        TEXT,
  `register_dtm`   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
  `register_user`  VARCHAR(100),
  `update_dtm`     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_user`    VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS `t_comment` (
  `id`             CHAR(36)      PRIMARY KEY DEFAULT (UUID()),
  `board_id`       CHAR(36)      NOT NULL,
  `user_id`        CHAR(36)      NOT NULL,
  `content`        TEXT          NOT NULL,
  `register_dtm`   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
  `register_user`  VARCHAR(100),
  `update_dtm`     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_user`    VARCHAR(100)
);


-- Foreign Keys

ALTER TABLE `t_board`
  ADD CONSTRAINT `fk_board_user`
  FOREIGN KEY (`user_id`) REFERENCES `t_user`(`id`) ON DELETE CASCADE;

ALTER TABLE `t_comment`
  ADD CONSTRAINT `fk_comment_board`
  FOREIGN KEY (`board_id`) REFERENCES `t_board`(`id`) ON DELETE CASCADE;

ALTER TABLE `t_comment`
  ADD CONSTRAINT `fk_comment_user`
  FOREIGN KEY (`user_id`) REFERENCES `t_user`(`id`) ON DELETE CASCADE;


-- Views

CREATE VIEW `v_board` AS
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
FROM `t_board` b
JOIN `t_user` u ON b.`user_id` = u.`id`;

CREATE VIEW `v_comment` AS
SELECT
  c.`id`,
  c.`board_id`,
  c.`user_id`,
  u.`username`       AS `username`,
  c.`content`,
  c.`register_dtm`,
  c.`register_user`,
  c.`update_dtm`,
  c.`update_user`
FROM `t_comment` c
JOIN `t_user` u ON c.`user_id` = u.`id`;
