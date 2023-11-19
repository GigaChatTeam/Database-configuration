CREATE FUNCTION channels.select_channels (source_client BIGINT, ttoken TEXT)
RETURNS SETOF RECORD AS $$
BEGIN
    IF users.validate_ttoken(source_client, ttoken, ARRAY ['LOAD', 'CHANNELS'])
    THEN
        RETURN QUERY
            SELECT DISTINCT
                channels."index"."id",
                channels."index".title,
                channels."index".description,
                channels."index".avatar,
                channels."index".links,
                channels."index".created,
                channels."index".enabled
            FROM channels."index"
            JOIN channels.users ON channels."index"."id" = channels.users.channel
            WHERE
                channels.users.leaved IS NULL AND
                channels.users.client = source_client;
        IF NOT FOUND
        THEN
           RETURN QUERY SELECT 0::BIGINT, 'SYSTEM', 'SYSTEM', 0::BIGINT, ARRAY ['SYSTEM'], now()::TIMESTAMP, FALSE;
        END IF;
    END IF;
    RETURN;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION channels.select_messages (source_client BIGINT, source_channel BIGINT, messages_start TIMESTAMP, messages_end TIMESTAMP, messages_limit INTEGER, messages_offset INTEGER, ttoken TEXT)
RETURNS SETOF RECORD AS $$
BEGIN
    IF users.validate_ttoken(source_client, ttoken, ARRAY ['LOAD', 'CHANNELS', 'MESSAGES', source_channel::TEXT])
    THEN
        RETURN QUERY
            SELECT
                "index".posted,
                "index".author,
                "index".alias,
                "index".type,
                data.data,
                data.attachments,
                MAX(data.version) <> 1
            FROM
                channels.messages "index"
            JOIN
                channels.messages_data data
                ON
                    "index".channel = data.channel AND
                    "index".posted = data.original
            WHERE
                data.version = (
                    SELECT MAX(version)
                    FROM channels.messages_data
                    WHERE
                        channels.messages_data.channel = "index".channel AND
                        channels.messages_data.original = "index".posted
                ) AND
                "index".channel = source_channel AND
                "index".posted > messages_start AND
                "index".posted < messages_end
            GROUP BY
                "index".posted,
                "index".author,
                "index".alias,
                "index".type,
                data.data,
                data.attachments
            ORDER BY
                "index".posted DESC
            LIMIT messages_limit
            OFFSET messages_offset;
        IF NOT FOUND
        THEN
            RETURN QUERY
                SELECT '01-01-1970'::TIMESTAMP, 0::BIGINT, 'SYSTEM', 'SYSTEM', 'SYSTEM', NULL, FALSE;
        END IF;
    END IF;
    RETURN;
END;
$$ LANGUAGE plpgsql;
