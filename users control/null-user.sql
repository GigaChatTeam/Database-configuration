INSERT INTO users.accounts ("id", username, password, created)
VALUES (0, 'system', 'password', '2023-09-01 11:00:00'::TIMESTAMP);

INSERT INTO users.aliases ("type", target, "id")
VALUES ('SYSTEM', 0, public.uuid_nil())
