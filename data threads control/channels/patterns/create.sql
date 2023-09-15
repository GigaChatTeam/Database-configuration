CREATE TABLE channels.users_%d (
    id INTEGER NOT NULL,
    join_date TIMESTAMP NOT NULL,
    join_reason JSONB,
    left_date TIMESTAMP,
    left_reason JSONB,
    FOREIGN KEY (client) REFERENCES public.accounts (id)
)

CREATE TABLE channels.messages_%d (
    id BIGSERIAL PRIMARY KEY,
    author INTEGER NOT NULL,
    type CHAR(8) NOT NULL,
    text_content TEXT,
    bytea_content BYTEA,
    attachments INTEGER[],
    response_to INTEGER,
    forwarding_from INTEGER[3],
    user_time TIMESTAMP,
    server_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client) REFERENCES public.accounts (id)
)

CREATE TABLE channels.permissions_%d (
    client INTEGER NOT NULL DEFAULT 0,
    permission INTEGER[4] NOT NULL,
    status BOOLEAN,
    FOREIGN KEY (client) REFERENCES public.accounts (id),
    FOREIGN KEY (permission) REFERENCES public.permissions (id)
)

CREATE TABLE channels.logs_%d (
    server_time TIMESTAMP,
    db_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data JSON
)