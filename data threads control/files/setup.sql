CREATE TABLE files."index" (
    "id" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "owner" BIGINT NOT NULL,
    bot BIGINT,
    upload TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT TIMEZONE('UTC', now()),
    "size" BIGINT,
    bucket TEXT NOT NULL,
    filename TEXT NOT NULL,
    path TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'EXPECTED',
    FOREIGN KEY ("owner") REFERENCES users.accounts ("id"),
    FOREIGN KEY (bot) REFERENCES users.bots (client)
);
