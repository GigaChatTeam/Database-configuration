CREATE TABLE "channels"."users" (
    "channel" BIGINT
        NOT NULL,
    "client" BIGINT
        NOT NULL,
    "status" SMALLINT
        NOT NULL
        DEFAULT 1, -- TODO: develop users status on channels system
    PRIMARY KEY ("channel", "client"),
    FOREIGN KEY ("channel")
        REFERENCES "channels"."index" ("id"),
    FOREIGN KEY ("client")
        REFERENCES "users"."accounts" ("id")
);

CREATE OR REPLACE VIEW "channels"."users2channels-withChannelMeta" AS
    SELECT
        "channels"."index"."id" AS "channel-id",
        "channels"."users"."client" AS "client-id",
        "channels"."users"."status" AS "client-status",
        "channels"."index"."title" AS "channel-title",
        "channels"."index"."description" AS "channel-description",
        "channels"."index"."public" AS "channel-public",
        "channels"."index"."enabled" AS "channel-enabled",
        "files"."index"."status" AS "channel-icon-status",
        "files"."index"."id" AS "channel-icon-id",
        "files"."index"."bucket" AS "channel-icon-bucket",
        "files"."index"."path" AS "channel-icon-path"
    FROM
        "channels"."index"
    JOIN
        "channels"."users"
        ON
            "channels"."users"."channel" = "channels"."index"."id"
    LEFT JOIN
        "files"."index"
        ON
            "files"."index"."id" = "channels"."index"."icon"
