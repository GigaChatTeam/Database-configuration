CREATE FUNCTION channels.join_user (target_client BIGINT, target_channel BIGINT, invitation TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    selected_time TIMESTAMP = now();
BEGIN
    IF EXISTS (
        SELECT 1
        FROM channels.invitations
        WHERE
            channel = target_channel AND
            uri = invitation
    ) THEN
        INSERT INTO channels.users (client, channel, joined, join_reason)
        VALUES (target_client, target_channel, selected_time, format('INVATION %s', invitation));

        INSERT INTO channels.messages (channel, posted, author, alias, type)
        VALUES (target_channel, selected_time, target_client, 'SYSTEM', 'SYSTEM');

        INSERT INTO channels.messages_data (channel, original, edited, data)
        VALUES (target_channel, selected_time, selected_time, '@events/system/channels/users/join');

        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION channels.leave_user (client BIGINT, target_channel BIGINT)
RETURNS BOOLEAN AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM channels.users
        WHERE
            channel = target_channel AND
            leaved IS NOT NULL
    ) THEN
        UPDATE channels.users
        SET
            leaved = now(),
            leave_reason = 'LEAVE'
        WHERE
            channel = target_channel AND
            leaved IS NULL;

        INSERT INTO channels.messages (channel, posted, author, alias, type, data)
        VALUES (target_channel, now(), client, 'SYSTEM', 'SYSTEM', '@events/system/channels/users/leave');

        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION channels.post_message_new (client BIGINT, target_channel BIGINT, message TEXT)
RETURNS TIMESTAMP AS $$
DECLARE
    selected_time TIMESTAMP = now();
BEGIN
    INSERT INTO channels.messages (channel, posted, author, type)
    VALUES (target_channel, selected_time, client, 'TEXT MESSAGE');

    INSERT INTO channels.messages_data (channel, original, edited, data, version)
    VALUES (target_channel, selected_time,  selected_time, message, 1);

    RETURN selected_time;
END;
$$ LANGUAGE plpgsql;
