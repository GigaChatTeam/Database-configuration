CREATE FUNCTION channels.select_channels (source_client BIGINT, ttoken TEXT)
RETURNS SETOF RECORD AS $$
BEGIN
    IF public.validate_ttoken(source_client, ttoken, ARRAY ['LOAD', 'CHANNELS'])
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
