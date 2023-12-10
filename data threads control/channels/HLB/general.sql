CREATE FUNCTION channels.select_channels (source_client BIGINT)
RETURNS SETOF RECORD AS $$
BEGIN
    RETURN QUERY
        SELECT DISTINCT
            channels."index"."id",
            channels."index".title,
            channels."index".description,
            channels."index".avatar,
            EXTRACT ( EPOCH FROM channels."index".created ) AS "created",
            channels."index".enabled
        FROM channels."index"
        JOIN
            channels.users ON channels."index"."id" = channels.users.channel
        WHERE
            channels.users.leaved IS NULL AND
            channels.users.client = source_client;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION channels.validate_select_messages (source_channel BIGINT, source_client BIGINT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT *
        FROM channels."index"
        JOIN
            channels.users ON channels."index"."id" = channels.users.channel
        WHERE
            channels.users.leaved IS NULL AND
            channels.users.client = source_client AND
            channels."index"."id" = source_channel
    );
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION channels.select_messages_asc (source_channel BIGINT, messages_start TIMESTAMP, messages_end TIMESTAMP, messages_limit INTEGER, messages_offset INTEGER)
RETURNS SETOF RECORD AS $$
BEGIN
    RETURN QUERY
        SELECT
            EXTRACT ( EPOCH FROM "index".posted ) AS "posted",
            "index".author,
            "index".alias,
            "index".type,
            channels.select_message_media_attachments (
                "index".channel,
                "index".posted,
                1::SMALLINT
            ),
            data.data,
            MAX(data.version) <> 1,
            channels.select_message_files_attachments (
                "index".channel,
                "index".posted,
                1::SMALLINT
            )
        FROM
            channels.messages "index"
        LEFT JOIN
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
            "index".channel,
            "index"."posted",
            "index".author,
            "index".alias,
            "index".type,
            data.data
        ORDER BY
            "index".posted ASC
        LIMIT messages_limit
        OFFSET messages_offset;
    RETURN;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION channels.select_messages_desc (source_channel BIGINT, messages_start TIMESTAMP, messages_end TIMESTAMP, messages_limit INTEGER, messages_offset INTEGER)
RETURNS SETOF RECORD AS $$
BEGIN
    RETURN QUERY
        SELECT
            EXTRACT ( EPOCH FROM "index".posted ) AS "posted",
            "index".author,
            "index".alias,
            "index".type,
            channels.select_message_media_attachments (
                "index".channel,
                "index".posted,
                1::SMALLINT
            ),
            data.data,
            MAX(data.version) <> 1,
            channels.select_message_files_attachments (
                "index".channel,
                "index".posted,
                1::SMALLINT
            )
        FROM
            channels.messages "index"
        LEFT JOIN
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
            "index".channel,
            "index"."posted",
            "index".author,
            "index".alias,
            "index".type,
            data.data
        ORDER BY
            "index".posted DESC
        LIMIT messages_limit
        OFFSET messages_offset;
    RETURN;
END;
$$ LANGUAGE plpgsql;