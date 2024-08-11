CREATE TABLE "channels"."users" (
    "channel-id" BIGINT
        NOT NULL,
    "user-id" BIGINT
        NOT NULL,
    PRIMARY KEY ("channel-id", "user-id"),
    CONSTRAINT "channels.users-FK-channelID" FOREIGN KEY ("channel-id") REFERENCES "channels"."index" ("id"),
    CONSTRAINT "channels.users-FK-userID" FOREIGN KEY ("user-id") REFERENCES "users"."accounts" ("id")
);
