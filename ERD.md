``` mermaid
erDiagram

  t_user {
    CHAR(36) id PK "UUID"
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

  t_board {
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
    CHAR(36) board_id FK
    CHAR(36) user_id FK
    TEXT content
    ENUM deleted "Y | N"
    TIMESTAMP register_dtm
    VARCHAR(100) register_user
    TIMESTAMP update_dtm
    VARCHAR(100) update_user
  }

  t_user ||--o{ t_board : "Writes"
  t_user ||--o{ t_comment : "Writes"
  t_board ||--o{ t_comment : "Contains"

```