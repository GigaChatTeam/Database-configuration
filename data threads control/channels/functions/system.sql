CREATE FUNCTION channels."create" (owner BIGINT, title TEXT)
RETURNS BIGINT AS $$
DECLARE
    channel_id BIGINT;
    selected_time TIMESTAMP = now();
BEGIN
    INSERT INTO channels."index" (owner, title, created)
    VALUES (owner, title, selected_time)
    RETURNING id INTO channel_id;

    INSERT INTO channels.users (client, channel, joined, join_reason)
    VALUES
        (1, channel_id, selected_time, 'CREATE CHANNEL'),
        (owner, channel_id, selected_time + '5 ms'::INTERVAL, 'CREATE CHANNEL');

    INSERT INTO channels.messages (channel, posted, author, alias, type)
    VALUES
        (channel_id, selected_time, 0, public.uuid_nil(), 'SYSTEM'),
        (channel_id, selected_time + '5 ms'::INTERVAL, owner, public.uuid_nil(), 'SYSTEM');

    INSERT INTO channels.messages_data (channel, original, edited, data, version)
    VALUES
        (channel_id, selected_time, selected_time, '@events/system/channels/create', 1),
        (channel_id, selected_time + '5 ms'::INTERVAL, selected_time + '5 ms'::INTERVAL, '@events/system/channels/create', 1);

    RETURN channel_id;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION channels.is_client_in_channel (target_client BIGINT, target_channel BIGINT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM channels.users
        WHERE
            client = target_client AND
            channel = target_channel AND
            leaved IS NULL
    );
END;
$$ LANGUAGE plpgsql;
