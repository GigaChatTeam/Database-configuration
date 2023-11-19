CREATE TABLE users.tokens (
    client BIGINT NOT NULL,
    agent TEXT NOT NULL,
    token TEXT NOT NULL,
    logins JSONB[],
    start TIMESTAMP NOT NULL,
    ending TIMESTAMP,
    FOREIGN KEY (client) REFERENCES users.accounts (id)
);

CREATE TABLE users.ttokens (
    client BIGINT NOT NULL,
    token TEXT NOT NULL,
    extradition TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    intentions TEXT[] NOT NULL,
    blocked TIMESTAMP,
    reason TEXT,
    comments TEXT[],
    FOREIGN KEY (client) REFERENCES users.accounts (id)
);
