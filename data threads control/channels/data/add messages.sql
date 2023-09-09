CREATE OR REPLACE FUNCTION
save_text_message(
    channel_id INT,
    author INT,
    text_content TEXT DEFAULT NULL,
    attachments INTEGER[] DEFAULT NULL,
    response_to INT DEFAULT NULL,
    user_time TIMESTAMP DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
    table_name TEXT := 'channels.messages_' || channel_id;
    inserted_id BIGINT;
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_name = table_name
    ) THEN
        EXECUTE format('INSERT INTO %I (
                author, type, text_content, attachments, response_to, user_time
            )
            VALUES ($1, "TEXTMESS", $3, $4, $5, $6)
            RETURNING id', table_name)
        INTO inserted_id
        USING author, text_content, attachments, response_to, user_time;

        RETURN inserted_id;
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
save_bytea_message(
    channel_id INT,
    author INT,
    bytea_content TEXT DEFAULT NULL,
    response_to INT DEFAULT NULL,
    user_time TIMESTAMP DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
    table_name TEXT := 'channels.messages_' || channel_id;
    inserted_id BIGINT;
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_name = table_name
    ) THEN
        EXECUTE format('INSERT INTO %I (
                author, type, bytea_content, response_to, user_time
            )
            VALUES ($1, "BYTEAMESS", $2, $3, $4)
            RETURNING id', table_name)
        INTO inserted_id
        USING author, bytea_content, response_to, user_time;

        RETURN inserted_id;
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
save_forwarded_message(
    channel_id INT,
    author INT,
    origin_channel INT DEFAULT NULL,
    origin_message TIMESTAMP DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
    table_name TEXT := 'channels.messages_' || channel_id;
    inserted_id BIGINT;
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_name = table_name
    THEN
        EXECUTE format('INSERT INTO %I (
                author, type, forwarding_from
            )
            VALUES ($1, "FORWARDE", $2)
            RETURNING id', table_name)
        INTO inserted_id
        USING author, response_to, {2, origin_channel, origin_message};

        RETURN inserted_id;
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;