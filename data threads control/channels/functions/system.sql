CREATE FUNCTION channels."create" ("owner" BIGINT, title TEXT)
RETURNS BIGINT AS $$
DECLARE
    channel_id BIGINT;
BEGIN
    INSERT INTO channels."index" ("owner", title, created)
    VALUES ("owner", title, TIMEZONE('UTC', now()))
    RETURNING "id" INTO channel_id;

    INSERT INTO channels.users (client, channel, joined, reason)
    VALUES
        (0, channel_id, TIMEZONE('UTC', now()), 'CREATE CHANNEL'),
        ("owner", channel_id, TIMEZONE('UTC', now()) + '5 ms'::INTERVAL, 'CREATE CHANNEL');

    INSERT INTO channels.messages (channel, posted, author, alias, "type")
    VALUES
        (channel_id, TIMEZONE('UTC', now()), 0, public.uuid_nil(), 'SYSTEM'),
        (channel_id, TIMEZONE('UTC', now()) + '5 ms'::INTERVAL, "owner", public.uuid_nil(), 'SYSTEM');

    INSERT INTO channels.messages_data (channel, original, edited, "data", version)
    VALUES
        (channel_id, TIMEZONE('UTC', now()), TIMEZONE('UTC', now()), '@events/system/channels/create', 1),
        (channel_id, TIMEZONE('UTC', now()) + '5 ms'::INTERVAL, TIMEZONE('UTC', now()) + '5 ms'::INTERVAL, '@events/system/channels/create', 1);

    RETURN channel_id;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION channels.is_client_in_channel (target_client BIGINT, target_channel BIGINT)
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT *
        FROM channels.users
        WHERE
            client = target_client AND
            channel = target_channel AND
            leaved IS NULL
    )
$$ LANGUAGE sql;
