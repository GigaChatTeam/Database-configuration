CREATE TABLE public.permissions (
    id SMALLINT PRIMARY KEY,
    reference TEXT,
    description TEXT,
    is_administration BOOLEAN
)
