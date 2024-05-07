CREATE TABLE "channels"."invitations" (
    "uri" TEXT
        PRIMARY KEY,
    "channel" BIGINT
        NOT NULL,
    "creator" BIGINT
        NOT NULL,
    "created" TIMESTAMP WITHOUT TIME ZONE
        NOT NULL
        DEFAULT TIMEZONE('UTC', now()),
    "expiration" TIMESTAMP WITHOUT TIME ZONE,
    "permitted-uses" INTEGER,
    "total-uses" INTEGER
        NOT NULL
        DEFAULT 0,
    "enabled" BOOLEAN
        NOT NULL
        DEFAULT TRUE,
    FOREIGN KEY ("creator")
        REFERENCES "users"."accounts" ("id"),
    FOREIGN KEY ("channel")
        REFERENCES "channels"."index" ("id"),
    CHECK ("permitted-uses" >= "total-uses")
);

SELECT "channels"."create-invitation"('penis'::TEXT, 2, 2, NULL, NULL)

COMMIT