CREATE FUNCTION channels.join_user (target_client BIGINT, target_channel BIGINT, invitation TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM channels.invitations
        WHERE
            channel = target_channel AND
            uri = invitation
    ) THEN
        INSERT INTO channels.users (client, channel, joined, join_reason)
        VALUES (target_client, target_channel, now(), format('INVATION %s', invitation));

        INSERT INTO channels.messages (channel, posted, author, alias, type, data)
        VALUES (target_channel, now(), target_client, 'SYSTEM', 'SYSTEM', '@events/system/channels/users/join');

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
RETURNS VOID AS $$
BEGIN
    INSERT INTO channels.messages (channel, posted, author, type, data)
    VALUES (target_channel, now(), client, 'TEXT MESSAGE', message);
END;
$$ LANGUAGE plpgsql;