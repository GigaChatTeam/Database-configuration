CREATE FUNCTION public.validate_ttoken (sourse_client BIGINT, sourse_token TEXT, sourse_intentions TEXT[])
RETURNS BOOLEAN AS $$
BEGIN
    IF EXISTS (
        SELECT *
        FROM public.ttokens
        WHERE
            client = sourse_client AND
            intentions = sourse_intentions AND
            token = sourse_token AND
            blocked IS NULL
    ) THEN
        UPDATE public.ttokens
        SET
            blocked = now(),
            reason = 'TOKEN WAS USED'
        WHERE
            CTID IN (
                SELECT CTID
                FROM public.ttokens
                WHERE
                    client = 5 AND
                    intentions = ARRAY ['LOAD', 'HISTORY'] AND
                    token = 'token324' AND
                    blocked IS NULL
                ORDER BY
                    blocked ASC
                LIMIT 1
            )
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END
$$ LANGUAGE plpgsql;


CREATE FUNCTION public.clear_ttokens ()
RETURNS VOID AS $$
BEGIN
    DELETE FROM public.ttokens
    WHERE
        blocked + '24 H'::INTERVAL < now();
END
$$ LANGUAGE plpgsql;


CREATE FUNCTION public.clear_ttokens (sourse_client BIGINT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM public.ttokens
    WHERE
        blocked + '24 H'::INTERVAL < now() AND
        client = sourse_client;
END
$$ LANGUAGE plpgsql;
