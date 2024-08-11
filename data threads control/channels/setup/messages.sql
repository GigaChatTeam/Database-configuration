CREATE TABLE "channels"."messages" (
    "id" BIGINT PRIMARY KEY DEFAULT "snowflake"."nextval"(),
    "channel-id" BIGINT
        NOT NULL
        CONSTRAINT "channels.messages-FK-channelID" FOREIGN KEY ("channel-id") REFERENCES "channels"."index" ("id"),
    "author-id" BIGINT
        NOT NULL
        CONSTRAINT "channels.messages-FK-authorID" FOREIGN KEY ("author-id") REFERENCES "users"."index" ("id"),
    "created-at" TIMESTAMP WITHOUT TIME ZONE
        NOT NULL
        DEFAULT TIMEZONE('UTC', now())
    "text" TEXT
        NOT NULL,
    "answer-to" BIGINT,
    CONSTRAINT "channels.messages-SFK-answerTo" FOREIGN KEY ("channel-id", "answer-to") REFERENCES ("channel-id", "id")
);
