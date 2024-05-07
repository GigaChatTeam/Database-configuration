CREATE TABLE "channels"."groups" (
    "channel" BIGINT
        NOT NULL,
    "primacy" SMALLINT
        NOT NULL,
    "denomination" TEXT
        NOT NULL,
    PRIMARY KEY ("channel", "primacy"),
    FOREIGN KEY ("channel")
        REFERENCES "channels"."index" ("id")
);

CREATE TABLE "channels"."users2groups" (
    "channel" BIGINT
        NOT NULL,
    "primacy" SMALLINT
        NOT NULL,
    "client" BIGINT
        NOT NULL,
    PRIMARY KEY ("client", "channel", "primacy"),
    FOREIGN KEY ("channel", "client")
        REFERENCES "channels"."users" ("channel", "client")
        ON DELETE CASCADE,
    FOREIGN KEY ("channel", "primacy")
        REFERENCES "channels"."groups" ("channel", "primacy")
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
