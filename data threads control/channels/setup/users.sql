CREATE TABLE "channels"."users" (
    "channel" BIGINT
        NOT NULL,
    "client" BIGINT
        NOT NULL,
    PRIMARY KEY ("channel", "client"),
    FOREIGN KEY ("channel")
        REFERENCES "channels"."index" ("id"),
    FOREIGN KEY ("client")
        REFERENCES "users"."accounts" ("id")
);
