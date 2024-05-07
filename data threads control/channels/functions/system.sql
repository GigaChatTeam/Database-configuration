CREATE FUNCTION "channels"."create" (
    "owner" BIGINT,
    "title" TEXT,
    "description" TEXT,
    "is-public" BOOLEAN
)
RETURNS BIGINT AS $$
DECLARE
    "channel-id" BIGINT;
BEGIN
    INSERT INTO
        "channels"."index" (
            "owner",
            "title",
            "description",
            "created",
            "public"
        )
    VALUES
        ("owner", "title", "description", TIMEZONE('UTC', now()), "is-public")
    RETURNING "id" INTO "channel-id";

    INSERT INTO
        "channels"."users" (
            "client",
            "channel",
            "status"
        )
    VALUES
        ("owner", "channel-id", 1);

    INSERT INTO
        "channels"."groups" (
            "channel",
            "primacy",
            "denomination"
        )
    VALUES
        ("channel-id", 32767, 'owner'),
        ("channel-id", 0, 'everyone');

    INSERT INTO
        "channels"."users2groups" (
            "channel",
            "primacy",
            "client"
        )
    VALUES
        ("channel-id", 32767, "owner"),
        ("channel-id", 0, "owner");

    EXECUTE format('
        CREATE SEQUENCE "channels"."channel-%s_messages"
            AS BIGINT
            INCREMENT BY 1
            MINVALUE 1
            NO MAXVALUE
            START WITH 1
            NO CYCLE
    ', "channel-id"::TEXT);

    RETURN "channel-id";
END;
$$ LANGUAGE plpgsql;
