CREATE TABLE public.test_test (
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    type character varying(40),
    name character varying(50) NOT NULL,
    status boolean NOT NULL
);
