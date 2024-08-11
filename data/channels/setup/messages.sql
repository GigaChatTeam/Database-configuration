CREATE TABLE "channels"."messages" (
    "id" BIGINT PRIMARY KEY DEFAULT "snowflake"."nextval"(),
    "channel-id" BIGINT
        NOT NULL,
    "author-id" BIGINT
        NOT NULL,
    "created-at" TIMESTAMP WITHOUT TIME ZONE
        NOT NULL
        DEFAULT TIMEZONE('UTC', now()),
    "text" TEXT
        NOT NULL,
    "answer-to" BIGINT,
    CONSTRAINT "channels.messages-FK-channelID" FOREIGN KEY ("channel-id") REFERENCES "channels"."index" ("id"),
    CONSTRAINT "channels.messages-FK-authorID" FOREIGN KEY ("author-id") REFERENCES "users"."accounts" ("id"),
    CONSTRAINT "channels.messages-SFK-answerTo" FOREIGN KEY ("channel-id", "answer-to") REFERENCES "channels"."messages" ("channel-id", "id")
);
