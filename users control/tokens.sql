CREATE TABLE users.tokens (
    client BIGINT NOT NULL,
    agent TEXT NOT NULL,
    secret TEXT NOT NULL,
    key TEXT NOT NULL,
    start TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT TIMEZONE('UTC', now()),
    PRIMARY KEY (client, key),
    FOREIGN KEY (client) REFERENCES users.accounts ("id")
);
