CREATE TABLE public.permissions (
    id SMALLINT PRIMARY KEY,
    reference TEXT NOT NULL,
    default_value BOOLEAN NOT NULL
)
