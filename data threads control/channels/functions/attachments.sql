CREATE OR REPLACE FUNCTION channels.select_message_media_attachments (source_channel BIGINT, source_message TIMESTAMP, source_version SMALLINT)
RETURNS BIGINT[][] AS $$
DECLARE
    size_x SMALLINT;
    size_y SMALLINT;
    result BIGINT[][];
    v SMALLINT[][2];
    b SMALLINT[2];
BEGIN
    SELECT
        MAX (x[2])
    FROM channels.messages_attachments_media
    WHERE
        channel = source_channel AND
        original = source_message AND
        version = source_version
    INTO size_x;

    SELECT
        MAX (y[2])
    FROM channels.messages_attachments_media
    WHERE
        channel = source_channel AND
        original = source_message AND
        version = source_version
    INTO size_y;

    IF (size_x IS NULL) OR (size_y IS NULL)
    THEN
        RETURN NULL;
    ELSE
        result := ARRAY(
            SELECT ARRAY(
                SELECT NULL
                FROM generate_series(1, size_x) _i
            )
            FROM generate_series(1, size_y) _j
        )::BIGINT[][];

        FOREACH v SLICE 1 IN ARRAY ARRAY(
            SELECT ARRAY(
                SELECT ARRAY[_i::SMALLINT, _j::SMALLINT]
                FROM generate_series(1, size_y) _j
            )
            FROM generate_series(1, size_x) _i
        )::SMALLINT[][][]
        LOOP
            FOREACH b SLICE 1 IN ARRAY v
            LOOP
                result[b[2]][b[1]] := (
                    SELECT file
                    FROM cells
                    WHERE
                        x[1] <= b[1] AND x[2] >= b[1] AND
                        y[1] <= b[2] AND y[2] >= b[2] AND
                        channel = source_channel AND
                        original = source_message AND
                        version = source_version
                );
            END LOOP;
        END LOOP;

        RETURN result;
    END IF;
END;
$$ LANGUAGE plpgsql;
