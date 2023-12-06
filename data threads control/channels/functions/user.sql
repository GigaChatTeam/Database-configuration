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
        UPDATE channels.invitations
        SET
            permitted_uses = COALESCE (permitted_uses, 0) + 1
        WHERE
            uri = invitation;

        INSERT INTO channels.users (client, channel, joined, join_reason)
        VALUES (target_client, target_channel, selected_time, format('INVATION %s', invitation));

        INSERT INTO channels.messages (channel, posted, author, alias, type)
        VALUES (target_channel, selected_time, target_client, public.uuid_nil(), 'SYSTEM');

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
        VALUES (target_channel, now(), client, public.uuid_nil(), 'SYSTEM', '@events/system/channels/users/leave');

        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION channels.post_message_new_text (client BIGINT, client_alias UUID, target_channel BIGINT, message TEXT, media_attachments BIGINT[][], files_attachaments BIGINT[])
RETURNS TIMESTAMP AS $$
DECLARE
    selected_time TIMESTAMP = now();
BEGIN
    INSERT INTO channels.messages (channel, posted, author, alias, type)
    VALUES (target_channel, selected_time, client, client_alias, 'TEXT');

    INSERT INTO channels.messages_data (channel, original, edited, data, version)
    VALUES (target_channel, selected_time, selected_time, message, 1);

    IF media_attachments IS NOT NULL
    THEN
        FOR i IN 1..ARRAY_LENGTH(media_attachments, 1)
        LOOP
            INSERT INTO channels.messages_attachments_media (channel, original, file, x, y)
            VALUES (target_channel, selected_time, media_attachments[i][1],
                ARRAY [ media_attachments[i][2]::SMALLINT, media_attachments[i][3]::SMALLINT ],
                ARRAY [ media_attachments[i][4]::SMALLINT, media_attachments[i][5]::SMALLINT ]);
        END LOOP;
    END IF;

    IF files_attachaments IS NOT NULL
    THEN
        FOR i IN 1..ARRAY_LENGTH(files_attachaments, 1)
        LOOP
            INSERT INTO channels.messages_attachments_files (channel, original, file, position)
            VALUES (target_channel, selected_time, files_attachaments[i], i);
        END LOOP;
    END IF;

    RETURN selected_time;
END;
$$ LANGUAGE plpgsql;

    RETURN selected_time;
END;
$$ LANGUAGE plpgsql;
