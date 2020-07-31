--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5 (Ubuntu 11.5-1.pgdg18.04+1)
-- Dumped by pg_dump version 11.5 (Ubuntu 11.5-1.pgdg18.04+1)

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

SET default_with_oids = false;

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
-- Name: orders_card; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.orders_card (
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    name character varying(30) NOT NULL,
    card_number character varying(16) NOT NULL,
    expiry_date date NOT NULL,
    cvv integer NOT NULL,
    card_provider character varying(30),
    card_logo character varying(100),
    status boolean NOT NULL,
    card_holder_id integer NOT NULL
);


ALTER TABLE public.orders_card OWNER TO polymath;

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
    birth_date date,
    user_id integer NOT NULL,
    profile_pic character varying(100)
);


ALTER TABLE public.users_profile OWNER TO polymath;

--
-- Name: users_subscriptionplan; Type: TABLE; Schema: public; Owner: polymath
--

CREATE TABLE public.users_subscriptionplan (
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    amount integer NOT NULL,
    status boolean NOT NULL,
    name character varying(30) NOT NULL,
    duration interval NOT NULL
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
1	Can add Subscription Plan	1	add_subscriptionplan
2	Can change Subscription Plan	1	change_subscriptionplan
3	Can delete Subscription Plan	1	delete_subscriptionplan
4	Can view Subscription Plan	1	view_subscriptionplan
5	Can add Profile	2	add_profile
6	Can change Profile	2	change_profile
7	Can delete Profile	2	delete_profile
8	Can view Profile	2	view_profile
9	Can add log entry	3	add_logentry
10	Can change log entry	3	change_logentry
11	Can delete log entry	3	delete_logentry
12	Can view log entry	3	view_logentry
13	Can add permission	4	add_permission
14	Can change permission	4	change_permission
15	Can delete permission	4	delete_permission
16	Can view permission	4	view_permission
17	Can add group	5	add_group
18	Can change group	5	change_group
19	Can delete group	5	delete_group
20	Can view group	5	view_group
21	Can add user	6	add_user
22	Can change user	6	change_user
23	Can delete user	6	delete_user
24	Can view user	6	view_user
25	Can add content type	7	add_contenttype
26	Can change content type	7	change_contenttype
27	Can delete content type	7	delete_contenttype
28	Can view content type	7	view_contenttype
29	Can add session	8	add_session
30	Can change session	8	change_session
31	Can delete session	8	delete_session
32	Can view session	8	view_session
33	Can add user subscription order	9	add_usersubscriptionorder
34	Can change user subscription order	9	change_usersubscriptionorder
35	Can delete user subscription order	9	delete_usersubscriptionorder
36	Can view user subscription order	9	view_usersubscriptionorder
37	Can add Card	10	add_card
38	Can change Card	10	change_card
39	Can delete Card	10	delete_card
40	Can view Card	10	view_card
41	Can add contact us	11	add_contactus
42	Can change contact us	11	change_contactus
43	Can delete contact us	11	delete_contactus
44	Can view contact us	11	view_contactus
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
4	pbkdf2_sha256$150000$KdA1xsIo8mBK$itjjqi99USTwohhVyE696BQxBKitYHRegp1Sa0qJJPg=	\N	f	aanoop@yopmail.com	Anoop Kumar		aanoop@yopmail.com	f	t	2019-09-17 13:56:17.809305+00
5	pbkdf2_sha256$150000$Zx0p4Ti6I1V8$85LPLlSDkSxiwqi1H3nm7WhxqOoIRE04f/KsXwtMysA=	\N	f	case@yopmail.com	ultacase		case@yopmail.com	f	t	2019-09-17 14:03:14.87387+00
6	pbkdf2_sha256$150000$f8Ub727nDlSC$IyIFuEUjhYK+nnfOmkFYtBLzkSjKutWVty7iegXLsPo=	2019-09-17 14:41:31.000912+00	f	test@yopmail.com	test		test@yopmail.com	f	t	2019-09-17 14:41:30.752779+00
7	pbkdf2_sha256$150000$7lz28oEeccCu$IvOKW1zDikXt0xS15MgaF4VV2U31kf2UJ80g8MkoHXU=	2019-09-18 05:46:14.264754+00	f	prateek@ava.c	prateek54555465		prateek@ava.c	f	t	2019-09-18 05:46:14.048716+00
3	pbkdf2_sha256$150000$kBDw5hnAGW5R$/N0l8ZioKdZneLsEz1t+VyfatTjKoeYlg8Rg64XK9Z0=	2019-09-17 13:54:14.045878+00	t	anoop	Anoop		anoop@yopmail.com	t	t	2019-09-17 13:53:50.113334+00
29	pbkdf2_sha256$150000$jzM87HS29uq5$BwSIlYTpFb2ND2pFxWtyeakHLsdHchR506bKYYF4JdM=	\N	f	nirupma.ch@yopmail.com	nirupma		nirupma.ch@yopmail.com	f	f	2019-11-07 05:01:13.260077+00
30	pbkdf2_sha256$150000$jlv1XoN5fGz6$zbo/ZHSZW6bT4URaR/EJCZxJY7WK4cv7HKSnuGZ0aKc=	\N	f	nirupama.cha@yopmail.com	nirupma		nirupama.cha@yopmail.com	f	f	2019-11-07 05:32:06.555049+00
27	pbkdf2_sha256$150000$jKARuHFx0N2D$sgpcki3qdINu7Qd6z3cw9Ia3hpNKtfTutFbKd7bPC5Y=	2019-11-05 07:28:26.033707+00	f	nirupama@yopmail.com	nirupma		nirupama@yopmail.com	f	t	2019-11-05 07:27:32.470149+00
9	pbkdf2_sha256$150000$LjNIUwkzhkGw$S8Q2THFSSD1B/ZjnAewL7Fp9L3KKOwBlimcqRe412/o=	2019-09-20 10:26:19.532377+00	f	anoop1@yopmail.com	Anoop Kumar		anoop1@yopmail.com	f	t	2019-09-20 10:26:19.312426+00
11	pbkdf2_sha256$150000$dqImYXnBXRFN$zz2Zq1kXHpNMPqelAnYn2C8U8+weQ5DkLg6g6WixPC4=	2019-09-25 13:48:41.192405+00	f	prateek@avainfotech.com	Prateek Sharma		prateek@avainfotech.com	f	t	2019-09-20 11:56:13.762574+00
10	pbkdf2_sha256$150000$TEKXroIdJxzn$/TUCP2R8HNlqOfUopuF6hT67yGt9t3UfdIwx9uiCNpw=	2019-09-20 11:40:47.932433+00	f	oman@yopmail.com	oman		oman@yopmail.com	f	t	2019-09-20 11:40:47.706974+00
12	pbkdf2_sha256$150000$kFkbj16ukIef$OUHmPhdvl9w9fJ5yQ+Vm0AnsJ+OMPpWxLuouGnc5s0A=	\N	f	vikrant@avainfotech.com	vikrant		vikrant@avainfotech.com	f	f	2019-09-21 04:29:05.921593+00
31	pbkdf2_sha256$150000$UfsP3aYGTIRe$idjFGs0N3zX5O31JJ7CUuZdF/UNFhToMBVvQLJpOrCs=	\N	f	amansinghbawa19@gmail.com	aman		amansinghbawa19@gmail.com	f	f	2019-11-07 06:25:16.620715+00
14	pbkdf2_sha256$150000$w12pKEpCLaXP$rxjomBt9mlZaMwym8GX2sev+8QTHT6P2sRFPQdmwVrk=	2019-09-25 09:47:32.379106+00	t	admin				t	t	2019-09-24 13:25:26.559257+00
23	pbkdf2_sha256$150000$qteRRIUaeZIS$j1v4FttKUqsLTBNp94WawLu/PW7FPmd7wwzL5DBLkHc=	2019-10-02 13:52:03.998732+00	f	g_s_d@yahoo.com	Giani		g_s_d@yahoo.com	f	t	2019-10-02 13:50:10.339615+00
32	pbkdf2_sha256$150000$mLuKEzKWO8AQ$l1G6xe+MQ4++6TjSVaZFDvQNRvUAbjoMWU80FlgbkjM=	2019-11-07 06:44:21.972309+00	t	test@123				t	t	2019-11-07 06:31:59.239548+00
24	pbkdf2_sha256$150000$x04DxwT5eN2Y$INpazXCoVrgGsKaB0ZPqqhV7fa19J5kiI/3NMG0Bgcc=	\N	f	abc@gmail.com	gfsr		abc@gmail.com	f	f	2019-10-11 05:32:10.061065+00
28	pbkdf2_sha256$150000$FekKu6vXKL5s$NkUVt20rdatK9gcpaTEj/5R2QfsceRFklYd6aWCFsv8=	\N	f	nirupma@yopmail.com	test12		nirupma@yopmail.com	f	f	2019-11-07 04:58:37.822634+00
22	pbkdf2_sha256$150000$5IvjwVjUZpXy$ov4L3ZueKjSY5yMGubFZ3qAAtHEYmRrCSlSTmt1QOI8=	2019-10-11 07:06:25.783482+00	f	shivi@avainfotech.com	shivi		shivi@avainfotech.com	f	t	2019-09-25 10:46:29.261638+00
25	pbkdf2_sha256$150000$AL7OdpA8dmyS$lJ8E5JDyd3PigGmie75v/nPWp8riNLS15cb3wZhAQh0=	\N	f	arronoliver2586@gmail.com	fTUVDZtIKMrcxXu		arronoliver2586@gmail.com	f	f	2019-10-14 18:51:36.883496+00
26	pbkdf2_sha256$150000$LUPGT0Bf9ZWh$ykEDT2i+CJiZAXIMbOVTVT5GTDgtD/HklyTGIZJ+Hhk=	\N	f	mario95pgonz@hotmail.es				f	t	2019-10-26 00:20:10.554222+00
13	pbkdf2_sha256$150000$oE8EAoDW1DQe$6M5elq0IMQMMS88PV7N42Mrgw2u/5JWVtzEVutrBDMM=	2019-10-29 10:51:19.696406+00	f	amansinghbawa@gmail.com	Aman Preet Singh		amansinghbawa@gmail.com	f	t	2019-09-21 09:55:16.002832+00
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
2019-09-21 11:02:06.952153+00	2019-09-21 11:02:06.953914+00	713e582a-4202-4ddd-8dec-91fb44542e4d	prateek	prateek@avainfotech.com	test	testwerr
2019-09-25 07:48:57.343581+00	2019-09-25 07:48:57.345324+00	b2cf01d6-cc8b-4c6e-94f7-780f0af288fc	shivi	shandilyashivi6@gmail.com	fdfd	fdffd
2019-09-25 07:51:22.353536+00	2019-09-25 07:51:22.355453+00	aeee24c7-cc91-4aaf-af07-8ee93955094e	shivi	shandilyashivi6@gmail.com	fdfd	fdffd
2019-09-25 07:51:34.706947+00	2019-09-25 07:51:34.708635+00	b4dad0f6-15aa-4aef-8210-369ed2c5f957	shivi	shandilyashivi6@gmail.com	fdfd	fdffd
2019-09-25 07:53:37.573187+00	2019-09-25 07:53:37.574742+00	b38207c6-9d60-460a-8de8-9461fc0e9b2b	shivi	shandilyashivi6@gmail.com	sdas	dsds
2019-09-25 07:55:49.301815+00	2019-09-25 07:55:49.303532+00	2252f4bc-2de9-43ce-9ea7-4536e25a230c	shivi	shandilyashivi6@gmail.com	sdas	dsds
2019-09-25 07:56:00.472119+00	2019-09-25 07:56:00.473676+00	d6f35275-a3dc-488c-9958-e43e0eb25b61	shivi	shandilyashivi6@gmail.com	sdas	dsds
2019-09-25 09:13:47.447779+00	2019-09-25 09:13:47.449521+00	1deed616-0fe1-45fe-9a12-96b1a5c7a017	shivi	shandilyashivi6@gmail.com	sdas	dsds
2019-09-25 09:24:39.29599+00	2019-09-25 09:24:39.297511+00	f342400a-189e-49b3-bb48-1ec26b7bf039	shivi	shivi@avainfotech.com	fdfds	fdff
2019-10-02 14:28:08.685587+00	2019-10-02 14:28:08.687176+00	ee7c742e-1934-4a11-9d3b-f4c78211e4d3	Geraldgooms	eric1970@tele2.nl	Beatport Music Releases	Hello, \r\nMP3s Club Music for DJs, More Info: http://0daymusic.orgt \r\nDownload 0DAY-MP3s Private Server, For DJs Electronika Musica \r\n \r\nRegards, \r\n0DAY Music
2019-10-02 21:40:36.519873+00	2019-10-02 21:40:36.521467+00	f133abf6-170a-4261-aadd-b228da00a57d	Geraldgooms	eric1970@tele2.nl	Beatport Music Releases	Hello, \r\nMP3s Club Music for DJs, More Info: http://0daymusic.orgt \r\nDownload 0DAY-MP3s Private Server, For DJs Electronika Musica \r\n \r\nRegards, \r\n0DAY Music
2019-10-11 04:40:56.980604+00	2019-10-11 04:40:56.983163+00	4bf732df-dccf-4a9e-a501-8d7d1b288a4c	dfweaf	efewf	wefwe	efed
2019-10-11 04:41:19.093532+00	2019-10-11 04:41:19.095185+00	3d1e08bc-5392-40de-9017-cdbd62262b0c	werf	erfwe	ef	fef
2019-10-11 04:41:37.478253+00	2019-10-11 04:41:37.479929+00	57a00f72-e589-4495-a057-004da6a3a996	fdsg	rg	rt	rte
2019-10-11 05:28:11.939437+00	2019-10-11 05:28:11.941139+00	67034964-0d58-44ab-823c-b9bc7b08bd5c	kjmkl	gli	lh	lhlh
2019-10-11 05:28:25.970198+00	2019-10-11 05:28:25.971829+00	2c7c65c9-fc7a-4230-899d-889a927f697a	gfsr	dfgdfg	dfgdg	fgdg
2019-10-11 05:29:45.936289+00	2019-10-11 05:29:45.937998+00	8a344816-1004-4e38-bf93-8eb3546f5205	klkh	hlkh	hkl	hkl
2019-10-11 05:30:08.304492+00	2019-10-11 05:30:08.306131+00	bbff1170-7047-4745-a6f1-cb7e43118272	ioloi	uioui	iu	ol
2019-10-14 18:50:43.304908+00	2019-10-14 18:50:43.307656+00	ea7b8252-dedd-4dcf-9de8-257b9c0fcdeb	dkNGeuxnFCRtB	arronoliver2586@gmail.com	SWmtzXbVgknABjT	IjXbKwuHTRAC
2019-10-14 18:51:17.127825+00	2019-10-14 18:51:17.129494+00	f0f10040-1ccb-4ba3-ae08-fe3cf65d41ff	xSdpivKb	arronoliver2586@gmail.com	hQLVBwZcEDmMjz	etZEsJfcwG
2019-10-25 21:37:58.620526+00	2019-10-25 21:37:58.622696+00	a4ba0e43-6038-4bf3-b29a-e6bb364a2b96	Winston	alexanderiizv65@thefirstpageplan.com	Your site, quick question...	Hey guys, I just wanted to see if you need anything in the way of site editing/code fixing/programming, unique blog post material, extra traffic, social media management, etc.  I have quite a few ways I can set all of this and do thhis for you.  Don't mean to impose, was just curious, I've been doing thhis for some time and was just curious if you needed an extra hand. I can even do Wordpress and other related tasks (you name it).\r\n\r\nPS - I'm here in the states, no need to outsource :-)\r\n\r\nWinston R.\r\n1.708.320.3171
2019-10-27 00:47:32.793596+00	2019-10-27 00:47:32.795402+00	54733e6f-6477-4250-8060-4c90c73d0d5c	Eric Jones	eric@talkwithcustomer.com	Do You Want Up to 100X More Conversions?	Hey,\r\n\r\nYou have a website polymathsports.com, right?\r\n\r\nOf course you do. I am looking at your website now.\r\n\r\nIt gets traffic every day – that you’re probably spending $2 / $4 / $10 or more a click to get.  Not including all of the work you put into creating social media, videos, blog posts, emails, and so on.\r\n\r\nSo you’re investing seriously in getting people to that site.\r\n\r\nBut how’s it working?  Great? Okay?  Not so much?\r\n\r\nIf that answer could be better, then it’s likely you’re putting a lot of time, effort, and money into an approach that’s not paying off like it should.\r\n\r\nNow… imagine doubling your lead conversion in just minutes… In fact, I’ll go even better.\r\n \r\nYou could actually get up to 100X more conversions!\r\n\r\nI’m not making this up.  As Chris Smith, best-selling author of The Conversion Code says: Speed is essential - there is a 100x decrease in Leads when a Lead is contacted within 14 minutes vs being contacted within 5 minutes.\r\n\r\nHe’s backed up by a study at MIT that found the odds of contacting a lead will increase by 100 times if attempted in 5 minutes or less.\r\n\r\nAgain, out of the 100s of visitors to your website, how many actually call to become clients?\r\n\r\nWell, you can significantly increase the number of calls you get – with ZERO extra effort.\r\n\r\nTalkWithCustomer makes it easy, simple, and fast – in fact, you can start getting more calls today… and at absolutely no charge to you.\r\n\r\nCLICK HERE http://www.talkwithcustomer.com now to take a free, 14-day test drive to find out how.\r\n\r\nSincerely,\r\nEric\r\n\r\nPS: Don’t just take my word for it, TalkWithCustomer works:\r\nEMA has been looking for ways to reach out to an audience. TalkWithCustomer so far is the most direct call of action. It has produced above average closing ratios and we are thrilled. Thank you for providing a real and effective tool to generate REAL leads. - P MontesDeOca.\r\nBest of all, act now to get a no-cost 14-Day Test Drive – our gift to you just for giving TalkWithCustomer a try. \r\nCLICK HERE http://www.talkwithcustomer.com to start converting up to 100X more leads today!\r\n\r\nIf you'd like to unsubscribe click here http://liveserveronline.com/talkwithcustomer.aspx?d=polymathsports.com\r\n
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2019-09-17 13:54:39.442375+00	a832bf5b-2543-468f-b8eb-b9c0819fd93a	Free	1	[{"added": {}}]	1	3
2	2019-09-17 13:54:57.048437+00	7f0b8b63-2006-47d5-a375-2db8208b343e	Weekly	1	[{"added": {}}]	1	3
3	2019-09-17 13:55:24.852909+00	211ea5af-65b3-4a74-8674-01d34f3da0f2	Monthly	1	[{"added": {}}]	1	3
4	2019-09-17 13:55:52.825614+00	0082f7c4-fff2-44d1-a547-92f0ce2b43c6	Yearly	1	[{"added": {}}]	1	3
5	2019-09-24 13:44:16.387205+00	a832bf5b-2543-468f-b8eb-b9c0819fd93a	FREE	2	[{"changed": {"fields": ["name"]}}]	1	14
6	2019-09-25 09:48:32.987967+00	d2a42116-d55e-49c5-a7c8-2134f034d12d	shivi@avainfotech.com	3		2	14
7	2019-09-25 09:48:32.990055+00	87b629e7-75b9-4f3b-a8ae-a1e93fd97b26	shivisharma135@gmail.com	3		2	14
8	2019-09-25 09:48:32.991389+00	36552933-421e-4833-9cfe-4b909308b361	shandilyashivi6@gmail.com	3		2	14
9	2019-09-25 09:49:00.478029+00	b55aa0a1-f027-4ae9-ba04-aecbc10d76e1	diksha@avainfotech.com	3		2	14
10	2019-09-25 09:49:00.480033+00	52841cad-6cc7-4d61-bcfd-f9ab4c35dfa7	testdev@gmail.com	3		2	14
11	2019-09-25 09:51:30.074838+00	18	shandilyashivi6@gmail.com	3		6	14
12	2019-09-25 09:51:55.897561+00	17	diksha@avainfotech.com	3		6	14
13	2019-09-25 09:51:55.899386+00	8	shivi@avainfotech.com	3		6	14
14	2019-09-25 09:51:55.908465+00	16	shivisharma135@gmail.com	3		6	14
15	2019-09-25 09:52:09.823228+00	15	testdev@gmail.com	3		6	14
16	2019-09-25 10:24:51.755348+00	19	shivi@avainfotech.com	3		6	14
17	2019-09-25 10:26:19.558247+00	20	shivi@avainfotech.com	3		6	14
18	2019-09-25 10:44:57.70523+00	21	shivi@avainfotech.com	3		6	14
19	2019-11-07 06:57:13.084684+00	28	nirupma@yopmail.com	2	[{"changed": {"fields": ["password"]}}]	6	32
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	users	subscriptionplan
2	users	profile
3	admin	logentry
4	auth	permission
5	auth	group
6	auth	user
7	contenttypes	contenttype
8	sessions	session
9	users	usersubscriptionorder
10	orders	card
11	customer_support	contactus
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2019-09-13 05:07:37.824323+00
2	auth	0001_initial	2019-09-13 05:07:37.921966+00
3	admin	0001_initial	2019-09-13 05:07:38.09292+00
4	admin	0002_logentry_remove_auto_add	2019-09-13 05:07:38.128603+00
5	admin	0003_logentry_add_action_flag_choices	2019-09-13 05:07:38.138499+00
6	contenttypes	0002_remove_content_type_name	2019-09-13 05:07:38.1595+00
7	auth	0002_alter_permission_name_max_length	2019-09-13 05:07:38.164911+00
8	auth	0003_alter_user_email_max_length	2019-09-13 05:07:38.173579+00
9	auth	0004_alter_user_username_opts	2019-09-13 05:07:38.182038+00
10	auth	0005_alter_user_last_login_null	2019-09-13 05:07:38.190639+00
11	auth	0006_require_contenttypes_0002	2019-09-13 05:07:38.192561+00
12	auth	0007_alter_validators_add_error_messages	2019-09-13 05:07:38.200923+00
13	auth	0008_alter_user_username_max_length	2019-09-13 05:07:38.214862+00
14	auth	0009_alter_user_last_name_max_length	2019-09-13 05:07:38.22828+00
15	auth	0010_alter_group_name_max_length	2019-09-13 05:07:38.236856+00
16	auth	0011_update_proxy_permissions	2019-09-13 05:07:38.245279+00
17	sessions	0001_initial	2019-09-13 05:07:38.261721+00
18	users	0001_initial	2019-09-13 05:07:38.32553+00
19	users	0002_auto_20190911_1215	2019-09-13 05:07:38.345823+00
20	users	0003_auto_20190911_1234	2019-09-13 05:07:38.412408+00
21	users	0004_auto_20190911_1351	2019-09-13 05:07:38.541527+00
22	users	0005_profile_subscription	2019-09-17 13:43:05.377853+00
23	users	0006_subscriptionplan_duration	2019-09-17 13:43:05.396066+00
24	users	0007_auto_20190917_1226	2019-09-17 13:43:05.445017+00
25	users	0008_profile_profile_pic	2019-09-17 13:43:05.483749+00
26	orders	0001_initial	2019-09-19 13:06:10.417744+00
27	orders	0002_auto_20190919_1010	2019-09-19 13:06:10.463407+00
28	users	0009_auto_20190919_0735	2019-09-19 13:06:10.475698+00
29	users	0010_auto_20190919_0736	2019-09-19 13:06:10.488321+00
30	customer_support	0001_initial	2019-09-21 09:22:12.860589+00
31	users	0011_contactcus	2019-09-21 09:22:12.88395+00
32	users	0012_auto_20190920_1451	2019-09-21 09:22:12.908804+00
33	users	0013_delete_contactus	2019-09-21 09:22:12.912469+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
s3ixc3ayo6anbqb4693tqnjtqtmsv1na	NGRhODcxY2NmNjYyY2M2N2ZlZTUzNDMxZGIxYzQwZjk2MjFmNTI3NTp7Il9hdXRoX3VzZXJfaWQiOiIzIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIxZDZhOTJlZGJhZGE4NGJhN2Q4MzI4ODBiMGU2NTYyOWRhZDdiMGU3In0=	2019-10-01 13:54:14.048222+00
m4nog3vgaz42obyq00mvmmnorv3486i3	ZTQ1MTNhMDMxZDlkMGFiNzQ0YjI5YjQ5ZDA0ZTI4ZmVmZjFmM2EyNzp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjVhMS00ZDk3Nzk1YjkyODE3MjE1MzY4YiJ9	2019-10-09 09:15:03.409662+00
f9e6d7mqg5nj35k67iph2duiqqjhytpd	ODRhYjcxMWQ1MDQ1MzhkNDE1MTJiMGYzYzY1YmZjOTQ5YWU2ZDVkNjp7Il9hdXRoX3VzZXJfaWQiOiI4IiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJhOTI0YWU1OGZmNzU5NjU5ZGQxMGJhZGFkNGJhNGVmYWU2NjM4YzJmIn0=	2019-10-04 06:48:16.465617+00
yfxu3fqfag6y4pmci8gtevaveht90wj4	NmM3M2E0NDViNWY1ZjM3YWI1YTRlM2ZjYTJhNGFkYWRhODFkNDA5YTp7Il9hdXRoX3VzZXJfaWQiOiIxNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiYWIzMzJjMTY3ZThhMTg1MTBhNTY4MWNlMDYzMjIwZTU2OTBiOWE5YiJ9	2019-10-09 09:33:37.675083+00
02l4trypa4qcbs36qukr9zspxo92z8s4	ZTQ1MTNhMDMxZDlkMGFiNzQ0YjI5YjQ5ZDA0ZTI4ZmVmZjFmM2EyNzp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjVhMS00ZDk3Nzk1YjkyODE3MjE1MzY4YiJ9	2019-10-09 09:43:55.858647+00
zokvb3b6byiqrsdusw0q22g88cbq1jvr	M2I5ZTU4N2U3MTI3NzYzZDg3ZTliZDMyMmQ4ZmQxOGFkYzdiYWZkMzp7Il9hdXRoX3VzZXJfaWQiOiIxNCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiOTZmMTEyNGJjYjI0MmMwNmYxZGQ3YWVhODM1ZGMyOGJlYTQ3NDM4MSJ9	2019-10-09 09:47:32.381576+00
ca7ayashyo55ttfgl9zp0524gn831uwh	M2Q5NTg3NzUxODAyOTZlYmU1YmQwOWEyYzAyODFhNGY0NDE4YzY5Mzp7Il9hdXRoX3VzZXJfaWQiOiIxMSIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMzk5ZjM3ZDY2YjZlMzA4OTVhZDM4ZDk2NDUzYjZlNGE5NDAzZDMxZSJ9	2019-10-04 11:56:14.001497+00
mwod8z4beigzimtl6v2z0tf3ro0bucan	MzA2YmVhYWQwYjdhNDFkNDc0MDc4NzUwMGQxYTIwZjRlNzI4M2JkMzp7Il9hdXRoX3VzZXJfaWQiOiIxMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMmQxZjNkZGMwNzUzYjRhYmM4NWQ1NzIwZDA1N2MzNjlhYTJhN2QxNyJ9	2019-10-05 09:57:19.571024+00
p3viuzzb8e4vp5u24feugrbml03xs8sa	OTE2MGFjNjMzMmQwNDEzMDM3ZTgwOTUwMWEwN2I0NzFkYjBjOTE1ODp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjU5eC1hMDMzOWU0MDIzYWIzMzAwYWM0YSJ9	2019-10-05 10:53:29.752724+00
jvovtp3xhw81h4mcfqd9g3az6mhmv183	ZmE0YWM5M2M0ZTFiYjA0MzQyYzYyYzRkYmE5YWI2MmVjYWI2ZjA0MDp7Il9hdXRoX3VzZXJfaWQiOiIyMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNzM3ODMwMGUwNzY1MGE2MzYzMTUzZWEyNTdkMmJiZWU0M2E1ZDliNSJ9	2019-10-09 10:54:54.505737+00
lb65covrbgoe226zbu86d4fx1xg4oe61	ZmU4YWFiNzUxMjFkY2I5MjBhNTJhZjVlYjA2MzI5YmIzZWE2MWNiODp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjVhMS0yZWU1Y2Q2ZDA0NzVmNTYyM2Q0NyJ9	2019-10-09 14:06:48.0722+00
36ztueh9hudem6i8pg43qirdm0gjsnut	NTE5MGMyZGExMzUxOTdhMDJkZGJjNTFmOTk2NjgzNDM4M2YxMTNmOTp7Il9hdXRoX3VzZXJfaWQiOiIxMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMDNmMzkzZjdlZWZhOTVlZmQyMDYyMmMyZDhlYWE5NjE0ZDM5NzRlMSJ9	2019-10-08 12:46:28.699155+00
5j39ycusxlt9um1flydbd27lyd8686iv	ZmU4YWFiNzUxMjFkY2I5MjBhNTJhZjVlYjA2MzI5YmIzZWE2MWNiODp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjVhMS0yZWU1Y2Q2ZDA0NzVmNTYyM2Q0NyJ9	2019-10-09 14:07:02.588763+00
052kw2125e8ab1zt9f7858rtic1ralom	MzRiNzZmMDA5MGJjYmMxZjkzZTBhMjJmM2UwZDZkNjA3ZDhhN2QwOTp7fQ==	2019-10-09 14:19:48.456721+00
pqtnuiwsj64bmd0woto6wmuhd5dcv9vw	ZmU4YWFiNzUxMjFkY2I5MjBhNTJhZjVlYjA2MzI5YmIzZWE2MWNiODp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjVhMS0yZWU1Y2Q2ZDA0NzVmNTYyM2Q0NyJ9	2019-10-09 17:06:33.53338+00
uc2xiw2q67iauyvvxmkvxicju6oe4vb1	M2I5ZTU4N2U3MTI3NzYzZDg3ZTliZDMyMmQ4ZmQxOGFkYzdiYWZkMzp7Il9hdXRoX3VzZXJfaWQiOiIxNCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiOTZmMTEyNGJjYjI0MmMwNmYxZGQ3YWVhODM1ZGMyOGJlYTQ3NDM4MSJ9	2019-10-08 13:26:35.936766+00
1a47cq29pqqcj2pcyd42spimh9q795h5	YWYzNjJhZjRlMjU3OWExODM1MTlmOTFhNzcwY2RkOTFjNDQ3MDhhNDp7Il9hdXRoX3VzZXJfaWQiOiIyMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiZDdjNmJjMzU5YjljZjJiZjJiODMxZjYzMDQ0YzIwN2I5NGQ3ZjkxNyJ9	2019-10-16 13:52:04.001211+00
bmrr2mhrksdd5p5ojhlx8tg68uyu6gzk	ZmE0YWM5M2M0ZTFiYjA0MzQyYzYyYzRkYmE5YWI2MmVjYWI2ZjA0MDp7Il9hdXRoX3VzZXJfaWQiOiIyMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNzM3ODMwMGUwNzY1MGE2MzYzMTUzZWEyNTdkMmJiZWU0M2E1ZDliNSJ9	2019-10-17 12:35:38.292218+00
d1crsve0313vl4ssuuq2uhqsmrzirk0b	YjU1ODYxODA5ODBmYWViNDM1OGY5OGIyZjk3YWFjN2Y0M2Y3MjZiNzp7Il9hdXRoX3VzZXJfaWQiOiIxNiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiY2ViYzFhMTRiMDdhZTJhOTgzMGFlYWI3NDU0ODA5NTMzNjdiYTRhMyJ9	2019-10-09 05:43:07.523032+00
0mr8c8znb4g5yvu0dfzanod14hy9zlyi	ZmE0YWM5M2M0ZTFiYjA0MzQyYzYyYzRkYmE5YWI2MmVjYWI2ZjA0MDp7Il9hdXRoX3VzZXJfaWQiOiIyMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNzM3ODMwMGUwNzY1MGE2MzYzMTUzZWEyNTdkMmJiZWU0M2E1ZDliNSJ9	2019-10-21 12:05:17.414461+00
67amh1087oo0jozifguvde04m3cqx88i	ZmE0YWM5M2M0ZTFiYjA0MzQyYzYyYzRkYmE5YWI2MmVjYWI2ZjA0MDp7Il9hdXRoX3VzZXJfaWQiOiIyMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNzM3ODMwMGUwNzY1MGE2MzYzMTUzZWEyNTdkMmJiZWU0M2E1ZDliNSJ9	2019-10-25 05:33:36.503392+00
xil41ih6w8davx1oq9ulq8mueipt0jy4	ZmE0YWM5M2M0ZTFiYjA0MzQyYzYyYzRkYmE5YWI2MmVjYWI2ZjA0MDp7Il9hdXRoX3VzZXJfaWQiOiIyMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNzM3ODMwMGUwNzY1MGE2MzYzMTUzZWEyNTdkMmJiZWU0M2E1ZDliNSJ9	2019-10-25 05:34:01.825207+00
w9yu491e2jvhdfx2dbxdb8nqphyxp492	ZmE0YWM5M2M0ZTFiYjA0MzQyYzYyYzRkYmE5YWI2MmVjYWI2ZjA0MDp7Il9hdXRoX3VzZXJfaWQiOiIyMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNzM3ODMwMGUwNzY1MGE2MzYzMTUzZWEyNTdkMmJiZWU0M2E1ZDliNSJ9	2019-10-25 07:06:25.798083+00
zfl7nkqm7w865l61geiccmf8k6khbw1h	NTE5MGMyZGExMzUxOTdhMDJkZGJjNTFmOTk2NjgzNDM4M2YxMTNmOTp7Il9hdXRoX3VzZXJfaWQiOiIxMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMDNmMzkzZjdlZWZhOTVlZmQyMDYyMmMyZDhlYWE5NjE0ZDM5NzRlMSJ9	2019-11-12 10:51:19.719638+00
zbkisnpiwqu2xr68aodmqokq4hvuj0xc	MTZmYTdmNzAyN2ExZWFiMDE4ZTBmZjEwMThhMzk4YTY1MTc3M2Q5ODp7Il9wYXNzd29yZF9yZXNldF90b2tlbiI6IjVhMS1kZTUwNGIwNDY2ZGE4MjhlYjUzOCJ9	2019-10-09 07:17:34.441597+00
hpo97qx76min1hiqstkw29mqajwvl7p6	ZmVjODVjYzYxMGZlNmJjY2U3NThkNzIyNDk0YTQ0YmNhNDk2NTY4MTp7Il9hdXRoX3VzZXJfaWQiOiIyNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMzY4MWRmMmVmMDUyNGM1ODExNmQ1MDk2ODQ4OTlhYTc2ODE5NmI2YiJ9	2019-11-19 07:28:26.035628+00
89tufclsf5hz3qbeh4ejgf55rkplcucl	MGFiZGY5YTRiMGE0ZTA2ODEzMjIwZmJiNTIzNzdkNGQwOTZiZWQ3MDp7Il9hdXRoX3VzZXJfaWQiOiIxOCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiZmUxMzliNWFkODIzMGEzM2UzYTkyZGU4MzE1MDNmNDg4ODQyYjE5NiJ9	2019-10-09 07:43:58.380881+00
ijyym5ew7cnnn0bgvv0ypuoohq5ua39h	MzRiNzZmMDA5MGJjYmMxZjkzZTBhMjJmM2UwZDZkNjA3ZDhhN2QwOTp7fQ==	2019-11-21 06:23:05.95587+00
aensysj5lerhujck0rw9cxq2ejilwa6a	ZWRjZmM0ODk2ZTI5NjlkZWUyOTJjZTA2NzRhY2I0NmMwYTUyYjIzYjp7Il9hdXRoX3VzZXJfaWQiOiIzMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiYTBmNzhhMjdjZDQwMTM0NDc0ZTA2N2NhZGI1MWEwNDU1YTk5ZTEyYiJ9	2019-11-21 06:32:44.471883+00
wpoyk7flm6kjbz5e6n5adx389qoilrb0	ZWRjZmM0ODk2ZTI5NjlkZWUyOTJjZTA2NzRhY2I0NmMwYTUyYjIzYjp7Il9hdXRoX3VzZXJfaWQiOiIzMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiYTBmNzhhMjdjZDQwMTM0NDc0ZTA2N2NhZGI1MWEwNDU1YTk5ZTEyYiJ9	2019-11-21 06:57:13.091476+00
\.


--
-- Data for Name: orders_card; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.orders_card (created, modified, id, name, card_number, expiry_date, cvv, card_provider, card_logo, status, card_holder_id) FROM stdin;
2019-09-20 11:43:07.359455+00	2019-09-20 11:43:07.361402+00	f1bafd04-222b-43f6-a860-06e71fdb0a5a	dsadadasd	2121312321312321	2022-12-11	231	\N		t	10
2019-09-20 11:58:34.673207+00	2019-09-20 11:58:47.660803+00	b908a934-e08b-4fca-b6bc-8c938b50e583	aman maan 	4343434343434343	2020-02-05	456	\N		f	11
2019-09-24 13:14:07.251378+00	2019-09-24 13:14:26.810971+00	5f2a7743-c1ce-4c83-969a-8bd04b7d7415	prateek	4242424242424242	2019-09-25	123	\N		f	11
\.


--
-- Data for Name: users_profile; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.users_profile (created, modified, id, bio, location, twitter, birth_date, user_id, profile_pic) FROM stdin;
2019-09-17 14:41:30.995529+00	2019-09-17 14:41:30.996932+00	47d5db5f-f35d-41f7-8ee3-3bc791d162f1			@sdasafds	\N	6	
2019-09-18 05:46:14.259349+00	2019-09-18 05:46:14.260677+00	61f2d9a4-d4d5-48e0-ab85-29d3c4599fc2			hjhjkhjkhjh@hjkhjkhjk 	\N	7	
2019-09-19 05:47:04.204759+00	2019-09-19 05:47:15.489479+00	76fcae58-bff7-4e2b-8c56-d8546f5cdd5a			@dsfa	\N	3	profile_pics/46700825_101310200902387_3365781946490683392_n.jpg
2019-09-20 10:26:19.526411+00	2019-09-20 10:26:19.527888+00	14716db6-50f1-4e57-826d-6c648fbc75b9			@fdsfsdf	\N	9	
2019-09-20 11:40:47.926778+00	2019-09-20 11:41:57.937845+00	bf857b8d-ebec-402c-a7aa-2528d8e528c6			@dfsf	\N	10	profile_pics/3.jpg
2019-09-21 04:29:08.678054+00	2019-09-21 04:29:08.679501+00	0850db1d-6955-4efd-8718-6672ee468d04			@jhjhj	\N	12	
2019-09-21 09:55:18.944192+00	2019-09-21 09:55:18.94555+00	7a1c2cd8-a6f5-4bd6-9b04-758a81aed5ff			@amansinghbawa	\N	13	
2019-09-20 11:56:13.973069+00	2019-09-21 10:59:28.879296+00	46fc7cce-d23d-47a9-ad2c-10283ff42ec0			@dfsf	\N	11	profile_pics/png_MSwrsbg.jpg
2019-10-02 13:50:13.356695+00	2019-10-02 13:50:13.358022+00	463bdfeb-dbb5-41bc-99a7-9ef6d1790fb1				\N	23	
2019-10-11 05:32:12.796005+00	2019-10-11 05:32:12.797344+00	9c0bf35d-214f-4e18-bc2d-c00d09ebfbb1			df	\N	24	
2019-09-25 10:46:31.997432+00	2019-10-11 05:34:47.426742+00	22a29877-9f41-48f2-b495-f8e4351ca359				\N	22	profile_pics/download_ZmRxsSv.jpeg
2019-10-14 18:51:39.377762+00	2019-10-14 18:51:39.379129+00	ac4f95ab-cca7-4a6e-a4c5-3df5091010e2			USvdFeVwtgBE	\N	25	
2019-11-05 07:27:35.449524+00	2019-11-05 07:27:35.4509+00	340a03ab-534e-4215-97fa-af22992034f9			@dwqe3453	\N	27	
2019-11-07 04:58:40.762945+00	2019-11-07 04:58:40.764316+00	1f0af85e-63d6-419b-97c0-ab4036c5774e			@nirupma	\N	28	
2019-11-07 05:01:16.01199+00	2019-11-07 05:01:16.01334+00	0c9362e1-964d-430f-8a64-1ec9f4ef5f79			@nirupma	\N	29	
2019-11-07 05:32:09.413289+00	2019-11-07 05:32:09.414628+00	51dc4cc3-322a-474e-925a-d948b4fca58a			@test	\N	30	
2019-11-07 06:25:19.324277+00	2019-11-07 06:25:19.325606+00	d930e6b5-1e0d-4522-932f-54941e0602f1			@bawaaman	\N	31	
\.


--
-- Data for Name: users_subscriptionplan; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.users_subscriptionplan (created, modified, id, amount, status, name, duration) FROM stdin;
2019-09-17 13:54:57.047933+00	2019-09-17 13:54:57.047955+00	7f0b8b63-2006-47d5-a375-2db8208b343e	5	t	Weekly	00:00:03
2019-09-17 13:55:24.852424+00	2019-09-17 13:55:24.852446+00	211ea5af-65b3-4a74-8674-01d34f3da0f2	30	t	Monthly	30 days
2019-09-17 13:55:52.825118+00	2019-09-17 13:55:52.82514+00	0082f7c4-fff2-44d1-a547-92f0ce2b43c6	120	t	Yearly	365 days
2019-09-17 13:54:39.441715+00	2019-09-24 13:44:16.386156+00	a832bf5b-2543-468f-b8eb-b9c0819fd93a	0	t	FREE	00:00:01
\.


--
-- Data for Name: users_usersubscriptionorder; Type: TABLE DATA; Schema: public; Owner: polymath
--

COPY public.users_usersubscriptionorder (created, modified, id, active, subscription_plan_id, user_id) FROM stdin;
2019-09-17 14:41:30.991822+00	2019-09-17 14:41:30.993855+00	4fbdc1c6-0983-421e-ae4f-c156602ff4fa	t	7f0b8b63-2006-47d5-a375-2db8208b343e	6
2019-09-18 05:46:14.255815+00	2019-09-18 05:46:14.257522+00	cad7251b-49ee-494e-a477-c596bfbe0392	t	a832bf5b-2543-468f-b8eb-b9c0819fd93a	7
2019-09-20 10:26:19.522488+00	2019-09-20 10:26:19.524493+00	1178ae59-07b1-4260-b890-7853fc162713	t	7f0b8b63-2006-47d5-a375-2db8208b343e	9
2019-09-20 11:40:47.92345+00	2019-09-20 11:40:47.925093+00	2894572a-6dae-4844-99b5-fea6d556d8b5	t	7f0b8b63-2006-47d5-a375-2db8208b343e	10
2019-09-20 11:56:13.969745+00	2019-09-20 11:56:13.971392+00	9fae37f1-3a3b-4cc4-9c6b-1c39e505433b	t	a832bf5b-2543-468f-b8eb-b9c0819fd93a	11
2019-09-21 04:29:08.673922+00	2019-09-21 04:29:08.676118+00	7ea84cf6-8cab-441a-9065-940a5eef9a6c	t	a832bf5b-2543-468f-b8eb-b9c0819fd93a	12
2019-09-21 09:55:18.940772+00	2019-09-21 09:55:18.942476+00	9c3868f0-e346-4ce9-8988-5d2a2fcd5274	t	a832bf5b-2543-468f-b8eb-b9c0819fd93a	13
2019-09-25 10:46:31.99412+00	2019-09-25 10:46:31.995878+00	d8a09feb-bde9-4d6a-8077-ce990245dbf5	t	a832bf5b-2543-468f-b8eb-b9c0819fd93a	22
2019-10-02 13:50:13.346012+00	2019-10-02 13:50:13.354906+00	08871665-ab2f-43b8-94a8-dd0a3b7459b2	t	a832bf5b-2543-468f-b8eb-b9c0819fd93a	23
2019-10-11 05:32:12.792482+00	2019-10-11 05:32:12.794351+00	b3e7ad6a-3ccc-49d5-99c9-f7007c1cff43	t	a832bf5b-2543-468f-b8eb-b9c0819fd93a	24
2019-10-14 18:51:39.373817+00	2019-10-14 18:51:39.376053+00	8e50f4c3-1362-4f40-9322-c15ac4138a68	t	0082f7c4-fff2-44d1-a547-92f0ce2b43c6	25
2019-11-05 07:27:35.445511+00	2019-11-05 07:27:35.447867+00	f640c6dd-2007-4b4f-82c3-9005606f6731	t	a832bf5b-2543-468f-b8eb-b9c0819fd93a	27
2019-11-07 04:58:40.759143+00	2019-11-07 04:58:40.761277+00	68edcfdc-185f-47a4-bc4b-9704310b3063	t	7f0b8b63-2006-47d5-a375-2db8208b343e	28
2019-11-07 05:01:16.008142+00	2019-11-07 05:01:16.010338+00	61ee4855-a524-4c1a-8be3-77dbb6071d5d	t	7f0b8b63-2006-47d5-a375-2db8208b343e	29
2019-11-07 05:32:09.4095+00	2019-11-07 05:32:09.411622+00	f3468f19-5073-4479-b0b4-dc0b9fc04591	t	211ea5af-65b3-4a74-8674-01d34f3da0f2	30
2019-11-07 06:25:19.320462+00	2019-11-07 06:25:19.322667+00	9f68f72a-7a14-417a-94dc-4b88d68b7622	t	211ea5af-65b3-4a74-8674-01d34f3da0f2	31
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

SELECT pg_catalog.setval('public.auth_permission_id_seq', 44, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 32, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 19, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 11, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: polymath
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 33, true);


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
-- Name: orders_card orders_card_pkey; Type: CONSTRAINT; Schema: public; Owner: polymath
--

ALTER TABLE ONLY public.orders_card
    ADD CONSTRAINT orders_card_pkey PRIMARY KEY (id);


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

