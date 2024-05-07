CREATE FUNCTION "channels"."create-invitation" (
    "selected-uri" TEXT,
    "target-channel" BIGINT,
    "target-owner" BIGINT,
    "selected-expiration" TIMESTAMP WITHOUT TIME ZONE,
    "selected-permitted-uses" INTEGER)
RETURNS VOID AS $$
    INSERT INTO
        "channels"."invitations" (
            "uri",
            "channel",
            "creator",
            "created",
            "permitted-uses",
            "expiration",
            "total-uses",
            "enabled"
        )
    VALUES
        ("selected-uri", "target-channel", "target-owner", TIMEZONE('utc', now()), 0, "selected-expiration", 0, TRUE)
$$ LANGUAGE sql;

CREATE FUNCTION "channels"."delete-invitation" ("invitation-uri" TEXT)
RETURNS VOID AS $$
    UPDATE
        "channels"."invitations"
    SET
        "enabled" = FALSE
    WHERE
        "channels"."invitations"."uri" = "invitation-uri"
$$ LANGUAGE sql;
