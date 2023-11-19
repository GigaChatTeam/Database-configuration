CREATE TABLE attachments.files (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner BIGINT NOT NULL,
    bot BIGINT,
    upload TIMESTAMP NOT NULL DEFAULT now(),
    intentions TEXT[],
    size BIGINT,
    bucket TEXT NOT NULL,
    filename TEXT NOT NULL,
    path TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'EXPECTED',
    FOREIGN KEY (owner) REFERENCES users.accounts (id),
    FOREIGN KEY (bot) REFERENCES users.bots (client)
);

CREATE FUNCTION attachments.update_occupied()
RETURNS TRIGGER AS
$$
BEGIN
    UPDATE servers.files
    SET occupied = (
        SELECT SUM(size)
        FROM attachments.files
        WHERE
            status = 'STORED' AND
            storage = NEW.storage
    )
    WHERE
        id = NEW.storage;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER update_occupied
AFTER INSERT OR UPDATE ON attachments.files
FOR EACH ROW
EXECUTE FUNCTION attachments.update_occupied();

CREATE TABLE attachments.widgets (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner BIGINT NOT NULL,
    bot BIGINT,
    created TIMESTAMP NOT NULL DEFAULT now(),
    intentions TEXT[],
    data TEXT[] NOT NULL,
    status TEXT NOT NULL DEFAULT 'EXPECTED',
    FOREIGN KEY (owner) REFERENCES users.accounts (id),
    FOREIGN KEY (bot) REFERENCES users.bots (client)
);
