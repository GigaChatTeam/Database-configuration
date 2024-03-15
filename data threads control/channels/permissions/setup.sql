CREATE TABLE channels.permissions (
    "id" SMALLINT PRIMARY KEY,
    "default_value" BOOLEAN NOT NULL,
    FOREIGN KEY ("id") REFERENCES "public"."permissions" ("id")
        ON DELETE CASCADE
        ON UPDATE CASCADE
)

CREATE TABLE channels.users_permissions (
    "client" BIGINT NOT NULL,
    "channel" BIGINT NOT NULL,
    "permission" BIGINT NOT NULL,
    "status" BOOLEAN,
    PRIMARY KEY ("client", "channel", "permission"),
    FOREIGN KEY ("client") REFERENCES "users"."accounts" ("id"),
    FOREIGN KEY ("channel") REFERENCES "channels"."index" ("id"),
    FOREIGN KEY ("permission") REFERENCES "public"."permissions" ("id")
        ON DELETE RESTRICT
        ON UPDATE CASCADE
)