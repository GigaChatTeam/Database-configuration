CREATE TABLE servers."index" (
    type TEXT[] NOT NULL,
    id UUID NOT NULL DEFAULT public.uuid_generate_v4() PRIMARY KEY
)


-- These are some of the services that I want to teach clients to contact directly. I will describe it in more detail later in the README. Please don't hit(
INSERT INTO servers."index" (type, id)
VALUES
    (ARRAY ['EXTERNAL', 'STORAGE', 'GIT', 'GITHUB'], '{99CD2175-108D-1575-88C0-4758296D1CFC}'::UUID),
    (ARRAY ['EXTERNAL', 'STORAGE', 'DISK', 'GOOGLE'], '{5F11CE94-2F92-F5DE-D4AD-303319785CF3}'::UUID)
