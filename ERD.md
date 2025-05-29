``` mermaid
erDiagram

  t_user {
    CHAR(36) id PK "UUID"
    CHAR(36) profile_picture_id "UUID"
    VARCHAR(50) username "Unique"
    VARCHAR(100) email "Unique"
    VARCHAR(255) password
    ENUM deleted "Y | N"
    TIMESTAMP register_dtm
    VARCHAR(100) register_user
    TIMESTAMP update_dtm
    VARCHAR(100) update_user
  }

  t_admin {
    CHAR(36) id PK "UUID"
    VARCHAR(50) username "Unique"
    VARCHAR(100) email "Unique"
    VARCHAR(255) password
    ENUM role "SUPER | MODERATOR"
    ENUM deleted "Y | N"
    TIMESTAMP register_dtm
    VARCHAR(100) register_user
    TIMESTAMP update_dtm
    VARCHAR(100) update_user
  }

  t_refresh_token {
    CHAR(36) id PK "UUID"
    ENUM owner_type "USER | ADMIN"
    CHAR(36) owner_id "UUID"
    VARCHAR(512) token
    TIMESTAMP expires_at
    ENUM revoked "Y | N"
    TIMESTAMP register_dtm
    VARCHAR(100) register_user
    TIMESTAMP update_dtm
    VARCHAR(100) update_user
  }

  t_attachment_file {
    CHAR(36) id PK "UUID"
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
    CHAR(36) id PK "UUID"
    CHAR(36) user_id FK
    VARCHAR(150) title
    TEXT content
    ENUM deleted "Y | N"
    TIMESTAMP register_dtm
    VARCHAR(100) register_user
    TIMESTAMP update_dtm
    VARCHAR(100) update_user
  }

  t_comment {
    CHAR(36) id PK "UUID"
    CHAR(36) post_id FK
    CHAR(36) user_id FK
    TEXT content
    ENUM deleted "Y | N"
    TIMESTAMP register_dtm
    VARCHAR(100) register_user
    TIMESTAMP update_dtm
    VARCHAR(100) update_user
  }

  tr_post_attachment_file {
    CHAR(36) attachment_file_id FK
    CHAR(36) post_id FK
  }

  t_user ||--o{ t_post : "Writes"
  t_user ||--o{ t_comment : "Writes"
  t_post ||--o{ t_comment : "Contains"
  t_post ||--o{ tr_post_attachment_file : "Has"
  t_attachment_file ||--o{ tr_post_attachment_file : "Attached To"

```