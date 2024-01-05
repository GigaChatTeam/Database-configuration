CREATE TABLE public.permissions (
    id SMALLINT PRIMARY KEY,
    default_value BOOLEAN NOT NULL
)

CREATE TABLE public.permissions_descriptions (
    id SMALLINT PRIMARY KEY,
    reference TEXT,
    description TEXT,
    FOREIGN KEY (id) REFERENCES public.permissions (id)
)
