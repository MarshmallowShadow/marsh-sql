``` mermaid
erDiagram

  t_user {
    BIGINT seq PK
    CHAR(36) uuid "UUID"
    BIGINT profile_picture_seq FK
    VARCHAR(50) username "Unique"
    VARCHAR(100) email "Unique"
    VARCHAR(255) password
    TINYINT(1) deleted
    TIMESTAMP register_dtm
    VARCHAR(100) register_user
    TIMESTAMP update_dtm
    VARCHAR(100) update_user
  }

  t_refresh_token {
    BIGINT seq PK
    BIGINT user_seq FK
    VARCHAR(512) token
    TIMESTAMP expires_at
    TINYINT(1) revoked
    TIMESTAMP register_dtm
    VARCHAR(100) register_user
    TIMESTAMP update_dtm
    VARCHAR(100) update_user
  }

  t_attachment_file {
    BIGINT seq PK
    CHAR(36) uuid "UUID"
    VARCHAR(255) stored_path
    VARCHAR(255) stored_name
    VARCHAR(255) origin_name
    VARCHAR(255) type
    BIGINT size
    TIMESTAMP register_dtm
    VARCHAR(100) register_user
    TIMESTAMP update_dtm
    VARCHAR(100) update_user
  }

  t_post {
    BIGINT seq PK
    CHAR(36) uuid PK "UUID"
    BIGINT user_seq FK
    VARCHAR(150) title
    TEXT content
    TINYINT(1) deleted
    TIMESTAMP register_dtm
    VARCHAR(100) register_user
    TIMESTAMP update_dtm
    VARCHAR(100) update_user
  }

  t_comment {
    BIGINT seq PK
    CHAR(36) uuid PK "UUID"
    BIGINT post_seq FK
    BIGINT user_seq FK
    TEXT content
    TINYINT(1) deleted
    TIMESTAMP register_dtm
    VARCHAR(100) register_user
    TIMESTAMP update_dtm
    VARCHAR(100) update_user
  }

  tr_post_attachment_file {
    BIGINT attachment_file_seq FK
    BIGINT post_seq FK
  }

  t_attachment_file ||--o| t_user : "Contains"
  t_user ||--o{ t_post : "Writes"
  t_user ||--o{ t_comment : "Writes"
  t_user ||--o{ t_refresh_token : "Authorized By"
  t_post ||--o{ t_comment : "Contains"
  t_post ||--o{ tr_post_attachment_file : "Has"
  t_attachment_file ||--o{ tr_post_attachment_file : "Attached To"

```