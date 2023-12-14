CREATE TABLE users.tokens (
    client BIGINT NOT NULL,
    agent TEXT NOT NULL,
    secret TEXT NOT NULL,
    key TEXT NOT NULL,
    start TIMESTAMP NOT NULL DEFAULT now(),
    PRIMARY KEY (client, key),
    FOREIGN KEY (client) REFERENCES users.accounts ("id")
);

CREATE TABLE users.logins (
    client BIGINT NOT NULL,
    key TEXT NOT NULL,
    login TIMESTAMP NOT NULL,
    duration INTERVAL,
    agent TEXT,
    successfully BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (client) REFERENCES users.accounts ("id")
);
