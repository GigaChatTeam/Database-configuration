CREATE TABLE "channels"."permissions" (
    "permission-id" SMALLINT
        PRIMARY KEY,
    "default-value" BOOLEAN
        NOT NULL,
    FOREIGN KEY ("permission-id")
        REFERENCES "guides"."permissions" ("id")
)

CREATE TABLE "channels"."users-permissions" (
    "channel" BIGINT
        NOT NULL,
    "client" BIGINT
        NOT NULL,
    "permission-id" SMALLINT
        NOT NULL,
    "status" BOOLEAN,
    PRIMARY KEY ("channel", "client", "permission-id"),
    FOREIGN KEY ("channel", "client")
        REFERENCES "channels"."users" ("channel", "client")
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY ("permission-id")
        REFERENCES "channels"."permissions" ("permission-id")
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE "channels"."groups-permissions" (
    "channel" BIGINT
        NOT NULL,
    "primacy" SMALLINT
        NOT NULL,
    "permission-id" SMALLINT
        NOT NULL,
    status BOOLEAN,
    PRIMARY KEY ("channel", "primacy", "permission-id"),
    FOREIGN KEY ("channel", "primacy")
        REFERENCES "channels"."groups" ("channel", "primacy")
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY ("permission-id")
        REFERENCES "channels"."permissions" ("permission-id")
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);