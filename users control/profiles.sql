CREATE TABLE "users"."profiles" (
    "client" BIGINT PRIMARY KEY,
    "nickname" TEXT,
    "avatar" BIGINT,
    "description" TEXT,
    "version" SMALLINT NOT NULL DEFAULT 1,
    "status" SMALLINT NOT NULL DEFAULT 1,
    FOREIGN KEY ("client")
        REFERENCES "users"."accounts" ("id"),
    FOREIGN KEY ("avatar")
        REFERENCES "files"."index" ("id")
);
