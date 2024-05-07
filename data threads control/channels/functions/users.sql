CREATE FUNCTION "channels"."add-user" ("target-channel" BIGINT, "target-user" BIGINT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO
        "channels"."users" (
            "channel",
            "client",
            "status"
        )
    VALUES
        ("target-channel", "target-user", 1);

    INSERT INTO
        "channels"."users2groups" (
            "channel",
            "primacy",
            "client"
        )
    VALUES
        ("target-channel", 0, "target-user");
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION "channels"."join-user" ("target-user" BIGINT, "invitation-uri" TEXT)
RETURNS BIGINT AS $$
DECLARE
    "target-channel" BIGINT;
BEGIN
    SELECT
        "channels"."invitations"."channel"
    INTO
        "target-channel"
    FROM
        "channels"."invitations"
    WHERE
        "uri" = "invitation-uri";

    IF ("target-channel")
    THEN
        RETURN NULL;
    ELSE
        UPDATE
            "channels"."invitations"
        SET
            "total-uses" = "total-uses" + 1
        WHERE
            "uri" = "invitation-uri";

        SELECT "channels"."add-user"("target-channel", "target-user");

        RETURN "target-channel";
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION "channels"."remove-user" ("target-channel" BIGINT, "target-user" BIGINT)
RETURNS VOID AS $$
    DELETE FROM
        "channels"."users"
    WHERE
        "channels"."users"."channel" = "target-channel" AND
        "channels"."users"."client" = "target-user"
$$ LANGUAGE sql;
