CREATE TABLE "channels"."invitations" (
    "uri-code" TEXT
        PRIMARY KEY,
    "channel-id" BIGINT
        NOT NULL
        CONSTRAINT "channels.invitations-FK-channelID" FOREIGN KEY ("channel-id") REFERENCES "channels"."index" ("id"),
    "creator-id" BIGINT
        NOT NULL
        CONSTRAINT "channels.invitations-FK-creatorID" FOREIGN KEY ("owner-id") REFERENCES "users"."accounts" ("id"),
    "created-at" TIMESTAMP WITHOUT TIME ZONE
        NOT NULL
        DEFAULT TIMEZONE('UTC', now()),
    "expiration-at" TIMESTAMP WITHOUT TIME ZONE,
    "permitted-uses" INTEGER,
    "total-uses" INTEGER
        NOT NULL
        CONSTRAINT "channels.invitations-logic-positiveTotalUses" CHECK ("permitted-uses" >= 0)
        DEFAULT 0,
    "enabled" BOOLEAN
        NOT NULL
        DEFAULT TRUE,
    CONSTRAINT "channels.invitations-logic-permittedUsesAboveTotalUses" CHECK ("permitted-uses" >= "total-uses")
);
