CREATE FUNCTION channels.post_message_new_text (target_client BIGINT, client_alias UUID, target_channel BIGINT, message TEXT, media_attachments BIGINT[][], files_attachaments BIGINT[])
RETURNS TIMESTAMP AS $$
BEGIN
    INSERT INTO channels.messages (channel, posted, author, alias, "type")
    VALUES (target_channel, TIMEZONE('UTC', now()), target_client, client_alias, 'TEXT');

    INSERT INTO channels.messages_data (channel, original, edited, "data", version)
    VALUES (target_channel, TIMEZONE('UTC', now()), TIMEZONE('UTC', now()), message, 1);

    IF media_attachments IS NOT NULL
    THEN
        FOR i IN 1..ARRAY_LENGTH(media_attachments, 1)
        LOOP
            INSERT INTO channels.messages_attachments_media (channel, original, file, x, y)
            VALUES (target_channel, TIMEZONE('UTC', now()), media_attachments[i][1],
                ARRAY [ media_attachments[i][2]::SMALLINT, media_attachments[i][3]::SMALLINT ],
                ARRAY [ media_attachments[i][4]::SMALLINT, media_attachments[i][5]::SMALLINT ]);
        END LOOP;
    END IF;

    IF files_attachaments IS NOT NULL
    THEN
        FOR i IN 1..ARRAY_LENGTH(files_attachaments, 1)
        LOOP
            INSERT INTO channels.messages_attachments_files (channel, original, file, position)
            VALUES (target_channel, TIMEZONE('UTC', now()), files_attachaments[i], i);
        END LOOP;
    END IF;

    RETURN TIMEZONE('UTC', now());
END;
$$ LANGUAGE plpgsql;
