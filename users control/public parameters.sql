CREATE TABLE users.profiles (
    client BIGINT NOT NULL,
    username TEXT NOT NULL,
    nickname TEXT,
    fast_avatar BYTEA,
    avatars BIGINT[],
    description TEXT,
    FOREIGN KEY (client) REFERENCES users.accounts (id),
    FOREIGN KEY (username) REFERENCES users.accounts (username)
);

CREATE TABLE users.settings (
    client BIGINT NOT NULL,
    privacy JSONB, -- TODO
    FOREIGN KEY (client) REFERENCES users.accounts (id)
);
