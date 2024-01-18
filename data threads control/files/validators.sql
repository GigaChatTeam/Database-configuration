CREATE FUNCTION channels.validate_files_attachments (target_client BIGINT, target_attachments BIGINT[])
RETURNS BOOLEAN AS $$
    SELECT ARRAY(
        SELECT
            files."index"."id"
        FROM
            files."index"
        WHERE
            files."index"."owner" = target_client AND
            files."index"."status" >= 1 AND -- temporary value || attachment prepared for download
            files."index"."access" >= 1 -- temporary value || "attachment" access
    ) @> target_attachments
$$ LANGUAGE sql;
