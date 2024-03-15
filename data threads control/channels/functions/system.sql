CREATE OR REPLACE FUNCTION "channels"."create" ("owner" BIGINT, "title" TEXT, "is_public" BOOLEAN)
RETURNS BIGINT AS $$
DECLARE
    "channel_id" BIGINT;
BEGIN
    INSERT INTO
        "channels"."index" (
            "owner",
            "title",
            "created",
            "public"
        )
    VALUES
        ("owner", "title", TIMEZONE('UTC', now()), "is_public")
    RETURNING "id" INTO "channel_id";

    INSERT INTO
        "channels"."users" (
            "client",
            "channel",
            "status"
        )
    VALUES
        ("owner", "channel_id", 1);

    EXECUTE format('
        CREATE SEQUENCE channels.channel_%s_messages_ids_sequence
            AS BIGINT
            INCREMENT BY 1
            MINVALUE 1
            NO MAXVALUE
            START WITH 2
            NO CYCLE
    ', "channel_id"::TEXT);

    RETURN "channel_id";
END;
$$ LANGUAGE plpgsql;




SELECT * FROM channels."index"