CREATE TABLE users.profiles (
    client BIGINT UNIQUE NOT NULL,
    username TEXT NOT NULL,
    nickname TEXT,
    avatar BIGINT,
    description TEXT,
    version SMALLINT NOT NULL,
    PRIMARY KEY (client, version),
    FOREIGN KEY (client) REFERENCES users.accounts ("id"),
    FOREIGN KEY (avatar) REFERENCES files."index" (id)
);

CREATE TABLE users.settings (
    client BIGINT NOT NULL,
    privacy JSONB,
    FOREIGN KEY (client) REFERENCES users.accounts ("id")
);
