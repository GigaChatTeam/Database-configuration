CREATE TABLE "files"."index" (
    "id" BIGINT PRIMARY KEY DEFAULT "snowflake"."nextval"(),
    "owner-id" BIGINT
        NOT NULL,
    "declared" TIMESTAMP WITHOUT TIME ZONE
        NOT NULL
        DEFAULT TIMEZONE('UTC', now()),
    "uploaded" TIMESTAMP WITHOUT TIME ZONE,
    "bucket" TEXT
        NOT NULL,
    "path" TEXT
        NOT NULL,
    "deleted" BOOLEAN
        NOT NULL
        DEFAULT FALSE,
    CONSTRAINT "files.index-logic-uniqueStoragePath" UNIQUE ("bucket", "path")
);
