--
-- PostgreSQL database dump
--

-- Dumped from database version 12.0 (Ubuntu 12.0-2.pgdg16.04+1)
-- Dumped by pg_dump version 12.0 (Ubuntu 12.0-2.pgdg16.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO polymath;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: polymath
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO polymath;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: polymath
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO polymath;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: polymath
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO polymath;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: polymath
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO polymath;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: polymath
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO polymath;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: polymath
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO polymath;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO polymath;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: polymath
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO polymath;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: polymath
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: polymath
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO polymath;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: polymath
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO polymath;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: polymath
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO polymath;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: polymath
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: customer_support_contactus; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.customer_support_contactus (
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(200) NOT NULL,
    subject character varying(200) NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.customer_support_contactus OWNER TO polymath;

--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO polymath;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: polymath
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO polymath;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: polymath
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO polymath;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: polymath
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO polymath;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: polymath
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO polymath;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: polymath
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO polymath;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: polymath
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO polymath;

--
-- Name: models_games; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.models_games (
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    name character varying(50) NOT NULL,
    status boolean NOT NULL,
    sport_id uuid NOT NULL
);


ALTER TABLE public.models_games OWNER TO postgres;

--
-- Name: models_mlalgorithms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.models_mlalgorithms (
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    name character varying(250) NOT NULL,
    access character varying(250),
    status boolean NOT NULL
);


ALTER TABLE public.models_mlalgorithms OWNER TO postgres;

--
-- Name: models_predictorvarriables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.models_predictorvarriables (
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    name character varying(250) NOT NULL,
    access character varying(250),
    status boolean NOT NULL,
    sport_id uuid NOT NULL
);


ALTER TABLE public.models_predictorvarriables OWNER TO postgres;

--
-- Name: models_sports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.models_sports (
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    name character varying(50) NOT NULL,
    status boolean NOT NULL
);


ALTER TABLE public.models_sports OWNER TO postgres;

--
-- Name: models_targetvarriables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.models_targetvarriables (
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    name character varying(50) NOT NULL,
    status boolean NOT NULL,
    sport_id uuid NOT NULL
);


ALTER TABLE public.models_targetvarriables OWNER TO postgres;

--
-- Name: orders_card; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.orders_card (
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    name character varying(30) NOT NULL,
    card_number character varying(16) NOT NULL,
    expiry_date date NOT NULL,
    card_provider character varying(30),
    card_logo character varying(100),
    status boolean NOT NULL,
    card_holder_id integer NOT NULL,
    cvv bigint
);


ALTER TABLE public.orders_card OWNER TO polymath;

--
-- Name: static_pages_post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.static_pages_post (
    id integer NOT NULL,
    video character varying(200)
);


ALTER TABLE public.static_pages_post OWNER TO postgres;

--
-- Name: static_pages_post_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.static_pages_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.static_pages_post_id_seq OWNER TO postgres;

--
-- Name: static_pages_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.static_pages_post_id_seq OWNED BY public.static_pages_post.id;


--
-- Name: users_privacypolicy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_privacypolicy (
    id integer NOT NULL,
    policy text
);


ALTER TABLE public.users_privacypolicy OWNER TO postgres;

--
-- Name: users_privacypolicy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_privacypolicy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_privacypolicy_id_seq OWNER TO postgres;

--
-- Name: users_privacypolicy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_privacypolicy_id_seq OWNED BY public.users_privacypolicy.id;


--
-- Name: users_profile; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.users_profile (
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    bio text NOT NULL,
    location character varying(30) NOT NULL,
    twitter character varying(100) NOT NULL,
    profile_pic character varying(100),
    user_id integer NOT NULL,
    stripe_customer_key character varying(100) NOT NULL,
    subscription_id character varying(100) NOT NULL,
    birth_date date,
    subscription_end_date date
);


ALTER TABLE public.users_profile OWNER TO polymath;

--
-- Name: users_subscriptionplan; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.users_subscriptionplan (
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    name character varying(30) NOT NULL,
    amount integer NOT NULL,
    status boolean NOT NULL,
    duration interval NOT NULL,
    plan_id character varying(200) NOT NULL
);


ALTER TABLE public.users_subscriptionplan OWNER TO polymath;

--
-- Name: users_usersubscriptionorder; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.users_usersubscriptionorder (
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    active boolean NOT NULL,
    subscription_plan_id uuid,
    user_id integer NOT NULL
);


ALTER TABLE public.users_usersubscriptionorder OWNER TO polymath;

--
-- Name: users_video; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_video (
    id integer NOT NULL,
    video text NOT NULL
);


ALTER TABLE public.users_video OWNER TO postgres;

--
-- Name: users_video_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_video_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_video_id_seq OWNER TO postgres;

--
-- Name: users_video_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_video_id_seq OWNED BY public.users_video.id;


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: static_pages_post id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.static_pages_post ALTER COLUMN id SET DEFAULT nextval('public.static_pages_post_id_seq'::regclass);


--
-- Name: users_privacypolicy id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_privacypolicy ALTER COLUMN id SET DEFAULT nextval('public.users_privacypolicy_id_seq'::regclass);


--
-- Name: users_video id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_video ALTER COLUMN id SET DEFAULT nextval('public.users_video_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add Subscription Plan	2	add_subscriptionplan
2	Can change Subscription Plan	2	change_subscriptionplan
3	Can delete Subscription Plan	2	delete_subscriptionplan
4	Can view Subscription Plan	2	view_subscriptionplan
5	Can add user subscription order	1	add_usersubscriptionorder
6	Can change user subscription order	1	change_usersubscriptionorder
7	Can delete user subscription order	1	delete_usersubscriptionorder
8	Can view user subscription order	1	view_usersubscriptionorder
9	Can add Profile	3	add_profile
10	Can change Profile	3	change_profile
11	Can delete Profile	3	delete_profile
12	Can view Profile	3	view_profile
13	Can add Card	4	add_card
14	Can change Card	4	change_card
15	Can delete Card	4	delete_card
16	Can view Card	4	view_card
17	Can add ml algorithms	7	add_mlalgorithms
18	Can change ml algorithms	7	change_mlalgorithms
19	Can delete ml algorithms	7	delete_mlalgorithms
20	Can view ml algorithms	7	view_mlalgorithms
21	Can add predictor varriables	8	add_predictorvarriables
22	Can change predictor varriables	8	change_predictorvarriables
23	Can delete predictor varriables	8	delete_predictorvarriables
24	Can view predictor varriables	8	view_predictorvarriables
25	Can add Games	6	add_games
26	Can change Games	6	change_games
27	Can delete Games	6	delete_games
28	Can view Games	6	view_games
29	Can add Sports	9	add_sports
30	Can change Sports	9	change_sports
31	Can delete Sports	9	delete_sports
32	Can view Sports	9	view_sports
33	Can add target varriables	5	add_targetvarriables
34	Can change target varriables	5	change_targetvarriables
35	Can delete target varriables	5	delete_targetvarriables
36	Can view target varriables	5	view_targetvarriables
37	Can add contact us	10	add_contactus
38	Can change contact us	10	change_contactus
39	Can delete contact us	10	delete_contactus
40	Can view contact us	10	view_contactus
41	Can add log entry	11	add_logentry
42	Can change log entry	11	change_logentry
43	Can delete log entry	11	delete_logentry
44	Can view log entry	11	view_logentry
45	Can add group	12	add_group
46	Can change group	12	change_group
47	Can delete group	12	delete_group
48	Can view group	12	view_group
49	Can add permission	14	add_permission
50	Can change permission	14	change_permission
51	Can delete permission	14	delete_permission
52	Can view permission	14	view_permission
53	Can add user	13	add_user
54	Can change user	13	change_user
55	Can delete user	13	delete_user
56	Can view user	13	view_user
57	Can add content type	15	add_contenttype
58	Can change content type	15	change_contenttype
59	Can delete content type	15	delete_contenttype
60	Can view content type	15	view_contenttype
61	Can add session	16	add_session
62	Can change session	16	change_session
63	Can delete session	16	delete_session
64	Can view session	16	view_session
100	Can add post	19	add_post
101	Can change post	19	change_post
102	Can delete post	19	delete_post
103	Can view post	19	view_post
104	Can add videos	20	add_videos
105	Can change videos	20	change_videos
106	Can delete videos	20	delete_videos
107	Can view videos	20	view_videos
108	Can add video	21	add_video
109	Can change video	21	change_video
110	Can delete video	21	delete_video
111	Can view video	21	view_video
112	Can add privacy policy	22	add_privacypolicy
113	Can change privacy policy	22	change_privacypolicy
114	Can delete privacy policy	22	delete_privacypolicy
115	Can view privacy policy	22	view_privacypolicy
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
4	pbkdf2_sha256$150000$KdA1xsIo8mBK$itjjqi99USTwohhVyE696BQxBKitYHRegp1Sa0qJJPg=	\N	f	aanoop@yopmail.com	Anoop Kumar		aanoop@yopmail.com	f	t	2019-09-17 19:26:17.809305+05:30
5	pbkdf2_sha256$150000$Zx0p4Ti6I1V8$85LPLlSDkSxiwqi1H3nm7WhxqOoIRE04f/KsXwtMysA=	\N	f	case@yopmail.com	ultacase		case@yopmail.com	f	t	2019-09-17 19:33:14.87387+05:30
6	pbkdf2_sha256$150000$f8Ub727nDlSC$IyIFuEUjhYK+nnfOmkFYtBLzkSjKutWVty7iegXLsPo=	2019-09-17 20:11:31.000912+05:30	f	test@yopmail.com	test		test@yopmail.com	f	t	2019-09-17 20:11:30.752779+05:30
7	pbkdf2_sha256$150000$7lz28oEeccCu$IvOKW1zDikXt0xS15MgaF4VV2U31kf2UJ80g8MkoHXU=	2019-09-18 11:16:14.264754+05:30	f	prateek@ava.c	prateek54555465		prateek@ava.c	f	t	2019-09-18 11:16:14.048716+05:30
3	pbkdf2_sha256$150000$kBDw5hnAGW5R$/N0l8ZioKdZneLsEz1t+VyfatTjKoeYlg8Rg64XK9Z0=	2019-09-17 19:24:14.045878+05:30	t	anoop	Anoop		anoop@yopmail.com	t	t	2019-09-17 19:23:50.113334+05:30
9	pbkdf2_sha256$150000$LjNIUwkzhkGw$S8Q2THFSSD1B/ZjnAewL7Fp9L3KKOwBlimcqRe412/o=	2019-09-20 15:56:19.532377+05:30	f	anoop1@yopmail.com	Anoop Kumar		anoop1@yopmail.com	f	t	2019-09-20 15:56:19.312426+05:30
11	pbkdf2_sha256$150000$dqImYXnBXRFN$zz2Zq1kXHpNMPqelAnYn2C8U8+weQ5DkLg6g6WixPC4=	2019-09-25 19:18:41.192405+05:30	f	prateek@avainfotech.com	Prateek Sharma		prateek@avainfotech.com	f	t	2019-09-20 17:26:13.762574+05:30
10	pbkdf2_sha256$150000$TEKXroIdJxzn$/TUCP2R8HNlqOfUopuF6hT67yGt9t3UfdIwx9uiCNpw=	2019-09-20 17:10:47.932433+05:30	f	oman@yopmail.com	oman		oman@yopmail.com	f	t	2019-09-20 17:10:47.706974+05:30
12	pbkdf2_sha256$150000$kFkbj16ukIef$OUHmPhdvl9w9fJ5yQ+Vm0AnsJ+OMPpWxLuouGnc5s0A=	\N	f	vikrant@avainfotech.com	vikrant		vikrant@avainfotech.com	f	f	2019-09-21 09:59:05.921593+05:30
31	pbkdf2_sha256$150000$UfsP3aYGTIRe$idjFGs0N3zX5O31JJ7CUuZdF/UNFhToMBVvQLJpOrCs=	\N	f	amansinghbawa19@gmail.com	aman		amansinghbawa19@gmail.com	f	f	2019-11-07 11:55:16.620715+05:30
14	pbkdf2_sha256$150000$w12pKEpCLaXP$rxjomBt9mlZaMwym8GX2sev+8QTHT6P2sRFPQdmwVrk=	2019-09-25 15:17:32.379106+05:30	t	admin				t	t	2019-09-24 18:55:26.559257+05:30
23	pbkdf2_sha256$150000$qteRRIUaeZIS$j1v4FttKUqsLTBNp94WawLu/PW7FPmd7wwzL5DBLkHc=	2019-10-02 19:22:03.998732+05:30	f	g_s_d@yahoo.com	Giani		g_s_d@yahoo.com	f	t	2019-10-02 19:20:10.339615+05:30
32	pbkdf2_sha256$150000$mLuKEzKWO8AQ$l1G6xe+MQ4++6TjSVaZFDvQNRvUAbjoMWU80FlgbkjM=	2019-11-07 12:14:21.972309+05:30	t	test@123				t	t	2019-11-07 12:01:59.239548+05:30
24	pbkdf2_sha256$150000$x04DxwT5eN2Y$INpazXCoVrgGsKaB0ZPqqhV7fa19J5kiI/3NMG0Bgcc=	\N	f	abc@gmail.com	gfsr		abc@gmail.com	f	f	2019-10-11 11:02:10.061065+05:30
25	pbkdf2_sha256$150000$AL7OdpA8dmyS$lJ8E5JDyd3PigGmie75v/nPWp8riNLS15cb3wZhAQh0=	\N	f	arronoliver2586@gmail.com	fTUVDZtIKMrcxXu		arronoliver2586@gmail.com	f	f	2019-10-15 00:21:36.883496+05:30
26	pbkdf2_sha256$150000$LUPGT0Bf9ZWh$ykEDT2i+CJiZAXIMbOVTVT5GTDgtD/HklyTGIZJ+Hhk=	\N	f	mario95pgonz@hotmail.es				f	t	2019-10-26 05:50:10.554222+05:30
13	pbkdf2_sha256$150000$oE8EAoDW1DQe$6M5elq0IMQMMS88PV7N42Mrgw2u/5JWVtzEVutrBDMM=	2019-10-29 16:21:19.696406+05:30	f	amansinghbawa@gmail.com	Aman Preet Singh		amansinghbawa@gmail.com	f	t	2019-09-21 15:25:16.002832+05:30
257	pbkdf2_sha256$150000$el7HaIRmmOjH$0DbLGPtgxIWz5ZtEkqoJGQ4FN/rZg0rM4uJbovGtizA=	2019-11-25 15:19:35.249541+05:30	f	nirupmadere@avainfotech.com	Akshma		nirupmadere@avainfotech.com	f	t	2019-11-25 15:18:40.540954+05:30
27	pbkdf2_sha256$150000$jKARuHFx0N2D$sgpcki3qdINu7Qd6z3cw9Ia3hpNKtfTutFbKd7bPC5Y=	2019-11-21 17:10:14.289912+05:30	f	nirupama@yopmail.com	nirupma		nirupama@yopmail.com	f	t	2019-11-05 12:57:32.470149+05:30
269	pbkdf2_sha256$150000$EsM4aypMHqBL$JBbgo0xPhKwg87c84kf2YtrZh/iywApGct3gbil5TVg=	\N	f	nirupmaggthhsdd@avainfotech.com	Akshma		nirupmaggthhsdd@avainfotech.com	f	f	2019-11-25 18:26:18.341897+05:30
170	pbkdf2_sha256$150000$8wB8irfCL7IB$2C8MjHjJsUDveG2ffAnwM9QwLMLadJlNmKY9PvA5yzM=	\N	f	akshmaTanwar@gmail.com	Akshma		akshmaTanwar@gmail.com	f	f	2019-11-20 12:27:28.281926+05:30
56	pbkdf2_sha256$150000$lSHYd2CIVVh0$vG0hYe/zFt/EthuMpBdjnfTe1esapWydmoqIUKKYbTI=	\N	f	niha@gmail.com	djcfhrg		niha@gmail.com	f	f	2019-11-14 17:30:51.706946+05:30
260	pbkdf2_sha256$150000$1fA9Pbd37U79$5stthSrMAJTUFfviQislBbB2boR5XYKsuMjJduf3m4w=	2019-11-25 15:31:18.356229+05:30	f	nirupmdssaddfe@avainfotech.com	Akshma		nirupmdssaddfe@avainfotech.com	f	t	2019-11-25 15:30:56.640003+05:30
22	pbkdf2_sha256$150000$5IvjwVjUZpXy$ov4L3ZueKjSY5yMGubFZ3qAAtHEYmRrCSlSTmt1QOI8=	2019-11-22 15:38:57.420656+05:30	f	shivi@avainfotech.com	shivi		shivi@avainfotech.com	f	t	2019-09-25 16:16:29.261638+05:30
68	pbkdf2_sha256$150000$abEThU0WspcX$eKbaus0AZgEHrYAv8/9U4Z60IzfxqAYMX4ZeZUAymcg=	\N	f	himanshu@gmail.com	Akshma		himanshu@gmail.com	f	f	2019-11-15 12:14:14.92955+05:30
182	pbkdf2_sha256$150000$xpL6uRFLWoJJ$YhCfF+YLILEFzr1erYhSb2llU+XDdcpUvITOmZivQHM=	\N	f	Akshmadcfkj@gmail.com	Akshma		Akshmadcfkj@gmail.com	f	f	2019-11-20 15:00:50.462676+05:30
197	pbkdf2_sha256$150000$CA131JJEk9Nz$s8enIx05eDixS1gvoZb032vDzavCBzpcsLcSkZJKA+s=	\N	f	azsxd@gmail.com	Akshma		azsxd@gmail.com	f	f	2019-11-20 16:09:22.643228+05:30
258	pbkdf2_sha256$150000$e5tdVZsYQotR$tkCp3fZMivIitBb/8uKZ6OmEtKFclmDC08WWoLgmutA=	\N	f	nirupmaddfe@avainfotech.com	Akshma		nirupmaddfe@avainfotech.com	f	f	2019-11-25 15:30:25.849191+05:30
261	pbkdf2_sha256$150000$tW0PEVrcnIM3$PfqyrbyFnOtclbkxj2iFk9whOuCR/s1X+PjacCStD4g=	2019-11-25 15:53:39.445471+05:30	f	nirupmarfgvde@avainfotech.com	Akshma		nirupmarfgvde@avainfotech.com	f	t	2019-11-25 15:53:08.800232+05:30
198	pbkdf2_sha256$150000$obBsmFSRFtu0$3xdgmJd9g218RNxuOVrG10tVrUWSERetymCxPh6Ym0w=	\N	f	afgfzsxd@gmail.com	Akshma		afgfzsxd@gmail.com	f	f	2019-11-20 16:11:20.96314+05:30
267	pbkdf2_sha256$150000$nOVQp4BQj0vB$ZS2K1oBu5scbGBCBshePxs9dubU2e4WVQ+kCifLOX4I=	\N	f	nirupmasdd@avainfotech.com	Akshma		nirupmasdd@avainfotech.com	f	f	2019-11-25 18:23:15.15837+05:30
270	pbkdf2_sha256$150000$W3VkO70MLtzK$gMymAV9W+oX0V0Ba+ujpp8CbLNGEZ8HEvDOAJp4Iqys=	\N	f	nirudfgfgpma@avainfotech.com	Akshma		nirudfgfgpma@avainfotech.com	f	f	2019-11-25 18:26:59.109045+05:30
42	pbkdf2_sha256$150000$xrnxROFMuUCB$EYft94qrehBAmQRZ3L3/4iF9ea0MStCeWWcbbSfquts=	\N	f	avantika@yopmail.com	avantika		avantika@yopmail.com	f	f	2019-11-13 17:51:34.640542+05:30
189	pbkdf2_sha256$150000$knYG6H2wn8Z5$8VKNLJ382sZuktRojqsWH+KknQVg2F9LZ5QNpBDH4Zo=	\N	f	cdssnirupma1234@gmail.com	ascxc		cdssnirupma1234@gmail.com	f	f	2019-11-20 15:21:14.417779+05:30
276	pbkdf2_sha256$150000$J33TxcVtyUyr$KytiTqqaqvHPgMZL70J27nUHeY43ZoLip7acR9BboZw=	2019-11-26 12:00:36.271336+05:30	f	nirupma@avainfotech.com	Akshma		nirupma@avainfotech.com	f	t	2019-11-26 12:00:17.136996+05:30
57	pbkdf2_sha256$150000$LApRvCK97llj$FF0yiEFH3FtlD0unbQgnWTvA/VTC/+3mxDc5GYvpyzA=	\N	f	minish@gmail.com	Akshma		minish@gmail.com	f	f	2019-11-14 18:59:21.547552+05:30
65	pbkdf2_sha256$150000$sNijz1w5lNn7$TXf1Yrr3rd+Pdbk9Q/7d0bCvqDf4BLTkZ4DKNs2VpY4=	\N	f	mahesh@gmail.com	mahesh		mahesh@gmail.com	f	f	2019-11-15 11:06:56.542923+05:30
69	pbkdf2_sha256$150000$jJO3dAOC2Wvp$gbW0dP1z3KEk47bLHKOnrymjYq1WkmMGmU/pxc4z8aM=	\N	f	himanshu3@gmail.com	Akshma		himanshu3@gmail.com	f	f	2019-11-15 12:14:55.069559+05:30
73	pbkdf2_sha256$150000$ze47Y30RAV12$u+7/nmlrlOHKQmlpGfnmu2V/3XUx8CG7hfINaVFnzPY=	\N	f	kallie@gmail.com	Akshma		kallie@gmail.com	f	f	2019-11-15 17:59:50.404864+05:30
92	pbkdf2_sha256$150000$2WFmp83l8KrQ$rTj1t0w8y+ZliT+R/zloY6dhiIz1E15CbzngYh7dZYY=	\N	f	rkvgnvg@gmail.com	rkvgnvg		rkvgnvg@gmail.com	f	f	2019-11-16 15:31:46.221114+05:30
93	pbkdf2_sha256$150000$1wETAAMM6fWp$RothHNEzgHhPnnPqMScrBmTDXn8mEvw7/FMTROxelAA=	\N	f	abhinav@avainfotech.com	Akshma		abhinav@avainfotech.com	f	f	2019-11-16 16:02:45.98807+05:30
94	pbkdf2_sha256$150000$OKmycHq4hcup$ZiHHeE/EdCTqYsdjjP0/v0UM8itc4hOwwNlbPFo/GZQ=	\N	f	abhinash@avainfotech.com	abhinav		abhinash@avainfotech.com	f	f	2019-11-16 16:04:33.887989+05:30
96	pbkdf2_sha256$150000$9WgzCIHiput5$7PV1Xms4pufgMRKRDddWl1kLj4UFinqY9ccOwHKt8jc=	\N	f	testavain@gmail.com	test		testavain@gmail.com	f	f	2019-11-16 16:17:26.381421+05:30
97	pbkdf2_sha256$150000$goZE3ZIQDam2$nYqsezoVzRVWoLjwLqfj0Rwvl4RuwgkTPwhas+cbW+c=	\N	f	testavawedf4in@gmail.com	test		testavawedf4in@gmail.com	f	f	2019-11-16 16:18:08.110807+05:30
256	pbkdf2_sha256$150000$LPu7xUKYYvwq$H8jxb5bk06WKb12UDlpXQPvp6mHVSFkfBKE+3t8DwEQ=	\N	f	nirupmade@avainfotech.com	Akshma		nirupmade@avainfotech.com	f	f	2019-11-25 15:16:38.602182+05:30
268	pbkdf2_sha256$150000$COusIqsZvEII$jC89ILnqjo2XtRRxgDVnfDkYzlVPx1vIF33FmSFupgk=	\N	f	nirupmaghhsdd@avainfotech.com	Akshma		nirupmaghhsdd@avainfotech.com	f	f	2019-11-25 18:24:57.411327+05:30
271	pbkdf2_sha256$150000$m2eIX5ngNBOk$k9AoK6k4+uQn0rGIzXQGnmphu2XUBMHjiS7tS5Zfq1g=	2019-11-25 18:30:19.604622+05:30	f	nirudfgfgpdretgma@avainfotech.com	Akshma		nirudfgfgpdretgma@avainfotech.com	f	t	2019-11-25 18:30:01.105972+05:30
213	pbkdf2_sha256$150000$wohTKfjlDpsG$izjP5NjTaMr4dATkjSfUZUTEMfDhxJwTr2rcRbim1P8=	2019-11-26 11:58:47.872641+05:30	t	nirupma				t	t	2019-11-20 17:42:00.621081+05:30
156	pbkdf2_sha256$150000$o0egxza2Epwv$qOrlrI9Q1i4fITosbJB9KyPB0St828aQhC1+1Frnz9U=	\N	f	akshmachoudhary@gmail.com	Akshma		akshmachoudhary@gmail.com	f	f	2019-11-20 11:13:48.96967+05:30
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: customer_support_contactus; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.customer_support_contactus (created, modified, id, name, email, subject, description) FROM stdin;
2019-09-21 16:32:06.952153+05:30	2019-09-21 16:32:06.953914+05:30	713e582a-4202-4ddd-8dec-91fb44542e4d	prateek	prateek@avainfotech.com	test	testwerr
2019-09-25 13:18:57.343581+05:30	2019-09-25 13:18:57.345324+05:30	b2cf01d6-cc8b-4c6e-94f7-780f0af288fc	shivi	shandilyashivi6@gmail.com	fdfd	fdffd
2019-09-25 13:21:22.353536+05:30	2019-09-25 13:21:22.355453+05:30	aeee24c7-cc91-4aaf-af07-8ee93955094e	shivi	shandilyashivi6@gmail.com	fdfd	fdffd
2019-09-25 13:21:34.706947+05:30	2019-09-25 13:21:34.708635+05:30	b4dad0f6-15aa-4aef-8210-369ed2c5f957	shivi	shandilyashivi6@gmail.com	fdfd	fdffd
2019-09-25 13:23:37.573187+05:30	2019-09-25 13:23:37.574742+05:30	b38207c6-9d60-460a-8de8-9461fc0e9b2b	shivi	shandilyashivi6@gmail.com	sdas	dsds
2019-09-25 13:25:49.301815+05:30	2019-09-25 13:25:49.303532+05:30	2252f4bc-2de9-43ce-9ea7-4536e25a230c	shivi	shandilyashivi6@gmail.com	sdas	dsds
2019-09-25 13:26:00.472119+05:30	2019-09-25 13:26:00.473676+05:30	d6f35275-a3dc-488c-9958-e43e0eb25b61	shivi	shandilyashivi6@gmail.com	sdas	dsds
2019-09-25 14:43:47.447779+05:30	2019-09-25 14:43:47.449521+05:30	1deed616-0fe1-45fe-9a12-96b1a5c7a017	shivi	shandilyashivi6@gmail.com	sdas	dsds
2019-09-25 14:54:39.29599+05:30	2019-09-25 14:54:39.297511+05:30	f342400a-189e-49b3-bb48-1ec26b7bf039	shivi	shivi@avainfotech.com	fdfds	fdff
2019-10-02 19:58:08.685587+05:30	2019-10-02 19:58:08.687176+05:30	ee7c742e-1934-4a11-9d3b-f4c78211e4d3	Geraldgooms	eric1970@tele2.nl	Beatport Music Releases	Hello, \r\nMP3s Club Music for DJs, More Info: http://0daymusic.orgt \r\nDownload 0DAY-MP3s Private Server, For DJs Electronika Musica \r\n \r\nRegards, \r\n0DAY Music
2019-10-03 03:10:36.519873+05:30	2019-10-03 03:10:36.521467+05:30	f133abf6-170a-4261-aadd-b228da00a57d	Geraldgooms	eric1970@tele2.nl	Beatport Music Releases	Hello, \r\nMP3s Club Music for DJs, More Info: http://0daymusic.orgt \r\nDownload 0DAY-MP3s Private Server, For DJs Electronika Musica \r\n \r\nRegards, \r\n0DAY Music
2019-10-11 10:10:56.980604+05:30	2019-10-11 10:10:56.983163+05:30	4bf732df-dccf-4a9e-a501-8d7d1b288a4c	dfweaf	efewf	wefwe	efed
2019-10-11 10:11:19.093532+05:30	2019-10-11 10:11:19.095185+05:30	3d1e08bc-5392-40de-9017-cdbd62262b0c	werf	erfwe	ef	fef
2019-10-11 10:11:37.478253+05:30	2019-10-11 10:11:37.479929+05:30	57a00f72-e589-4495-a057-004da6a3a996	fdsg	rg	rt	rte
2019-10-11 10:58:11.939437+05:30	2019-10-11 10:58:11.941139+05:30	67034964-0d58-44ab-823c-b9bc7b08bd5c	kjmkl	gli	lh	lhlh
2019-10-11 10:58:25.970198+05:30	2019-10-11 10:58:25.971829+05:30	2c7c65c9-fc7a-4230-899d-889a927f697a	gfsr	dfgdfg	dfgdg	fgdg
2019-10-11 10:59:45.936289+05:30	2019-10-11 10:59:45.937998+05:30	8a344816-1004-4e38-bf93-8eb3546f5205	klkh	hlkh	hkl	hkl
2019-10-11 11:00:08.304492+05:30	2019-10-11 11:00:08.306131+05:30	bbff1170-7047-4745-a6f1-cb7e43118272	ioloi	uioui	iu	ol
2019-10-15 00:20:43.304908+05:30	2019-10-15 00:20:43.307656+05:30	ea7b8252-dedd-4dcf-9de8-257b9c0fcdeb	dkNGeuxnFCRtB	arronoliver2586@gmail.com	SWmtzXbVgknABjT	IjXbKwuHTRAC
2019-10-15 00:21:17.127825+05:30	2019-10-15 00:21:17.129494+05:30	f0f10040-1ccb-4ba3-ae08-fe3cf65d41ff	xSdpivKb	arronoliver2586@gmail.com	hQLVBwZcEDmMjz	etZEsJfcwG
2019-10-26 03:07:58.620526+05:30	2019-10-26 03:07:58.622696+05:30	a4ba0e43-6038-4bf3-b29a-e6bb364a2b96	Winston	alexanderiizv65@thefirstpageplan.com	Your site, quick question...	Hey guys, I just wanted to see if you need anything in the way of site editing/code fixing/programming, unique blog post material, extra traffic, social media management, etc.  I have quite a few ways I can set all of this and do thhis for you.  Don't mean to impose, was just curious, I've been doing thhis for some time and was just curious if you needed an extra hand. I can even do Wordpress and other related tasks (you name it).\r\n\r\nPS - I'm here in the states, no need to outsource :-)\r\n\r\nWinston R.\r\n1.708.320.3171
2019-10-27 06:17:32.793596+05:30	2019-10-27 06:17:32.795402+05:30	54733e6f-6477-4250-8060-4c90c73d0d5c	Eric Jones	eric@talkwithcustomer.com	Do You Want Up to 100X More Conversions?	Hey,\r\n\r\nYou have a website polymathsports.com, right?\r\n\r\nOf course you do. I am looking at your website now.\r\n\r\nIt gets traffic every day – that you’re probably spending $2 / $4 / $10 or more a click to get.  Not including all of the work you put into creating social media, videos, blog posts, emails, and so on.\r\n\r\nSo you’re investing seriously in getting people to that site.\r\n\r\nBut how’s it working?  Great? Okay?  Not so much?\r\n\r\nIf that answer could be better, then it’s likely you’re putting a lot of time, effort, and money into an approach that’s not paying off like it should.\r\n\r\nNow… imagine doubling your lead conversion in just minutes… In fact, I’ll go even better.\r\n \r\nYou could actually get up to 100X more conversions!\r\n\r\nI’m not making this up.  As Chris Smith, best-selling author of The Conversion Code says: Speed is essential - there is a 100x decrease in Leads when a Lead is contacted within 14 minutes vs being contacted within 5 minutes.\r\n\r\nHe’s backed up by a study at MIT that found the odds of contacting a lead will increase by 100 times if attempted in 5 minutes or less.\r\n\r\nAgain, out of the 100s of visitors to your website, how many actually call to become clients?\r\n\r\nWell, you can significantly increase the number of calls you get – with ZERO extra effort.\r\n\r\nTalkWithCustomer makes it easy, simple, and fast – in fact, you can start getting more calls today… and at absolutely no charge to you.\r\n\r\nCLICK HERE http://www.talkwithcustomer.com now to take a free, 14-day test drive to find out how.\r\n\r\nSincerely,\r\nEric\r\n\r\nPS: Don’t just take my word for it, TalkWithCustomer works:\r\nEMA has been looking for ways to reach out to an audience. TalkWithCustomer so far is the most direct call of action. It has produced above average closing ratios and we are thrilled. Thank you for providing a real and effective tool to generate REAL leads. - P MontesDeOca.\r\nBest of all, act now to get a no-cost 14-Day Test Drive – our gift to you just for giving TalkWithCustomer a try. \r\nCLICK HERE http://www.talkwithcustomer.com to start converting up to 100X more leads today!\r\n\r\nIf you'd like to unsubscribe click here http://liveserveronline.com/talkwithcustomer.aspx?d=polymathsports.com\r\n
2019-11-11 10:46:16.157189+05:30	2019-11-11 10:46:16.201672+05:30	10b90a24-27b0-4fc7-8c2f-c4cb3342dc4a	nirupma	nirupama.cha@yopmail.com	fghfghvvf	fdbffhfhfhff
2019-11-11 15:25:22.70482+05:30	2019-11-11 15:25:22.731271+05:30	19ffe58e-9990-450d-9b0a-9c6a322fcbb0	test	dscfgs@gmail.com	ghgsdv	vdhsfvhscvf
2019-11-11 15:34:45.546723+05:30	2019-11-11 15:34:45.573491+05:30	8275f978-6cc0-4d34-a5f5-9188f6f36088	fsdfv	svfsdf@gmail.com	fghfghvvf	fsdvgag
2019-11-11 15:40:26.209793+05:30	2019-11-11 15:40:26.243076+05:30	31bec315-6616-4214-b00e-b935a3a5c4ff	sdfvgsdv	nirupama.cha@yopmail.com	dsfsdfv	sdvdsvsv
2019-11-11 15:46:28.794117+05:30	2019-11-11 15:46:28.830255+05:30	2f2c4db2-b206-47e5-8d1b-5379a2075227	dvhbsdhv	vhsv@gmail.com	fcvbhsv	gvehbvjuhs
2019-11-11 19:02:27.236041+05:30	2019-11-11 19:02:27.280062+05:30	f1f25ad1-d04f-49b2-a378-8e89c9188240	sdvsd	svsv@gmail.com	dsvfsdv	b fsbb
2019-11-11 19:03:29.357556+05:30	2019-11-11 19:03:29.376525+05:30	d349c602-9f0e-4d09-829f-0ad06d6f0fa5	sdvsd	svsv@gmail.com	dsvfsdv	b fsbb
2019-11-12 12:30:04.424252+05:30	2019-11-12 12:30:04.501955+05:30	2a216b64-c155-4f76-8a29-1e376ded908f	dsvdscv	dv@gmail.com	rfghh	hthdrehh
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2019-09-17 19:24:39.442375+05:30	a832bf5b-2543-468f-b8eb-b9c0819fd93a	Free	1	[{"added": {}}]	1	3
2	2019-09-17 19:24:57.048437+05:30	7f0b8b63-2006-47d5-a375-2db8208b343e	Weekly	1	[{"added": {}}]	1	3
3	2019-09-17 19:25:24.852909+05:30	211ea5af-65b3-4a74-8674-01d34f3da0f2	Monthly	1	[{"added": {}}]	1	3
4	2019-09-17 19:25:52.825614+05:30	0082f7c4-fff2-44d1-a547-92f0ce2b43c6	Yearly	1	[{"added": {}}]	1	3
5	2019-09-24 19:14:16.387205+05:30	a832bf5b-2543-468f-b8eb-b9c0819fd93a	FREE	2	[{"changed": {"fields": ["name"]}}]	1	14
6	2019-09-25 15:18:32.987967+05:30	d2a42116-d55e-49c5-a7c8-2134f034d12d	shivi@avainfotech.com	3		2	14
7	2019-09-25 15:18:32.990055+05:30	87b629e7-75b9-4f3b-a8ae-a1e93fd97b26	shivisharma135@gmail.com	3		2	14
8	2019-09-25 15:18:32.991389+05:30	36552933-421e-4833-9cfe-4b909308b361	shandilyashivi6@gmail.com	3		2	14
9	2019-09-25 15:19:00.478029+05:30	b55aa0a1-f027-4ae9-ba04-aecbc10d76e1	diksha@avainfotech.com	3		2	14
10	2019-09-25 15:19:00.480033+05:30	52841cad-6cc7-4d61-bcfd-f9ab4c35dfa7	testdev@gmail.com	3		2	14
11	2019-09-25 15:21:30.074838+05:30	18	shandilyashivi6@gmail.com	3		6	14
12	2019-09-25 15:21:55.897561+05:30	17	diksha@avainfotech.com	3		6	14
13	2019-09-25 15:21:55.899386+05:30	8	shivi@avainfotech.com	3		6	14
14	2019-09-25 15:21:55.908465+05:30	16	shivisharma135@gmail.com	3		6	14
15	2019-09-25 15:22:09.823228+05:30	15	testdev@gmail.com	3		6	14
16	2019-09-25 15:54:51.755348+05:30	19	shivi@avainfotech.com	3		6	14
17	2019-09-25 15:56:19.558247+05:30	20	shivi@avainfotech.com	3		6	14
18	2019-09-25 16:14:57.70523+05:30	21	shivi@avainfotech.com	3		6	14
19	2019-11-07 12:27:13.084684+05:30	28	nirupma@yopmail.com	2	[{"changed": {"fields": ["password"]}}]	6	32
222	2019-11-20 17:47:59.698699+05:30	214	nirupma@avainfotech.com	3		13	213
223	2019-11-20 17:51:31.457151+05:30	215	nirupma@avainfotech.com	3		13	213
224	2019-11-20 18:09:52.850427+05:30	216	nirupma@avainfotech.com	3		13	213
225	2019-11-20 18:11:59.156725+05:30	217	nirupma@avainfotech.com	3		13	213
226	2019-11-21 12:36:00.267136+05:30	218	nirupmabhmtfkb@gmail.com	3		13	213
227	2019-11-21 12:36:00.319584+05:30	220	nirupmafvghgj@gmail.com	3		13	213
228	2019-11-21 12:36:00.327556+05:30	219	nirupmajfrjjttyf@gmail.com	3		13	213
229	2019-11-21 12:45:25.886683+05:30	222	nirupmasdxfdf@gmail.com	3		13	213
230	2019-11-21 12:45:25.900143+05:30	223	nirupmasdxffghhdf@gmail.com	3		13	213
231	2019-11-21 12:45:25.90844+05:30	224	nirupmasdxfsdffghhdf@gmail.com	3		13	213
232	2019-11-21 12:50:35.681481+05:30	225	nirupmafjvhvgf@gmail.com	3		13	213
233	2019-11-21 12:50:35.694027+05:30	221	nirupmasd@gmail.com	3		13	213
234	2019-11-21 13:04:23.674902+05:30	226	nirupma@avainfotech.com	3		13	213
235	2019-11-21 13:08:01.620201+05:30	227	nirupma@avainfotech.com	3		13	213
236	2019-11-21 13:10:59.801183+05:30	228	nirupma@avainfotech.com	3		13	213
237	2019-11-21 13:20:00.55271+05:30	229	nirupma@avainfotech.com	3		13	213
238	2019-11-21 13:23:50.636357+05:30	230	nirupma@avainfotech.com	3		13	213
239	2019-11-21 13:26:33.123489+05:30	231	nirupma@avainfotech.com	3		13	213
240	2019-11-21 13:29:32.708127+05:30	232	nirupma@avainfotech.com	3		13	213
241	2019-11-21 17:44:50.691863+05:30	234	nirupma@avainfotech.com	3		13	213
242	2019-11-21 17:48:18.359869+05:30	235	nirupma@avainfotech.com	3		13	213
243	2019-11-21 17:49:26.066396+05:30	236	nirupma@avainfotech.com	3		13	213
244	2019-11-21 17:51:46.562102+05:30	237	nirupma@avainfotech.com	3		13	213
245	2019-11-21 17:57:03.904709+05:30	239	nirupma@avainfotech.com	3		13	213
246	2019-11-21 17:59:38.325467+05:30	240	nirupma@avainfotech.com	3		13	213
247	2019-11-21 18:10:46.643023+05:30	241	nirupma@avainfotech.com	3		13	213
248	2019-11-21 18:11:53.0182+05:30	243	nirupma@avainfotech.com	3		13	213
249	2019-11-21 18:34:16.611387+05:30	244	nirupma@avainfotech.com	3		13	213
250	2019-11-22 11:59:40.153371+05:30	6	sample.mp4	2	[{"changed": {"fields": ["video"]}}]	21	213
251	2019-11-22 12:05:45.436392+05:30	5	sample.mp4	2	[{"changed": {"fields": ["video"]}}]	21	213
252	2019-11-22 12:05:53.17957+05:30	4	sample.mp4	2	[{"changed": {"fields": ["video"]}}]	21	213
253	2019-11-22 12:06:02.041751+05:30	3	sample.mp4	2	[{"changed": {"fields": ["video"]}}]	21	213
254	2019-11-22 12:06:11.305283+05:30	2	sample.mp4	2	[{"changed": {"fields": ["video"]}}]	21	213
255	2019-11-22 12:06:18.695207+05:30	1	sample.mp4	2	[{"changed": {"fields": ["video"]}}]	21	213
256	2019-11-22 15:28:20.529938+05:30	245	nirupma@avainfotech.com	3		13	213
257	2019-11-22 15:31:07.192305+05:30	246	nirupma@avainfotech.com	3		13	213
258	2019-11-22 15:31:07.202129+05:30	238	nirupmadeqw@gmail.com	3		13	213
259	2019-11-22 15:31:07.210587+05:30	233	nirupmadfdf@gmail.com	3		13	213
260	2019-11-22 15:31:07.218875+05:30	242	nirupmefwscfa@avainfotech.com	3		13	213
261	2019-11-22 15:33:18.546938+05:30	247	nirupma@avainfotech.com	3		13	213
262	2019-11-22 15:40:11.185509+05:30	248	nirupma@avainfotech.com	3		13	213
263	2019-11-25 14:35:33.629622+05:30	249	nirupma@avainfotech.com	3		13	213
264	2019-11-25 14:44:49.729844+05:30	250	nirupma@avainfotech.com	3		13	213
265	2019-11-25 14:49:14.334531+05:30	251	nirupma@avainfotech.com	3		13	213
266	2019-11-25 14:55:27.886234+05:30	252	nirupma@avainfotech.com	3		13	213
267	2019-11-25 14:56:56.697236+05:30	59	minish43@gmail.com	3		13	213
268	2019-11-25 14:56:56.714186+05:30	58	minish4@gmail.com	3		13	213
269	2019-11-25 15:01:14.41759+05:30	253	nirupma@avainfotech.com	3		13	213
270	2019-11-25 15:03:41.132636+05:30	254	nirupma@avainfotech.com	3		13	213
271	2019-11-25 15:18:17.862373+05:30	255	nirupma@avainfotech.com	3		13	213
272	2019-11-25 16:35:32.947933+05:30	262	nirupma@avainfotech.com	3		13	213
273	2019-11-25 16:45:32.532214+05:30	263	nirupma@avainfotech.com	3		13	213
274	2019-11-25 17:40:28.458017+05:30	264	nirupma@avainfotech.com	3		13	213
275	2019-11-25 17:44:33.291685+05:30	265	nirupma@avainfotech.com	3		13	213
276	2019-11-25 18:46:23.271549+05:30	266	nirupma@avainfotech.com	3		13	213
277	2019-11-26 10:33:09.608135+05:30	272	nirupma@avainfotech.com	3		13	213
278	2019-11-26 10:39:22.512882+05:30	273	nirupma@avainfotech.com	3		13	213
279	2019-11-26 11:36:36.54638+05:30	274	nirupma@avainfotech.com	3		13	213
280	2019-11-26 11:58:55.232317+05:30	275	nirupma@avainfotech.com	3		13	213
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	users	usersubscriptionorder
2	users	subscriptionplan
3	users	profile
4	orders	card
5	models	targetvarriables
6	models	games
7	models	mlalgorithms
8	models	predictorvarriables
9	models	sports
10	customer_support	contactus
11	admin	logentry
12	auth	group
13	auth	user
14	auth	permission
15	contenttypes	contenttype
16	sessions	session
17	customer_support	videosdsgf
18	customer_support	contactusdfsvggf
19	static_pages	post
20	users	videos
21	users	video
22	users	privacypolicy
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2019-11-08 12:20:06.221977+05:30
2	auth	0001_initial	2019-11-08 12:20:06.538969+05:30
3	admin	0001_initial	2019-11-08 12:20:07.170654+05:30
4	admin	0002_logentry_remove_auto_add	2019-11-08 12:20:07.261916+05:30
5	admin	0003_logentry_add_action_flag_choices	2019-11-08 12:20:07.284465+05:30
6	contenttypes	0002_remove_content_type_name	2019-11-08 12:20:07.349919+05:30
7	auth	0002_alter_permission_name_max_length	2019-11-08 12:20:07.385271+05:30
8	auth	0003_alter_user_email_max_length	2019-11-08 12:20:07.409537+05:30
9	auth	0004_alter_user_username_opts	2019-11-08 12:20:07.433344+05:30
10	auth	0005_alter_user_last_login_null	2019-11-08 12:20:07.458425+05:30
11	auth	0006_require_contenttypes_0002	2019-11-08 12:20:07.47122+05:30
12	auth	0007_alter_validators_add_error_messages	2019-11-08 12:20:07.491098+05:30
13	auth	0008_alter_user_username_max_length	2019-11-08 12:20:07.557991+05:30
14	auth	0009_alter_user_last_name_max_length	2019-11-08 12:20:07.600847+05:30
15	auth	0010_alter_group_name_max_length	2019-11-08 12:20:07.62699+05:30
16	auth	0011_update_proxy_permissions	2019-11-08 12:20:07.652939+05:30
17	customer_support	0001_initial	2019-11-08 12:20:07.726183+05:30
18	models	0001_initial	2019-11-08 12:20:08.085714+05:30
19	models	0002_auto_20191017_0604	2019-11-08 12:20:08.402683+05:30
20	models	0003_auto_20191019_1030	2019-11-08 12:20:08.479631+05:30
21	models	0004_mlalgorithms	2019-11-08 12:20:08.62989+05:30
22	orders	0001_initial	2019-11-08 12:20:08.737183+05:30
23	sessions	0001_initial	2019-11-08 12:20:08.861229+05:30
24	users	0001_initial	2019-11-08 12:20:09.131599+05:30
34	orders	0002_remove_card_cvv	2019-11-12 18:04:28.509713+05:30
35	orders	0003_auto_20191112_1252	2019-11-12 18:22:48.952247+05:30
36	orders	0004_auto_20191112_1313	2019-11-12 18:43:40.978719+05:30
37	orders	0005_auto_20191112_1320	2019-11-12 18:50:43.701349+05:30
38	users	0002_auto_20191113_1136	2019-11-13 17:06:10.687703+05:30
39	users	0003_subscriptionplan_plan_id	2019-11-14 10:41:09.66718+05:30
40	users	0004_remove_profile_birth_date	2019-11-15 10:38:07.492604+05:30
41	users	0005_profile_birth_date	2019-11-15 10:38:07.567394+05:30
42	orders	0006_auto_20191116_1225	2019-11-16 17:55:33.948396+05:30
43	users	0006_videos	2019-11-16 17:55:34.408783+05:30
44	users	0007_delete_videos	2019-11-16 18:38:48.860999+05:30
45	users	0008_videos	2019-11-16 18:39:06.051451+05:30
46	customer_support	0002_videos	2019-11-16 18:46:10.128143+05:30
47	customer_support	0003_auto_20191116_1316	2019-11-16 18:46:37.739778+05:30
48	customer_support	0004_auto_20191116_1321	2019-11-16 18:51:21.781478+05:30
49	customer_support	0005_delete_contactusdfsvggf	2019-11-16 18:51:38.692914+05:30
50	static_pages	0001_initial	2019-11-18 11:49:15.386026+05:30
51	static_pages	0002_auto_20191118_0622	2019-11-18 11:52:16.21505+05:30
52	users	0009_auto_20191118_0718	2019-11-18 12:48:11.372952+05:30
53	users	0010_privacypolicy	2019-11-18 16:41:19.64655+05:30
54	users	0011_auto_20191118_1155	2019-11-18 17:26:01.528504+05:30
55	users	0012_auto_20191118_1341	2019-11-18 19:11:37.259049+05:30
56	users	0013_auto_20191122_1301	2019-11-22 18:31:59.125731+05:30
57	users	0014_auto_20191125_1022	2019-11-25 15:52:13.111493+05:30
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
k19l11cmix2pv30hxui051ws950rf4oj	NmE4ZDUzM2FlMTdhZjg0MjcwNDA3Y2IxYmUwYjIxY2IyYTZmNDQ2ZTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiYTMyNGVlZmZhZmFmY2VkMjY0MzkyZjY2OWY5MWY3MTI0NmM2ZGFjOSIsIl9hdXRoX3VzZXJfaWQiOiIxIn0=	2019-11-22 12:29:35.099399+05:30
s3ixc3ayo6anbqb4693tqnjtqtmsv1na	NGRhODcxY2NmNjYyY2M2N2ZlZTUzNDMxZGIxYzQwZjk2MjFmNTI3NTp7Il9hdXRoX3VzZXJfaWQiOiIzIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIxZDZhOTJlZGJhZGE4NGJhN2Q4MzI4ODBiMGU2NTYyOWRhZDdiMGU3In0=	2019-10-01 19:24:14.048222+05:30
m4nog3vgaz42obyq00mvmmnorv3486i3	ZTQ1MTNhMDMxZDlkMGFiNzQ0YjI5YjQ5ZDA0ZTI4ZmVmZjFmM2EyNzp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjVhMS00ZDk3Nzk1YjkyODE3MjE1MzY4YiJ9	2019-10-09 14:45:03.409662+05:30
f9e6d7mqg5nj35k67iph2duiqqjhytpd	ODRhYjcxMWQ1MDQ1MzhkNDE1MTJiMGYzYzY1YmZjOTQ5YWU2ZDVkNjp7Il9hdXRoX3VzZXJfaWQiOiI4IiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJhOTI0YWU1OGZmNzU5NjU5ZGQxMGJhZGFkNGJhNGVmYWU2NjM4YzJmIn0=	2019-10-04 12:18:16.465617+05:30
yfxu3fqfag6y4pmci8gtevaveht90wj4	NmM3M2E0NDViNWY1ZjM3YWI1YTRlM2ZjYTJhNGFkYWRhODFkNDA5YTp7Il9hdXRoX3VzZXJfaWQiOiIxNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiYWIzMzJjMTY3ZThhMTg1MTBhNTY4MWNlMDYzMjIwZTU2OTBiOWE5YiJ9	2019-10-09 15:03:37.675083+05:30
02l4trypa4qcbs36qukr9zspxo92z8s4	ZTQ1MTNhMDMxZDlkMGFiNzQ0YjI5YjQ5ZDA0ZTI4ZmVmZjFmM2EyNzp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjVhMS00ZDk3Nzk1YjkyODE3MjE1MzY4YiJ9	2019-10-09 15:13:55.858647+05:30
zokvb3b6byiqrsdusw0q22g88cbq1jvr	M2I5ZTU4N2U3MTI3NzYzZDg3ZTliZDMyMmQ4ZmQxOGFkYzdiYWZkMzp7Il9hdXRoX3VzZXJfaWQiOiIxNCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiOTZmMTEyNGJjYjI0MmMwNmYxZGQ3YWVhODM1ZGMyOGJlYTQ3NDM4MSJ9	2019-10-09 15:17:32.381576+05:30
ca7ayashyo55ttfgl9zp0524gn831uwh	M2Q5NTg3NzUxODAyOTZlYmU1YmQwOWEyYzAyODFhNGY0NDE4YzY5Mzp7Il9hdXRoX3VzZXJfaWQiOiIxMSIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMzk5ZjM3ZDY2YjZlMzA4OTVhZDM4ZDk2NDUzYjZlNGE5NDAzZDMxZSJ9	2019-10-04 17:26:14.001497+05:30
mwod8z4beigzimtl6v2z0tf3ro0bucan	MzA2YmVhYWQwYjdhNDFkNDc0MDc4NzUwMGQxYTIwZjRlNzI4M2JkMzp7Il9hdXRoX3VzZXJfaWQiOiIxMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMmQxZjNkZGMwNzUzYjRhYmM4NWQ1NzIwZDA1N2MzNjlhYTJhN2QxNyJ9	2019-10-05 15:27:19.571024+05:30
p3viuzzb8e4vp5u24feugrbml03xs8sa	OTE2MGFjNjMzMmQwNDEzMDM3ZTgwOTUwMWEwN2I0NzFkYjBjOTE1ODp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjU5eC1hMDMzOWU0MDIzYWIzMzAwYWM0YSJ9	2019-10-05 16:23:29.752724+05:30
jvovtp3xhw81h4mcfqd9g3az6mhmv183	ZmE0YWM5M2M0ZTFiYjA0MzQyYzYyYzRkYmE5YWI2MmVjYWI2ZjA0MDp7Il9hdXRoX3VzZXJfaWQiOiIyMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNzM3ODMwMGUwNzY1MGE2MzYzMTUzZWEyNTdkMmJiZWU0M2E1ZDliNSJ9	2019-10-09 16:24:54.505737+05:30
lb65covrbgoe226zbu86d4fx1xg4oe61	ZmU4YWFiNzUxMjFkY2I5MjBhNTJhZjVlYjA2MzI5YmIzZWE2MWNiODp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjVhMS0yZWU1Y2Q2ZDA0NzVmNTYyM2Q0NyJ9	2019-10-09 19:36:48.0722+05:30
36ztueh9hudem6i8pg43qirdm0gjsnut	NTE5MGMyZGExMzUxOTdhMDJkZGJjNTFmOTk2NjgzNDM4M2YxMTNmOTp7Il9hdXRoX3VzZXJfaWQiOiIxMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMDNmMzkzZjdlZWZhOTVlZmQyMDYyMmMyZDhlYWE5NjE0ZDM5NzRlMSJ9	2019-10-08 18:16:28.699155+05:30
5j39ycusxlt9um1flydbd27lyd8686iv	ZmU4YWFiNzUxMjFkY2I5MjBhNTJhZjVlYjA2MzI5YmIzZWE2MWNiODp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjVhMS0yZWU1Y2Q2ZDA0NzVmNTYyM2Q0NyJ9	2019-10-09 19:37:02.588763+05:30
052kw2125e8ab1zt9f7858rtic1ralom	MzRiNzZmMDA5MGJjYmMxZjkzZTBhMjJmM2UwZDZkNjA3ZDhhN2QwOTp7fQ==	2019-10-09 19:49:48.456721+05:30
pqtnuiwsj64bmd0woto6wmuhd5dcv9vw	ZmU4YWFiNzUxMjFkY2I5MjBhNTJhZjVlYjA2MzI5YmIzZWE2MWNiODp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjVhMS0yZWU1Y2Q2ZDA0NzVmNTYyM2Q0NyJ9	2019-10-09 22:36:33.53338+05:30
uc2xiw2q67iauyvvxmkvxicju6oe4vb1	M2I5ZTU4N2U3MTI3NzYzZDg3ZTliZDMyMmQ4ZmQxOGFkYzdiYWZkMzp7Il9hdXRoX3VzZXJfaWQiOiIxNCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiOTZmMTEyNGJjYjI0MmMwNmYxZGQ3YWVhODM1ZGMyOGJlYTQ3NDM4MSJ9	2019-10-08 18:56:35.936766+05:30
1a47cq29pqqcj2pcyd42spimh9q795h5	YWYzNjJhZjRlMjU3OWExODM1MTlmOTFhNzcwY2RkOTFjNDQ3MDhhNDp7Il9hdXRoX3VzZXJfaWQiOiIyMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiZDdjNmJjMzU5YjljZjJiZjJiODMxZjYzMDQ0YzIwN2I5NGQ3ZjkxNyJ9	2019-10-16 19:22:04.001211+05:30
bmrr2mhrksdd5p5ojhlx8tg68uyu6gzk	ZmE0YWM5M2M0ZTFiYjA0MzQyYzYyYzRkYmE5YWI2MmVjYWI2ZjA0MDp7Il9hdXRoX3VzZXJfaWQiOiIyMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNzM3ODMwMGUwNzY1MGE2MzYzMTUzZWEyNTdkMmJiZWU0M2E1ZDliNSJ9	2019-10-17 18:05:38.292218+05:30
d1crsve0313vl4ssuuq2uhqsmrzirk0b	YjU1ODYxODA5ODBmYWViNDM1OGY5OGIyZjk3YWFjN2Y0M2Y3MjZiNzp7Il9hdXRoX3VzZXJfaWQiOiIxNiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiY2ViYzFhMTRiMDdhZTJhOTgzMGFlYWI3NDU0ODA5NTMzNjdiYTRhMyJ9	2019-10-09 11:13:07.523032+05:30
0mr8c8znb4g5yvu0dfzanod14hy9zlyi	ZmE0YWM5M2M0ZTFiYjA0MzQyYzYyYzRkYmE5YWI2MmVjYWI2ZjA0MDp7Il9hdXRoX3VzZXJfaWQiOiIyMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNzM3ODMwMGUwNzY1MGE2MzYzMTUzZWEyNTdkMmJiZWU0M2E1ZDliNSJ9	2019-10-21 17:35:17.414461+05:30
67amh1087oo0jozifguvde04m3cqx88i	ZmE0YWM5M2M0ZTFiYjA0MzQyYzYyYzRkYmE5YWI2MmVjYWI2ZjA0MDp7Il9hdXRoX3VzZXJfaWQiOiIyMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNzM3ODMwMGUwNzY1MGE2MzYzMTUzZWEyNTdkMmJiZWU0M2E1ZDliNSJ9	2019-10-25 11:03:36.503392+05:30
xil41ih6w8davx1oq9ulq8mueipt0jy4	ZmE0YWM5M2M0ZTFiYjA0MzQyYzYyYzRkYmE5YWI2MmVjYWI2ZjA0MDp7Il9hdXRoX3VzZXJfaWQiOiIyMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNzM3ODMwMGUwNzY1MGE2MzYzMTUzZWEyNTdkMmJiZWU0M2E1ZDliNSJ9	2019-10-25 11:04:01.825207+05:30
w9yu491e2jvhdfx2dbxdb8nqphyxp492	ZmE0YWM5M2M0ZTFiYjA0MzQyYzYyYzRkYmE5YWI2MmVjYWI2ZjA0MDp7Il9hdXRoX3VzZXJfaWQiOiIyMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNzM3ODMwMGUwNzY1MGE2MzYzMTUzZWEyNTdkMmJiZWU0M2E1ZDliNSJ9	2019-10-25 12:36:25.798083+05:30
zfl7nkqm7w865l61geiccmf8k6khbw1h	NTE5MGMyZGExMzUxOTdhMDJkZGJjNTFmOTk2NjgzNDM4M2YxMTNmOTp7Il9hdXRoX3VzZXJfaWQiOiIxMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMDNmMzkzZjdlZWZhOTVlZmQyMDYyMmMyZDhlYWE5NjE0ZDM5NzRlMSJ9	2019-11-12 16:21:19.719638+05:30
zbkisnpiwqu2xr68aodmqokq4hvuj0xc	MTZmYTdmNzAyN2ExZWFiMDE4ZTBmZjEwMThhMzk4YTY1MTc3M2Q5ODp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjVhMS1kZTUwNGIwNDY2ZGE4MjhlYjUzOCJ9	2019-10-09 12:47:34.441597+05:30
hpo97qx76min1hiqstkw29mqajwvl7p6	ZmVjODVjYzYxMGZlNmJjY2U3NThkNzIyNDk0YTQ0YmNhNDk2NTY4MTp7Il9hdXRoX3VzZXJfaWQiOiIyNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMzY4MWRmMmVmMDUyNGM1ODExNmQ1MDk2ODQ4OTlhYTc2ODE5NmI2YiJ9	2019-11-19 12:58:26.035628+05:30
7yzbtyj5s4y2x6bbft9ztfx6gourcomr	NGQ3MTQwNjU4YWMxNDI3MWNhODVjYTI5YmFkZDhmZjNhODAxMjU1Yzp7InBsYW5fbmFtZSI6Ik1PTlRITFkiLCJwbGFuX2Ftb3VudCI6MTAwfQ==	2019-12-09 15:30:26.385496+05:30
qnfw193wu6v18a8e8t1j93dd5wxrb96p	MzRiNzZmMDA5MGJjYmMxZjkzZTBhMjJmM2UwZDZkNjA3ZDhhN2QwOTp7fQ==	2019-11-27 13:05:24.625301+05:30
89tufclsf5hz3qbeh4ejgf55rkplcucl	MGFiZGY5YTRiMGE0ZTA2ODEzMjIwZmJiNTIzNzdkNGQwOTZiZWQ3MDp7Il9hdXRoX3VzZXJfaWQiOiIxOCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiZmUxMzliNWFkODIzMGEzM2UzYTkyZGU4MzE1MDNmNDg4ODQyYjE5NiJ9	2019-10-09 13:13:58.380881+05:30
ijyym5ew7cnnn0bgvv0ypuoohq5ua39h	MzRiNzZmMDA5MGJjYmMxZjkzZTBhMjJmM2UwZDZkNjA3ZDhhN2QwOTp7fQ==	2019-11-21 11:53:05.95587+05:30
aensysj5lerhujck0rw9cxq2ejilwa6a	ZWRjZmM0ODk2ZTI5NjlkZWUyOTJjZTA2NzRhY2I0NmMwYTUyYjIzYjp7Il9hdXRoX3VzZXJfaWQiOiIzMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiYTBmNzhhMjdjZDQwMTM0NDc0ZTA2N2NhZGI1MWEwNDU1YTk5ZTEyYiJ9	2019-11-21 12:02:44.471883+05:30
wpoyk7flm6kjbz5e6n5adx389qoilrb0	ZWRjZmM0ODk2ZTI5NjlkZWUyOTJjZTA2NzRhY2I0NmMwYTUyYjIzYjp7Il9hdXRoX3VzZXJfaWQiOiIzMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiYTBmNzhhMjdjZDQwMTM0NDc0ZTA2N2NhZGI1MWEwNDU1YTk5ZTEyYiJ9	2019-11-21 12:27:13.091476+05:30
kbfnqgxdva7zdfiachs8ye4fauo7xmdp	MzUzZGI3MjU5MjFiMmNmNDY5Y2FlOTZmOTc5ZjdkZDBmM2JiZGYwYzp7InBsYW5fbmFtZSI6Ik1PTlRITFkiLCJwbGFuX2Ftb3VudCI6MTAwLCJfYXV0aF91c2VyX2lkIjoiMjYwIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIwM2Q1YzVlZGNhZmExOTExMjM2MjQzMGY4MjIzOWRkMThjNGYxNmIzIn0=	2019-12-09 15:31:18.455323+05:30
fe3oq2g1go2j0azb34trx75xqlp3h3v3	MGE5ZmM5MjU1M2JmMDZjMzA4NjNhMzZhNDlhYTBmNDY5YzBjZDZmMjp7InVzZXJfaWQiOjgyLCJzdWJzY3JpcHRpb25faWQiOiJjZmEzMmJiZi1kNTUzLTQ4ZDYtYjdmNS00YWY0OTA3YzZjZjcifQ==	2019-11-29 18:34:59.804116+05:30
pt682ylo8cw35k4r5urnni7x3xze81kb	MzRiNzZmMDA5MGJjYmMxZjkzZTBhMjJmM2UwZDZkNjA3ZDhhN2QwOTp7fQ==	2019-11-27 13:04:12.574866+05:30
adj9j01dkxx9b5mzprm38e4uk767ag6a	YjdmMjBlNDQ5NjYzYWI0YmY4MzM5ZThlYTIzZDlkNDQxNTM3OWI3Zjp7Il9hdXRoX3VzZXJfaWQiOiIyMTMiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6IjQzNDVmNTljZDI2MGExZmNkOTQ5ZDVkZjVlZWM3MjQ0ODkwNDhjZjEifQ==	2019-12-10 10:11:45.699557+05:30
uwui5q4cz7116anbe69otnf8ky5rv9pp	MzRiNzZmMDA5MGJjYmMxZjkzZTBhMjJmM2UwZDZkNjA3ZDhhN2QwOTp7fQ==	2019-11-27 12:24:17.790608+05:30
5340uosiv4ukfslspp07wc7gcjqwekks	ZTRiMzMwZDUyYTM3NDhlZmMwMzIxZTY0YjdlY2VmYmVmYjg4Y2MyYTp7InBsYW5fbmFtZSI6IkRBSUxZIiwicGxhbl9hbW91bnQiOjUsIl9hdXRoX3VzZXJfaWQiOiIyMTMiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6IjQzNDVmNTljZDI2MGExZmNkOTQ5ZDVkZjVlZWM3MjQ0ODkwNDhjZjEifQ==	2019-12-05 17:48:07.827676+05:30
p8soe3859dazi69wv5vcex83g8ikls64	MGJiYjE4MjZkZjk1NTc1MmIwYzU1ZjA4YWQzOTAyY2QwMzA3M2M4Yzp7InVzZXJfaWQiOjI3NiwiX2F1dGhfdXNlcl9pZCI6IjI3NiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiZWU4MTc4YWIxMzcxYmM0MjhhMzYxMWMxZjdiMTQxM2UxYzJlMDNlNCJ9	2019-12-10 12:00:36.308502+05:30
10yny0k8oht5m3f6n3o7y09v9m3rawjm	YTkwZmUzOGE0ODAzN2JhMzEyZTJhODFiZTJkNWEwYjdjYjI0NjA2Mzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJhMzI0ZWVmZmFmYWZjZWQyNjQzOTJmNjY5ZjkxZjcxMjQ2YzZkYWM5In0=	2019-11-30 15:41:47.960712+05:30
\.


--
-- Data for Name: models_games; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.models_games (created, modified, id, name, status, sport_id) FROM stdin;
\.


--
-- Data for Name: models_mlalgorithms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.models_mlalgorithms (created, modified, id, name, access, status) FROM stdin;
\.


--
-- Data for Name: models_predictorvarriables; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.models_predictorvarriables (created, modified, id, name, access, status, sport_id) FROM stdin;
\.


--
-- Data for Name: models_sports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.models_sports (created, modified, id, name, status) FROM stdin;
\.


--
-- Data for Name: models_targetvarriables; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.models_targetvarriables (created, modified, id, name, status, sport_id) FROM stdin;
\.


--
-- Data for Name: orders_card; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.orders_card (created, modified, id, name, card_number, expiry_date, card_provider, card_logo, status, card_holder_id, cvv) FROM stdin;
2019-09-20 17:13:07.359455+05:30	2019-09-20 17:13:07.361402+05:30	f1bafd04-222b-43f6-a860-06e71fdb0a5a	dsadadasd	2121312321312321	2022-12-11	\N		t	10	\N
2019-09-20 17:28:34.673207+05:30	2019-09-20 17:28:47.660803+05:30	b908a934-e08b-4fca-b6bc-8c938b50e583	aman maan 	4343434343434343	2020-02-05	\N		f	11	\N
2019-09-24 18:44:07.251378+05:30	2019-09-24 18:44:26.810971+05:30	5f2a7743-c1ce-4c83-969a-8bd04b7d7415	prateek	4242424242424242	2019-09-25	\N		f	11	\N
2019-11-14 12:39:16.861131+05:30	2019-11-14 12:39:16.876389+05:30	6f9ff27a-f47c-4561-a716-4e83ad3f929d	Akshma	4242424242424242	2019-11-30	\N		t	27	\N
2019-11-13 18:21:14.528559+05:30	2019-11-16 10:38:38.723845+05:30	9e2cf9a7-70e2-451c-8b4f-03dd3643d09b	akshma	4111111111111111	2019-11-30	\N		f	27	5931587263701
2019-11-13 18:12:11.605032+05:30	2019-11-16 10:38:41.421507+05:30	5c7f930d-8aa9-418a-a9ed-e941e7b7d28b	akshma	4242424242424242	2019-11-30	\N		f	27	5132466355638856605
2019-11-14 12:34:44.502018+05:30	2019-11-16 10:38:45.192406+05:30	e67d4170-7067-4231-825a-391e5271c0a1	Akshma	4242424242424242	2019-11-30	\N		f	27	4124236774412106915
2019-11-16 10:39:10.111211+05:30	2019-11-21 15:08:37.739448+05:30	dcbf4c3d-1443-49a9-9fe2-16ba7f9bfe33	Akshma	4111111111111111	2019-11-30	\N		f	27	-1219530405152145992
2019-11-14 13:26:33.358882+05:30	2019-11-21 15:08:45.509988+05:30	d3a88ac2-d142-4198-8713-3e259cc7fe0c	Akshma	4242424242424242	2019-11-30	\N		f	27	\N
\.


--
-- Data for Name: static_pages_post; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.static_pages_post (id, video) FROM stdin;
\.


--
-- Data for Name: users_privacypolicy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_privacypolicy (id, policy) FROM stdin;
1	<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p> \t\t\t\t\t\t\t\t\t\t<p>Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p> \t\t\t\t\t\t\t\t\t\t<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrudullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p> \t\t\t\t\t\t\t\t\t\t<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. </p> \t\t\t\t\t\t\t\t\t\t<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrudullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p> \t\t\t\t\t\t\t\t\t\t<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p> \t\t\t\t\t\t\t\t\t\t<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
\.


--
-- Data for Name: users_profile; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.users_profile (created, modified, id, bio, location, twitter, profile_pic, user_id, stripe_customer_key, subscription_id, birth_date, subscription_end_date) FROM stdin;
2019-09-17 20:11:30.995529+05:30	2019-09-17 20:11:30.996932+05:30	47d5db5f-f35d-41f7-8ee3-3bc791d162f1			@sdasafds		6			\N	\N
2019-09-18 11:16:14.259349+05:30	2019-09-18 11:16:14.260677+05:30	61f2d9a4-d4d5-48e0-ab85-29d3c4599fc2			hjhjkhjkhjh@hjkhjkhjk 		7			\N	\N
2019-09-19 11:17:04.204759+05:30	2019-09-19 11:17:15.489479+05:30	76fcae58-bff7-4e2b-8c56-d8546f5cdd5a			@dsfa	profile_pics/46700825_101310200902387_3365781946490683392_n.jpg	3			\N	\N
2019-09-20 15:56:19.526411+05:30	2019-09-20 15:56:19.527888+05:30	14716db6-50f1-4e57-826d-6c648fbc75b9			@fdsfsdf		9			\N	\N
2019-09-20 17:10:47.926778+05:30	2019-09-20 17:11:57.937845+05:30	bf857b8d-ebec-402c-a7aa-2528d8e528c6			@dfsf	profile_pics/3.jpg	10			\N	\N
2019-09-21 09:59:08.678054+05:30	2019-09-21 09:59:08.679501+05:30	0850db1d-6955-4efd-8718-6672ee468d04			@jhjhj		12			\N	\N
2019-09-21 15:25:18.944192+05:30	2019-09-21 15:25:18.94555+05:30	7a1c2cd8-a6f5-4bd6-9b04-758a81aed5ff			@amansinghbawa		13			\N	\N
2019-09-20 17:26:13.973069+05:30	2019-09-21 16:29:28.879296+05:30	46fc7cce-d23d-47a9-ad2c-10283ff42ec0			@dfsf	profile_pics/png_MSwrsbg.jpg	11			\N	\N
2019-10-02 19:20:13.356695+05:30	2019-10-02 19:20:13.358022+05:30	463bdfeb-dbb5-41bc-99a7-9ef6d1790fb1					23			\N	\N
2019-10-11 11:02:12.796005+05:30	2019-10-11 11:02:12.797344+05:30	9c0bf35d-214f-4e18-bc2d-c00d09ebfbb1			df		24			\N	\N
2019-09-25 16:16:31.997432+05:30	2019-10-11 11:04:47.426742+05:30	22a29877-9f41-48f2-b495-f8e4351ca359				profile_pics/download_ZmRxsSv.jpeg	22			\N	\N
2019-10-15 00:21:39.377762+05:30	2019-10-15 00:21:39.379129+05:30	ac4f95ab-cca7-4a6e-a4c5-3df5091010e2			USvdFeVwtgBE		25			\N	\N
2019-11-07 11:55:19.324277+05:30	2019-11-07 11:55:19.325606+05:30	d930e6b5-1e0d-4522-932f-54941e0602f1			@bawaaman		31			\N	\N
2019-11-25 18:23:15.4972+05:30	2019-11-25 18:23:15.504989+05:30	2543d0a2-2b16-4d36-bd4e-b248e1106009					267			\N	\N
2019-11-25 18:24:57.75288+05:30	2019-11-25 18:24:57.760757+05:30	2a56992d-3b13-4b21-b51a-f8cd667ad361					268			\N	\N
2019-11-25 18:26:18.685498+05:30	2019-11-25 18:26:18.692574+05:30	d4e93501-1e44-4cd4-964a-cc23a72f8a54					269			\N	\N
2019-11-25 18:26:59.458162+05:30	2019-11-25 18:26:59.465873+05:30	3896d0a6-c28a-4774-b007-a00ffc51199e					270			\N	\N
2019-11-25 15:16:38.959966+05:30	2019-11-25 15:17:00.005124+05:30	78481485-1422-4d43-ad0b-00e85d879278					256	cus_GF8Q4IROLI4GzE		\N	\N
2019-11-25 15:18:40.875963+05:30	2019-11-25 15:19:33.587791+05:30	03e23c46-5058-4415-8067-38a7e17efafb					257	cus_GF8TyU1hK0bAj4		\N	\N
2019-11-25 15:30:26.263499+05:30	2019-11-25 15:30:26.273827+05:30	02a9b2e0-831e-436a-bfaf-246acab6d498					258			\N	\N
2019-11-25 18:30:01.45823+05:30	2019-11-25 18:30:19.562691+05:30	b59b7bd2-e68c-4f25-84ff-7565a2dc8ca7					271	cus_GFBXWJGbiOLaLA	sub_GFBXJd3jAFyhD0	\N	2019-12-25
2019-11-25 15:30:56.974059+05:30	2019-11-25 15:31:16.730777+05:30	0a25b764-fdd2-4e0c-9543-e283a6992ffb					260	cus_GF8ejfFNtvZNxo		\N	\N
2019-11-25 15:53:09.148958+05:30	2019-11-25 15:53:38.641883+05:30	d3d40de4-54af-450d-a2f6-32344205cf3a					261	cus_GF91vmhjTMSaik	sub_GF916mQ8gqumy6	\N	2019-12-25
2019-11-13 17:51:42.470705+05:30	2019-11-13 17:51:42.478664+05:30	7517b0b6-cded-4238-9eae-e3f192c7b155			@test		42			\N	\N
2019-11-05 12:57:35.449524+05:30	2019-11-21 15:11:19.460578+05:30	340a03ab-534e-4215-97fa-af22992034f9			@dwqe3453	profile_pics/Screenshot_from_2019-11-11_10-55-00.png	27			\N	\N
2019-11-20 12:27:28.638637+05:30	2019-11-20 12:29:15.559532+05:30	43ae0b20-178e-47e4-9f45-dce2ed80e73f					170	cus_GDDamVpZryDBHE		\N	\N
2019-11-26 12:00:17.470052+05:30	2019-11-26 12:00:36.229748+05:30	ec346700-f922-49d1-9bb7-9ca96d01e1f4					276	cus_GFSUKBVNvHQX2e	sub_GFSUABm8zBbpQe	\N	2019-11-27
2019-11-20 15:00:50.814016+05:30	2019-11-20 15:00:50.823073+05:30	9c51869e-9767-48f2-9469-c0f5d8771794					182			\N	\N
2019-11-15 12:15:02.576575+05:30	2019-11-15 12:16:40.941558+05:30	eecdc2c6-1dfb-4120-b3b7-8b7027dc6ced			@test		69	cus_GBLG8M0z6VbP2v		\N	\N
2019-11-14 17:30:58.554322+05:30	2019-11-14 18:44:38.770118+05:30	ef624b07-27cf-4826-b993-42209014d612			@test		56	cus_GB4IEd0tp1oEc5		\N	\N
2019-11-14 18:59:29.437127+05:30	2019-11-14 18:59:29.445361+05:30	e728747f-b818-4781-9c9e-ad8c573ed6ac			@test		57			\N	\N
2019-11-20 15:21:14.792664+05:30	2019-11-20 15:21:14.798287+05:30	ed22e483-8a95-4d20-ae6a-5ddd1007a74b					189			\N	\N
2019-11-15 17:59:58.957076+05:30	2019-11-15 17:59:58.965142+05:30	181ae7bb-0953-4061-ae5c-3c7738b6960e			@test		73			\N	\N
2019-11-15 11:07:05.459057+05:30	2019-11-15 11:14:52.566329+05:30	b7f3c6bd-a0e3-4118-a4d1-58676d9ada51			@test		65	cus_GBKGn2FkYSaBnX		\N	\N
2019-11-20 16:09:22.998528+05:30	2019-11-20 16:09:23.006489+05:30	f9ad871b-e325-4ee4-8076-bd5c8a1cd6d1					197			\N	\N
2019-11-20 16:11:21.33122+05:30	2019-11-20 16:11:21.3404+05:30	eb33842e-7ab3-4762-8956-197c14254210					198			\N	\N
2019-11-20 11:13:49.318901+05:30	2019-11-20 11:13:49.324825+05:30	19b06e9f-a3ad-405e-bf28-d3c27e6ea80e					156			\N	\N
2019-11-16 15:31:54.982152+05:30	2019-11-16 15:31:54.990357+05:30	bd667c7c-b939-4b55-b320-c1518c1bd2c2					92			\N	\N
2019-11-16 16:02:55.009467+05:30	2019-11-16 16:02:55.017809+05:30	d476f0d8-c2e6-4233-82d1-d6daa177c903					93			\N	\N
2019-11-16 16:04:43.434792+05:30	2019-11-16 16:04:43.442964+05:30	c6c61f5b-7839-4330-b2ce-ea1fe6f48911					94			\N	\N
2019-11-16 16:17:38.977108+05:30	2019-11-16 16:17:38.986856+05:30	452e55fd-d80c-4417-bab3-0292a66be5f3					96			\N	\N
2019-11-16 16:18:18.001018+05:30	2019-11-16 16:18:18.008969+05:30	d4843274-f331-4e40-be61-5e63324e0eb3					97			\N	\N
\.


--
-- Data for Name: users_subscriptionplan; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.users_subscriptionplan (created, modified, id, name, amount, status, duration, plan_id) FROM stdin;
2019-11-13 16:32:32.050652+05:30	2019-11-14 18:37:24.156873+05:30	7a26a72e-6bee-4507-a6ac-96a6c475012f	YEARLY	1000	f	365 days	plan_GAIpXeiQjhmq17
2019-11-13 16:32:05.979295+05:30	2019-11-14 18:38:46.190436+05:30	1bb3cd33-4cc4-4449-a6f4-465d2d91c26e	MONTHLY	100	f	30 days	plan_GAIliCtjB6PhbD
2019-11-13 16:31:11.320865+05:30	2019-11-14 18:39:17.971433+05:30	d5eb20f4-fced-40f4-ba75-f4ea491b65a2	WEEKLY	30	f	7 days	plan_GAIisb0JkKtSgR
2019-11-13 16:29:55.749547+05:30	2019-11-14 18:42:40.6032+05:30	07730a91-cb26-4dd2-9001-e8c838d6943c	DAILY	5	f	1 day	plan_GAIgi48ZYEEIan
2019-11-13 16:29:29.279051+05:30	2019-11-14 18:43:13.11065+05:30	cfa32bbf-d553-48d6-b7f5-4af4907c6cf7	FREE	0	f	1 day	plan_GAIekvIXRlAO8M
\.


--
-- Data for Name: users_usersubscriptionorder; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.users_usersubscriptionorder (created, modified, id, active, subscription_plan_id, user_id) FROM stdin;
2019-11-14 17:30:58.530424+05:30	2019-11-14 17:30:58.545922+05:30	e437800c-0b70-4caa-9ae1-7bc7f49be974	t	d5eb20f4-fced-40f4-ba75-f4ea491b65a2	56
2019-11-14 18:59:29.415583+05:30	2019-11-14 18:59:29.428404+05:30	97823ff6-eaf8-4a23-be7e-cfec7482058e	t	d5eb20f4-fced-40f4-ba75-f4ea491b65a2	57
2019-11-15 11:07:05.440618+05:30	2019-11-15 11:07:05.450342+05:30	c4b754af-d2d1-430a-9eef-cff6e81fe706	t	7a26a72e-6bee-4507-a6ac-96a6c475012f	65
2019-11-25 15:19:35.266096+05:30	2019-11-25 15:19:35.273303+05:30	4c9888fc-ed03-4e88-b071-7a251cce0529	t	1bb3cd33-4cc4-4449-a6f4-465d2d91c26e	257
2019-11-15 12:15:02.528874+05:30	2019-11-15 12:15:02.561603+05:30	5c74a6bd-935b-48c6-9414-ba49c5371d07	t	1bb3cd33-4cc4-4449-a6f4-465d2d91c26e	69
2019-11-25 15:31:18.388329+05:30	2019-11-25 15:31:18.424375+05:30	9b44af77-3341-402d-aafe-b64cec8c1269	t	1bb3cd33-4cc4-4449-a6f4-465d2d91c26e	260
2019-11-25 15:31:18.396223+05:30	2019-11-25 15:31:18.446635+05:30	bb940919-3277-4113-9477-a3104004d96e	t	1bb3cd33-4cc4-4449-a6f4-465d2d91c26e	260
2019-11-25 15:53:39.462933+05:30	2019-11-25 15:53:39.47005+05:30	8a189dfb-cbf9-4baf-b178-83d494e5ac3e	t	1bb3cd33-4cc4-4449-a6f4-465d2d91c26e	261
2019-11-20 12:27:28.620244+05:30	2019-11-20 12:27:28.628234+05:30	d96030ed-930c-4886-ab74-50a88d2885f4	t	d5eb20f4-fced-40f4-ba75-f4ea491b65a2	170
2019-11-25 18:30:19.643271+05:30	2019-11-25 18:30:19.662252+05:30	e4f58007-b831-4959-bb67-34cc7642f2d6	t	1bb3cd33-4cc4-4449-a6f4-465d2d91c26e	271
2019-11-13 17:51:42.44728+05:30	2019-11-13 17:51:42.462231+05:30	ab452e33-44b1-41e2-8f35-c2d5f157e824	t	d5eb20f4-fced-40f4-ba75-f4ea491b65a2	42
2019-11-26 12:00:36.287784+05:30	2019-11-26 12:00:36.295733+05:30	eee5172f-dfc4-43b8-aebe-2ec4347dda59	t	1bb3cd33-4cc4-4449-a6f4-465d2d91c26e	276
2019-11-20 15:00:50.797833+05:30	2019-11-20 15:00:50.805336+05:30	90959898-043c-4d02-9f0d-eeba5f6a9d75	t	d5eb20f4-fced-40f4-ba75-f4ea491b65a2	182
2019-11-15 17:59:58.931301+05:30	2019-11-15 17:59:58.948726+05:30	dbe57f7d-e26d-4662-95d9-935143de657c	t	cfa32bbf-d553-48d6-b7f5-4af4907c6cf7	73
2019-11-20 15:21:14.776764+05:30	2019-11-20 15:21:14.781009+05:30	8970d661-00e7-4078-922c-dd6693ea82c0	t	7a26a72e-6bee-4507-a6ac-96a6c475012f	189
2019-11-20 16:09:22.981885+05:30	2019-11-20 16:09:22.989634+05:30	c19786b1-8ea0-4a97-b0b4-492ce522e967	t	07730a91-cb26-4dd2-9001-e8c838d6943c	197
2019-11-20 16:11:21.314741+05:30	2019-11-20 16:11:21.323064+05:30	139b7f79-4edb-4b20-98ff-588addd529b5	t	7a26a72e-6bee-4507-a6ac-96a6c475012f	198
2019-11-16 15:31:54.959903+05:30	2019-11-16 15:31:54.973321+05:30	476bc875-999d-4beb-9a6a-f660effbe741	t	cfa32bbf-d553-48d6-b7f5-4af4907c6cf7	92
2019-11-16 16:02:54.989899+05:30	2019-11-16 16:02:55.001675+05:30	ec9c677d-e9cf-4923-9e9b-6f4acbba00cd	t	d5eb20f4-fced-40f4-ba75-f4ea491b65a2	93
2019-11-16 16:04:43.410196+05:30	2019-11-16 16:04:43.426575+05:30	433adfac-ab6f-4522-80ff-4ddd6ac022f4	t	d5eb20f4-fced-40f4-ba75-f4ea491b65a2	94
2019-11-16 16:17:38.954551+05:30	2019-11-16 16:17:38.970055+05:30	3610a221-f037-4924-bbdd-bc1e7f055652	t	cfa32bbf-d553-48d6-b7f5-4af4907c6cf7	96
2019-11-16 16:18:17.976756+05:30	2019-11-16 16:18:17.992564+05:30	eb7e3bb7-99aa-43ed-807c-c301c7e005b2	t	cfa32bbf-d553-48d6-b7f5-4af4907c6cf7	97
2019-11-20 11:13:49.300099+05:30	2019-11-20 11:13:49.308492+05:30	d57a6b53-43e4-4691-984c-c143bf83bc8e	t	d5eb20f4-fced-40f4-ba75-f4ea491b65a2	156
\.


--
-- Data for Name: users_video; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_video (id, video) FROM stdin;
6	sample.mp4
5	sample.mp4
4	sample.mp4
3	sample.mp4
2	sample.mp4
1	sample.mp4
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 115, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 276, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 280, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 22, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 57, true);


--
-- Name: static_pages_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.static_pages_post_id_seq', 1, false);


--
-- Name: users_privacypolicy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_privacypolicy_id_seq', 1, true);


--
-- Name: users_video_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_video_id_seq', 6, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: customer_support_contactus customer_support_contactus_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.customer_support_contactus
    ADD CONSTRAINT customer_support_contactus_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: models_games models_games_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models_games
    ADD CONSTRAINT models_games_name_key UNIQUE (name);


--
-- Name: models_games models_games_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models_games
    ADD CONSTRAINT models_games_pkey PRIMARY KEY (id);


--
-- Name: models_mlalgorithms models_mlalgorithms_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models_mlalgorithms
    ADD CONSTRAINT models_mlalgorithms_name_key UNIQUE (name);


--
-- Name: models_mlalgorithms models_mlalgorithms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models_mlalgorithms
    ADD CONSTRAINT models_mlalgorithms_pkey PRIMARY KEY (id);


--
-- Name: models_predictorvarriables models_predictorvarriables_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models_predictorvarriables
    ADD CONSTRAINT models_predictorvarriables_name_key UNIQUE (name);


--
-- Name: models_predictorvarriables models_predictorvarriables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models_predictorvarriables
    ADD CONSTRAINT models_predictorvarriables_pkey PRIMARY KEY (id);


--
-- Name: models_sports models_sports_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models_sports
    ADD CONSTRAINT models_sports_name_key UNIQUE (name);


--
-- Name: models_sports models_sports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models_sports
    ADD CONSTRAINT models_sports_pkey PRIMARY KEY (id);


--
-- Name: models_targetvarriables models_targetvarriables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models_targetvarriables
    ADD CONSTRAINT models_targetvarriables_pkey PRIMARY KEY (id);


--
-- Name: orders_card orders_card_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.orders_card
    ADD CONSTRAINT orders_card_pkey PRIMARY KEY (id);


--
-- Name: static_pages_post static_pages_post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.static_pages_post
    ADD CONSTRAINT static_pages_post_pkey PRIMARY KEY (id);


--
-- Name: users_privacypolicy users_privacypolicy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_privacypolicy
    ADD CONSTRAINT users_privacypolicy_pkey PRIMARY KEY (id);


--
-- Name: users_profile users_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.users_profile
    ADD CONSTRAINT users_profile_pkey PRIMARY KEY (id);


--
-- Name: users_profile users_profile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.users_profile
    ADD CONSTRAINT users_profile_user_id_key UNIQUE (user_id);


--
-- Name: users_subscriptionplan users_subscriptionplan_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.users_subscriptionplan
    ADD CONSTRAINT users_subscriptionplan_pkey PRIMARY KEY (id);


--
-- Name: users_usersubscriptionorder users_usersubscriptionorder_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.users_usersubscriptionorder
    ADD CONSTRAINT users_usersubscriptionorder_pkey PRIMARY KEY (id);


--
-- Name: users_video users_video_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_video
    ADD CONSTRAINT users_video_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: models_games_name_9a9daa81_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX models_games_name_9a9daa81_like ON public.models_games USING btree (name varchar_pattern_ops);


--
-- Name: models_games_sport_id_fd27fac8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX models_games_sport_id_fd27fac8 ON public.models_games USING btree (sport_id);


--
-- Name: models_mlalgorithms_name_7f357a64_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX models_mlalgorithms_name_7f357a64_like ON public.models_mlalgorithms USING btree (name varchar_pattern_ops);


--
-- Name: models_predictorvarriables_name_17509d75_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX models_predictorvarriables_name_17509d75_like ON public.models_predictorvarriables USING btree (name varchar_pattern_ops);


--
-- Name: models_predictorvarriables_sport_id_03f4b402; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX models_predictorvarriables_sport_id_03f4b402 ON public.models_predictorvarriables USING btree (sport_id);


--
-- Name: models_sports_name_fddd97e4_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX models_sports_name_fddd97e4_like ON public.models_sports USING btree (name varchar_pattern_ops);


--
-- Name: models_targetvarriables_sport_id_61dd992c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX models_targetvarriables_sport_id_61dd992c ON public.models_targetvarriables USING btree (sport_id);


--
-- Name: orders_card_card_holder_id_172c4daa; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX orders_card_card_holder_id_172c4daa ON public.orders_card USING btree (card_holder_id);


--
-- Name: users_usersubscriptionorder_subscription_plan_id_5895d461; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX users_usersubscriptionorder_subscription_plan_id_5895d461 ON public.users_usersubscriptionorder USING btree (subscription_plan_id);


--
-- Name: users_usersubscriptionorder_user_id_952a6a1b; Type: INDEX; Schema: public; Owner: polymath
--

CREATE INDEX users_usersubscriptionorder_user_id_952a6a1b ON public.users_usersubscriptionorder USING btree (user_id);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: models_games models_games_sport_id_fd27fac8_fk_models_sports_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models_games
    ADD CONSTRAINT models_games_sport_id_fd27fac8_fk_models_sports_id FOREIGN KEY (sport_id) REFERENCES public.models_sports(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: models_predictorvarriables models_predictorvarr_sport_id_03f4b402_fk_models_sp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models_predictorvarriables
    ADD CONSTRAINT models_predictorvarr_sport_id_03f4b402_fk_models_sp FOREIGN KEY (sport_id) REFERENCES public.models_sports(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: models_targetvarriables models_targetvarriables_sport_id_61dd992c_fk_models_sports_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models_targetvarriables
    ADD CONSTRAINT models_targetvarriables_sport_id_61dd992c_fk_models_sports_id FOREIGN KEY (sport_id) REFERENCES public.models_sports(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_card orders_card_card_holder_id_172c4daa_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.orders_card
    ADD CONSTRAINT orders_card_card_holder_id_172c4daa_fk_auth_user_id FOREIGN KEY (card_holder_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_profile users_profile_user_id_2112e78d_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.users_profile
    ADD CONSTRAINT users_profile_user_id_2112e78d_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_usersubscriptionorder users_usersubscripti_subscription_plan_id_5895d461_fk_users_sub; Type: FK CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.users_usersubscriptionorder
    ADD CONSTRAINT users_usersubscripti_subscription_plan_id_5895d461_fk_users_sub FOREIGN KEY (subscription_plan_id) REFERENCES public.users_subscriptionplan(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_usersubscriptionorder users_usersubscriptionorder_user_id_952a6a1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.users_usersubscriptionorder
    ADD CONSTRAINT users_usersubscriptionorder_user_id_952a6a1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

