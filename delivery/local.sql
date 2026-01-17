--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Ubuntu 14.18-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.18 (Ubuntu 14.18-0ubuntu0.22.04.1)

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
-- Name: Logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Logs" (
    id integer NOT NULL,
    action character varying(255) NOT NULL,
    "table" character varying(255) NOT NULL,
    "userId" integer,
    "values" jsonb,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Logs" OWNER TO postgres;

--
-- Name: Logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Logs_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Logs_id_seq" OWNER TO postgres;

--
-- Name: Logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Logs_id_seq" OWNED BY public."Logs".id;


--
-- Name: ProductImages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ProductImages" (
    id integer NOT NULL,
    "productId" integer NOT NULL,
    image character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."ProductImages" OWNER TO postgres;

--
-- Name: ProductImages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ProductImages_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ProductImages_id_seq" OWNER TO postgres;

--
-- Name: ProductImages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ProductImages_id_seq" OWNED BY public."ProductImages".id;


--
-- Name: ages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ages (
    id integer NOT NULL,
    age character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.ages OWNER TO postgres;

--
-- Name: ages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ages_id_seq OWNER TO postgres;

--
-- Name: ages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ages_id_seq OWNED BY public.ages.id;


--
-- Name: banners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banners (
    id integer NOT NULL,
    text character varying(255),
    link character varying(255) DEFAULT 0,
    image character varying(255) DEFAULT 0,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.banners OWNER TO postgres;

--
-- Name: banners_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.banners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.banners_id_seq OWNER TO postgres;

--
-- Name: banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.banners_id_seq OWNED BY public.banners.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(255),
    address1 character varying(255),
    address2 character varying(255),
    city character varying(255),
    state character varying(255),
    phone character varying(255),
    website character varying(255),
    email character varying(255),
    zipcode character varying(255),
    country character varying(255),
    nature character varying(255),
    brand character varying(255),
    lookfor character varying(255),
    area character varying(255),
    size character varying(255),
    request character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: deliveries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deliveries (
    id integer NOT NULL,
    merchant_id integer NOT NULL,
    phone character varying(255) DEFAULT 0 NOT NULL,
    address character varying(255) DEFAULT 0 NOT NULL,
    status integer DEFAULT 0,
    price numeric(10,2) DEFAULT 0 NOT NULL,
    comment character varying(255) DEFAULT 0 NOT NULL,
    driver_id integer DEFAULT 0,
    is_reported boolean DEFAULT false NOT NULL,
    report_id integer DEFAULT 0 NOT NULL,
    delivery_id character varying(10) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    is_paid boolean DEFAULT false,
    is_rural boolean DEFAULT false,
    delivered_at timestamp with time zone,
    driver_comment character varying,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.deliveries OWNER TO postgres;

--
-- Name: deliveries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deliveries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deliveries_id_seq OWNER TO postgres;

--
-- Name: deliveries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deliveries_id_seq OWNED BY public.deliveries.id;


--
-- Name: delivery_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivery_items (
    id integer NOT NULL,
    delivery_id integer NOT NULL,
    good_id integer,
    quantity integer DEFAULT 1 NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.delivery_items OWNER TO postgres;

--
-- Name: delivery_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.delivery_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.delivery_items_id_seq OWNER TO postgres;

--
-- Name: delivery_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.delivery_items_id_seq OWNED BY public.delivery_items.id;


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctors (
    id integer NOT NULL,
    prof character varying(255),
    name character varying(255) DEFAULT 0,
    image character varying(255) DEFAULT 0,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.doctors OWNER TO postgres;

--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctors_id_seq OWNER TO postgres;

--
-- Name: doctors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctors_id_seq OWNED BY public.doctors.id;


--
-- Name: goods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.goods (
    id integer NOT NULL,
    ware_id integer,
    merchant_id integer DEFAULT 0,
    stock integer DEFAULT 0,
    name character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    delivered integer DEFAULT 0,
    in_delivery integer DEFAULT 0
);


ALTER TABLE public.goods OWNER TO postgres;

--
-- Name: goods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.goods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.goods_id_seq OWNER TO postgres;

--
-- Name: goods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.goods_id_seq OWNED BY public.goods.id;


--
-- Name: infos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.infos (
    id integer NOT NULL,
    richtext character varying(255),
    doctor character varying(255) DEFAULT 0,
    image character varying(255) DEFAULT 0,
    audio character varying(255) DEFAULT 0,
    title character varying(255) DEFAULT 0,
    isactive character varying(255) DEFAULT 1,
    category character varying(255) DEFAULT 0,
    gender character varying(255) DEFAULT 0,
    age character varying(255) DEFAULT 0,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.infos OWNER TO postgres;

--
-- Name: infos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.infos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.infos_id_seq OWNER TO postgres;

--
-- Name: infos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.infos_id_seq OWNED BY public.infos.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    title character varying(255),
    body character varying(255),
    type integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    merchant_id integer,
    phone character varying(255) DEFAULT 0,
    address character varying(255) DEFAULT 0,
    status integer DEFAULT 0,
    driver_id integer DEFAULT 0,
    comment character varying(255) DEFAULT 0,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    module character varying(255) NOT NULL,
    action character varying(255) NOT NULL,
    description character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: privacies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.privacies (
    id integer NOT NULL,
    privacy character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.privacies OWNER TO postgres;

--
-- Name: privacies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.privacies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.privacies_id_seq OWNER TO postgres;

--
-- Name: privacies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.privacies_id_seq OWNED BY public.privacies.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(255),
    status integer DEFAULT 0,
    "catId" integer,
    description character varying(255),
    stock integer DEFAULT 0,
    image character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id integer NOT NULL,
    lastname character varying(255),
    firstname character varying(255) DEFAULT 0,
    email character varying(255) DEFAULT 0,
    role character varying(255) DEFAULT 'user'::character varying,
    phone integer DEFAULT 0,
    isactive character varying(255) DEFAULT 1,
    school character varying(255) DEFAULT 0,
    member_type character varying(255) DEFAULT 0,
    start_date character varying(255) DEFAULT 0,
    end_date character varying(255) DEFAULT 0,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.profiles_id_seq OWNER TO postgres;

--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.profiles_id_seq OWNED BY public.profiles.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regions (
    id integer NOT NULL,
    name character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.regions OWNER TO postgres;

--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.regions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.regions_id_seq OWNER TO postgres;

--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requests (
    id integer NOT NULL,
    ware_id integer,
    merchant_id integer DEFAULT 0,
    stock integer DEFAULT 0,
    status integer DEFAULT 0,
    good_id integer DEFAULT 0,
    name character varying(255),
    type integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.requests OWNER TO postgres;

--
-- Name: requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.requests_id_seq OWNER TO postgres;

--
-- Name: requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.requests_id_seq OWNED BY public.requests.id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statuses (
    id integer NOT NULL,
    status character varying(255),
    color character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.statuses OWNER TO postgres;

--
-- Name: statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.statuses_id_seq OWNER TO postgres;

--
-- Name: statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statuses_id_seq OWNED BY public.statuses.id;


--
-- Name: summaries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.summaries (
    id integer NOT NULL,
    merchant_id integer,
    number_delivery integer,
    total numeric(10,2) DEFAULT 0 NOT NULL,
    driver numeric(10,2) DEFAULT 0 NOT NULL,
    account numeric(10,2) DEFAULT 0 NOT NULL,
    comment character varying(255) DEFAULT 0 NOT NULL,
    driver_id integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.summaries OWNER TO postgres;

--
-- Name: summaries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.summaries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.summaries_id_seq OWNER TO postgres;

--
-- Name: summaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.summaries_id_seq OWNED BY public.summaries.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(255),
    password character varying(255),
    role_id integer,
    phone character varying(255),
    email character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: wares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wares (
    id integer NOT NULL,
    name character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.wares OWNER TO postgres;

--
-- Name: wares_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wares_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wares_id_seq OWNER TO postgres;

--
-- Name: wares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wares_id_seq OWNED BY public.wares.id;


--
-- Name: words; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.words (
    id integer NOT NULL,
    ware_id character varying(255),
    merchant_id integer DEFAULT 0,
    stock integer DEFAULT 0,
    name character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.words OWNER TO postgres;

--
-- Name: words_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.words_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.words_id_seq OWNER TO postgres;

--
-- Name: words_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.words_id_seq OWNED BY public.words.id;


--
-- Name: Logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Logs" ALTER COLUMN id SET DEFAULT nextval('public."Logs_id_seq"'::regclass);


--
-- Name: ProductImages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ProductImages" ALTER COLUMN id SET DEFAULT nextval('public."ProductImages_id_seq"'::regclass);


--
-- Name: ages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ages ALTER COLUMN id SET DEFAULT nextval('public.ages_id_seq'::regclass);


--
-- Name: banners id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banners ALTER COLUMN id SET DEFAULT nextval('public.banners_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: deliveries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries ALTER COLUMN id SET DEFAULT nextval('public.deliveries_id_seq'::regclass);


--
-- Name: delivery_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_items ALTER COLUMN id SET DEFAULT nextval('public.delivery_items_id_seq'::regclass);


--
-- Name: doctors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors ALTER COLUMN id SET DEFAULT nextval('public.doctors_id_seq'::regclass);


--
-- Name: goods id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goods ALTER COLUMN id SET DEFAULT nextval('public.goods_id_seq'::regclass);


--
-- Name: infos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.infos ALTER COLUMN id SET DEFAULT nextval('public.infos_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: privacies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privacies ALTER COLUMN id SET DEFAULT nextval('public.privacies_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: profiles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles ALTER COLUMN id SET DEFAULT nextval('public.profiles_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests ALTER COLUMN id SET DEFAULT nextval('public.requests_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: statuses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statuses ALTER COLUMN id SET DEFAULT nextval('public.statuses_id_seq'::regclass);


--
-- Name: summaries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summaries ALTER COLUMN id SET DEFAULT nextval('public.summaries_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: wares id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wares ALTER COLUMN id SET DEFAULT nextval('public.wares_id_seq'::regclass);


--
-- Name: words id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.words ALTER COLUMN id SET DEFAULT nextval('public.words_id_seq'::regclass);


--
-- Data for Name: Logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Logs" (id, action, "table", "userId", "values", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: ProductImages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ProductImages" (id, "productId", image, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: ages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ages (id, age, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: banners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banners (id, text, link, image, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name, address1, address2, city, state, phone, website, email, zipcode, country, nature, brand, lookfor, area, size, request, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: deliveries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deliveries (id, merchant_id, phone, address, status, price, comment, driver_id, is_reported, report_id, delivery_id, "createdAt", "updatedAt", is_paid, is_rural, delivered_at, driver_comment, is_deleted) FROM stdin;
32	7	89073848	CHD 103 tow	3	1.00	12tsagta	3	f	0	7mCu93Ydoe	2025-06-11 03:06:59.503+00	2025-06-16 08:28:50.967+00	f	f	\N	\N	f
33	7	90095797	BZd 103 tow	3	1.00	12tsagt	3	f	0	iPmgxy2IHz	2025-06-11 03:07:30.065+00	2025-06-16 08:28:58.557+00	f	f	\N	\N	f
10	7	99904475	Сонгино хайрхан 103 төв	3	25000.00	18 tsagt hurgeh	3	f	0	aI5REyRrqQ	2025-06-06 13:14:52.708+00	2025-06-09 14:09:22.779+00	f	f	\N	\N	f
9	2	99094870	УИД урд 35 байр 1 тоот	3	600000.00	nylh huuhedtei ochhoosoo umnu zalgah	3	f	0	1cg4eTPbdr	2025-06-06 12:57:46.938+00	2025-06-09 14:09:53.211+00	f	f	\N	\N	f
34	7	89073848	chingelte 103	3	1.00	12tsagt	3	f	0	CmAHzMtgXB	2025-06-11 03:07:59.912+00	2025-06-16 08:29:03.976+00	f	f	\N	\N	f
35	4	99113223	zaisan altai haus 87-1	3	1.00	hurdan	3	f	0	tlBnM6zGpa	2025-06-11 03:10:35.739+00	2025-06-16 08:29:07.003+00	f	f	\N	\N	f
1143	4	99123710	ХУД арцат өргөө хотхон С блок 2-р орц 7 давхар 92	3	1.00	.	3	f	0	OHuNvBiI2g	2025-07-24 07:08:04.905+00	2025-07-25 06:50:57.973+00	f	f	2025-07-25 06:50:57.972+00	0	f
1210	10	567998655	fhjkljhfd	5	145667.00	cv	24	f	0	EaDE2GrR9f	2025-07-26 15:04:59.041+00	2025-07-28 10:13:14.291+00	f	f	\N	hodoo ywtsan bga nogoodor awna gsen	f
36	4	99172229	ih delguur altai tsentr 12-18tsag	3	1.00	12:00 18:00 hiorond	3	f	0	MlfmvEGtsU	2025-06-11 03:12:06.413+00	2025-06-16 08:29:10.019+00	f	f	\N	\N	f
37	4	99081495	СБД 2р хороо 5р хороолол 31р байр Их монголтой байр хойноосоо UB comedy-р орно 2тоот, код 0280# 99089929	3	1.00	.	3	f	0	0kGZYcpIBg	2025-06-15 07:40:12.434+00	2025-06-16 08:29:14.364+00	f	f	\N	\N	f
38	4	99095226	Бөмбөгөрийн 1 урсгалтай зам, Хараа зочид буудлын урд, Монхаус 33-1-2. 6 давхар тоосгон байр 99095226	3	1.00	.	3	f	0	yUb8u6yswL	2025-06-15 07:41:44.798+00	2025-06-16 08:29:17.756+00	f	f	\N	\N	f
39	4	88101447	Алтай хотхон 18р байр 1орц 8давхар 50тоот	3	1.00	.	3	f	0	Q47DLR0nk7	2025-06-15 07:43:16.164+00	2025-06-16 08:29:23.147+00	f	f	\N	\N	f
132	2	80160428	5 shariin prizer garaad akuma auto zaswariin urd talin 5dawhar saraal bair 	3	550000.00	hurdan	9	f	0	9adncPyKI7	2025-06-25 04:56:21.394+00	2025-06-25 07:53:43.17+00	f	f	\N	\N	f
105	2	80778012	Нарантуул өргөтгөл	3	1.00	94111987 6366ДОА энэ унаанд тавих 40Л	3	f	0	L9lKA4YXjp	2025-06-21 04:06:31.156+00	2025-06-22 02:23:24.295+00	f	f	\N	\N	f
11	4	88026987	дархан	3	1.00	oron nutgiin unaand tavih	3	f	0	wyzYrvRDD8	2025-06-06 13:26:16.984+00	2025-06-19 07:56:24.908+00	f	f	\N	\N	f
12	4	99107690	chonon burt tuv 1 davhar	3	1.00	unuudur hurgeh	3	f	0	VTnIvRaQnB	2025-06-06 13:28:00.401+00	2025-06-19 07:56:28.707+00	f	f	\N	\N	f
13	4	88002616	10 horoolol e mart zamiin urd tal g1	3	1.00	hurdan hurgeh	3	f	0	2W2j0upG9r	2025-06-06 13:39:25.378+00	2025-06-19 07:56:32.163+00	f	f	\N	\N	f
1165	10	88017767	han uul duureg 3-horoo telmuun hothon 43a bair	3	0.00	hurdan	14	f	0	NMfrtpJ8gn	2025-07-25 05:20:31.211+00	2025-07-25 06:11:49.151+00	t	f	2025-07-25 06:11:49.15+00	0	f
2288	18	91900602	hunnu 22 3eelj 219 bair 1orts 301toot	2	46000.00	tsagaan top	9	f	0	eP3F18i9TT	2025-08-25 08:14:40.344+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
31	7	90095797	HUD 103 tow	3	1.00	12tsagtaa	3	f	0	NifDhvkj6S	2025-06-11 03:06:16.473+00	2025-06-16 10:51:28.917+00	f	f	\N	\N	f
1044	10	99967320	BGD 18r horoo 86-2-23 99489580	3	79000.00	metal ilrvvlegch 	14	t	8	QGGAs9Sfre	2025-07-23 06:39:32.867+00	2025-07-25 06:15:20.103+00	f	f	2025-07-23 09:46:48.965+00	0	f
1015	61	99888495	"HanUul 2horoo Dund goliin  zam 33bair 13 toot hajuudaa  Baynhan delgvvriin zalgaa bair"	3	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	65	f	0	4nWZ4C2UfD	2025-07-23 03:28:47.403+00	2025-07-23 10:34:25.152+00	t	f	2025-07-23 10:34:25.152+00	0	f
1304	63	89951105	төмөр зам дээр	5	60000.00	төмөр зам дээр	3	f	0	9zmDwLl0Ky	2025-07-29 06:25:31.966+00	2025-07-30 14:54:02.915+00	f	f	\N	bolison	f
1070	10	99193927	10r horoolol 41-32 toot 99171752	5	99000.00	zowhinii tos 4shirheg	3	f	0	T1HC2gF3rx	2025-07-23 07:26:00.877+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
30	2	86859230	erdenet	3	22500.00	ochihoos umnu holbogdoh 	3	f	0	LnH1kzFjdA	2025-06-10 05:15:15.68+00	2025-06-19 07:57:00.846+00	f	f	\N	\N	f
127	6	88108242	hud crocus hajuud nomun united officeeeeee	3	0.00	hurdasn	9	f	0	b3ZbKXf5hH	2025-06-25 04:44:26.031+00	2025-06-25 06:26:31.527+00	t	f	\N	\N	f
988	58	99410271	3,4 хороолол, говь саун	3	100000.00	2025.07.23-ны хүргэлт. Шар өнгийн сүүдрэвч 6х4.5. Нисэх актив гарденаас авна.	9	t	10	3opfdMlOmi	2025-07-22 06:50:59.774+00	2025-07-25 06:16:46.596+00	f	f	2025-07-23 11:37:08.748+00	0	f
128	6	88121955	bzd 14 horoo nart hothon 93 1bair 81toot	3	0.00	hurdan	9	f	0	aZz1qA65ii	2025-06-25 04:46:45.719+00	2025-06-25 12:50:02.514+00	t	f	\N	\N	f
129	6	94044349	bzd 14 horoo tumen nast hothon 36b bair 225 toot	3	0.00	nylh huuhedtei ochhoosoo umnu zalgah	9	f	0	OK9hz30pYF	2025-06-25 04:49:55.613+00	2025-06-25 12:51:00.716+00	t	f	\N	\N	f
131	2	95948844	bzd 39-horoo 63-63toot 	3	450000.00	hurdan	9	f	0	BkluGmReqQ	2025-06-25 04:54:10.967+00	2025-06-25 13:39:51.494+00	f	f	\N	\N	f
1120	58	98114477	ХУД, 1-р хороо, 120 мянгат, 18-р байр, 5-р орц, 74 тоот	3	185000.00	Сүүдрэвч шар 6х4.5(100'000₮), шар 4.5х4.5(85'000₮) 2ш сүүдрэвч авна.	9	t	11	e8AYrlhpYo	2025-07-23 12:03:21.518+00	2025-07-25 06:17:06.424+00	f	f	2025-07-24 12:54:20.972+00	0	f
1207	10	589655	fjgxxg	5	1000.00	ghhvf	24	f	0	xbNLm7r8nD	2025-07-26 15:04:00.895+00	2025-07-28 10:33:23.224+00	f	f	\N	ooroo mar awna gsen	f
130	6	99993181	bayn gol duureg 1horoo orgoo 142a bair 1202 toot	3	0.00	hurdan	9	f	0	ln0uGr2CaQ	2025-06-25 04:51:15.113+00	2025-06-26 11:14:22.673+00	t	f	\N	\N	f
261	16	99921827	bzd shine amgalan horoolol 520 r bair 7 davhart 130 toot	3	15000.00	baihgyi	24	f	0	4zqYLagYjf	2025-07-02 04:11:42.615+00	2025-07-02 11:10:24.695+00	f	f	\N	\N	f
341	23	80300191	Мөнгөн завъяа дэлгүүрт /10-18 цагийн хооронд байна/	3	44900.00	m5	14	f	0	kysEyZNNNy	2025-07-03 13:26:35.791+00	2025-07-04 07:22:01.748+00	f	f	\N	\N	f
1498	10	88064537	ts	5	11.00	test	3	f	0	9CO9m2z4Jo	2025-08-07 04:58:07.696+00	2025-08-20 06:42:53.508+00	f	f	\N	3zalgasan	f
1186	63	86127092	sbd 11r horoo st apartment ireed zalga	5	60000.00	 	14	f	0	9nAmK3Qq94	2025-07-26 01:15:22.671+00	2025-07-29 04:59:48.045+00	f	f	\N	awhgu gesin	f
1263	59	88717266	Дорноговь аймаг	3	0.00	б	3	f	0	JktcnU2tsN	2025-07-28 07:45:58.27+00	2025-07-29 07:26:17.044+00	f	f	2025-07-29 07:26:17.044+00	0	f
1199	63	95247410	24р хороо хустайн 1-н 1 тоот 	3	60000.00	27нд хүргэнэ	14	t	16	tAnUIL531L	2025-07-26 06:09:54.51+00	2025-07-30 15:10:50.855+00	f	f	2025-07-27 11:35:36.749+00	0	f
1251	63	99273625	26 р хороо parkriro 116а байр 9-902 тоот уранганаас зүүн тииш 	3	60000.00	маргааш хүргэнэ	9	t	16	XsS30MpAyB	2025-07-28 03:24:05.684+00	2025-07-30 15:10:50.855+00	f	f	2025-07-28 12:02:27.089+00	0	f
1411	59	99024419	Дархан 	3	6000.00	ы	3	f	0	FNibGKTu5e	2025-08-03 13:06:28.642+00	2025-08-04 08:02:37.778+00	f	f	2025-08-04 08:02:37.778+00	0	f
1485	6	94825540	bzd horoolol 108 bair	3	0.00	onoodor	9	f	0	jifJMNmMcd	2025-08-06 05:36:25.152+00	2025-08-06 12:03:25.544+00	t	f	2025-08-06 12:03:25.544+00	0	f
1553	63	5424384	shisbzbsn	1	2585458.00	shsjs	\N	f	0	dMXAzDbfv3	2025-08-09 05:43:09.486+00	2025-08-09 05:43:41.684+00	f	f	\N	0	t
40	4	99193602	99018001 БЗД 6-р хороо 13-р хороолол баянзүрх захын хажуу дахь 75-р байр 3-р орц 190 тоот	3	1.00	.	3	f	0	2AgTgQiWDS	2025-06-15 10:09:51.633+00	2025-06-16 08:29:26.401+00	f	f	\N	\N	f
41	4	99193602	99018001 БЗД 6-р хороо 13-р хороолол баянзүрх захын хажуу дахь 75-р байр 3-р орц 190 тоот	3	1.00	.	3	f	0	j5lQup2SHO	2025-06-15 10:09:51.767+00	2025-06-16 08:29:29.694+00	f	f	\N	\N	f
1144	4	99063744	Хүннү моллын замын урд Нью гарден 1417-18 тоот 7 дав .2019# 85591919 дугаарруу залгах	3	1.00	.	3	f	0	bK7Lpb3ODX	2025-07-24 07:10:15.358+00	2025-07-25 06:50:31.965+00	f	f	2025-07-25 06:50:31.965+00	0	f
43	10	99296014	jukow hoid buudal deer ired yari	3	30000.00	hurdan baiwal sain bn	3	f	0	p9rqpnt9kH	2025-06-17 01:32:55.888+00	2025-06-17 15:01:42.833+00	f	f	\N	\N	f
44	11	88118735	Marshal taun 105 bair 6f 24toot	3	1.00	5литртэй 2сав шингэн бордоо	3	f	0	gbvLWfqLrF	2025-06-18 07:14:41.417+00	2025-06-20 07:28:14.294+00	f	f	\N	\N	f
51	4	99149869	Бөхийн өргөөнөөс урагшаа 84р сургуулийн урд 9давхар угсармалын12р байр 1орц 5давхар 18тоот	3	1.00	.	3	f	0	PJr8Lr1es0	2025-06-19 11:36:25.311+00	2025-06-20 07:28:21.202+00	f	f	\N	\N	f
52	2	80236000	нарантуул өргөтгөл  Өмнөговь каргоны машин 79-66УНБ	3	600000.00	төлбөр авсан унаанд нь шууд өгөөд л болоо	3	f	0	Ump06vfIqr	2025-06-19 11:39:18.542+00	2025-06-20 07:28:31.332+00	f	f	\N	\N	f
53	4	99993464	ӨМНӨГОВЬ ДАЛАНЗАДГАД	3	1.00	.	3	f	0	njBQPHqwtL	2025-06-19 11:40:24.082+00	2025-06-20 07:28:43.489+00	f	f	\N	\N	f
45	6	89154044	СХД 11-хороо Сөүл эмнэлгийн ногоон нуур авто буудал New residence hothon	3	1.00	hund zuiler darahgui baih	3	f	0	Vr3ngiZpvv	2025-06-19 08:01:00.584+00	2025-06-20 07:28:50.449+00	f	f	\N	\N	f
46	6	94222111	hogjim bujigin hoino 41-bair 18toot	3	1.00	hagarna	3	f	0	LUzUCEhKgg	2025-06-19 08:02:07.859+00	2025-06-20 07:28:55.058+00	f	f	\N	\N	f
47	6	89580628	dari ehin shine buudal monel ywah zamd 127 surguuli	3	1.00	hagarna	3	f	0	J6FrhYWc4l	2025-06-19 08:03:08.993+00	2025-06-20 07:28:58.945+00	f	f	\N	\N	f
55	2	89117464	Алтай хотхон 50в байр 8 давхарт 33 тоот	3	500000.00	очихдоо залгах 30Л	3	f	0	sQ7sKZD59b	2025-06-20 04:10:40.713+00	2025-06-20 12:37:26.851+00	f	f	\N	\N	f
54	2	99099576	Баянбүрдийн тойргын баруун хойно М ойл колонкоор баруун хойш эргээдУБЦТС байр 11 давхар 59 тоот	3	500000.00	очихоосоо өмнө залгах 30л төлбөр авах	3	f	0	JLc5FX4xry	2025-06-20 04:00:53.145+00	2025-06-20 16:59:57.154+00	f	f	\N	\N	f
57	2	99158797	7 буудлаас хойш Хайрхан хөгжилийн төв очоод залгах	3	600000.00	50Л өнөөдөр авнаа 7 буудал өнгөрөөд залгаж зам заалгах	3	f	0	ZFB8ShoiJF	2025-06-20 04:51:30.976+00	2025-06-20 17:00:21.113+00	f	f	\N	\N	f
56	2	95121564	Зурагт шинэ эцэс хувьсгалчидийн 609тоот	3	450000.00	шинэ эцэс очоод залгаад замаа заалгана 20л	3	f	0	1tMFjw7f6w	2025-06-20 04:23:49.28+00	2025-06-20 17:00:46.203+00	f	f	\N	\N	f
621	16	86088009	ofitser 14 surguuliin hajuud shunhlai kolonk deer avna	3	15000.00	baihgyi	14	f	0	KpNZlzLJFZ	2025-07-06 03:47:55.673+00	2025-07-06 10:30:52.926+00	f	f	\N	\N	f
629	16	99070187	monel jarga zaya delguur	5	15000.00	baihgyi	14	f	0	FqzoAUM5Ch	2025-07-06 04:03:08.909+00	2025-07-06 14:26:43.808+00	f	f	\N	\N	f
48	6	89009237	bzd ulaanhuaran etses 71a bair 92 toot	3	1.00	hagarna	3	f	0	dLqAWD9pCd	2025-06-19 08:04:08.691+00	2025-06-20 07:29:05.493+00	f	f	\N	\N	f
49	6	99994182	ih delguurin baruun hoin manduhai zochid buudal	3	1.00	hurdan	3	f	0	ht3eYWeQ10	2025-06-19 08:04:55.802+00	2025-06-20 07:29:11.656+00	f	f	\N	\N	f
50	6	99696484	bzd 4-horoo jukow muzie ard 11bair 10toot	3	1.00	hagarna	3	f	0	gBv3yNZiUg	2025-06-19 08:06:21.709+00	2025-06-20 07:29:16.001+00	f	f	\N	\N	f
631	16	99995661	horoollin erses duuhe delguurin urd 16 r bair	3	15000.00	baihgyi	3	f	0	U2IORRdHss	2025-07-06 04:05:28.888+00	2025-07-06 17:16:08.006+00	f	f	\N	\N	f
2345	26	88041344	Han uul solongos elchingiin urd global town b block 17 dawhar 1707 toot Haalga 1122#Dotor 9999tsooj111111 tsenher tsag	2	50000.00	tsenher tsag	66	f	0	QydyEcPMkQ	2025-08-25 16:52:41.529+00	2025-08-26 05:09:50.496+00	f	f	\N	0	f
2289	82	99982374	СХД 20-р хороо, Хуучин нефть баазын байр 2.30 байр, 19 тоот	2	69000.00	.	9	f	0	ZrSGyIpDjv	2025-08-25 08:27:58.846+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
1121	21	94056769	talbai central tower 2 davhart TITEM	3	0.00	emma emma-d	9	t	11	ziGOfB7tSI	2025-07-23 14:05:18.18+00	2025-07-25 06:17:06.424+00	t	f	2025-07-24 06:32:33.004+00	0	f
361	26	88119561	100 айл одкон төв дээр ирээд залгах гараад авчихна тор	3	28000.00	ок	14	f	0	qTQMQASgiw	2025-07-04 00:50:41.035+00	2025-07-06 04:18:51.264+00	f	f	\N	\N	f
573	26	95002084	95002084 баянхошуу эцэс дээр тор очихдоо ярихаар заагаад өгье тор	3	19900.00	баянхошуу	24	f	0	XfEacEQola	2025-07-06 01:37:31.098+00	2025-07-07 10:19:21.363+00	f	f	\N	\N	f
546	26	89179930	89179930  94176659 5 шар м ойл сутайн буян зүүн талд зам дагуу 22 байр 5 давхар хүрэн байр 12 тоот очоод залгахаар гараад авчихнаа тор	3	19900.00	5 шар	9	f	0	XnysaqkI8p	2025-07-05 23:57:14.955+00	2025-07-09 11:49:40.672+00	f	f	2025-07-09 11:49:40.672+00	\N	f
2392	71	91200223	SBD 5r horoo 61a 10 toot	2	0.00	.	73	f	0	R7V5n13vto	2025-08-26 05:58:33.001+00	2025-08-26 06:07:14.936+00	f	f	\N	0	f
633	16	80108070	horoolol hugjil hothon 25/2 2 r orts 9/903 toot	5	15000.00	baihgyi	9	f	0	HR6136CzF9	2025-07-06 04:35:24.773+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
1071	10	99483008	narnii horoolol 17r bair 202 toot 17s hoish 890503008	3	55000.00	zovhinii tos 2 shirheg	65	f	0	9ZsCDiJ8N8	2025-07-23 07:28:59.896+00	2025-07-23 15:16:45.325+00	f	f	2025-07-23 15:16:45.325+00	0	f
1016	61	95148041	"ХУД- 15-Р хороо Ганди гудамж  Монголын худалдаа аж  үйлдвэрийн танхим"	3	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	65	f	0	z2XpFWJiDK	2025-07-23 03:30:14.195+00	2025-07-23 11:10:16.052+00	t	f	2025-07-23 11:10:16.052+00	0	f
624	6	99141227	bz 41 horoo ih zasag surguulin zamin urd palapis hothon 59b 1403 toot	5	0.00	f	9	f	0	2YzSmpqSoU	2025-07-06 04:00:14.671+00	2025-07-22 04:44:21.816+00	t	f	\N	\N	f
1045	10	94621585	4r horoo COT 3-2-97 19s hoish 89231545 	3	79000.00	metal ilrvvlegch 	14	t	8	FlIgosuiBY	2025-07-23 06:41:08.912+00	2025-07-25 06:15:20.103+00	f	f	2025-07-23 12:38:14.762+00	0	f
1187	17	99267433	Төв аймгийн Жаргалант сум Хархорин захаас	3	195000.00	1ш камэр 3 с өмнө	9	f	0	Mu5an6SXYJ	2025-07-26 02:03:34.066+00	2025-07-27 06:00:22.063+00	f	f	2025-07-27 06:00:22.063+00	0	f
1160	63	89011946	зурагтын эцэс дээр ирээд залгачих	3	60000.00	7сарын 25нд хүргэж өгөх	3	t	16	Zf9Ht8UmlS	2025-07-25 04:41:55.708+00	2025-07-30 15:10:50.855+00	f	f	2025-07-25 06:56:52.026+00	0	f
1208	10	57875443	ghjbvc	5	0.00	hv	24	f	0	6mMhWK7OP4	2025-07-26 15:04:19.484+00	2025-07-29 04:59:48.045+00	t	f	\N	gerte uzched bolison	f
59	2	99372201	Дархан	3	1.00	Дарханы автобуснд өнөөдөр тавих	3	f	0	4OrQc8HMxs	2025-06-20 06:10:31.126+00	2025-06-20 09:18:43.206+00	f	f	\N	\N	f
63	2	80090089	Хан уул дүүрэг 5р хороо яармаг 18р гудамж 429б	3	550000.00	40Л Баруун тийшээ харсан хаалга Siskin Pc & billiard тоглоомын газар	3	f	0	aYdNrt5oPN	2025-06-20 07:29:30.447+00	2025-06-20 11:09:08.723+00	f	f	\N	\N	f
60	2	88035852	40Л Өвөрхангай Арвайхээр унаанд тавих	3	1.00	өнөөдөртөө багтаад унаанд тавих 40Л	3	f	0	dLTpoxKn7p	2025-06-20 06:11:40.994+00	2025-06-20 17:00:28.074+00	f	f	\N	\N	f
62	2	99911718	Сэлэнгэ аймаг унаанд тавих	3	1.00	40Л	3	f	0	digaB37c2K	2025-06-20 07:14:56.165+00	2025-06-20 17:01:08.933+00	f	f	\N	\N	f
58	2	99158797	7 буудлаас хойш Хайрхан хөгжилийн төв очоод залгах	5	600000.00	50Л өнөөдөр авнаа 7 буудал өнгөрөөд залгаж зам заалгах	3	f	0	SorZmH9AP8	2025-06-20 04:51:30.978+00	2025-06-20 17:01:14.466+00	f	f	\N	\N	f
547	26	95268392	хан-уул ГовьХК  дээр тор 95268392	3	19900.00	худ	3	f	0	o5EHEKxM7o	2025-07-05 23:57:46.281+00	2025-07-07 08:44:57.951+00	f	f	\N	\N	f
574	26	88286002	88286002 niseh iveel hothon 436bair 2opts 9daw 910toot top	3	19900.00	нисэх	3	f	0	y7GYmsfNn8	2025-07-06 01:38:03.918+00	2025-07-07 15:09:49.567+00	f	f	\N	\N	f
66	4	91993086	ХУД 15р хороо Global town D block 13д 1301тоот, 1122# 88112081 рүү залгаж өгөх	3	1.00	.	3	f	0	O96hHaziD4	2025-06-20 08:11:26.413+00	2025-06-24 12:31:06.666+00	f	f	\N	\N	f
67	4	99081144	СБД 8р хороо River castle 4давхар 406	3	1.00	.	3	f	0	CPfXzVtM7c	2025-06-20 08:13:09.763+00	2025-06-24 12:31:13.218+00	f	f	\N	\N	f
990	10	88064537	test	3	10000.00	test	3	f	0	aCnffUyoII	2025-07-22 08:12:48.424+00	2025-07-23 12:36:48.796+00	f	f	2025-07-23 12:36:48.795+00	yesss	f
68	4	94099694	ХУД 18р хороо Оргил рашаан сувилалын эсрэг талд LS Plaza	3	1.00	.	3	f	0	9pht4Ie6lY	2025-06-20 09:00:45.308+00	2025-06-24 12:31:19.057+00	f	f	\N	\N	f
1122	21	88888021	shangrila office 23 davhart	3	0.00	mugi-d	9	t	11	lITYGeROC8	2025-07-23 14:06:01.081+00	2025-07-25 06:17:06.424+00	t	f	2025-07-24 04:43:25.379+00	0	f
968	10	88064537	narnii horoolol	5	1000.00	etet	3	f	0	jqRS1zBFNw	2025-07-21 17:09:54.897+00	2025-07-22 10:12:33.367+00	f	f	\N		f
559	26	95459031	95459031 sonsgolongiin monos emiim uildwer der tor	3	19900.00	sonsgolon	24	f	0	ZGCpEKTfey	2025-07-06 00:49:41.072+00	2025-07-07 08:24:22.611+00	f	f	\N	\N	f
815	23	99951333	Төв аймаг унаанд тавих драгоноос	3	0.00	g9 tom 	8	t	2	VPMYc3lqP7	2025-07-08 12:40:25.547+00	2025-07-18 12:08:11.986+00	t	t	2025-07-09 09:59:02.25+00	\N	f
824	20	89105965	1-р хороолол, Хар хорин, 19-р байр, 10 орц, 3 давхар 334 тоот	3	6000.00	a	8	f	0	Wn7ZRRPLDI	2025-07-08 13:38:34.113+00	2025-07-09 11:12:12.653+00	f	f	2025-07-09 11:12:12.653+00	\N	f
2290	60	89907831	Налайхруу унаанд тавьж өгөх	2	85000.00	Унаанд тавихдаа дансаа явуулах	66	f	0	kQ5SbYeIec	2025-08-25 11:37:07.281+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
1166	63	89878698	bayanzurkh	5	60000.00	7сарын 26нд авна	14	f	0	8MrXqg8zaD	2025-07-25 06:04:18.393+00	2025-07-29 04:59:48.045+00	f	f	\N	tsutsalsan	f
555	26	89080030	89080030 1 r horoolol erin horoolol 53/12 - 66 toot 2 dawhart #5322 tor	3	19900.00	1 horoolol	9	f	0	FL6h7xQQ3R	2025-07-06 00:31:24.454+00	2025-07-06 11:59:17.196+00	f	f	\N	\N	f
1337	63	95451723	Увс аймгийн төв	3	60000.00	95451723. 88820019	3	t	16	LJrRL2wqz7	2025-07-30 04:22:38.575+00	2025-07-30 15:10:50.855+00	f	t	2025-07-30 08:55:02.88+00	0	f
2346	26	89118616	замын цагдагын зүүн талд 60 байр 78 тоот ягаан цаг	2	50000.00	yagaan tsag	66	f	0	VYuWew7a7H	2025-08-25 16:53:26.316+00	2025-08-26 05:09:50.496+00	f	f	\N	0	f
1017	61	80746468	Схд 8хороо 26гудам 1 10тоот	3	0.00	Ногоон сойтог-1ш Саарал сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-2ш	66	f	0	6M4def0unC	2025-07-23 03:34:03.581+00	2025-07-23 11:45:55.258+00	t	f	2025-07-23 11:45:55.258+00	0	f
1145	52	88085307	kino uildweriin sky town 90b bair 11-207 toot	3	6000.00	Nomintoi bair	14	f	0	w6DER26dip	2025-07-24 07:47:55.818+00	2025-07-25 09:00:35.458+00	f	f	2025-07-25 09:00:35.458+00	0	f
1072	10	99664258	4r horoolol 65a bair b orts 704 toot 99137937	3	45000.00	hamar helberjuulegch	14	t	8	xRZtOtJSkV	2025-07-23 07:30:23.121+00	2025-07-25 06:15:20.103+00	f	f	2025-07-23 12:44:09.306+00	0	f
1046	10	99076041	BGD modnii 2-50bair 5 orts 173 toot 	5	79000.00	metal ilrvvlegch 	3	f	0	xbwkPICW2L	2025-07-23 06:42:30.352+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
64	2	96060604	Залгаж байгаад 50Л өгнө	5	600000.00	Том тэрэг бариад явж байдаг тодорхой газар зогсдоггүй гэнээ	3	f	0	BfodhioqGC	2025-06-20 07:56:53.289+00	2025-06-24 12:30:40.146+00	f	f	\N	\N	f
1097	10	88845918	ulsiin ih delguur 11 ued baih 	5	45000.00	gold collagen 1sh	3	f	0	D1Jqm1WEdP	2025-07-23 09:12:26.003+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
65	4	99119033	Ривер гарден 403-р байр 10 давхар 1003 тоот	3	1.00	.	3	f	0	2vpT6iMcIY	2025-06-20 08:09:18.441+00	2025-06-24 12:31:00.006+00	f	f	\N	\N	f
1188	21	88181145	tumur zamiin deed suruuliin baruun tald 47b bair 62 toot	3	0.00	sunny saturn-d	9	t	15	LwythQT3OD	2025-07-26 02:10:49.207+00	2025-07-27 05:28:48.894+00	t	f	2025-07-26 08:31:20.335+00	0	f
1209	10	458876543	chjiyff	3	0.00	fhi	24	f	0	LVKG1DeKOl	2025-07-26 15:04:41.183+00	2025-07-26 15:14:55.348+00	t	f	2025-07-26 15:14:55.348+00	0	f
2393	71	94116581	darhan	2	0.00	.	9	f	0	pnhrX3TtGN	2025-08-26 05:59:00.246+00	2025-08-26 06:06:36.872+00	f	f	\N	0	f
928	46	96640302	СБД 16 хорооны байранд авна	5	229000.00	проектор	14	f	0	pXhNgmaBmt	2025-07-20 06:32:41.887+00	2025-07-22 05:24:01.515+00	f	f	\N	hurges ogtsin gejin	f
1230	21	99099884	1r emnelgiin hajuud HHBanknii tuv bair	3	0.00	odv gombo-d	9	f	0	qZSVBxcmgu	2025-07-27 13:13:58.263+00	2025-07-28 09:17:38.806+00	t	f	2025-07-28 09:17:38.806+00	0	f
947	10	86465050	hud 23horoo happy resdes hothon 885-804	5	76000.00	uhaalag tsag 1sh	9	f	0	1Ck5Nq1M8u	2025-07-21 03:40:27.082+00	2025-07-22 04:44:21.816+00	f	f	\N	0	f
1283	59	80917474	3 4 хорооллын Өргөө кино театрын урд 	3	30500.00	мөнгөө мартваа	9	f	0	hBZGGgy1gF	2025-07-28 16:08:58.41+00	2025-07-29 10:49:27.647+00	f	f	2025-07-29 10:49:27.647+00	0	f
1282	59	99649122	сэлэнгэ аймаг сайхан сум	3	6000.00	ж	3	f	0	G3lW1UmP7g	2025-07-28 15:31:53.172+00	2025-07-29 07:25:54.329+00	f	f	2025-07-29 07:25:54.329+00	0	f
1352	46	85310733	niseh 7 surgulin awtusni budl	5	229000.00	проектор	3	f	0	RzfV6GI4b7	2025-07-30 12:59:35.073+00	2025-08-01 01:22:10.523+00	f	f	\N	0	f
1351	6	80959522	altai hothon 16-bair 3orts 6-233 toot	3	0.00	oroi hunte	3	f	0	7a0qFZUwlB	2025-07-30 06:22:26.202+00	2025-07-30 11:47:22.001+00	t	f	2025-07-30 11:47:22.001+00	0	f
1313	63	94177651	bayn olgii 	5	60000.00	bayn olgii 	3	f	0	1Ipy839aiz	2025-07-29 07:28:04.921+00	2025-07-30 14:54:02.915+00	f	t	\N	bolison	f
1363	4	86118889	River garden 212 town house	3	1.00	.	3	f	0	Fsm6NCGOLk	2025-07-31 11:25:24.852+00	2025-08-01 11:58:21.379+00	f	f	2025-08-01 11:58:21.379+00	0	f
1364	17	99094970	амгаланд	3	195000.00	1ш камэр	9	f	0	NNwhYNc6lI	2025-07-31 11:47:01.182+00	2025-08-01 13:09:07.552+00	f	f	2025-08-01 13:09:07.552+00	0	f
61	2	99192153	БЗД 37р хороо жанжин 20-352В	3	450000.00	20Л 147р сургуулийн урд ТАЛСТ хүнсний дэлгүүр	3	f	0	b5VLjk9gPS	2025-06-20 06:49:19.479+00	2025-06-21 08:34:52.124+00	f	f	\N	\N	f
108	2	88303800	Нарантуул захаас Өмнөговь ханбогд явах унаанд тавих	3	1.00	50Л унаанд тавиад машины дугаар болон утасны дугаар мэдэгдэх тавьсан гэдгээ хэлэх	3	f	0	hb8SxCZuHj	2025-06-21 06:04:40.732+00	2025-06-22 02:23:47.844+00	f	f	\N	\N	f
113	2	88275955	Нарантуул захаах чойрын taxind тавина	3	1.00	30л Чойрт хүлээж авах хүний утас 99041391	9	f	0	McnIkGDr1q	2025-06-22 03:46:23.199+00	2025-06-22 15:59:45.826+00	f	f	\N	\N	f
116	6	94044349	bzd 14 horoo tumen nast hothon 36b bairnii 12d 215 toot	3	1.00	hurdan	9	f	0	89KPfIkExv	2025-06-22 05:17:47.165+00	2025-06-22 15:59:50.283+00	f	f	\N	\N	f
106	11	99768451	3-р хорооллын эцэст Говь сауны зүүн талд Амино дэлгүүрийн хажууд Хонгор ээж цайны газар	5	36000.00	1литртэй шингэн бордооноос 2савыг хүргэж өгөөрэй.	9	f	0	kBR6PMqsxD	2025-06-21 04:31:22.324+00	2025-06-22 16:20:08.073+00	f	f	\N	\N	f
114	2	88275955	Нарантуул захаах чойрын taxind тавина	5	1.00	30л Чойрт хүлээж авах хүний утас 99041391	9	f	0	cAWhuK7WGh	2025-06-22 03:46:23.203+00	2025-06-22 05:08:55.837+00	f	f	\N	\N	f
115	6	95008163	narnii horoolol 28bair 1906 toot	3	1.00	hurdan	3	f	0	ykRzCFnnaK	2025-06-22 05:15:15.568+00	2025-06-22 05:25:34.416+00	f	f	\N	\N	f
112	2	88035852	Өвөрхангай арвайхээр өнөөдөр унаанд тавих	3	1.00	40Л	9	f	0	QYaxIKrcqX	2025-06-22 02:23:18.872+00	2025-06-22 06:54:47.604+00	f	f	\N	\N	f
109	11	96492424	Завхан Улиастайн автобусанд тавих	3	1.00	5литртэй шингэн бордоо 2савыг өгч явуулах.Хүргэлтийн 6к-г авсан.	9	f	0	JuqEBZi3PA	2025-06-21 13:01:46.812+00	2025-06-22 07:21:17.797+00	f	f	\N	\N	f
107	2	89098535	МҮОНРТ ийн урд талд байрлах 2 өндөр шар байр	3	500000.00	30Л очоод энэ дугаарлуу залгах 99788384	9	f	0	4LDsvhbYZN	2025-06-21 05:38:07.201+00	2025-06-22 10:07:31.064+00	f	f	\N	\N	f
117	6	94688686	3,4 horoolol sogiin nogoon bairluu ergeed panda minii market	3	1.00	hurdan	9	f	0	iCbHxayK7S	2025-06-22 05:19:25.107+00	2025-06-22 10:07:46.091+00	f	f	\N	\N	f
118	6	91190044	bzd 19 horoo 16 horoolol green appartment hothon 39b bair 14 daw 150 toot	3	1.00	hurdan	9	f	0	oCagsgwLii	2025-06-22 05:20:49.018+00	2025-06-22 15:59:32.726+00	f	f	\N	\N	f
110	11	99351469	УБ хот БЗД, 15-р хороо, Уудам монгол сургуулийн хажууд 8б байр 3тоот	3	1.00	5литртэй шингэн бордооноос 2савыг өгөх. Хүргэлтийн 6к-г аваагүй.	9	f	0	RiUe8z0xL2	2025-06-21 13:05:28.662+00	2025-06-22 15:59:38.106+00	f	f	\N	\N	f
111	2	99165332	Нарантуул өргөтгөл хүнсний 22	3	500000.00	30Л	9	f	0	EzPIF2alDh	2025-06-22 02:17:36.295+00	2025-06-22 15:59:41.096+00	f	f	\N	\N	f
137	10	99230502	uh zasag surguulin hajuud suldet orgoo hothon 51b bair 57 toot	3	65000.00	ochihoso omno yarih	9	f	0	as9Bcoq4C6	2025-06-25 15:31:59.33+00	2025-06-26 04:47:58.188+00	f	f	\N	\N	f
2291	77	89800371 	 tsirkiin zuun urd tald garuda center	2	22000.00	1davhart avnaa 	73	f	0	aC86wX5WiG	2025-08-25 13:29:54.569+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
69	4	99091369	Зайсангийн эцсийн буудал хүрэх замд Анома хотхон 74-12тоот	3	1.00	.	3	f	0	a13P0HQKOr	2025-06-20 09:02:02.186+00	2025-06-24 12:31:40.252+00	f	f	\N	\N	f
70	4	95894149	Сонгино хайрхан дүүрэг 25хороо зүүнсалаа хуучин эцэс	3	1.00	.	3	f	0	nwF6mpye2e	2025-06-20 12:23:26.736+00	2025-06-24 12:31:48.653+00	f	f	\N	\N	f
121	4	80109696	Модны 2 Монгени сургуулийн баруун урд 69а байр 1р орц 4 давхар 17 тоот	3	1.00	.	9	f	0	vahdAagY7k	2025-06-24 12:20:08.703+00	2025-06-25 12:50:27.663+00	f	f	\N	\N	f
251	16	95854636	hovd aimagiin unaand tavina	5	15000.00	baihgyi	24	f	0	MiIjoxOGGd	2025-07-02 03:49:42.612+00	2025-07-06 17:23:25.789+00	f	f	\N	\N	f
119	4	91118290	Үндэсний цэцэрлэгт хүрээлэн Олонлог сургуулийн баруун талд Sunshine Village 333-1-403	3	1.00	.	9	f	0	RgnH4bVF2Y	2025-06-23 10:40:49.64+00	2025-06-25 13:40:22.063+00	f	f	\N	\N	f
120	4	99374355	hunnu2222 217-1601	3	1.00	.	9	f	0	aSGZUY1f9f	2025-06-23 10:41:32.843+00	2025-06-25 13:40:26.871+00	f	f	\N	\N	f
139	11	80880220	Бзд 2-р хороо Дарь эх, Итгэлт хүлэг авто сервисийн залгаа зүүн талын хашаа. 431тоот.	3	6000.00	5литрийн шингэн бордоо 1савыг хүргэж өгөх. хүргэлтийн 6к-г авсан.\nМаргааш үдээс өмнө бол сайн. Үдээс хойш зуслан явах байх.	3	f	0	QJtc3ukCwI	2025-06-27 02:17:36.665+00	2025-06-29 10:50:16.184+00	f	f	\N	\N	f
125	4	88827003	Koyo town Алтай хотхоны хажууд 54/8 1305 тоот	3	1.00	.	9	f	0	dvVH2M77ir	2025-06-24 16:05:48.357+00	2025-06-25 05:57:50.46+00	f	f	\N	\N	f
124	4	80092919	Баянхонгор	3	1.00	.	9	f	0	vSZFfJIYQO	2025-06-24 14:50:57.314+00	2025-06-25 09:38:49.528+00	f	f	\N	\N	f
122	4	95110329	3,4 хороолол говь сауны баруун талаар уруудаад 150 орчим метр яваадзамын зүүн талд хар хашаатай 3 давхар саарал амины орон сууц байгаа хашаандаа модтой голын хаалга дөхөөд залгах	3	1.00	.	9	f	0	McSix2rhDy	2025-06-24 12:21:04.597+00	2025-06-25 09:39:16.848+00	f	f	\N	\N	f
138	2	80559988	hud 18horoo hunnu 2222 horoolol 114 bair 	3	600000.00	50l horogch yarij bgad ochih 	9	f	0	eaG4ssioEE	2025-06-25 15:36:10.35+00	2025-06-26 11:12:15.114+00	f	f	\N	\N	f
123	10	88031991	yarmagt	3	15000.00	huwtsasni hairtsag	3	f	0	KtyPQnN2YW	2025-06-24 12:25:15.461+00	2025-06-29 10:49:45.255+00	f	f	\N	\N	f
1146	52	88006608	BZD tsaiz 16 iin 45 r surguuliim baruun tald Garden 16 hothon 49b bair 4-20 toot	3	6000.00	b	14	f	0	oyUJIZ1wPi	2025-07-24 07:49:52.341+00	2025-07-25 10:36:10.325+00	f	f	2025-07-25 10:36:10.325+00	0	f
855	2	80145503	Тэнгэр Плазагаас энэ унаанд тавих 88801966 хар alphard 3876УНН	3	1.00	40L орой 8 цагаас өмнө өгөх!!!	14	f	0	rWGylzFfTZ	2025-07-09 05:24:28.162+00	2025-07-09 10:05:37.185+00	f	f	2025-07-09 10:05:37.185+00	\N	f
2394	71	89199697	umnu gobi tsogtsetsi	2	0.00	.	9	f	0	BBaoQm08mF	2025-08-26 06:00:42.071+00	2025-08-26 06:06:36.872+00	f	f	\N	0	f
1853	6	96309096	tsaiz 16 deer	3	0.00	onooodor	9	f	0	3g78GDRnA9	2025-08-18 02:52:08.616+00	2025-08-18 13:20:42.812+00	t	f	2025-08-18 13:20:42.811+00	0	f
1123	21	89115478	huuchin buynt uhaa ongotsnii buudal baruun hoino shilen officed	3	0.00	bilgee-d	\N	f	0	z8aIdFuXwv	2025-07-23 14:07:30.624+00	2025-07-25 05:14:24.376+00	t	f	\N	0	f
1047	10	88214213	BGD 32 khoroo 12 bair 20 tsagt 	3	79000.00	metal ilrvvlegch 	14	t	8	JFqgUdcvFH	2025-07-23 06:43:40.721+00	2025-07-25 06:15:20.103+00	f	f	2025-07-23 12:17:26.829+00	0	f
1189	60	99003999	Бзд 25р хороо 13-р хороолол нарны зам 147 байр 10 тоот	3	99000.00	tulbur hiigdeegui bga	14	t	14	6chWm2oa16	2025-07-26 03:10:52.283+00	2025-07-27 04:04:40.905+00	f	f	2025-07-26 13:14:24.411+00	0	f
250	16	88303077	shd 20r horoo nept selenge zah jimsnii 11 r lanuu	3	15000.00	baihgyi	14	f	0	fOnWEtsTAp	2025-07-02 03:49:14.435+00	2025-07-02 12:51:52.973+00	f	f	\N	\N	f
140	2	88 036707	Максмоллоор дээшээ хороолол өгсөөд Мандах дээд сургуулийн зүүн талд Боса Импекс ХХК төв оффис	3	1.00	1 дэх өдөр үйлдвэрээс 28 гутал хүргэж өгөх	3	f	0	AEjNpcLDJm	2025-06-28 07:05:34.91+00	2025-06-29 10:50:19.155+00	f	f	\N	\N	f
141	4	94702090	10р хороолол Петровисын замын эсрэг талын Авзагын ногоон 10р байр 5 давхар 21 тоот, код 2369# 	3	1.00	.	3	f	0	54wH0hT0qa	2025-06-28 08:11:52.832+00	2025-06-29 10:50:22.428+00	f	f	\N	\N	f
142	4	99595935	ЗАМЫН ҮҮД	3	1.00	.	3	f	0	HZPHDYQrSB	2025-06-28 08:12:32.44+00	2025-06-29 10:50:26.629+00	f	f	\N	\N	f
143	4	99012828	Модны 2 Elegance town 44e-48	3	1.00	.	3	f	0	6ZCQmXD9Fe	2025-06-28 09:26:39.406+00	2025-06-29 10:50:29.7+00	f	f	\N	\N	f
144	4	99666578	сүхбаатар дүүрэг 2 хороо дөлгөөн нуур 295 байр 13 давхар 81 тоот хоймор оффис хойно	3	1.00	.	3	f	0	yvCsy7ce9k	2025-06-28 11:05:14.807+00	2025-06-29 10:50:32.457+00	f	f	\N	\N	f
149	16	99099846	king tower 134 р байр	3	30000.00	15000*2 нийт 30.000 төгрөг авна. 2 ширхэгийг авна	3	f	0	3VMBMkQLLq	2025-07-01 03:15:58.689+00	2025-07-02 12:17:22.596+00	f	f	\N	\N	f
155	16	88082759	3.4 хороолол авто плаза хажууд 7 р байр	3	15000.00	байхгүй	14	f	0	x5OrnZDRBB	2025-07-01 03:29:52.135+00	2025-07-01 07:24:54.374+00	f	f	\N	\N	f
159	17	95935036	1ш камэр дөлгөөн нуур	3	195000.00	hurdan hurgeh	14	f	0	B9H0I7A3mM	2025-07-01 04:12:43.809+00	2025-07-01 11:18:41.852+00	f	f	\N	\N	f
169	21	88083664	HUD narnii horoolol 9 bair 203 toot	3	0.00	batchimeg bayarmaa	3	f	0	SHNe3FqrQL	2025-07-01 10:20:59.385+00	2025-07-02 09:39:32.727+00	t	f	\N	\N	f
167	21	88113473	naadam center KH appartment 6A bair 8davhart 125 toot	3	0.00	уянгаа Аз	3	f	0	yOTki3WrOA	2025-07-01 10:18:02.909+00	2025-07-02 10:41:54.202+00	t	f	\N	\N	f
154	16	88027612	гандан автобусны буудалын ард монгол үндэсний их сургууль	3	15000.00	байхгүй	14	f	0	9x6gXc8axU	2025-07-01 03:20:51.658+00	2025-07-01 11:19:14.496+00	f	f	\N	\N	f
147	16	82274040	цайз 16 баян зүрх захын ард очоод залгах	3	15000.00	байхгүй	14	f	0	vH002ecAL5	2025-07-01 03:13:52.55+00	2025-07-01 12:42:45.597+00	f	f	\N	\N	f
160	17	88440722	1ш камэр чулуун овоо сод монгол Колонк дээр	3	195000.00	hurdan	14	f	0	9iz5dnCkXL	2025-07-01 04:13:20.573+00	2025-07-01 12:24:31.418+00	f	f	\N	\N	f
161	17	95953950	Япон дугуй засварын хажуугийн бумба дэлгүүрт	3	175000.00	onoodor zaawal	14	f	0	sMceQpe3IC	2025-07-01 04:15:12.951+00	2025-07-01 12:24:21.254+00	f	f	\N	\N	f
146	16	99837779	архангайн унаанд тавих	3	15000.00	унаанд тавиад тооцоогоо авах	14	f	0	GkjvE9XFFX	2025-07-01 03:12:39.728+00	2025-07-01 04:42:51.916+00	f	f	\N	\N	f
157	16	99257106	увс ын унаанд тавина драгоноос	3	15000.00	унаанд тавиад хүнрүү нь залгаж тооцоогоо авна	14	f	0	encNNmW7wW	2025-07-01 03:37:29.965+00	2025-07-01 05:09:43.857+00	f	f	\N	\N	f
151	16	89195019	21, содон хороолол	5	15000.00	срдон хороолоолд авна	14	f	0	NNgxR8GsXR	2025-07-01 03:17:36.188+00	2025-07-01 05:13:27.198+00	f	f	\N	\N	f
153	16	88014491	москва хороолол 132-4 105 тоот	3	15000.00	б	14	f	0	dOqd21l4tT	2025-07-01 03:19:54.93+00	2025-07-01 06:22:17.258+00	f	f	\N	\N	f
148	16	88015550	эх нялхасын эмнэлэг	5	15000.00	хүргэлтээ өгөөд тооцоого авах	14	f	0	6AtPlzHnkN	2025-07-01 03:14:37.807+00	2025-07-01 08:43:50.598+00	f	f	\N	\N	f
156	16	89992119	натур шинэ монгол сургуулын хажууд 56 р байр 2/5 тоот	3	15000.00	байхгүй	14	f	0	MP0oHiH4Vh	2025-07-01 03:32:01.494+00	2025-07-01 09:32:17.508+00	f	f	\N	\N	f
158	16	89191914	бзд, 22 р хороо дэлгэрэх аппартмэнт 99А	3	15000.00	байхгүй	14	f	0	XUmmBKr2nS	2025-07-01 03:53:07.976+00	2025-07-01 11:45:46.53+00	f	f	\N	\N	f
162	17	99222225	HUD 20horoo	3	195000.00	hurdan	3	f	0	5nYYX50SMW	2025-07-01 04:16:59.966+00	2025-07-01 12:21:28.727+00	f	f	\N	\N	f
2348	26	99991447	han uul King tower 129-310 toot har tsag	2	50000.00	har	78	f	0	EaBNtzbQKG	2025-08-25 16:55:11.022+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
170	21	88881489	7 buudaliin gerken dohio unguruud ECO oil shatahuunii gazriin zogsool deer avna	3	0.00	ireheesee 20minutin umnu zalgah, ger n lagert bhoor zamdaa tosoj awna, zaaval zalgah	9	f	0	APgueAqNXy	2025-07-01 10:22:39.501+00	2025-07-03 12:50:59.343+00	t	f	\N	\N	f
2292	77	88297023 	sport tsogtsolbor iin buudal new family	2	18000.00	307r bair 4davhar 29toot 	73	f	0	YlapgUJKAN	2025-08-25 13:30:33.105+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
166	16	90090994	хан уул дүүрэг арцатын ам марал аялал хотхон 1444 байр 14 давхар 89 тоот	3	15000.00	байхгүй	3	f	0	JnrVLRLqf0	2025-07-01 10:05:39.494+00	2025-07-02 05:11:05.261+00	f	f	\N	\N	f
168	21	86165493	zaisan soyombotoi uulnii hajuu CU tei  51r bair, 2 orts, 10davhart 101 toot	3	0.00	T. oyunsanaa-d	3	f	0	JXbWRzCMO7	2025-07-01 10:19:48.17+00	2025-07-02 13:15:13.896+00	t	f	\N	\N	f
2395	71	80117685	SHD 29 hrooo moskva apartment 132-4	2	0.00	.	9	f	0	8Jl2lIixIa	2025-08-26 06:02:58.728+00	2025-08-26 06:06:36.872+00	f	f	\N	0	f
175	23	88745185	Схд ийн 22р хороо 34 54т	3	39900.00	PK	14	f	0	QIzp2eMj96	2025-07-01 12:19:57.404+00	2025-07-02 15:24:07.174+00	f	f	\N	\N	f
174	23	99793251	Улаанбаатар их дэлгүүр  4 давхарт 5_10_15 хүүхдийн хувцасны тасаг дээр	3	39900.00	PK	24	t	1	L4HzS9K6aQ	2025-07-01 12:19:31.909+00	2025-07-05 11:14:26.633+00	f	f	\N	\N	f
1099	10	86670210	chd suis 92000210	5	61000.00	turaah naalt 3sh	3	f	0	f1tyD0dR63	2025-07-23 09:15:02.398+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1074	10	88111634	narniii horoolol 35/b bair 1202	3	44000.00	untlagiin tos	65	f	0	2SxTwVG3jF	2025-07-23 07:33:08.957+00	2025-07-23 09:14:13.183+00	f	f	2025-07-23 09:14:13.183+00	0	f
1019	61	99399155	дархан 	3	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	66	f	0	VSJDm32v3n	2025-07-23 03:36:18.548+00	2025-07-23 09:49:07.931+00	t	t	2025-07-23 09:49:07.931+00	0	f
730	23	99017254	Өвөрхангай	5	0.00	pic mat	9	f	0	FidnOkzfU6	2025-07-07 13:15:52.187+00	2025-07-22 04:44:21.816+00	t	t	2025-07-09 07:29:47.049+00	\N	f
1124	21	88086683 88096683	tedy tuv-d	1	0.00	lucky gegee-d	\N	f	0	6IvInUus1U	2025-07-23 14:08:54.262+00	2025-07-24 03:15:20.917+00	t	f	\N	0	t
1647	19	86185200	Dari eh 27horoo huuchin etses	5	86000.00	төлбөр танайх авна	14	f	0	b5vbbfLGkr	2025-08-13 10:08:48.423+00	2025-08-20 07:16:45.851+00	f	f	\N	utaa avaguu	f
1147	52	98110984	Zaidan enhjin hothon 104 r bair 8-29 toot	3	6000.00	bl	9	t	15	idcOXo7omT	2025-07-24 07:50:24.696+00	2025-07-27 05:28:48.894+00	f	f	2025-07-26 11:46:02.214+00	0	f
548	26	91006090	91006090 яармаг пермерүүд зах туул ривер 109 байр 8 дав 39 тоот код 1090# Тор	3	19900.00	яармаг	3	f	0	Ngkrxo8yyz	2025-07-05 23:58:19.951+00	2025-07-07 12:42:55.834+00	f	f	\N	\N	f
510	16	99170875	17 iin buudal deer ireed zalgah	5	15000.00	baihgyi	24	f	0	RdANaXz8Y9	2025-07-05 05:08:40.234+00	2025-07-07 10:29:14.461+00	f	f	\N	\N	f
178	23	99105688	HUd 1r horoo 52r surguulin chanh hoino 32r bair 1r orts 4dawhar 10toot	3	39900.00	L3	3	f	0	ZGiwRLTaWc	2025-07-01 12:21:24.837+00	2025-07-02 10:53:42.289+00	f	f	\N	\N	f
1020	61	89900509	Төв зуунмод 	3	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	3	f	0	VbUiCEUA7g	2025-07-23 03:37:01.757+00	2025-07-23 11:38:46.671+00	t	t	2025-07-23 11:38:46.671+00	0	f
152	16	99922529	бзд, 19 р хороо new town хотхон 43/5 байр 302 тоот	3	15000.00	байхгүй	3	f	0	q7K1gpDqZB	2025-07-01 03:19:01.797+00	2025-07-02 14:20:32.039+00	f	f	\N	\N	f
186	16	99190474	яармаг гардэн сити хотхон 1205-2/5/503 тоот	3	15000.00	маргааш өглөө хөдөө явна.Өнөөдөр оройтоод ч хамаагүй авна гэсэн. хэрэв хүргэлт амжихгүй бол хасаарай	3	f	0	tavLdCTTGD	2025-07-01 12:37:37.177+00	2025-07-02 05:10:59.731+00	f	f	\N	\N	f
1125	21	88086683 88096683	tedy tuv-d	1	0.00	lucky gegee-d	\N	f	0	xnrbGth6q8	2025-07-23 14:08:54.263+00	2025-07-24 03:15:20.917+00	t	f	\N	0	t
145	16	99309156	зүүн хараа унаанд тавина. драгоноос	3	15000.00	унаанд нь тавиад дугаарлуу нь залгаад тооцоогоо авах	14	f	0	5AIU5QeZgi	2025-07-01 03:11:40.88+00	2025-07-02 06:36:43.481+00	f	f	\N	\N	f
993	46	90076647	nalaihiin unaand taviulna	5	229000.00	проектор\nунаанд тавихаасаа өмнө төлбөрөө аваарай	14	f	0	3fhNssVs2e	2025-07-22 12:11:38.488+00	2025-07-24 14:16:12.68+00	f	f	\N	awh awhgu medhgu bn	f
187	22	99986827 код:4	Хан-Уул Корокус төв	3	0.00	Өглөө 10-12:30 цагийн хооронд Крокус дээр авна. Хүргэлт 6к	3	f	0	WGgfW9RXzE	2025-07-01 12:47:15.713+00	2025-07-02 05:48:24.809+00	t	f	\N	\N	f
180	23	99904677	yarmag mandala garden 1481-32	3	129900.00	p2	3	f	0	Qepl1tNgWy	2025-07-01 12:22:12.177+00	2025-07-02 07:06:42.252+00	f	f	\N	\N	f
196	16	99940060	10 р хороолол баялаг хотхон	3	15000.00	баялаг хотохнд очоод залгах	3	f	0	ZuIwGxKFH9	2025-07-01 16:24:20+00	2025-07-02 05:08:29.301+00	f	f	\N	\N	f
177	23	88610298 86564648	Улаанбаатар сувилал 72а байр 12 давхар 4 давхарт 20 тоот /88610298 хүлээж авах хүний дугаар/	3	39900.00	PK GR	3	f	0	m6isNa9jw7	2025-07-01 12:20:53.997+00	2025-07-02 11:19:42.033+00	f	f	\N	\N	f
163	16	88195433	бзд 26 р хороо Time tower хотхон, 216-139 тоот	3	15000.00	байхгүй	3	f	0	VIjaoCq1wc	2025-07-01 06:00:48.415+00	2025-07-02 11:45:13.021+00	f	f	\N	\N	f
199	16	89779780	Han uuliin emartaas zuun tiishee yvaad vega city hothonii zamiin yg urd tald orchid park tolsiiln hashaa	5	30000.00	2 shirheg zahialsan. 15*2=30k tootsoo avna	3	f	0	ecml2X9Xsx	2025-07-02 00:22:56.656+00	2025-07-02 11:49:47.83+00	f	f	\N	\N	f
1148	52	86109300	Yaarmagiin Porshe giin deeshee ugsuud Happy residence 878r bair 2 orts 3-307 toot	3	6000.00	Uure	3	f	0	hbQpoxpNeL	2025-07-24 07:51:22.56+00	2025-07-25 14:02:06.856+00	f	f	2025-07-25 14:02:06.856+00	0	f
184	23	91698195	Схд хархоринын ар зам дагуух 24р байр 9 орц 1 давхарт 292 тоот Код нь 292B 	3	54900.00	i8 jijig	9	f	0	ahmkwrfcgy	2025-07-01 12:23:58.97+00	2025-07-03 10:36:47.259+00	f	f	\N	\N	f
181	23	94929292	yaarmag hunnu malliin hajuugiin viva city 623-r bairnii gadaa ireed zalgahad bolnoo	3	129900.00	p1	3	f	0	3zCsikEG07	2025-07-01 12:22:41.447+00	2025-07-02 05:09:36.079+00	f	f	\N	\N	f
1298	63	99551909	erdnet 	3	60000.00	  	3	t	16	s0s9vha252	2025-07-29 04:37:54.757+00	2025-07-30 15:10:50.855+00	f	t	2025-07-29 07:25:59.244+00	0	f
1233	21	99941777	BZD 3 horoo 12 horoolol SANSAR garden 39b bair 2302 toot	3	0.00	sunshine-d	9	f	0	whpeA4FmDo	2025-07-27 13:17:03.843+00	2025-07-28 08:46:50.293+00	t	f	2025-07-28 08:46:50.292+00	0	f
1049	10	88006174	BGD 10r khoroolol 25 khoroo goldan park hothon 101 bair 5 davhar 	5	65000.00	sahariin tsai 	3	f	0	VE1IC3kQil	2025-07-23 06:46:37.357+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1075	10	80119801	horoolol altan tugrug 44r bair 2 orts 2daw 100 toot	5	65000.00	sahariin tsai	3	f	0	7JtNxQp7Kq	2025-07-23 07:34:33.217+00	2025-07-24 04:20:40.425+00	f	f	\N	margash awna	f
1100	10	88015053	chd hailast 16horoo 57-686 toot	5	76000.00	uhaalag tsag 1sh	3	f	0	WhMvEswvKv	2025-07-23 09:16:21.084+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1211	54	95999666	Баянгол дүүрэг 12-р хороо Бичил 13-р байр 2-р орц	3	0.00	тооцоо авахгүй шүү. Тооцоогоо урьдчилаад хийцэн хүн байгаа юм аа	9	f	0	mYFjHQvCw6	2025-07-26 16:04:44.057+00	2025-07-27 09:13:37.847+00	f	f	2025-07-27 09:13:37.846+00	0	f
857	2	80145503	Тэнгэр плаза 3876УНН хар Alphard 88801966	3	1.00	40л тэй унаанд тавина төлбөр авсан	14	f	0	7OJ6UHwPYW	2025-07-09 06:37:50.549+00	2025-07-09 10:20:18.014+00	f	f	2025-07-09 10:20:18.014+00	\N	f
1225	4	99109708	Сбд, 6-р хороо , метромоллын замын урд жем кастел шилэн барилга , 2-р орц 10 давхар 106 тоот	3	1.00	.	9	f	0	Dl0VkzageV	2025-07-27 08:29:23.105+00	2025-07-28 11:00:00.251+00	f	f	2025-07-28 11:00:00.251+00	0	f
2293	77	80167318 	sportin tov ordon	2	20000.00	43r bair 2orts 11davhar 78toot  	73	f	0	8Cu1kq8bul	2025-08-25 13:31:05.047+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
2349	59	89907676	ardiin horshoo ochir hothon	2	0.00	0	73	f	0	kduc876joA	2025-08-25 17:07:31.125+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
650	4	99183271	Мөнгөн Завьяа	5	1.00	.	9	f	0	OXv6Qlcwsn	2025-07-06 12:14:31.956+00	2025-07-22 04:44:21.816+00	f	f	2025-07-16 03:53:29.362+00	\N	f
2396	71	99661688	saporro urd avtobusni buudal deeres zalgah	2	0.00	.	9	f	0	5gozj5IiaD	2025-08-26 06:06:12.367+00	2025-08-26 06:07:36.886+00	f	f	\N	0	f
1191	63	99751801	драгон дээрээс шижир алтны унаанд тавих	5	60000.00	7сарын 26нд унаанд тавих	9	f	0	zhjHlyO7S3	2025-07-26 03:18:41.343+00	2025-07-29 04:57:45.966+00	f	t	\N	0	f
1305	63	99158736	багануур автобусанд тавих	5	60000.00	багануур автобусанд тавих	67	f	0	R3Q5nDNJCk	2025-07-29 06:33:12.778+00	2025-07-30 06:25:47.221+00	f	t	\N	0	f
1221	19	96055198	Чингэлтэй дүүрэг 2р хороо Барилгачидын талбай  дулаан граж 96055198	5	860000.00	төлбөр  танайх  авна	9	f	0	3xdGAexN9h	2025-07-27 07:41:43.735+00	2025-07-29 06:35:40.557+00	f	f	\N		f
1169	63	80709795	увс улаангом	5	60000.00	7арын 26нд унаанд тавих 99450391 энэ хүн тосч авна	3	f	0	siM8o2ZFul	2025-07-25 06:12:29.817+00	2025-07-30 14:54:47.374+00	f	t	\N	bolison	f
1314	63	99873458	khan uul yarmagiin 2 buudal green art hothon 775-12 	3	60000.00	  	3	t	16	Ap70GrYExG	2025-07-29 07:57:29.023+00	2025-07-30 15:10:50.855+00	f	f	2025-07-30 06:03:31.567+00	0	f
1859	6	99795900	sain shand	3	0.00	onoodor	3	f	0	1y1Mvgg2VV	2025-08-18 06:09:50.059+00	2025-08-18 06:57:35.985+00	t	f	2025-08-18 06:57:35.985+00	0	f
254	16	86222277	1 r horoolol 27 r bair	3	15000.00	baihgyi	14	f	0	RKdGhjsJij	2025-07-02 03:59:51.452+00	2025-07-02 08:49:50.733+00	f	f	\N	\N	f
1126	21	88086683 88096683	tedy tuv-d	1	0.00	lucky gegee-d	\N	f	0	GDbQcIG9b3	2025-07-23 14:08:54.323+00	2025-07-24 03:15:20.917+00	t	f	\N	0	t
256	16	96808896	zahvhanculiastain unaand tavina	3	15000.00	baihgyi	14	f	0	V3fMOpHIoQ	2025-07-02 04:04:08.634+00	2025-07-02 12:21:25.937+00	f	f	\N	\N	f
252	16	95182219	sbd 12 r horoo hangain 15.616 toot	5	15000.00	baihgyi	9	f	0	WR4qLxIlsE	2025-07-02 03:56:21.21+00	2025-07-03 13:23:39.341+00	f	f	\N	\N	f
258	16	99282447,86119966	niseh 4 berh hothon 423 bair 6 davhart 30 toot	3	15000.00	baihgyi	3	f	0	kMoQaoxWHJ	2025-07-02 04:06:12.926+00	2025-07-02 07:54:51.748+00	f	f	\N	\N	f
262	16	94995151	aktive garden 508r bair	3	15000.00	oroi 7 uus umnu avna	3	f	0	gvyHIJtLS3	2025-07-02 04:18:59.077+00	2025-07-02 06:57:16.961+00	f	f	\N	\N	f
1050	10	99292067	BGD 5 khoroo ulsiin 3r emnelgiin hoshootei tov haalganii derged JI AR tov 4 davhar 402 toot lavlah utas 88119898	1	129000.00	ondor bolgodog naalt 	9	f	0	smbFCZIqUN	2025-07-23 06:49:19.546+00	2025-07-23 08:17:23.902+00	f	f	\N	0	t
1073	10	99750211	bgd 18 r horoo 32b 1b 8-21 toot 88084867	3	58000.00	untlagiin tos 2shirheg	14	t	8	Cx55nVzFD0	2025-07-23 07:31:53.949+00	2025-07-25 06:15:20.103+00	f	f	2025-07-23 10:27:09.539+00	0	f
257	16	94943035	moskva horoolol mt kolonkiin chandmani erdene hunsnii delguurt uguh	3	15000.00	baihgyi	14	f	0	4msQpTiQgk	2025-07-02 04:05:13.34+00	2025-07-02 10:11:44.216+00	f	f	\N	\N	f
2350	59	9000108	BGD 18r horoo 47r bair	2	0.00	0	73	f	0	SkM5HYhpsF	2025-08-25 17:10:30.136+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
994	46	99051195	Төв номын сангийн урд Моннис цамхаг оффис дотор ирээд залгахад буугаад шалгаад авчина	3	229000.00	проектор 12-13н цагын үед	9	t	10	pZKoMutWvr	2025-07-22 12:27:18.9+00	2025-07-25 06:16:46.596+00	f	f	2025-07-23 08:37:41.771+00	0	f
243	2	80602149	Хархорин Зах Хархорин хороолол 55р байр 2 орц 11 давхар 55 тоот	5	450000.00	20Л орой 22:00 цагт авна очоод залгах	14	f	0	YXDEbl9UR6	2025-07-02 03:00:18.107+00	2025-07-02 14:36:08.009+00	f	f	\N	\N	f
1149	20	80606073	Алтай центр	3	1.00	19 цаг хүртэл байна	9	t	15	7s3NMGjiRN	2025-07-24 08:01:28.354+00	2025-07-27 05:28:48.894+00	f	f	2025-07-26 08:25:46.507+00	0	f
2294	77	91216685 	 huuchin dragon 	2	20000.00	5davhart 1tsegiin uilchilgee 	9	f	0	noRc8NqbbS	2025-08-25 13:31:41.983+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
1192	63	88003308	Баянгол рестораны баруун урд 25байр 6орц 1давхарт бор хаалга	3	60000.00	 	9	t	15	Z9xif42ulT	2025-07-26 03:19:42.695+00	2025-07-27 05:28:48.894+00	f	t	2025-07-26 08:28:39.697+00	0	f
1021	61	97116688	"13horoolol 14bair 8r orts 267 toot  ireh uedee zalgaarai."	3	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	24	f	0	0UIyd1zNq9	2025-07-23 03:37:57.976+00	2025-07-23 12:03:44.478+00	t	f	2025-07-23 12:03:44.478+00	0	f
1076	10	99292126	bgd bgd zah 4r pawilon urguugiin urd	3	149000.00	emegteichuudiin capsul 6 shirheg	9	t	10	FqgV4SOKwT	2025-07-23 07:35:49.492+00	2025-07-25 06:16:46.596+00	f	f	2025-07-23 11:50:17.285+00	0	f
1127	21	88086683 88096683	tedy tuv-d	3	0.00	lucky gegee-d	9	t	11	JZgm1oNqJ3	2025-07-23 14:08:58.285+00	2025-07-25 06:17:06.424+00	t	f	2025-07-24 05:00:48.976+00	0	f
2391	71	80017685	moskva apartment 132/4	2	0.00	.	9	f	0	VhQ6SiR3j6	2025-08-26 05:57:49.986+00	2025-08-26 06:06:36.872+00	f	f	\N	0	f
1267	58	91094429	Sodon horoolol 113 bair 1 orts 13 dawhar 89 toot	3	55000.00	Сүүдрэвч ногоон 3х3	24	f	0	bijedV6Yza	2025-07-28 13:17:10.983+00	2025-07-29 08:16:12.334+00	f	f	2025-07-29 08:16:12.334+00	0	f
1223	58	88063002	40-р байр агуулах очиж авна.	5	85000.00	Сүүдрэвч шар 4.5х4.5-1ш. 16:00 цагаас өмнө агуулахаас очиж авна.	9	f	0	f6wjrtp1Qp	2025-07-27 08:20:16.601+00	2025-07-29 04:57:45.966+00	f	f	\N	0	f
259	16	80351423	erdenet hotiin unaand tavina	3	30000.00	2 shirhegiig avsan	14	f	0	KWMZ8tNEmV	2025-07-02 04:09:58.564+00	2025-07-02 06:18:16.047+00	f	f	\N	\N	f
1212	17	99039692	kino uildver 1s omno	5	195000.00	1ш кхмнр	14	f	0	c9JcDqHbRO	2025-07-26 23:02:40.915+00	2025-07-29 04:59:48.045+00	f	f	\N	tsutsalsan	f
1315	63	99549982	Метро молл ард ногоон урлан хотхон 73-5 	3	60000.00	07сарын 30  15цагаас хойш	9	t	16	V0Kmh8v28H	2025-07-29 08:17:02.864+00	2025-07-30 15:10:50.855+00	f	f	2025-07-30 09:17:11.239+00	0	f
266	16	99460069	tsirkiin baruun hoino nomiin sand	3	15000.00	baihgyi	24	f	0	ph7IS5nw4x	2025-07-02 04:34:17.159+00	2025-07-02 06:34:24.629+00	f	f	\N	\N	f
267	16	88104780	saporro 5 r bair 3 davhart 12a	3	15000.00	oroi 8 aas hoish avah	14	f	0	Q0h10YN0Zx	2025-07-02 04:35:09.656+00	2025-07-02 08:23:14.547+00	f	f	\N	\N	f
1681	6	99540562	selenge aimag hurul buyu saihan sum	3	0.00	anduudaas yawdag	9	f	0	JzPuLMqCjw	2025-08-14 04:37:20.19+00	2025-08-15 02:48:30.33+00	t	f	2025-08-15 02:48:30.33+00	margash unaan yvn	f
1285	21	88885800	hotiin tuvd ugluunii gudamjind	3	0.00	Saruul Ganbat-d	9	f	0	Np3CTvPcPi	2025-07-29 01:37:36.759+00	2025-07-29 11:26:13.21+00	t	f	2025-07-29 11:26:13.21+00	0	f
1649	19	96691799	5shar avtusni buudl	3	86000.00	төлбөр танайх авна	9	f	0	uobblzGKzs	2025-08-13 10:44:22.253+00	2025-08-14 11:39:56.268+00	f	f	2025-08-14 11:39:56.267+00	0	f
1299	63	96694632	 5 хороо 10 хороолол 14B байр  2орц	3	60000.00	  	24	t	16	cN9rFxzleM	2025-07-29 04:39:45.92+00	2025-07-30 15:10:50.855+00	f	f	2025-07-29 07:05:57.221+00	0	f
1262	59	99953878	БЗД 43 хороо Guru travel ард талын байр 	5	6000.00	ирэхээсээ өмнө залгах	9	f	0	e3tGuMnGE8	2025-07-28 07:44:59.286+00	2025-07-31 03:09:09.69+00	f	f	\N	0	f
1250	63	99226200	монгол 3сургууль авто плаза чанх хойшоо яваад наран маркет 	3	60000.00	7сарын 27нд авна	9	t	16	qnG5HnzR3x	2025-07-28 03:17:15.406+00	2025-07-30 15:10:50.855+00	f	f	2025-07-29 09:43:23.057+00	0	f
1721	19	99302057	urt tsagaanii zvvn urd uulzwar elegant salon	3	86000.00	төлбөр танайх авна. эртхэн хүргэх -ажил тарахаас өмнө	9	f	0	ZMRAcUY6FR	2025-08-14 15:09:21.722+00	2025-08-15 08:22:12.411+00	f	f	2025-08-15 08:22:12.411+00	0	f
1239	63	98210988	Хөвсгөл, Тариалан	5	60000.00	Хөвсгөл аймаг тариалан сум нарантуул захаас унаанд тавих	67	f	0	vRUQ7VFZDX	2025-07-28 02:05:39.457+00	2025-07-30 14:54:02.915+00	f	t	\N	хөдөө хол байгаа тул ирэхээрээ ярина гэсэн хугацаа тодорхойгүй	f
1331	63	99350085	erdnetruu unaand taviulah 	5	60000.00	erdnetruu unaand taviulah 	3	f	0	ZNM4YD121L	2025-07-30 03:07:30.066+00	2025-07-30 14:54:02.915+00	f	t	\N	bolison	f
1306	63	86091468	arhangai 	5	60000.00	arhangai 	3	f	0	NeOSc8ML7o	2025-07-29 06:38:44.903+00	2025-07-30 14:54:02.915+00	f	t	\N	bolison	f
265	16	89014457	ktms iin ard mt kolonkiin ard taliin bairnii gadaa ired zalgah	3	15000.00	baihgyi	24	f	0	hTExZI5uB2	2025-07-02 04:33:30.065+00	2025-07-02 09:32:55.628+00	f	f	\N	\N	f
264	16	94202225	huuchin dragon deer ochood zalgah	3	15000.00	baihgyi	14	f	0	VuQ7WspHwD	2025-07-02 04:20:39.394+00	2025-07-02 10:25:45.389+00	f	f	\N	\N	f
2295	77	99924259 	Замын цагдаагийн газрын зүүн талд Үйлдвэрчин хотхон	5	25000.00	 60- 177 тоот. 10 давхарт.	\N	f	0	EfDn0ltlKt	2025-08-25 13:32:31.265+00	2025-08-26 04:07:52.101+00	f	f	\N	0	f
2351	59	95775841	tokyo town 2 124orts 401toot	2	35000.00	0	78	f	0	XH0eyzwINP	2025-08-25 17:29:32.325+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
858	2	89040426	Амгалан цагдаа хотхон 75/7 байр 2 орц 3 давхарт 71 тоот	3	500000.00	30Л тэй очоод төлбөрөө авах	14	f	0	KKxBaOte3x	2025-07-09 06:38:58.18+00	2025-07-09 12:13:39.621+00	f	f	2025-07-09 12:13:39.621+00	\N	f
276	16	86659505	suhbaatar duureg -11 r horoo nogoon nuurin gudamj darhan urguu hothon 1018r bair908 toot hoid orts	3	15000.00	baihgyi	9	f	0	ZLoqXcPdiu	2025-07-02 08:47:20.854+00	2025-07-03 13:23:06.961+00	f	f	\N	\N	f
279	23	99196825	1-р хороолол 34-р байр 171 тоот /14 цагаас хойш авна/	3	39900.00	GR	9	f	0	R3HnvopWHS	2025-07-02 11:13:49.719+00	2025-07-03 10:17:15.372+00	f	f	\N	\N	f
286	23	94683427	3.4-р хороолол Номин хойшоо энхбаяр зам МБ моторс авто сервис ирээд залгах 	3	39900.00	GR	9	f	0	iX6X9mP7Xm	2025-07-02 11:16:45.431+00	2025-07-03 11:22:19.19+00	f	f	\N	\N	f
2397	71	89810389	dornod	2	0.00	.	66	f	0	za2JYAobk5	2025-08-26 06:10:36.131+00	2025-08-26 06:18:43.494+00	f	f	\N	0	f
270	16	88195433	time tower hothon	5	30000.00	2 shirheg avna	14	f	0	Tuct5UOj60	2025-07-02 04:59:05.477+00	2025-07-03 06:43:31.61+00	f	f	\N	\N	f
283	23	91114185	БЗД Нётур худалдааны төвөөс нарны намлуугаа нийлдэг зам дагуу 256-р цэцэрлэг дээр	3	49900.00	g9 tom 	14	f	0	TNtRBIv5Df	2025-07-02 11:15:33.767+00	2025-07-03 08:05:01.609+00	f	f	\N	\N	f
272	19	99137248	Баянзүрх  дүүрэг 16р хороолол 68b байр5 давхар 26 тоот монгол  хотхоны Зүүн талд 10 давхарбайр	3	86000.00	10 давхар 1 орцтой байр төлбөр аваагүй	3	f	0	1J0wcWZFT5	2025-07-02 08:01:15.81+00	2025-07-03 04:52:28.884+00	f	f	\N	\N	f
287	23	88370751	1 хороолол 5 байр 71	3	59900.00	i4 tom 	9	f	0	vzWGprdz2Z	2025-07-02 11:17:09.774+00	2025-07-03 09:50:47.642+00	f	f	\N	\N	f
285	23	99840130	Бзд Баганат өргөө хороолол 420-10-56	3	34900.00	L5	14	f	0	MtJv7qeVfo	2025-07-02 11:16:22.944+00	2025-07-03 16:17:25.461+00	f	f	\N	\N	f
282	23	95741847	denjiin 1000 zam guuriin avto baaz	5	39900.00	PK	9	f	0	TdRNiyeIaj	2025-07-02 11:15:10.794+00	2025-07-04 10:28:42.379+00	f	f	\N	\N	f
296	17	99708224	зүүн салааны 1р буудал дээр хоол зардаг машинд	3	195000.00	камэр 1ш	9	f	0	PfIc5HsuRW	2025-07-02 13:09:48.436+00	2025-07-03 08:30:31.109+00	f	f	\N	\N	f
275	16	99138149	crystal townii baruun tald Sumber ord hothon603 iin 33 toot4 davhart	3	15000.00	baihgyi	14	f	0	EOAq6aR3cm	2025-07-02 08:38:08.543+00	2025-07-03 07:27:34.376+00	f	f	\N	\N	f
293	23	99207997	13-р хороолол Шинэ монгол сургууль хажууд 45-р байр чиптэй ирээд залгах 	3	39900.00	PK	14	f	0	zxXKKD786w	2025-07-02 11:19:30.342+00	2025-07-03 08:04:27.86+00	f	f	\N	\N	f
300	21	98119697	MUIS-n hoino MT office-n bairand avna.	3	0.00	ireed zalgaarai, buuj ochood awna, swl receptiond uldeej bno	14	f	0	vz1YWcfLTy	2025-07-03 00:36:26.578+00	2025-07-04 11:13:43.363+00	t	f	\N	\N	f
301	21	80100909	3r horoolol nomin ih delguuriin chanh ard 10r bair 2orts 51 toot 	3	0.00	Namuun Ganbold-d 	9	f	0	Faydrq2IAM	2025-07-03 00:38:04.195+00	2025-07-04 07:02:06.105+00	t	f	\N	\N	f
299	21	88888262	zaisan HAAIS-n ard ALTANBOGD hothon A block 2dav 2 toot	3	0.00	Gerelee Bayandalai-d	3	f	0	IB6Bn9UasK	2025-07-03 00:34:20.044+00	2025-07-04 10:09:31.519+00	t	f	\N	\N	f
309	16	88306869	chingeltei duureg 18r horoo sarandava hiidiin hajuud haluun usnii gazart	3	15000.00	baihgyi	14	f	0	8PZeUuBmTu	2025-07-03 03:22:32.256+00	2025-07-03 13:13:43.437+00	f	f	\N	\N	f
622	16	99291318	zamiin unaand tavina	5	15000.00	baihgyi	9	f	0	NJCP897FOS	2025-07-06 03:49:19.944+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
1102	10	99009348	chd barilchdiin talbai global center 703 toot	5	76000.00	erchuudin beldmel shilajit 1sh	3	f	0	TIg0WOiiY1	2025-07-23 09:19:02.603+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1051	10	88709918	eh nylhsiin hoino 5 davhar shar bair 	3	65000.00	gvn tseverlegch 	14	t	8	u4RPpYZvUY	2025-07-23 06:50:24.511+00	2025-07-25 06:15:20.103+00	f	f	2025-07-23 10:46:20.754+00	0	f
1077	10	96036992	bgd TBD anduud 6-40	5	65000.00	gun tseverlegch 2 shirheg	3	f	0	B8VUhYYegT	2025-07-23 07:37:06.312+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
991	58	99221932	БГД, 27-р хороо, 29/3-р байр, 32тоот. Код #4230	3	45000.00	Сүүдрэвч цэнхэр 3х3. нисэх актив гарденгахс авна.\n1ш баганы үе өнгө алдсан тул хямдарсан.	9	t	11	aW20wRe371	2025-07-22 09:44:09+00	2025-07-25 06:17:06.424+00	f	f	2025-07-24 09:47:52.984+00	0	f
1386	6	96757584	shd orchlon horoolol	3	0.00	onoodor	14	f	0	O0UfUBnCHl	2025-08-01 07:19:20.432+00	2025-08-01 14:08:20.115+00	t	f	2025-08-01 14:08:20.115+00	0	f
1204	46	86704293	Налайхын унаанд тавина	5	229000.00	проектор\n❗️Анхааруулга❗️\n6552 УНЧ гэсэн дугаартай хар прүст өгж болохгүй эмэгтэй жолоочтой бусад нь болно	14	f	0	1yZkU6qHtT	2025-07-26 10:27:38.902+00	2025-07-29 04:54:03.352+00	f	f	\N	utsa awagu	f
1255	61	80122266	yarmag1  buudal carefour delguuriin hoino deedsiin urguu hothon 909/2 bair 5-26 toot	3	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	3	f	0	zTP4hAEfsl	2025-07-28 06:42:37.461+00	2025-07-29 12:14:20.567+00	t	f	2025-07-29 12:14:20.567+00	0	f
1286	59	85206069	МҮИС 12 давхар 1217 тоот 	3	6000.00	энэ шинэ хаяг нь шүү өмнөх хаяг дээр хүргэхгүй 	9	f	0	C6Q3b5kHI8	2025-07-29 01:41:56.001+00	2025-07-30 10:09:30.624+00	f	f	2025-07-30 10:09:30.624+00	0	f
1193	63	99640742	19р хороо цайз 16 дээр Акума 16 салбарт охиныхоо ажил дээр авна	3	60000.00	байнгын байна	14	t	16	akckNcHlmY	2025-07-26 03:27:46.039+00	2025-07-30 15:10:50.855+00	f	f	2025-07-27 06:22:57.85+00		f
1412	59	91080104	Дархан 	3	6000.00	ы	3	f	0	2A4g32OBoW	2025-08-03 13:07:01.622+00	2025-08-04 08:02:40.966+00	f	f	2025-08-04 08:02:40.966+00	0	f
1486	6	85937593	naadam tsentr 2dawhart	3	0.00	onoodor	9	f	0	fUzfUxAE1y	2025-08-06 05:38:18.476+00	2025-08-06 08:10:44.332+00	t	f	2025-08-06 08:10:44.332+00	0	f
1505	10	hdhhhz	hsjhhgs	5	111.00	hsisj	9	f	0	A6guXbjMNv	2025-08-07 08:15:01.453+00	2025-08-07 08:16:47.214+00	f	f	\N	0	f
284	23	88028292	БЗД Өгөөмөр захын зүүн талд 51р байр 1р орц 2давхар 14Б тоот	3	39900.00	g41 jijig	14	f	0	mqy4hN4TEW	2025-07-02 11:15:58.874+00	2025-07-03 08:35:23.061+00	f	f	\N	\N	f
306	26	99527654	нарны зам дагуу миний дэлгүүрийн баруун талд 133 байр 7 тоот тор	3	28000.00	тор	14	f	0	GifOsTfAoT	2025-07-03 02:18:30.488+00	2025-07-03 08:45:58.361+00	f	f	\N	\N	f
320	17	85435884	zoloo hotel	3	0.00	yaraltai hurgelt	9	f	0	BjttRPvsLS	2025-07-03 06:16:40.806+00	2025-07-03 06:17:51.194+00	t	f	\N	\N	f
2296	77	89057751 	 hanigarird city	2	19000.00	1460r bair 8toot 	78	f	0	QAUklYHQGZ	2025-08-25 13:33:00.774+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
242	17	88989591	Орбитын тойрог	5	100000.00	5ш наранцэцэг	24	f	0	ZhoBKOn6gq	2025-07-02 02:15:51.803+00	2025-07-06 17:22:10.522+00	f	f	\N	\N	f
333	23	96620692	Дэнжийн 1000 шонхор зах хажууд ирээд залгах 	3	39900.00	GR PK	14	f	0	6X8ljEd8O4	2025-07-03 10:53:56.473+00	2025-07-06 02:27:46.68+00	f	f	\N	\N	f
303	26	91173808	1 р хороолол хархорин зах 2 давхарт 58 59 р лангуун дээр тор	5	28000.00	зах ажиллах цагаар	9	f	0	H5mW4xsXwC	2025-07-03 02:15:15.885+00	2025-07-03 09:23:56.635+00	f	f	\N	\N	f
1023	61	99025147	БЗД ногоон төгөл 77байр 3тоот	3	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	24	f	0	QVvXkGEEAJ	2025-07-23 03:42:27.696+00	2025-07-23 12:00:29.743+00	t	f	2025-07-23 12:00:29.743+00	0	f
289	23	99067214	Төмөр замын дээд сургуулийн хажууд 107-р байр 3-р орц 3031 тоот 	3	54900.00	i5 jijig	9	f	0	YGwsheSYOT	2025-07-02 11:17:58.594+00	2025-07-03 07:02:19.011+00	f	f	\N	\N	f
304	26	80340901	баянхошуу тойрогоос уруудаад замын зүүн гар талд өнөр зоог дотор тор	3	28000.00	ок	9	f	0	gBZZzJeEpD	2025-07-03 02:16:36.689+00	2025-07-03 08:06:49.492+00	f	f	\N	\N	f
308	26	91615146	баянхошуу тойрог очхоосоо өмнө залгах баруун салаанаас очиж авна тор	3	28000.00	ок	9	f	0	Pwm3xSuDIW	2025-07-03 02:20:25.323+00	2025-07-03 08:09:53.954+00	f	f	\N	\N	f
298	17	99453671	өргөтгөл дээр Увс зогсоол	5	195000.00	1ш камэр өглөө	14	f	0	o6ycWrVhJf	2025-07-02 14:07:05.56+00	2025-07-03 10:16:58.737+00	f	f	\N	\N	f
297	17	96488457	Дорнод унаанд	3	195000.00	Дорнод унаанд өглөө	14	f	0	KyyDY6PqrO	2025-07-02 14:05:45.114+00	2025-07-03 10:23:52.911+00	f	f	\N	\N	f
313	16	95957714	x apartment D2/9 toot	3	15000.00	bhgyi	14	f	0	NcDGa3Mr5m	2025-07-03 03:33:48.089+00	2025-07-03 10:58:00.831+00	f	f	\N	\N	f
2352	52	80690904	Hunnu 2222 erhi mergen tsetserlegt	2	6000.00	9-17.00 hoorond bn	78	f	0	NyFTh1CPTU	2025-08-25 17:51:34.396+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
330	23	96691130	Нарны хороолол 7-р байр 4-р орц 6 давхар 201 тоот 	3	39900.00	GR	3	f	0	k4gZrLw9BH	2025-07-03 10:52:48.362+00	2025-07-04 08:13:08.716+00	f	f	\N	\N	f
332	23	80113377	Яармаг нутгийн буян 878-р байр 2-р орц 607 тоот 	3	59900.00	i7 tom 	3	f	0	6SMl7FKkmE	2025-07-03 10:53:33.604+00	2025-07-04 13:37:58.38+00	f	f	\N	\N	f
321	16	89178797	suhbaayar duureg,11 r horoo, darhan urguu hothon,1012r bair 306 toot	3	15000.00	baihgyi	14	f	0	AnJBoAX7Pa	2025-07-03 06:44:39.377+00	2025-07-04 12:46:45.927+00	f	f	\N	\N	f
1103	10	88118606	100ail chandmani delguur 	5	132000.00	zagasnii tos 6sh	3	f	0	IQMWVrkBTo	2025-07-23 09:29:55.784+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
326	16	89505519	altai hothon	5	15000.00	baihgyi	3	f	0	nD4sfgJrtA	2025-07-03 07:21:48.157+00	2025-07-04 08:32:03.196+00	f	f	\N	\N	f
339	17	86088797	100ail sodon toviin 3davhart	3	0.00	baraa ochij avah dohod yarival zam deer gargaj ogno Gesen	14	f	0	6m4E7wNI53	2025-07-03 11:57:37.622+00	2025-07-04 11:33:02.895+00	f	f	\N	\N	f
325	17	99007883	вариэтэ төмөр замын 4давхарт	3	60000.00	3ш наранцэцэг.	24	f	0	4VV1j0gr3a	2025-07-03 07:10:52.144+00	2025-07-05 09:34:01.849+00	f	f	\N	\N	f
337	23	91995598	Жуков 13-р байр 2-р орц 24 тоот 	3	39900.00	GR	14	f	0	ROPYZ2jU1M	2025-07-03 10:55:32.64+00	2025-07-05 12:29:32.089+00	f	f	\N	\N	f
340	23	80050510	Сонгино хайрхан дүүрэг. Баруунсалааны 6- р буудал  ирээд залгана уу	3	44900.00	m2 780	9	f	0	Ui4HX2d5sI	2025-07-03 13:20:08.575+00	2025-07-04 13:18:36.523+00	f	f	\N	\N	f
335	23	99288891 80840050 	2-р сургууль Төрийн банктай байр Төгс гутлын дэлгүүр 89803343 бараа хүлээж авах хүн 	3	59900.00	i4 tom 	9	f	0	DwsrK7Zkdf	2025-07-03 10:54:41.151+00	2025-07-05 08:32:04.31+00	f	f	\N	\N	f
331	23	99076515	 БЗД бөхийн өргөөний автобусны хойд буудал, Төрийн өмчийн байранд	3	44900.00	m1	14	f	0	NGknHgT9u6	2025-07-03 10:53:11.382+00	2025-07-04 08:37:41.363+00	f	f	\N	\N	f
329	23	99262899	10 хороолол голдэн парк 1 . 105 байр 7 давхарт 84 тоот	3	54900.00	i9 jijig	24	f	0	ZIZtpLu3Cc	2025-07-03 10:52:25.658+00	2025-07-05 10:09:52.712+00	f	f	\N	\N	f
379	2	94090883	Хангай хотхоны зүүн талд 515р байр 5 давхарт 26тоот	3	500000.00	30Л орой 8 цагаас хойш хүргэх	14	f	0	yAvKaXhdDe	2025-07-04 01:29:48.464+00	2025-07-04 14:11:01.553+00	f	f	\N	\N	f
353	4	88470099	Төв шуудангийн замын урд Эко товер 14 давхар 1403тоот ажлын цагаар 09:00-17:00	3	0.00	hurdan	14	f	0	ugaP3FKoT4	2025-07-03 14:39:29.395+00	2025-07-04 10:31:02.263+00	t	f	\N	\N	f
345	26	89112919	худ тэмээтэй хөшөөний хажууд дөхөөд залгахаар заагаад өгнө тор	3	28000.00	ок	3	f	0	uE1jnlXvxW	2025-07-03 14:23:08.908+00	2025-07-04 10:46:25.324+00	f	f	\N	\N	f
1130	21	99984559	ofitser 14r surguuliin urd 119r bair 2 orts 5dav 68 toot	1	0.00	tuyanaa-d	\N	f	0	kkZEqWTaUP	2025-07-23 14:10:56.464+00	2025-07-24 03:15:04.092+00	t	f	\N	0	t
1052	10	88693029	tets 4 deer 	5	65000.00	tvrvv bulchirhain naalt 	66	f	0	ACvDWismFv	2025-07-23 06:51:04.151+00	2025-07-24 04:23:12.08+00	f	f	\N	0	f
2398	71	86333390	SHD 31r horoo saporro sport zaal	2	0.00	.	9	f	0	QuIHT8JWLC	2025-08-26 06:18:32.732+00	2025-08-26 06:19:14.398+00	f	f	\N	0	f
1078	10	99184342	bgd 4 r horoolol modnii 2 world mongolia tower 808toot	3	65000.00	gun tseverlegch 2shirheg	9	t	10	xzNNqaarpP	2025-07-23 07:38:46.694+00	2025-07-25 06:16:46.596+00	f	f	2025-07-23 10:02:48.709+00	0	f
1683	6	99194216	tsetseg tuw	3	0.00	ajliin tsagaar	9	f	0	J8ZtEfAtaG	2025-08-14 04:39:23.796+00	2025-08-14 06:15:56.343+00	t	f	2025-08-14 06:15:56.342+00	0	f
1194	63	99943011	erdnet 	3	60000.00	  	9	t	15	kXpwgHaGOb	2025-07-26 03:32:41.194+00	2025-07-27 05:28:48.894+00	f	t	2025-07-26 08:30:47.168+00	0	f
362	26	80800912	баянбүрд шинэ замын го тү маркет 1 дав в 126 лангуу тор	3	28000.00	ок	9	f	0	MoyrOH3JTl	2025-07-04 00:51:36.127+00	2025-07-04 08:25:33.671+00	f	f	\N	\N	f
552	26	99021856	99021856 dragon towiin hoid gem iin arhinii uildwer deer tor	3	19900.00	CXDuureg	24	f	0	LpqElxVE1K	2025-07-06 00:08:04.043+00	2025-07-07 09:49:27.428+00	f	f	\N	\N	f
351	26	88898669	чд хүнсний нэг дээр ирээд залгаа гараад авчихнаа гэнэ тор	5	28000.00	ок	9	f	0	PSAArqilV8	2025-07-03 14:35:41.616+00	2025-07-04 14:03:07.176+00	f	f	\N	\N	f
997	20	99506307	СХД, 24-р хороо, Зээлийн 1-ж тоот Соёмбо дэлгүүр	3	6000.00	төлбөр авахгүй	66	f	0	ZiRvSpgTTj	2025-07-23 00:11:50.585+00	2025-07-23 12:29:16.464+00	f	f	2025-07-23 12:29:16.464+00	0	f
364	26	80064794	хуучин бөмбөгөр зүүн тад хуучнаар содон бөмбөгөр 10-34 лангуу	3	28000.00	ок	9	f	0	PhNCRKZxPw	2025-07-04 01:06:17.094+00	2025-07-04 11:06:11.746+00	f	f	\N	\N	f
350	26	88095323	схд 21 хороолол шинэ өргөө хороолол 5 орц 5 давхарт 34 тоот тор	5	28000.00	ок	9	f	0	LN3F3aPO80	2025-07-03 14:32:37.784+00	2025-07-04 14:39:57.866+00	f	f	\N	\N	f
359	26	99877275	Алтай хотхоны урд Хан уул дүүрэг хос даль хотхон 53 н 1 155 тоот 2 машины тор	3	56000.00	uchigdur dugaar buruu bichigdsen bsn bn gertee bainga baina gene tor	3	f	0	X8B4TBXDJb	2025-07-04 00:48:31.617+00	2025-07-04 08:38:41.165+00	f	f	\N	\N	f
352	26	96653354	бөмбөгөрийн хажууд найман шарга дээр ажлын цагаар тор	3	28000.00	Ок	9	f	0	uo0jIg4zq0	2025-07-03 14:37:07.501+00	2025-07-05 11:07:08.519+00	f	f	\N	\N	f
343	26	94091135	схд 30 хороо 34ын арын 34 гүүр гараад залгах тор	3	28000.00	ок	24	f	0	lkzBXkKoNJ	2025-07-03 14:20:57.696+00	2025-07-05 15:53:01.364+00	f	f	\N	\N	f
619	16	94444064	ulaan huaran comfort hothon 71a bair 14 davhart 200 toot	3	15000.00	baihgyi	14	f	0	pmS2Y5Qrk2	2025-07-06 03:43:45.621+00	2025-07-06 11:59:41.153+00	f	f	\N	\N	f
312	16	99679281	apu xxk	5	15000.00	baihgyi	3	f	0	Tp50NsF4Ru	2025-07-03 03:33:05.707+00	2025-07-04 17:52:03.164+00	f	f	\N	\N	f
305	26	99154530	схд орчлон хороолол 41 байр 185 тоот тор	5	28000.00	ок	24	f	0	MBH0z5hzGx	2025-07-03 02:17:25.499+00	2025-07-06 17:24:07.148+00	f	f	\N	\N	f
344	26	95460195	худ хүннү 2222 101/1 байр 17 давхарт 17б тоот тор	5	28000.00	ок	3	f	0	UeyV5uVe3f	2025-07-03 14:22:09.1+00	2025-07-04 10:25:02.185+00	f	f	\N	\N	f
358	16	88018953	Home plaza giin baruun urd hans vill hothon 104 bair 1 ortstoi 6 davhart 601 toot. Han uul iin home plaza	3	0.00	zalgaj bgad ochij tatan awalt awah gsima gd	9	f	0	Kh0VY3dtWV	2025-07-03 18:57:41.598+00	2025-07-04 10:28:57.965+00	t	f	\N	\N	f
617	26	98100145	98100145 yaarmag shine orgoo horolol 607 - 21 toot tor	3	19900.00	yaarmag	3	f	0	JixLgsZPuM	2025-07-06 02:34:31.395+00	2025-07-07 13:13:52.134+00	f	f	\N	\N	f
346	26	95641049	схд 5 шар ач интернешнл эмнэлэг дээр ажлын цагаар тор	3	28000.00	ажлын цагаар	9	f	0	UteOD1OLyW	2025-07-03 14:24:24.39+00	2025-07-09 07:32:47.892+00	f	f	2025-07-09 07:32:47.892+00	\N	f
347	26	95292991	худ 5 хороо яармаг 21 гудам 574 тоот тор	3	28000.00	ок	3	f	0	Oqdhh4bPD7	2025-07-03 14:26:50.205+00	2025-07-05 02:04:45.319+00	f	f	\N	\N	f
1237	52	80088354	SBD 11 r horoo Khangai hothonii hoino 911r bair  Huuchnaar 9r delgvvriin tend 2 block nogoon bair	3	6000.00	Garaad Wna	9	f	0	CvEWasIwb3	2025-07-27 18:06:48.012+00	2025-07-29 13:51:48.144+00	f	f	2025-07-29 13:51:48.143+00	0	f
2353	59	94800958	erdene tolgoin toirog bzd 8r horoo	2	0.00	0	66	f	0	g4eFKrmecU	2025-08-25 17:51:52.861+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
319	16	86167576	chingeltei duureg deer	5	15000.00	baihgyi	9	f	0	lMKNDCfJCa	2025-07-03 05:21:41.529+00	2025-07-06 13:13:31.817+00	f	f	\N	\N	f
1287	63	99093004	 зүүн 4замамерикон дэнж хотхон 144- байр 193тоот	5	60000.00	  	67	f	0	CRowzoIpcJ	2025-07-29 02:13:29.688+00	2025-07-30 06:26:14.293+00	f	f	\N	0	f
1079	10	99102138	modnii 2 oimon office 2 draw	5	65000.00	togloomon mashin 2 shirheg	3	f	0	DZZDduJUhn	2025-07-23 07:39:57.593+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
406	10	86163350	zaisan proline kargonos baraa awah 86163350 helj awah	3	20000.00	oyutni orgoo 2 deer hurgej ogoh	14	f	0	A0OhmBoALk	2025-07-04 04:05:39.631+00	2025-07-04 16:29:55.29+00	f	f	\N	\N	f
412	21	89058880	hunnu 2222 horoolol 111bair 1orts 9dav 9b toot	3	0.00	tuguldur oyunbilegt orts kod 2345#	3	f	0	8XuyPk43G7	2025-07-04 08:46:06.891+00	2025-07-05 07:47:38.437+00	t	f	\N	\N	f
397	16	91194482	baganat horoolol. 419 bair 15 davhar  87toot	3	15000.00	baihgyi	14	f	0	H0ubEMORgq	2025-07-04 02:18:19.253+00	2025-07-04 04:37:14.471+00	f	f	\N	\N	f
1104	10	94942766	blue sky baruun tald street foodnii zogsool deer	5	49000.00	nudnii tsatslag 1sh	3	f	0	LrEXMwwEKR	2025-07-23 09:33:51.561+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
2297	77	88456214 	narangiin goliin shin etses deer ochod zalgah	2	25000.00	88856214 	9	f	0	LBfqW7FkLs	2025-08-25 13:33:31.687+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
986	10	88064537	narnii horoolol	1	1000.00	222	\N	f	0	7A7QGZ1U86	2025-07-22 04:48:49.916+00	2025-07-22 04:57:18.028+00	f	f	\N	0	t
1131	21	99984559	ofitser 14r surguuliin urd 119r bair 2 orts 5dav 68 toot	3	0.00	tuyanaa-d	14	t	9	gRd8ZWuiy7	2025-07-23 14:10:56.498+00	2025-07-25 06:15:33.973+00	t	f	2025-07-24 05:52:10.796+00	0	f
1053	10	90202720	BGD modnii 2 65r bair 3 davhar 9 toot 	3	76000.00	uhaalag tsag 	9	t	10	0K4xzXgdGE	2025-07-23 06:52:11.506+00	2025-07-25 06:16:46.596+00	f	f	2025-07-23 10:03:26.739+00	0	f
1152	52	89116652	Buyant Uhaa - n Niseh 86 bair	3	6000.00	Ochood zalgah	3	f	0	FBPs3eLQw5	2025-07-24 08:20:49.096+00	2025-07-26 11:23:48.385+00	f	f	2025-07-26 11:23:48.384+00	0	f
356	16	99071383	хуучин драгон дээр авна	5	15000.00	7.4 ны орой 4 цагаас өмнө авна	9	f	0	8GPaYVtbhv	2025-07-03 15:48:11.527+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
1214	6	89129243	uliastai huuchin etses bolor delguur	3	0.00	tootsoo hiisen	14	f	0	uYceNheq1k	2025-07-27 04:35:40.964+00	2025-07-27 07:30:30.452+00	t	f	2025-07-27 07:30:30.452+00	0	f
1684	61	99748478	дархан	3	0.00	орон нутаг	68	f	0	zRTzp0qXKi	2025-08-14 04:39:59.193+00	2025-08-15 04:33:14.101+00	t	t	2025-08-15 04:33:14.101+00	0	f
929	46	99746954	сонгинохайрхан дүүрэг 18 хороо 5 шар хороолол 66 байр 8 давхар 83 тоот	5	229000.00	проектор	9	f	0	tfUw5kRHOH	2025-07-20 12:26:54.931+00	2025-07-29 04:57:45.966+00	f	f	\N	margash mongon orhir awan gesn	f
1716	59	95598430	ХУД 20 р хороо 57а 49 тоот 	3	0.00	ирэхээсээ өмнө залгах	68	f	0	MnuLi4i3cJ	2025-08-14 11:38:03.861+00	2025-08-15 10:59:12.558+00	f	f	2025-08-15 10:59:12.558+00	0	f
1167	63	88351112	ovorhangai 	5	60000.00	7/26	9	f	0	cm8OK0REtc	2025-07-25 06:05:35.425+00	2025-07-29 04:57:45.966+00	f	t	\N	0	f
1170	63	88550754	Цайз 16 Батлан хамгаалах их сургууль өгсөөд СОД Монгол колонкийн харалдаа замын хойд талд  14 давхар 2 ягаан канттай саарал байр 47Б байр 13 давхар 1307т	3	60000.00	  	14	t	16	6drmyKlvEa	2025-07-25 06:20:21.27+00	2025-07-30 15:10:50.855+00	f	t	2025-07-25 10:23:15.582+00	0	f
1269	21	99403099	shine dragonoos Arhangai avtobusand uguh. 	3	0.00	ugluu 8 udur14. oroi 19s avtobus yawna	24	f	0	FRHVxGI0h4	2025-07-28 13:34:09.995+00	2025-07-29 07:40:27.071+00	t	t	2025-07-29 07:40:27.071+00	0	f
402	2	86092428	Зайсан Жардин хотхон 101-102 тоот	3	600000.00	50Л мөнгөө очоод авах	14	f	0	biZ9JoVX6v	2025-07-04 03:24:50.341+00	2025-07-04 16:29:29.358+00	f	f	\N	\N	f
1105	10	95955725	shd 8-horoo 29r bair 5/5 58toot	5	112000.00	zagasni tos 4sh	3	f	0	dw4EpIxMMo	2025-07-23 09:35:19.549+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
413	21	91919919	ih mongol horoolol 905 bair 3orts 7dav 120toot	3	0.00	suvda suvda-d orts kod #9053	14	f	0	feJRqGTJbs	2025-07-04 08:47:28.851+00	2025-07-05 09:04:13.693+00	t	f	\N	\N	f
989	58	95450399	5 шар, 15-р байр, 3-36 тоот. Гаднаа шар өнгийн дулаалга хийсэн хуучин 5 давхар байр.	3	55000.00	Сүүдрэвч ногоон 3х3. Нисэх актив гарденаас авна.	66	f	0	AEU2h8221Z	2025-07-22 08:03:04.4+00	2025-07-23 14:58:40.201+00	f	f	2025-07-23 14:58:40.201+00	0	f
407	10	89807400	shd 19-horoo 54bair 3dawhart 10 toot miraj zochid buudalzuun ereged	3	0.00	hurdan	9	f	0	Nb0HLEnJnU	2025-07-04 05:41:55.431+00	2025-07-04 12:18:43.386+00	t	f	\N	\N	f
348	26	88240936	худ ивээл хотхон 434 байр 2 орц 1216 тоот тор	3	28000.00	эрт байвал сайн байна хөдөө гарах юм гэнэ	3	f	0	juzIxG1zj2	2025-07-03 14:29:09.941+00	2025-07-04 13:09:26.068+00	f	f	\N	\N	f
360	26	91913697	гурвалжин даваад гэрлэн дохиогоор зүүн эргээд han endestrail gns 3 dawhar saaral baishin vagner aziin yag zuun tald 3 давхарт 302 toot tor	3	28000.00	ок	3	f	0	pmUYXYLUZc	2025-07-04 00:49:45.58+00	2025-07-04 08:50:35.786+00	f	f	\N	\N	f
338	23	88760000	ХУД 19-р хороо Дөл хотхон 97А байр 19 тоот	3	44900.00	m2 600	3	f	0	ZPgJrn28SF	2025-07-03 10:55:52.702+00	2025-07-04 09:23:09.113+00	f	f	\N	\N	f
349	26	88081065	худ зайсан  зайсангаас дээш өгсөөд агаарлъя амралтын газрын самбар дээр байна тор	3	28000.00	зайсан дөхөөд залгаарай гэнэ	3	f	0	V4goXikEcK	2025-07-03 14:30:58.082+00	2025-07-04 09:52:33.428+00	f	f	\N	\N	f
568	26	96037494	96037494 5shariin 17bair 4optsnii gadaa irher garaad awchnaa awna top	5	19900.00	5 shar	24	f	0	OmdABdxhSS	2025-07-06 01:17:42.437+00	2025-07-07 06:06:51.404+00	f	f	\N	\N	f
327	16	91029090	120 myngat KH apartment	3	15000.00	baihgyi	3	f	0	4hgA4nqcJ7	2025-07-03 08:53:38.533+00	2025-07-04 10:36:10.196+00	f	f	\N	\N	f
860	17	88093915	Алтай хотхоны урд peace town 1 49_ 2_26	5	195000.00	kamer 1sh өглөө	14	f	0	e5sloVWUG3	2025-07-09 14:21:16.213+00	2025-07-22 13:32:29.568+00	f	f	\N	tsutsalsan	f
409	10	88067051	suhbaatar duureg 10horoo mongol 3-dugar surguulin baruun tald 16b bair 4d 14toot	3	0.00	ortsnii kod 14b	14	f	0	blCdYtPoNz	2025-07-04 05:45:59.468+00	2025-07-04 14:47:41.512+00	t	f	\N	\N	f
417	4	88018288	пийс тауэр -н зүүн хойд талд 6 давхар хүрэн барилгын 4 давхарт 401 тоот	3	1.00	.	9	f	0	XX7rgP1i5R	2025-07-04 09:44:46.048+00	2025-07-05 12:16:29.565+00	f	f	\N	\N	f
398	26	99626872	Hayg huuchin gants hudag Dari eh  Dari ehees monel ywdag zasmal zam daguu 3 bulag hudaldaaniii tow 99626872 top	3	28000.00	ok	9	f	0	OZlyk8QKr7	2025-07-04 02:21:58.678+00	2025-07-05 15:01:29.888+00	f	f	\N	\N	f
415	16	86054411	10 r horoolol my town hothon 108 r bair ireed zalgah	3	15000.00	baihgyi	24	f	0	ZE1hVrSoVI	2025-07-04 08:50:19.417+00	2025-07-05 12:29:42.165+00	f	f	\N	\N	f
414	21	99078710	BZD 26 horoo Olymp hothon 430 bair 2orts 2dav 85toot	3	0.00	ch. uyan-d 	14	f	0	q6oQ6UCOGR	2025-07-04 08:49:04.955+00	2025-07-05 09:30:30.307+00	t	f	\N	\N	f
404	4	99984669	3 дугаар эмнэлгийн урд техник импорт ажлын цагаар.	3	56000.00	.	24	f	0	o78KAxXSKh	2025-07-04 04:01:24.122+00	2025-07-05 13:32:37.803+00	f	f	\N	\N	f
410	17	86870620	шөнийн зах 1давхарт	3	0.00	100айлаас авсан барааг шөнийн захад хүргүүлэх	14	f	0	6vqvAFSPdi	2025-07-04 05:51:00.889+00	2025-07-05 07:59:19.474+00	f	f	\N	\N	f
418	4	99068582	Нарантуул зах өргөтгөл к1 лангуу	3	1.00	.	14	f	0	WQL04rGRq7	2025-07-04 09:45:49.227+00	2025-07-05 07:25:52.684+00	f	f	\N	\N	f
405	4	99016104	13 натур төвөөс урагш 400 метр. Хүслийн өргөө хотхон. 100/3 47тоот	3	34000.00	тооцоотой	14	f	0	ovhBVEha7S	2025-07-04 04:04:30.298+00	2025-07-05 06:03:42.762+00	f	f	\N	\N	f
416	4	91291926	БЗД-н 2-р хороо, КТМС цагдаа хотхоны 13/7-р байр, 103 тоот	3	1.00	.	14	f	0	i3oxfz9F98	2025-07-04 09:39:45.608+00	2025-07-05 11:24:35.415+00	f	f	\N	\N	f
419	18	83166232	Яармаг, хуучин эцэс Жаргалант8-191	3	36000.00	улаан топ	3	f	0	eLqe69zrVE	2025-07-04 10:26:03.789+00	2025-07-05 01:54:12.212+00	f	f	\N	\N	f
302	17	88054763	Бэлх зах дээр	5	95000.00	гэрийн камэр жижиг цагаан хайрцагтай	24	f	0	FRbSVgnOQm	2025-07-03 01:49:49.564+00	2025-07-06 17:22:31.213+00	f	f	\N	\N	f
176	23	99179308	БЗД Монгол хотхон 66д "Бичиг хэрэг&Тоглоом"дэлгүүрт 18 цаг хүртэл байна	5	39900.00	PK	14	f	0	cvYCsYzBO4	2025-07-01 12:20:21.452+00	2025-07-06 13:18:10.629+00	f	f	\N	\N	f
579	26	99037552	99037552 baynhoshuunii toipog 67surguulin avtusnii buudal duhuud zalgh tsaanaas ipj awna top	3	19900.00	bayanhoshu	24	f	0	jMx1iC3CBj	2025-07-06 01:46:26.989+00	2025-07-07 10:19:02.108+00	f	f	\N	\N	f
432	23	99088334	dunjingaraw hudaldaanii tuwd 888r languun dr	3	44900.00	pic mat	14	f	0	evY0aaUmK6	2025-07-04 13:02:21.534+00	2025-07-05 09:01:15.853+00	f	f	\N	\N	f
434	23	99900041	Khan uul duureg 19-r khoroo ub town 81 bair 115r surguuliin urd	3	259800.00	p4 2sh	3	f	0	Rxz6iXsaU4	2025-07-04 13:03:04.589+00	2025-07-05 06:19:46.9+00	f	f	\N	\N	f
429	23	85258685	17 avtobusnii buudal 	3	54900.00	code2	24	f	0	2F5YnerirV	2025-07-04 13:01:18.582+00	2025-07-05 17:13:28.273+00	f	f	\N	\N	f
1025	60	99185033	Yarmag Artsatiin am Hangarid siti-1 1461-r bair 4n dawhart 21 toot	3	99000.00	Tulburuu hiigegui bga	3	f	0	ppKhlNGJum	2025-07-23 04:01:28.305+00	2025-07-23 12:05:02.111+00	f	f	2025-07-23 12:05:02.111+00	0	f
1054	10	88111634	narnii horoolol 35b bair 1202 toot 	3	71000.00	massage neck 	65	f	0	IUQantHE5c	2025-07-23 06:53:20.78+00	2025-07-23 09:14:25.344+00	f	f	2025-07-23 09:14:25.344+00	0	f
2298	77	99098868 	хойморь оффис 	2	20000.00	407 тоот 	73	f	0	YOA6iwDUYf	2025-08-25 13:34:01.48+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
998	20	98075558	3-р эмнэлгийн замын урд талд Peace hotel ресепшинд	3	6000.00	төлбөр авахгүй	9	t	10	x1Rgfgq5Va	2025-07-23 00:12:22.533+00	2025-07-25 06:16:46.596+00	f	f	2025-07-23 09:45:49.971+00	0	f
1080	10	86207499	bgd 33-r horoo 73r bair 62 toot 89090087	3	76000.00	uhaalag tsag	14	t	8	AIcL1gv4RH	2025-07-23 07:41:04.573+00	2025-07-25 06:15:20.103+00	f	f	2025-07-23 10:05:32.936+00	0	f
1682	6	99636813	Suhbaatar aimag dariganga sum	3	0.00	omoo	9	f	0	LQwJzMz0b8	2025-08-14 04:38:55.835+00	2025-08-14 09:38:54.158+00	t	f	2025-08-14 09:38:54.158+00	0	f
1215	6	88156255	uliastai huuchin etses	3	0.00	tootsoo hiisen	14	f	0	joEPKWBZEP	2025-07-27 04:36:19.654+00	2025-07-27 07:30:24.636+00	t	f	2025-07-27 07:30:24.636+00	0	f
1270	21	88112858	HUD 3 horoo Hos Dali hothon 53/3 2orts 4dav 196 toot	3	0.00	erdenezayad. kod 196 zalgah	3	f	0	XLLd8bHWzY	2025-07-28 13:35:29.19+00	2025-07-29 08:04:57.531+00	t	f	2025-07-29 08:04:57.531+00	0	f
420	18	89834033	замын цагдаагийн эсрэг талд Соёолж малл 10 давхарт Jinjoo keran restaurant	3	36000.00	улаан топ	14	f	0	Z3BxYAmqJp	2025-07-04 10:29:03.935+00	2025-07-05 11:01:26.081+00	f	f	\N	\N	f
428	23	98100327	Tsetseg tuviin hoino gmobile office 5 davhar 	3	54900.00	code2	9	f	0	sjBYxrCKgP	2025-07-04 13:00:54.51+00	2025-07-05 09:23:24.778+00	f	f	\N	\N	f
1172	63	88703536	өвөрхангай баянхонгор	5	60000.00	хотоос Баянхонгор явах хүн асуучиад айл руу хүргүүлнэ	3	f	0	wTJvvUfS2D	2025-07-25 07:25:31.721+00	2025-07-30 14:57:27.79+00	f	t	\N	bolison	f
1026	61	94534524	Өргөө хойно дако төв 3 давхарт 95070830 руу залгаарай	3	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	9	t	11	s1GHYkJjlt	2025-07-23 04:43:39.617+00	2025-07-25 06:17:06.424+00	t	f	2025-07-24 05:22:44.145+00		f
1132	59	95737784	БЗД 8-р хороо нохойтой хөшөө өнгөрөөд шөнийн дэлгүүр автобусны буудал эсрэг талын байр 51b орц 6 давхар 64 тоот	3	6000.00	ж	14	f	0	NQaMzcZmP8	2025-07-24 02:17:34.422+00	2025-07-25 11:19:15.613+00	f	f	2025-07-25 11:19:15.613+00		f
1665	19	88010787	Схд, 19-р хороо, 21-р хороолол, 84-104	3	86000.00	төлбөр танайх авна	9	f	0	A0cKBXeXn2	2025-08-14 02:43:34.005+00	2025-08-14 10:57:40.45+00	f	f	2025-08-14 10:57:40.45+00	0	f
421	18	95681000	Ард кино театрын хойно Кореабулл restaurant	3	36000.00	цэнхэр топ	9	f	0	kEvLwg0Vnl	2025-07-04 10:30:12.241+00	2025-07-05 08:56:35.318+00	f	f	\N	\N	f
1680	6	88082080	zaisanmsc-iin buural unguruud azi farm Ulaanbaatar suwilaliin urd tald shudni emneleg super markettai 558 8 toot	3	0.00	a	9	f	0	5DbOyChNpQ	2025-08-14 04:36:17.148+00	2025-08-14 04:40:49.919+00	t	f	2025-08-14 04:40:49.919+00	0	f
426	23	99045090	13 хард рок	3	54900.00	code2	14	f	0	zLbkeHsnyz	2025-07-04 13:00:08.745+00	2025-07-05 16:00:17.607+00	f	f	\N	\N	f
431	23	89511981	KYOKUSHU TOWER 106-bair 6-davhart 23-toot 	3	54900.00	code1	24	f	0	xxvAOMIXdk	2025-07-04 13:02:00.615+00	2025-07-05 12:23:10.114+00	f	f	\N	\N	f
422	23	89899090	Sansar garden 39/5r bair 1r orts 602 toot	3	44900.00	m3 780	14	f	0	2hppD64H0n	2025-07-04 12:58:27.657+00	2025-07-05 10:33:44.86+00	f	f	\N	\N	f
999	20	99950000	Говийн зам, Ривер стоун хотхон 24Б-908 тоот	3	6000.00	төлбөр авахгүй	65	f	0	OWyun5O7fA	2025-07-23 00:12:53.253+00	2025-07-23 10:11:53.076+00	f	f	2025-07-23 10:11:53.076+00	0	f
1055	10	99499434	BGD ub palace 10a 9 davhart 88toot 88003967 17s hoish 	5	139000.00	sahariin tsai 	3	f	0	B749CMSBA9	2025-07-23 06:54:52.475+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
433	23	88119229	"Ajliin tsagaar Dunjingaraw Oroin tsagaar tselmeg xotxon"	3	54900.00	code2	14	f	0	KlRKZn7GeJ	2025-07-04 13:02:46.54+00	2025-07-05 08:28:53.686+00	f	f	\N	\N	f
424	23	99727809 80858562	Монгол 3 р сургуулийн. ард урдаа 16рсургуультай 36 байр 8 тоот	3	44900.00	m2 780	14	f	0	T2XA8U7qTI	2025-07-04 12:59:22.588+00	2025-07-06 02:50:56.733+00	f	f	\N	\N	f
1653	59	99726952	Эрин хороолол 53/8 орц 2 5 давхар 74 тоот 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	LoXgxEdxsO	2025-08-13 12:39:04.249+00	2025-08-14 10:24:57.812+00	f	f	2025-08-14 10:24:57.812+00	0	f
1081	10	86663888	BGD 12 horoo 6r bichil 6a-58	5	76000.00	uhaalag tsag	3	f	0	JnBxYz1Rod	2025-07-23 07:41:56.737+00	2025-07-24 04:20:40.425+00	f	f	\N	tutalsan	f
423	23	99297578	ХУД 19 дүгээр хороо Саруул шилтгээн хотхон 98/2 байр 2 дугаар орц 9 давхар 901	3	34900.00	h1	3	f	0	8xuoz9X0E5	2025-07-04 12:58:49.516+00	2025-07-05 06:12:05.794+00	f	f	\N	\N	f
1106	10	99244518	shd 9 horoo 236b bair 60toot	5	71000.00	erchuudin beldmel milk oil	3	f	0	mq9bYz6oke	2025-07-23 09:36:40.502+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1168	63	80843774	толгойт нарангийн гол 64-35	3	60000.00	7сарын 26нд авна	14	t	14	fXtxiOZ8Wu	2025-07-25 06:08:21.194+00	2025-07-27 04:04:40.905+00	f	f	2025-07-26 09:05:37.196+00	0	f
1196	62	90500043	Энх тайвны гүүрний баруун талд дунд голын зам дагуу Гранде Вилла хотхоны 14 давхарт	3	80700.00	7/26-ны захиалга	9	f	0	9CJKJ87pEx	2025-07-26 04:29:58.113+00	2025-07-27 07:54:53.587+00	f	f	2025-07-27 07:54:53.587+00	0	f
508	16	99000355	BZD sky residence hothon 77c 126 toot	3	15000.00	baihgyi	14	f	0	fR7jfmbNwn	2025-07-05 05:07:28.828+00	2025-07-07 10:57:06.155+00	f	f	\N	\N	f
502	16	99017543	naadam center t	3	15000.00	baihgyi	3	f	0	yFFUuSNwMU	2025-07-05 04:06:57.456+00	2025-07-07 07:08:41.314+00	f	f	\N	\N	f
492	26	88891539	88891539 100 ail altan shagai deguur dotor tor haan bank esreg tald	3	20000.00	ok	14	f	0	wkqfBV4SlC	2025-07-05 02:09:59.403+00	2025-07-06 04:08:25.568+00	f	f	\N	\N	f
501	16	99926508	ih delguuriin 1 davhart	3	15000.00	baihgyi	9	f	0	ueyORIu9mI	2025-07-05 04:06:21.751+00	2025-07-06 06:16:29.872+00	f	f	\N	\N	f
1231	21	88198897	ofitser Bayanzurh hothon 108-7-67 toot	3	0.00	NG NqGq- d	9	f	0	OGnWdpnnOJ	2025-07-27 13:15:05.339+00	2025-07-28 08:14:47.914+00	t	f	2025-07-28 08:14:47.914+00	0	f
483	26	80002850	95830843 метромалл б1 цагаан идээний лангуу 80002850 дугаартай хүнд тор	3	20000.00	ok	9	f	0	O6gWZa1vJM	2025-07-05 02:08:13.238+00	2025-07-06 07:17:33.165+00	f	f	\N	\N	f
503	26	89999357	хуучин Бөмөгөр 1 даврар г 5 лангуу тор 6 хүртэл байна	3	20000.00	ok	9	f	0	vW5jAtxXHl	2025-07-05 04:11:16.062+00	2025-07-05 10:36:50.696+00	f	f	\N	\N	f
474	26	99066969	99066939 худ кинг товер 135 байр 2 орц 6 дав 245 тоот тор	5	20000.00	ok	3	f	0	liOO3JrlnC	2025-07-05 02:01:29.256+00	2025-07-05 13:06:13.658+00	f	f	\N	\N	f
1216	6	95498025	gemtel emneleg	3	0.00	tootso hiisen	9	f	0	5mJGxIBgu0	2025-07-27 04:37:22.805+00	2025-07-27 05:31:59.296+00	t	f	2025-07-27 05:31:59.295+00	0	f
425	23	95980088	3.4 horoolol ezes	5	44900.00	m5	14	f	0	JZxeNMoxPB	2025-07-04 12:59:44.352+00	2025-07-22 04:42:08.842+00	f	f	\N	\N	f
1232	21	88165959	ih delguuriin zuun tald 4dav saaral bair TOPICA office	3	0.00	haliunaa-d	9	f	0	9UVfC4y7HC	2025-07-27 13:16:00.59+00	2025-07-28 09:48:56.002+00	t	f	2025-07-28 09:48:56.002+00	0	f
1220	19	96055198	Чингэлтэй дүүрэг 2р хороо Барилгачидын талбай  дулаан граж 96055198	5	860000.00	төлбөр  танайх  авна	9	f	0	HlwIovxVyB	2025-07-27 07:41:43.538+00	2025-07-29 04:57:45.966+00	f	f	\N	0	f
1229	21	89115478	Buynt Uhaa niseh ongotsnii buudal baruun hoino shilen office-d	3	0.00	Bilge-d	3	f	0	0CjXww5krC	2025-07-27 13:12:47.204+00	2025-07-29 12:14:12.27+00	t	f	2025-07-29 12:14:12.27+00	0	f
1154	63	99033626	 Алтай хотхоны урд Ривер стоун хотхон 24б 2-205 тоот Ирээд залга 	3	60000.00	 	9	t	16	GtRaUD0QVV	2025-07-24 08:38:51.483+00	2025-07-30 15:10:50.855+00	f	f	2025-07-25 12:30:43.021+00	0	f
1271	21	99914090	BZD 26 horoo Time Tower hothon 218 bair Zara delguur deer	3	0.00	Gansuvdiin duud uguh	9	f	0	QYVzf7S8UJ	2025-07-28 13:36:25.492+00	2025-07-30 05:58:55.547+00	t	f	2025-07-30 05:58:55.547+00	0	f
1288	63	99818407	яармаг 312 цэцэрлэг дээр	3	60000.00	яаралтай хүргэж өгөх	3	t	16	M9wLEJEDjD	2025-07-29 02:16:35.492+00	2025-07-30 15:10:50.855+00	f	f	2025-07-29 12:13:03.522+00	0	f
496	22	96331393	Нисэх Гардин Хаан Банк	3	75000.00	код:1 хүргэлт 6к+75000	3	f	0	0vLXenWlFN	2025-07-05 02:56:34.652+00	2025-07-05 13:04:16.052+00	f	f	\N	\N	f
489	17	99444596	Завхан Тэлмэн сум	5	195000.00	камэр	24	f	0	F8jlLC0bdv	2025-07-05 02:08:41.87+00	2025-07-06 17:24:30.507+00	f	f	\N	\N	f
504	26	89461256	89461256 hud 6 horoo nuht 4-70 toot tor	3	20000.00	ok	3	f	0	Cx1MMUjTKg	2025-07-05 04:13:45.873+00	2025-07-05 10:01:19.15+00	f	f	\N	\N	f
497	6	99000230	bohin orgoo hajuud  tald negdelchin zochid buudal 2dawhart ogoodoi zoog 	3	0.00	80880330 	14	f	0	X8k6X8inUx	2025-07-05 03:32:55.625+00	2025-07-05 06:30:04.261+00	t	f	\N	\N	f
1000	20	99329680	Орбит, Хүнс трейд(ирэхдээ яриарай, төвөөр авч болно)	3	6000.00	төлбөр авахгүй	66	f	0	ieMhS5BcUX	2025-07-23 00:13:28.58+00	2025-07-23 13:18:49.618+00	f	f	2025-07-23 13:18:49.618+00	0	f
494	26	85116843	85116843 Нисэх дэнж пирамид хотхон үүдний жижүүр дээр очоод залгах хажуунаас гараад авна	3	20000.00	ok	3	f	0	UiHEmjJb8w	2025-07-05 02:42:26.147+00	2025-07-05 10:23:11.182+00	f	f	\N	\N	f
475	26	99317488	99317488 narnii horoolol 12 bair 5 dawhar 17 toot tor *#1930	3	20000.00	ok	3	f	0	AZzxt3nWRM	2025-07-05 02:01:55.641+00	2025-07-05 06:57:10.351+00	f	f	\N	\N	f
427	23	89975577	"Tumur zam bars zah Mahnii 7-1"	3	44900.00	m2 780	24	f	0	QKqvUG1syi	2025-07-04 13:00:31.306+00	2025-07-05 09:38:29.131+00	f	f	\N	\N	f
500	16	99679281	horoolol gemtlin hajuud	3	15000.00	apu xxk haygaa solison	24	f	0	rTF3HJbyOM	2025-07-05 03:43:01.173+00	2025-07-05 13:17:41.325+00	f	f	\N	\N	f
498	6	80546666	 120 deer ireed zalga	3	0.00	88253095 hurd rapid	3	f	0	XFg8ya0ajp	2025-07-05 03:35:21.032+00	2025-07-05 07:17:09.447+00	t	f	\N	\N	f
506	16	86762911	1 r horoolol sanday2 hudaldaanii tuviin hajuud ired zalgah	3	15000.00	baihgyi	9	f	0	eRz6kIwpgw	2025-07-05 05:05:56.492+00	2025-07-10 12:28:30.54+00	f	f	2025-07-10 12:28:30.54+00	\N	f
490	26	95000655	95000655 гурвалжин даваад гэрлэн дохиогоор баруун эргээд 200 метр яваад шинэ оношлогооны төвөөр баруун гар эргэсэн засмалаар яваад чигээрээ ороод залга 2 машинд авна	3	40000.00	ok 2 mashind	24	f	0	MjXxRB2JvL	2025-07-05 02:08:51.556+00	2025-07-05 11:38:18.34+00	f	f	\N	\N	f
560	26	90124646	90124646  Altai hothon 50a-79 top	3	19900.00	huduureg	3	f	0	hoZJGcNgUe	2025-07-06 00:58:30.678+00	2025-07-07 06:21:58.948+00	f	f	\N	\N	f
479	26	89003877	89003877 120iin intermed emnelgiin zamiin esreg tald 14bair 32toot  top	3	20000.00	ok	3	f	0	ejqChv2hnT	2025-07-05 02:04:14.603+00	2025-07-05 06:40:35.703+00	f	f	\N	\N	f
473	26	99180402	99180402 зайсангийн 51 байр хөдөө аж ахуйн 2 байр 2 орц 28 тоот тор	3	20000.00	ok	3	f	0	IWJL1XsanN	2025-07-05 02:00:40.512+00	2025-07-05 08:12:54.158+00	f	f	\N	\N	f
430	23	88023398	Схд 38-р хороо 21р байр	3	59900.00	i9 tom 	24	f	0	zdBMs2jMk9	2025-07-04 13:01:40.083+00	2025-07-05 14:41:11.915+00	f	f	\N	\N	f
493	17	99320289	Говьсүмбэр унаанд	5	195000.00	камэр 1ш	24	f	0	2OscDdGXZq	2025-07-05 02:17:53.954+00	2025-07-05 03:44:33.837+00	f	f	\N	\N	f
477	26	99041536	99041536 Саппоро талаасаа гурвалжингийн гүүр даваад автобусны 2 дахь буудлын бор ТҮЦний хажуу талын хашаанд Үндэсний шигшээ багийн бэлтгэл сургалтын төв хуучнаар буудлагын клуб	3	20000.00	ok	24	f	0	bt6rz7OXu7	2025-07-05 02:03:26.148+00	2025-07-05 11:26:37.729+00	f	f	\N	\N	f
1018	61	99813573	" songinohairhan duureg 24 horoo  zeeliin 29 iin 53 toot"	3	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	66	f	0	vMDxgqAQvP	2025-07-23 03:35:30.613+00	2025-07-23 12:29:36.324+00	t	f	2025-07-23 12:29:36.324+00	0	f
507	16	99220409	zuun salaa 4r buudal( ulaan delguuriin buudal deer)	3	15000.00	baihgyi	24	f	0	cBAVG38qkq	2025-07-05 05:06:41.567+00	2025-07-07 10:03:50.129+00	f	f	\N	\N	f
718	4	99922891	zaisan bluefin sushi bar	3	0.00	h	3	f	0	BTOInSqc0x	2025-07-07 09:13:42.9+00	2025-07-07 09:16:06.473+00	t	f	\N	\N	f
482	26	88061100	88061100 мишээл экспо баруун 84 байр 2 орц 4 дав 81 тоот тор	3	20000.00	ok	3	f	0	CJt74zCP3h	2025-07-05 02:07:24.825+00	2025-07-05 05:54:17.477+00	f	f	\N	\N	f
480	26	89483004	Яармаг.  3р буудал дөнгөж өнгөрөөд  МТ колонкоор  эргээд чигээрээ хойшоо  зам бгаа тийшээ явангуут үзүүр дээр нүхт 1-16 гэсэн гудамж.  557тоот. tor	3	20000.00	ok	3	f	0	TCiVBb6jvf	2025-07-05 02:05:28.16+00	2025-07-05 09:56:47.949+00	f	f	\N	\N	f
172	23	99109105	Офицеруудын ордон тойрог хойшоо яваад баруун талд хаан банктай байран дээр ирээд залгах 	3	39900.00	PK GR	24	t	1	0XIftAKpEM	2025-07-01 12:18:03.336+00	2025-07-05 11:14:26.633+00	f	f	\N	\N	f
173	23	99136474	Натурын голын зам төрийн банкны өөдөөс харсан 38-р байр 5-р орц 168 тоот /оройн цагаар авах/	3	39900.00	GR	24	t	1	iKMWW4uhWZ	2025-07-01 12:18:55.868+00	2025-07-05 11:14:26.633+00	f	f	\N	\N	f
195	16	95737172	их дэлгүүрт	3	15000.00	их дэлгүүр дээр очоод залгах	24	t	1	UiFRbs1jnQ	2025-07-01 16:20:29.393+00	2025-07-05 11:14:26.633+00	f	f	\N	\N	f
164	16	88532353	5 шар сутайн буянт зах Аблок 36 номер	5	15000.00	байхгүй	24	t	1	841hLXBmy5	2025-07-01 08:15:13.9+00	2025-07-05 11:14:26.633+00	f	f	\N	\N	f
183	23	99383890	Nogoon togol 73 r bair 7 dawhar 31 toot	3	84800.00	m1, L8	24	t	1	N0154L86Fz	2025-07-01 12:23:32.889+00	2025-07-05 11:14:26.633+00	f	f	\N	\N	f
1027	58	99766972	Буянт Ухаа-2 автобусны буудал	3	70000.00	Сүүдрэвч шар 3×4.5. 40-р байрны агуулахаас авна. БУ-2-н автобусны буудлаас тосч авах тул хүргэлтээр очихдоо утсаар яриарай.	3	f	0	OfDTTsIV4E	2025-07-23 05:14:30.481+00	2025-07-23 12:36:52.616+00	f	f	2025-07-23 12:36:52.616+00	0	f
1133	59	96009015	Сансарын E mart	3	6000.00	j	14	t	9	YAGzCG7t76	2025-07-24 02:18:14.27+00	2025-07-25 06:15:33.973+00	f	f	2025-07-24 05:18:28.414+00	0	f
735	16	99917253	tengis	5	15000.00	baihgui	9	f	0	KJyxrymqW5	2025-07-07 13:17:01.901+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
1107	10	99996151	100 ail bumbat delguur 31 languu	5	71000.00	erchuudin beldmel milk iol1sh	3	f	0	H1DMa1YBdJ	2025-07-23 09:37:46.249+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1056	10	99109508	BGD 3r khoroo 73/1 bair 15toot 18s hoish 	5	76000.00	uhaalag tsag 	3	f	0	aOLaCxzw3H	2025-07-23 06:56:06.989+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
509	16	94424442	tengis kino teatriin ariun bairand garaad avna	5	15000.00	baihgyi	9	f	0	wlRYehicj4	2025-07-05 05:08:12.905+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
570	26	99245354	99245354 nisehiin toipog are town 302bair 72toot 1opts top	5	19900.00	niseh	24	f	0	ZYy0ShLQNE	2025-07-06 01:22:14.951+00	2025-07-22 04:42:35.541+00	f	f	\N	\N	f
1173	63	99980459	Зүүнхараа руу унаанд тавих	3	60000.00	Зүүнхараа унаанд тавих	9	t	15	IeCpjo9YdZ	2025-07-25 07:40:31.275+00	2025-07-27 05:28:48.894+00	f	t	2025-07-26 08:28:28.214+00	0	f
182	23	89247171	" Шархадны эцэс"	3	54900.00	i8 jijig	24	t	1	fdSnr9V1XD	2025-07-01 12:23:08.237+00	2025-07-05 11:14:26.633+00	f	f	\N	\N	f
511	16	99679281	horoolol gemteliin emnelgiin hajuud 5 davhar nogoon bair 65-97	5	15000.00	baihgyi	9	f	0	AVE2U4yOsf	2025-07-05 05:31:33.93+00	2025-07-06 15:06:48.112+00	f	f	\N	\N	f
533	26	99700758	99700758  Нүхт Sunset хотхон 756 байр 1орц 3давхарт 4тоот код 2749# top	3	20000.00	яармаг нүхт	3	f	0	MTzFbPsZta	2025-07-05 17:15:35.842+00	2025-07-07 14:12:57.273+00	f	f	\N	\N	f
2151	59	80755749	налайх	3	0.00	0	66	f	0	oONUX7dV6C	2025-08-23 16:07:09.667+00	2025-08-25 10:09:15.011+00	f	f	2025-08-25 10:09:15.011+00	margash avna	f
1029	19	80998791	нарантуул захаас явах такси 16 цагын үед явдаг.хэнтийн бэндэр	1	86000.00	төлбөр танайх авна.худалдан авж байгаа хүний  дугаар 80950572	\N	f	0	aolK3lLoci	2025-07-23 05:25:20.597+00	2025-07-23 06:02:25.726+00	f	f	\N	0	t
521	11	80901298	Буянт Ухаа 2 хороолол 1020 12 тоот	3	6000.00	5литртэй шингэн бордоо нэг савыг хүргэж өгөх. Хүргэлт аваагүй.	3	f	0	BM6UG7GSyZ	2025-07-05 09:33:23.106+00	2025-07-06 07:19:11.404+00	f	f	\N	\N	f
2274	71	80658583	bayan ulgii	3	0.00	80110331	50	f	0	GoFFirWEV1	2025-08-25 04:08:56.832+00	2025-08-25 10:47:21.355+00	f	f	2025-08-25 10:47:21.355+00	0	f
531	16	88503215	han uul duureg food city dotor solongos hoolnii gazar	3	15000.00	baihgyi	3	f	0	kAfUXk305L	2025-07-05 16:57:41.422+00	2025-07-06 06:30:33.597+00	f	f	\N	\N	f
972	59	95005453	Нарны хороолол Есөн эрдэнэ хотхон 29/8 4 давхар 19 тоот	3	0.00	хүргэлтийн мөнгөө өөрөөё нь авна	14	f	0	XfKcS0NmSM	2025-07-22 00:45:51.463+00	2025-07-22 13:24:48.659+00	f	f	\N	0	f
526	23	99133594	Схд 1-р хороолол 16-р хороо хар хорин захын хойшоо 41б байр 6 давхарт 38 тоот	3	54900.00	LCh3	3	f	0	tzeuZ0BLWh	2025-07-05 12:41:30.037+00	2025-07-06 11:52:28.409+00	f	f	\N	\N	f
1028	19	80998791	нарантуул захаас явах такси 16 цагын үед явдаг.хэнтийн бэндэр	5	86000.00	төлбөр танайх авна.худалдан авж байгаа хүний  дугаар 80950572	14	f	0	lfeOILr9v2	2025-07-23 05:25:20.412+00	2025-07-29 05:19:54.512+00	f	f	\N	utsa awagu	f
512	16	99157585	ofitserudin ordongiin zuun tald well marttai nogoon bair 34-4 toot	3	15000.00	baihgyi	14	f	0	AphyCDvX5w	2025-07-05 05:34:07.352+00	2025-07-06 10:42:59.951+00	f	f	\N	\N	f
1977	71	95509591	Zamiin vvd	3	6000.00	unaa	73	f	0	NkoKP8R6A5	2025-08-22 00:46:48.172+00	2025-08-22 07:53:25.065+00	f	f	2025-08-22 07:53:25.065+00	0	f
518	16	89535340	25r emiin sangiin ard 12 davhar nogoon bair 71 a bair 4 davhart 29 toot	5	15000.00	baihgyi	9	f	0	IU86JPiuIw	2025-07-05 06:02:53.252+00	2025-07-06 08:05:03.656+00	f	f	\N	\N	f
1981	71	90787247	Govisumber	3	6000.00	narantuulaas	14	f	0	UbSeEXOs1H	2025-08-22 01:00:51.184+00	2025-08-22 09:23:56.392+00	f	f	2025-08-22 09:23:56.392+00	0	f
556	26	99024881	99024881 1 р хороолол 10 байр 87 тоот тор	3	19900.00	1 horoolol	9	f	0	CIRKPiqqZA	2025-07-06 00:39:23.831+00	2025-07-06 11:37:32.771+00	f	f	\N	\N	f
516	16	99918391	zamiin uudiin unaand tavina	3	15000.00	baihgyi	9	f	0	38wZcq017O	2025-07-05 05:53:31.136+00	2025-07-06 13:05:44.731+00	f	f	\N	\N	f
517	16	88100714	BZD bayan mongoliin hajuud emerald hothon 505r bair 401 toot	3	15000.00	baihgyi	14	f	0	4tOMjCXJ5Z	2025-07-05 05:55:27.278+00	2025-07-07 14:22:01.262+00	f	f	\N	\N	f
1030	19	80998791	нарантуул захаас явах такси 16 цагын үед явдаг.хэнтийн бэндэр	1	86000.00	төлбөр танайх авна.худалдан авж байгаа хүний  дугаар 80950572	\N	f	0	ZmRM8uJFpR	2025-07-23 05:25:21.578+00	2025-07-23 06:02:25.726+00	f	f	\N	0	t
534	26	96062370	96062370 yarmag 1 buudal ct palace yag ariin nogoon deedsiin urgoo bairand ochood zalgah tor	3	20000.00	яармаг	3	f	0	MV4C5qzmBz	2025-07-05 17:16:12.741+00	2025-07-07 13:28:10.149+00	f	f	\N	\N	f
515	16	94387676	5r surguuliin hajuud 43 r bair 4 r orts 56 toot	3	15000.00	baihgyi	9	f	0	gBmSkdLQ3q	2025-07-05 05:50:30.404+00	2025-07-06 06:51:11.576+00	f	f	\N	\N	f
625	16	88113233	9r delguur esvel 100 ailiin. jobi d avna	3	15000.00	baihgyi	14	f	0	gFr1GVQ8WH	2025-07-06 04:00:41.016+00	2025-07-06 05:27:36.683+00	f	f	\N	\N	f
524	23	99384449	хан уул дүүрэг яармаг happy residence 881-r bair 2-r otrs 7 toot	3	59900.00	i7 tom 	3	f	0	gvoq3C5PTk	2025-07-05 12:40:44.728+00	2025-07-06 06:21:48.164+00	f	f	\N	\N	f
363	26	89068050	100 айл атлас төв подвол с6 лангуу тор	3	28000.00	ок	14	f	0	QsJoGnFMy4	2025-07-04 00:54:08.602+00	2025-07-06 04:14:15.114+00	f	f	\N	\N	f
609	26	99761540	99761540 hanuul 3hopoo govi huvitsaat company der awna top	3	19900.00	худүүрэг	3	f	0	wEraH8EfbJ	2025-07-06 02:11:54.525+00	2025-07-07 07:10:13.497+00	f	f	\N	\N	f
523	18	91221103	Сансарын Е март хэргэлэгчийн үйлчилгээний төв	3	36000.00	Хар топ	14	f	0	2nOUyhrOG6	2025-07-05 11:27:34.147+00	2025-07-06 05:53:06.463+00	f	f	\N	\N	f
572	26	86058612	86058612 nisehiin yngir duhuud zalgh tsaanaas ipj awna top	3	19900.00	niseh	3	f	0	jYPFcLTrPz	2025-07-06 01:29:34.559+00	2025-07-07 15:42:41.913+00	f	f	\N	\N	f
627	16	88942739	zavhan uliastai unaand tavih	5	15000.00	baihgyi	24	f	0	mztVfCRVuN	2025-07-06 04:01:37.524+00	2025-07-07 05:29:53.137+00	f	f	\N	\N	f
542	26	91997099	91997090 Bgd 1 horoolok tsamba urd unur horoolol 45a bair 77 toot tor	5	20000.00	1-р хороолол	9	f	0	sGivn85vki	2025-07-05 17:28:05.298+00	2025-07-06 13:13:03.272+00	f	f	\N	\N	f
2301	77	96800207 	Замын-Үүд	2	0.00	tolbor batalgaajsan 	9	f	0	3pIM3m3rsB	2025-08-25 13:35:59.666+00	2025-08-26 05:10:35.085+00	t	t	\N	0	f
557	26	95459031	95459031 sonsgolongiin monos emiim uildwer der tor	5	19900.00	sonsgolon	24	f	0	3FAoYLKFit	2025-07-06 00:41:54.692+00	2025-07-06 17:46:26.255+00	f	f	\N	\N	f
1001	20	86041378	ХУД, 25-р хороо, 4 бэрх хотхон 424-31	3	6000.00	төлбөр авахгүй	3	f	0	3pXvSCi7Uu	2025-07-23 00:13:56.296+00	2025-07-23 12:26:50.811+00	f	f	2025-07-23 12:26:50.811+00	0	f
1655	4	99042055	Сэлэнгэ унаанд	3	1.00	.	9	f	0	DmeqWNLQgq	2025-08-13 16:13:06.889+00	2025-08-14 05:13:41.066+00	f	f	2025-08-14 05:13:41.066+00	0	f
859	2	95273308	Баянзүрх дүүрэг 23р хороо сургуулийн 3р гудамж 1247 тоот	5	450000.00	20Л төлбөр авах! дөхөөд залгахаар өөрсдөө гарч ирээд авна	9	f	0	fTuHM8J2NV	2025-07-09 12:47:16.994+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
1708	59	99689957	гэмтэлийн буудал өнгөрөөд сайн ломбард өгсөөд 606 худаг 	3	6000.00	ирэхээсээ өмнө залгах	69	f	0	8G2OeljVfc	2025-08-14 09:43:03.811+00	2025-08-15 07:38:31.774+00	f	f	2025-08-15 07:38:31.773+00	0	f
1715	59	86862804	ХУД уяаачдын гудам 4-13	3	0.00	ирэхээсээ өмнө залгах	68	f	0	7GQYm1fFcB	2025-08-14 11:33:37.819+00	2025-08-15 09:42:22.194+00	f	f	2025-08-15 09:42:22.194+00	0	f
1871	6	80319119	Rapid	3	0.00	O	9	f	0	IU8sxsqPT5	2025-08-18 13:39:28.08+00	2025-08-18 14:11:06.225+00	t	f	2025-08-18 14:11:06.225+00	0	f
2090	71	88077051	umnu gobi tsogtsetsii	3	0.00	unuudur	50	f	0	RR9mtUbJM8	2025-08-23 05:59:19.145+00	2025-08-23 11:13:14.744+00	t	f	2025-08-23 11:13:14.744+00	0	f
2182	71	96644183	Hentii bor undur	3	0.00	.	9	f	0	di4dA7ZVXO	2025-08-24 04:21:19.251+00	2025-08-24 06:45:08.078+00	f	f	2025-08-24 06:45:08.078+00	0	f
623	6	96111398	govi sumberin unaand tawih	3	0.00	onoodor	14	f	0	UUq5Dt933B	2025-07-06 03:58:55.99+00	2025-07-07 05:56:25.661+00	t	f	\N	\N	f
541	26	80726665	1-р хороолол 11-р байр 4-р орц. Утас 80726665 top	3	20000.00	1 -р хороолол	9	f	0	XYx4AFcz3J	2025-07-05 17:27:25.269+00	2025-07-06 11:17:17.339+00	f	f	\N	\N	f
544	10	86083839	tow shuudan hoino smart phone gj 2 dawhar barilga bga	3	20000.00	ogloo 10 tsagas ajil ongon	3	f	0	K4WkBY4nBv	2025-07-05 18:00:01.728+00	2025-07-06 06:03:33.669+00	f	f	\N	\N	f
620	16	96997557	13 r horoolol 84r surguuliin urd 12 r bair	3	15000.00	baihgyi	14	f	0	TFuGAGTFwg	2025-07-06 03:45:45.513+00	2025-07-06 08:52:14.307+00	f	f	\N	\N	f
522	18	88096134	батлан хамгаалах яам	3	46000.00	цэнхэр өмд	14	f	0	ayeA9tVJaT	2025-07-05 11:23:18.018+00	2025-07-06 10:23:00.565+00	f	f	\N	\N	f
2302	77	95098686 	narantuul zah orogtgol bayn olgii giin 	2	18000.00	mashiin deer avna 	66	f	0	JgqINnnRIk	2025-08-25 13:36:53.594+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2356	52	88023661	HanUuliin Tawanbogdiin hajud Anun tawilgiin delgvvrt	2	6000.00	Gada garad Wna	78	f	0	Xj5940QiGG	2025-08-25 17:55:45.089+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
539	26	96037497	96037494 5 shariin 15 bair 48 toot 4 orts tor	5	20000.00	схд	24	f	0	X1AmQjv98f	2025-07-05 17:21:16.184+00	2025-07-07 06:53:59.35+00	f	f	\N	\N	f
1031	19	80998791	нарантуул захаас явах такси 16 цагын үед явдаг.хэнтийн бэндэр	1	86000.00	төлбөр танайх авна.худалдан авж байгаа хүний  дугаар 80950572	\N	f	0	1cm0yGD0p5	2025-07-23 05:25:21.914+00	2025-07-23 06:02:25.726+00	f	f	\N	0	t
1002	20	89020911	Хүннү 2222, 220 байр	3	6000.00	төлбөр авахгүй	65	f	0	GQRqaGVpcd	2025-07-23 00:14:24.085+00	2025-07-23 11:53:57.881+00	f	f	2025-07-23 11:53:57.881+00	0	f
630	16	89820345	ih mandal hothon 53/2 6 davhart 23 toot, orts kod #123456#	3	15000.00	baihgyi	14	f	0	7HTuZIvCpd	2025-07-06 04:04:39.498+00	2025-07-07 14:42:17.467+00	f	f	\N	\N	f
535	26	99637815	99637815 cxd 8 horoo баянхошуу jantsan buudal urd 1 tsegiin uilchilgeeruu 65 surguuliin urduur ugsuul uragsh ergeed bulgan delguur dagad orohod bayantsagaan 4- 33 toot tor	3	20000.00	баянхошуу	9	f	0	FY8wVZVHhq	2025-07-05 17:16:47.274+00	2025-07-09 07:30:24.234+00	f	f	2025-07-09 07:30:24.234+00	\N	f
411	17	99090428	нисэх мянган зоог хоолны газарт	3	620000.00	4ш 400ватт улаан хайрцагтай	3	f	0	8nBHawlQ7N	2025-07-04 06:00:16.981+00	2025-07-06 06:58:31.305+00	f	f	\N	\N	f
654	23	99066062	HUD 3r horoo Hos urguu 29b 42	3	59900.00	i7 tom 	3	f	0	LfFJPwt6kb	2025-07-06 12:45:42.333+00	2025-07-07 09:49:04.564+00	f	f	\N	\N	f
658	23	88943058	бзд 22хороо telmu apartment 11давхар 51тоот	3	54900.00	Lch1	14	f	0	Ubm7zINk1B	2025-07-06 12:47:11.332+00	2025-07-07 13:29:10.261+00	f	f	\N	\N	f
652	23	95630222	Яармаг нүхт ам шүншиг 3 хотхон 243-р байр 88 тоот /18 цагаас хойш авах/ 	3	84800.00	GR, m4	3	f	0	ctGlrKiX7e	2025-07-06 12:44:51.633+00	2025-07-07 14:12:04.945+00	f	f	\N	\N	f
655	23	88932509	Шар хад дах хүрээ зах	3	49900.00	g44 tom 	14	f	0	noPU8k0ljR	2025-07-06 12:46:04.888+00	2025-07-07 12:03:23.094+00	f	f	\N	\N	f
643	21	80028383	BZD 16 horoo OFITSER town 2 402 toot	3	0.00	solo-d	14	f	0	rhOszSIYwx	2025-07-06 08:35:09.764+00	2025-07-07 10:23:37.485+00	t	f	\N	\N	f
536	26	99896330	99896330 zaisan bogdiin muzein urd 3 orgil hothon 62 bair 2 orts 2 dawhar 32 toot kod 32b tor	3	20000.00	зайсан оргил	3	f	0	IS7GiQVYil	2025-07-05 17:17:25.598+00	2025-07-07 08:45:58.546+00	f	f	\N	\N	f
649	4	80038074	Зайсан Nomuun Village 100/7 1 орц 5 давхар 27	3	1.00	.	3	f	0	JfDloykjMT	2025-07-06 12:12:46.598+00	2025-07-07 08:46:40.241+00	f	f	\N	\N	f
640	4	99029950	Сансар 97р сургуулийн яг ард 42р байр 8орц 2 давхар 114тоот	3	1.00	.	14	f	0	OWBrsRpAe9	2025-07-06 08:22:09.668+00	2025-07-07 12:41:22.015+00	f	f	\N	\N	f
719	48	88064537	narnii horoolol	3	1000.00	etet	3	f	0	QJ7OjqIzP6	2025-07-07 12:16:04.723+00	2025-07-07 16:15:21.604+00	f	f	2025-07-07 16:15:21.603+00	\N	f
540	26	88180539	88180539 niseh sport ordon ard ulaantai saaral baishin 226 bair duhuud zalgah хажууд нь ажиллаж байгаа 86221895 2 dugartai	3	20000.00	нисэх	24	f	0	vMJuUaWgqF	2025-07-05 17:22:33.079+00	2025-07-08 12:08:38.905+00	f	f	2025-07-08 12:08:38.905+00	\N	f
1057	10	99176264	BGD altai hothon 50g 52 toot 20s hoish 	3	99000.00	hvzvvnii zvvlt 	65	f	0	Hyp1h2qZrP	2025-07-23 06:57:22.709+00	2025-07-23 09:59:23.268+00	f	f	2025-07-23 09:59:23.268+00	0	f
1108	10	99091481	shd 8horoo bagshiin deed sonor plaaza 801 toot	5	55000.00	zowhnii tos 2sh	3	f	0	ozWDobgskF	2025-07-23 09:39:38.991+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1134	59	95680207	БГД 4-р хороо 12 байр 2 давхар 4 тоот	3	6000.00	ж	9	t	11	7WkLJzL55v	2025-07-24 02:19:26.19+00	2025-07-25 06:17:06.424+00	f	f	2025-07-24 05:46:42.464+00	0	f
1240	63	89913747	dornod aimag 	5	60000.00	dornod aimag 	67	f	0	Qq0jYUYYft	2025-07-28 02:12:56.702+00	2025-07-30 14:54:02.915+00	f	t	\N	унаанд тавьж өгөх гэсэн боловч төлбөрөө шилжүүлээгүй тул бараагаа өгч явуулаагүй 10-с дээш удаа залгасан олон мсж бичсэн	f
1218	6	88970760	10r horoolol my town 113r bair 1r orts 8 davhar 47 toot code 1719#	3	0.00	96016851	14	f	0	cwGQG8fUba	2025-07-27 04:41:49.388+00	2025-07-27 09:50:18.464+00	t	f	2025-07-27 09:50:18.464+00	0	f
1024	17	88855665	шинэ Баянгол оношлогооны төв	5	195000.00	1ш камэр	9	f	0	Ul1G6XENEN	2025-07-23 03:52:37.029+00	2025-07-29 04:57:45.966+00	f	f	\N	0	f
1155	63	94464226	baruunharaa 95951685	5	60000.00	 	9	f	0	mh7scD5k1C	2025-07-25 01:47:33.48+00	2025-07-29 04:57:45.966+00	f	t	\N	0	f
1273	59	94142050	СБД 9 р хороо 213 байр 42 тоот 	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	gWjXgJohHH	2025-07-28 15:22:28.48+00	2025-07-29 09:23:56.921+00	f	f	2025-07-29 09:23:56.921+00	0	f
1175	63	89891619	Svljmeliin vildwerin Zolt hudaldaanii tow 2dawhar 13toot 	5	110000.00	irehdee yrih	9	f	0	jIDykeBP2n	2025-07-25 07:46:52.286+00	2025-07-29 04:57:45.966+00	f	f	\N	0	f
1243	63	94052333	Baruun 4zam Shihihutug ih surgiin hajuudah  5r bair 1r orts 1dawhar 3toot	5	60000.00	  	9	f	0	cPx0JkkzHx	2025-07-28 02:28:54.524+00	2025-07-29 04:57:45.966+00	f	f	\N	0	f
1174	63	97009708	29r horoo selbiin 25r gudam 643 toot 	5	60000.00	  	14	f	0	OlFYeHRfGR	2025-07-25 07:42:54.072+00	2025-07-29 04:59:48.045+00	f	f	\N	tsutsalsan	f
1272	21	99055790	yarmag Artsat-2 hothon 1430 bair 11dav 42 toot	3	0.00	odkoo-d. orts kodgui	3	f	0	ADuo8wuxo3	2025-07-28 13:40:53.538+00	2025-07-29 12:32:41.912+00	t	f	2025-07-29 12:32:41.911+00	0	f
1257	61	88136458	Схд 26 р хороо мандал  овооны  21 1 тоот	3	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	24	f	0	OUwxSfHs7a	2025-07-28 06:45:40.557+00	2025-07-29 09:29:36.661+00	t	f	2025-07-29 09:29:36.661+00	0	f
1307	63	99355732	эрин хороолол 56-6 байр 16тоот	5	60000.00	  	3	f	0	h0x2e4Qaxd	2025-07-29 06:44:50.82+00	2025-07-30 14:57:27.79+00	f	f	\N	bolison	f
1506	10	hsjsjh	jshsh	5	111.00	xxx	9	f	0	zRKrCWkFWo	2025-08-07 08:15:26.614+00	2025-08-07 08:16:52.423+00	f	f	\N	0	f
1556	10	8888	jofyjnv	5	60000.00	giccj	3	f	0	4cPXeWFAeW	2025-08-09 06:24:59.984+00	2025-08-11 01:15:32.771+00	f	f	\N	0	f
660	23	99707831	Баян бүрд хороолол 417 р байр 2 р орц 13 ын 198 тоот	3	39900.00	g8	14	f	0	VGukqarZYL	2025-07-06 12:47:54.256+00	2025-07-07 14:30:19.453+00	f	f	\N	\N	f
656	23	94652001	Бзд 4-р хороо 9р байр /оройн цагаар авах/	3	89800.00	m2, m6	14	f	0	kkTppQHuXD	2025-07-06 12:46:25.279+00	2025-07-07 14:58:03.48+00	f	f	\N	\N	f
661	23	90708000	ХУД 24-р хороо Богд виста хотхон 16-1605 тоот 	3	49900.00	g9 tom 	3	f	0	lIkq7Q7xLY	2025-07-06 12:48:15.831+00	2025-07-07 12:43:30.309+00	f	f	\N	\N	f
638	16	80110446	Tsaiz 16  sky residence hothon 192/b 14 iin 150	3	15000.00	ochihdoo hunruu ni zalgah	14	f	0	MVLxZ53CgE	2025-07-06 05:51:38.316+00	2025-07-07 11:16:00.118+00	f	f	\N	\N	f
645	21	88823931	HUD 21 horoo nisehiin toirog unguruud Buman zaluus horoolol 202 bair 16-147 toot.	3	0.00	kod 2580#  sainaa-d	3	f	0	eXpC7jnnBY	2025-07-06 09:27:28.76+00	2025-07-07 08:47:46.871+00	t	f	\N	\N	f
644	21	99922869	sansar KTMS-n hajuud Tsagdaa hothon 13/7 bair 1 orts 19 toot	3	0.00	Dolgorsuren-d	14	f	0	OkLK3TkvL8	2025-07-06 08:36:34.945+00	2025-07-07 12:54:43.254+00	t	f	\N	\N	f
636	16	95111016	SHD 19 r horoo uildverchnii evleliin gudamj mt kolonk	3	15000.00	baihgyi	24	f	0	0Xf21dHDJZ	2025-07-06 05:42:36.926+00	2025-07-07 06:50:28.634+00	f	f	\N	\N	f
637	16	99036921	BZD 43 horoo 101 r bair Amartuvshin hothon 3 r orts 12 davhar 221 toot	3	15000.00	baihgyi	14	f	0	WpVmaRWOJK	2025-07-06 05:43:41.633+00	2025-07-07 08:13:13.694+00	f	f	\N	\N	f
651	4	99098214	Зайсан эцэст Зайсан Лакшери вилла 2байр 17 тоот	3	1.00	.	3	f	0	oFmfoFiipi	2025-07-06 12:15:31.244+00	2025-07-07 08:48:11.09+00	f	f	\N	\N	f
639	4	99152552	Зайсан ХААИС ын төв сургуулийн баруун талын 45р байр, хойшоо харсан 1 орцтой, 6 давхар 32 тоот	3	1.00	.	3	f	0	7WspSWwAw8	2025-07-06 08:18:31.174+00	2025-07-07 08:48:33.167+00	f	f	\N	\N	f
642	4	88997221	Сансар 805р цэргийн ангийн урд 40/3 байр 8давхар 31тоот орц код 31в	3	1.00	.	14	f	0	7hbgDoo3qr	2025-07-06 08:28:29.069+00	2025-07-07 13:02:24.283+00	f	f	\N	\N	f
1003	17	99202929	Төв аймгийн төв унаанд	3	195000.00	1ш камэр	3	f	0	MR4FMbpkTz	2025-07-23 01:02:33.982+00	2025-07-23 11:38:41.854+00	f	f	2025-07-23 11:38:41.854+00	0	f
675	26	99173399	99173399 altai hothon 18 bair 1 orts 3 daw 18 toot tor	3	19900.00	худ	3	f	0	hTxWfI7Uc8	2025-07-06 15:37:30.114+00	2025-07-07 07:11:42.591+00	f	f	\N	\N	f
676	26	89697576	89697576 gurwaljin guur dawaad suuri kompani mongol tamhi co unguruud altai hothon takruuga yawahar baidag tor	3	19900.00	гурвалжин урагш	3	f	0	LSX2GzEvCr	2025-07-06 15:38:13.732+00	2025-07-07 07:12:10.435+00	f	f	\N	\N	f
682	16	99017543	altai hothon	3	15000.00	1 odor awna gsen	3	f	0	fOWSHunxzp	2025-07-06 17:20:53.49+00	2025-07-07 07:12:48.274+00	f	f	\N	\N	f
666	26	91119288	91119288 govi cashmarn baruun tald delgereh hothon naranmamdal emneleg dee top	3	19900.00	худ	3	f	0	3OXVaE2WPR	2025-07-06 15:30:59.011+00	2025-07-07 08:44:40.388+00	f	f	\N	\N	f
678	26	93096566	93096566 hud 18 horoon deer ajilladag ajliin tsagar orgil rashaan suwilal ard baidag tor 2 mashind	3	39800.00	hud	3	f	0	0NavjGhUNk	2025-07-06 15:40:12.889+00	2025-07-07 08:47:25.394+00	f	f	\N	\N	f
677	26	88032652	88032652 hud lavai zahiin unguruud zam zaswar hiij bga hun ochihdoo 88222429 dugaar holbogdood zaalgad ochoorou gene tor	3	19900.00	худ	3	f	0	drSw5r8h4w	2025-07-06 15:38:55.128+00	2025-07-07 08:50:56.762+00	f	f	\N	\N	f
674	26	80630715	80630715 hud zamiin ard 20 dugar bair ochood zalgah ajliin tsagaar !!! Tor	3	19900.00	худ	3	f	0	YSzq3yNe27	2025-07-06 15:37:00.844+00	2025-07-07 10:20:42.471+00	f	f	\N	\N	f
668	26	91929055	91929055 hanuul 19hopoo dul hothonii urd 95 bair 2opts 3 daw 303toot top	3	19900.00	худ	3	f	0	tPKaCzzZPr	2025-07-06 15:32:17.316+00	2025-07-07 10:21:25.78+00	f	f	\N	\N	f
679	26	99319378	99319378 yaarmag hanbogd horolol 408 bair 2 orts 5 dawhar 86 toot kod 86b tor	3	19900.00	yaarmag	3	f	0	AWi8fGKQGM	2025-07-06 15:40:46.945+00	2025-07-07 12:44:19.416+00	f	f	\N	\N	f
664	26	99570180	99570180 89460180 hanuul hanbogd hothon 202toot 2opts 72toot  top	3	19900.00	hud yaarmag 2 dugaraa ugsun shu	3	f	0	WswnHSlWXp	2025-07-06 15:29:14.802+00	2025-07-07 12:44:58.495+00	f	f	\N	\N	f
681	26	88184226	88184226 yarmag viva city n2 3-2 toot tor	3	19900.00	яармаг	3	f	0	PKXX1du97C	2025-07-06 15:42:12.259+00	2025-07-07 13:27:22.848+00	f	f	\N	\N	f
618	26	88050026	88050026 Hanuul 4 horoo yarmag 1 buudal alt 8-345 toot. Zalgarai tor	3	19900.00	yaarmag	3	f	0	9zl2dwZxzq	2025-07-06 02:36:57.311+00	2025-07-07 15:11:09.203+00	f	f	\N	\N	f
673	26	88898391	88898391 гурвалжин даваад тесо компань дээр тор	3	19900.00	гурвалжин урагш	3	f	0	OzjsXYMaH2	2025-07-06 15:36:20.593+00	2025-07-07 15:11:59.928+00	f	f	\N	\N	f
680	26	89980412	89980412 yaarmagiin orgil hudaldaani tow baruun zasmalaar hoish ywaad sonsgolongiin 11-427 tootod tor	3	19900.00	яармаг	3	f	0	CpsbNavx4L	2025-07-06 15:41:20.614+00	2025-07-07 15:13:35.158+00	f	f	\N	\N	f
669	26	94852868	94852868  yaarmag huuchin etses Ulziit buuniitow der awna top	3	19900.00	яармаг	3	f	0	FCRTByfemf	2025-07-06 15:32:55.989+00	2025-07-07 15:14:18.267+00	f	f	\N	\N	f
2357	52	99034350	Zaisan Amerik surguliin esreg tald Moritom residenece 2 orts 5-521 toot	2	6000.00	n	78	f	0	7FW6oIhOWl	2025-08-25 17:56:29.931+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
662	23	89965958	Нисэх тойрог Миний маркет дотор Агар фармд авах /эртхэн авах/	3	49900.00	g41 tom 	3	f	0	eaQUfazo8E	2025-07-06 12:48:38.618+00	2025-07-07 02:29:32.877+00	f	f	\N	\N	f
700	16	89995732	huuchin dragonoos Tsetsiiruu tavih	3	15000.00	baihgyi	24	f	0	PodY13Fim9	2025-07-07 03:56:48.146+00	2025-07-07 07:21:01.111+00	f	f	\N	\N	f
1083	10	99292067	BGD 31r horoo 55b bair 6 davhar 34 toot 96052067	3	55000.00	zowhinii tos 2 shirheg	9	t	10	sB0WYXl9Ys	2025-07-23 08:18:38.912+00	2025-07-25 06:16:46.596+00	f	f	2025-07-23 10:41:07.361+00	0	f
2303	77	99167753 	  zuun salaa huucin etsesiin buudal 	2	18000.00	5tsagaas hoish 	9	f	0	iPOH3P5Xz9	2025-08-25 13:37:35.217+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
1817	61	99995490	Eko hothon 23iin 5toot	3	29900.00	тооцоо хийгээгүй	73	f	0	Uq5B0byvEF	2025-08-17 01:59:18.312+00	2025-08-22 18:00:08.602+00	f	f	2025-08-22 18:00:08.602+00		f
614	26	80598809	80598809 yaarmag sportiin ordonii urd tald  iped zalgh huduunii hvn bga garj iped awna  top 2sh	3	39800.00	яармаг 2 машинд	24	f	0	tcbfNf73LH	2025-07-06 02:15:12.944+00	2025-07-08 09:53:17.854+00	f	f	2025-07-08 09:53:17.854+00	\N	f
1135	59	95005453	Нарны хороолол Ёсөн эрдэнэ хотхон 29/8 4 давхар 19 тоот код:0102#	3	6000.00	ж	9	t	11	WW6r45WpD4	2025-07-24 02:20:38.338+00	2025-07-25 06:17:06.424+00	f	f	2025-07-24 08:03:41.624+00	0	f
1109	10	96568188	shd 10horoo 42/5 toot	5	45000.00	shudnii tsatslaga 1sh	3	f	0	2JNi6F1g0k	2025-07-23 09:41:39.467+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1058	10	99088435	horoolol 15r bair ard tusdaa 1 davhar baishin 	3	68000.00	erchvvdiin beldmel lengsu 	14	t	8	vBJScGWD0Z	2025-07-23 06:58:19.916+00	2025-07-25 06:15:20.103+00	f	f	2025-07-23 11:30:46.867+00	0	f
1258	59	99971057	СХД  төв эмнэлэг 	3	6000.00	8 цагас өмнө очино 	24	f	0	211zmppQtG	2025-07-28 07:34:17.042+00	2025-07-29 07:27:09.517+00	f	f	2025-07-29 07:27:09.517+00	0	f
634	19	99833224	Emerald residence 501r bair 3orts 207. Ortsnii uudend ireed zalgachhuuu	5	86000.00	төлбөр  танайх	9	f	0	n63jJF1ogD	2025-07-06 05:21:26.085+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
698	16	99166272	dragon deer teeshind uguh	5	15000.00	baihgyi	24	f	0	dYHiL8z9Om	2025-07-07 03:55:09.664+00	2025-07-07 11:35:47.509+00	f	f	\N	\N	f
1084	10	99099198	BGD 5r horoo Ulsiin 3r emnelegiin hushuutei tuw haalganii derged GR tuw 4 davhar 402 toot 801198989	3	129000.00	undur bolgodog naalt	9	t	10	EKXkNTnFsu	2025-07-23 08:28:13.941+00	2025-07-25 06:16:46.596+00	f	f	2025-07-23 12:17:36.84+00	0	f
671	26	94492538	94492538 Hunnu mall baruu shine orgoo horoolol 627 bair 5 d 37 toot ezgui baiwal yag uudus harsan dekguurt ukdeelgene tor	3	19900.00	яармаг	3	f	0	49NTmfaqCZ	2025-07-06 15:34:21.43+00	2025-07-07 13:13:30.473+00	f	f	\N	\N	f
696	16	91017172	hal uul duureg 19r horoo Dul hothon 97a bair 58 toot	3	15000.00	baihgyi	3	f	0	TvOFJwwaaV	2025-07-07 03:53:53.059+00	2025-07-07 07:59:54.078+00	f	f	\N	\N	f
2358	52	99463686	Naturiin Selbe hothon 97/3 bair 4 toot	2	6000.00	n	66	f	0	CY1vxUsEZb	2025-08-25 17:57:09.867+00	2025-08-26 04:40:43.104+00	f	f	\N	0	f
716	4	88054203	ХАР ХОРИН зах	3	20000.00	тооцоотой	8	f	0	Pgg4M8nMl5	2025-07-07 07:49:22.63+00	2025-07-09 10:24:48.174+00	f	f	2025-07-09 10:24:48.174+00	\N	f
711	16	99021436	hangai hothon 535 14/66 toot	3	15000.00	baihgyi	14	f	0	nb14oZ1x05	2025-07-07 06:03:20.817+00	2025-07-09 10:25:52.011+00	f	f	2025-07-09 10:25:52.011+00	\N	f
1198	10	95118685	3-4 horoolol mongolmed emlegin hajuud zunii suwlald 606 toot	3	25000.00	har beh	9	t	15	JB3paIhxzD	2025-07-26 05:51:13.719+00	2025-07-27 05:28:48.894+00	f	f	2025-07-26 09:15:22.619+00	0	f
701	16	96207745	yarmagiin shine etsestiin buudald	3	15000.00	baihgyi	3	f	0	biBUUt2anJ	2025-07-07 03:57:33.819+00	2025-07-07 15:11:37.977+00	f	f	\N	\N	f
1032	19	80998791	нарантуул захаас явах такси 16 цагын үед явдаг.хэнтийн бэндэр	1	86000.00	төлбөр танайх авна.худалдан авж байгаа хүний  дугаар 80950572	\N	f	0	AoRjNlwkEs	2025-07-23 05:25:22.083+00	2025-07-23 06:02:25.726+00	f	f	\N	0	t
694	6	99057672	altai hothon 20bair 52 toot	3	0.00	h	3	f	0	2X0PHvKpwI	2025-07-07 03:14:38.942+00	2025-07-07 06:11:44.395+00	t	f	\N	\N	f
647	18	80289682	Han-uul home plaza baruun tald buti town 108 r bair 63 toot	3	46000.00	umd	14	f	0	LF2Hs0Aaps	2025-07-06 11:53:23.285+00	2025-07-07 06:56:48.549+00	f	f	\N	\N	f
683	26	88000561	88000561 алтай хотхон урд жижиг гүүрний урд автобус 1 ийн яг баруун хашаа пепси ундааны үйлдвэр ажлын цагаар тор	3	19900.00	hud	3	f	0	BHYnRcz3KJ	2025-07-07 00:29:42.495+00	2025-07-07 07:13:33.058+00	f	f	\N	\N	f
672	26	99908932	99908932 нисэх 25 хороо хүрээ хотхон 301 байр 26 тоот 7 давхарт. Очоод залгаарай эзгүй бол дэлгүүрт үлдээлгэнэ тор	3	19900.00	нисэх	3	f	0	szV9HsELA0	2025-07-06 15:35:05.132+00	2025-07-07 15:13:03.865+00	f	f	\N	\N	f
648	18	91900602	13-iin dund zam natur hudaldaanii tuviinhuu baruun talaar uragshaa orood selbe hothon 97.2r bair 1ortstoi 6n davhart 32toot ortsnii kod_1122#  91900602	3	36000.00	top tsenher	14	f	0	JV8s7ip9Vk	2025-07-06 11:54:12.557+00	2025-07-07 08:49:18.625+00	f	f	\N	\N	f
699	16	97114799	dragon deeres uvsiin unaand tavina	3	15000.00	baihgyi	24	f	0	gN44iHZUqK	2025-07-07 03:55:38.074+00	2025-07-07 10:18:54.071+00	f	f	\N	\N	f
670	26	99091994	99091994 Naadam center hajuudah khan tower 1 davhart ажлын цагаар!!! Тор	3	19900.00	худ	3	f	0	eIWSMHVhea	2025-07-06 15:33:35.552+00	2025-07-07 10:21:54.627+00	f	f	\N	\N	f
2304	77	89075790 	9tsag hurtel zaisan 	2	20000.00	hoily nomads resturant 	78	f	0	fR5DX0ybEk	2025-08-25 13:38:25.403+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
706	17	99373779	баруун хараа Баянголын гүүр	3	195000.00	1ш камэр	24	f	0	DH0zU5khNV	2025-07-07 05:31:43.277+00	2025-07-07 06:50:08.166+00	f	f	\N	\N	f
689	26	90011668	90011668 altai hothonii baruun tald toyo town baruun hashaa nogoon sendwichen hashaa 3 tsagaas hoish ochson baina gene tor	3	19900.00	hud	3	f	0	mdoXAN6vZ7	2025-07-07 01:26:05.302+00	2025-07-07 10:22:29.843+00	f	f	\N	\N	f
688	26	99146332	99146332 нарны хороолол 6байр 14 тоот өдөр хүнгүй байна оройн цагаар авах тор эзгүй үед очвол 5 дугаар байрны эмийн сэнд үлдээж болно	3	19900.00	hud	3	f	0	7tBa6yYQx6	2025-07-07 01:23:38.689+00	2025-07-07 10:35:44.767+00	f	f	\N	\N	f
1156	4	99121666	3р хороо, Циркийн хажууд Төгөлдөр 12 байр 2 орц 4 давхар 37тоот	3	1.00	.	9	f	0	Y7xm5OtRDs	2025-07-25 02:25:37.359+00	2025-07-25 11:49:09.11+00	f	f	2025-07-25 11:49:09.11+00	0	f
973	59	95782010	СХД 8-р хороо 52-р байр 3 давхар 15 тоот	3	0.00	хүргэлтийн мөнгө авна	14	t	7	jrOwa4J15m	2025-07-22 00:46:58.242+00	2025-07-25 06:14:48.825+00	f	f	2025-07-22 10:52:16.799+00	0	f
1110	10	88845918	ulsiin ih delguur 	5	51000.00	eemeg	3	f	0	c2R9ZYh6FG	2025-07-23 09:42:26.091+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1059	10	95921573	BGD tsambagarav onor hothon 45a bair 128 toot 29r horoo 8 tsagiin vyd  oroi 	5	64000.00	buguin tsag 	3	f	0	VgHL432j6E	2025-07-23 06:59:42.502+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1136	59	96069599	БГД хороололын эцэс Talts auto угаалга	3	6000.00	ж	9	f	0	i595VAbMC0	2025-07-24 02:24:40.11+00	2025-07-25 11:05:52.962+00	f	f	2025-07-25 11:05:52.962+00	0	f
663	4	80017511	Энхтайваны гүүрний баруун дор Vista office 09:00-18:00	5	1.00	09:00-18:00 ажлын цагаар	9	f	0	qQXoBzmmZk	2025-07-06 13:07:43.788+00	2025-07-22 04:44:21.816+00	f	f	2025-07-09 07:34:37.561+00	\N	f
684	26	91160066	91160066 нисэх 4 бэрх хотхон 422 -19 тоот 5 давхарт #4230 тор	3	19900.00	niseh	24	f	0	IKjYbriaev	2025-07-07 01:03:15.448+00	2025-07-08 11:08:54.197+00	f	f	2025-07-08 11:08:54.197+00	\N	f
955	10	99316648	10 horoolol baylag hothon 61 bair 	3	0.00	tom aygatai 	14	t	6	6PxXSim9vD	2025-07-21 04:25:11.232+00	2025-07-22 05:07:54.013+00	t	f	2025-07-21 05:21:16.399+00	0	f
695	6	88928000	1 horoolol 23bair 8-68 toot	5	0.00	.	9	f	0	almeHJRiL0	2025-07-07 03:15:55.201+00	2025-07-22 04:44:21.816+00	t	f	2025-07-09 07:34:53.757+00	\N	f
1213	6	88131770	harhorin sunday plaza2 delguurin zamiin esreg tald buundii aguulah delguur khan banktai bairnii 2 davhart	3	0.00	tootsoo hiisen	9	f	0	Lqo6yAtsZ2	2025-07-27 04:34:12.771+00	2025-07-27 06:08:03.155+00	t	f	2025-07-27 06:08:03.155+00	0	f
1552	10	90095797	hud duureg	1	5088.00	onoodor	\N	f	0	W8eRIyuFFP	2025-08-09 05:38:59.872+00	2025-08-09 05:43:41.684+00	f	f	\N	0	t
720	22	99162745	Ривер Гардены Тайм Скүэр 504-801	5	85000.00	Код:6 орой тийшээ авна гсн. Хүргэлт6к+85000	24	f	0	jRdMinORWh	2025-07-07 12:49:51.814+00	2025-07-22 04:43:32.366+00	f	f	\N	\N	f
717	18	90614565	sbd, 9khoroo, dulguun nuur, 4r surguuli ungruud MGL radio 88.3-in urduuraar zuun gar tiishee ergej orohod 433bair, 1ortstoi, 13davhar, 96toot,	3	36000.00	ygaan top	24	f	0	TEcmWyLFYf	2025-07-07 09:11:32.079+00	2025-07-07 12:58:17.305+00	f	f	\N	\N	f
1085	6	95504973	omno gowi hanbogd narantuulas tawih	3	0.00	onoodoor	9	t	11	t53PDrGyVt	2025-07-23 08:32:55.761+00	2025-07-25 06:17:06.424+00	t	f	2025-07-24 11:49:50.177+00	narantuulaas unaa yawdaggui	f
983	59	88640627	ХУД 24 хороо Viva city garden n7 3 давхар 3 тоот	3	6000.00	j	14	f	0	xJ93VaQnoZ	2025-07-22 03:46:37.65+00	2025-07-22 13:24:48.659+00	f	f	\N	0	f
491	26	91181156	91181156 11 хороолол 1 байр 10 орц 327 тоот код 327#382 тор	5	20000.00	ok	9	f	0	y0kU6HIqz0	2025-07-05 02:09:27.418+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
974	59	88481277	Өвөрхангай Арвайхээр	3	0.00	хүргэлтийн мөнгө өөрөөс нь	14	t	7	2aMEvJ0goD	2025-07-22 00:48:10.227+00	2025-07-25 06:14:48.825+00	f	f	2025-07-22 09:33:35.46+00	0	f
165	16	99647234	1horoolol sapporo hoid tali 2 r  bair 9 orts 3 davhar 299 toot baruun ergeed hoisho harsan huren haalga	3	15000.00	байхгүй	9	f	0	1UibbQ7cmN	2025-07-01 08:25:00.093+00	2025-07-09 07:36:32.092+00	f	f	2025-07-09 07:36:32.092+00	\N	f
747	6	88017277	bzd tseriin tow emneleg 	3	0.00	ajilin tsagar shuuu tema	8	f	0	ObSxkM0Z7Y	2025-07-07 17:05:59.568+00	2025-07-09 09:51:28.255+00	t	f	2025-07-09 09:51:28.255+00	\N	f
725	23	99059920	Бөмбөгөрийн урд талын 24-р сургуулийн урд 23-р байр зүүн талаасаа эхний орц баруун тийшээ харсан 11 давххрт 77 тоот 	3	49900.00	g9 tom 	8	f	0	6TDmDfLXot	2025-07-07 13:14:13.389+00	2025-07-09 13:51:13.299+00	f	f	2025-07-09 13:51:13.299+00	\N	f
692	26	99154936	Ԁ̀ȁCarefour буюу хуучин сансарын арын дээдсийн өргөө гээд ногоон байр 914 15 д 107 тоот	3	19900.00	яармаг	3	f	0	5bEn79SLyF	2025-07-07 02:54:26.781+00	2025-07-07 13:27:51.49+00	f	f	\N	\N	f
1005	58	88464399	БЗД, КТМС сургуулийн ар талын байшин. Эрдэм 180 хотхон, 10В байр, 9тоот	3	85000.00	Сүүдрэвч шар 4.5х4.5. 40р байрны агуулахаас авна.	24	f	0	wwwe0U7K6t	2025-07-23 01:50:15.013+00	2025-07-23 11:43:15.044+00	f	f	2025-07-23 11:43:15.044+00	0	f
2359	52	88012700	Zaisangiin orgiliin Aziparmaaer ergeed 115r surguuliin ard 73r bair 34 toot	2	6000.00	yaaraltai🙏🏻	78	f	0	nbCbjYkDph	2025-08-25 17:58:13.462+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2305	77	86590609 	zuragtiin shin etses ireed zalgah 	2	18000.00	95567356 	73	f	0	ma77g55H0p	2025-08-25 13:57:08.601+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
248	16	94390100	100 ail bsb iin ard gerontlogy tuviin 1 davhart zuun gar tald emiin sand	5	15000.00	7.2 nii 15 tsagaas umnu avna	9	f	0	1y3l8A3Tj8	2025-07-02 03:47:15.69+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
1710	59	85240925	баянхошуу хөтөл 	3	0.00	ирэхээсээ өмнө залгах	69	f	0	M9IuWRq4nq	2025-08-14 09:58:19.096+00	2025-08-15 08:03:43.987+00	f	f	2025-08-15 08:03:43.987+00	0	f
1111	10	95633499	shd 7horoo 100ail amirka elchingiin urd hiimori hothon 12bbair 21toot	5	51000.00	belhuus baridag omd 1sh	3	f	0	fv2y4OYbZB	2025-07-23 09:44:43.063+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1259	59	85627988	Баянзүрх сансарын түнээл S маркет хажуу талын ногоон байр 17 байр 1 орц 14 тоот	5	6000.00	ирэхээсээ өмнө залгах	67	f	0	eBJqmuLmeM	2025-07-28 07:35:56.762+00	2025-07-30 06:26:42.564+00	f	f	\N	0	f
956	10	99267767	13 horoolol naturin hoino 22b bair 26 toot	3	0.00	mango	14	t	6	kDwbwrOvka	2025-07-21 04:27:38.188+00	2025-07-22 05:07:54.013+00	t	f	2025-07-21 09:04:17.337+00	0	f
1157	20	88090390	khan uul duureg 15-r horoo tokyo town 2 hothon 124-1302 toot	3	1.00	oroin tsagaar	9	t	15	pSkJMzECvZ	2025-07-25 03:05:55.618+00	2025-07-27 05:28:48.894+00	f	f	2025-07-26 06:18:57.179+00	0	f
1060	10	99750211	BGD 29r khoroo 54 bair 44toot 88084867	5	119000.00	nvdnii tsatslaga 	3	f	0	a54Q2O5Zwm	2025-07-23 07:01:10.587+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1128	21	99984559	ofitser 14r surguuliin urd 119r bair 2 orts 5dav 68 toot	1	0.00	tuyanaa-d	\N	f	0	n9o7x9xZ1o	2025-07-23 14:10:56.363+00	2025-07-24 03:15:04.092+00	t	f	\N	0	t
1129	21	99984559	ofitser 14r surguuliin urd 119r bair 2 orts 5dav 68 toot	1	0.00	tuyanaa-d	\N	f	0	2wiT7jejPM	2025-07-23 14:10:56.458+00	2025-07-24 03:15:04.092+00	t	f	\N	0	t
505	16	80194691	BZD 29r horoo gegee orgoo hothon. 113r bair 1 orts 9 davhar 46 toot	5	15000.00	baihgyi	9	f	0	rNEqhCDRlw	2025-07-05 05:05:02.599+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
924	6	99170827	monel20-473	3	0.00	onoodor	14	t	3	qqUgMWdOFV	2025-07-20 05:03:00.341+00	2025-07-22 05:03:44.782+00	t	f	2025-07-20 14:18:02.091+00	0	f
1034	10	99953792	blue sky 1dawhart wall street 	3	0.00	hailna	14	t	8	c3bt8XanCE	2025-07-23 06:11:54.016+00	2025-07-25 06:15:20.103+00	t	f	2025-07-23 06:23:49.944+00	0	f
748	6	88074442	10 horoolol golden park 302-140 toot 	5	0.00	11 dawhart ortsnii kod 1397	9	f	0	16ssn03vU6	2025-07-07 17:07:16.408+00	2025-07-22 04:44:21.816+00	t	f	2025-07-09 07:30:32.466+00	\N	f
723	23	89010697	Яармагийн 3-р буудал 41-р сургуулийн хажууд дөмөг өргөө хотхон 7давхар 46 тоот өдрийн цагаар тэдди төв дээр байна орой7-с хойш гэрийн хаяг дээр	3	44900.00	pic mat	24	f	0	0gIoCWneIZ	2025-07-07 13:13:34.482+00	2025-07-08 11:08:40.363+00	f	f	2025-07-08 11:08:40.363+00	\N	f
736	23	99058098	хангай хотхон 514-19 тоот	3	54900.00	i7 jijig	14	f	0	lLnktzpmKa	2025-07-07 13:17:18.211+00	2025-07-08 15:45:19.614+00	f	f	2025-07-08 15:45:19.614+00	\N	f
745	6	86066161	tokyo town2	5	0.00	hurdan	9	f	0	3XlyRAGlhg	2025-07-07 17:03:42.63+00	2025-07-22 04:44:21.816+00	t	f	2025-07-09 07:35:31.437+00	\N	f
1274	59	88522417	БЗД 5 хороо 6 байр 9 давхар 37 тоот	3	6000.00	ирэхээсээ өмнө залгах	67	f	0	78NwdncLYR	2025-07-28 15:23:22.651+00	2025-07-29 15:43:35.218+00	f	f	2025-07-29 15:43:35.218+00	0	f
950	10	99472557	hud buynt 1horoolol 708 bair	5	45000.00	nuurnii serim	9	f	0	rsnqjCIFYY	2025-07-21 03:51:12.121+00	2025-07-22 04:44:21.816+00	f	f	\N	0	f
746	6	88646997	ulaanhuaran	5	0.00	tailbar	9	f	0	EcYApXpVVR	2025-07-07 17:04:37.906+00	2025-07-22 04:44:21.816+00	t	f	2025-07-08 12:38:16.878+00	\N	f
744	4	90255115	32 шинэ зам Сод Монгол клонк	3	1.00	.	14	f	0	UcydXr6NNu	2025-07-07 15:52:45.363+00	2025-07-08 04:06:02.037+00	f	f	2025-07-08 04:06:02.036+00	\N	f
739	23	99844548	Narnii horoolol 19bair 1601	3	44900.00	pic mat	24	f	0	JtBkXqGpjM	2025-07-07 13:18:25.62+00	2025-07-08 08:02:55.866+00	f	f	2025-07-08 08:02:55.866+00	\N	f
724	23	99901550	яармаг 1 гарден сити хотхон	3	54900.00	Lch5	24	f	0	ppoJhTaOgj	2025-07-07 13:13:54.383+00	2025-07-08 14:10:49.19+00	f	f	2025-07-08 14:10:49.19+00	\N	f
1171	63	99818407	han uul Yarmagt Shine zamiin hajuudh 312r tsetserlegiin baigdaj baiga barilga deer awiy	5	110000.00	  	14	f	0	6xoOIfn7uD	2025-07-25 07:13:52.027+00	2025-07-29 04:59:48.045+00	f	f	\N	tsutsalsan	f
657	23	95739504	Дэнжийн 1000 шонхор зах өгсөөд Петровис клонк дөхөөд залгах 	3	49900.00	g44 tom 	14	f	0	XQNVMXeRvP	2025-07-06 12:46:51.189+00	2025-07-09 10:06:20.945+00	f	f	2025-07-09 10:06:20.945+00	\N	f
551	26	96015692	96015692 4 р цахилгаан станц баруун талд сайхан төмөрт хажууд 1-9 тоот 2 машинд авна 2тор	5	39800.00	2 машинд	9	f	0	oT1GlxAWQL	2025-07-06 00:00:18.914+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
749	26	99756042	buynt uhaa 1 deer awna 	3	19900.00	hayg solison	24	f	0	jifQHmBhrW	2025-07-07 17:42:55.012+00	2025-07-08 12:40:01.948+00	f	f	2025-07-08 12:40:01.948+00	\N	f
1061	10	99438507	10 horoolol happines town 110 bair 184 toot 	5	65000.00	sahariin tsai 	3	f	0	NZt1jKIsZc	2025-07-23 07:02:09.162+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
2306	77	96658566 	hujirbulangin etses 	2	18000.00	80186089 	66	f	0	iGbqvu89QP	2025-08-25 13:57:48.26+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2360	52	99499608	Uwuthangai aimag avtobusand	2	6000.00	Uguud medegdeh!	9	f	0	15qrpDZep8	2025-08-25 17:59:30.46+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
653	23	88860840	Сүлжмэлийн үйлдвэрийн хаан бууз кафены хажууд ирээд залгах /үдээс хойш авах/ 	5	44900.00	m3	14	f	0	Rdw0Mps2qw	2025-07-06 12:45:20.714+00	2025-07-24 03:32:01.804+00	f	f	\N	\N	f
925	6	99084043	tomor zam kfc urd restoraand hun baiwal ogchih	3	0.00	ger shangirilaa hajuud	14	t	3	KEbeHvrs1k	2025-07-20 05:05:06.082+00	2025-07-22 05:03:44.782+00	t	f	2025-07-20 07:19:52.749+00	0	f
1112	10	86047100	blue sky 6dawhart 607 toot 	5	71000.00	massaje neck 1sh	3	f	0	ZdYc3lgeP8	2025-07-23 09:46:16.779+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1217	6	99005734	BGD 1r horoo 136a bair 13 davhar bars zahin hoid talin tuslah zam dagu 16 davhar 2 undur bair	3	0.00	tootsoo hiisen	14	f	0	TBaM11IsP8	2025-07-27 04:40:13.387+00	2025-07-27 08:06:28.276+00	t	f	2025-07-27 08:06:28.276+00	0	f
930	17	86148384	hovsgol moron avtobusand	3	195000.00	1sh kamer	66	f	0	m72ZSuWQAe	2025-07-21 01:59:23.041+00	2025-07-23 10:05:56.135+00	f	f	2025-07-23 10:05:56.135+00	margash awna	f
957	10	80805212	bzd duureg sengur gorhi hothon 53b bair 75toot	3	0.00	2+1 	14	t	6	g515FyZca3	2025-07-21 04:30:22.603+00	2025-07-22 05:07:54.013+00	t	f	2025-07-21 09:43:09.532+00	0	f
1086	6	99394400	hanuul uuderg zaisan apartment 2bair 501toot	3	0.00	onoodor	3	f	0	N5JK8tJg2G	2025-07-23 08:36:48.745+00	2025-07-23 10:30:52.309+00	t	f	2025-07-23 10:30:52.309+00	0	f
767	26	96051283	96051283 yaarmagiin shine bolon huuchin etses dund minii delguur deer 2 mashind tor	3	39800.00	yarmag	24	f	0	I01rvQzVce	2025-07-08 00:42:35.82+00	2025-07-08 13:11:30.573+00	f	f	2025-07-08 13:11:30.573+00	\N	f
615	26	89013034	89013034 nisekhiin toipog erged avtusnii buudal unguruud zvvn ergeed tultal yvhaar shar hashaa bga iped zalgh top	3	19900.00	нисэх	24	f	0	oLxcjzt7yd	2025-07-06 02:19:14.316+00	2025-07-08 14:59:20.85+00	f	f	2025-07-08 14:59:20.85+00	\N	f
1082	10	80061015	modnii 2 bubmbuuhei tsetserlegiin hajuud 50 bair 3r orts 95 toot oroihondoo	5	65000.00	gun tseverlegch 2 shirheg	3	f	0	DigOzF6cFJ	2025-07-23 08:04:48.876+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
984	19	80950572	наран туул зах	5	86000.00	төлбөр  танайх  авна	9	f	0	SbCKRDNMfY	2025-07-22 04:22:10.244+00	2025-07-22 04:44:21.816+00	f	f	\N	0	f
743	19	94060012	Үйлдвэр комбинат Таванбогд төв байр ажлын цаг 17 цагаас өмнө	3	86000.00	төлбөр  танайх  авна\nажил дээрээ 17 цаг хүртэл  байна.	24	f	0	hwYyjPCVfw	2025-07-07 15:02:22.892+00	2025-07-08 07:37:46.317+00	f	f	2025-07-08 07:37:46.317+00	\N	f
646	22	99890644	Bzd 13-r horoolol natur hudaldaanii tuviin urd selbe hothonii ariin 95-1-206 toot	5	90.00	Код:9    хүргэлт6к+90.000	9	f	0	361CQ2TctW	2025-07-06 10:53:42.91+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
757	26	89173312	89173312 narni horoolol 22bair 1802 toor tor	3	19900.00	19	24	f	0	9g77Fqqezu	2025-07-07 23:24:14.483+00	2025-07-08 09:49:34.09+00	f	f	2025-07-08 09:49:34.09+00	\N	f
1035	10	99327213	bayngol bogd ar horoolol 15a bair 14 toot	3	45000.00	huurnii serim	9	t	10	l6A1QnTglF	2025-07-23 06:26:27.924+00	2025-07-25 06:16:46.596+00	f	f	2025-07-23 12:10:36.052+00	0	f
691	26	99766081	99766081 нисэх шүрт хотхон 811 байр 2 орц 10 дав 139 тоот код 8112# Тор	3	19900.00	niseh	24	f	0	jUkPhWzx7h	2025-07-07 01:32:48.221+00	2025-07-08 11:13:57.085+00	f	f	2025-07-08 11:13:57.085+00	\N	f
702	26	99246042	99246042 niseh toirog unguruud sod mongol kolonkoor ergeed tugs orhhin hothon goliin bair 6 dawhar 18 toot	3	19900.00	niseh	24	f	0	tefnu6spEN	2025-07-07 03:59:39.854+00	2025-07-08 12:08:57.474+00	f	f	2025-07-08 12:08:57.474+00	\N	f
685	26	88180539	88180539 нисэх хойд 226 байрны хажууд барилга дээр тор	3	19900.00	niseh	24	f	0	KriUFrP4Xm	2025-07-07 01:12:42.858+00	2025-07-08 12:10:13.541+00	f	f	2025-07-08 12:10:13.541+00	\N	f
758	26	88051597	88051597 Niseh tugs orchin 1 hothon 286a bair 8-27 toot tor	3	19900.00	niseh	24	f	0	uXKnIeVqwa	2025-07-07 23:24:48.188+00	2025-07-08 12:39:22.797+00	f	f	2025-07-08 12:39:22.797+00	\N	f
754	26	88220251	88220251 buyant uhaa2 1041 -52 toot 9 dawhar tor	3	19900.00	niseh	24	f	0	iFO0nEGzYF	2025-07-07 23:22:23.706+00	2025-07-08 14:59:56.419+00	f	f	2025-07-08 14:59:56.419+00	\N	f
755	26	91154630	91154630 яармаг замын ард шинэ номин ард 2 дахь гудам нүхт 31 гудам 589 тоот тор	3	19900.00	yarmag	24	f	0	RsgsyFL5oZ	2025-07-07 23:22:52.239+00	2025-07-08 19:16:17.936+00	f	f	2025-07-08 19:16:17.935+00	\N	f
1158	58	95354069	40-р байр агуулахаас очиж авна.	3	55000.00	Сүүдрэвч шар 3х3. Өнөөдөр 13:30 үед очиж авна. Хүнгүй байхаар бвал утсаар нь хнлж бгад өөр газар үлдээгээд өгөөрэй.	9	f	0	l86J9YiwBF	2025-07-25 04:34:54.705+00	2025-07-25 09:25:13.524+00	f	f	2025-07-25 09:25:13.524+00	0	f
687	17	99042820	өдөр 32дээр орой Хүннү	5	195000.00	камэр 1ш 88063244s zahialga ogson	9	f	0	nMuDGgncvg	2025-07-07 01:18:21.311+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
667	26	99881879	99881879 niseh evel apartment 436bair 1212toot 2opts 12daw top	5	19900.00	нисэх	24	f	0	33w3gYdwmp	2025-07-06 15:31:43.263+00	2025-07-22 04:43:32.366+00	f	f	\N	\N	f
763	26	98388183	98388183 Нарны хороолол 4-61 тоот д цонхны тор	5	19900.00	ok	24	f	0	ypBfENygOB	2025-07-07 23:29:43.598+00	2025-07-22 04:43:32.366+00	f	f	\N	\N	f
751	10	99057672	sengur hothoni hajuud	5	35000.00	poma haygaa oloh	9	f	0	HMfpns0tnX	2025-07-07 18:01:24.637+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
750	10	95010393	tsaiz 16 hotiin towruu ywdag avto buudlas goishoo erged	5	35000.00	hunsnii delguurte haishaa bga	9	f	0	65AhvoNGX4	2025-07-07 17:46:07.868+00	2025-07-22 04:44:21.816+00	f	f	2025-07-08 11:45:09.349+00	\N	f
1007	59	95160171	БГД 2-р хороо Төмөр замын дээд сургуулийн хар шилэн цонхтой Crystal od 107р байр 1р орц 8 давхар 1083 тоот	3	20000.00	khalk	9	t	10	s80INgfvQr	2025-07-23 02:42:07.151+00	2025-07-25 06:16:46.596+00	f	f	2025-07-23 12:26:43.201+00	0	f
1718	59	89144045	дорнод 	3	0.00	ирэхээсээ өмнө залгах	14	f	0	g1XdhuYb3l	2025-08-14 12:24:06.264+00	2025-08-15 05:54:46.351+00	f	f	2025-08-15 05:54:46.35+00	0	f
977	59	88971004	ХУД 5-р хороо 937 байр	3	0.00	хүргэлтийн мөнгө авна	14	f	0	KhUYVf2Zo5	2025-07-22 00:50:03.891+00	2025-07-22 13:24:48.659+00	f	f	\N	0	f
796	19	99201276	Чингэлтэй дүүрэг 10р хороо Шинэчлэл хороолол 804-85 тоот	5	86000.00	төлбөр  танайх	14	f	0	PNDIjaiyNd	2025-07-08 04:27:08.204+00	2025-07-22 13:37:28.887+00	f	f	\N	awahgu gesn	f
878	10	88064537	ete	5	1000.00	etet	3	f	0	8ZcraUHsmR	2025-07-17 13:06:25.011+00	2025-07-22 04:48:36.916+00	f	f	\N	fun cousin	f
926	10	90114630	1emneleg  zuun haalga 5dawhart 4toot	3	20000.00	onoodor	14	t	3	uPj60i5Axh	2025-07-20 05:06:46.66+00	2025-07-22 05:03:44.782+00	f	f	2025-07-20 08:10:43.641+00	0	f
1177	63	86806760	hodoo baigaa dornog bayn uul her	5	150000.00	86806760	14	f	0	OaMGxDhveW	2025-07-25 07:59:36.874+00	2025-07-29 04:59:48.045+00	f	t	\N	tsutsalsan	f
772	2	88203197	Сансар КТМС баруун талд Undral auto service	3	600000.00	50 L төлбөр авах!	8	f	0	o4DjtF3mjj	2025-07-08 00:47:03.563+00	2025-07-09 08:47:08.805+00	f	f	2025-07-09 08:47:08.805+00	\N	f
1062	10	80000955	BGD 20 horoo BH 48r bair 1orts 5 toot 	5	71000.00	massage neck	3	f	0	pTu3KQYULt	2025-07-23 07:03:16.542+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
765	26	86048498	86048498 яармагруу гараад заавал залгаарай гэнэ 1 буудал замын урд талын яармагийн эмнэлэг   эсвэл ханбогд хороолол 205 -110 тор	3	19900.00	yarmag	24	f	0	2cJ103yNyW	2025-07-08 00:41:24.863+00	2025-07-08 09:49:03.478+00	f	f	2025-07-08 09:49:03.478+00	\N	f
787	23	90290019	СБД 11-р хороо шинэ зам Дархан өргөө хотхон 1013 байр 9 давхар 901 тоот	3	89800.00	g9 tom, g18 bosoo jijig	14	t	2	DXBgtQZyTU	2025-07-08 02:14:35.1+00	2025-07-18 12:08:11.986+00	f	f	2025-07-10 12:31:28.828+00	\N	f
1087	10	99399526	darhanin unaand tawih 	3	0.00	tsagaan tor	66	f	0	ClwYkhd4A9	2025-07-23 08:46:34.499+00	2025-07-23 09:49:47.045+00	t	f	2025-07-23 09:49:47.045+00	0	f
1179	63	88112608	zaisan america surguuli hajuud blue sky hothon 46g 14 toot 	3	60000.00	  	9	t	15	il0tGXzdvX	2025-07-25 08:55:31.83+00	2025-07-27 05:28:48.894+00	f	f	2025-07-26 11:51:02.833+00	0	f
1113	10	80296161	shd 9horoo 32-bair 42toot	5	65000.00	gun tsewerlegch 2sh	3	f	0	uMS0kXzmLH	2025-07-23 09:47:12.26+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1201	60	99175243	BZD 16-r horoo 16-r horoolol bayajih tsogtsolbor 18-r bair 31 toot	3	99000.00	tulbur hiigdeegui bga	14	f	0	mN1UaWYJ6b	2025-07-26 06:23:17.273+00	2025-07-27 11:39:35.024+00	f	f	2025-07-27 11:39:35.024+00	0	f
1036	10	86853666	bayangol 11r horoo zuragtiin huuchin etses buudal deer ireed hayg zaalgah 	3	45000.00	nvvrnii serum 	14	t	8	ciWh9yHyw6	2025-07-23 06:30:28.508+00	2025-07-25 06:15:20.103+00	f	f	2025-07-23 10:56:18.376+00	0	f
1137	58	99217852	Бөхийн өргөө, Баянзүрх захын зүүн урд талд 31-р байр 33 тоот	3	70000.00	Сүүдрэвч шар 3х4.5 1ш.	14	t	9	aRGAoea2Qi	2025-07-24 03:32:21.032+00	2025-07-25 06:15:33.973+00	f	f	2025-07-24 05:06:54.568+00	0	f
788	23	99389925 95026905	hayag: bzd 26-r horoo 331r bair 8 dawhar 806 toot	3	44900.00	m4	14	t	9	VIkMnO33NE	2025-07-08 02:14:52.186+00	2025-07-25 06:15:33.973+00	f	f	2025-07-24 12:05:19.994+00	24 awan gsn	f
785	26	91005000	91005000 shunshig 3 241 bair 2 orts 9 daw 115 toot tor kod 2412#	3	19900.00	yarmag	24	f	0	vDTdeVcxda	2025-07-08 01:45:14.728+00	2025-07-08 13:26:02.038+00	f	f	2025-07-08 13:26:02.038+00	\N	f
1296	63	88897619	хужирбуланд утас88897619	5	60000.00	7/29 ны өдөр бол Ботаник дээр байна. Маргааш хүргэнэ гэвэл хужир буланд авна 88446653 нэмэлт дугаар 	67	f	0	Wiao2XB4BZ	2025-07-29 03:50:43.995+00	2025-07-30 14:54:02.915+00	f	f	\N	очисон блловч өөр 3 ширхэг цайг дэлгүүрээс аваачиж өгсөн бсан тул бараагаа өгч чадаагүй	f
1297	61	99543358	очход байнга хүнтэй байна гэриййн  хаяг  хан уул дүүрэг 19 хороо дөл хот хон 97 д 2 орц 74 тоот утас 99543358	3	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	3	f	0	tE3MNMAEhk	2025-07-29 04:15:03.84+00	2025-07-29 09:51:09.806+00	t	f	2025-07-29 09:51:09.806+00	0	f
1244	63	88385053	Howsgol aimag unaand tawih	5	60000.00	Howsgol aimag unaand tawih	3	f	0	MkJGzElexU	2025-07-28 02:35:43.606+00	2025-07-30 14:57:27.79+00	f	t	\N	bolison	f
1159	63	99094062	16р хорооолол цайз 16 саруул ресторан 	3	60000.00	7сарын 25нд хүргэж өгөх	14	t	16	lEUEWoG4M6	2025-07-25 04:40:37.331+00	2025-07-30 15:10:50.855+00	f	f	2025-07-25 10:48:59.872+00	0	f
1291	63	94361318	баруун салаа 4-р буудал	3	60000.00	  	24	t	16	dXU8yExqIM	2025-07-29 02:30:51.102+00	2025-07-30 15:10:50.855+00	f	f	2025-07-29 09:50:46.357+00	0	f
773	26	91831018	91831018 Алтай хотхон 16 байр 140 тоот тор	3	19900.00	hud	24	f	0	FbrznV4BuU	2025-07-08 00:54:41.041+00	2025-07-08 09:47:29.94+00	f	f	2025-07-08 09:47:29.94+00	\N	f
1660	52	89470470	Kino yuldverees hoishoo ugsuud 69r surguuliin hajuugaar garaad 73r bair	3	6000.00	ochood zalgah	9	f	0	vG4M3CxXl5	2025-08-13 18:41:26.226+00	2025-08-14 15:32:52.304+00	f	f	2025-08-14 15:32:52.304+00	0	f
768	26	99681707	99681707 hud erelees hoish tawigdsan shine zamaar yawaad vitafit kompanii bairan deer ajliin tsagaar tor	3	19900.00	hud	24	f	0	Sd6hVSpE8R	2025-07-08 00:43:02.281+00	2025-07-08 09:48:07.149+00	f	f	2025-07-08 09:48:07.149+00	\N	f
790	23	89006565	Oworhangai aimag xuuchn dragon drees junug tergn tawiad ogiroi 	5	0.00	Lch3	9	t	2	zYllkjNYp2	2025-07-08 02:15:28.831+00	2025-07-22 04:44:21.816+00	t	t	2025-07-09 07:35:51.042+00	\N	f
1235	52	99015181	BZD 26 r horoo SumberOrd hothon	3	6000.00	Ochihdoo zalgah	67	f	0	XFf1Zz6GE3	2025-07-27 18:04:35.101+00	2025-07-29 15:44:29.081+00	f	f	2025-07-29 15:44:29.081+00	0	f
1717	59	80920055	БЗД 14 хороо нарт хотхон 95/3 127тоот	3	0.00	ирэхээсээ өмнө залгах	14	f	0	jWnfTQ7eGI	2025-08-14 11:40:01.723+00	2025-08-15 13:02:34.183+00	f	f	2025-08-15 13:02:34.183+00	0	f
1275	59	95287580	БГД 15 хороо 30 р байр 	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	eZ9BFwS5aE	2025-07-28 15:24:06.786+00	2025-07-30 09:48:03.26+00	f	f	2025-07-30 09:48:03.26+00	0	f
2307	77	88179576  	БЗД 16р хороолол	2	20000.00	 25а 10тоот	66	f	0	gGIrxKZNAy	2025-08-25 13:58:10.976+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
1316	63	88777586	Erdenet Saihanii hotol deer awiy unaand tawih	3	60000.00	Anduud deerees unaa ywna  unaand tawihdaa  zaawal yrih	3	t	16	eIco0z9uPf	2025-07-29 08:29:55.703+00	2025-07-30 15:10:50.855+00	f	t	2025-07-30 07:34:33.344+00	0	f
764	26	99240622	96240622 niseh 7r surguuliin baruun tald 68r bair iped zalgh hiij uzej awna top	3	19900.00	niseh	24	f	0	f2E9XTFzHH	2025-07-08 00:40:54.766+00	2025-07-08 12:12:40.569+00	f	f	2025-07-08 12:12:40.569+00	\N	f
794	26	89053262	89053262 hanuul 3hopoo gerelt utguu 47v bair 6daw 41toot bhgv bol delgvrt uldeelgene top	5	19900.00	hud	9	f	0	yyVkfgLlit	2025-07-08 02:35:47.8+00	2025-07-22 04:44:21.816+00	f	f	2025-07-08 08:06:46.864+00	\N	f
959	10	90114630	1 emlege zuun haalga 5dawhart 4toot	3	20000.00	onoodoro	14	t	6	spXnQROmVE	2025-07-21 04:35:46.307+00	2025-07-22 05:07:54.013+00	f	f	2025-07-21 08:36:40.391+00	0	f
1151	58	94449191	8 шаргын урд талын Капитал центр 504 тоот	3	55000.00	Сүүдрэвч шар 3х3.\nхүргэлтээр очихдоо залгаарай гадуур гарчиж магадгүй.	9	f	0	hZU0qb6YoJ	2025-07-24 08:09:47.916+00	2025-07-25 09:24:17.61+00	f	f	2025-07-25 09:24:17.609+00	0	f
2362	20	88035201	Shd 7r horoo 0119iin 55n toot	2	1.00	төлбөр авахгүй	9	f	0	Vznl6ekqLq	2025-08-25 23:08:10.585+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
2308	77	95403418 	 X apartment 2 	2	19000.00	15in 120	66	f	0	hfoBDxfVQT	2025-08-25 13:58:36.688+00	2025-08-26 05:17:54.791+00	f	f	\N	0	f
797	2	99919043	Нисэх спорт цогцолбор Ла коли	3	500000.00	30Л тооцоогоо очоод авах шөнө 12 оос өмнө очих	24	f	0	SFWGFcYkYE	2025-07-08 05:29:29.312+00	2025-07-08 12:23:01.523+00	f	f	2025-07-08 12:23:01.523+00	\N	f
802	22	95900004 Код:10	Сэлэнгэ-Сүхбаатар төв	3	0.00	Унаанд тавина. Барааны төлбөр+хүргэлт төлбөр хийсэн	8	f	0	k4MiNHuhIB	2025-07-08 12:12:46.235+00	2025-07-09 09:56:23.121+00	t	t	2025-07-09 09:56:23.121+00	\N	f
931	6	88967205	nalaihin unaand tawih	3	0.00	onoodor	14	t	6	3U0DFmSNly	2025-07-21 03:17:26.079+00	2025-07-22 05:07:54.013+00	t	f	2025-07-21 10:12:39.382+00	0	f
799	18	89525236	Peacemall office 15 1505	3	36000.00	har top	8	f	0	3R8l072xHv	2025-07-08 10:10:00.327+00	2025-07-10 07:30:47.283+00	f	f	2025-07-10 07:30:47.283+00	\N	f
804	23	99670493	"baruunharaa /darhanii unaand baruunharaa gd tawiad uguurei joloochid urdaa awaarai gdgig sn helerei/  "	3	0.00	Lch4	8	t	2	8vABCmfvO2	2025-07-08 12:36:20.163+00	2025-07-18 12:08:11.986+00	t	t	2025-07-09 09:51:11.825+00	\N	f
805	23	99075464	grand plaza uruudaad tumur zamiin tsagdaagiin hajuu taliin Erhes supermarkettai 214b bair 5 davhar 19 toot	3	44900.00	pic mat	8	t	2	APBEd7GdbJ	2025-07-08 12:36:45.302+00	2025-07-18 12:08:11.986+00	f	f	2025-07-09 14:26:58.991+00	\N	f
803	23	90868686	Барс захын арын 65-р байр 3-р орц 9 давхарт 108 тоот 	3	44900.00	pic mat	8	t	2	ntnfaL76yS	2025-07-08 12:35:57.627+00	2025-07-18 12:08:11.986+00	f	f	2025-07-09 14:38:50.381+00	\N	f
818	23	86086799	Seoul garden 313-308	3	54900.00	i7 jijig	14	t	2	yT8fLHBNOI	2025-07-08 12:41:25.642+00	2025-07-18 12:08:11.986+00	f	f	2025-07-10 06:28:51.827+00	\N	f
817	23	91931010	misheel A-13	3	44900.00	pic mat	14	t	2	OfgERQvkwi	2025-07-08 12:41:07.156+00	2025-07-18 12:08:11.986+00	f	f	2025-07-10 12:32:50.863+00	\N	f
819	23	88045079	БЗД 14 р хороо цагаан хуаран хотхон	3	39900.00	g9 jijig	14	t	2	tjlBFrrlgQ	2025-07-08 12:43:39.883+00	2025-07-18 12:08:11.986+00	f	f	2025-07-10 12:33:15.839+00	\N	f
1063	10	99483008	BGD narnii horoolol 17r bair 202toot 	3	71000.00	massage neck 	65	f	0	GmKTGeRKAe	2025-07-23 07:04:13.33+00	2025-07-23 15:16:50.915+00	f	f	2025-07-23 15:16:50.915+00	0	f
752	26	99946924	99946924 Tets 3 iin baruun tald tesa gsn beton zuurmagiin hashaand tor ezgui baihad ochij taarwal  manaachid uldeeh tor	5	19900.00	tets 3	9	f	0	Bx6Ho6HVZv	2025-07-07 23:20:13.062+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
753	26	86040011	86040011 hanuul duureg 19 iin kfc deer tor	5	19900.00	hud-19	9	f	0	mEKlzgSgmd	2025-07-07 23:21:47.932+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
821	20	86666111	ХУД, 4-р хороо, Шүншиг – хотхон, 57B байр, 14 давхарт, 80 тоот	5	6000.00	a	9	f	0	aq1Cfj6kJ1	2025-07-08 13:36:49.257+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
1138	6	89662353 99662353	10horoolol uub 21 tooot	3	0.00	onoodor	9	t	11	ZlGtYjDS6M	2025-07-24 03:37:46.066+00	2025-07-25 06:17:06.424+00	t	f	2025-07-24 09:48:07.427+00	0	f
822	20	88109634	Ажлын цагаар: Найман шарга, Голомт банкны 1 давхарт Ажлын бус цагаар: Цирк, алтан жолоо 13р байр	5	6000.00	a	9	f	0	XtC2FS2Qg9	2025-07-08 13:37:24.942+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
1037	10	99959389	BGD 6 khoroo 107 bair 11toot	5	55000.00	zovhinii tos 	3	f	0	Jl2suAmSTW	2025-07-23 06:31:33.727+00	2025-07-24 04:20:40.425+00	f	f	\N	Butsasa	f
828	21	88035500	peace mall-n 206 deer	5	0.00	7/9nii 12-18 tsagiin hoorond avna	9	f	0	Gr0IAPCdyA	2025-07-08 14:00:45.99+00	2025-07-22 04:44:21.816+00	t	f	\N	\N	f
831	22	99109824 Код:11	Тэнгис Гэсэр сүмийн зүүн талд мплаза	5	85000.00	16 цагаас өмнө авах, 85к+хүргэлт 6к, таарахгүй бол хүргэлтийн мөнгөө өгөх	9	f	0	R7TcDw5PfF	2025-07-08 16:00:40.241+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
712	16	99917253	10r holoolold	5	15000.00	baihgyi	9	f	0	pybLc3KvH0	2025-07-07 07:15:54.942+00	2025-07-22 04:44:21.816+00	f	f	2025-07-10 12:28:12.831+00	\N	f
971	59	95005453	Нарны хороолол Есөн эрдэнэ хотхон 29/8 4 давхар 19 тоот	5	0.00	хүргэлтийн мөнгөө өөрөөё нь авна	9	f	0	Pk04O93Rr4	2025-07-22 00:45:51.165+00	2025-07-22 04:44:21.816+00	f	f	\N	0	f
641	4	99135488	Цэцэг төвийн замын эсрэг талын Төрийн банкны төв оффис 9:00-18:00	5	1.00	09:00-18:00 хооронд	9	f	0	hLQCBv5i4h	2025-07-06 08:27:25.783+00	2025-07-22 04:44:21.816+00	f	f	2025-07-09 07:33:10.816+00	\N	f
693	6	88087722	horoololin etses next ilektronoor baruun irges hondlon shar 1 bair 4 dawhart 13t	5	0.00	80082429 88087772	9	f	0	pPrpViEUwC	2025-07-07 03:13:28.141+00	2025-07-22 04:44:21.816+00	t	f	2025-07-09 07:34:06.1+00	\N	f
703	19	99916507	өөрөө очиж авах	5	86000.00	төлбөр  танайх	9	f	0	LeE5CAXG3e	2025-07-07 04:55:37.567+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
709	16	89583726	ylaanhuarand	5	15000.00	baihgyi	9	f	0	BJdAMFe0Pt	2025-07-07 06:01:40.984+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
952	10	99912323	niseh buynt uhaa 1d	5	71000.00	erchuudin beldmel milk oil	9	f	0	96F1f8sQ9J	2025-07-21 03:55:53.697+00	2025-07-22 04:44:21.816+00	f	f	\N	0	f
978	59	89838260	Чулуу Овоогийн Номин	5	0.00	хүргэлтийн мөнгө өөрөөс нь	9	f	0	ongR0BMK5O	2025-07-22 00:50:50.136+00	2025-07-22 04:44:21.816+00	f	f	\N	0	f
1088	10	80186699	zaisan time square 505bair 8dawhart 801	3	0.00	onoodor	3	f	0	ubwf4XLYCa	2025-07-23 08:51:10.877+00	2025-07-23 11:08:14.339+00	t	f	2025-07-23 11:08:14.339+00	0	f
1008	58	88005071	Төмөр замын эмнэлэгийн зүүн талын саарал 5 давхар байр. 55-р байр 60 тоот, код 60В	3	45000.00	усан буу	9	t	10	zExtHemoq4	2025-07-23 02:48:59.041+00	2025-07-25 06:16:46.596+00	f	f	2025-07-23 14:37:54.619+00	0	f
1114	10	89777993	shd 11 horoolol ardchiliin ordoni ard tald 5b bair	5	51000.00	eemeg	3	f	0	wUbOQwcczF	2025-07-23 09:48:51.476+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
825	20	88992904	БЗД 19 хороо 52А байр/ new town хотхоны зүүн талын байр/ 12 давхар 1201 тоот	3	6000.00	a	14	f	0	KfQRSFajFH	2025-07-08 13:38:56.436+00	2025-07-09 12:13:31.482+00	f	f	2025-07-09 12:13:31.482+00	\N	f
823	20	99159192	ХУД, 15-р хороо, KH апартмент, 6A bair 2-р орц	3	6000.00	(oroi 19 tsagaas hoish hurgelteer avah)	14	f	0	DwV1X6div7	2025-07-08 13:38:05.747+00	2025-07-10 12:33:01.497+00	f	f	2025-07-10 12:33:01.497+00	\N	f
2309	77	99108373 	 CHD 5 horoo tengis kino teatrin ard tald	2	20000.00	12r bair 2 toot 	73	f	0	N5ZHnhtyLy	2025-08-25 13:59:06.142+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
2363	6	99068536	БГд 19р 4р хороолол 57р байр 5р орц 169тоот	2	1.00	заавал өдөртөө багтааж хүргэх ёстой маргааш үсний найртай маргааш бараа хагарна‼️‼️‼️‼️‼️‼️‼️	73	f	0	tVTrNt4SkV	2025-08-25 23:48:41.589+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
1161	19	80550541	Utas 80550541 Hayg baynzurh duureg 26r horoo olimp hothon 426 dugaar bair 4dawhar	3	86000.00	төлбөр танайх  авна	14	f	0	vQWhJ6q0zn	2025-07-25 04:44:08.979+00	2025-07-25 15:04:37.013+00	f	f	2025-07-25 15:04:37.012+00	0	f
1115	10	99104056	shd 11-horoo 310bair 12os omno	5	65000.00	erchuudin kapsul1sh	3	f	0	Bn88MsamVb	2025-07-23 09:49:59.357+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
960	54	99551172	Баянголь дүүрэг 7-р хороо 30р байр	3	150000.00	e mart-n zamiin urd 7sarin 22nd huleen awna 12 tsagaas hoish huleen awah bolomjtoi	14	t	7	CvDcOPPKvd	2025-07-21 06:38:03.942+00	2025-07-25 06:14:48.825+00	f	f	2025-07-22 11:43:22.903+00	0	f
980	4	88140708	хан уул И мартын эсрэг тал Encanto 307-2-7-43 тоот	3	1.00	.	14	t	7	MCL2L0KpSB	2025-07-22 01:15:04.56+00	2025-07-25 06:14:48.825+00	f	f	2025-07-22 13:00:43.088+00	0	f
1098	10	88095774	chingelte duureg 1 horoo 5in 29 toot	5	65000.00	sahariin tsai 1 sh	3	f	0	bSZY2Kzx49	2025-07-23 09:13:46.594+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1038	10	99921861	BGD 8-khoroo 12-44	5	45000.00	hamar helberjvvlegch	3	f	0	LPaFZRgJ5h	2025-07-23 06:33:19.179+00	2025-07-24 04:20:40.425+00	f	f	\N	yum asugad delgurin dugar awsni dara utsa awagu	f
1089	10	99087372	suis utasdaj ogno ajilin tsagaar 16 hurtel bna	5	55000.00	zowhinii tos 2sh	3	f	0	blVVtO1UYs	2025-07-23 08:54:50.75+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1064	10	99989216	BGD 3r horoo huuchin teevriin tovchoni 73r surguuliin urd 6n davhar tsagaan 76r bair 3n davhart14n toot ortsni code 7633#	5	64000.00	buguin tsag	3	f	0	vB5PdMrZdD	2025-07-23 07:10:10.142+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
632	26	94484850	94484850shunshig2 iin esreg taliin aurug ged gants bairnii 2daw 3toot top	5	19900.00	huduureg	9	f	0	OR3NvN5Tf6	2025-07-06 04:30:38.34+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
690	17	91929320	орой зүүн салаа улаан худаг буудал өдөр хотын төвөөр ярьж байгаад	5	195000.00	1ш камэр	9	f	0	OhwS6CcNCx	2025-07-07 01:27:52.706+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
954	54	99163299	СБ дүүрэг 3-р хороо 20-р байр 23 тоот	3	150000.00	7/20ны захиалга тул 21-нд хүргэж өгөх	14	t	6	KO9cOkL1MA	2025-07-21 04:10:12.252+00	2025-07-22 05:07:54.013+00	f	f	2025-07-21 08:08:11.876+00	0	f
1180	46	91575757	denjin 1000 gaxain bair maral tow zam daguu	3	229000.00	проектор	14	t	14	6UP0d2f0QX	2025-07-25 11:47:26.134+00	2025-07-27 04:04:40.905+00	f	f	2025-07-26 13:17:32.716+00	0	f
830	21	99078710	BZD 26 horoo Olymp hothon 430 bair 2orts 2 dav 85 toot	5	0.00	ch. uyan -d	9	f	0	eNo4gWV1gn	2025-07-08 14:47:46.723+00	2025-07-22 04:44:21.816+00	t	f	\N	\N	f
697	16	88303360	sonsgolon chnartai dugui delguurt	5	15000.00	baihgyi	9	f	0	gEiwe9ujA2	2025-07-07 03:54:29.169+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
1203	58	95112599	нисэх, актив гарденаас очиж авна.	3	85000.00	Сүүдрэвч шар 4.5х4.5. Нисэх актив гарденаас очиж авах тул очихоороо дугаар луу залгаарай.	3	f	0	gfH4uLHY9I	2025-07-26 08:38:49.172+00	2025-07-27 12:39:53.989+00	f	f	2025-07-27 12:39:53.989+00	0	f
732	16	99832192	Төмөр замын 65байр 155тоот сүүлийн орц 3давхарт 99035327	5	15000.00	baihgui	9	f	0	MVmiwSZrDa	2025-07-07 13:16:29.886+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
721	22	99446032	Цагаан хуаран	5	80000.00	Код: 3, 7-г үзэж бгаад нэгийг нь авна. Код:3-75000, код:7-80000. Эрт байвал сайн  гэсэн. Хүргэлт6к+тооцоо	9	f	0	SlWvbUpEIA	2025-07-07 12:57:48.387+00	2025-07-22 04:44:21.816+00	f	f	2025-07-08 07:38:38.02+00	\N	f
1300	6	98080819	dornotin  unaand	3	0.00	fd	67	f	0	NINOg1k2HC	2025-07-29 05:40:55.501+00	2025-07-30 11:05:00.028+00	t	f	2025-07-30 11:05:00.028+00	0	f
705	18	94968129	БЗД 5хороо 74байр 3 тоот баш нарын байр гэсэн байгаа	5	36000.00	ulaan top	9	f	0	j5XGOVRDlw	2025-07-07 05:27:44.573+00	2025-07-22 04:44:21.816+00	f	f	2025-07-08 13:49:58.713+00	\N	f
708	16	91002275	horoolol apex ih delguur	5	15000.00	baihgyi	9	f	0	0iEAnTIRjI	2025-07-07 06:01:01.873+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
1390	4	96051042	Яармаг богд вилла 1202- р байр	3	1.00	.	3	f	0	NQ12WUQ1Yr	2025-08-01 12:39:41.488+00	2025-08-02 07:57:05.236+00	f	f	2025-08-02 07:57:05.236+00	0	f
1402	4	89948121	max mall  4 давхар406 тоот	3	1.00	.	14	f	0	GrMO2KTw5v	2025-08-02 11:59:07.73+00	2025-08-03 10:54:08.63+00	f	f	2025-08-03 10:54:08.63+00	0	f
710	16	99045704	dulguun nuur220 r bair 5/506 toot	5	15000.00	baihgyi	9	f	0	35VLsT14QS	2025-07-07 06:02:27.05+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
738	23	88608128	Цайз 16 буудал хойд талд Грийн апартмент в байр 15 давхар 159 тоот /ирэхдээ залгах/	5	49900.00	g9 tom 	9	f	0	BBLpPwEj3q	2025-07-07 13:18:06.493+00	2025-07-22 04:44:21.816+00	f	f	2025-07-08 10:57:13.641+00	\N	f
728	23	88107036	Сүнжинграндийн баруун талд грандресиденс хотхоны 706 тоот	5	49900.00	g8 tom 	9	f	0	rJzar1V1Vl	2025-07-07 13:15:13.4+00	2025-07-22 04:44:21.816+00	f	f	2025-07-08 09:51:45.49+00	\N	f
729	23	80073163	Oftseriin XApartment 4r bair Ablock 14toot 3 dawhart	5	44900.00	pic mat	9	f	0	ZHFK1M4c9N	2025-07-07 13:15:32.581+00	2025-07-22 04:44:21.816+00	f	f	2025-07-08 10:18:06.805+00	\N	f
726	23	88063000	Buhiin urguu baynzurh zahiin urd 55r bair 67toot 12dawhart	5	39900.00	g18 hundlun jijig	9	f	0	hphS3EcV4w	2025-07-07 13:14:34.227+00	2025-07-22 04:44:21.816+00	f	f	2025-07-08 14:21:24.006+00	\N	f
665	26	88110165	88110165 yaarmag nutgiin buyn happy residence 870bair 803toot 8daw top utas untraakttai bwal shuud gert ogood dansaa yawuul gene tor	5	19900.00	yaarmag	9	f	0	fM3T4mUsfx	2025-07-06 15:30:20.874+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
792	26	90075511	90075511 120myngat 10bair 27toot top	5	19900.00	120	9	f	0	caOTqLZEbo	2025-07-08 02:34:10.742+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
826	20	95801525	Дунд гол, Цагдаагийн Ерөнхий газрын авто баазын яг хажууд Parco reviera хотхон, 116b байр, 1001 тоот	5	6000.00	a	9	f	0	MFBYKwsr65	2025-07-08 13:39:17.112+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
740	16	99036921	Бзд 43 хороо 101 байр амартүвшин хотхон 3 р орц 12 давхарт 221 тоот	5	15000.00	baihgui	9	f	0	FTg6VbF7iX	2025-07-07 13:18:36.11+00	2025-07-22 04:44:21.816+00	f	f	2025-07-09 11:44:39.629+00	\N	f
2364	60	90060222	6 r bichil horoolol	2	85000.00	6r bichil horoolol deer ochiod zalgah tulbur hiigdeegui	73	f	0	I9VCIi675t	2025-08-25 23:57:52.102+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
798	18	95057396	32toirog,ongorood tsagdaagin 2r heltesiin urduur yawad hasha ongorood baruun ergeed delger delgvvr	5	46000.00	хар өмд	14	f	0	ndbheib4By	2025-07-08 10:08:28.443+00	2025-07-25 12:02:31.402+00	f	f	\N	hodonos eregu	f
2310	77	86305883 	 SHD 6horoo haniin matiraliin etsest  	2	18000.00	 64A 1r orts 57toot 	9	f	0	r7zhQjFsLJ	2025-08-25 13:59:32.004+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
737	23	95550025	БГД 18-р хороо 83.б байр 67-тоот	3	44900.00	pic mat	8	f	0	GnF14IPCxu	2025-07-07 13:17:46.172+00	2025-07-09 13:51:44.5+00	f	f	2025-07-09 13:51:44.5+00	\N	f
1116	2	99442448	Darkhan unaand tavih	3	1.00	40L tulbur avsan shuud unaand tavina darkhan	3	f	0	2FkNq69y4o	2025-07-23 10:52:10.267+00	2025-07-24 05:13:57.462+00	f	f	2025-07-24 05:13:57.462+00	0	f
808	23	99012068	БЗД 2хороо 104байр 24тоот	3	39900.00	g42 jijig	14	t	2	GFSqHXoxqA	2025-07-08 12:37:57.021+00	2025-07-18 12:08:11.986+00	f	f	2025-07-10 12:34:15.743+00	\N	f
811	23	88819865	Дорнод аймаг /каргонд өгөх/	3	0.00	i7 jijig	8	t	2	Uy0szFpkMa	2025-07-08 12:39:02.449+00	2025-07-18 12:08:11.986+00	t	t	2025-07-09 12:42:28.485+00	\N	f
813	23	80090756 89090907	"БЗД 16р хороолол монгол хотхон 66ё байр 69 тоот"	3	119800.00	i3 tom 2sh 	14	t	2	AOmAyl54rv	2025-07-08 12:39:44.087+00	2025-07-18 12:08:11.986+00	f	f	2025-07-09 12:46:53.951+00	\N	f
816	23	91003394	Holiday inn gd zochid buudliin reception dr uldee	3	39900.00	g9 jijig	8	t	2	mBwkJcRP3O	2025-07-08 12:40:47.407+00	2025-07-18 12:08:11.986+00	f	f	2025-07-09 13:51:06.416+00	\N	f
812	23	88097310	xan uul duureg 18r xoroo gegeentenii zuun tald SS garden xotxon. xaruuln putik deer n uldeexed bolnoo	3	44900.00	pic mat	14	t	2	0LoNQazdhr	2025-07-08 12:39:24.554+00	2025-07-18 12:08:11.986+00	f	f	2025-07-10 06:29:50.075+00	\N	f
807	23	88885690	Khan hills hothon 526-401 toot Irheese umnu zalgah	3	89800.00	alo pink, alo black	14	t	2	Ow5i1AlH6a	2025-07-08 12:37:32.147+00	2025-07-18 12:08:11.986+00	f	f	2025-07-10 08:05:46.381+00	\N	f
707	16	86018820	huuchin dragon	5	15000.00	baihgyi	9	f	0	1JtCIZzllU	2025-07-07 06:00:38.209+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
722	23	99518333	ajliin tsagaar Shangrila office 603 toot /оройн цагаар ХУД, 11р хороо, Удирдлагын акдемийн урд талд Цэцэг хотхон, 46с байр, 11тоот,/	3	54900.00	Lch5	8	f	0	EwhIPaEBz9	2025-07-07 13:13:12.711+00	2025-07-10 12:27:03.3+00	f	f	2025-07-10 12:27:03.3+00	\N	f
742	23	80116069	Khanuul duureg, Orgil rashaan suvilal dr zahirgaa heseg 2 davhart 209 toot	3	44900.00	pic mat	14	f	0	dwT670mRVx	2025-07-07 13:25:08.271+00	2025-07-10 12:33:22.798+00	f	f	2025-07-10 12:33:22.798+00	\N	f
810	23	99281918	Худ 24.р х Глобал гарден 1271-29 	3	99800.00	g8 tom, g41 tom 	14	t	2	Ojot3aV7jd	2025-07-08 12:38:39.984+00	2025-07-18 12:08:11.986+00	f	f	2025-07-10 12:34:00.988+00	\N	f
731	23	99694564	"Баянгол дүүрэг 11р хороо 4-р хороолол Хасбаатар гудамж 43а байр 11 давхарт 46 тоот. орц код #2580 "	3	49900.00	g7 tom 	14	f	0	01O9IIikt5	2025-07-07 13:16:16.149+00	2025-07-10 12:33:54.261+00	f	f	2025-07-10 12:33:54.26+00	\N	f
809	23	98884986	"Дүнжингарав үйлчилгээний төвийн чанх урд талын Богд банктай Санрайс хотхон 408-4-15 тоот"	3	89800.00	g9 tom, g9 jijig	14	t	2	H5qU6ZFuH6	2025-07-08 12:38:17.747+00	2025-07-18 12:08:11.986+00	f	f	2025-07-10 12:34:07.039+00	\N	f
862	21	99184466	BZD 36 horoo Ih mongol residence 906 bair B block 4 dav 49 toot	3	0.00	odnoo odnoo-d	14	t	7	Skz6nSvlyR	2025-07-12 04:42:23.465+00	2025-07-25 06:14:48.825+00	t	f	2025-07-22 12:42:01.123+00	\N	f
727	23	86819961	Haldwartiin etses /18 Цагаас өмнө авах/	5	54900.00	Lch6	14	f	0	ETXAnk1P0N	2025-07-07 13:14:54.023+00	2025-07-22 04:43:32.366+00	f	f	2025-07-16 08:17:32.138+00	boltsin	f
741	16	99829202	tsaiz 16 shine ger 55a2dawhar 2 toot	5	15000.00	baihgui	9	f	0	7K08Q92ugz	2025-07-07 13:21:44.217+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
1065	10	80061015	modnii 2 bomboohoi tsetserlegiin hajuud 50 bair 3 orts 95 toot oroihondoo	1	65000.00	buguin tsag	9	f	0	BO6Ha3h94r	2025-07-23 07:13:20.283+00	2025-07-23 08:02:46.053+00	f	f	\N	0	t
1048	10	86818797	horoolol nomin ard vip center 307 toot 99818797	5	55000.00	zovhinii tos 	3	f	0	SJvQONqSCJ	2025-07-23 06:44:59.113+00	2025-07-24 04:20:40.425+00	f	f	\N		f
1090	10	99912101	hailast shine  etsest deer 	5	71000.00	eregtechuudin beldmel milk oil 1 sh	3	f	0	VEvjXBuWQH	2025-07-23 08:56:26.426+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1039	10	94116524	horoolliin emart 	5	55000.00	beebreathe erchvvdiin gazar 	3	f	0	aJ0HIMPLcA	2025-07-23 06:34:18.429+00	2025-07-24 04:20:40.425+00	f	f	\N		f
686	26	99143365	99143365 yaarmagiin garden city 1306 bair 1 orts 202 toot tor	5	19900.00	yarmag	9	f	0	Xa3zywqOLL	2025-07-07 01:14:56.692+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
975	59	94149646	Дорноговь Сайншанд	5	0.00	өөрөөс нь хүргэлтийн мөнгө авна	9	f	0	Hd679uz4pO	2025-07-22 00:48:51.18+00	2025-07-22 04:44:21.816+00	f	f	\N	0	f
769	26	88857843	88857843 120 myangat ereliin bair 45 bair 3 toot tor	5	19900.00	120	9	f	0	aAnIBG0too	2025-07-08 00:43:35.966+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
1711	59	99440839	сэлэнгэ	3	0.00	ирэхээсээ өмнө залгах	68	f	0	uq8I01gP7q	2025-08-14 10:18:25.858+00	2025-08-15 04:33:21.784+00	f	f	2025-08-15 04:33:21.784+00	0	f
786	23	95058199	БЗДүүрэг, нарт хотхон, 94б байрны 157 тоот	5	39900.00	g18 bosoo jijig	9	f	0	UB45GNikyh	2025-07-08 02:14:15.372+00	2025-07-22 04:44:21.816+00	f	f	2025-07-08 16:57:47.48+00	\N	f
1162	6	94538999	bzd 16horoo gegee 39bair 1orts 65 toot	3	0.00	onooodor	14	t	14	lljw62wzqh	2025-07-25 05:03:07.603+00	2025-07-27 04:04:40.905+00	t	f	2025-07-26 10:04:13.84+00		f
1181	58	89073041	БЗД, 32 хороо, 19р гудамж, 257 тоот	3	70000.00	Сүүдрэвч шар 3х4.5 1ш	14	t	14	r4LS5BtxqJ	2025-07-25 12:34:01.797+00	2025-07-27 04:04:40.905+00	f	f	2025-07-26 11:22:33.608+00	0	f
1238	52	89470470	Kino uildwereez hoish ugsuud Soyombo Comlex- oor ergeed 73 r bair	3	0.60	b	67	f	0	NSFGaLYbJS	2025-07-27 18:07:36.856+00	2025-07-29 15:46:11.286+00	f	f	2025-07-29 15:46:11.286+00	0	f
1301	6	89241800	6 buudal	3	0.00	;lk	9	f	0	YRLTNSIbDR	2025-07-29 05:48:37.114+00	2025-07-29 05:51:56.813+00	t	f	2025-07-29 05:51:56.813+00	0	f
1309	63	88645428	Tow shuudangiin hajuudah Smart phone deer awiy ire	5	60000.00	ireed yrih	9	f	0	bCjjtlcjMs	2025-07-29 06:58:49.693+00	2025-08-05 06:15:25.762+00	f	t	\N	utsa avaguu	f
1249	63	91710556	5шар 5байр 58тоот 4орц	3	60000.00	7сарын 27нд хүргэж өгөх	24	t	16	gSRZrbAR4f	2025-07-28 03:16:00.221+00	2025-07-30 15:10:50.855+00	f	f	2025-07-29 08:30:46.769+00	0	f
2365	26	88069048	Баянзүрх дүүрэг эрүүл мэндийн төв  ягаан өнгөөс нь	2	50000.00	yagan	66	f	0	Hc2o54RJkw	2025-08-26 01:46:06.336+00	2025-08-26 04:35:26.807+00	f	f	\N	0	f
2311	77	86013366 	Москва хороолол	2	20000.00	7р байр 74 тоот	9	f	0	xEKkqSPMMQ	2025-08-25 13:59:58.198+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
1139	20	99154081	3-р эмнэлэг, Мэдрэлийн мэс заслын тасаг	3	1.00	төлбөр авахгүй	9	f	0	GDtRRsQvEG	2025-07-24 05:12:26.443+00	2025-07-25 10:42:26.738+00	f	f	2025-07-25 10:42:26.738+00	0	f
1066	10	88014571	tomor zam 60r bair 99854774	5	76000.00	uhaalag tsag	3	f	0	zKuywSHKLX	2025-07-23 07:14:48.625+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1022	61	99482248	Ховд аймаг	3	0.00	Ногоон сойтог-1ш Саарал сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-2ш	66	f	0	qQ4xt8bXd7	2025-07-23 03:38:52.972+00	2025-07-23 10:53:10.57+00	t	t	2025-07-23 10:53:10.57+00	0	f
1182	21	85259917	BZD 41 horoo jukoviin talbain zuun hoino 8r bair 2 orts 5dav 30toot	3	0.00	Bilgune-d. kodgui	14	t	14	xH230ef4mO	2025-07-25 13:54:07.818+00	2025-07-27 04:04:40.905+00	t	f	2025-07-26 11:35:16.342+00	0	f
1011	61	88023828	ХУД 10- р хороо нийсэхийн тойргийн баруун талд  Сод монгол колонк өнгөрөөд замын урд  Пирамид хотхон 296- р байр 1 орцтой 11 давхарт 93 тоот	3	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	3	f	0	IEK9XbVDW5	2025-07-23 03:24:17.736+00	2025-07-23 12:36:42.064+00	t	f	2025-07-23 12:36:42.063+00	0	f
1040	10	99439198	grand plaza 3 davhar 326	5	45000.00	am zailagch 	50	f	0	Vj74imbX49	2025-07-23 06:35:18.857+00	2025-07-24 14:17:48.151+00	f	f	\N	0	f
1033	60	80032735	Хаяг: Баянгол дүүргийн Засаг даргын Тамгын газрын баруун талд Баянгол дүүргийн прокурорын газар.	3	0.00	төлбөр төлсөн 5 дахь өдөр хүргүүлнэ	9	f	0	2pskJH4S3U	2025-07-23 05:37:51.115+00	2025-07-26 06:23:20.168+00	f	f	2025-07-25 09:03:12.748+00	0	f
336	23	90858818	Baynhongor aimag	3	0.00	g18 hundlun 	9	f	0	HCAm0pEQM9	2025-07-03 10:55:05.134+00	2025-07-10 12:29:56.871+00	t	t	2025-07-10 12:29:56.871+00	\N	f
1205	58	99029377	төмөр зам, зүтгүүрийн депо	3	70000.00	Сүүдрэвч шар 3х4.5. Боломжтой бол 14:30-аас өмнөхөн авна.	9	f	0	WaEdSvqwwk	2025-07-26 10:44:41.888+00	2025-07-27 06:44:54.667+00	f	f	2025-07-27 06:44:54.667+00	0	f
294	23	99138266	Алтжин бөмбөгөрийн урд байр 1-20 	3	59900.00	i4 tom 	9	f	0	DwD9ZzPnDJ	2025-07-02 11:19:51.554+00	2025-07-09 07:37:34.765+00	f	f	2025-07-09 07:37:34.765+00	\N	f
328	23	88006910	Энхжин худалдааны төвийн 2 давхарт 	3	44900.00	m5	9	f	0	ZMn9cYJ5hK	2025-07-03 10:52:04.165+00	2025-07-09 07:38:08.72+00	f	f	2025-07-09 07:38:08.72+00	\N	f
1247	63	99362916	эрдэнэт аймгийн унаанд тавих	3	60000.00	7сарын 26нд унаанд тавих	3	t	16	2JiSnAbOb8	2025-07-28 03:10:00.931+00	2025-07-30 15:10:50.855+00	f	t	2025-07-29 07:26:48.963+00	0	f
854	11	80899823	БГД-7р хороо 4-р хорооллын 12-р байр 282 тоот	3	1.00	5литрийн шингэн бордоо 1савыг хүргэж өгөх. Хүргэлтийн мөнгө авсан.	14	f	0	ibzPeooRxN	2025-07-09 05:07:01.719+00	2025-08-01 11:46:29.634+00	f	f	2025-08-01 11:46:29.634+00		f
278	23	95703948	Модны 2  гантьн 40 рбайр2 тоот	3	39900.00	PK	9	f	0	CnOQsFQozk	2025-07-02 11:13:07.059+00	2025-07-09 11:19:38.287+00	f	f	2025-07-09 11:19:38.287+00	\N	f
288	23	99006887	БГД 19 р хороо 58-31 тоот Парадоксын урд	3	59900.00	i3 tom 	9	f	0	lUyohvhheq	2025-07-02 11:17:35.747+00	2025-07-09 11:32:11.283+00	f	f	2025-07-09 11:32:11.283+00	\N	f
290	23	99070278	4r horoolol modnii 2 amure zochid buudlaas baruun tiish  4 zamiin uulzvar 2 tsenher 12 davhar ugsarmal bair 63 r bair ni. Ireed zalgahad bno oo /17 цагаас хойш авах/	3	79800.00	PK GR 2sh	9	f	0	9Krn0Vtheb	2025-07-02 11:18:21.885+00	2025-07-09 11:33:07.692+00	f	f	2025-07-09 11:33:07.692+00	\N	f
273	16	85853414	bumbuguriin urd 24 r surguuliin urd Huree hothon 23-3 bair 5 davhart26 toot	3	15000.00	baihgyi	9	f	0	boRbFHanyi	2025-07-02 08:12:25.735+00	2025-07-09 11:48:02.416+00	f	f	2025-07-09 11:48:02.416+00	\N	f
408	10	88074549	4 horoolol altan togrog delguurin ariin hunsnii zahar uruudad 52a bair 2dawhart 4toot	3	0.00	13 dawhar barilga bga	9	f	0	5WPdmwMSKx	2025-07-04 05:43:57.618+00	2025-07-09 11:58:43.273+00	t	f	2025-07-09 11:58:43.273+00	\N	f
311	16	99994454	modnii 2t duhuud zalgah	3	15000.00	baihgyi	9	f	0	5Uujlhna38	2025-07-03 03:32:15.37+00	2025-07-09 12:11:43.123+00	f	f	2025-07-09 12:11:43.123+00	\N	f
334	23	99208029	Баянгол 3-р хороо 69-28 гранд плаза урд талд	3	39900.00	PK	9	f	0	OtDv1Q5XHJ	2025-07-03 10:54:20.589+00	2025-07-09 12:14:23.671+00	f	f	2025-07-09 12:14:23.671+00	\N	f
274	16	89969689	BGD, 27r horoo,2a bair,goliin orts,4 davhart 36 toot	3	15000.00	hermesiin zuun tald	9	f	0	56K8ZmWwXT	2025-07-02 08:21:31.252+00	2025-07-09 12:26:00.717+00	f	f	2025-07-09 12:26:00.717+00	\N	f
851	2	80665806	Хан-Уул, 15-р хороо, Чингисийн өргөн чөлөө, Стадион Оргил /17011/  Режис плейс цамхаг, 8 давхар 805 тоот.	3	600000.00	50л очоод төлбөрөө авах	14	f	0	bDt0u4mOQv	2025-07-09 02:41:24.139+00	2025-07-10 03:15:42.094+00	f	f	2025-07-10 03:15:42.094+00	\N	f
852	19	86040011	Nisehiin toirog unguruud Pyramid Apartment 294-89 toot 11 dawhar	3	86000.00	төлбөр  танайх  авна\n7 цагаас хойш гэртээ байна	14	f	0	HCNJTIIa9y	2025-07-09 03:21:01.884+00	2025-07-10 06:28:31.556+00	f	f	2025-07-10 06:28:31.556+00	\N	f
604	26	88995567	Arhangai 88995567 top схд номин агуулахаас автобусанд	5	19900.00	схд орон нутаг	9	f	0	b4AOkFPYPH	2025-07-06 02:09:04.658+00	2025-07-22 04:44:21.816+00	f	f	2025-07-09 12:33:07.412+00	\N	f
853	19	99537546	Баянзүрх  16р хороолол газарчингийн 1-р байр 3-р орц 4-н давхарт 53тоот	3	0.00	15 ширхгийг хүргэх	14	f	0	Dl2h3xhPAL	2025-07-09 03:26:44.303+00	2025-07-10 12:31:37.22+00	f	f	2025-07-10 12:31:37.219+00	\N	f
1277	59	99442149	завхан улиастай	3	6000.00	а	3	f	0	HXB9ll9iWF	2025-07-28 15:27:19.201+00	2025-07-30 08:55:32.284+00	f	f	2025-07-30 08:55:32.284+00	Утсаа аваагүй	f
354	4	85859082	bayngol duureg 7-horoo eko 21-r bair 1 toot 	3	0.00	udees omno erthen baiwal sain	9	f	0	3woM3DG7Pd	2025-07-03 14:41:50.224+00	2025-07-16 07:55:44.716+00	t	f	2025-07-16 07:55:44.716+00	\N	f
814	23	88394771	БГД 33р хороо 86-1-30 тоот 	3	79800.00	g9 jijig 2sh	8	t	2	aSh5WAuSzZ	2025-07-08 12:40:03.294+00	2025-07-18 12:08:11.986+00	f	f	2025-07-10 12:27:50.817+00	\N	f
1264	59	91778210	замын үүд 	3	6000.00	б	3	f	0	9dsUEOelgf	2025-07-28 07:46:29.195+00	2025-07-29 07:26:33.61+00	f	f	2025-07-29 07:26:33.61+00	0	f
806	23	99867141	Баянгол дүүрэг 29 хороо 51-3 байр 37 тоот	3	54900.00	Lch4	14	t	2	fHSrMeHXX7	2025-07-08 12:37:09.494+00	2025-07-18 12:08:11.986+00	f	f	2025-07-10 12:32:06.308+00	\N	f
545	26	88296595	88296595 1 р хороолол 34 гүүрэн дээр ирээд залгах тор	5	19900.00	1 horoolol	9	f	0	SEEtUWPPMc	2025-07-05 23:56:24.792+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
1117	58	99466488	Хүүхдийн 100, төрийн банк	3	70000.00	258ш-тэй minecraft.	14	t	9	FSkLRVt8sV	2025-07-23 11:06:30.204+00	2025-07-25 06:15:33.973+00	f	f	2025-07-24 04:27:07.816+00	0	f
1183	21	99914090	BZD 26 horoo TIMETOWER hothon 218 bair zara delguur deer	3	0.00	Gansuvdiin duud uguh	14	t	14	HosWc274g9	2025-07-25 13:55:07.662+00	2025-07-27 04:04:40.905+00	t	f	2025-07-26 13:32:55.015+00	0	f
2312	77	88019249 	 21 horoolol 62surguulin baruun urd tald amni oron suuts	2	22000.00	5r 58 bairni baruun tald 	9	f	0	hojRS9zwUy	2025-08-25 14:01:05.096+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
1691	59	80747695	хүнсний 1	3	70000.00	ирэхээсээ өмнө залгах	9	f	0	cRbeEUOlIG	2025-08-14 08:44:24.914+00	2025-08-15 05:57:27.991+00	f	f	2025-08-15 05:57:27.991+00	0	f
1140	20	88199486	Зуун айл, шинэ зам дагуу New residence хотхон, 722 байр ()	5	1.00	төлбөр авахгүй\nочихоосоо өмнө залгаарай	14	f	0	6DaU08L40H	2025-07-24 05:13:11.9+00	2025-07-25 12:02:02.224+00	f	f	\N	tsitsalsan	f
1163	58	99364007	40-р агуулахаас очиж авна.	3	85000.00	Сүүдрэвч шар 4.5х4.5. Агуулахтай ойрхон үлдээхэд болно. Очоод авна.	9	f	0	QjzvFPQayH	2025-07-25 05:08:20.33+00	2025-07-25 14:38:27.898+00	f	f	2025-07-25 14:38:27.898+00	0	f
1293	19	99344440	Нарантуул захын гэрлэн дохиотои улзварын баруун талд байрлах ДОКТОР АВТО засварын баруун талаар жижиг туслах замаар хойшоо 100м яваад 3YYH гар талд улаан тоосгон 5 давхар 67-р байр.	5	86000.00	төлбөр  танайх  авна.	67	f	0	k1FKC16U9n	2025-07-29 03:26:27.563+00	2025-07-29 06:35:40.557+00	f	f	\N	0	f
1041	10	88420842	sapporod 4r sakura vschind 	5	64000.00	hvzvvnii zvvlt 	3	f	0	xFtMY87XKD	2025-07-23 06:36:12.803+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1067	10	80087621	BGD 1r horoo142 bair	5	76000.00	uhaalag tsag	3	f	0	DNAQ1BdDGF	2025-07-23 07:19:30.784+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1092	10	88845918	ulsiin ih delguurt 3 hurgelt	5	161000.00	gold collagen eemeg gun tsewerlegch	3	f	0	Vt1QoTzyiU	2025-07-23 09:00:05.935+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1276	59	88644546	СБД 12 хороо 9 р дэлгүүр 	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	yWsxgmz53Q	2025-07-28 15:25:45.093+00	2025-07-29 08:58:12.057+00	f	f	2025-07-29 08:58:12.057+00	0	f
1333	63	99630746	радио-22 372 тоот	5	60000.00	радио-22 372 тоот	9	f	0	NutReTwN1G	2025-07-30 03:14:17.259+00	2025-08-03 05:43:45.084+00	f	f	\N	avahguu gesen	f
1289	63	88735877	Дэнжийн 1000, Нарантуул 2 зах, Оргил зоогийн газар	3	60000.00	88005947 Өглөө 8-18 цагийн хооронд байх хаяг	9	t	16	RogU3ZvTZB	2025-07-29 02:20:42.922+00	2025-07-30 15:10:50.855+00	f	f	2025-07-29 08:39:42.018+00	0	f
529	23	88475548	Дарханы унаанд тавих 	3	0.00	m2 780, PK GR	9	f	0	gEkWW03Bgd	2025-07-05 12:42:56.76+00	2025-07-09 07:37:48.096+00	t	t	2025-07-09 07:37:48.096+00	\N	f
1227	4	88179987	Бөхийн өргөөний зүүн талд 3 өндрийн урд талын 5-р байр 2-р орц 6 давхарт 58 тоот	3	1.00	.	67	f	0	xExI2OjrHK	2025-07-27 08:32:32.151+00	2025-07-29 15:47:10.677+00	f	f	2025-07-29 15:47:10.677+00	0	f
565	2	89093161	СХД 20р хороо Оюу төв 2 давхарт авна	3	500000.00	30Л очоод мөнгөө авах	9	f	0	4MmxZGs0zn	2025-07-06 01:13:20.761+00	2025-07-09 11:27:39.192+00	f	f	2025-07-09 11:27:39.192+00	\N	f
553	26	96224262	96224262 orbitiiin toirogruu duhuud zalgah tsaanas irj awna tor	5	19900.00	CX duureg	9	f	0	P6MXmchAtG	2025-07-06 00:14:11.609+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
554	26	99229007	99229007 bayanhoshuu toirog duhuud zalgah ahjuuhan ni baidag zaagad ugie gene tor	5	19900.00	bayanhoshu	9	f	0	NCD91J3PlQ	2025-07-06 00:30:55.289+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
1302	6	94265573	7 buudal	3	0.00	ochigdor	9	f	0	xrKY5ml2qs	2025-07-29 05:50:23.693+00	2025-07-29 05:52:17.291+00	t	f	2025-07-29 05:52:17.291+00	0	f
399	16	88024249	horooliin etses emartiin urd tald havai 38r bair 7 davhart 74 toot ortsnii kod4321#	3	15000.00	bhgyi	9	f	0	lqk3sDQswY	2025-07-04 02:34:51.687+00	2025-07-09 11:51:39.431+00	f	f	2025-07-09 11:51:39.431+00	\N	f
317	19	99048818	Дарханы автобусанд	3	86000.00	автобусны  цаг дугаарыг нь авах. төлбөр танайх авах	9	f	0	rdxve2tash	2025-07-03 04:38:57.603+00	2025-07-09 12:03:26.534+00	f	f	2025-07-09 12:03:26.534+00	\N	f
530	23	80103907	5 шар залуус хороолол М-маркет дэлгүүрт  үлдээчих	3	39900.00	g40 jijig	9	f	0	JeKHl3ciLt	2025-07-05 12:43:20.121+00	2025-07-09 12:18:38.953+00	f	f	2025-07-09 12:18:38.952+00	\N	f
528	23	95010959	Өвөрхангай Арвайхээр орой 19 цагаас явах автобусанд	3	0.00	Lch9	9	f	0	4wY2iKXOU5	2025-07-05 12:42:21.351+00	2025-07-16 07:57:43.636+00	t	t	2025-07-16 07:57:43.635+00	\N	f
525	23	88652120	Shd 65 r surguuli gerlen dohiotoi uulzwar	3	44900.00	pic mat	9	f	0	cPttSCqN0Q	2025-07-05 12:41:09.925+00	2025-07-16 07:58:28.512+00	f	f	2025-07-16 07:58:28.512+00	\N	f
481	26	99170228	99170228 bumburiin urd  huduu aj ahiun 30ail deer iped zalgh  top	5	20000.00	ok	9	f	0	4zWYQ72MAa	2025-07-05 02:06:15.133+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
527	23	88043290	Схд 19 хороо содон хороолол монос эмийн санд	3	44900.00	pic mat	9	f	0	Kky5TpzuNg	2025-07-05 12:41:51.006+00	2025-07-16 08:00:55.961+00	f	f	2025-07-16 08:00:55.961+00	\N	f
1226	58	89119406	БГД, 5р хороо, 122р байр, 2р орц, 8 давхар, 808 тоот. 3р эмнэлэгийн зүүн талын сүмийн ар талын 15 давхар байр.	3	70000.00	248ш minecraft-1ш. Орцны код 4959#	24	f	0	BhFX4eX1YU	2025-07-27 08:31:53.231+00	2025-07-29 07:11:37.156+00	f	f	2025-07-29 07:11:37.156+00	0	f
714	16	80004435	Chingeltei duureg 7 buudal altan delgurt	5	15000.00	baihgyi	9	f	0	5sJg9eRzIs	2025-07-07 07:25:28.596+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
532	26	99039391	99039391  Baynhoshuu hutuliin doodoh tsegeennuuriin buudal deer tsegeennuur supermarket  top	5	20000.00	баянхошуу	9	f	0	K2Ku3cCxA0	2025-07-05 17:14:59.477+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
513	16	99356677	modnii 2iin 34-24t	5	15000.00	baihgyi	9	f	0	VlCP9sDy4H	2025-07-05 05:40:41.252+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
520	16	80240028	tengis 12 r bair 4 toot	5	15000.00	baihgyi	9	f	0	5ZlneV7JLl	2025-07-05 08:59:00.358+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
1317	58	99671863	10 хороолол хермесийн баруун талд мая таун хотхоны 113 байр 1 орц 6 давхарт 36 тоот код 1719#	3	75000.00	Ванны тоглоом багц-1	3	f	0	QUJrmaqytQ	2025-07-29 08:41:39.768+00	2025-07-30 07:54:02.132+00	f	f	2025-07-30 07:54:02.132+00	0	f
1321	21	88043483	horoololiin etsets 32-56 toot	3	0.00	erka-d	9	f	0	5kuIBbNtPg	2025-07-29 17:31:28.842+00	2025-07-30 10:40:49.64+00	t	f	2025-07-30 10:40:49.64+00	0	f
1241	63	99974499	narnii horoolol 18r bair 10 davhar 1005 toot 	3	60000.00	  	3	t	16	QzwD73Hfj6	2025-07-28 02:16:42.875+00	2025-07-30 15:10:50.855+00	f	f	2025-07-29 10:47:32.419+00	0	f
1265	58	88539341	Нарантуул зах зүүн хойд тал Цагаан хуаран хотхон	3	70000.00	Сүүдрэвч шар 3х3. 18:00 цагаас өмнө авна. Залгахаар гарч ирээд авна.	67	f	0	eHCbqjAHYD	2025-07-28 07:58:41.595+00	2025-07-30 15:23:16.303+00	f	f	2025-07-29 15:46:57.261+00	0	f
770	26	99007942	99007942 zaisan ub town barun ubtown hoid orts 6 dawhar t ezgui baiwal delguurt uldeeged dansa yawuulahd bolnoo tor	5	19900.00	hud	9	f	0	hzeMKpMUh0	2025-07-08 00:44:05.167+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
784	10	96099292	BZD, Sansarin Home plazagin zuun talin MT kolonkin arin 5 davhar bairnii 5 davhart, 19 toot	5	35000.00	ygaan1 sh tsenher 1sh ogoh 	9	f	0	fFqibumdxy	2025-07-08 01:40:15.459+00	2025-07-22 04:44:21.816+00	f	f	2025-07-08 13:49:53.309+00	\N	f
771	17	88070697	Орбитын тойрог дээр	5	1950000.00	камэр	9	f	0	eEKc9PIhnW	2025-07-08 00:44:51.019+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
762	26	80060360	80060360-yarmag titan center urd arwai villa 737bair 15toot	5	19900.00	yarmag	9	f	0	6pWMaEL1oj	2025-07-07 23:28:18.847+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
774	26	99099903	99099906 3 tsahilgaan stants der top	5	19900.00	tets 3	9	f	0	K41coSccoF	2025-07-08 00:55:16.46+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
789	23	80653965	Бзд Халдвартын эмнэлэгийн арын Цempaл молл 11 байр 80653965	5	39900.00	g41 jijig	9	f	0	9SGhPaACob	2025-07-08 02:15:10.141+00	2025-07-22 04:44:21.816+00	f	f	2025-07-08 08:01:12.994+00	\N	f
948	10	99407576	hud nisehin arivchin togs orchin 1218r bair 	5	76000.00	uhaalag tsag1sh	9	f	0	cD5qGeM7DX	2025-07-21 03:45:29.222+00	2025-07-22 04:44:21.816+00	f	f	\N	0	f
761	26	88150073	88764545-19horoolol 23surguulin urd 88150073 ene dugaarlu yrij uguh	5	19900.00	hud	9	f	0	AhCAsGdd03	2025-07-07 23:27:41.995+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
949	10	80591175	hud 25 horoo buynt uhaa 1 728-1toot 76057992 17s hoish	5	65000.00	emegtechuudin kapsul	9	f	0	lFdPWM08v0	2025-07-21 03:47:54.144+00	2025-07-22 04:44:21.816+00	f	f	\N	0	f
943	10	88374422	hud 25horoo 611bair 32toot	5	65000.00	gun tsewerlegch 2sh	9	f	0	mceSM6XjzD	2025-07-21 03:31:09.046+00	2025-07-22 04:44:21.816+00	f	f	\N	0	f
791	2	86006376	Офицер Алдар спорт хороо зам дагуу 10к 12 давхар шар байр 4 давхарт 10тоот	5	450000.00	20л очоод тооцоогоо авна	9	f	0	jq2tpv9FoH	2025-07-08 02:27:53.464+00	2025-07-22 04:44:21.816+00	f	f	2025-07-08 13:50:15.663+00	\N	f
795	26	91999802	91999802 hanuul team internatiol haruul der awna top	5	19900.00	hud	9	f	0	6SwBdFdEpm	2025-07-08 02:53:31.179+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
829	22	99491223 Код:7	Сүхбаатар аймаг	5	80000.00	Тэнгэр плазагаас унаанд тавина. Хүргэлт6к+80.000	9	f	0	DZW1e5DIzq	2025-07-08 14:46:28.802+00	2025-07-22 04:44:21.816+00	f	t	\N	\N	f
793	26	90505511	90505511 hanuul nova vista 1458bair 2opts 8daw 802toot	5	19900.00	hud	9	f	0	rN2ibWn83U	2025-07-08 02:34:47.282+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
844	26	88737321	88737321 hud misheel hothon 94a bair 1opts 3daw 14toot to p	5	19900.00	hud	9	f	0	nmWbL4mzT4	2025-07-09 01:09:11.206+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
1164	2	88869996	sh duuregtoosgo5-61toot 30 l	3	500000.00	onoodor zaawal awna	14	f	0	NV7MCZ04vZ	2025-07-25 05:08:31.893+00	2025-07-25 13:12:19.681+00	f	f	2025-07-25 13:12:19.68+00	0	f
1093	10	99081881	chd 4horoo hiimori tsogtsolbor 4/6  A20 toot	5	45000.00	tsairuulah tos 1sh	3	f	0	p1OabcZmQM	2025-07-23 09:02:38.96+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
766	26	99104837	99104837 gurvaljin delgerh hothon urd nogoon hashaan dotor awna top	5	19900.00	tets e	9	f	0	w86C3JX3VR	2025-07-08 00:41:58.688+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
756	26	91234279	91234279 хан уул 23 хороо нүхт грийн гарден 721 байр 1601 тоот тор	5	19900.00	yarmag	9	f	0	BeGHz1bvTd	2025-07-07 23:23:31.655+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
759	26	99901956	99901956-yarmag shunshig villa2 57a bair 12dawhar 66toot tor	5	19900.00	Yarmag	9	f	0	49CpWkXIS1	2025-07-07 23:25:36.275+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
713	16	99966953	darhanii unaand tavina	5	15000.00	baihgyi	9	f	0	ntXC3W4xsZ	2025-07-07 07:16:31.811+00	2025-07-22 04:44:21.816+00	f	f	2025-07-08 11:58:00.635+00	\N	f
715	4	89111045	ЧД 4-р хороо Хүнсний 1-р дэлгүүрийн зүүн талын хуучны 3-н давхар шар ногоон 11-р байр 3-30 тоот (Орц код-881B)	5	1.00	.	9	f	0	AtdVYOj9Ty	2025-07-07 07:45:23.629+00	2025-07-22 04:44:21.816+00	f	f	2025-07-09 11:48:27.914+00	\N	f
659	23	99059624	галлериа улаанбаатар ажлын цагаар авая	5	54900.00	Lch9	9	f	0	DmWo9mOMSN	2025-07-06 12:47:33.775+00	2025-07-22 04:44:21.816+00	f	f	2025-07-09 11:49:02.559+00	\N	f
635	2	99546442	Дэнжийн 1000	5	1.00	50Л энэ дугаарлуу залгаад хүргэж өгнө 86682878	9	f	0	nFPtjjN2Vd	2025-07-06 05:28:42.313+00	2025-07-22 04:44:21.816+00	f	f	2025-07-16 08:00:25.417+00	\N	f
760	26	89097121	120 myangat 20 bair 70 toot tor	5	19900.00	hud	9	f	0	tvZqnZDhgB	2025-07-07 23:26:29.688+00	2025-07-22 04:44:21.816+00	f	f	\N	\N	f
1042	10	99824908	narnii horoolol 23 bair 	3	65000.00	emegteichvvdiin kapsul 	65	f	0	4QzByTJS6P	2025-07-23 06:37:03.442+00	2025-07-23 08:28:32.264+00	f	f	2025-07-23 08:28:32.264+00	0	f
1013	61	99877496	"Кино үйлдвэр Полирс  хотхон 57а 904 тоот"	3	0.00	Ногоон сойтог-1ш Саарал сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-2ш	24	f	0	1y7UwiT3Ee	2025-07-23 03:26:09.065+00	2025-07-23 11:25:36.301+00	t	f	2025-07-23 11:25:36.301+00	0	f
1118	58	88037054	40-р байр агуулах очиж авна.	5	55000.70	3х3(55'000₮) эсвэл 3х4.5(70'000) хэмжээтэй сүүдрэвчнээс үзэж байгаад авна.	\N	f	0	fkpLJzBtWd	2025-07-23 11:57:34.786+00	2025-07-25 05:14:36.774+00	f	f	\N	0	f
1068	10	99110357	baruun 4 zam golomt hothonc-92 toot 99169289	3	55000.00	zowhinii tos 2 shirheg	14	t	8	XngecVk1QW	2025-07-23 07:21:32.81+00	2025-07-25 06:15:20.103+00	f	f	2025-07-23 09:06:20.228+00	0	f
1184	21	96168690	SBD 11 horoo 709 bair 8d 36 toot. go to marketiin hoino	3	0.00	kod- b0852. hongorzul-d	14	t	14	CN5AZKwWnX	2025-07-25 13:56:47.393+00	2025-07-27 04:04:40.905+00	t	f	2025-07-26 12:16:31.632+00	0	f
1228	4	86004108	Зайсан Түшээ Гүн хотхон 108-1тоот	3	1.00	.	3	f	0	wDSticCqyA	2025-07-27 08:35:59.211+00	2025-07-29 09:01:47.723+00	f	f	2025-07-29 09:01:47.723+00	0	f
2313	77	86112737 	bayr hoshuuni toirog shunhlai klonk 	2	22000.00	80812747 	9	f	0	cFTsfsdvqU	2025-08-25 14:01:32.378+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
1141	4	86700066	Өвөрхангай Хархорин сум	3	1.00	.	9	t	15	qcLxbGNAi2	2025-07-24 05:28:04.414+00	2025-07-27 05:28:48.894+00	f	f	2025-07-26 09:52:08.637+00	0	f
1206	10	88064537	test	5	1000.00	test	24	f	0	CyoETGsNvC	2025-07-26 12:06:55.782+00	2025-07-29 04:59:48.045+00	f	f	\N	tsutsalsan	f
1236	52	89116652	Buynt uhaa 1-n hoino Niseh86 bair	3	6000.00	Zalgah	3	f	0	5WVVIa8yQ1	2025-07-27 18:05:10.94+00	2025-07-29 12:14:33.235+00	f	f	2025-07-29 12:14:33.235+00	0	f
1311	63	88302719	Депо 52-р байр, 2орц 8 давхарт 112 тоот	5	60000.00	07сарын 30нд 12-14цагийн хооронд 	14	f	0	EUtROTf0B3	2025-07-29 07:05:08.464+00	2025-08-03 05:10:50.049+00	f	f	\N	tsutalsan	f
1303	6	95683171	horoolol 58 bair 	3	0.00	mbf	9	f	0	s6DfD2W7CA	2025-07-29 05:51:03.108+00	2025-07-29 05:52:21.711+00	t	f	2025-07-29 05:52:21.711+00	0	f
1234	52	99686468	HUD 23r horoo Shine hotiin zahirgaa Agarta Residence 1425 bair 1 orts 302 toot	3	6000.00	b	3	f	0	T5GkikmT8W	2025-07-27 18:03:40.23+00	2025-07-29 12:32:30.714+00	f	f	2025-07-29 12:32:30.713+00	0	f
1318	18	99797971	сбд, 1 хороо буянгын зам дагуу сэлбэ комфорт 52р байр	3	36000.00	топ	9	f	0	tni7gUgNpL	2025-07-29 09:27:35.815+00	2025-07-30 11:09:17.896+00	f	f	2025-07-30 11:09:17.896+00	0	f
1119	58	88800098	Хархорин захын зүүн талын Эрин хороолол. 52/13 байр, 12 давхар, 57 тоот	3	55000.70	Сүүдрэвч ногоон 3х3(55'000₮), шар 3х4.5(70'000₮) 2ш сүүдрэвчнээс сонгож авна.	9	t	11	O3Aa4rG0L8	2025-07-23 12:00:27.543+00	2025-07-25 06:17:06.424+00	f	f	2025-07-24 09:24:52.322+00	0	f
150	16	90134390	говь алтайн унаанд тавина	5	15000.00	унаанд тавиад тооцоогоо авах	9	f	0	vN243jY4sI	2025-07-01 03:16:46.309+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
271	16	99133692,99138556	BGD, 18 r horoo 46r bair3 orts 2 davhart 80 toot	5	15000.00	1 shirheg avna	9	f	0	41SdfaHa6k	2025-07-02 05:09:19.572+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
310	16	89283809	umnugovi unaand tavih	5	15000.00	baihgyi	9	f	0	fP08x8n7uO	2025-07-03 03:31:42.846+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
567	19	89116995	Чд 4р хороо НҮБ баруун талд борхош кафе	5	86000.00	төлбөр  танайх	9	f	0	vN3fkxYnpJ	2025-07-06 01:16:07.5+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
355	26	99303014	бгд 5 хороо 10 р хороолол 7б байр 27 тоот тор	5	28000.00	ок	9	f	0	T8Ztdrj4cd	2025-07-03 14:57:59.895+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
514	16	88856239	SHD 19 r horoo Nobel apartment 46r bair 1 orts 4 davhart 401 toot	5	15000.00	baihgyi	9	f	0	uPBzk2oUii	2025-07-05 05:44:08.447+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
571	26	88653500	88653500 tolgoit 65surguuliin avtusnii buudal der iphed garaad awchih n top	5	19900.00	CX Duureg	9	f	0	cxCiRzToZ5	2025-07-06 01:25:57.602+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
538	26	80402222	80402222 схд Орчлон хороолол 46 байр 136 тоот 7 давхар 2орц тор	5	20000.00	21 хороолол	9	f	0	WPXkEIEYPE	2025-07-05 17:19:14.61+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
537	26	99176646	99176646 сонсголон моносын уулзвар схд оношогооны замд 2. Давхар шаттай дэлгүүр кристал лайп дэлгүүр хажуудаа халуун устай тор	5	20000.00	сонсголон	9	f	0	267l5k0Tpb	2025-07-05 17:18:40.915+00	2025-07-22 04:44:48.285+00	f	f	\N	\N	f
1280	59	88511415	БГД 33 р хороо 67А байр 	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	La42WzOpk5	2025-07-28 15:30:33.764+00	2025-07-29 10:49:24.138+00	f	f	2025-07-29 10:49:24.138+00	0	f
1069	10	99193927	10r horoolol 41-32 toot 99171752	1	99000.00	zowhinii tos	\N	f	0	OwkJFNbNKA	2025-07-23 07:24:22.746+00	2025-07-23 07:25:24.132+00	f	f	\N	0	t
1094	10	99250725	chingelte duureg 19 horoo deed salhit 3.49 12os omno	5	79000.00	mital ilruulegch 1sh 	3	f	0	7gMVlCv6bV	2025-07-23 09:04:30.445+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
1043	10	99840109	BGD 1-khoroo Anduud panasonic bairnii 2r davhar spa massage 	5	45000.00	am zailagch 	3	f	0	LyGhu8k1Dx	2025-07-23 06:38:35.803+00	2025-07-24 04:20:40.425+00	f	f	\N	0	f
2314	77	95585307 	 gemtlin emneleg narlag hothon	1	20000.00	105 r bair 1davhar 11toot  	\N	f	0	SuxKJRJe4T	2025-08-25 14:01:59.408+00	2025-08-26 03:55:56.635+00	f	f	\N	0	t
1150	58	99031818	Чулуу овоо сансрын эсрэг талын карго буудаг хашаанаас Сүхбаатар төврүү унаанд тавьж өгнө.	3	85000.00	Сүүдрэвч шар 4.5х4.5\nСүүдрэвч дээрээ авах хүний утсын бичээд өгөөрэй. 99031818	14	f	0	7BEEs8BFOs	2025-07-24 08:07:48.121+00	2025-07-25 10:14:13.14+00	f	f	2025-07-25 10:14:13.14+00	0	f
888	52	94012888	Tumur zam 20r surguuliim urd bathaan zochid buudliin baruun talf 13 r bair 3-31 toot	3	0.00	Solongo	14	t	3	vHdwCDvaDo	2025-07-19 08:34:09.972+00	2025-07-22 05:03:44.782+00	f	f	2025-07-20 06:01:52.707+00	0	f
2368	62	99904450	Икс апартмэнт с блок 78 тоот	2	1.00	8/26-ны захиалга	66	f	0	MRTdrartQG	2025-08-26 02:28:26.034+00	2025-08-26 05:22:34.569+00	f	f	\N	0	f
1650	62	9507 7276	Ard kino teater 23r surguuliin zuun tald jur urtei hashaa 40bair 36toot kod 36b	3	1.00	Аль болох эртхэн авъя гэсэн.	9	f	0	mJL1FrDv1Q	2025-08-13 10:56:09.181+00	2025-08-14 06:11:22.579+00	f	f	2025-08-14 06:11:22.579+00	0	f
1185	63	94112728	зайсан оргил 63байр 1орц 1тоот 	3	60000.00	 	9	t	15	0QppTWPZJL	2025-07-26 01:02:33.173+00	2025-07-27 05:28:48.894+00	f	f	2025-07-26 13:56:19.31+00	0	f
1014	61	88205182	"Налайхын унаанд тавиаад   жолоочд нь хэлээд гордокт  өгөх юмаа гээд болноо"	3	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	14	t	9	p9r7oV1vVi	2025-07-23 03:27:26.056+00	2025-07-25 06:15:33.973+00	t	t	2025-07-24 06:00:21.732+00	zugeer l margaash avna gsen odoo avahq	f
1142	61	99877496	"Кино үйлдвэр Полирс  хотхон 57а 904 тоот"	3	0.00	Буцаалт 	14	t	9	9er92AHpx3	2025-07-24 06:56:24.106+00	2025-07-25 06:15:33.973+00	t	f	2025-07-24 12:04:56.542+00	0	f
1294	63	88818940	20-р хороо Хан-уул товерын арын 13 давхар 32 байр 9-217 тоот	5	60000.00	  	3	f	0	zvxOF7qvUJ	2025-07-29 03:47:13.95+00	2025-08-02 09:25:14.09+00	f	f	\N	bolison	f
1648	19	88953593	suhbaatar duureg 11r horoo 11b bair 28 toot 88953593	3	86000.00	төлбөр танайх авна	9	f	0	YdAQPHj6wV	2025-08-13 10:12:24.085+00	2025-08-14 08:44:43.193+00	f	f	2025-08-14 08:44:43.193+00	0	f
1178	63	86600555	BZD, 37-r horoo, Baganat Urgoo, 404-r bair, 5 davhar, 57 tot. Yaraltai 5.20nd amjuulj avna.	3	60000.00	Яаралтай хүргүүлж авна	14	t	16	Cydk0hGQ2v	2025-07-25 08:06:03.873+00	2025-07-30 15:10:50.855+00	f	f	2025-07-27 08:50:34.165+00		f
1260	59	99211875	Өмнөговь аймаг 	3	6000.00	дугаар луу нь жолоочийн дугаар машины номер явуулна 	24	f	0	NREQLFVaMf	2025-07-28 07:37:10.185+00	2025-07-29 07:44:56.343+00	f	f	2025-07-29 07:44:56.343+00	0	f
1219	19	96055198	Чингэлтэй дүүрэг 2р хороо Барилгачидын талбай  дулаан граж 96055198	5	860000.00	төлбөр  танайх  авна	9	f	0	dui9xXFFGi	2025-07-27 07:41:42.897+00	2025-07-29 06:16:05.637+00	f	f	\N	0	f
1224	58	96665161	7 буудал	5	45000.00	Усан буу-1ш. очихоосоо өмнө залгаарай. Цаанаас лагераас ирж тосч авна.	9	f	0	40kxXdnHhV	2025-07-27 08:26:02.302+00	2025-07-30 05:50:53.388+00	f	f	\N	avahaa bolison	f
1693	59	99648497	3 4 р хорооллын өргөөгийн хойно байдаг Жүр үр bakery 2 давхар 	3	0.00	ирэхээсээ өмнө залгах	69	f	0	zhic3c7Dbj	2025-08-14 08:46:26.354+00	2025-08-15 07:46:04.187+00	f	f	2025-08-15 07:46:04.187+00	0	f
1256	63	89113745	3r emneleg iin ard  enerel 4iin 9 	5	60000.00	  	24	f	0	tdel9J7VzY	2025-07-28 06:42:57.418+00	2025-07-29 13:55:05.92+00	f	f	\N	авцан байсан 28нд	f
1319	18	91159988	Натурын замаар Ub tower 5 dawhar 508toot	3	36000.00	top ajliin tsagaar	9	f	0	nc3YffUM7H	2025-07-29 09:29:03.537+00	2025-07-30 05:18:21.911+00	f	f	2025-07-30 05:18:21.911+00	0	f
1320	4	99112800	зайсан ,Bella Vista хотхог ,700-р байр 901-тоот	3	1.00	.	3	f	0	dHZLcKmnjm	2025-07-29 14:21:01.022+00	2025-07-30 10:52:48.082+00	f	f	2025-07-30 10:52:48.081+00	0	f
1200	63	95381568	Сүхбаатар дүүрэг 5н буудал мини ногоон дэлгүүр дээр ирээд залгах	3	60000.00	 	14	t	16	UrAWyZ1ntT	2025-07-26 06:14:12.128+00	2025-07-30 15:10:50.855+00	f	f	2025-07-27 10:42:14.964+00	0	f
1284	21	88893038	BZD 42 horoo Nart hothon 94b bair 1-2 toot. Temuulen delguuriin kassnii hund uguh	3	0.00	tseren-d. Temuulen delguurnii kass-d	67	f	0	r4ecJk0C5E	2025-07-29 01:15:07.36+00	2025-07-29 15:41:39.614+00	t	f	2025-07-29 15:41:39.614+00	0	f
1278	59	85206069	10 р хороолол 80а байр 1р орц 13 давхар 97 тоот code 1#851	5	6001.00	ирэхээсээ өмнө залгах	3	f	0	h9THbgtrhr	2025-07-28 15:28:25.09+00	2025-07-30 14:57:27.79+00	f	f	\N	bolison	f
1651	59	88660631	ХУД 19 р хороолол 52 сургуулийн хойд талд 33 саарал байр 1 давхар 46 тоот зүүн талын бор хаалга	3	0.00	ирэхээсээ өмнө залгах	9	f	0	5OJO8ggIz1	2025-08-13 12:35:30.127+00	2025-08-14 04:25:31.559+00	f	f	2025-08-14 04:25:31.559+00	0	f
1657	4	85277130	ЧД 1р хороо 35р байр 6орц 71 тоот Тэди төвийн зүүн урд	3	1.00	.	9	f	0	8FD2xmivMb	2025-08-13 16:15:11.403+00	2025-08-14 05:57:02.675+00	f	f	2025-08-14 05:57:02.675+00	0	f
1662	52	96369707	Turiiin Tusgai alban haagchidiin negdsen emnelegt ( talbain baruun tald)	3	6000.00	5:30 hvrtel baina	9	f	0	FHLZdcLMMi	2025-08-13 18:43:11.389+00	2025-08-14 06:28:57.696+00	f	f	2025-08-14 06:28:57.696+00	0	f
1663	52	99035477	100 ail khangai hothon ertontsiin zvger zvvn taliin 546r bair	3	6000.00	Ochod zalgah	9	f	0	gadnfcEwkt	2025-08-13 18:44:00.131+00	2025-08-14 09:05:31.731+00	f	f	2025-08-14 09:05:31.731+00	0	f
1646	19	Холбоо барих утас 88425939	Хан уул 16хороо элеганс хороолол 909р байр 16тоот	3	86000.00	төлбөр танайх авна	9	f	0	Sdn5OVHH4p	2025-08-13 07:55:23.476+00	2025-08-14 12:27:36.636+00	f	f	2025-08-14 12:27:36.636+00	0	f
1695	59	85525989	БЗД 22р хороо дэлгэрэх apartment 103a 1дүгээр орц 9 давхар 3060	3	0.00	ирэхээсээ өмнө залгах	14	f	0	joc4yJbYcj	2025-08-14 09:01:29.322+00	2025-08-15 12:57:48.036+00	f	f	2025-08-15 12:57:48.035+00	0	f
1770	52	80401100	Jukowiin hushuunii zuun hoino RomeoJuliet hothon 46a bair 8-67 toot	3	6000.00	w	9	f	0	mhMWDbVciM	2025-08-15 17:54:12.603+00	2025-08-16 09:31:15.513+00	f	f	2025-08-16 09:31:15.512+00	0	f
1737	21	88112858	HUD 3 horoo Hos Dali hothon 53/3bair 2 orts 4d 196 toot	3	0.00	Erdenezaya-d. altai hothonii gerlen dohio unguruud essenzia oil zasvarin tuwuur uragshaa ergeed undur ulbar shar bair	14	f	0	5GCqNaz3Hn	2025-08-15 11:50:38.373+00	2025-08-16 09:52:08.625+00	t	f	2025-08-16 09:52:08.625+00	0	f
1661	52	88180976	SHD Haniin materialiin etses dr MT kolonkd	3	6000.00	zalgah	69	f	0	lgjb7vCHuA	2025-08-13 18:42:08+00	2025-08-15 05:31:07.985+00	f	f	2025-08-15 05:31:07.985+00	0	f
1694	61	91678504	Увс аймаг Өмнөговь	3	0.00	Маргааш 12 цагаас гарах автобусанд тавиулна. Долоо хоногт нэг удаа явдаг.	69	f	0	FLffY8MKl4	2025-08-14 09:00:23.537+00	2025-08-15 05:31:22.295+00	t	t	2025-08-15 05:31:22.295+00	0	f
1729	52	99056926	naturin zam daguu mpm-in 1 davhart	3	6000.00	ou	9	f	0	3iHQAw96h1	2025-08-15 05:04:41.858+00	2025-08-15 06:15:09.364+00	f	f	2025-08-15 06:15:09.364+00	0	f
1709	59	89177326	Баянмонгол 418 байр 3 орц 3 давхар 140 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	ous31BDL1C	2025-08-14 09:56:46.114+00	2025-08-15 06:34:50.067+00	f	f	2025-08-15 06:34:50.067+00	0	f
1652	59	94451017	Баруун салааны 3 дугаар буудал 	3	0.00	ирэхээсээ өмнө залгах	69	f	0	iX8iK64F8w	2025-08-13 12:36:06.497+00	2025-08-15 08:39:24.921+00	f	f	2025-08-15 08:39:24.921+00	0	f
2315	77	99983643 	HUD 7horoo orgiliin encantogin baruun talaar n orn 	2	19000.00	jargalant13iin 332toot 	78	f	0	daAb5Yv5H9	2025-08-25 14:02:30.718+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
1747	59	88405984	 3 4 р хорооллын эцэс 9 хороо cotiin байрны ар талын дулаахан байр 44 байр 4 давхар 15 тоот 1  	3	0.00	ирэхээсээ өмнө залгах	14	f	0	MUF9dZi8pT	2025-08-15 15:06:36.028+00	2025-08-16 12:21:56.336+00	f	f	2025-08-16 12:21:56.336+00	0	f
2369	26	88090111	han uul duureg 18-r khoroo ikh mongol uls gudamj Monnis building	2	50000.00	Tsenher	78	f	0	2fmNpxCblt	2025-08-26 02:42:17.666+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
1781	61	88690739	БЗД их засагын урд поларис хотхон 57б 1р орц 11давхар 1106 тоо	3	0.00	тооцоо хийсэн.	9	f	0	x5jg9MWF6q	2025-08-16 02:26:16.514+00	2025-08-16 09:11:24.766+00	t	f	2025-08-16 09:11:24.766+00	0	f
1811	61	89017090	Мишээл экспо өнгөрөөд лавай захын хажууд 107р байр 5р орц 6 давхар 151 тоот	3	29900.00	тооцоо хийгээгүй	3	f	0	5OWzCa3OoF	2025-08-17 01:43:22.164+00	2025-08-17 13:09:29.038+00	f	f	2025-08-17 13:09:29.038+00	0	f
1759	61	90198844	Баянцээлийн хажууд хуучны 9 давхар байр 4-р орц  2 давхар 113 тоот	5	29900.00	орой 5 цагаас хойш хүнтэй. тооцоо хийгээгүй	9	f	0	K69p5bo8ca	2025-08-15 15:42:41.447+00	2025-08-18 02:40:17.442+00	f	f	\N	tsutsalsan	f
1782	19	88621336	Sonsgolon  штс buudal	5	86000.00	төлбөр танайх авна	3	f	0	nbbagakdKW	2025-08-16 02:57:38.042+00	2025-08-18 14:49:07.652+00	f	f	\N	margash avna	f
1786	60	96231453	Сбд 1 хороо 25 байр 2 орц б1-4 тоот	5	99000.00	автомат хатаагч төлбөр хийгдээгүй	9	f	0	tl0hlJykIO	2025-08-16 10:42:27.362+00	2025-08-20 06:04:09.574+00	f	f	\N	japan yvj bga irhere avna	f
1153	52	91111482	Buhiin urgoogiin Hajuud5n dawhar yagaan 62 r bair 4 orts 3-52 toot	3	6000.00	Baynzurh zah talruga	67	f	0	RIg69AIt9o	2025-07-24 08:21:33.925+00	2025-07-29 15:42:23.134+00	f	f	2025-07-29 15:42:23.134+00		f
1268	58	91191990	БГД 17-р хороо хуучнаар Од кино театр, одоогийн COCO banana баарны баруун талын 38-р байр 11 давхарт 1107 тоот	5	75000.00	Ванны тоглоомын багц. Барааг татаж авсны дараа хүргүүлнэ.	9	f	0	s1Vl3c73fM	2025-07-28 13:19:33.557+00	2025-07-30 14:57:27.79+00	f	f	\N	avahguu gesen	f
1222	58	99856744	БЗД, 14р хороо, Улаанхуаран, цэргийн их сургуулийн баруун талд,24р байр, 2р орц	3	70000.00	Сүүдрэвч шар 3х4.5.	67	f	0	LXz6y4gDhj	2025-07-27 08:13:57.5+00	2025-07-30 11:04:48.726+00	f	f	2025-07-30 11:04:48.726+00	0	f
1338	63	95050021	ХААИС баруун талд 2шар байшингийн зүүн талынх нь байр 2 давхар 203	5	60000.00	ХААИС баруун талд 2шар байшингийн зүүн талынх нь байр 2 давхар 203	3	f	0	CtrFqgOGtT	2025-07-30 04:24:17.301+00	2025-08-04 13:44:33.479+00	f	t	\N	tetgever buuhaar avna	f
1330	21	88109640	narnii zam Nogoon tugul hothon 78r bair 4dav 15toot	3	0.00	uuganaa badam-d	67	f	0	XJzDG44oef	2025-07-30 02:28:58.247+00	2025-07-30 11:05:21.247+00	t	f	2025-07-30 11:05:21.246+00	0	f
1261	59	80989850 	БЗД 42 хороо Цагаан хуаран хотхон 92V байр 2 давхар 13 тоот 	5	6000.00	ирэхээсээ өмнө залгах	67	f	0	I4rWc9BSLq	2025-07-28 07:38:23.305+00	2025-07-30 06:26:29.22+00	f	f	\N	0	f
1391	4	99261126	Зүүнхараа такси вокзалын араас	3	1.00	.	3	f	0	nMWWra1xoG	2025-08-01 12:42:01.979+00	2025-08-02 05:56:10.092+00	f	f	2025-08-02 05:56:10.092+00	0	f
1329	63	96500527	Дорноговь Айраг сум 13н цагт тэнгэр палазгаас автобус явдаг1ширхэг авъя	5	60000.00	address: Дорноговь Айраг сум 13н цагт тэнгэр палазгаас автобус явдаг1ширхэг авъя, radio_input_1: 🌿🧃 1 хайрцаг: 120,000₮ → Зөвхөн 60,000₮ (50% хямдрал) + 🚚 Үнэгүй хүргэлт	9	f	0	3aKm5wRvZK	2025-07-30 02:25:35.991+00	2025-08-03 05:43:45.084+00	f	t	\N	0	f
1403	4	88112806	ХУД 11р хороо blue sky 44b 22 тоот	3	1.00	.	14	f	0	kj4LaWCBsd	2025-08-02 12:02:27.396+00	2025-08-03 16:12:57.481+00	f	f	2025-08-03 16:12:57.481+00	0	f
1353	46	86868630	hiimoriin ovoo	3	229000.00	проектор	9	f	0	U7BObqHufi	2025-07-30 13:51:42.796+00	2025-07-31 11:50:12.957+00	f	f	2025-07-31 11:50:12.957+00	0	f
1339	63	86072929	БЗД, 26-р хороо, Цэцэрлэгт хүрээлэн, Park side хотхон, 825-р байр	5	60000.00	БЗД, 26-р хороо, Цэцэрлэгт хүрээлэн, Park side хотхон, 825-р байр	9	f	0	NC2DW3lADW	2025-07-30 04:26:22.946+00	2025-07-30 14:56:24.978+00	f	f	\N	avahguu gesen	f
1448	21	96091986	1horoolol 32bair 8orts 1-253 toot	3	0.00	j	9	f	0	qqcsoGyKrr	2025-08-04 05:04:37.377+00	2025-08-04 07:38:12.241+00	t	f	2025-08-04 07:38:12.241+00	0	f
1323	20	99183321	Циркийн урд, Ub central residence, 1 давхрын ресепшнд үлдээх, 85 тоот	3	1.00	төлбөр авахгүй	9	f	0	IHsjAtMhH8	2025-07-30 00:05:13.929+00	2025-07-31 12:30:16.753+00	f	f	2025-07-31 12:30:16.753+00	0	f
1322	20	95230680	Сүхбаатар дүүрэг, 8-р хороо, Ривер кастел бизнес апартмент, 8 давхар, 809 тоот /Сансарын Имартын баруун талд, Архитектор ордны урд/	3	1.00	төлбөр авахгүй	9	f	0	12In8gxxGZ	2025-07-30 00:04:36.158+00	2025-07-31 13:01:40.76+00	f	f	2025-07-31 13:01:40.759+00	0	f
1324	20	99546000	Дарь-Эхийн хуучин эцэс, 102-р сургууль (хүргэхийн өмнө залгаарай)	3	1.00	төлбөр авахгүй	9	f	0	yVSti8r4MM	2025-07-30 00:05:54.103+00	2025-07-31 13:18:35.603+00	f	f	2025-07-31 13:18:35.603+00	0	f
1246	63	98843122	банануур дүүрэг унаанд тавих тэнгэрээс явна	5	60000.00	7сарын27нд унаанд тавих	67	f	0	7ckY62bLVl	2025-07-28 02:58:17.034+00	2025-07-30 14:54:02.915+00	f	f	\N	очоод унаанд тавих гэсэн бодовч хүлээн авах утас ашиглалтанд байхгүй гэсэн тул бараагаа өгөөгүй	f
1295	63	94139411	BZD 6r horoo bzd zah urd 21r surguulliij zuun taliin bair 	3	60000.00	   	67	t	16	1apIlxCqw2	2025-07-29 03:48:52.011+00	2025-07-30 15:10:50.855+00	f	f	2025-07-29 15:46:40.77+00	0	f
1325	60	89057605	89057605 БЗД 36-р хороо Их Монгол Резиденсе 4-177тоот	3	200000.00	автомат хатаагч 1ширхэг модон хатааг 1 ширхэг	9	f	0	otyB6EAX0H	2025-07-30 01:18:15.286+00	2025-07-30 08:22:50.355+00	f	f	2025-07-30 08:22:50.354+00	0	f
1332	63	95225050	Baganuurluu unaand tavih 	5	60000.00	Baganuurluu unaand tavih 	9	f	0	neY96GOWvo	2025-07-30 03:11:35.163+00	2025-08-03 05:43:45.084+00	f	f	\N	0	f
1266	63	94066602	Oworhangai aimag Harhorin suman deer awiy	3	60000.00	Oworhangai aimag Harhorin suman deer awiy	24	t	16	jK6dvDTJK2	2025-07-28 08:20:48.897+00	2025-07-30 15:10:50.855+00	f	t	2025-07-30 04:39:14.74+00	маргааш тээшинд авна	f
1327	63	95693886	өвөрхангай аймаг 	3	60000.00	өвөрхангай аймаг 	3	t	16	ygtqh8Xva6	2025-07-30 01:28:39.34+00	2025-07-30 15:10:50.855+00	f	t	2025-07-30 08:56:00.443+00	0	f
1310	63	93004884	Darhan aimag deeree awiy	3	60000.00	Darhan aimag deeree awiy	3	t	16	9EmAJ919oc	2025-07-29 07:01:01.823+00	2025-07-30 15:10:50.855+00	f	t	2025-07-30 07:35:30.966+00	0	f
1395	21	96091986	1 horoolol 32 bair 8 orts 1dav 253 toot	3	0.00	d. burnwe-d	14	f	0	bIbtwwrDnu	2025-08-02 03:11:13.693+00	2025-08-02 07:13:00.097+00	t	f	2025-08-02 07:13:00.097+00	0	f
1340	63	89029937	baynhoshuu 7r horoo 23iiin 20 toot 	5	60000.00	baynhoshuu 7r horoo 23iiin 20 toot 	9	f	0	FeAn8HbLlX	2025-07-30 04:28:19.274+00	2025-08-03 05:43:45.084+00	f	f	\N	3 odor awna	f
1366	21	96091986	1 horoolol 32 bair 8orts 1dav 253 toot	3	0.00	D. Burnee-d 	14	f	0	N9W8tCDNjQ	2025-07-31 12:58:27.545+00	2025-08-02 07:14:11.218+00	t	f	2025-08-02 07:14:11.218+00	0	f
1308	63	91716910	BGD 17r horoo modnii 2iin zam 34r bair 3r orts 7 davhar 100 toot huucgin od kino tytriin dood  	5	60000.00	  	14	f	0	em6h48k5OR	2025-07-29 06:49:58.124+00	2025-08-03 15:06:29.117+00	f	f	\N	avah bolhoroo helne gesen	f
1419	59	88712481	10 хороолол 15 байр	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	SGJ0wbmUOv	2025-08-03 13:12:43.617+00	2025-08-04 07:38:18.573+00	f	t	2025-08-04 07:38:18.573+00	0	f
1377	63	99552141	8/1 11r horoolol 8r bair 122 toot	5	60000.00	1/8	14	f	0	0V0FNzaXG3	2025-08-01 01:40:01.478+00	2025-08-04 13:44:33.479+00	f	f	\N	hodo bga tul awj chadhgu erhere helne	f
1446	2	96770880	zaisan suld hothon 11horoo 110g bair 2in 43 toot	5	500000.00	onoodor	3	f	0	AmY4RYtO7G	2025-08-04 04:52:00.02+00	2025-08-04 13:44:33.479+00	f	f	\N	bolison	f
1483	6	95858955	bzd ulaan huaran bagant horoolol 471-14-86toot	3	0.00	onooodor	9	f	0	5iiNT3ncoK	2025-08-06 05:34:37.631+00	2025-08-06 12:27:04.18+00	t	f	2025-08-06 12:27:04.18+00	0	f
1480	6	99450098	shd 28 horoo nogoon chuluut 7-34a	3	0.00	onoodor	14	f	0	dmVVWJDsq3	2025-08-06 05:29:20.046+00	2025-08-06 10:18:17.579+00	t	f	2025-08-06 10:18:17.579+00	0	f
1473	52	86118082	Darkhan unaand	3	6000.00	Vogzalaas yawdag	14	f	0	KtcdfAMp2W	2025-08-05 18:36:54.002+00	2025-08-06 09:01:51.16+00	f	f	2025-08-06 09:01:51.16+00	0	f
1345	61	98117176	Narnii horoolol 14r bair 8 davhart 804 toot"	3	0.00	Саарал сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	3	f	0	9s1pidBcJI	2025-07-30 05:44:10.163+00	2025-07-30 11:37:30.382+00	t	f	2025-07-30 11:37:30.382+00	0	f
1290	63	88124278	BZD 12r horoo janjin klub 145r surguuliin baruun tal 340 toot ireed zalga 	5	60000.00	  	67	f	0	Yy44LNWOcn	2025-07-29 02:22:19.303+00	2025-07-30 14:54:02.915+00	f	f	\N	хаягаар очиход 88181393 дугаараас яриад 3ширхэг цай өгсөн бсан ба надаас цай аваагүй буцаасан	f
1354	6	80034057	hud 2horoo han uul hothon 6a bair 1615toot	3	0.00	onoodor	3	f	0	DqFEkAuYeH	2025-07-31 02:40:27.258+00	2025-07-31 13:46:03.295+00	t	f	2025-07-31 13:46:03.295+00	0	f
1347	20	94506274	СХД, депогийн буудал 1-58байр 26 тоот	1	1.00	төлбөр төлөхгүй	\N	f	0	rAX1uppk2a	2025-07-30 06:16:01.506+00	2025-07-30 14:59:22.835+00	f	f	\N	0	t
1248	63	99166794	налайх 	5	60000.00	7сарын 27нд хот орно тэр үедээ очих хаягаа хэлж өгий	67	f	0	v8Ti36ob6d	2025-07-28 03:13:52.675+00	2025-07-30 06:27:07.915+00	f	f	\N	хүлээн авах хүн нь хөдөө явсан гэсэн ирэхээр нь холбогдоно гэсэн	f
1344	61	94118444	Баян-Өлгий	3	0.00	Саарал сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	3	f	0	sB8wHjMPfy	2025-07-30 05:43:15.48+00	2025-07-30 08:54:42.311+00	t	f	2025-07-30 08:54:42.311+00	0	f
1346	20	94506274	СХД, депогийн буудал 1-58байр 26 тоот	3	1.00	төлбөр төлөхгүй	14	f	0	gS4IG6DyU8	2025-07-30 06:16:01.504+00	2025-08-01 13:41:27.363+00	f	f	2025-08-01 13:41:27.363+00	utsa awagu	f
1342	19	91102787	911027875shariin perizer Gachuurt kamponi 91102787	3	86000.00	төлбөр  танайх  авна	3	f	0	Ci6XnbrCGt	2025-07-30 04:49:49.4+00	2025-07-30 09:26:09.444+00	f	f	2025-07-30 09:26:09.444+00	0	f
1253	63	88559761	Нарантуул захын ард 42в байр 4 давхарт 403 тоот	3	60000.00	7/28-наас хэтрүүлэхгүй хүргэлтээ авна 80869248 энэ хүнд хүргэж өгнө	9	f	0	h6H2eFbX1y	2025-07-28 06:26:40.265+00	2025-08-03 05:43:52.213+00	f	f	2025-08-03 05:43:52.213+00	авах хүн нь хөдөө явсан бсан бараагаа аваагүй	f
1279	59	96069599	БГД 9 р хорооллын эцэс Талст auto угаалга 	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	6Cs4VIeuVI	2025-07-28 15:29:56.079+00	2025-07-30 10:27:01.441+00	f	f	2025-07-30 10:27:01.441+00	0	f
1350	6	88006522	hud 19d sholondoogin hoid talin shar bair 15dawhar 48bair 2orts 6-110toot	3	0.00	o	3	f	0	h0ke2hc97x	2025-07-30 06:20:27.933+00	2025-07-30 10:27:55.886+00	t	f	2025-07-30 10:27:55.886+00	0	f
1326	60	80008180	Гэмтлийн эмнэлгийн зүүн талд Шүүт хотхоны зүүн талд 47 байр 7 давхар 46 тоот	3	119000.00	төлбөр хийгдээгүй	9	f	0	gAimrI80ZO	2025-07-30 01:19:43.439+00	2025-07-30 10:58:59.048+00	f	f	2025-07-30 10:58:59.048+00	0	f
1343	17	94149319	сансарын 805р анги хажууд хүнсний дэлгүүр	3	195000.00	1ш камэр	67	f	0	8yqjJuxXnX	2025-07-30 05:29:28.052+00	2025-07-30 11:05:32.211+00	f	f	2025-07-30 11:05:32.211+00	0	f
1349	6	91117995	bgd 8-horoo  hogjil baruun taliin olimp 5-r bair 1-orts 3dawhart 10toot	3	0.00	onoodor	9	f	0	GB02RVMET6	2025-07-30 06:17:30.589+00	2025-07-30 11:06:21.694+00	t	f	2025-07-30 11:06:21.694+00	0	f
1348	20	94506274	СХД, депогийн буудал 1-58байр 26 тоот	1	1.00	төлбөр төлөхгүй	\N	f	0	YW3fd1elPc	2025-07-30 06:16:01.508+00	2025-07-30 14:59:22.835+00	f	f	\N	0	t
1245	63	86662523	Орбит тахилт 151 анги өнгөрөөд жаргалант дэлгүүр	3	60000.00	7сарын27нд хүргэж өгөх	24	t	16	nDpxf2nenK	2025-07-28 02:56:38.821+00	2025-07-30 15:10:50.855+00	f	f	2025-07-29 09:14:59.084+00		f
1242	63	99082776	Арцат апартмент 2 1442-29 тоот	3	60000.00	7сарын 27нд авна	3	t	16	vaKHI6vOwk	2025-07-28 02:22:31.168+00	2025-07-30 15:10:50.855+00	f	f	2025-07-29 12:32:36.794+00	0	f
1202	63	90167373	Баянзүрх дахь эхийн хуучин эцэс барс дэлгүүр  	3	60000.00	7сарын 26нд авна	14	t	16	VUTsuhEkL8	2025-07-26 07:01:42.472+00	2025-07-30 15:10:50.855+00	f	f	2025-07-27 10:32:59.004+00	0	f
1254	63	99198540	18 р хороо Удирдлагын академийн Академи 2 хотхон 36-4 байр 	3	60000.00	оройн 19 цагаас хойш хүнтэй 	3	t	16	CQb3bGSWaZ	2025-07-28 06:38:41.739+00	2025-07-30 15:10:50.855+00	f	f	2025-07-29 09:50:22.973+00	0	f
1195	63	99008476	Narnii horoolol 7r bair 12toot	3	60000.00	 	3	t	16	wzewXEIMX5	2025-07-26 04:16:40.374+00	2025-07-30 15:10:50.855+00	f	f	2025-07-29 10:50:14.738+00		f
1190	63	88681745	3r emneleg baruun tald nairamdal emneleg	3	60000.00	7сарын 26нд аваачиж өгөх	9	t	16	0rOrqKYHVf	2025-07-26 03:12:28.645+00	2025-07-30 15:10:50.855+00	f	f	2025-07-27 05:52:49.867+00	0	f
1176	63	89803405	оффицеруудын ордоны буудал дээр	3	60000.00	7сарын 25нд авна	14	t	16	Cqo5ME5vxE	2025-07-25 07:49:13.032+00	2025-07-30 15:10:50.855+00	f	f	2025-07-27 04:14:09.791+00		f
1341	63	99179298	Erdenet aimag deeree awiy	3	60000.00	Erdenet aimag deeree awiy	3	t	16	DjuZw8bQ64	2025-07-30 04:40:59.334+00	2025-07-30 15:10:50.855+00	f	t	2025-07-30 07:35:09.236+00	0	f
1292	63	80701244	Дархан хот.	3	60000.00	Яаралтайгаар түрүүлж хүргэх	3	t	16	e8R93OUKJx	2025-07-29 02:39:53.95+00	2025-07-30 15:10:50.855+00	f	t	2025-07-29 07:27:18.431+00	0	f
1312	63	88253165	SHD Baynhoshuu 112r buudliin  nuuriin 3r gudamj 6w haalga	3	60000.00	  	24	t	16	tJYEk4CMzU	2025-07-29 07:11:15.791+00	2025-07-30 15:10:50.855+00	f	f	2025-07-29 10:14:15.903+00	0	f
1384	6	99016992	tomor zamiin emneleg	3	0.00	onoodor	14	f	0	aIVZPzeavI	2025-08-01 07:17:31.246+00	2025-08-01 10:39:13.484+00	t	f	2025-08-01 10:39:13.484+00	0	f
1369	21	88874290	BZD 22 horoo Sondor appartment 1 dav	3	0.00	jaagii.g- d 	9	f	0	yFcwtiqRYW	2025-07-31 13:01:59.968+00	2025-08-01 13:26:17.888+00	t	f	2025-08-01 13:26:17.888+00	0	f
1385	6	88058454 80558454	6-n buudal deer	3	0.00	onoodor	14	f	0	FsBfE7xzw4	2025-08-01 07:18:28.337+00	2025-08-02 18:31:38.925+00	t	f	2025-08-02 18:31:38.925+00	0	f
1281	59	88789218	СХД тахилт сүндэрлэх дэлгүүр 	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	X6qk4PA3Q1	2025-07-28 15:31:21.487+00	2025-08-02 10:10:39.21+00	f	f	2025-08-02 10:10:39.21+00	utasaa awagui	f
1399	6	99097622	hud 3-horoo telmuun tower 43b 11daw 215 toot	3	0.00	onoodor	3	f	0	13PaMCfJOu	2025-08-02 05:34:31.573+00	2025-08-02 06:20:28.738+00	t	f	2025-08-02 06:20:28.738+00	0	f
1252	63	94570909	хархорин 3 давхар 130 тоот	5	60000.00	7сарын 29нд авна	14	f	0	srAsQm00Nt	2025-07-28 06:18:14.197+00	2025-08-03 05:10:50.049+00	f	f	\N	tsutsalsan zahalaigu	f
1197	58	95959835	СХД, 24р хороо, Хустай 1-р гудамж, 45А тоот	5	55000.00	Сүүдрэвч ногоон 3х3	14	f	0	FBti0U2pti	2025-07-26 04:52:36.016+00	2025-08-03 05:10:50.049+00	f	f	\N	utsa awagu bn	f
1447	6	88093765	amaglan zah 112-r languu 	3	0.00	onoodor 	14	f	0	GLL1N9IxQf	2025-08-04 04:53:36.311+00	2025-08-05 08:22:24.419+00	t	f	2025-08-05 08:22:24.419+00		f
1408	21	88888021	shangrilla office 23 davhart	3	0.00	mugi ch. 	14	f	0	yumOo5Nx3E	2025-08-03 09:48:47.807+00	2025-08-04 07:45:05.463+00	t	f	2025-08-04 07:45:05.463+00	0	f
1423	59	91778210	замын үүд 	3	6000.00	ирэхээсээ өмнө залгах	3	f	0	Rul0TNRyI1	2025-08-03 13:36:16.16+00	2025-08-04 08:03:09.076+00	f	f	2025-08-04 08:03:09.076+00	0	f
1392	17	99197357	1r horoolol Erin horoolol 53_9 145	5	195000.00	1ш камэр	14	f	0	v2K4h3RdYr	2025-08-01 12:45:36.671+00	2025-08-07 02:31:41.277+00	f	f	\N	camer bahgu	f
1335	63	88840851	Вокзалаас Сайншанд руу унаанд өгөх	3	60000.00	вокзал дээрээс сайншанд руу тавих	3	t	16	Mpy6YqqlQY	2025-07-30 03:18:03.198+00	2025-07-30 15:10:50.855+00	f	t	2025-07-30 07:34:50.877+00	0	f
1328	63	88712986	nariinteel ovorkhangai	3	60000.00	8 цагийн Баянхонгорын автобусанд тавих. Нарийнтээлийн постон дээр үлдээх	3	t	16	D4UJix4Lr5	2025-07-30 01:35:08.978+00	2025-07-30 15:10:50.855+00	f	t	2025-07-30 08:56:23.817+00	0	f
1336	63	99283358	Jukov busnii buudam dovdan sondor 71a bair 2r orts 8 davhar 115 toot 	3	60000.00	Jukov busnii buudam dovdan sondor 71a bair 2r orts 8 davhar 115 toot 	67	t	16	8PQBHS7nO6	2025-07-30 04:20:56.557+00	2025-07-30 15:10:50.855+00	f	f	2025-07-30 13:45:56.457+00	0	f
1334	63	99863637	Баянмонгол 404 1орц 3давхарт 13 тоот	3	60000.00	яаралтай хүргэх	9	t	16	7rHFtsXtwO	2025-07-30 03:16:17.865+00	2025-07-30 15:10:50.855+00	f	f	2025-07-30 05:51:38.542+00	0	f
1666	61	88758966	Зайсан Номун вилла 100б байр 6 давхар 21 тоот	3	29900.00	Тооцоо хийгээгүй	68	f	0	b5hu4MRLWe	2025-08-14 03:33:39.437+00	2025-08-15 11:59:29.948+00	f	f	2025-08-15 11:59:29.948+00	0	f
1376	63	99561343	15хороо цайз 16 саруул хотхон  45р байр 4орц 161тоот	5	60000.00	8сарын 1нд 	9	f	0	OucszJNzec	2025-08-01 01:35:33.052+00	2025-08-03 05:43:45.084+00	f	f	\N	avhaa bolison	f
1367	21	99338486	hunnu 2222 207 bair 604 toot.  604# zalgah	3	0.00	18s umnu dood emiin sand uldeegeed heleh, 18s hoish hayag deeree bna	3	f	0	p5MCmJVjPW	2025-07-31 12:59:44.732+00	2025-08-01 11:44:23.278+00	t	f	2025-08-01 11:44:23.278+00	0	f
1355	60	99975427	Gerlug vista 58/8 17 dawhar 1702 toot	3	119000.00	Uudnees 1702 gj zalgah-tulbur hiigdeegui bga	9	f	0	ACVoUvHqB0	2025-07-31 05:35:30.693+00	2025-08-02 10:30:30.563+00	f	f	2025-08-02 10:30:30.563+00	0	f
1357	20	99165036	Мандала хотхон, 320/9 байр, 11 давхар 419 тоот (18 цагаас хойш)MSM группын төв оффис (ажлын цагаар)	3	1.00	төлбөр авахгүй	9	f	0	n72zQnkqcP	2025-07-31 09:29:21.391+00	2025-08-02 11:14:19.538+00	f	f	2025-08-02 11:14:19.538+00	utsa avaguu	f
1361	58	99545504	40р байр агуулах очиж авна.	5	70000.00	Сүүдрэвч шар 3х4.5. Өглаө агуулах дээрээ очоод залгахад ирээд авна. 11:00-12:00	9	f	0	k8EVZZ0qxb	2025-07-31 09:53:54.825+00	2025-08-01 07:36:30.415+00	f	f	\N	0	f
1371	11	80899823	Оройн мэ БГД-7р хороо 4-р хорооллын 12-р байр 282 тоот	3	1.00	5литр шингэн бордоо нэг савыг хүргэх. Хүргэлтийн мөнгөө өгсөн.	14	f	0	HUaQhMjsjO	2025-08-01 00:16:55.844+00	2025-08-02 05:58:10.539+00	f	f	2025-08-02 05:58:10.539+00	0	f
1656	62	80104621	Dulguun nuur 224bair 1504 toot	3	1.00	8-14-ны захиалга	9	f	0	UgSUaoNOO8	2025-08-13 16:14:40.419+00	2025-08-14 09:37:30.243+00	f	f	2025-08-14 09:37:30.243+00	utsa avaguu	f
1368	21	99652064	sunday plaza esreg tald FM 107,5tai bair 2orts 5dav 50 toot	3	0.00	DegyBLGN-d	9	f	0	8HDvOlnlY3	2025-07-31 13:00:59.406+00	2025-08-02 07:39:41.597+00	t	f	2025-08-02 07:39:41.597+00	0	f
1379	60	90846070	СБД 3 р хороо.Орос 3 р сургуулийн урд 5 давхар улаан тоосгон байр 5 давхарт	3	99000.00	автомат хувцас хатаагч жижиг дөрвөлжин төлбөр хийгдээгүй байгаа	9	f	0	oOmfWOOuUP	2025-08-01 04:38:02.662+00	2025-08-01 09:09:02.444+00	f	f	2025-08-01 09:09:02.444+00	0	f
1356	54	99774723	Баянгол дүүрэг 1-р хороо 48-р байр 5-р орц 73 тоот	3	150000.00	хүргэлт гарахаасаа өмнө залгаарай. гэсэн шүү. Залгаж гэртээ байгаа үгүйг нь асуугаад гарах юм байна шүү	14	f	0	NT6ajyx0DT	2025-07-31 08:52:44.947+00	2025-08-01 10:01:13.508+00	f	f	2025-08-01 10:01:13.508+00	0	f
1370	19	99971248	модны  2 шинэ 7р төв	5	86000.00	төлбөр  танайх  авна	14	f	0	BawKZuWayr	2025-07-31 15:04:27.246+00	2025-08-03 05:10:50.049+00	f	f	\N	tsutalsan	f
1373	63	88172625	altai hothon 10r bair 51 toot code 51v	3	60000.00	8 сарын 1ны өглөө  ирээд залгаарай	3	f	0	HTdkBiCBVi	2025-08-01 01:25:38.231+00	2025-08-01 10:42:19.491+00	f	f	2025-08-01 10:42:19.491+00	0	f
1362	4	99152934	ХУД-ийн баруун талд 45в байр 44 тоот	3	1.00	.	3	f	0	VGWO5j7rlf	2025-07-31 11:23:40.406+00	2025-08-01 10:59:57.55+00	f	f	2025-08-01 10:59:57.55+00	0	f
1360	58	99170213	Модны 2, Монгени сургуулийн урд, 72А байр, 12 давхар, 61 тоот	3	65000.00	Minecraft 248ш	14	f	0	SYD9mnXOR4	2025-07-31 09:35:30.842+00	2025-08-01 11:19:34.384+00	f	f	2025-08-01 11:19:34.384+00	0	f
1685	61	99134398	СХД 3-р хороо 44 37б 65-р сургуулийн баруун талд	3	29900.00	тооцоо хийсэн	69	f	0	2CdWeI3Dlf	2025-08-14 05:17:13.893+00	2025-08-15 12:46:18.204+00	f	f	2025-08-15 12:46:18.203+00	0	f
1378	63	80407140	Tomor zamiin bairand awiy	5	60000.00	hot orj ireed yriy 8sariin 1d awiy	14	f	0	FjEVumM0fc	2025-08-01 01:45:30.045+00	2025-08-03 05:10:50.049+00	f	f	\N	tsutsalsan huhdin awsan	f
1372	63	99488219	bayn ulgii ulgii sum	5	60000.00	8сарын1нд хүргэлтээр авна. Залгаарай	9	f	0	GwE8NDe7se	2025-08-01 01:20:35.835+00	2025-08-05 06:15:25.762+00	f	t	\N	mungu baihguu	f
1696	59	95973871	БЗД 16 хороо данзангийн 29 14 тоот	3	0.00	ирэхээсээ өмнө залгах	14	f	0	VWASORDtTb	2025-08-14 09:09:50.77+00	2025-08-15 10:52:42.718+00	f	f	2025-08-15 10:52:42.718+00		f
1730	10	88064537	narnii horoolol	3	145000.00	test	3	f	0	zp6wgzgXMN	2025-08-15 05:32:21.171+00	2025-08-15 05:33:10.362+00	f	f	2025-08-15 05:33:10.362+00	0	f
1689	19	99959257	ховд аймаг шинэ  даргон оос Өдөр бүр	3	86000.00	86000	69	f	0	qLoBWwdQcj	2025-08-14 06:43:20.345+00	2025-08-15 06:39:35.905+00	f	f	2025-08-15 06:39:35.905+00	0	f
1365	21	88001104	Dunjingarav horoolol 108b bair 3 orts 10dav 60toot	3	0.00	Buyna Zagd-d   kod 60B	14	f	0	mticxqm3PH	2025-07-31 12:57:38.419+00	2025-08-05 08:24:08.176+00	t	f	2025-08-05 08:24:08.176+00	utsan holbogdoh bolomjguu	f
1719	19	80994869	3ш авий , 80994869, модны2, 35г байр 30 тоот	3	258000.00	төлбөр танайх авна . 3ш шүү	69	f	0	XMAodLHh6A	2025-08-14 13:04:31.205+00	2025-08-15 09:50:32.804+00	f	f	2025-08-15 09:50:32.804+00	0	f
1748	59	85334471	БГД 20 р хороо нөхөрлөлийн 4 н 45 тоот 	3	0.00	ирэхээсээ өмнө залгах	14	f	0	M53nPVfrR0	2025-08-15 15:08:40.655+00	2025-08-16 11:15:04.239+00	f	f	2025-08-16 11:15:04.239+00	0	f
1791	21	88030970	Turiin tusgai albanii emneleg deer, ajiliin tsagaar 1deh udur awna	3	0.00	Tuya-d. 1deh udur ajiliin tsagaar awna. chingis muzein urd bdag	24	f	0	AcrUoTCdT6	2025-08-16 13:07:19.677+00	2025-08-18 06:08:14.143+00	t	f	2025-08-18 06:08:14.143+00	mar	f
2318	77	98119525 	songdo emneleg 	2	18000.00	sahiur hiij baiga hun 	73	f	0	yzjpe7Ll8W	2025-08-25 14:04:08.174+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
1760	61	99790638	32-ын тойрог сансар супермаркет 2 давхар 9 тоот	3	29900.00	тооцоо хийгээгүй	9	f	0	RKeOlTJe3x	2025-08-15 15:44:35.466+00	2025-08-16 07:22:21.25+00	f	f	2025-08-16 07:22:21.25+00	0	f
1669	61	95071213	Төмөр замын ард Өргөө  41	3	59800.00	2 ширхэг тооцоо хийгээгүй	9	f	0	ODSf5xSSCU	2025-08-14 03:44:38.057+00	2025-08-16 12:44:11.318+00	f	f	2025-08-16 12:44:11.317+00	utas ni holbgdhgvi bno	f
1375	63	88172625	altai hothon 10r bair 51 toot code 51v	5	60000.00	8 сарын 1ны өглөө  ирээд залгаарай	3	f	0	p5C6XO4L50	2025-08-01 01:33:31.786+00	2025-08-02 09:09:41.936+00	f	f	\N	bolison	f
1396	21	94755599	HUD18 horoo Akademi 2 hothon 36-2bair 7d 701 toot	3	0.00	ariuka-d. kod 701#	3	f	0	50EmXbtfye	2025-08-02 03:12:22.316+00	2025-08-02 07:23:58.496+00	t	f	2025-08-02 07:23:58.496+00	0	f
1383	6	96881489	enhbayriin zam delgereh delgerh mini market ired zalga	3	0.00	fonoodor	14	f	0	yRMA5yjQ5X	2025-08-01 07:16:37.459+00	2025-08-02 09:13:56.286+00	t	f	2025-08-02 09:13:56.285+00	tsutsalsan huhdin awsan	f
1405	6	89911084	bohiin orgoonii zuun tald altan orgoo hothon 72bair 4orts 6dawhart 101 toot	3	0.00	margaash usnii nairtai onoodor zaawal awna	14	f	0	dY7Z3koeKm	2025-08-03 05:17:16.338+00	2025-08-03 08:15:20.569+00	t	f	2025-08-03 08:15:20.569+00	0	f
1406	6	85252584	dari eh stantsiin buudal deer ireed zalga	3	0.00	maargaash usnii nairtai onoodor zawaal awna	14	f	0	LyoUKwhGH2	2025-08-03 05:18:36.401+00	2025-08-03 09:13:27.492+00	t	f	2025-08-03 09:13:27.492+00	0	f
1374	21	99055790	Artsat 2 hothon 1430 bair 11dav 42 toot	3	0.00	orts kodgui. Odko-d	3	f	0	UiqmM7tddi	2025-08-01 01:26:16.14+00	2025-08-01 12:50:39.829+00	t	f	2025-08-01 12:50:39.829+00	0	f
1389	46	99164489	ХУД Hunnu mall хажууд ногоон 5 давхар Шинэ-Өргөө хотхоны 626-р байр 2 давхар 25 тоот.	3	229000.00	проектор	3	f	0	hGMmMe8h1u	2025-08-01 10:18:52.059+00	2025-08-01 12:53:20.091+00	f	f	2025-08-01 12:53:20.091+00	0	f
1400	60	99688283	Khan Uul duureg 20r horoo Hursh Zaan hothon 106a-114 toot	3	119000.00	Модон хатаагч төлбөр хийгдээгүй	3	f	0	DNW4RTekN4	2025-08-02 05:36:03.191+00	2025-08-03 04:49:13.392+00	f	f	2025-08-03 04:49:13.392+00	0	f
1381	60	88992378	10 хороолол хаан банкны чанх арын 3 байр (хуучны 9 давхар цэнхэр байр),2 орц, 6 давхарт ,57 тоот	3	99000.00	8.2 нд хүргүүлэх төлбөр хийгдээгүй байгах	14	f	0	5tjmSeBhto	2025-08-01 06:48:45.902+00	2025-08-01 14:09:04.793+00	f	f	2025-08-01 14:09:04.793+00	0	f
1358	20	99073035	СХД, 27-р хороо, Орчлон хороолол, 44-р байр(эмийн сантай 1 орцтой байр)Очихоосоо өмнө залгаарай	5	1.00	төлбөр авахгүй	14	f	0	teZDH1uy9p	2025-07-31 09:29:50.259+00	2025-08-03 05:10:50.049+00	f	f	\N	tsutsalsan	f
1359	20	88044060	Дөлгөөн нуур, Хоймор оффисын урд талд Гэрэлт титэм хотхон, 267, 30 тоот	5	1.00	төлбөр авахгүй	9	f	0	EW3U1Ysy7W	2025-07-31 09:30:18.618+00	2025-08-03 05:43:45.084+00	f	f	\N	utsan holbogdoh bolomjguu	f
1382	60	99 473016	өмнөговь гурван тэс пойшиг драгон дээрээс унаа явна	3	99000.00	өмнөговь гурван тэс пойшиг драгон дээрээс унаа явна автомат хувцас хатаагч	14	f	0	A8lZ9tflYP	2025-08-01 06:57:32.642+00	2025-08-02 07:48:12.353+00	f	f	2025-08-02 07:48:12.353+00	0	f
1414	59	80407355	цайз MONEL доороосоо 2 дахь буудал 17 р гудам Хар тороо 2-1 	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	1nsIpsig7H	2025-08-03 13:08:50.061+00	2025-08-04 12:04:12.94+00	f	f	2025-08-04 12:04:12.94+00	0	f
1393	19	99045157	ХУД, Зайсанд Вилла Верде хотхон, 112/2 байр, 3 давхарт 1006 тоот. Хаалганы код 111202# Күнз сургуулийн замын эсрэг талд	3	86000.00	төлбөр  танайх  авна	3	f	0	gQvbr6ql47	2025-08-01 23:50:35.429+00	2025-08-02 07:49:14.108+00	f	f	2025-08-02 07:49:14.108+00	0	f
1394	62	88094281	100 айл, M building office	3	85800.00	8/2-ны захиалга	14	f	0	xNIC2WmxVl	2025-08-02 02:02:06.34+00	2025-08-03 10:10:35.435+00	f	f	2025-08-03 10:10:35.435+00	0	f
1388	60	99187851	2 дугаар 40 мянгатын 6 байр 1 орц	3	99000.00	автомат хатаагч 8 сарын 2нд заавал авах \nочиод залгах төлбөр хийгдээгүй	9	f	0	YTZFt4L3SQ	2025-08-01 09:13:42.671+00	2025-08-02 08:09:52.796+00	f	f	2025-08-02 08:09:52.796+00	0	f
1397	21	88928282	SHD 21 horoolol chingis soosa-n baruun tald Chuhag hothon 32-b bair 5dav 19 toot	3	0.00	Enhzol-d. kod 28 tulhuur 1355	14	f	0	voAbONmajV	2025-08-02 03:13:43.007+00	2025-08-02 08:22:45.352+00	t	f	2025-08-02 08:22:45.351+00	0	f
1387	60	88055599	орбит схд  22 хороо жаргалант супер маркет	3	99000.00	автомат хатаагч жаргалант супер маркет дээр очиод залгах төлбөр хийгдээгүй байгаа	14	f	0	I9u1AD8koA	2025-08-01 08:14:48.008+00	2025-08-02 09:05:01.711+00	f	f	2025-08-02 09:05:01.711+00	0	f
1658	52	89108048	Yaarmagiin Bogd  villa 1205r bair 5-29 toot	3	6000.00	Ochihdo zalgah	9	f	0	V06VGC1vIy	2025-08-13 18:39:53.242+00	2025-08-14 13:46:13.985+00	f	f	2025-08-14 13:46:13.985+00	0	f
1009	61	88690739	БЗД их засагын урд поларис хотхон 57б 1р орц 11давхар 1106 тоот	5	0.00	Ногоон сойтог-1ш Шүүлтүүрийн суурь-1ш  Шүүлтүүрийн тор-1ш	9	f	0	kfK0Y0OrnY	2025-07-23 03:21:57.033+00	2025-08-07 04:04:22.379+00	t	f	\N	утас холбогдохгүй ба,гэрт нь очиход хүнгүй бна	f
1686	61	99841432	цайз зах 16 саруул тэнгэр-1 хотхон 47  1-орц 3 давхар 11 тоот 	3	29900.00	тооцоо хийгээгүй	14	f	0	0pgxI1e1Em	2025-08-14 05:23:38.849+00	2025-08-15 10:33:48.479+00	f	f	2025-08-15 10:33:48.479+00	0	f
1401	4	85277130	ЧД 1р хороо 35р байр 6орц 4 дав 71тоот Тэди төвийн зүүн урд	3	1.00	.	14	f	0	tkgnzjJkAl	2025-08-02 08:39:01.026+00	2025-08-03 10:35:53.999+00	f	f	2025-08-03 10:35:53.998+00	0	f
1772	52	88189998	Saruul zahiin hajuud 17 r bair 7-63 toot	3	6000.00	s	9	f	0	rIkdEnTpys	2025-08-15 17:55:38.418+00	2025-08-16 06:25:03.393+00	f	f	2025-08-16 06:25:03.393+00	0	f
1398	21	88990232	Tsagdaagiin Akademiin surguuliin zuun tald sondgoi 12 dav bair. 16 bair 82 toot	3	0.00	Z. Otgonjargal-d. 2doh udur gertee irne. 8/5nd hurguulj awna	14	f	0	gePM9IdFtI	2025-08-02 03:57:07.505+00	2025-08-04 13:02:59.202+00	t	f	2025-08-04 13:02:59.202+00	0	f
1407	62	91360327	Баянгол зочид буудлын баруун урд талын шар 5 давхар 25 байр 6 орц 1 давхар 76 тоот	3	30900.00	гэрт хүн бхгүй бол орцны урд талын ундрага дэлгүүрт үлдээчих	14	f	0	cpZ9GbInFw	2025-08-03 09:46:30.623+00	2025-08-04 13:17:37.664+00	f	f	2025-08-04 13:17:37.664+00	0	f
1415	59	94392057	дархан уул аймаг шарын гол сум	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	s5iUOJffod	2025-08-03 13:09:45.149+00	2025-08-04 07:54:53.108+00	f	f	2025-08-04 07:54:53.108+00	0	f
1409	21	96000952	12s umnu zaisan grandmed emneleg deer.	3	0.00	swl oroi 5-6n hooron emartiin urd ayoko mall deer. Erdeneoyun-d	3	f	0	j1ojBvYepu	2025-08-03 09:51:17.722+00	2025-08-04 09:36:31.026+00	t	f	2025-08-04 09:36:31.026+00	0	f
1667	61	99272042	Мишээл экспо С-33 	3	29900.00	19 цагаас өмнө	68	f	0	ntpTOqFFca	2025-08-14 03:38:14.244+00	2025-08-15 09:42:00.743+00	f	f	2025-08-15 09:42:00.743+00	0	f
1731	10	88064537	narnii horoolol	5	145000.00	test	3	f	0	Ht4hxO5k70	2025-08-15 05:32:30.532+00	2025-08-20 06:42:53.508+00	f	f	\N	0	f
1803	59	94299969	зүүнхараа	3	0.00	ирэхээсээ өмнө залгах	3	f	0	wW188kp1ds	2025-08-16 14:10:29.829+00	2025-08-17 11:06:09.746+00	f	f	2025-08-17 11:06:09.746+00	0	f
1810	61	99684187	Увс Улаангом	3	0.00	тооцоо хийсэн	9	f	0	dFYfgX1VTL	2025-08-17 01:40:30.06+00	2025-08-17 08:39:45.031+00	t	t	2025-08-17 08:39:45.031+00	0	f
1698	59	99551049	эрдэнэт	3	0.00	ирэхээсээ өмнө залгах	68	f	0	zyzYtzrqbD	2025-08-14 09:17:59.03+00	2025-08-15 04:33:49.275+00	f	f	2025-08-15 04:33:49.275+00	0	f
1431	59	89767202	X apartment  хажуу талд 109 байр 24 тоот 	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	5M19uXxT4I	2025-08-03 13:43:12.213+00	2025-08-04 12:35:27.024+00	f	f	2025-08-04 12:35:27.024+00	0	f
1432	59	99970008	Хурд Rapid хороолол 15 хороо 21 байр 1 орц 5 давхар 15 	3	35000.00	ирэхээсээ өмнө залгах	3	f	0	Fd3vxne1Z4	2025-08-03 13:44:12.935+00	2025-08-04 09:19:17.764+00	f	f	2025-08-04 09:19:17.764+00	0	f
1438	59	95982223	Эрдэнэт аймаг 	3	6000.00	ирэхээсээ өмнө залгах	3	f	0	8nfYmObu52	2025-08-03 13:47:57.199+00	2025-08-04 08:03:31.938+00	f	f	2025-08-04 08:03:31.938+00	0	f
1420	59	85648540	БГД 29 р хороо Эрин хороолол 53 11 байр 1 орц 20 тоот код *#1101	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	2MnpeGHHAZ	2025-08-03 13:33:08.355+00	2025-08-04 09:38:08.186+00	f	f	2025-08-04 09:38:08.186+00	0	f
1421	59	88690222	ХУД  23 хороо Agarta residence 1426 байр 2 р орц 13 давхар 1307 тоот 	3	6000.00	ирэхээсээ өмнө залгах	3	f	0	nxa9wjKvOu	2025-08-03 13:34:35.088+00	2025-08-04 12:26:18.296+00	f	f	2025-08-04 12:26:18.296+00	0	f
1428	59	95429247	5 шар залуус хороолол 	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	QBJF6aUN0i	2025-08-03 13:41:09.857+00	2025-08-04 08:14:18.514+00	f	f	2025-08-04 08:14:18.514+00	0	f
1732	6	88707616	nisehiin mnii delguures ochij baraa awna	3	0.00	onoodoor oroi	68	f	0	eHDSs5PkbR	2025-08-15 05:38:13.027+00	2025-08-15 14:51:32.559+00	t	f	2025-08-15 14:51:32.559+00	0	f
1433	59	90909025	БЗД 17 хороо 397 в2	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	Haej6BLY63	2025-08-03 13:44:54.104+00	2025-08-04 11:21:25.053+00	f	f	2025-08-04 11:21:25.053+00	0	f
1429	59	90979944	БГД 29 хороо Ви Си ХХК 	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	LdGpwYazKI	2025-08-03 13:41:52.033+00	2025-08-04 07:38:39.552+00	f	f	2025-08-04 07:38:39.552+00	0	f
1424	59	99851539	БЗД 7 р хороо 115 байр 4 орц 54 тоот код  54b 	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	pjHDHWsqkk	2025-08-03 13:37:11.863+00	2025-08-04 13:25:07.863+00	f	f	2025-08-04 13:25:07.863+00	0	f
1418	59	96114040	3 4 хороолол эцэс e mart доошоо уруудаад 32 байр 1 орц 	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	V4uW9hiZfw	2025-08-03 13:11:56.943+00	2025-08-04 09:14:21.988+00	f	t	2025-08-04 09:14:21.988+00	0	f
1422	59	96059697	Монгол 3 сургууль автобусны буудал 	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	GRglhTDllr	2025-08-03 13:35:49.533+00	2025-08-04 06:56:40.564+00	f	f	2025-08-04 06:56:40.564+00	0	f
1440	59	90050677	13 р хороолол бөхийн өргөөний урд талын байр 73 р байр 9\\34 тоот 	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	6Ki9dk61fE	2025-08-03 13:49:35.199+00	2025-08-04 13:47:34.666+00	f	f	2025-08-04 13:47:34.666+00	0	f
1435	46	99148998	Сэлэнгэ аймгийн Сүхбаатар сум руу	3	199000.00	проектор	3	f	0	wMVIHeu3aw	2025-08-03 13:45:37.745+00	2025-08-04 11:52:24.636+00	f	f	2025-08-04 11:52:24.636+00	0	f
1380	60	94943848	дархан уурхай шарын гол	5	99000.00	драгоноос унаа авдаг дархан уурхай шарын гол	9	f	0	EyX7Piqoqr	2025-08-01 06:39:11.538+00	2025-08-05 06:15:25.762+00	f	f	\N	mungu orj irheer avna	f
1441	59	99845117	Сүхбаатар дүүрэг 9 хороо 4 дүгээр сургууль хажууд 	3	35000.00	ирэхээсээ өмнө залгах	14	f	0	wN0K1qf3uY	2025-08-03 13:50:18.412+00	2025-08-04 06:38:24.681+00	f	f	2025-08-04 06:38:24.681+00	0	f
1439	59	88831103	UG arena уран ган 	3	88831103.00	ирэхээсээ өмнө залгах	3	f	0	mNHz6Dkr8z	2025-08-03 13:48:34.268+00	2025-08-04 09:00:12.774+00	f	f	2025-08-04 09:00:12.774+00	0	f
1443	59	88683412	сүхбаатар аймаг	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	94u8RIVolX	2025-08-03 13:51:28.66+00	2025-08-04 10:14:39.787+00	f	f	2025-08-04 10:14:39.787+00	utsa awagu	f
1437	59	88854558	БГД 14 хороо 1р Өргөө кино театр 	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	uNWeagayxa	2025-08-03 13:47:18.488+00	2025-08-04 09:38:13.913+00	f	f	2025-08-04 09:38:13.913+00	0	f
1416	59	95211762	өвөрхангай аймаг 	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	QTmlcLjavR	2025-08-03 13:10:14.841+00	2025-08-04 08:22:29.686+00	f	t	2025-08-04 08:22:29.685+00	0	f
1410	60	88988483	Өмнөговь Даланзадаг руу	3	99000.00	Автомат хатаагч унаанд тавьж өгөх төлбөр хийгдээгүй байгах	9	f	0	nFqfZISPm6	2025-08-03 12:08:54.983+00	2025-08-04 07:40:57.216+00	f	f	2025-08-04 07:40:57.216+00	0	f
1430	59	85627988	Сэлэнгэ аймаг 	3	6000.00	ирэхээсээ өмнө залгах	3	f	0	KJNmuVWJiT	2025-08-03 13:42:25.828+00	2025-08-04 08:03:20.845+00	f	f	2025-08-04 08:03:20.845+00	0	f
1445	62	94993223 88488568	Өмнөговь аймаг, цгаан хад 114-дэх км	3	1.00	Өмнөговь аймгийн унаанд хийх	14	f	0	AKeZWn6GC9	2025-08-04 04:22:11.907+00	2025-08-05 10:31:42.514+00	f	f	2025-08-05 10:31:42.514+00	0	f
1413	59	98010248	3 4 хороолол	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	gZXlus5GcH	2025-08-03 13:07:53.432+00	2025-08-04 09:48:06.483+00	f	f	2025-08-04 09:48:06.483+00	0	f
1450	62	99555431 95739688	Эрдэнэт хот ( Орхон аймаг баян өндөр сум 5-24)	3	1.00	Эрдэнэт хотын унаанд хийх	14	f	0	aw6g0gUdjp	2025-08-04 10:03:55.749+00	2025-08-05 10:50:30.28+00	f	f	2025-08-05 10:50:30.279+00	0	f
1434	59	80626979	10 р хороолол автобусны урд талын буудал 	3	6000.00	ирэхээсээ өмнө залгах	9	f	0	LYFX2AjbIq	2025-08-03 13:45:28.406+00	2025-08-04 05:45:24.505+00	f	f	2025-08-04 05:45:24.505+00	0	f
1427	59	96162012	баянбүрд residence 417 байр 2 орц 10 давхар 175 тоот код 2180#	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	7U6PS7KUGp	2025-08-03 13:40:27.14+00	2025-08-04 06:04:17.146+00	f	f	2025-08-04 06:04:17.146+00	0	f
1404	6	99607358	suhbaatar aimag narantuulin orgotgolos unaand tawih	3	0.00	margaash usnii nairtai onoodor zaawal	14	f	0	zQGhGizOSA	2025-08-03 05:15:16.662+00	2025-08-04 08:56:20.522+00	t	f	2025-08-04 08:56:20.522+00		f
1425	59	95739763	naadam center хажуу талд KH apartment 6b байр 2р орц 	3	6000.00	гадаа нь очиод залга 	3	f	0	8jOI2CXgun	2025-08-03 13:38:10.747+00	2025-08-04 09:19:11.237+00	f	f	2025-08-04 09:19:11.237+00	0	f
1417	59	89757573	16 хороолол sky residence 3 77c байр 139 тоот 	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	X5GXJIxeGp	2025-08-03 13:11:11.581+00	2025-08-04 10:31:56.32+00	f	t	2025-08-04 10:31:56.32+00	0	f
1426	59	80790363	дорнод чойбалсан 	3	6000.00	дугаар луу нь мэссэж бичнэ машиний номерыг 	14	f	0	cqvXusJoBu	2025-08-03 13:39:07.681+00	2025-08-04 10:14:48.067+00	f	f	2025-08-04 10:14:48.067+00	utsa awagu	f
1442	59	90793399	ХУД 17 р хороо Time Squere	3	6000.00	ирэхээсээ өмнө залгах	3	f	0	rVbXB08Bqm	2025-08-03 13:51:01.111+00	2025-08-04 10:38:46.903+00	f	f	2025-08-04 10:38:46.903+00	0	f
1478	52	93335000	Suis - n Ard 50r bair 4n dawhart 26 toot	3	6000.00	x	9	f	0	knnVlscV23	2025-08-05 18:42:29.361+00	2025-08-06 08:44:19.762+00	f	f	2025-08-06 08:44:19.762+00	0	f
1469	59	94492125	сэлэнгэ	3	0.00	ирэхээсээ өмнө залгах	14	f	0	XdTIkiAx0Y	2025-08-05 16:38:29.639+00	2025-08-06 07:15:11.074+00	f	f	2025-08-06 07:15:11.074+00	0	f
1444	59	99896465	зайсангийн эцсийн буудал 	3	34000.00	ирэхээсээ өмнө залгах	3	f	0	T4Q6Ff6qRd	2025-08-03 13:52:16.078+00	2025-08-04 10:46:15.677+00	f	f	2025-08-04 10:46:15.677+00	0	f
1468	59	80320031	ЧД 13 хороо сургуулийн 36-721	3	0.00	ирэхээсээ өмнө залгах	14	f	0	6LOEGR3liB	2025-08-05 16:38:08.645+00	2025-08-06 10:50:30.291+00	f	f	2025-08-06 10:50:30.291+00	0	f
1454	59	88049032	Дамбын эцэс наран төв	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	wJUsQ0yggu	2025-08-04 17:00:58.475+00	2025-08-06 11:25:36.67+00	f	f	2025-08-06 11:25:36.67+00	utsa awagu	f
1456	59	99205807	өмнөговь даланзадгад	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	MUrwrvvQPa	2025-08-05 03:51:35.517+00	2025-08-05 10:30:16.316+00	f	t	2025-08-05 10:30:16.316+00	utsa avaguu	f
1466	59	80818102	БЗД 15 хороо 6 р байр	3	0.00	ирэхээсээ өмнө залгах	9	f	0	j76sosvEMk	2025-08-05 16:36:49.387+00	2025-08-06 11:46:19.163+00	f	f	2025-08-06 11:46:19.163+00	0	f
1474	52	95672065	Umnugovi Togttsetsii sum Unaand	3	0.00	Sapporoo, Dragon ali alins yawna	14	f	0	CQRVHD6nSl	2025-08-05 18:38:12.548+00	2025-08-06 07:13:32.321+00	f	f	2025-08-06 07:13:32.32+00	0	f
1464	59	85036398	хөвсгөл их уул сум	3	0.00	ирэхээсээ өмнө залгах	14	f	0	j5eLhgePYQ	2025-08-05 16:35:49.785+00	2025-08-06 07:17:08.116+00	f	t	2025-08-06 07:17:08.116+00	0	f
1463	59	96112905	СХД 19 хороо 87 байр а орц 60 тоот 	3	0.00	ирэхээсээ өмнө залгах	14	f	0	Py6apvAny4	2025-08-05 16:35:13.132+00	2025-08-06 07:55:30.791+00	f	f	2025-08-06 07:55:30.791+00	0	f
1452	46	99112702	Sansar ktms baruun tald auto undral service	3	229000.00	проектор	14	f	0	SEAibaPxjs	2025-08-04 13:04:04.007+00	2025-08-05 11:59:05.395+00	f	f	2025-08-05 11:59:05.395+00	0	f
1451	4	88653324	ХУД 19р хороо Туулгол гудамж Шинэ мөрөөдөл хотхон	3	1.00	.	14	f	0	XoecfikP3f	2025-08-04 10:41:30.601+00	2025-08-05 08:41:28.696+00	f	f	2025-08-05 08:41:28.696+00	0	f
1461	10	93111137	shd orchlon 1 duureg zalgaa 41 bair 9dawhart 83toot 	3	35000.00	7tsagas hoish hunte bna	14	f	0	UHPdGdyBbJ	2025-08-05 06:18:14.413+00	2025-08-05 12:19:53.287+00	f	f	2025-08-05 12:19:53.287+00	0	f
1449	4	99287799	БЗД Ахмадын хороолол 253 байр 43тоот	3	1.00	.	14	f	0	TsPcm5Bacx	2025-08-04 09:18:08.214+00	2025-08-05 08:47:36.911+00	f	f	2025-08-05 08:47:36.911+00	0	f
1458	59	88558956	Яармаг хангарьд буудал хотын захиргааны баруун талд байдаг Garden city хотхон 1304 байр 1 орц код #201#	3	19000.00	7 цагаас хойш хүргээрэй	14	f	0	nCRJKRj9Vz	2025-08-05 04:03:31.626+00	2025-08-05 08:55:57.636+00	f	f	2025-08-05 08:55:57.636+00	0	f
1455	59	99027854	ХУД 1 хороо наадам center замын эсрэг тал Есөн тун эмийн сантай байр	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	0WtEe1B6OX	2025-08-04 17:02:43.329+00	2025-08-05 09:03:30.72+00	f	f	2025-08-05 09:03:30.72+00	0	f
1467	59	80818102	БЗД 15 хороо 6 р байр	5	0.00	ирэхээсээ өмнө залгах	9	f	0	TSgCiqKoLV	2025-08-05 16:37:04.836+00	2025-08-07 02:33:01.292+00	f	f	\N	lvv shivsen	f
1465	59	94245516	БЗД 14 хороо буламба 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	ZhNTHWKXpV	2025-08-05 16:36:19.28+00	2025-08-06 12:00:04.77+00	f	f	2025-08-06 12:00:04.77+00	0	f
1460	19	99971248	Модны 2 шинэ 7р төв	3	86000.00	төлбөр  танайх  авна	14	f	0	xUTzIiWlWW	2025-08-05 05:15:33.942+00	2025-08-05 13:56:22.599+00	f	f	2025-08-05 13:56:22.599+00	0	f
1699	61	94207474	Алтай хотхон хажууд 4 замын уулзвар Механик инженерийн сургууль	1	29900.00	тооцоо хийгээгүй	\N	f	0	1osFOjOpQh	2025-08-14 09:19:25.495+00	2025-08-14 14:06:50.697+00	f	f	\N	0	t
1659	52	88027018	HUD Zaisan bogd uulruu baruun talaar ugsdug der White hill hothon100-303toot	3	6000.00	b	9	f	0	74GZfMMBoV	2025-08-13 18:40:45.368+00	2025-08-14 14:07:02.171+00	f	f	2025-08-14 14:07:02.171+00	0	f
1470	59	99193444	ЧД 4 хороо 112 байр diplomat 95 3 р орц 4 давхар 30 тоот Код 4268#	3	0.00	ирэхээсээ өмнө залгах	14	f	0	UUyYXGx99l	2025-08-05 16:39:36.709+00	2025-08-06 12:31:45.613+00	f	f	2025-08-06 12:31:45.613+00	0	f
1453	46	99179532	УБ СБД 9р хороо Хойморт офиссын баруун хойно Цэнгэлтэй хотхон 806-30 тоот	5	199000.00	проектор	9	f	0	iFEWLe5jw2	2025-08-04 13:10:56.89+00	2025-08-07 02:33:19.717+00	f	f	\N	buruu proektor	f
1457	59	93050595	БЗД 7 хороо Оточ Марамба дотуур байр	3	6000.00	ирэхээсээ өмнө залгах	9	t	17	5tR3XS6DL7	2025-08-05 03:53:00.018+00	2025-08-08 02:44:31.454+00	f	f	2025-08-07 08:48:48.913+00	utsa avaguu	f
1436	59	99839383 99094174	Баруун салааны 4р буудал gs25 үлдээнэ 	3	6000.00	ирэхээсээ өмнө залгах	9	t	17	8Rm7SQDkX5	2025-08-03 13:46:16.23+00	2025-08-08 02:44:31.454+00	f	f	2025-08-07 10:18:53.385+00		f
1690	59	96270422	ХУД 1 р хороо 120 мянгат 9 р байр 1р орц 11 тоот 4 давхар голын хаалга	3	0.00	ирэхээсээ өмнө залгах	68	f	0	VltC95xxcz	2025-08-14 08:43:51.322+00	2025-08-15 11:14:39.701+00	f	f	2025-08-15 11:14:39.701+00	0	f
1479	19	95232638	Altan ovoo 48dugaar gudamj	3	86000.00	төлбөр  танайх  авна	9	f	0	528C4F8hcJ	2025-08-06 02:02:14.116+00	2025-08-06 17:04:55.816+00	f	f	2025-08-06 17:04:55.815+00	0	f
1477	52	99177409	Tuw shuudangiin Chanh urd shilen Eco tower 23n dawhart	3	6000.00	n	9	t	17	widqhlBkTV	2025-08-05 18:41:40.223+00	2025-08-08 02:44:31.454+00	f	f	2025-08-07 04:42:00.198+00	margash avna	f
1462	46	99791769	river rarden	3	229000.00	проектор	9	t	17	qngAWGXkwx	2025-08-05 14:03:03.804+00	2025-08-08 02:44:31.454+00	f	f	2025-08-07 06:44:06.435+00	0	f
1482	6	99170065	zaisan orgil arshaan suvilal hoino ls plaza office 7dawhart 703	3	0.00	onooodor	9	f	0	ZDbuemvaQi	2025-08-06 05:33:37.371+00	2025-08-06 08:25:20.308+00	t	f	2025-08-06 08:25:20.308+00	0	f
1472	52	99133130	11r horoolol 10r bair 8 orts 4n dawhariin 268r toot	3	0.00	Ugsarmal 9n dawharuud	9	f	0	t3Vu51OAl4	2025-08-05 18:36:19.603+00	2025-08-06 09:17:58.317+00	f	f	2025-08-06 09:17:58.317+00	0	f
1459	59	89180146	8.6 хүргэнэ СХД 11 хороо 112 буудал 	3	6000.00	ирэхээсээ өмнө залгах	14	f	0	jdwvC8tyrr	2025-08-05 04:06:03.186+00	2025-08-06 09:58:14.744+00	f	f	2025-08-06 09:58:14.744+00		f
2320	77	88871448 	haniin metiral etses 	2	20000.00	91017887 	9	f	0	I8CvgoeOES	2025-08-25 14:05:04.012+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
1471	52	88335282	Nalaikh unaand	3	0.00	Oficceruudiin ordongoos ogoh zalgaj medegdeh	9	t	17	Da0qjRC3uQ	2025-08-05 18:35:16.01+00	2025-08-08 02:44:31.454+00	f	f	2025-08-07 08:02:40.868+00	utsa avaguu	f
2371	26	94070746	yaarmag hangari2 hothon 1554 bair 1 orts 48 toot tsahilgaanii bahi	5	25000.00	bahi 25000	78	f	0	gImKTfKKEM	2025-08-26 03:16:20.619+00	2025-08-26 05:11:23.214+00	f	f	\N	0	f
1757	61	99077634	чойр	3	0.00	 нарантуулаас унаа явдаг	9	f	0	cAStu977zW	2025-08-15 15:37:20.042+00	2025-08-16 10:13:26.77+00	t	t	2025-08-16 10:13:26.77+00	0	f
1745	59	998645771	дархан орхон сум	3	0.00	ирэхээсээ өмнө залгах	3	f	0	N0qLiKtOc0	2025-08-15 14:59:59.739+00	2025-08-17 11:03:25.388+00	f	f	2025-08-17 11:03:25.388+00	0	f
1484	6	86002847	1horoolol  tsamba garav 18bair 6-23toot	3	0.00	g	14	f	0	UmFi9XlDEm	2025-08-06 05:35:23.154+00	2025-08-06 06:54:27.136+00	t	f	2025-08-06 06:54:27.136+00	0	f
1481	6	80472966	shd 34 horoo tolgoitin 64-10	3	0.00	onooofor	14	f	0	il0HmGZLdi	2025-08-06 05:30:04.387+00	2025-08-06 09:04:08.847+00	t	f	2025-08-06 09:04:08.847+00	0	f
1476	52	88072094	SHD  9r horoo bayanhoshuunii Jantsan Hudaldaanii tuw 2 dawhart Dotuur huwtsasnii tasagt	3	6000.00	N	14	f	0	cWpTVXZi1H	2025-08-05 18:40:58.842+00	2025-08-06 09:45:30.959+00	f	f	2025-08-06 09:45:30.959+00	0	f
1475	52	86640290	SBD 11 r horoo nogoon nuur Khangai hothonii  Baruun tald ST apartment 714r bair 702 toot	3	6000.00	B	14	f	0	2QhtGg0Cpp	2025-08-05 18:39:37.101+00	2025-08-06 09:50:47.289+00	f	f	2025-08-06 09:50:47.289+00	0	f
1700	61	89222933	Бөмбөгөр	3	29900.00	тооцоо хийгээгүй	9	f	0	5x49h3n9ee	2025-08-14 09:21:24.342+00	2025-08-15 05:42:06.305+00	f	f	2025-08-15 05:42:06.305+00	0	f
1487	2	94871229	dunjingarawin esreg tal chuhag 2 hothon 601-1toot	5	500000.00	onoodor	14	f	0	lCeQxCsGDD	2025-08-06 06:00:14.74+00	2025-08-07 02:32:13.17+00	f	f	\N	tsutalsan	f
1720	19	99923242	шижир алт даргонаас	3	86000.00	төлбөр танайх авна	69	f	0	cFERvKxXLb	2025-08-14 14:59:12.025+00	2025-08-15 05:46:49.732+00	f	f	2025-08-15 05:46:49.731+00	0	f
1687	61	99234592	Нарантуул зах Зүүн саравч Женс өмдний 3 дах эгнээ	3	29900.00	тооцоо хийгээгүй	14	f	0	mbtJ08zXtf	2025-08-14 05:26:45.748+00	2025-08-15 06:31:53.512+00	f	f	2025-08-15 06:31:53.512+00	0	f
1750	59	95399006	Ub palace урд байдаг Momo hot pottoi  13 давхарт бор шаргал байр 47/2 	3	0.00	ирэхээсээ өмнө залгах	14	f	0	32cJdHvPtN	2025-08-15 15:12:52.46+00	2025-08-16 13:15:57.432+00	f	f	2025-08-16 13:15:57.432+00	0	f
1688	19	88022939	Баянзүрх барилгамегасторын баруун талд сэлбэ апартмент 91-1 орц 104 тоот утас 88022939	3	86000.00	төлбөр танайх авна	9	f	0	uQjlzCCN1V	2025-08-14 05:37:40.889+00	2025-08-15 08:50:39.14+00	f	f	2025-08-15 08:50:39.14+00	0	f
1670	61	99898195	Хүчит шонхор хүнсний зах	3	29900.00	Тооцоо хийгээгүй	9	f	0	ZVHpoKz1rF	2025-08-14 03:46:42.915+00	2025-08-16 07:10:32.432+00	f	f	2025-08-16 07:10:32.432+00	margash 1umnu avna gesen	f
1768	52	80526538	Khangai hothon 507 r bair 2orts 8-118 toot	3	6000.00	b	9	f	0	Kgh182pf4m	2025-08-15 17:52:14.225+00	2025-08-16 08:32:37.078+00	f	f	2025-08-16 08:32:37.078+00	0	f
1679	61	94894994	БЗД 14-хороо Цагаанхуаран 76б байр 2-р орц 4865# 1 давхар 74 тоот	3	0.00	ногоон сойтог 2 саарал сойтог 2	14	f	0	URkkJU8Cag	2025-08-14 04:29:08.864+00	2025-08-15 09:54:04.121+00	t	f	2025-08-15 09:54:04.12+00	0	f
1668	61	88717708	Баганат хороолол 455г байр 12 давхар 1202 тоот 	3	29900.00	тооцоо хийгээгүй	14	f	0	nAtnBoEJm3	2025-08-14 03:41:03.825+00	2025-08-15 10:19:24.247+00	f	f	2025-08-15 10:19:24.247+00	0	f
1677	61	88126307	Офицер Хорго хотхон 2-ын 6-р байр GS25 ийн хажуу үсчин	3	29900.00	ажлын цагаар	14	f	0	JFvkttT0vc	2025-08-14 04:19:11.989+00	2025-08-15 11:01:25.751+00	f	f	2025-08-15 11:01:25.751+00	0	f
1697	59	98132418	БЗД дүүргийн эмнэлэгийн хашаа Зүтгэл найдвар эмнэлэг 2 давхар 3 тоот	3	0.00	ирэхээсээ өмнө залгах	14	f	0	rJNUSFrn7N	2025-08-14 09:17:36.611+00	2025-08-15 12:35:08.174+00	f	f	2025-08-15 12:35:08.173+00	0	f
2372	26	80114522	narantuul zahiin baruun tumen mall baruun tald shuuhiim 2 ulaan bairnii hoid taliin 166 bairnii 2 dawhart 8 toot tsenher tsag	2	50000.00	Tsenher	66	f	0	j5mx6L7iCs	2025-08-26 03:20:32.812+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2321	77	95857989 	8tsagaas hoish horoolol iin etssin sot iin bair 	2	20000.00	 2/1r bair 1 orts 24toot	73	f	0	RdzTZEb1Ha	2025-08-25 14:05:34.89+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
1780	61	99425340	Баян-өлгий	3	0.00	төлсөн	3	f	0	QJ10AKMr1k	2025-08-16 02:17:24.404+00	2025-08-19 08:22:51.666+00	t	t	2025-08-19 08:22:51.666+00		f
1762	61	88720813	Niseh  16r horoo vita apartment	5	29900.00	Hyagaa niseh gej ugsun. tootsoo hiigeegvi. 	3	f	0	BzIOcdm6eX	2025-08-15 16:00:52.768+00	2025-08-20 06:30:49.829+00	f	f	\N		f
1746	59	80186409	СБД 1р хороо 2 р байр 1 орц 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	nA1URQVJtz	2025-08-15 15:05:32.44+00	2025-08-20 07:11:21.995+00	f	f	2025-08-16 11:25:51.009+00	0	f
1769	52	85163245	Bayanmongol horoolol 414bair 6-78 tot	3	6000.00	Bichsen dugaarku zalgaj uguh	9	f	0	dHaQhaDe2g	2025-08-15 17:53:09.118+00	2025-08-16 11:37:06.746+00	f	f	2025-08-16 11:37:06.746+00	0	f
1495	6	86994059	river garden	3	0.00	18 tsag hurtel bn	9	t	17	6TRa9nJd2M	2025-08-07 03:37:40.76+00	2025-08-08 02:44:31.454+00	t	f	2025-08-07 06:47:59.356+00	0	f
1488	21	99078710	BZD 26 horoo Olymp hothon 430 bair 2 orts 2dav 85 toot	3	0.00	ch. uyan-d	9	t	17	oV2a9iEtVD	2025-08-06 13:16:41.694+00	2025-08-08 02:44:31.454+00	t	f	2025-08-07 07:08:46.449+00	0	f
1494	59	99530888	БЗД 26 р хороо Crystal town 803р байр 2р орц 15 давхар 1504	3	0.00	ирэхээсээ өмнө залгах	9	t	17	qXLWEMVvFE	2025-08-06 13:54:35.325+00	2025-08-08 02:44:31.454+00	f	f	2025-08-07 07:24:40.14+00	0	f
1497	6	90172470	hud 3-horoo delgereh hothon 80-1-22 toot	3	0.00	onoodor	9	t	17	ftw6kfdzWv	2025-08-07 03:40:24.556+00	2025-08-08 02:44:31.454+00	t	f	2025-08-07 05:34:02.254+00	0	f
1496	6	94655111	narnii horoololruu zamiin uulzwar deer tst barilgiin 2-201 toot 	3	0.00	onoodor	9	t	17	uKYfucwL8Z	2025-08-07 03:38:51.588+00	2025-08-08 02:44:31.454+00	t	f	2025-08-07 06:01:17.836+00	0	f
1490	21	99006356	Gegeentenii zuun urd Narantuul tower 3 dav	3	0.00	Tuguldur-t	9	t	17	jezV693osp	2025-08-06 13:18:16.324+00	2025-08-08 02:44:31.454+00	t	f	2025-08-07 06:16:52.473+00	0	f
1492	21	94484760	BZD 39 horoo Sky residence 3dav 23 toot	3	0.00	Otgonzul-d. ireheesee umnu zaaval zalgah, bagshiin deed deer baij magad	9	t	17	xrFGJV6UU1	2025-08-06 13:21:24.005+00	2025-08-08 02:44:31.454+00	t	f	2025-08-07 08:02:35.712+00	0	f
1493	59	94144654	32 р тойрог бүрд худалдааны төв ирээд залга	3	0.00	ирэхээсээ өмнө залгах	9	t	17	bAUKMctOlm	2025-08-06 13:31:36.477+00	2025-08-08 02:44:31.454+00	f	f	2025-08-07 09:27:37.223+00	0	f
1491	21	99064159	HUD 4 horoo Hanbogd horoolol 409 bair 94 toot	3	0.00	Baysgalan-d. 8sarin 8nd hurgeltee awnaa. 8s hoish gertee bna	9	t	17	ELr1QSZVNQ	2025-08-06 13:20:04.828+00	2025-08-08 02:44:31.454+00	t	f	2025-08-07 11:39:18.563+00	0	f
1489	21	88082269	yarmag shunshig villa 2 hothon Suld delguurt uldeeh	3	0.00	Urtnasan-d	9	t	17	bn45r6gfGZ	2025-08-06 13:17:31.316+00	2025-08-08 02:44:31.454+00	t	f	2025-08-07 11:43:35.051+00	0	f
1678	61	95555559	БЗД 26-р хороо Элизабет 221-р байр 1-р орц 11 давхар 73 тоот 	3	29900.00	тооцоо хийгээгүй	9	f	0	PGkfhE2LPD	2025-08-14 04:23:35.868+00	2025-08-16 11:57:32.39+00	f	f	2025-08-16 11:57:32.39+00	utsan holbogdoh bolomjguu	f
1771	52	99002964	Narnii gvvreer uragshaa dawaad goviun zamruu baruun ergeed Khaan banktai bair 3-3toot	3	0.00	b	3	f	0	befctP8IME	2025-08-15 17:54:54.285+00	2025-08-17 12:46:52.563+00	f	f	2025-08-17 12:46:52.563+00	bhq margaash avna	f
1503	59	95376630	дархан	3	0.00	ирэхээсээ өмнө залгах	14	f	0	fNYI43Xqoh	2025-08-07 06:27:24.65+00	2025-08-08 05:34:44.218+00	f	f	2025-08-08 05:34:44.218+00		f
1520	59	91220017	Баруун салаа СХД 24р хороо зээл 31-1	5	0.00	ирэхээсээ өмнө залгах	9	f	0	KQuD2OAKPX	2025-08-07 16:02:16.628+00	2025-08-08 02:43:05.485+00	f	f	\N	0	f
1510	6	88369606	Бзд 19р хороо газарчин 1р байр 24 тоот	3	298000.00	хурдан	9	f	0	3pYgg3teEy	2025-08-07 14:10:35.73+00	2025-08-08 05:34:20.765+00	f	f	2025-08-08 05:34:20.765+00	0	f
1499	59	94049812	Яармаг Garden city 1101 1 орц 103 тоот	3	0.00	ирэхээсээ өмнө залгах	3	f	0	WgfujxNvvY	2025-08-07 05:39:40.896+00	2025-08-08 07:23:03.813+00	f	f	2025-08-08 07:23:03.813+00	0	f
1501	59	90508685	Жуков эсрэг талын орос байр	3	0.00	ирэхээсээ өмнө залгах	9	f	0	DVv28bQ23X	2025-08-07 06:03:23.614+00	2025-08-08 06:24:05.47+00	f	f	2025-08-08 06:24:05.47+00	0	f
1513	59	95822612	СХД Их наран 43 , 48 тоот 	3	0.00	ирэхээсээ өмнө залгах	14	f	0	c6vR5qwvv7	2025-08-07 15:33:13.454+00	2025-08-08 07:13:26.674+00	f	f	2025-08-08 07:13:26.674+00	0	f
1522	59	89626085	СХД 29 хороо 22а 122 тоот	3	0.00	ирэхээсээ өмнө залгах	14	f	0	5QKkGemN6K	2025-08-07 17:11:28.322+00	2025-08-08 06:28:52.734+00	f	f	2025-08-08 06:28:52.733+00	0	f
1524	6	95545403	owtsiorin toirog  horgo hothon 	3	0.00	dugarin araaasan ogno	9	f	0	kxyfbvLq9E	2025-08-08 02:58:47.922+00	2025-08-08 06:32:38.208+00	t	f	2025-08-08 06:32:38.208+00	0	f
1535	4	99666110	Схд 7р хороо баянхошуу 11-8	3	1.00	.	9	f	0	cqd10hCYSY	2025-08-08 11:39:27.386+00	2025-08-09 12:11:48.355+00	f	f	2025-08-09 12:11:48.355+00	0	f
1511	59	95549682	БЗД 6 хороо 21 байр 3 орц 3 давхар 83 тоот 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	28O5dmMW3t	2025-08-07 15:29:15.869+00	2025-08-08 07:38:45.373+00	f	f	2025-08-08 07:38:45.372+00	0	f
1504	59	85410001	СХД эмнэлэгийн  зүүн хойно 11а байр хүннү зочид буудал баруун талаар хойшоо орно google map anand tower гэж гарна	3	35000.00	ирэхээсээ өмнө залгах	9	f	0	pNPL3qRvCn	2025-08-07 06:30:33.478+00	2025-08-08 09:54:29.267+00	f	f	2025-08-08 09:54:29.267+00	0	f
1517	59	80734188	5 шар дээр ирээд залга	3	0.00	ирэхээсээ өмнө залгах	14	f	0	vd1ogyO7ds	2025-08-07 15:43:09.784+00	2025-08-08 06:38:49.474+00	f	f	2025-08-08 06:38:49.474+00	0	f
1521	59	90687478	БЗД 16 хороо цайз монгол хотхон 66ё е байр 44 тоот доороо  billiard bga	3	0.00	ирэхээсээ өмнө залгах	9	f	0	HwEW2XcAmw	2025-08-07 16:30:18.879+00	2025-08-08 07:17:20.792+00	f	f	2025-08-08 07:17:20.792+00	0	f
1518	59	95376630	дархан	3	0.00	ирэхээсээ өмнө залгах	14	f	0	nBdEFGGmPX	2025-08-07 16:00:53.383+00	2025-08-08 04:16:16.411+00	f	f	2025-08-08 04:16:16.411+00	0	f
1516	59	99551049	Эрдэнэт хот	3	0.00	ирэхээсээ өмнө залгах	14	f	0	CLlXwjkKKG	2025-08-07 15:40:52.82+00	2025-08-08 04:18:02.893+00	f	f	2025-08-08 04:18:02.893+00	0	f
1509	6	88369606	БЗД Газарчин 1 байр 24тоот	3	298000.00	Өдөртөө багтаж хүргэгдэнэ.	14	f	0	oE2FpGiDHf	2025-08-07 14:08:23.34+00	2025-08-08 05:14:35.703+00	f	f	2025-08-08 05:14:35.702+00	0	f
1526	58	88053358	40 bairnaas irj awsan aldar	3	90000.00	ulaan hairtsagtaigas 1sh	3	f	0	Q5zv4zmBTW	2025-08-08 03:18:30.816+00	2025-08-25 07:58:22.003+00	f	f	2025-08-08 07:15:39.247+00	0	f
1515	59	80675387	БЗД 13 хороо 15 гудамж 556 тоот 	3	35000.00	ирэхээсээ өмнө залгах	9	f	0	ZaaKWUXXxG	2025-08-07 15:38:06.006+00	2025-08-08 07:01:13.992+00	f	f	2025-08-08 07:01:13.992+00	0	f
1519	59	91220017	Баруун салаа СХД 24р хороо зээл 31-1	3	0.00	ирэхээсээ өмнө залгах	14	f	0	X8d9R1WtZg	2025-08-07 16:01:58.303+00	2025-08-08 07:54:23.037+00	f	f	2025-08-08 07:54:23.037+00	0	f
1507	6	86981089	БЗД 26 хороо Элизабет хотхон. 214 байр 3 орц 9давхар 213 тоот	3	85500.00	08ндаа заавал амжиж өгөх.	9	f	0	wVbRLu92Lc	2025-08-07 14:03:57.496+00	2025-08-08 09:17:43.269+00	f	f	2025-08-08 09:17:43.269+00	0	f
1512	59	88217366	хангарьд 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	It53Wnnakj	2025-08-07 15:30:48.854+00	2025-08-08 10:40:56.584+00	f	f	2025-08-08 10:40:56.583+00	0	f
1514	59	91198244	БЗД santo tower 713 байр 1 орц 12 давхар 1202 тоот	3	0.00	ирэхээсээ өмнө залгах	9	f	0	rLLYAClh7E	2025-08-07 15:35:58.616+00	2025-08-08 09:29:53.95+00	f	f	2025-08-08 09:29:53.95+00	0	f
1502	59	86246446	100 айл иргэний бүртгэлээс урагшаа яваад мапан дээр барилгачин бумбат гарч ирнэ тэрний эсрэг талд 6 хаалгатай 1 давхар  чандмань гээд ногоон  дэлгүүр тэрний 3 дахь хаалга	3	0.00	ирэхээсээ өмнө залгах	9	f	0	tXluk8OS81	2025-08-07 06:19:59.61+00	2025-08-08 09:31:01.831+00	f	f	2025-08-08 09:31:01.828+00	0	f
1534	6	99044909	100 ailin shine ail bair 601 toot	3	0.00	onoodor 	9	f	0	J3RcWqXyEH	2025-08-08 09:23:28.941+00	2025-08-08 09:44:17.923+00	t	f	2025-08-08 09:44:17.923+00	0	f
1500	59	94627402	БГД 16 хороо гандангийн 60 айл 3 р орц 1 давхар 44 тоот	3	0.00	ирэхээсээ өмнө залгах	9	f	0	OtaHoq6Bbm	2025-08-07 06:00:59.69+00	2025-08-08 10:52:48.693+00	f	f	2025-08-08 10:52:48.693+00	0	f
2373	77	99055402 	6tsag hurtel eruul mendin yamni urd talin	2	18000.00	zalgaa shilen bair ireed zalga	73	f	0	NgWJ7tdfLF	2025-08-26 03:24:57.647+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
1724	61	95758950	Офицер Алдар спорт хороо 10к байр	3	29900.00	тооцоо хийгээгүй	14	f	0	snBH8zqHQu	2025-08-15 02:46:58.786+00	2025-08-15 11:16:53.65+00	f	f	2025-08-15 11:16:53.65+00	0	f
1508	6	88125424	Оргил стар хотхон. 59байр 3 орц 8дав 77 тоот	3	38500.00	орцны код 5903#	9	f	0	1jBmBsyicn	2025-08-07 14:05:46.205+00	2025-08-08 15:16:51.198+00	f	f	2025-08-08 15:16:51.198+00	0	f
1528	19	80862689	Хархорин худалдааны төв 5 давхар 158 лангуу	3	86000.00	төлбөр  танайх  авна	9	f	0	fmlFcchkE5	2025-08-08 06:34:04.45+00	2025-08-09 09:30:09.705+00	f	f	2025-08-09 09:30:09.705+00	0	f
1533	20	88607050	ХУД, 3-р хороо  Дэлгэр хотхон 67а-126 тоот	3	1.00	төлбөр авахгүй	9	f	0	Yv9bUNiaGq	2025-08-08 08:54:52.614+00	2025-08-09 05:44:21.49+00	f	f	2025-08-09 05:44:21.49+00	0	f
1532	20	99288128	Seven star residence, Зайсан	3	1.00	төлбөр авахгүй	9	f	0	YKVFHPbMQW	2025-08-08 08:54:18.844+00	2025-08-09 06:25:01.525+00	f	f	2025-08-09 06:25:01.525+00	0	f
1530	19	99551360	Баянзүрх дүүрэг 26хороо энканто 3	3	86000.00	төлбөр  танайх  авна	24	f	0	SecfknlWcR	2025-08-08 07:39:18.976+00	2025-08-09 10:16:02.651+00	f	f	2025-08-09 10:16:02.651+00	0	f
1525	19	96004382	Tahilt 33 horoo 8gudamj 79toot	3	86000.00	төлбөр  танайх  авна. эртхэн хүргээрэй. эхлээд залгаарай	9	f	0	9Adk8ye5iA	2025-08-08 02:59:25.179+00	2025-08-09 07:38:51.954+00	f	f	2025-08-09 07:38:51.953+00	0	f
1529	19	95120134	Баянгол дүүрэг horoolol 13a	5	86000.00	төлбөр  танайх  авна	9	f	0	Tsei5IuCzj	2025-08-08 07:22:24.907+00	2025-08-09 06:53:09.883+00	f	f	\N	0	f
1523	59	90503088	дөлгөөн нуур 211 байр 15 давхар 1503	3	0.00	ирэхээсээ өмнө залгах	9	f	0	AnrXAM0kh2	2025-08-07 17:14:54.273+00	2025-08-09 10:25:43.333+00	f	f	2025-08-09 10:25:43.333+00	utsa avaguu	f
1701	59	86177860	өмнөговь	3	0.00	ирэхээсээ өмнө залгах	69	f	0	Bo8XKzvCzq	2025-08-14 09:23:37.965+00	2025-08-15 05:48:55.217+00	f	f	2025-08-15 05:48:55.217+00	0	f
1551	19	85256898	Цогт-Эрдэнэ Чингэлтэй дүүрэг 18хороо Яргайтын 33 489 85256898	3	86000.00	төлбөр танайх авна	9	f	0	BOvQEYh9lV	2025-08-09 05:12:07.359+00	2025-08-09 20:23:05.536+00	f	f	2025-08-09 20:23:05.535+00	0	f
1548	6	95683171	bzd duureg 36r horoo baynmongol horoolol 412 bair 2orts 16 toot	3	0.00	onoodor	24	f	0	PQ0ctXF96V	2025-08-09 04:53:15.943+00	2025-08-09 09:42:02.934+00	t	f	2025-08-09 09:42:02.934+00	0	f
1550	6	85601414	tomor zamiin deed surguuli baruun tald 13 dawhar bor bair 47b 35 toot	3	0.00	onooodor	9	f	0	lSQsgtu97e	2025-08-09 04:56:30.786+00	2025-08-09 20:23:21.089+00	t	f	2025-08-09 20:23:21.089+00	arai iregu bga	f
1549	6	96224484 94413181	king tower 143 bair 3dawhart venus kidsd	3	0.00	onooodr	24	f	0	uBWYZwpCw4	2025-08-09 04:54:43.384+00	2025-08-09 09:56:36.676+00	t	f	2025-08-09 09:56:36.676+00	0	f
1541	21	99176789	Altai hithonii urd Hongor appartment 2 orts 10dav 107 toot	3	0.00	Tsatsral-d	9	f	0	tO9JDaIZO7	2025-08-08 12:40:55.734+00	2025-08-09 05:36:37.788+00	t	f	2025-08-09 05:36:37.788+00	0	f
1645	62	99905352	Чойжин ламын сүм музейн касс	3	1.00	Муйзей хаасан байвал, харуулд орхих	9	f	0	5oA0TyakrS	2025-08-13 04:48:46.355+00	2025-08-14 15:19:25.756+00	f	f	2025-08-14 15:19:25.756+00	0	f
1566	59	99340462	модны 2 grand hill урд талын bank тай байр 3 давхар 10 тоот 	3	0.00	ирэхээсээ өмнө залгах	14	f	0	MfdTBx2owi	2025-08-09 15:34:14.104+00	2025-08-12 09:45:38.844+00	f	f	2025-08-12 09:45:38.844+00	utasn holbogdoh bolomjguu	f
1702	61	88058670	Баянхошуу 7-р хороо 16-ийн 1-р хаалга 	3	29900.00	Захиалсан, төлбөр төлөх хүний дугаар 99235951	3	f	0	yRhn6ErfVJ	2025-08-14 09:24:09.353+00	2025-08-19 09:00:52.512+00	f	f	2025-08-19 09:00:52.512+00		f
1540	21	80028383	king tower 145 bair 241 toot	3	0.00	solo-d	9	f	0	YsKmqnA3Nx	2025-08-08 12:39:50.651+00	2025-08-09 12:11:51.416+00	t	f	2025-08-09 12:11:51.416+00	utas n ogt bolohgui baisan	f
1545	19	96004382	Tahult 33 horoo 8d gudamj 79n toot	5	86000.00	төлбөр танайх авна	9	f	0	PgPcHImcl9	2025-08-09 02:15:33.61+00	2025-08-09 05:07:42.325+00	f	f	\N	0	f
1536	4	99809963	БЗД 1 хороо Автай сайн хотхон 75б байр баруун талын орц, 4давхар 410тоот #0099#	3	1.00	.	24	f	0	77kYBCnN1l	2025-08-08 11:41:27.546+00	2025-08-09 06:34:37.879+00	f	f	2025-08-09 06:34:37.879+00	0	f
1537	18	80031260	Hanbogd hothon 405-r bair narka salon	3	36000.00	ulaan top	9	f	0	LTwHJtcfSX	2025-08-08 12:36:26.787+00	2025-08-09 06:47:55.156+00	f	f	2025-08-09 06:47:55.156+00	0	f
1544	19	96690635	Баянзүрх дүүрэг 5р хороо 1000 оюутны байр 96690635	3	86000.00	төлбөр  танайх  авна	24	f	0	9JbmX8kl2U	2025-08-08 15:20:35.762+00	2025-08-09 07:00:24.492+00	f	f	2025-08-09 07:00:24.492+00	0	f
1559	21	88076907	13n sunday plaza 4 dav 4049 languu	3	0.00	Nar Nar-d	9	f	0	oLMCIiK62r	2025-08-09 12:46:58.571+00	2025-08-10 06:42:19.205+00	t	f	2025-08-10 06:42:19.205+00	0	f
1546	19	80476708 	16р хороолол газарчингийн 1-р байр 3-р орц 4-н давхарт 53тоот 804 20sh76708	3	1.00	би өөрөө  авч байгаа.өнөөдөр заавал  хүргэх .хөдөө авч явах тул	24	f	0	FL1wm36KKZ	2025-08-09 03:18:56.264+00	2025-08-09 07:25:29.705+00	f	f	2025-08-09 07:25:29.705+00	0	f
1554	2	95351953	erdentruu 50l horogch tawih 	3	0.00	anhaagiin duun awtsan	3	f	0	kQ17d4vyUc	2025-08-09 05:56:04.67+00	2025-08-09 07:30:57.641+00	t	f	2025-08-09 07:30:57.641+00	0	f
1542	21	94280980	5 shar 13A bair 34 toot	3	0.00	Ganaa-d. 96880980	9	f	0	OzPxZcCCOq	2025-08-08 12:41:50.904+00	2025-08-09 08:34:43.163+00	t	f	2025-08-09 08:34:43.163+00	0	f
1527	20	80116063	БЗД , Япон Монголын эмнэлэгийн баруун талд Сэрэнэ таун хотхон  80б байр 2-р орц 3 давхар 69 тоот	3	1.00	төлбөр авахгүй	24	f	0	sJwqwUrHNX	2025-08-08 05:15:13.205+00	2025-08-09 08:37:22.556+00	f	f	2025-08-09 08:37:22.556+00	0	f
1543	21	88990232	Tsagdaagin akademin zuun tald sondgoi 12 dav bair. 16 bair 82 toot	3	0.00	Otgonjargal-d 	24	f	0	k3jKO19RRV	2025-08-08 12:42:48.663+00	2025-08-09 08:37:49.788+00	t	f	2025-08-09 08:37:49.788+00	0	f
1539	21	88928282	SHD 21 horoolol chingis soosa-n baruun tald Chuhag hothon 32 bair 5dav 19 toot	3	0.00	Enhzol-d.	9	f	0	yGpfX4CwNM	2025-08-08 12:38:20.294+00	2025-08-09 08:56:42.911+00	t	f	2025-08-09 08:56:42.911+00	0	f
1538	21	99078710	BZD 26 horoo Olymp hothon 430 bair 2 orts 2 dav 85 toot	3	0.00	ch. uyan-d. 12s umnu irwel sain bna	24	f	0	M2gF3lK8OF	2025-08-08 12:37:18.853+00	2025-08-09 09:18:36.293+00	t	f	2025-08-09 09:18:36.293+00	0	f
1740	21	99231930	hunnu mollin zamiid urd artsat 1 	3	0.00	onoodor	68	f	0	BjENg55JF5	2025-08-15 13:03:23.555+00	2025-08-15 14:50:23.859+00	t	f	2025-08-15 14:50:23.859+00	0	f
2374	26	80903399	altai hothon urd gerlen dooroo cu tei hongor apartment 14 dawhar bor bair 2 orts 9 dawhar 103 har	2	50000.00	har tsag	78	f	0	Ryl0HzNAI2	2025-08-26 03:25:35.726+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
1725	61	80362828	БГД 3-р хороо 63-р байр 37 тоот	3	29900.00	тооцоо хийгээгүй	69	f	0	pFgETNJtIS	2025-08-15 02:48:21.063+00	2025-08-15 10:36:14.04+00	f	f	2025-08-15 10:36:14.04+00	0	f
2323	77	86010778 	10r horoolol zamiin urd tald 	2	18000.00	49/3-7 toot	9	f	0	JWQSNTVLU7	2025-08-25 14:06:27.166+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
1547	19	94110269	хан уул  дүүрэг 15р хороо цэнгэлдэх  хотхоны 203  ын 1604 тоот	5	86000.00	төлбөр  танайх  авна	9	f	0	eSuszj4xp3	2025-08-09 03:30:33.301+00	2025-08-10 08:05:53.67+00	f	f	\N	hayag deer unuudur bhq mar avna	f
1558	21	88289393	Hurd rapid horoolol 3-131 toot	3	0.00	tseegii ulzii+d	9	f	0	QgYwxhfnNn	2025-08-09 12:46:16.326+00	2025-08-10 08:22:19.848+00	t	f	2025-08-10 08:22:19.848+00	0	f
1739	21	99078710	BZD 26 horoo Olymp hothon 430 bair 2orts 2 dav 85 toot	3	0.00	ch.uyan-d 	9	f	0	CpvJa62Jyr	2025-08-15 11:54:19.802+00	2025-08-16 11:47:36.703+00	t	f	2025-08-16 11:47:36.703+00	0	f
1560	21	88882439	10horoollin urd avtobus buudliin arkaar garaad Busgui emnelgiin hajuud sondgoi 6dav bair 5dav 22 toot	3	0.00	oyunaa-d	9	f	0	fviuOZf3pO	2025-08-09 12:48:16.073+00	2025-08-10 13:13:35.287+00	t	f	2025-08-10 13:13:35.287+00	0	f
1557	46	88155579	11 horoolol uwur mongol hoteliin zuun urd Diamond lounge  deer	3	199000.00	проектор\n8 аас өмнө	9	f	0	HxGffCLad6	2025-08-09 12:15:56.105+00	2025-08-10 14:44:51.989+00	f	f	2025-08-10 14:44:51.989+00	0	f
1531	19	99120789	Bzd tsaiz zah 99120789	5	86000.00	төлбөр  танайх  авна	9	f	0	ijNCkDpb8G	2025-08-08 08:42:42.846+00	2025-08-11 05:14:21.192+00	f	f	\N	margash avna	f
1773	52	95262146	Sapporoo 4 r bair 20 toot A/Busnii buudaliin ard bdg	3	6000.00	b	14	f	0	D8EY0M400y	2025-08-15 17:56:26.552+00	2025-08-16 12:00:05.912+00	f	f	2025-08-16 12:00:05.912+00	0	f
1672	61	99956202	1-р хороолол Барс-2 зах 	3	29900.00	тооцоо хийгээгүй	3	f	0	1KjMgelKBc	2025-08-14 03:52:29.909+00	2025-08-18 08:20:07.85+00	f	f	2025-08-18 08:20:07.849+00	margash avna	f
1555	10	5458876	hsvnajz	5	10400.00	bsjjaa	3	f	0	wZdgQZLaJQ	2025-08-09 06:24:07.249+00	2025-08-20 06:42:53.508+00	f	f	\N	3 zalgad utasa awagui	f
1588	20	96882222	11 хороолол (Сити сургуулийн чанх ард) Хийморь 12А байр 4 давхарт 33 тоот	3	1.00	төлбөр авахгүй	9	f	0	pJCuiAoLHo	2025-08-11 03:46:12.979+00	2025-08-11 10:55:16.284+00	f	f	2025-08-11 10:55:16.284+00	0	f
1574	21	88109640	narnii zam Nogoon tugul hothon 78 bair 4dav 15toot	3	0.00	Uuganaa Badam-d	9	f	0	iYrl6P5QQV	2025-08-10 09:48:25.321+00	2025-08-11 14:08:05.845+00	t	f	2025-08-11 14:08:05.844+00	0	f
1572	6	99666920	narantuul zah deer hurgej ogoh	3	0.00	onoodor	9	f	0	sXRQS9cj5D	2025-08-10 05:28:18.69+00	2025-08-10 06:12:55.119+00	t	f	2025-08-10 06:12:55.119+00	0	f
1570	19	88113294	өмнөговь даланзадгад унаанд тавих	3	86000.00	төлбөр танайх авна	9	f	0	f7fFKjs1Tp	2025-08-10 04:06:31.42+00	2025-08-10 07:03:51.955+00	f	f	2025-08-10 07:03:51.955+00	0	f
1569	19	88095659	Орхон аймаг унаанд  тавих	3	86000.00	төлбөр  танайх авна	9	f	0	nSxwggyDPE	2025-08-10 03:27:46.395+00	2025-08-10 07:47:09.553+00	f	f	2025-08-10 07:47:09.553+00	0	f
1564	59	85559911	замын үүд 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	C28KDM4zFJ	2025-08-09 14:50:29.953+00	2025-08-10 07:47:21.704+00	f	f	2025-08-10 07:47:21.704+00	0	f
1561	59	88702149	яармаг арцат 2 1443 1 р орц 11 давхар 43 тоот	3	35000.00	ирэхээсээ өмнө залгах	9	f	0	CpxTjcvNvt	2025-08-09 13:27:28.004+00	2025-08-10 11:50:47.523+00	f	f	2025-08-10 11:50:47.523+00	0	f
1563	59	96919808	1 р хорооллын 29 р хороо москва APARTMENT 132/1 13 давхар 1301 тоот 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	u7nOpaPluR	2025-08-09 14:45:20.184+00	2025-08-10 12:44:51.082+00	f	f	2025-08-10 12:44:51.082+00	0	f
1586	19	94416902	Чингэлтэй дүүрэг 8-р хороо зүүн тасган 15б нийтийн байр 2-тоот. 94416902	3	86000.00	төлбөр танайх авна	9	f	0	oqGHU11K1m	2025-08-11 03:38:28.164+00	2025-08-13 09:52:32.798+00	f	f	2025-08-13 09:52:32.798+00		f
1571	6	94393779	govi altai narantuul zahaas tawih	3	0.00	onoodor	9	f	0	hPuQsdKz0v	2025-08-10 05:27:29.2+00	2025-08-10 13:16:24.242+00	t	f	2025-08-10 13:16:24.242+00	utsa avaguu	f
1567	19	99105704	Moskva horoolol 8r bair	3	86000.00	төлбөр танайх авна	9	f	0	8JbqKrQzG2	2025-08-10 02:45:25.746+00	2025-08-10 13:30:45.85+00	f	f	2025-08-10 13:30:45.85+00	0	f
1565	59	99931549	11хороолол	3	37000.00	ирэхээсээ өмнө залгах	9	f	0	JIamjNRCcM	2025-08-09 14:59:50.196+00	2025-08-10 14:08:28.486+00	f	f	2025-08-10 14:08:28.486+00	0	f
1573	6	88541771	bzd duureg ulaanhuaran etses 750 bair	3	0.00	onoodor	9	f	0	WdsULweHKC	2025-08-10 05:29:38.749+00	2025-08-11 03:56:14.152+00	t	f	2025-08-11 03:56:14.152+00	0	f
1726	61	99157685	Яармаг Шинэ хотын захиргаа Арцат 2 хотхон 1432р  байр 12 давхарт 105 тоот	3	29900.00	тооцоо хийгээгүй	68	f	0	oCsLxGlI9F	2025-08-15 02:51:29.033+00	2025-08-15 09:43:30.005+00	f	f	2025-08-15 09:43:30.005+00	0	f
1620	6	99926930	misheel ekspo baruun tald 84r bair 2 orts 2 davhar 61toot	3	0.00	dugaargui	14	f	0	XnkmLAiY9C	2025-08-12 03:00:00.235+00	2025-08-12 06:23:38.678+00	t	f	2025-08-12 06:23:38.677+00	0	f
1584	19	89779922	Bzd 21 r horoo 6 dugaar gudamj 1588 toot	3	86000.00	төлбөр танайх авна	9	f	0	2UAGwfHAid	2025-08-11 02:37:45.55+00	2025-08-12 06:43:21.794+00	f	f	2025-08-12 06:43:21.794+00	0	f
1638	52	80999269	Hunnu 2222 1r eelj 113d 11dawgart 11D toot	3	6000.00	n	9	f	0	rqx2Miz7H9	2025-08-12 18:27:30.783+00	2025-08-13 13:04:55.535+00	f	f	2025-08-13 13:04:55.535+00	0	f
1568	19	80982728	3,4 хороолол Coral center	3	86000.00	төлбөр танайх авна	14	f	0	weszrz6rvJ	2025-08-10 02:57:57.935+00	2025-08-12 10:14:44.074+00	f	f	2025-08-12 10:14:44.074+00	odo hayg deer bhgu bga margash avna	f
1585	19	99051044	дүнжингарав хотхоны 105-2 тоот	3	86000.00	төлбөр танайх авна	9	f	0	g2GKEUMF69	2025-08-11 02:54:54.313+00	2025-08-13 13:24:24.39+00	f	f	2025-08-13 13:24:24.39+00	0	f
1576	21	99046626	hunnu 2222 116 bair 16A toot.	3	0.00	Solongoo-d. kod:  ##1161#	3	f	0	XPDmLrqS8X	2025-08-10 09:51:41.8+00	2025-08-11 05:19:10.013+00	t	f	2025-08-11 05:19:10.013+00	0	f
1575	21	88928282	SHD 21horoolol chingis soosa baruun tald Chuhag hothon 32b bair 5dav 19 toot	3	0.00	Enhzol-d. kod: 28 tulhuur 1355	9	f	0	9FPhk3ybaq	2025-08-10 09:50:20.936+00	2025-08-11 06:33:29.604+00	t	f	2025-08-11 06:33:29.604+00	0	f
1562	21	89115478	huuchin buyant uhaa niseh ongotsnii buudliin baruun hoino officed awna	3	0.00	bilgeed. 1deh udur buyu 8/11nd awna	3	f	0	tb2543zHYO	2025-08-09 14:17:01.037+00	2025-08-11 06:57:13.649+00	t	f	2025-08-11 06:57:13.649+00	margash avna	f
1577	21	89002859	yarmag shunshig villa 2 hothon. 61A bair 5dav 33 toot	3	0.00	Dolgorsuren-d	3	f	0	o0i4UVw4Jq	2025-08-10 09:52:47.773+00	2025-08-11 06:57:17.559+00	t	f	2025-08-11 06:57:17.559+00	0	f
1583	21	99998487	erdenetruu unaand tavih	3	0.00	joloochin utasnii dugaariig zaawal yawuulah. zula-d	3	f	0	QgXMydyR73	2025-08-11 02:15:58.166+00	2025-08-11 05:18:46.054+00	t	t	2025-08-11 05:18:46.054+00	0	f
1582	21	80869420	Narnii horoolol 2 bair 3dav 11 toot	3	0.00	Odonchimeg-t	3	f	0	lelZ0iMAzs	2025-08-11 00:52:31.685+00	2025-08-11 05:18:52.619+00	t	f	2025-08-11 05:18:52.619+00	0	f
1579	21	99002102	Darhanluu unaand uguh, daivart uguh	3	0.00	Basbish Baagii-d. unaand uguud joloochiin utasnii dugaariig zaaval uguh. 	3	f	0	JeWHipjQFr	2025-08-10 12:37:15.07+00	2025-08-11 05:18:59.676+00	t	f	2025-08-11 05:18:59.676+00	0	f
1578	21	99185035	zaisan White Hill hothon 100/3 bair 9dav 901 toot	3	0.00	Uyanga-d	3	f	0	ujkqCcsgr4	2025-08-10 11:34:14.819+00	2025-08-11 05:19:04.17+00	t	f	2025-08-11 05:19:04.17+00	0	f
1587	20	99668160	25 эмийн сан kpc эсрэг талд Ази товер 10 давхар байрны 6 давхарт	3	1.00	төлбөр авахгүй	9	f	0	HCMifcU8VP	2025-08-11 03:45:41.646+00	2025-08-11 07:44:02.773+00	f	f	2025-08-11 07:44:02.772+00	0	f
1581	19	80889815	25 emiin san 34 р байр 7тоот	3	86000.00	төлбөр танайх авна	9	f	0	MUYKY8i5Zt	2025-08-10 13:34:06.942+00	2025-08-11 08:00:43.952+00	f	f	2025-08-11 08:00:43.952+00	0	f
1580	46	89116091	10 r horoolol zamiin urd taliin hishig mongol zoogiin zvvn tald 49A bair b1 davhar	3	199000.00	проектор	9	f	0	fgVBhcyHgO	2025-08-10 13:11:49.081+00	2025-08-11 08:26:53.958+00	f	f	2025-08-11 08:26:53.957+00	0	f
1722	19	86038060	Хөвсгөл аймаг даргонаас 14 цагаас явна	5	86000.00	төлбөр танайх авна.	69	f	0	jwb73KYqq1	2025-08-15 01:52:52.697+00	2025-08-15 07:41:56.656+00	f	f	\N	0	f
1703	61	96530417	Гэмтлийн эмнэлэг Баруун дэнж 999 хотхон 2р байр 2 давхар 211 тоот 	3	29900.00	тооцоо хийгээгүй	69	f	0	0Ofsvk84ps	2025-08-14 09:26:59.681+00	2025-08-15 07:12:24.209+00	f	f	2025-08-15 07:12:24.209+00	0	f
1713	59	90050112	БГД 17 р хороо global 80-2 apartment	3	0.00	ирэхээсээ өмнө залгах	69	f	0	oNFU6zz06Y	2025-08-14 10:35:48.559+00	2025-08-15 09:10:12.978+00	f	f	2025-08-15 09:10:12.978+00	0	f
1673	61	99624320	СБД 9-р хороо 274-р байр 1203 тоот 99624320	5	29900.00	тооцоо хийгээгүй	9	f	0	tl0hcvVR4t	2025-08-14 03:56:05.425+00	2025-08-18 02:40:17.442+00	f	f	\N	tsutsalsan	f
1761	61	89436063	Nisehiin toirog Active garden hothon 506 bair 78 toot	3	29900.00	tootsoj hiigeegvi	14	f	0	a40WPzq90W	2025-08-15 15:56:08.601+00	2025-08-16 10:44:39.548+00	f	f	2025-08-16 10:44:39.548+00	0	f
1593	19	90033302	7n buudliin awtuusnii buudal	5	86000.00	төлбөр танайх авна	9	f	0	xdefRxtnCM	2025-08-11 06:56:10.441+00	2025-08-13 14:01:36.321+00	f	f	\N	margash avna	f
1765	52	99896920	Narnii horoolol 22 r bair 3-301 toot	3	6000.00	Yaaraltai heregtei ert awah	9	f	0	YnxlZdGpm7	2025-08-15 17:47:21.464+00	2025-08-17 07:58:35.387+00	f	f	2025-08-17 07:58:35.386+00	unand tawan barn hara	f
1589	20	99038905	СБД 11р хороолол 7р хороо 5А байр 30 тоот	3	1.00	төлбөр авахгүй	9	f	0	qMpBjvaUSj	2025-08-11 03:47:00.038+00	2025-08-11 10:47:54.831+00	f	f	2025-08-11 10:47:54.831+00	0	f
1741	59	85161105	 сүхбаатар даринга 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	CIG3pvklDW	2025-08-15 14:57:45.591+00	2025-08-16 09:49:08.126+00	f	f	2025-08-16 09:49:08.126+00	0	f
1735	21	88121649	BZD 39 horoo ulaanhuaran, Tenuun hothonii hoid tald 17/1 bair 904 toot	3	0.00	Uugantsetseg-t. 	9	f	0	T3YVdtTVoJ	2025-08-15 09:09:43.473+00	2025-08-16 09:52:18.3+00	t	f	2025-08-16 09:52:18.3+00	0	f
1591	6	88857382	bzd  kino uildwer happy taun 2orts 11dawhart 131	3	0.00	onooodor	9	f	0	HJziyPEFwY	2025-08-11 05:03:30.302+00	2025-08-11 11:46:13.194+00	t	f	2025-08-11 11:46:13.194+00	0	f
1590	6	80404217	bzd 39 horoo peart citi hothon 13.1bair 1001 toot	3	0.00	onoodor	9	f	0	zuocmBvPOq	2025-08-11 05:01:50.112+00	2025-08-11 13:05:56.116+00	t	f	2025-08-11 13:05:56.116+00	0	f
1704	59	88079024	нарны зам миний дэлгүүр баруун талд 123 шаргал байр	3	0.00	ирэхээсээ өмнө залгах	9	f	0	Y1aF4R7kUw	2025-08-14 09:29:06.39+00	2025-08-15 07:03:21.689+00	f	f	2025-08-15 07:03:21.689+00	0	f
1727	61	88884287	бзд 25-р хороо Ногоон төгөл хотхон 75р байр 11 давхар 50 тоот 	3	29900.00	тооцоо хийгээгүй	14	f	0	Ml38OX58ME	2025-08-15 02:53:38.459+00	2025-08-15 07:03:36.886+00	f	f	2025-08-15 07:03:36.886+00	0	f
1674	61	94423030	Баян-өлгий аймаг	3	0.00	Орон нутаг	69	f	0	yhTTM9Xcg0	2025-08-14 03:58:23.352+00	2025-08-15 08:04:29.879+00	t	t	2025-08-15 08:04:29.879+00	0	f
1707	59	86697427	нисэх фемида хотхон 692 байр 14 давхар 1405 тоот 	3	0.00	ирэхээсээ өмнө залгах	68	f	0	0ecpxiQx5Z	2025-08-14 09:34:49.428+00	2025-08-15 09:43:00.451+00	f	f	2025-08-15 09:43:00.451+00	0	f
1664	52	80499849	Tuw aimag yawah unaand tawina.	3	6000.00	Zalgaj unaanii dugaar heleh ( yaaraltai)	68	f	0	hBwUYAazxh	2025-08-13 18:44:55.937+00	2025-08-15 10:02:15.588+00	f	f	2025-08-15 10:02:15.588+00	0	f
2376	84	88920223	Нарантуул зах өндөг -1	2	36000.00	17 цаг хүртэл байна	66	f	0	zbBgVLsZlO	2025-08-26 03:45:19.274+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2325	77	99096699 	13horoolol arslantai guurni baruun talin	2	25000.00	27/6r bair 14toot 	73	f	0	PZK99Db51b	2025-08-25 14:07:18.714+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
1596	19	91179495	91179495Бзд 42 хороо цагаанхуран 90в 3 давхар 15 тоот	3	86000.00	төлбөр танайх авна	9	f	0	olMIM3TooU	2025-08-11 10:14:48.809+00	2025-08-12 07:36:58.885+00	f	f	2025-08-12 07:36:58.885+00	0	f
1595	19	99751153	хан уул дүүрэг 24р хороо Богд Bella хотхон 1207р байр 3р орц 5давхар 18 тоот	3	86000.00	төлбөр танайх авна	14	f	0	EMXzTIN6ob	2025-08-11 09:54:18.091+00	2025-08-12 07:53:52.185+00	f	f	2025-08-12 07:53:52.185+00	0	f
1594	19	88313260	3,4 хорооллын эцэс	3	86000.00	төлбөр танайх авна	14	f	0	LJEaEECleF	2025-08-11 07:01:43.843+00	2025-08-12 10:54:03.146+00	f	f	2025-08-12 10:54:03.146+00	0	f
1597	21	96880980	5n shar 13A bair 34 toot	3	0.00	Ganaa-d	14	f	0	9fSHTGTUBg	2025-08-11 10:53:34.154+00	2025-08-12 12:13:51.574+00	t	f	2025-08-12 12:13:51.574+00	0	f
1592	19	95566587	Сийлэгмаа Baynzurhiin nomintoi bairnii baruun talyn hondlon bair 90b 95566587	3	86000.00	төлбөр танайх авна	9	f	0	DbxK4id6ny	2025-08-11 06:50:59.967+00	2025-08-12 15:22:38.293+00	f	f	2025-08-12 15:22:38.293+00	0	f
1774	52	80802277	Bluesky hotel 1 dawhart	3	6000.00	Zalgaj baigaa eseh asuuh	9	f	0	dyiDklGou2	2025-08-15 17:56:57.573+00	2025-08-16 06:39:49.191+00	f	f	2025-08-16 06:39:49.191+00	0	f
1734	21	80960202	tuv shuudangiin ard Montel gar utasnii gazar. udriin tsagaar	3	0.00	Hongoroo-d. 	9	f	0	gZhKxSBq1N	2025-08-15 09:08:38.443+00	2025-08-16 06:45:46.372+00	t	f	2025-08-16 06:45:46.371+00	0	f
1806	59	88580646	завхан тосонцэнгэл 4 автобус	3	0.00	ирэхээсээ өмнө залгах	9	f	0	kvqwbLqWJO	2025-08-16 14:58:44.215+00	2025-08-17 08:36:11.173+00	f	f	2025-08-17 08:36:11.173+00	0	f
1777	52	89117578	BZD 30r horoo Sansar Ktms iin MT kolonkoos hoishoo chigere ger horoololru ugsuud 100 m yawhad zamd hothin bga 5 n dawhar bairuud 54r bairnii 7 toot	3	6000.00	kodg	9	f	0	UffxOUIPn3	2025-08-15 17:59:31.485+00	2025-08-16 09:03:52.046+00	f	f	2025-08-16 09:03:52.046+00	0	f
1775	52	80910500	HUD 19 r horoo UB town 81 b 2 r orts 7-40toot	3	6000.00	b	14	f	0	jC8wDF1NHQ	2025-08-15 17:57:51.233+00	2025-08-16 09:30:41.333+00	f	f	2025-08-16 09:30:41.333+00	0	f
1738	21	80122266	yarmag 1r buudal Deedsiin urguu hothon 909/2 bair 5dav 26 toot	3	0.00	Bolor-Erdene-d	14	f	0	feTmGKaK1v	2025-08-15 11:51:51.338+00	2025-08-16 10:19:52.115+00	t	f	2025-08-16 10:19:52.115+00	0	f
1763	52	88118041	Ikh mongol horoolol 901 r bair 2 orts 102 toot	3	6000.00	s	9	f	0	MdOzkQcaQB	2025-08-15 17:45:28.107+00	2025-08-16 11:01:04.607+00	f	f	2025-08-16 11:01:04.607+00	0	f
1752	59	86016884	бичил хороолол 13 р байр 4р орц 5 давхар 126 тоот 	3	0.00	ирэхээсээ өмнө залгах	14	f	0	nhcGaoMPhh	2025-08-15 15:21:19.022+00	2025-08-16 12:59:54.159+00	f	f	2025-08-16 12:59:54.159+00	0	f
1776	52	86311131	Gerege tower 3-302 toot	3	6000.00	n	9	f	0	55Tmel5xi8	2025-08-15 17:58:18.482+00	2025-08-16 14:03:22.83+00	f	f	2025-08-16 14:03:22.83+00	0	f
1795	59	86180775	БГД 18 хороо 44 байр 1 дүгээр орц 11 давхар   	3	0.00	ирэхээсээ өмнө залгах	9	f	0	XgwgCkDwyV	2025-08-16 13:26:01.273+00	2025-08-17 10:24:18.53+00	f	f	2025-08-17 10:24:18.53+00	0	f
1813	61	99762021	мишээл экспо баруун талд 92а байр 10 тоот	3	29900.00	тооцоо хийгээгүй	3	f	0	khpNokVfJ4	2025-08-17 01:51:22.289+00	2025-08-17 13:09:55.217+00	f	f	2025-08-17 13:09:55.217+00	0	f
1788	21	95348802	Erdenetiin unaand tawina	3	0.00	Nomuundati-d. unaand uguud joloochiin dugaariig zaaval yawuulah	3	f	0	rPRRWc59g1	2025-08-16 13:02:06.206+00	2025-08-17 11:05:35.071+00	t	t	2025-08-17 11:05:35.071+00	0	f
1733	6	88707616	nisehiin mnii delguures ochij baraa awna	5	0.00	onoodoor oroi	3	f	0	5oaXOjkC4V	2025-08-15 05:38:13.678+00	2025-08-17 02:54:03.334+00	t	f	\N	0	f
1754	61	99066025	Баялаг ундраа төв 2 давхар 154-р лангуу	3	29900.00	тооцоо хийгээгүй	9	f	0	YSMJhOb3yi	2025-08-15 15:29:10.563+00	2025-08-18 08:43:00.063+00	f	f	2025-08-18 08:43:00.063+00		f
1598	21	96000952	zaisan grandemed emneleg. udur 16:00s umnu 	5	0.00	Erdeneoyu-d. idir 16:00s umnu awah	9	f	0	urTMXH92E9	2025-08-11 10:54:48.453+00	2025-08-13 04:30:42.218+00	t	f	\N	0	f
1604	19	80887508	СХД 28 дугаар хороо 4. 1     80887508	3	86000.00	төлбөр танайх авна	9	f	0	fci3ISByQF	2025-08-11 13:12:36.694+00	2025-08-13 14:34:56.061+00	f	f	2025-08-13 14:34:56.061+00		f
1612	52	89908594	10r horoolliin Tehnik tehnology-n deed surguuli deer	3	6000.00	ajilin tsagaar	14	f	0	jnZafpOzkh	2025-08-11 18:01:33.404+00	2025-08-12 11:27:24.809+00	f	f	2025-08-12 11:27:24.808+00	0	f
1623	19	85257470	Өмнөговь аймаг гурвантэм сум Шивээ хүрэн боомт хуучин даргоноос 3ба 5 дахь өдөр 3 цагт явдагг	5	86000.00	3дахь буюу маргааш  3 цагаас явдаг .төлбөр танайх авна	69	f	0	EFHwoRzMwI	2025-08-12 03:05:12.112+00	2025-08-25 06:51:05.059+00	f	f	2025-08-15 06:22:59.845+00	margash unaan yvna	f
1617	62	99176766	Barilgachdiin talbain zuun tald MAXTOWER hoino Hiimori hothon 4/7 bair 2 orts 8davhar 44toot. Orts:B5379	3	1.00	8/12-ны захиалга	9	f	0	kceJpbgaRD	2025-08-12 02:27:37.494+00	2025-08-12 07:40:06.88+00	f	f	2025-08-12 07:40:06.88+00	0	f
1602	59	86564442	баруун салаа 3 дугаар буудал 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	knCWZMbGRN	2025-08-11 11:03:18.044+00	2025-08-13 14:43:13.186+00	f	f	2025-08-13 14:43:13.185+00	dugarin ashiglant bahgu bn	f
1613	52	89303388	Dulguun nuur Hoimori office iin hoino 294r bair 3-15 toot	3	6000.00	z	9	f	0	iSRRuGKcQ6	2025-08-11 18:02:17.963+00	2025-08-12 14:21:42.541+00	f	f	2025-08-12 14:21:42.541+00	0	f
1631	10	88053358	misheel ekspo baruun tald 84r bair 2 orts 2 davhar 61toot	1	0.00	a	\N	f	0	P6YMD7BCWb	2025-08-12 15:17:08.54+00	2025-08-12 15:17:51.814+00	t	f	\N	0	t
1619	6	88025613	choir bayan zurhiin avto onoshilgoonii urd m martaas unaand ugnu	3	0.00	choir	9	f	0	e0bU59xSKn	2025-08-12 02:59:21.306+00	2025-08-12 07:53:34.926+00	t	t	2025-08-12 07:53:34.926+00	0	f
1614	52	90198299	MUBIS- Bagshiun surguuli ( Sportiin tuw ordonii nomtoi hushuutei)	3	6000.00	Khongorzuld	9	f	0	5ujX8bOG25	2025-08-11 18:03:10.797+00	2025-08-12 05:16:20.274+00	f	f	2025-08-12 05:16:20.274+00	0	f
1603	59	88075765	СХД ногоон чулуут 6 , 59	3	0.00	ирэхээсээ өмнө залгах	14	f	0	5egh73Y2g0	2025-08-11 11:03:53.87+00	2025-08-12 13:38:51.665+00	f	f	2025-08-12 13:38:51.665+00	0	f
1633	52	99767980	Union Building deer	3	0.00	ajiliin tsagaar	9	f	0	R0JDc6c0T7	2025-08-12 18:22:53.069+00	2025-08-13 15:33:49.875+00	f	f	2025-08-13 15:33:49.875+00	0	f
1723	58	88780541	БЗД 42 хороо нарт хотхоны дунд сондгой 7 давхар бор канттай 81 байр22 тоот	3	90000.00	294ш minecraft	14	f	0	FN8r32dw7W	2025-08-15 02:16:16.392+00	2025-08-15 09:33:38.434+00	f	f	2025-08-15 09:33:38.434+00	0	f
1611	52	99152458	HUD 2r horoo Badrakh hothon B2 block 17r bair 901 toot	3	6000.00	z	14	f	0	KmUyiBTkAA	2025-08-11 18:00:59.828+00	2025-08-12 05:09:21.216+00	f	f	2025-08-12 05:09:21.216+00	0	f
1600	59	99313816	32 тойрог 17 гийн сод монгол 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	kTVILmCBXu	2025-08-11 11:02:17.615+00	2025-08-12 05:16:07.482+00	f	f	2025-08-12 05:16:07.482+00	0	f
1605	59	99661662	СХД 11р хороо хангай хотхон 511 р байр 2 дугаар орц 12 давхар 140 тоот	3	0.00	ирэхээсээ өмнө залгах	9	f	0	E2gwQuTe1N	2025-08-11 14:39:43.105+00	2025-08-12 05:41:41.943+00	f	f	2025-08-12 05:41:41.942+00	0	f
1622	6	80472043	hangai hothonii zuun tald 310r bair	3	0.00	.	9	f	0	bJA9WHaedg	2025-08-12 03:02:21.692+00	2025-08-12 05:55:23.123+00	t	f	2025-08-12 05:55:23.123+00	0	f
1607	52	89802308	Central Tower -t	3	6000.00	Ajiliin tsagaar 18.00 hvrtel	9	f	0	RTd9c7H40b	2025-08-11 17:57:14.655+00	2025-08-12 05:55:49.15+00	f	f	2025-08-12 05:55:49.149+00	0	f
1609	52	98111714	Hud Khauunl tower 5-502 toot	3	0.00	Ajiliin tsagaar	14	f	0	SSXFBAc87i	2025-08-11 17:59:23.254+00	2025-08-12 06:01:34.265+00	f	f	2025-08-12 06:01:34.264+00	0	f
1610	52	80088354	SBD 11r horoo Khangai hothonii hoino 911r bair	3	6000.00	Ochiod zalgah	9	f	0	6IgZOiAEJr	2025-08-11 18:00:07.508+00	2025-08-12 06:06:42.006+00	f	f	2025-08-12 06:06:42.006+00	0	f
1621	6	89008632	HUD 24r horoo tuul view hothon 106b 1602toot code #778899 	3	0.00	han uul duureg	14	f	0	Ec5ZRRkG0l	2025-08-12 03:01:35.691+00	2025-08-12 06:47:30.372+00	t	f	2025-08-12 06:47:30.372+00	0	f
1615	52	90096889	BZD tsagaan huaran hothon 90D bair 64 toot	3	6000.00	b	9	f	0	86ivMGjLrR	2025-08-11 18:03:50.837+00	2025-08-12 07:40:01.26+00	f	f	2025-08-12 07:40:01.26+00	0	f
1599	59	99623741	3р хороо ТБД андууд урд талын 71 р байр 5р орц 9 давхар 177 тоот 	3	0.00	ирэхээсээ өмнө залгах	14	f	0	a5ybH7w6jl	2025-08-11 11:01:38.299+00	2025-08-12 09:24:09.838+00	f	f	2025-08-12 09:24:09.838+00	0	f
1616	19	94022806	25-р эмийн сангийн хажууд 179-р цэцэрлэг дээр авъя	3	86000.00	эртхэн авах .төлбөр танайх авна	14	f	0	ANseTkPx8l	2025-08-12 01:55:04.763+00	2025-08-12 10:03:22.646+00	f	f	2025-08-12 10:03:22.646+00	0	f
1601	59	94250692	дорнод 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	WYTAFuzP4N	2025-08-11 11:02:41.284+00	2025-08-12 10:04:27.912+00	f	f	2025-08-12 10:04:27.912+00	0	f
1627	19	99912364	99912364 SHD 19 bair 232 toot	3	86000.00	төлбөр танайх авна	69	f	0	19CVwPRfKZ	2025-08-12 08:23:35.396+00	2025-08-15 11:47:33.226+00	f	f	2025-08-15 11:47:33.226+00	0	f
1618	6	89148998	SHD 40-r horoo35 gudamj nogoochin 5-8 toot	3	0.00	tolbor hiisen	14	f	0	1s7HrjpqGQ	2025-08-12 02:53:56.582+00	2025-08-12 12:59:46.885+00	t	f	2025-08-12 12:59:46.885+00	0	f
1671	61	99270985	ХУД Яармаг 1-р буудал Арцат-2 хотхон	3	29900.00	тооцоо хийгээгүй	68	f	0	B7mUYZZEkC	2025-08-14 03:49:18.825+00	2025-08-15 09:44:07.307+00	f	f	2025-08-15 09:44:07.307+00	0	f
1632	6	88213512	sbd 32n toirog 921 bair	3	0.00	roma	9	f	0	XhAcgNcrK4	2025-08-12 15:26:17.141+00	2025-08-12 15:31:48.461+00	t	f	2025-08-12 15:31:48.461+00	0	f
1728	61	88150948	halast 84 buudal	3	29900.00	тооцоо хийгээгүй	9	f	0	vjXTh7Vfx8	2025-08-15 02:55:35.006+00	2025-08-15 09:13:58.262+00	f	f	2025-08-15 09:13:58.262+00	0	f
1629	19	88150477	88150477 гэрийн хаяг ХУД 2-р хорр максын 34- р байр 21 тоот	3	86000.00	төлбөр танайх авна	68	f	0	9JHMH0exk1	2025-08-12 13:25:02.154+00	2025-08-15 10:57:44.763+00	f	f	2025-08-15 10:57:44.762+00	0	f
1675	61	94077400	СХД Цэргийн хотхон Гэрэлт-оюу цэцэрлэг	3	29900.00	ажлын цагаар	69	f	0	RUSCR14W7E	2025-08-14 04:04:28.022+00	2025-08-15 13:13:25.295+00	f	f	2025-08-15 13:13:25.295+00	0	f
2377	84	91661093	Шархадны эцэс	2	36000.00	в	66	f	0	2SxkvwjwW0	2025-08-26 03:46:23.516+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2326	77	95189021 	 bayn olgii 	2	20000.00	tolbor batalgaajsan 	66	f	0	EJjMJJRjvO	2025-08-25 14:07:52.813+00	2025-08-26 05:09:50.496+00	f	f	\N	0	f
1753	59	91017151	БЗД 36 хороо crystal town 802 2р байр 1р орц 16 давхар 1602 	3	35000.00	ирэхээсээ өмнө залгах	9	f	0	6zYKwe6Gip	2025-08-15 15:24:01.347+00	2025-08-16 11:11:00.128+00	f	f	2025-08-16 11:11:00.128+00	0	f
1705	61	99147935	Чингэлтэй дүүрэг 17-р хороо 49-ийн 1122 тоот 	3	29900.00	тооцоо хийгээгүй	9	f	0	NZqe3Tqwdu	2025-08-14 09:29:13.477+00	2025-08-16 07:51:34.189+00	f	f	2025-08-16 07:51:34.189+00	avahgu irtsen gesen	f
1624	19	85232595	85232595 Баянзүрх дүүрэг Жанжингийн гудамж-14 276 тоот	3	86000.00	төлбөр танайх авна. өнөөдөр  заавал  хүргэх	9	f	0	U7Unh603MC	2025-08-12 03:08:03.008+00	2025-08-14 08:16:25.769+00	f	f	2025-08-14 08:16:25.769+00	0	f
1642	21	88069064	zaisan Enhjin hothon 102 bair 2 orts 4dav 54 toot	3	0.00	Mandy-d. orts kod: 2022	9	f	0	6n2ig7PhyZ	2025-08-13 04:13:25.639+00	2025-08-14 14:15:22.909+00	t	f	2025-08-14 14:15:22.909+00	0	f
1630	19	88555085	Баянзүрх дүүрэг 13 р хороо 101 р байр 20 тоот	5	86000.00	төлбөр танайх авна	9	f	0	O7FUTxlUGw	2025-08-12 14:18:57.098+00	2025-08-13 02:48:04.679+00	f	f	\N	0	f
1625	19	80859633	Yarmag 3dugaar buudal	3	86000.00	төлбөр танайх авна  өнөөдөр хүргэх	9	f	0	taHKlF4sSB	2025-08-12 03:58:54.247+00	2025-08-13 06:06:08.67+00	f	f	2025-08-13 06:06:08.67+00	0	f
1635	52	99039269	HUD 23r horoo Yaarmag Greenart hothon 776r bair	3	6000.00	Zalgah	9	f	0	m4J079Ty82	2025-08-12 18:24:54.525+00	2025-08-13 07:15:44.75+00	f	f	2025-08-13 07:15:44.75+00	0	f
1606	19	89185449	sxd 29 xoroo dargonii ariin 22 a 3orts 81 toot 89185449	3	86000.00	төлбөр танайх авна	9	f	0	2cGTqXSmdK	2025-08-11 15:33:11.543+00	2025-08-13 08:21:30.876+00	f	f	2025-08-13 08:21:30.876+00	8 udai zalagsan utsa awagu	f
1640	62	Утас:99351127	Эрдэнэт	3	1.00	Эрдэнэтийн унаанд хийх	9	f	0	uEUN7ZAW0V	2025-08-13 02:05:22.812+00	2025-08-13 08:32:45.526+00	f	f	2025-08-13 08:32:45.526+00	0	f
1628	19	86949290	Дорноговь аймаг Замын Үүд сум Жинчин1-25 86949290	5	86000.00	төлбөр танайх авна	9	f	0	MyCuepRv2U	2025-08-12 11:03:56.458+00	2025-08-13 08:45:11.112+00	f	f	\N	0	f
1636	52	99009116	Moskwa horoolol Nomintoi bair deer	3	6000.00	b	9	f	0	w9R3aVGEZE	2025-08-12 18:25:20.525+00	2025-08-13 08:45:37.056+00	f	f	2025-08-13 08:45:37.056+00	0	f
1634	52	88198161	Gemteliin ard shine horoolol 85g bair 2-216 toot	3	0.00	b	9	f	0	gGRByPoR3f	2025-08-12 18:24:03.112+00	2025-08-13 09:21:09.713+00	f	f	2025-08-13 09:21:09.713+00	0	f
1626	19	99919183	BGD 13-r horoo huuchinaar huh hulagnii oron togloomiin gazart.odoo shireenii tennisnii klubt.	3	86000.00	төлбөр танайх авна	9	f	0	zceResnnwq	2025-08-12 07:13:26.205+00	2025-08-13 09:35:54.271+00	f	f	2025-08-13 09:35:54.271+00	0	f
1639	52	88070372	CHD 2 r horoo TX 30 bair gants ortstoi 5n toot	3	6000.00	olku bol zalgah	9	f	0	dyYomgxCvG	2025-08-12 18:28:17.273+00	2025-08-13 10:26:23.348+00	f	f	2025-08-13 10:26:23.347+00	0	f
1608	52	89115029	Central Tower 14 dawhart ajiliin tsagaar	3	6000.00	Ajiliin bus tsagaar bol bichsen hayg dr awna	9	f	0	HW4s577Yyt	2025-08-11 17:58:48.037+00	2025-08-13 12:03:30.059+00	f	f	2025-08-13 12:03:30.059+00	0	f
1637	52	99204740	BZD 13r horoo Dvvrgiun buudliin baruun taliin Nomintoi bairnii hajuud 90a bair 12-41 toot	3	6000.00	n	9	f	0	ft2iuxcwsm	2025-08-12 18:26:35.589+00	2025-08-13 12:06:25.571+00	f	f	2025-08-13 12:06:25.571+00	0	f
1641	62	80545546	100ail zugiinii uur hudaldaanii tuv 80545546	3	1.00	8/13-ны захиалга	9	f	0	mo5SrMbxjj	2025-08-13 03:40:32.348+00	2025-08-13 12:37:51.237+00	f	f	2025-08-13 12:37:51.237+00	0	f
1644	21	88086955	udriin tsagaar ih delguuriin ariin Mateix salond.	3	0.00	Munhtsetseg-t. 10-19 tsagiin hooron bna	9	f	0	FPw0zE6ioK	2025-08-13 04:15:25.866+00	2025-08-14 05:48:34.476+00	t	f	2025-08-14 05:48:34.476+00	0	f
1676	61	 91914168	ХУ 23-хороо нүхтийн замд арцатын ам Арвай вилла 735-1-19 4 давхар	3	29900.00	тооцоо хийгээгүй	68	f	0	BkEvDT2Omj	2025-08-14 04:16:29.196+00	2025-08-15 06:21:28.46+00	f	f	2025-08-15 06:21:28.46+00	0	f
1714	59	93245555	emerald residence 520 11 давхар 1102 тоот 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	LaNSmnFa6p	2025-08-14 10:37:38.029+00	2025-08-15 06:24:52.979+00	f	f	2025-08-15 06:24:52.979+00	0	f
1712	59	95565244	БЗД 1 хороо их тойруу 30 р байр 	3	0.00	ирэхээсээ өмнө залгах	9	f	0	3FBP8T1d2E	2025-08-14 10:31:28.885+00	2025-08-15 07:43:35.543+00	f	f	2025-08-15 07:43:35.542+00	0	f
1643	21	90243001	7buudlaas dambaruu ergeed Sodmongol kolonkiin zuun tald zam daguu	3	0.00	oogii-d.	9	f	0	9KtJqVpVEq	2025-08-13 04:14:22.047+00	2025-08-15 08:41:08.158+00	t	f	2025-08-15 08:41:08.157+00	0	f
1706	61	99158928	Яармагийн дэнжийн 3-р гудамж 103 тоот 	3	29900.00	тооцоо хийгээгүй	68	f	0	pV4dJMEYWj	2025-08-14 09:31:03.598+00	2025-08-15 10:02:54.879+00	f	f	2025-08-15 10:02:54.879+00	0	f
1796	59	99757712	эрдэнэт	3	0.00	ирэхээсээ өмнө залгах	3	f	0	b2Hfl5yVC3	2025-08-16 13:26:19.491+00	2025-08-17 11:01:33.203+00	f	f	2025-08-17 11:01:33.203+00	0	f
1764	52	99982793	100n ail khangai hothon Sport zaalnii hajuud 522r bair 12 dawhart	3	6000.00	zalgah	9	f	0	wHOkte1vV4	2025-08-15 17:46:26.986+00	2025-08-16 08:39:32.951+00	f	f	2025-08-16 08:39:32.951+00	0	f
1778	60	80335533	80335533  олимп хотхон 428-62 тоот	3	99000.00	avtomat hataagch tulbur hiigdeegui	9	f	0	lofLfm5cCg	2025-08-16 01:19:57.178+00	2025-08-16 11:51:35.564+00	f	f	2025-08-16 11:51:35.564+00	0	f
1784	60	88200405	ulaan huaran komfort hothon 63r bair 67toor	3	99000.00	автомат хатаагч очихоосоо өмнө залгаж асуух төлбөр хийгдээгүй	9	f	0	bh4uqto3aZ	2025-08-16 03:44:22.721+00	2025-08-16 10:29:09.517+00	f	f	2025-08-16 10:29:09.517+00	0	f
1766	52	99178743	Blue sky 3-dawhart	3	6000.00	Ajiliin 1 udur uguh	24	f	0	vuLL28DBCh	2025-08-15 17:50:41.955+00	2025-08-18 06:18:31.624+00	f	f	2025-08-18 06:18:31.624+00	margash avna	f
1755	61	80136292	Баруун 4 зам уруудаад нарны гүүрийн эсрэг талд Ундрам зоог 	3	29900.00	тооцоо хийгээгүй	9	f	0	Tl53U8z149	2025-08-15 15:32:40.915+00	2025-08-16 09:20:36.141+00	f	f	2025-08-16 09:20:36.141+00	0	f
1793	21	89058880	hunnu 2222 hothon 111 bair 9b toot	3	0.00	Oyunbileg-t. 	3	f	0	l439f9fRV1	2025-08-16 13:10:20.478+00	2025-08-17 13:38:35.913+00	t	f	2025-08-17 13:38:35.913+00	0	f
1767	52	95198595	Dulguun nuut soul emnelegiin baruun talf Uptown Vistta 610r bair 8 dawgart	3	0.00	zalgah	9	f	0	n2Abr8e3RS	2025-08-15 17:51:37.466+00	2025-08-16 08:19:10.329+00	f	f	2025-08-16 08:19:10.329+00	0	f
1756	61	95095588	golden buddah 1р орц 10 давхар 12 тоот Хаалтаар дөнгөж ороод гаднаас ордог орц	3	29900.00	тооцоо хийгээгүй	14	f	0	ZjamqxA7SC	2025-08-15 15:35:06.309+00	2025-08-16 09:14:46.906+00	f	f	2025-08-16 09:14:46.906+00	0	f
1743	19	86656456	Өмнөговь аймаг Цогтцэций сум 88984749 86656456 даргонаас. нарантуулаас	5	86000.00	төлбөр танайх авна	3	f	0	WnmR2AmhQ5	2025-08-15 14:58:58.339+00	2025-08-18 08:52:44.341+00	f	f	\N	utsan holbogdoh bolomjguu	f
1779	61	88801316	3р хороолол Өргөө театрийн баруун тал 1р байр 15 тоот	3	29900.00	тооцоо хийгээгүй	14	f	0	MjpSh6oiTa	2025-08-16 02:12:04.38+00	2025-08-16 12:45:09.589+00	f	f	2025-08-16 12:45:09.588+00	0	f
2378	84	99933335	Багануур унаанд тавих	2	0.00	.	66	f	0	P6Abju0gvV	2025-08-26 03:47:08.832+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2327	77	95951730 	7buudal deer avna 	2	25000.00	95151790 	73	f	0	MMoYbKpoYq	2025-08-25 14:08:17.216+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
1789	21	91008800	HUD 19 horoolol Nutgiin buyn hothon 37b bair 401 toot. 	3	0.00	obe-d. kod; tulhuur 3702 tulhuur	3	f	0	R0KL3pnLWW	2025-08-16 13:03:50.172+00	2025-08-17 12:44:10.623+00	t	f	2025-08-17 12:44:10.623+00	0	f
2092	71	99892963	gobisubmer narantuul deeres	3	0.00	onoodor	66	f	0	CGk1BzO5T8	2025-08-23 06:01:02.923+00	2025-08-25 10:09:51.101+00	t	f	2025-08-25 10:09:51.101+00	yriad margaash bolgosn	f
1843	52	99644381	BZD 5 r horoo Ineemsgelel hothon 77a bir 1 orrs 9-53 toot	3	0.00	d	9	f	0	FBR6y94uLg	2025-08-17 18:04:40.284+00	2025-08-18 11:34:48.178+00	f	f	2025-08-18 11:34:48.178+00	0	f
1799	59	99581617	БГД 8 р хороо 4 р хороолол 27/2   54	3	0.00	ирэхээсээ өмнө залгах	9	f	0	IAuaOEdHq1	2025-08-16 13:33:56.714+00	2025-08-17 10:03:29.036+00	f	f	2025-08-17 10:03:29.036+00	0	f
1742	59	86330447	налайх 1 хороо баянзүрх 11 859 хашаа	3	0.00	ирэхээсээ өмнө залгах	14	f	0	GyHOh4TUsA	2025-08-15 14:58:34.334+00	2025-08-21 10:04:37.336+00	f	f	2025-08-21 10:04:37.336+00	utsan holbogdoh bolomjgu	f
1816	61	89897805	нисэх Eagle taun 430р байр 7 давхар 7 тоот	3	29900.00	тооцоо хийгээгүй	3	f	0	DLISIhHRfn	2025-08-17 01:57:09.484+00	2025-08-17 15:26:24.16+00	f	f	2025-08-17 15:26:24.16+00	0	f
1785	19	95957409	Улаанхуаран SKY RESDENS1 224БАЙР 5давхар 17тоот	3	86000.00	төлбөр танайх авна	9	f	0	zMnL32fCYE	2025-08-16 09:11:01.586+00	2025-08-17 04:13:00.588+00	f	f	2025-08-17 04:13:00.588+00	0	f
1654	4	99666578	сүхбаатар дүүрэг 2 хороо дөлгөөн нуур 295 байр 13 давхар 81 тоот	3	1.00	зөрүүлээд 1 буцаалтын бараа авна	3	f	0	GLWcUDjm4N	2025-08-13 16:10:22.848+00	2025-08-18 11:39:08.196+00	f	f	2025-08-18 11:39:08.196+00		f
1845	52	89477788	Tuw nomiin san Altai building 3-302 toot	3	6000.00	z	9	f	0	2XrZZFQWak	2025-08-17 18:06:25.246+00	2025-08-18 05:41:57.922+00	f	f	2025-08-18 05:41:57.922+00	0	f
1808	19	94129725	Өмнөговь аймаг Ханбогд сум даргонаас  өдөр бүр	3	86000.00	төлбөр танайх авна	9	f	0	G9pnPrqtUH	2025-08-16 15:29:37.349+00	2025-08-17 08:11:14.567+00	f	f	2025-08-17 08:11:14.567+00	0	f
1801	59	99942084	5 шарын 10 буудал энхжин худалдааны төвийн замын урд баянголын цагдаагийн 2 дугаар хэлтэсийн хажууд 23р байр	3	0.00	ирэхээсээ өмнө залгах	9	f	0	ZJC492WuK5	2025-08-16 13:54:16.723+00	2025-08-17 09:09:54.837+00	f	f	2025-08-17 09:09:54.837+00	0	f
1805	59	96660499	СБД 1р хороо замын цагдаагийн яаг ард байдаг 59а байр 7 давхар	3	31000.00	ирэхээсээ өмнө залгах	9	f	0	j1HSjAJw0k	2025-08-16 14:56:21.349+00	2025-08-17 11:36:09.345+00	f	f	2025-08-17 11:36:09.345+00	0	f
1978	71	88144002	hentii	3	6000.00	unaa	14	f	0	RHOTAOjgOj	2025-08-22 00:58:14.323+00	2025-08-22 09:24:02.396+00	f	f	2025-08-22 09:24:02.396+00	0	f
1820	6	80844611	daa khuree khaan bank	3	0.00	a	9	f	0	56gdL0dCG0	2025-08-17 03:33:17.189+00	2025-08-17 04:28:29.778+00	t	f	2025-08-17 04:28:29.778+00	0	f
1797	59	99601473	БЗД 16 хороо дандарбаатарын гудамж 28 байр 70 тоот	3	0.00	ирэхээсээ өмнө залгах	9	f	0	nxm2JSgm6O	2025-08-16 13:30:55.975+00	2025-08-17 05:05:51.104+00	f	f	2025-08-17 05:05:51.103+00	0	f
1815	61	86119275	БЗД 32 хороо 104р байр 1р орц 1-107 	3	29900.00	тооцоо хийгээгүй.	9	f	0	Hxqn5oFwca	2025-08-17 01:55:00.674+00	2025-08-17 05:27:04.559+00	f	f	2025-08-17 05:27:04.559+00	0	f
1783	59	95588677	булган	3	0.00	ирэхээсээ өмнө залгах	9	f	0	Vhy5d7vLNu	2025-08-16 03:12:18.976+00	2025-08-17 07:57:56.55+00	f	f	2025-08-17 07:57:56.55+00	0	f
1744	59	90301881	замын үүд	3	0.00	ирэхээсээ өмнө залгах	3	f	0	D8rIOlpgcQ	2025-08-15 14:59:40.79+00	2025-08-19 06:22:06.029+00	f	f	2025-08-19 06:22:06.029+00	0	f
1809	19	94297247	Geriin hayg :25s deeshe orgoolu ogsj bgd gerlen dohiogor  zvvn  ergeed gemtelin dund zamru dongj erged Hawai complexin urd 12A bair 1dawhr 94297247	5	86000.00	төлбөр танайх авна	9	f	0	LwoZbkoGfo	2025-08-17 01:23:38.671+00	2025-08-17 10:11:58.458+00	f	f	\N	0	f
1800	59	89614840	 БГД 15 хороо 23b байр 118 тооот 	3	35000.00	ирэхээсээ өмнө залгах	9	f	0	l582L8GPPa	2025-08-16 13:35:24.875+00	2025-08-17 10:39:33.438+00	f	f	2025-08-17 10:39:33.438+00	0	f
1963	52	89585885	BZD 8r horoo Baganat urgoo hothon 413r bair 10 toot	3	6000.00	m	14	f	0	7cHAYKCuEr	2025-08-21 19:23:11.42+00	2025-08-22 10:31:02.18+00	f	f	2025-08-22 10:31:02.18+00	0	f
1802	59	91778210	замын үүд 	3	0.00	ирэхээсээ өмнө залгах	3	f	0	1xHpeSLEQ3	2025-08-16 14:04:56.615+00	2025-08-17 11:06:49.384+00	f	f	2025-08-17 11:06:49.384+00	0	f
1824	6	80234275	Zaisan Suld khotkhon 100\\3 bair 4 davhar 19 toot	3	0.00	a	3	f	0	Q4jb52BT88	2025-08-17 03:40:11.412+00	2025-08-17 14:06:34.007+00	t	f	2025-08-17 14:06:34.007+00	0	f
1758	61	88844572	Буянт ухаа-1 721-27	3	29900.00	тооцоо хийгээгүй	3	f	0	6LAz05isd3	2025-08-15 15:39:54.145+00	2025-08-17 15:08:27.352+00	f	f	2025-08-17 15:08:27.351+00	0	f
1847	52	88998282	Natur Nogoon tugul hothon 75 r bair 14-69toot	3	6000.00	b	24	f	0	wTyNTxJQwM	2025-08-17 18:08:05.597+00	2025-08-18 13:10:21.272+00	f	f	2025-08-18 13:10:21.272+00	0	f
1876	52	99690236	Darhan unaand	3	0.00	Ugud medegdeh	3	f	0	gldnjgyjv3	2025-08-18 17:55:07.525+00	2025-08-19 06:22:37.17+00	f	f	2025-08-19 06:22:37.17+00	0	f
1835	21	88097814	zaisan Nomun villa 100/6 bair 18 toot	3	0.00	Enhtuul-d. 88097814	9	f	0	4EL3kGVXX3	2025-08-17 12:17:42.691+00	2025-08-18 15:15:35.869+00	t	f	2025-08-18 15:15:35.869+00	0	f
1792	21	99121228	hud tower chanh urd 32 bair 2orts 4-165 toot	3	0.00	ujin gua-d. ireed zalgahaar nbgaraad awna.	9	f	0	Ikhmqri6bd	2025-08-16 13:09:25.935+00	2025-08-19 08:28:58.366+00	t	f	2025-08-19 08:28:58.366+00	utsaa avagui	f
1812	61	88614069	Цамбагарав замын урд тал Номин дэлгүүрийн баруун талийн 45а байр 2р орц 14 давхар 158 тоот	3	29900.00	тооцоо хийгээгүй	3	f	0	a3FPrss3Rl	2025-08-17 01:45:13.942+00	2025-08-18 07:47:15.589+00	f	f	2025-08-18 07:47:15.588+00	0	f
1790	21	88909513	BZD 42 horoo Aman huur hothon 33B bair 82 toot.	3	0.00	Handmaa-d. kod; 7893#	9	f	0	0VdkppS183	2025-08-16 13:05:18.711+00	2025-08-18 10:46:26.302+00	t	f	2025-08-18 10:46:26.302+00	0	f
1749	59	89846070	 21 хорооллын их засаг сургуулийн урд талд 80k outlet	3	0.00	ирэхээсээ өмнө залгах	3	f	0	DH8pDMEvYf	2025-08-15 15:10:41.29+00	2025-08-18 09:34:44.83+00	f	f	2025-08-18 09:34:44.83+00	margash erthen avna	f
1838	59	99740545	тэнгис 2	3	0.00	ирэхээсээ өмнө залгах	9	f	0	CkleI72tV7	2025-08-17 15:07:06.713+00	2025-08-19 09:42:41.485+00	f	f	2025-08-19 09:42:41.484+00		f
1794	21	99665583	SBD 9 horoo 274 bair 7dav 701 toot. Hoimor office-n baruun tald	3	0.00	Naraa Tseenee-d. 	3	f	0	PiEGYWJC37	2025-08-16 13:11:49.369+00	2025-08-18 11:30:31.518+00	t	f	2025-08-18 11:30:31.518+00	0	f
1736	19	95588055	БЗД 17р хороо да хүрээ техник зах автобусны буудал 95588055	3	86000.00	төлбөр танайх авна	9	f	0	0KiUMMY65p	2025-08-15 11:43:40.539+00	2025-08-19 01:34:59.595+00	f	f	2025-08-19 01:34:59.594+00	utsa avaguu	f
1955	59	88047866	багануур 	3	0.00	0	14	f	0	1SIDTwLtFh	2025-08-21 17:12:14.365+00	2025-08-22 09:53:29.496+00	f	f	2025-08-22 09:53:29.496+00	0	f
1787	19	89889143	Чингэлтэй дүүрэг 10-р хороо, цагаан байр 89889143	5	86000.00	төлбөр танайх авна	50	f	0	u1H7T3NX6j	2025-08-16 11:36:30.512+00	2025-08-22 10:29:37.747+00	f	f	\N	gertee bhgvi margaash yarij bgad ogoh	f
1821	6	88213512	SBD  32-n toirog 11-r khoroo tsagdaagiin gudamj 921 bair 12 davhar 103 toot	1	0.00	a	\N	f	0	5gcARTgu3o	2025-08-17 03:34:43.774+00	2025-08-17 03:39:05.989+00	t	f	\N	0	t
1830	19	80515047	Hentii omnodelgeriin unaand  narantuul zah deeres ywna	5	86000.00	төлбөр танайх авна	14	f	0	mWnDLsK2Q1	2025-08-17 06:12:21.203+00	2025-08-22 09:50:06.122+00	f	f	\N	utsan holbogdoh bolomjguu	f
1819	61	99038896	Соёлын төв өргөө	3	29900.00	Өнөөдөр 11-14 цагийн хооронд хаяг дээрээ байна. Орой хотоос гараад явчихна.	9	f	0	Vtww1ECWbP	2025-08-17 02:06:31.245+00	2025-08-17 04:15:15.221+00	f	f	2025-08-17 04:15:15.221+00	0	f
1822	6	96141418	BZD tsagdaagiin akadem Mongol shuudan 32 salbar 	3	0.00	a	9	f	0	s2zSSaCPni	2025-08-17 03:35:56.819+00	2025-08-17 06:55:12.799+00	t	f	2025-08-17 06:55:12.798+00	0	f
1825	6	99122704  86818178	yarmag hunnu mall baruun urd Shunshig villa 2 khotkhon 6107 toot	3	0.00	a	3	f	0	kK7hI3nC4q	2025-08-17 03:46:04.011+00	2025-08-17 14:29:16.947+00	t	f	2025-08-17 14:29:16.947+00	0	f
1839	59	95208638	өмнөговь гурван тус 	3	0.00	ирэхээсээ өмнө залгах	3	f	0	KWdpOWXvuM	2025-08-17 15:07:33.824+00	2025-08-18 09:02:57.817+00	f	f	2025-08-18 09:02:57.817+00	0	f
1846	52	88142080	Zaisan orgil hud/tuwiin esreg taliin Orgil hothon 62 -10 tott	3	6000.00	b	9	f	0	zsFqKd5NwI	2025-08-17 18:07:27.793+00	2025-08-19 06:36:07.315+00	f	f	2025-08-19 06:36:07.315+00	0	f
1829	19	98881683	БЗД 27-р хороо дарь эх хуучин эцэс утас 99972349,98881683	3	86000.00	төлбөр танайх авна	9	f	0	iEvuRv2cP3	2025-08-17 05:33:27.927+00	2025-08-19 10:30:43.145+00	f	f	2025-08-19 10:30:43.145+00	0	f
1823	6	95112170	Bayankhoshuu toirgoos zuun salaa ruu 1 buudal yvaad uuliin 5 gesen gudmaar deesh ugsuud 11 toot	3	0.00	a	3	f	0	KG7vslaJBo	2025-08-17 03:37:18.042+00	2025-08-18 10:46:40.671+00	t	f	2025-08-18 10:46:40.671+00	0	f
1832	60	89126876	1 horoolol 25 bair 5 toot	5	99000.00	avtomat hataagch tulhur hiigdeegui	\N	f	0	jj30yNpLlQ	2025-08-17 11:50:26.241+00	2025-08-18 03:46:19.619+00	f	f	\N	0	f
1837	59	90662039	sunday арын 41 байр 6 давхар 	3	0.00	ирэхээсээ өмнө залгах	24	f	0	FnUVdb2ONX	2025-08-17 15:06:45.696+00	2025-08-18 11:48:12.347+00	f	f	2025-08-18 11:48:12.347+00	0	f
1842	52	99909230	BZD 25r horoo 13 horoololl Narnii zam daguu baidag Doctor avto suljeenii baruun taliin Lux House iin hoino bdg 156r bair 15 tot	3	6000.00	s	24	f	0	8fhvMvVGjo	2025-08-17 18:03:36.691+00	2025-08-18 12:45:57.183+00	f	f	2025-08-18 12:45:57.183+00	0	f
1834	21	99096769	HUD 15 horoo Buti town 109 bair CEO office 201 toot	3	0.00	oogiinoo-d. stadion mahatma gandi gudamj buti town 109	9	f	0	6uZFg5notI	2025-08-17 12:16:43.228+00	2025-08-18 14:10:56.056+00	t	f	2025-08-18 14:10:56.056+00	0	f
1841	52	89059500	HUD 23r horoo artsadiin am Mandala garden 1484 r bair 55 toot	3	6000.00	Ajiliin tsagaar bol Yaarmag Titan Center 1 dawhart TDB bank	3	f	0	chUmRh4y6J	2025-08-17 18:02:26.965+00	2025-08-18 14:36:01.91+00	f	f	2025-08-18 14:36:01.91+00	0	f
1831	60	80707420	БЗД25 хороо 13 хороолол гангарын 170 байр 2 орц10 дав   106 тоот орцны код 7359. 80707420	3	99000.00	avtomat hataagch tulbur hiigdeegui	9	f	0	4kRyICZsXg	2025-08-17 09:50:37.321+00	2025-08-19 11:43:55.879+00	f	f	2025-08-19 11:43:55.879+00	0	f
1828	19	95418617	bayn burd deer awna oroi bol10 хороолол 102 байр 4 давхар 49-р хаалга	3	86000.00	төлбөр танайх авна .эртхэн хүргэх	3	f	0	Y9b6xXb2I3	2025-08-17 04:30:59.95+00	2025-08-19 11:47:32.338+00	f	f	2025-08-19 11:47:32.338+00		f
1840	61	99067952	БЗД 26р хороо Цэцэрлэгт хүрээлэнгийн ард парквью хотхон 753р байр 305 тоот	3	15000.00	тооцоо хийгээгүй	14	f	0	NaOwrgF98m	2025-08-17 17:53:47.204+00	2025-08-21 05:31:18.343+00	f	f	2025-08-20 10:47:38.445+00	0	f
1818	61	96101068	Багадар хороолол 1а байр  голын орц 5 давхар 28 тоот 	5	29900.00	тооцоо хийгээгүй	24	f	0	166k4FMTbs	2025-08-17 02:01:33.777+00	2025-08-18 03:56:47.44+00	f	f	\N	hotod bhq bgaa irhere delgurlu n bichne	f
1827	19	99354702	Эрдэнэтийн унаанд	5	86000.00	төлбөр танайх авна	3	f	0	juJOZg37uq	2025-08-17 04:25:11.405+00	2025-08-18 04:05:53.069+00	f	f	\N	0	f
1751	59	88079691	БГД 31 байр 35 тоо хөгжил хотхон	3	0.00	ирэхээсээ өмнө залгах	3	f	0	IR5BHRw78h	2025-08-15 15:19:42.78+00	2025-08-18 07:11:36.302+00	f	f	2025-08-18 07:11:36.302+00	utsan holbogdoh bolomjguu	f
1833	60	88609095	өмнөговь ханбогд унаанд тавьж өгөх	3	990000.00	Өмнөговь ханбогдруу 88603500 гэсэн дугаар унаа явна жсвэл драгон ноос явуулсан ч болно төлбөр хийгдээгүй	3	f	0	P6XthROrrL	2025-08-17 12:06:54.825+00	2025-08-18 08:53:12.704+00	f	f	2025-08-18 08:53:12.704+00	0	f
1836	21	88054554	Umnu gobi aimag Tsogttsetsii Sum ruu unaadn ugnu.	3	0.00	Buyantsetseg-t. unaand uguud joloochiin dugaariig zaawal heleh, dragonos 12,16, 20 tsaguudad avtobus yawna	3	f	0	sBdgfFnkDH	2025-08-17 13:23:40.995+00	2025-08-18 08:55:12.205+00	t	t	2025-08-18 08:55:12.205+00	0	f
1844	52	90490307	HUD 23 r horoo Yarmag Artsad Luxury 2 hothon 1442r bair 13-60 toot	3	6000.00	b	9	f	0	qx32FS1yNz	2025-08-17 18:05:49.111+00	2025-08-18 15:59:37.54+00	f	f	2025-08-18 15:59:37.54+00	0	f
2250	52	80682181	Natur iin UB tower Plus urd taldaa bdg - 9-905 toot	5	6000.00	Solih baraa	\N	f	0	OaRqxs2xjb	2025-08-24 18:42:06.72+00	2025-08-26 04:09:34.258+00	f	f	\N	0	f
2241	52	80063632	Niseh sport tsogtsolboriin hajud Aero town 302 r bair 21 toot	2	6000.00	n	78	f	0	nlYAZj2XRM	2025-08-24 18:34:51.305+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2242	52	99968110	Misheel expogiin zvvn tald Park view hothon 112/2 bair 12-72 toot	2	6000.00	n	78	f	0	kLcXunnygr	2025-08-24 18:35:53.363+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2245	52	88996655	HUD 23r horoo Mandala garden 1480r bair  134 toot	2	6000.00	oroi huduu yawah uchraas yaaraltai awna	78	f	0	KHXlpzQOJJ	2025-08-24 18:38:08.125+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2246	52	99052723	HUD Tselmeg hothonii hoino Goyol delgvvrin baruun tald 89a bair 1 orts 7 toot	2	6000.00	b	78	f	0	fPtP1O9t2o	2025-08-24 18:38:59.946+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2329	59	94586454	tov aimag	2	0.00	0	78	f	0	trrWDoCfrY	2025-08-25 15:00:15.775+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2243	52	88575461	SHD orgil hudaldaanii tuw iin 70a bair 3-8 toot	2	6000.00	zalgah	9	f	0	viaF3Xh9HR	2025-08-24 18:36:39.24+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
2244	52	98904989	Zawhan aimag unaand uguh	2	0.00	Uguud zalgaj medegdeh	9	f	0	y64S9A7fF6	2025-08-24 18:37:07.413+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
2247	52	95166732	SHD moskwa horoolol 133/6 bair 1209 toot	2	6000.00	n	9	f	0	DuQyKS0kwp	2025-08-24 18:39:48.886+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
1854	6	88610629	bzd duureg  negdsen emlege hajuud taliin nogoon bair	3	0.00	g	9	f	0	7EA2YXX6Li	2025-08-18 02:53:29.521+00	2025-08-18 11:58:43.912+00	t	f	2025-08-18 11:58:43.912+00	0	f
2000	76	88084260	test	3	44000.00	test	3	f	0	x4YiazMAsH	2025-08-22 07:12:44.843+00	2025-08-22 07:15:19.074+00	f	f	\N	0	f
1868	59	80467145	bzd 14 horoo ogoomor hothon 74a bair	3	0.00	ирэхээсээ өмнө залгах	9	f	0	M2VWYI5FzR	2025-08-18 12:58:06.746+00	2025-08-20 06:51:50.154+00	f	f	2025-08-19 12:38:15.7+00	0	f
1804	59	99010588	натурын зам дагуу уруудаад зам дагуу голомт банктай 6 давхар байр 6 давхар 12 тоот	3	0.00	ирэхээсээ өмнө залгах	24	f	0	FarnDgv4xp	2025-08-16 14:14:09.589+00	2025-08-18 12:45:49.286+00	f	f	2025-08-18 12:45:49.286+00	0	f
1979	71	80891906	Dornod	3	6000.00	unaa	14	f	0	Xpj3e1VblJ	2025-08-22 00:59:03.581+00	2025-08-22 09:24:10.744+00	f	f	2025-08-22 09:24:10.744+00	0	f
1849	52	99398763	Hutul ( anduudaaz unaand uguh)	3	6000.00	Ugchuud zalgaj medegdeh	3	f	0	wvWCtPn0yA	2025-08-17 18:09:06.435+00	2025-08-18 07:10:39.183+00	f	f	2025-08-18 07:10:39.182+00	0	f
1852	19	99649206	3.4 хороолол	3	86000.00	төлбөр танайх авна	3	f	0	xZkGrBbYUC	2025-08-18 02:31:14.828+00	2025-08-18 07:11:09.507+00	f	f	2025-08-18 07:11:09.507+00	0	f
1692	59	89395272	СХД 29 р хороо 131-1-3 тоот 	3	0.00	ирэхээсээ өмнө залгах	3	f	0	vPABYfxOrA	2025-08-14 08:45:26.591+00	2025-08-18 08:52:33.006+00	f	f	2025-08-18 08:52:33.005+00	utsan holbogdoh bolomjguu	f
2280	71	88129403	darhan	3	0.00	.	50	f	0	jELjPcxTl2	2025-08-25 04:13:00.4+00	2025-08-25 07:15:03.226+00	f	f	2025-08-25 07:15:03.226+00	0	f
1866	60	95959572	Bella vista 500 bair 1602	5	85000.00	Эвхжгддэг модон хатаагч төлбөр хийгдээгүй	3	f	0	Cvm3NgK348	2025-08-18 12:12:04.455+00	2025-08-20 07:45:15.738+00	f	f	\N	utsan saltsan bn	f
1826	6	89941800	Songino khairkhan duureg 19-r khoroo 58-51 toot	3	0.00	a	3	f	0	57x3QtJrX1	2025-08-17 03:46:43.15+00	2025-08-18 09:49:44.589+00	t	f	2025-08-18 09:49:44.589+00	0	f
2275	71	95119015	uvurhangai arvaiheer	3	0.00	.	50	f	0	LzomuIu5Hc	2025-08-25 04:09:30.439+00	2025-08-25 08:41:05.655+00	f	f	2025-08-25 08:41:05.655+00	0	f
1855	6	89192020 99044112	naran tuul deer awah jolooch	3	0.00	onoodor	9	f	0	nMhU03oGt4	2025-08-18 02:54:53.169+00	2025-08-18 10:24:57.546+00	t	f	2025-08-18 10:24:57.545+00	0	f
1848	52	88045876	Baruun salaa 4r buudal der	3	6000.00	Ochod zalgh	3	f	0	7nQKPDDVJE	2025-08-17 18:08:32.113+00	2025-08-18 10:48:33.695+00	f	f	2025-08-18 10:48:33.695+00	0	f
1850	52	80089303	BZD 7 r horoo 24r bair 1 orts 13 toot	5	0.00	b	9	f	0	sJ5H37Ircv	2025-08-17 18:10:39.402+00	2025-08-18 13:21:47.22+00	f	f	\N	0	f
1851	60	88089737	King tower 118-205	3	85000.00	Эвхэгддэг модон хатаагч төлбөр хийгдээгүй	9	f	0	qRVAIrZfDD	2025-08-18 01:53:24.224+00	2025-08-18 14:33:00.378+00	f	f	2025-08-18 14:33:00.378+00	0	f
2330	59	95488706	bzd 14horoo enhtaivnii gudamj buynt od hothon 89/2-80 toot 	2	0.00	0	66	f	0	TCRZOAtbA8	2025-08-25 15:06:51.383+00	2025-08-26 04:40:43.104+00	f	f	\N	0	f
2249	52	90828236	Soeolj mall iin 6-603 t	5	0.00	B	\N	f	0	XYY1ifLipK	2025-08-24 18:41:24.429+00	2025-08-26 04:09:18.879+00	f	f	\N	0	f
2284	84	94247088	han uul emart	2	21000.00	.	78	f	0	Ba4Ko9RJ5P	2025-08-25 05:36:33.783+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2141	59	95733921	Dornogovi aimg sainshand	3	0.00	0	3	f	0	Vwu7NEmzzX	2025-08-23 14:41:50.181+00	2025-08-24 06:05:52.729+00	f	f	2025-08-24 06:05:52.729+00	0	f
1864	21	99097419	BZD 18 horoo 84r surguuliin hajuud 12r bair 1orts 8dav 32 toot	3	0.00	Suvdaa-d. kod : 32B	14	f	0	aFbdfj0zkv	2025-08-18 11:14:37.097+00	2025-08-20 10:13:51.986+00	t	f	2025-08-20 10:13:51.986+00	0	f
1856	19	86880545	Сансарын 805 цэргийн анги	3	86000.00	төлбөр танайх авна	14	f	0	CfWbAdPlX6	2025-08-18 03:46:02.296+00	2025-08-20 10:39:17.568+00	f	f	2025-08-20 10:39:17.568+00	0	f
2093	71	95750455	horoolol bichil	3	0.00	unuudur	50	f	0	wwFQ1wFr7u	2025-08-23 06:01:55.728+00	2025-08-23 14:58:13.848+00	t	f	2025-08-23 14:58:13.848+00	0	f
1857	19	99344313	Selenge aimag orkhontuul sum 99344313 вагон явдаг	5	86000.00	төлбөр танайх авна	3	f	0	xo85rCOmnI	2025-08-18 03:59:12.287+00	2025-08-19 06:22:22.616+00	f	f	\N		f
1869	59	99726952	эрин хороолол 53/8 орц 5 давхар 74 тоот	3	0.00	ирэхээсээ өмнө залгах	3	f	0	ILCMvOONhH	2025-08-18 13:00:21.45+00	2025-08-19 07:00:53.018+00	f	f	2025-08-19 07:00:53.018+00	0	f
1867	60	88453610	Увс аймаг руу унаанд тавьж өгөх	5	85000.00	Автомат хатаагч төлбөр хийгдээгүй	3	f	0	xTnI7SxfDA	2025-08-18 12:12:53.798+00	2025-08-19 07:43:38.128+00	f	f	\N	0	f
1858	60	99441223	Khan uul duureg 120 myangat 42-1-15 toot	3	85000.00	автомат хатаагч төлбөр хийгдээгүй	9	f	0	j3g3SLAQXL	2025-08-18 04:01:24.641+00	2025-08-19 07:56:55.889+00	f	f	2025-08-19 07:56:55.889+00	0	f
1870	60	88592255	Авья.  Сонгино хайрхан дүүрэг 20 р хороо титэм хотхон бадди баавгай цэцэрлэг дээр авна.  Яг нефтийн буудлын замын урд талын таван давхарын голд нь байдаг цэцэрлэг дээр авна цаг 8.00-17 .00 цагын хооронд бнө	3	85000.00	8-17 цагийн хооронд авна . төлбөр хийгдээгүй	3	f	0	uPbzKcxKT8	2025-08-18 13:18:31.51+00	2025-08-19 08:32:38.007+00	f	f	2025-08-19 08:32:38.007+00	0	f
1946	10	888888	ttt	5	111.00	111	3	f	0	Fz79oD1iKr	2025-08-21 03:03:59.705+00	2025-08-21 04:25:12.914+00	f	f	\N	0	f
1865	21	88300086	Sansariin hoino Petrovis kolonkiin ard Hybrid battery service deer	3	0.00	D.Nyamtsetseg-t. 	9	f	0	GkaRtnQ0KI	2025-08-18 11:16:10.56+00	2025-08-19 13:27:30.999+00	t	f	2025-08-19 13:27:30.999+00	0	f
1860	19	89611511	Baynzureh 22 horoo 10budamj 134	5	86000.00	төлбөр танайх авна	14	f	0	IzioMI4rk6	2025-08-18 08:00:41.351+00	2025-08-21 10:09:34.6+00	f	f	\N	0	f
2183	71	91113573	Hentii	3	0.00	.	9	f	0	t7eZPGRrgA	2025-08-24 04:21:45.059+00	2025-08-24 07:01:32.974+00	f	f	2025-08-24 07:01:32.974+00	0	f
2176	71	88676999	Umnu govi Dalanzadgad	3	0.00	.	3	f	0	kcbI6Fd4iT	2025-08-24 04:18:52.81+00	2025-08-24 07:32:17.623+00	f	f	2025-08-24 07:32:17.622+00	0	f
2185	71	88663598	Umnugovi	3	0.00	.	3	f	0	p52bPrukDq	2025-08-24 04:22:39.018+00	2025-08-24 07:34:33.918+00	f	f	2025-08-24 07:34:33.918+00	0	f
2149	59	90360455	дархан 	3	0.00	0	3	f	0	sUIOYzf1El	2025-08-23 15:49:19.438+00	2025-08-24 08:23:43.652+00	f	f	2025-08-24 08:23:43.652+00	0	f
2187	6	86052011	zawhan urgamal sum	3	0.00	onoodor	9	f	0	WZbJWLLDhE	2025-08-24 04:45:44.966+00	2025-08-24 08:51:53.029+00	t	f	2025-08-24 08:51:53.029+00	0	f
2299	77	86939648 	ulaanhuaran deer ireed zalgah	2	20000.00	99468900 	66	f	0	liv4rjxwGO	2025-08-25 13:34:25.406+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2300	77	99961302 	 jinjin club uruudad dunjin garavlu yvdag zamaar 2iin buudal deer avna	2	25000.00	88718549 	66	f	0	NB0FfBz6pI	2025-08-25 13:34:52.466+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2322	77	88066002 	 tsaiz 16 mognol hothon 	2	22000.00	66c bair 2orts 4davhart 126toot 	66	f	0	vCo521VF1E	2025-08-25 14:06:02.423+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2331	59	90361330	olympic residents Ablock 13davhar 1302toot code:#8569#	2	0.00	0	66	f	0	zsJjEA8rQc	2025-08-25 15:59:36.14+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
1899	59	80811429	тахилт задгай 	3	0.00	ирэхээсээ өмнө залгах	69	f	0	2Qve8tcGMG	2025-08-19 13:53:53.508+00	2025-08-20 09:19:18.693+00	f	f	2025-08-20 09:19:18.693+00	0	f
1894	21	99004205	Darhanii unaand ugnu. 	3	0.00	Saraa Saranchimeg-t. unaand uguud joloochiin dugaariig zaawal yavuulah.	69	f	0	lse2m1APmi	2025-08-19 11:22:32.664+00	2025-08-20 07:58:03.271+00	t	t	2025-08-20 07:58:03.271+00	0	f
1891	21	99255085	Bumbugur hudaldaani tuwiin zamiin urd Monfa office 1 dav, eswel hajuugiin Hishig office-d. ali 1 deer n bna	3	0.00	Nemo HB-d. udur ajiliin tsagaar awna, ali 1 office deer n bna	69	f	0	PUr5ka8Zr4	2025-08-19 11:18:33.589+00	2025-08-20 12:35:05.964+00	t	f	2025-08-20 12:35:05.964+00	0	f
1892	21	99941777	shangrilla office deer, 9;00-17;00 hoorond awna. 	3	0.00	Sunshine Sun-d. 	14	f	0	ZC2sCY1alt	2025-08-19 11:20:01.52+00	2025-08-20 11:15:01.35+00	t	f	2025-08-20 11:15:01.35+00	0	f
1880	52	91092729	HUD 19 r horoo Green houseaar ergeed Shine muruudul hothon 24/5 bair 32 toot	3	0.00	Uunga	9	f	0	WdHVoiqg48	2025-08-18 17:59:22.606+00	2025-08-19 12:29:39.046+00	f	f	2025-08-19 12:29:39.046+00	0	f
1807	19	99141783	Tengis kino theatr 16 цаг хүртэл  байна.Гэрийн хаяг:Чингэлтэй5r horoo 3r bair 1r orts	3	86000.00	төлбөр танайх авна	9	f	0	lvJl8sSRgo	2025-08-16 15:16:53.876+00	2025-08-19 14:39:19.823+00	f	f	2025-08-19 14:39:19.823+00	unuudur bhq	f
1882	6	86999942	БЗД 4 хороо 38а байр 3 орц 59 тоот	3	0.00	Заавал өнөөдөртөө багтаж хүргэх	9	f	0	FqMXELjcmb	2025-08-19 00:45:52.138+00	2025-08-20 02:54:58.827+00	f	f	2025-08-20 02:54:58.827+00	0	f
1861	19	80306020	3 4 дүгээр хороолол Москва рестораны автобусны буудал 7 цагаас өмнө авъя ааГэмтлийн эмнэлгийн буудлын Эсрэг талын  M Мартын арын 89a  8dawhart 44 тоот..	3	172000.00	төлбөр танайх авна. 2ш авна	3	f	0	RSTDpdDvNe	2025-08-18 09:18:21.488+00	2025-08-19 10:41:01.468+00	f	f	2025-08-19 10:41:01.467+00	0	f
1862	61	99495667	Сэлэнгэ Сүхбаатар	3	0.00	тооцоо хийсэн	3	f	0	8iIcaguLCr	2025-08-18 10:08:45.042+00	2025-08-19 06:22:57.339+00	t	t	2025-08-19 06:22:57.338+00	0	f
1884	6	99979395	Замын үүд унаанд тавих	3	0.00	Унаанд өгөөд тухайн дугаарт тавьсан эсэхээ хэлэх	3	f	0	X7mC7UQtmR	2025-08-19 00:47:40.492+00	2025-08-19 06:23:26.64+00	f	f	2025-08-19 06:23:26.64+00	0	f
1872	54	89063066	1-r horoolol 32-r bairnii ard taliin 58-r bair 9n dawhar 60 toot	3	0.00	tootsoo hiigdsen tul mungu awahgvi	3	f	0	fgQ6WMUvs9	2025-08-18 14:57:25.966+00	2025-08-19 07:01:40.173+00	f	f	2025-08-19 07:01:40.173+00	0	f
1887	58	99929967	Дүнжингарав урд талын зогсоол	3	60000.00	сүүдрэвч 3х3. 14:00 цагаас өмнө авна.	9	f	0	XXaNupJ69x	2025-08-19 01:40:39.207+00	2025-08-19 07:05:37.216+00	f	f	2025-08-19 07:05:37.216+00	0	f
1863	21	80157733	Huvsgul aimag Tarialant sumiin unaand uguh.	3	0.00	Badamtsetseg-t. Narantuulaas Tarialantiin unaa yawdag. unaand uguud joloochiin dugaariig zaaval uguh	3	f	0	Nh4jLAgk9u	2025-08-18 11:13:22.1+00	2025-08-19 07:43:52.951+00	t	t	2025-08-19 07:43:52.951+00	0	f
1888	60	88672255	Баруун салаа 41 хорооны урдуур дөнгөж гараад Нарны хүүхдүүд цэцэрлэгийн араар өгсөөд 158-р цэцэрлэгийн араар өгсөөд 4дэхь ногоон хаалга 14-9а ногоон хаалга бгаа	3	85000.00	avtomat hataagch tulbur hiigdeegui	3	f	0	pYolm7L8AJ	2025-08-19 02:20:40.939+00	2025-08-19 09:28:29.132+00	f	f	2025-08-19 09:28:29.132+00	0	f
1889	60	88519967	25 dugaar emiin san 63 bair 2 toot	3	85000.00	evhegddeg modon hataagch tulbur hiigdeegui	3	f	0	ziAqX8tnXr	2025-08-19 07:47:06.749+00	2025-08-19 11:33:06.915+00	f	f	2025-08-19 11:33:06.915+00	0	f
1874	52	96021820	Oficeriin toirog MIU surguuliim zamiin esreg tald 107r bair 8 - 74 toot	3	6000.00	nomiunbaigal	9	f	0	JcFJu9qFI4	2025-08-18 17:54:00.662+00	2025-08-19 12:05:07.005+00	f	f	2025-08-19 12:05:07.005+00	0	f
1875	52	99672748	HUD 16r horoo Niseh garden hothon 323r bair 5-503 toot	3	6000.00	Oroin tsagaar hvntei	3	f	0	ICB4VXaWF8	2025-08-18 17:54:45.506+00	2025-08-19 12:32:31.691+00	f	f	2025-08-19 12:32:31.691+00	0	f
1881	52	99108606	Zaisan Gerelt hothon 25r bair 3 orts 36/1 toot	3	0.00	Zalgah ochihdoo	9	f	0	nihZwD2Vpe	2025-08-18 18:00:10.249+00	2025-08-19 12:53:05.525+00	f	f	2025-08-19 12:53:05.525+00	0	f
1877	52	99979971	SBD 11r horoo Khangai hothonii GO To Market - d	3	6000.00	Ochihdo zalgah	9	f	0	rQpDp5uS2d	2025-08-18 17:55:47.017+00	2025-08-19 13:48:49.32+00	f	f	2025-08-19 13:48:49.32+00	0	f
1873	60	95208171	Баруун 4 замын Kiwiko интернеттэй барилгын жантай гоймонгын газрын харуул дээр өгөх	3	85000.00	модон хатаагч төлбөр хийгдээгүй очхоосоо өмнө залгах	69	f	0	gP6Ptmm5eM	2025-08-18 15:21:53.744+00	2025-08-20 13:33:32.099+00	f	f	2025-08-20 13:33:32.099+00	0	f
1896	59	86780132	БЗД 16 хороо шүүхий шийдвэр гүйцэтгэх байр 	3	0.00	ирэхээсээ өмнө залгах	14	f	0	JxF8D8zqS4	2025-08-19 13:51:32.503+00	2025-08-20 11:01:39.962+00	f	f	2025-08-20 11:01:39.962+00	0	f
1878	52	89009829	BZD 19 r horoo Felhanowiin surguuliim hajugar uragshaa nariin zamaar 100 metr yawaad 50r bair 5-23 toot	3	6000.00	kod 4780#	14	f	0	1GoheMloTD	2025-08-18 17:57:10.196+00	2025-08-20 08:39:09.523+00	f	f	2025-08-20 08:39:09.523+00	0	f
1893	21	86035444	Global town B block 10dav 1012 toot	3	0.00	Bilguun Lhagvasuren-d	14	f	0	2F6IraOymK	2025-08-19 11:21:08.162+00	2025-08-20 12:26:37.755+00	t	f	2025-08-20 12:26:37.755+00	0	f
1897	59	95400561	29 хороо москва хороолол 8 ийн 92 тоот 	3	0.00	ирэхээсээ өмнө залгах	69	f	0	jlyoM87BKx	2025-08-19 13:52:56.474+00	2025-08-20 09:02:58.843+00	f	f	2025-08-20 09:02:58.843+00	0	f
1895	59	95814181	vogzaliin хойно 16 давхар байр 	3	86000.00	ирэхээсээ өмнө залгах	69	f	0	fgOGAFsZMt	2025-08-19 13:50:24.096+00	2025-08-20 13:07:06.54+00	f	f	2025-08-20 13:07:06.54+00	0	f
1898	59	99012374	өмнөговь	3	0.00	ирэхээсээ өмнө залгах	69	f	0	cm68vso8gC	2025-08-19 13:53:32.205+00	2025-08-20 08:12:58.373+00	f	f	2025-08-20 08:12:58.372+00	0	f
1902	59	807577998	яармаг 	3	0.00	ирэхээсээ өмнө залгах	3	f	0	5lppZfawgg	2025-08-19 13:55:36.418+00	2025-08-20 07:45:11.249+00	f	f	2025-08-20 07:45:11.249+00	0	f
1890	19	99028012	Циркийн баруун урд UB central байрны решепшинд үлдээх. 99028012	3	86000.00	төлбөр танайх авна	14	f	0	ss4VVf1sXg	2025-08-19 11:04:39.029+00	2025-08-20 07:51:44.218+00	f	f	2025-08-20 07:51:44.218+00	0	f
1900	59	98210990	дундговь аймаг 	3	0.00	ирэхээсээ өмнө залгах	69	f	0	62SSpFXWZ9	2025-08-19 13:54:30.27+00	2025-08-20 08:13:06.25+00	f	f	2025-08-20 08:13:06.25+00	0	f
1798	59	94121680	11 р хороолол 7 р хороо 9 р байр 6 давхар 129 тоот	3	35000.00	ирэхээсээ өмнө залгах	9	f	0	KW1SLqAFkT	2025-08-16 13:32:23.94+00	2025-08-19 14:09:02.322+00	f	f	2025-08-19 14:09:02.322+00	holbogdohgvj bolomjgvi	f
1906	60	90172117	Сүхбаатар аймаг руу унаанд тавьж өгөх	3	85000.00	автомат хатаагч төлбөр хийгдээгүй	66	f	0	P2lNkKbE5O	2025-08-20 02:47:02.411+00	2025-08-25 10:10:00.802+00	f	f	2025-08-25 10:10:00.802+00	utsa avaguu	f
1915	4	99196629	ХУД 22р хороо, Зайсан KFC Pizza Hut ын баруун урд Royal Green villa 206р байр 2орц 103тоот код 2062#	3	1.00	.	3	f	0	7LeYhJzQPf	2025-08-20 09:43:49+00	2025-08-21 15:14:19.929+00	f	f	2025-08-21 15:14:19.928+00	0	f
2347	26	80000985	Bayanzurh duurgiin emnelgiin ard 92b gants ortstoi uragshaa harsan bair bga 7 dawhar 31 toot kod ezgui baiwal gert uldeelgechne shu gene 0212# Tsenher	2	50000.00	tsenher	66	f	0	7DKo9bEdzv	2025-08-25 16:54:18.806+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
1921	21	99078710	BZD 26 horoo Olymp hothon 430 bair 2 orts 2dav 85 toot	3	0.00	ch. uyan-d	14	f	0	FFK4ELmYtG	2025-08-20 13:22:04.765+00	2025-08-22 13:54:24.003+00	t	f	2025-08-22 13:54:24.003+00	0	f
2355	52	88588332	Dornod aimag(tenger olazagas unaand	2	6000.00	Ugud medegdeh	66	f	0	DY6GEEANU6	2025-08-25 17:52:50.479+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2379	84	94444839	бзд 16 хороо СЮ тэй 10 дхвхар байр 2 орц 7 давхар 71 тоот	2	66000.00	.	66	f	0	TxKRw4nd0E	2025-08-26 03:48:20.575+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2332	59	85155095	tsambagaraviin zamiin tsagdsagin oodooos harsan 12bair 9r orts 311 toot code 311B	2	0.00	0	73	f	0	uynMykIBl4	2025-08-25 16:07:47.577+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
1885	60	99773924	99773924 BZD ulaanhuarangiin   82r tsetserleg	5	85000.00	avtomat hataagch tulbur hiigdeegui	14	f	0	SAvBxBqYur	2025-08-19 01:01:37.741+00	2025-08-20 11:17:36.863+00	f	f	\N	0	f
1912	6	80099201	BGD 22khoroo orgoogiin hoino Enkhbayariin zamaar ergeed mega city hothon 101bair 11 davhar 1109toot 	3	0.00	onoodor hvrgeh	69	f	0	JSfWXPwKBn	2025-08-20 06:48:11.721+00	2025-08-20 11:40:59.377+00	t	f	2025-08-20 11:40:59.377+00	0	f
1911	10	99866612	selnege aimagin unaand tawih	3	0.00	onoodor	69	f	0	JSoDN0roZR	2025-08-20 06:29:38.265+00	2025-08-20 07:58:21.284+00	t	f	2025-08-20 07:58:21.284+00	0	f
1905	61	99724864	Хавдар судлалын зүүн талд болор төв2 	3	0.00	Ajliin tsagaar	14	f	0	bmP8wtTO6a	2025-08-20 02:38:45.133+00	2025-08-20 10:04:57.446+00	t	f	2025-08-20 10:04:57.446+00	0	f
1910	10	88995079	tsambagaraw nomintoi bair buyu 39r bairnii 2orts 8dawhart 103 toot	3	0.00	onoodor	69	f	0	V9z23XK59P	2025-08-20 06:28:51.829+00	2025-08-20 10:49:27.371+00	t	f	2025-08-20 10:49:27.371+00	0	f
1901	59	94500929	БГД 29 хороо өнөр хотхон 45б байр 2р орц 149 тоот 	3	0.00	ирэхээсээ өмнө залгах	69	f	0	XiosiEGhQu	2025-08-19 13:55:20.657+00	2025-08-20 10:54:57.731+00	f	f	2025-08-20 10:54:57.731+00	0	f
1886	60	99005621	Хаяг ХХААЯ-ны арын 41-р байр 15 тоот	3	85000.00	модон хатаагч төлбөр хийгдээгүй	14	f	0	FYUKfuClgS	2025-08-19 01:03:26.593+00	2025-08-20 11:49:36.119+00	f	f	2025-08-20 11:49:36.118+00	0	f
1907	60	99859167	хорооллын билэг их дэлгүүрийн хойд талын цэнхэр байрны 25 байр 7 тоот 2 давхарт	3	85000.00	Автомат хатаагч талбөр хийгдээгүй	69	f	0	mXJChoIxJt	2025-08-20 05:19:20.387+00	2025-08-20 11:57:30.364+00	f	f	2025-08-20 11:57:30.364+00	0	f
1879	52	99906126	BZD Zam daguu Nomintoi Skytown 90a bair 11-40 toot	3	6000.00	kod 204060	14	f	0	eyrnSEpR8q	2025-08-18 17:58:11.645+00	2025-08-20 12:01:17.961+00	f	f	2025-08-20 12:01:17.96+00	0	f
1904	61	98336060	Эх нялхасын хойно шилмэл буйдан	3	0.00	Tootsoo hiisen ajliin tsagaar	69	f	0	CKZSRmXZbu	2025-08-20 02:20:16.903+00	2025-08-20 12:08:13.705+00	t	f	2025-08-20 12:08:13.705+00	0	f
1903	19	88101351	88101351 сонгино хайрхан дүүрэг 24-р хороо зээлийн 29-8а тоот	5	86000.00	төлбөр танайх авна	69	f	0	uIr4RiRK7R	2025-08-19 15:28:06.958+00	2025-08-20 13:34:47.211+00	f	f	\N	0	f
1916	59	90163111	hunnu 2222 115 байр 4 давхар 4c байр 	3	0.00	0	3	f	0	9JXkHqkdcI	2025-08-20 13:12:38.074+00	2025-08-21 16:09:44.387+00	f	f	2025-08-21 16:09:44.387+00	dolgoon nuur haygaa solison	f
1922	21	80206108	HUD 21 horoi Shurt hothon 816 bair 2 orts 4dav 96 toot	3	0.00	M.Batchimeg-t	3	f	0	fbBaV07SS5	2025-08-20 13:23:17.478+00	2025-08-21 16:59:56.965+00	t	f	2025-08-21 16:59:56.965+00	0	f
1914	4	80580314	СБД 3-р хороо, Хүүхдийн 100 Наран Маллийн урд 24-р байр, 10 давхар, 43 тоот. 0324#	3	1.00	.	14	f	0	lJf8tAN2Kg	2025-08-20 09:40:14.182+00	2025-08-21 06:46:45.011+00	f	f	2025-08-21 06:46:45.011+00	0	f
1918	59	89681889	3 4 хороолол senatoriin 15 байр 1р орц 3 тоот	3	35000.00	0	3	f	0	8azy9ynm2v	2025-08-20 13:15:09.71+00	2025-08-21 09:10:52.962+00	f	f	2025-08-21 09:10:52.962+00	0	f
1920	59	88583387	3 4 хороооллын эцэсээсээ цааш яваад говь сауний баруун талд саарал өнгийн байр 	3	0.00	0	3	f	0	9dJA9Urv2B	2025-08-20 13:17:51.116+00	2025-08-21 10:18:10.608+00	f	f	2025-08-21 10:18:10.608+00	utasaa awagui	f
1913	4	99339999	Драгоноос Архангай аймгийн төв автобусанд 08:00 14:00 19:00	3	1.00	.	3	f	0	j15aA1sn4Q	2025-08-20 09:38:05.757+00	2025-08-21 11:21:31.462+00	f	f	2025-08-21 11:21:31.462+00	0	f
1919	59	95286745	хар хорин дээрээс баянчандмань	3	0.00	0	3	f	0	4dWFm1hTHh	2025-08-20 13:16:42.502+00	2025-08-21 13:09:23.911+00	f	f	2025-08-21 13:09:23.911+00	0	f
1917	59	91373004	БЗД 17 хороо холбоо толгойт 41 гудамж 	3	0.00	0	9	f	0	ITwdI2b3Ak	2025-08-20 13:13:59.937+00	2025-08-23 08:58:36.475+00	f	f	2025-08-23 08:58:36.475+00		f
2333	59	98161508	bzd 43 horoo boroldoin ger tsetserlegiin baruun tald 91/3r bair 4davhar 13toot 	2	0.00	0	66	f	0	NVpSa33KVf	2025-08-25 16:22:00.045+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2248	52	94603750	Misheel expo giin baruun talaar Yawaad ulaan alag 84 r bair 1 orts 11-52 toot	2	6000.00	jaka	78	f	0	cnszsGvHoi	2025-08-24 18:40:48.487+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
1943	21	99184164	bagshiin deed UBH center 6dav 614 toot	3	0.00	door zogsoolgui bol zalgah buuj ochood awna, Bolortungalag-t	50	f	0	C9tGgOssCm	2025-08-21 01:46:11.106+00	2025-08-22 14:25:20.145+00	t	f	2025-08-22 14:25:20.145+00	utasaa awaagvi utasaa untraasan	f
1926	6	89482122	Монгол кино үйлдвэр Жуков хотхон 49а байр	3	0.00	Өдөртөө багтаж өгөх	14	f	0	zkKxYUCq0G	2025-08-20 13:35:14.749+00	2025-08-21 13:15:14.388+00	f	f	2025-08-21 13:15:14.387+00	0	f
2317	77	80707296 	Нисэх сөүл гардэн	2	19000.00	314-208 	78	f	0	iRpzFoxPIW	2025-08-25 14:03:40.229+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
1936	52	99252204	1 r surguuliim baruun urd Bid center	3	6000.00	b	50	f	0	M8pg2thnZD	2025-08-20 18:35:59.154+00	2025-08-22 07:25:06.948+00	f	f	2025-08-22 07:25:06.948+00	0	f
1928	21	90158000 80078072	Cwntral tower 7dav 712 toot.	3	0.00	Anu Ulambayar-t	14	f	0	xDG9ccR14F	2025-08-20 14:43:45.731+00	2025-08-22 08:10:42.836+00	t	f	2025-08-22 08:10:42.835+00	0	f
1883	6	99235486	Шар хад эрдэнэ толгой Харх авто шил хажууд Класс авто төв	5	0.00	Өдөртөө багтаж хүргэх	14	f	0	yUX7i7QVtT	2025-08-19 00:47:00.139+00	2025-08-22 09:56:25.339+00	f	f	\N	margash 11 uyd avna	f
2324	77	88653457 	 7hurtel 19iin uilchilgeeni toviin18r bair 	2	18000.00	orogtgol uschingiin door ger ahiud avna 	78	f	0	2vVTyVaLbc	2025-08-25 14:06:52.631+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2328	59	89403230	HUD nisehiin toirog uulzwar newt unguruud zamiihaa ardaa  daguu niseh garden 337r bair 8davhar 805toot #002201#eh garden 337r bair 8davhar 805toot kod#002201#	2	0.00	0	78	f	0	4peBGMW5R1	2025-08-25 14:53:45.367+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2354	52	99230783	Han uuliin emartiin 3n dawhart unet edleliin tasagt	2	6000.00	Togloomin tuwiin uuduus harsn	78	f	0	7rndqo0nXd	2025-08-25 17:52:15.77+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
1935	52	85450007	Naadam centeriun yag hoino Shilen MSN Building	3	6000.00	ired zalgah	3	f	0	TbZg2VN5rN	2025-08-20 18:35:30.166+00	2025-08-21 13:49:36.587+00	f	f	2025-08-21 13:49:36.587+00	0	f
1927	6	98006464	Төмөр замын хойно 65 байрны 1 орц 3 дав 12 тоот	3	0.00	Өдөртөө багтаж өгнө	3	f	0	7QEUoTtVSV	2025-08-20 13:36:26.106+00	2025-08-21 08:14:30.8+00	f	f	2025-08-21 08:14:30.8+00	0	f
1923	21	91967078	Erdenet-n unaand ugnu	3	0.00	Badamdari-d. unaand uguud joloochiin dugaar zaaval yawuulah	3	f	0	tT8RuxDVQc	2025-08-20 13:24:19.285+00	2025-08-21 08:16:06.386+00	t	t	2025-08-21 08:16:06.386+00	0	f
1940	6	99140339	БГД наранбулаг зочид буудлын залгаа байр 29-6тоот	3	1.00	үүдний хаалга 6b гэж залгана	3	f	0	55XjSx9xGJ	2025-08-21 00:16:48.371+00	2025-08-21 08:45:19.242+00	f	f	2025-08-21 08:45:19.241+00	0	f
1934	52	80867745	Modnii 2 bolon Gandangiin dund baidag Erdene Anagaah Zasal tuw	3	6000.00	Emneleg uchir irehde yarih	3	f	0	LSMhepaHdD	2025-08-20 18:34:08.355+00	2025-08-21 08:47:52.159+00	f	f	2025-08-21 08:47:52.158+00	0	f
1931	52	99149497	Moskwa horoolol 131/2 baid 1 orts 3-13 toot	3	0.00	n	3	f	0	ZzUpZ44jvU	2025-08-20 18:31:24.507+00	2025-08-21 10:53:32.178+00	f	f	2025-08-21 10:53:32.178+00	0	f
1941	60	99910447	99910447хаяг Чингэлтэй дүүргийн 4р хороо глобал төв 405тоот	3	85000.00	Avtomat hataagch tulbur hiigdeguu	50	f	0	6w7nle6tiD	2025-08-21 01:30:28.458+00	2025-08-22 12:30:34.372+00	f	f	2025-08-22 12:30:34.372+00	0	f
1932	52	99968956	Govialtai aimag avtobusand	3	6000.00	Ugchud zalgah eswel msj	3	f	0	DyVNdlkJaJ	2025-08-20 18:32:31.391+00	2025-08-21 11:21:11.743+00	f	f	2025-08-21 11:21:11.743+00	0	f
1929	58	88002066	СХД 6 дугаар хороо дүүхээ 2 дэлгүүр.	3	45000.00	Усан буу 1ш	3	f	0	9hQ3x4D0dK	2025-08-20 14:54:25.644+00	2025-08-21 11:24:56.039+00	f	f	2025-08-21 11:24:56.038+00	0	f
1924	59	88047295	БЗД 15 хороо хос өргө хотхон 69 байр 1 орц 5 тоот 2 давхар 	3	0.00	0	14	f	0	BkjGsFYQ1g	2025-08-20 13:30:57.6+00	2025-08-21 11:38:25.6+00	f	f	2025-08-21 11:38:25.6+00	0	f
1925	6	99886384	БГД 29 хороо Хархорин хороолол 51-4 байр1 орц 6 дав 33 тоот	3	0.00	Өдөртөө багтаж өгнө.	3	f	0	17xVwNPLLc	2025-08-20 13:33:31.327+00	2025-08-21 12:58:20.587+00	f	f	2025-08-21 12:58:20.587+00	0	f
1938	6	88052787	жуков поларис хотхон 57А 1р орц 901тоот	3	1.00	орцны код 88052787#	14	f	0	1AgjWm9DGB	2025-08-21 00:13:42.744+00	2025-08-21 12:59:07.268+00	f	f	2025-08-21 12:59:07.268+00	0	f
1909	10	89992643	bzd 13 horoolol 25 horoo nogoon togol	3	0.00	ff	14	f	0	u3XDnNfSiP	2025-08-20 06:18:38.216+00	2025-08-22 12:38:51.951+00	t	f	2025-08-22 12:38:51.951+00	0	f
1933	52	95769192	BZD tsagdaagiin gazriun urd  Bayanzurh horoolol 103/1 bair 16-39 toot	3	6000.00	b	14	f	0	WFM7y6vfuu	2025-08-20 18:33:20.118+00	2025-08-21 13:55:23.441+00	f	f	2025-08-21 13:55:23.441+00	0	f
1908	60	99152933	akoya residence  tower (tokyo towni hajuud yag alpha zone-n esreg tald) 54/a 1 ortstoi 8 davhar 805 toot	3	85000.00	эвхэгддэг модон хатаагч 5 дахь өдөр хүргүүлж авна төлбөр хийгдээгүй	3	f	0	8NpNHygTBD	2025-08-20 05:56:34.035+00	2025-08-21 14:14:29.174+00	f	f	2025-08-21 14:14:29.174+00	0	f
1939	6	99111507.91917105	зайсан golden vill 201.1.11 тоот 6давхарт	3	1.00	орцны код 2011	3	f	0	JRBtpTy4NC	2025-08-21 00:15:22.163+00	2025-08-21 14:51:49.273+00	f	f	2025-08-21 14:51:49.273+00	0	f
1937	52	88812958	zaisan tolgoin zvvn tald zam daguu Golden Vill hothon Dor Herlen Delgvvrt vldeelgeh	3	6000.00	vldeged medegdeh	3	f	0	7uFo6yHUYz	2025-08-20 18:36:47.07+00	2025-08-21 14:52:01.77+00	f	f	2025-08-21 14:52:01.77+00	0	f
1930	52	88027018	HUD arzaisan Whitehill hothon 100	3	6000.00	Ochihdoo zalgah	3	f	0	53E0h1rahY	2025-08-20 18:30:38.324+00	2025-08-21 15:15:38.758+00	f	f	2025-08-21 15:15:38.758+00	0	f
1945	61	99906106	Дашчойлан хийдийн ард Гаалийн ЕГ 	3	0.00	Жижүүрт 99906106 дугаар бичүүлж үлдээх	78	f	0	FYTqDgpoGQ	2025-08-21 02:41:33.066+00	2025-08-24 09:57:13.853+00	t	f	2025-08-24 09:57:13.853+00	0	f
2366	26	88109976	ХУД 3-р хороо Гэрэлт өргөө хотхон 47в 17тоот tsenher yagaan tsag	2	50000.00	yagaam tsag	78	f	0	8hDwqBgWHJ	2025-08-26 01:46:56.683+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2316	77	88166242 	 tov aimag jargalant	2	0.00	tolbor batalgaajsan 	9	f	0	iZDrUy8sBn	2025-08-25 14:03:01.807+00	2025-08-26 05:24:43.881+00	t	t	\N	0	f
2375	76	88700938	Yarmag 23 khoroo Nukhtiin am ugsuud Arvai villa 740 bairnii 1r orts 15davhart 1504 toot, lifteer buugaad chigeerei	2	77800.00	1ш Цагаан багц + 2ш 00 цаас буюу багцтайгаа нийлээд 3ш 00 цаас явна.	78	f	0	TQFljHHWTX	2025-08-26 03:35:47.443+00	2025-08-26 06:59:37.573+00	f	f	\N	0	f
1944	61	86131100	Dornogovi	3	0.00	Тооцоо хийсэн. Өнөөдөр унаанд тавина	3	f	0	0Xu2U9Eokh	2025-08-21 02:36:57.085+00	2025-08-21 08:17:13.785+00	t	t	2025-08-21 08:17:13.785+00	0	f
1947	59	99162723	huuchin dragon ariin 22b 4orts 126 toot	3	0.00	b	3	f	0	EaQqHJmDi3	2025-08-21 09:20:00.454+00	2025-08-21 12:34:07.694+00	t	f	2025-08-21 12:34:07.694+00	0	f
1942	60	88160110	HUD 15 horoo , Global town c block 19 davhar 1902 toot 88160110	3	85000.00	Modon hataagch tulbur hiigdeegui	3	f	0	MYCRcjPA0E	2025-08-21 01:44:44.432+00	2025-08-21 14:29:05.018+00	f	f	2025-08-21 14:29:05.018+00	0	f
1964	52	95869652	CHD 10r horoo 30r bair 383 toot	3	6000.00	Olku bol zalgarai	50	f	0	SDjjb1tcKb	2025-08-21 19:24:17.363+00	2025-08-25 14:52:20.433+00	f	f	2025-08-25 14:52:20.433+00	dugaar n ashiglaltand bhgvi	f
2334	59	94606280	mongol kino uildver	2	0.00	0	66	f	0	leYZkROBjz	2025-08-25 16:27:05.551+00	2025-08-26 04:40:43.104+00	f	f	\N	0	f
2319	77	72129551 	denjiin myngin shin zam uruudad gants 12 davhar bor bair 1004r bair 45toot 	2	25000.00	99990700 	73	f	0	5XNRoa5Vnj	2025-08-25 14:04:38.374+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
2361	20	99015982	цэцэг төвийн төрийн банк	2	1.00	төлбөр авахгүй	73	f	0	TVuTL8iul8	2025-08-25 23:07:26.302+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
2367	26	99990169	Циркийн зүүн талд  . СБД 2- р хороо 29байр 27 тоот ягаан цаг	2	50000.00	yagaan	73	f	0	WT4hEW5VFi	2025-08-26 01:47:36.48+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
2370	77	99712478 	BGD 23horoo enhbayrin zamaar deeshe ogsood ulaan toosgon delguur	2	18000.00	deer ireed zalga zuun ard ayush 25iin 204b 89258886 	73	f	0	hqsJbf6UJ4	2025-08-26 03:14:55.896+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
1990	58	6454554485	ыхшызырыхы	1	2500858.00	хыүыраы	\N	f	0	gOIGMwJd30	2025-08-22 04:49:07.141+00	2025-08-22 04:49:28.563+00	f	f	\N	0	t
1962	52	99003845	13 Natur Hudaldani tuwiin urd 87r bair 10-55 toot	3	6000.00	n	14	f	0	tbKNwUa9TT	2025-08-21 19:22:29.849+00	2025-08-22 12:07:00.259+00	f	f	2025-08-22 12:07:00.258+00	0	f
1989	58	99888007	агуулйх	1	45000.00	өнөөдөр	\N	f	0	xGSXDY0bvs	2025-08-22 04:48:10.593+00	2025-08-22 04:52:38.286+00	f	f	\N	0	t
1982	19	88924050	Баянгол дүүрэг 24рхороо Middle river 46b bair	3	86000.00	төлбөр танайх авна	73	f	0	ZpbjZQXPin	2025-08-22 01:12:14.02+00	2025-08-22 12:22:11.38+00	f	f	2025-08-22 12:22:11.38+00	0	f
1956	59	86881804	Baruun 4zamin shilmel zagwarin gda irerei	3	0.00	0	50	f	0	wKo6FZlqCg	2025-08-21 17:14:03.245+00	2025-08-22 12:29:44.552+00	f	f	2025-08-22 12:29:44.552+00	0	f
1953	59	85206069	10р хороолол, 80а байр, 1р орц, 13давхар, 97тоот 12оосоо дээшээ нэг давхар шатаар гарна 	5	0.00	0	50	f	0	USJFFj9RAi	2025-08-21 17:08:06.677+00	2025-08-23 11:44:37.324+00	f	f	\N	Утас аа аваагүй	f
1968	52	88066125	Harhorin horoolol 55r bairnii 12 dawhart 61 toot	3	6000.00	n	73	f	0	BDmyr7pE5I	2025-08-21 19:27:07.664+00	2025-08-22 13:04:58.281+00	f	f	2025-08-22 13:04:58.281+00	0	f
1959	52	89259515	Umnugovi unaand	3	6000.00	uguud heleh Dalanzadgad sapporogos yawdg	73	f	0	qqEHEvjIzh	2025-08-21 19:19:59.63+00	2025-08-22 13:22:52.726+00	f	f	2025-08-22 13:22:52.726+00	0	f
1954	59	95820913	СХД 18 р хороо вита сити байгаль буудлаас хойшоо 150м 12д 	3	0.00	0	73	f	0	8ElUvLOUww	2025-08-21 17:10:51.709+00	2025-08-22 13:39:26.886+00	f	f	2025-08-22 13:39:26.886+00	0	f
1949	21	88928282	SHD 21 horoolol chuhag hothon 32b bair 5dav 19 toot	3	0.00	Enhzol-d. kod tulhuur 1355.  chingis soosagin baruun taliinh	73	f	0	ejkS6wpr3z	2025-08-21 12:52:21.908+00	2025-08-22 13:46:35.136+00	t	f	2025-08-22 13:46:35.136+00	0	f
1987	72	99942079	СБД тоосгоны үйлдвэрийн эцсийн буудал	3	65000.00	Мөнгөө заавал авна. Нийтдээ 65.000	14	f	0	rIvjBz5qZL	2025-08-22 02:45:10.283+00	2025-08-22 14:50:03.773+00	f	f	2025-08-22 14:50:03.772+00	0	f
1948	58	88088027	Их дэлгүүрийн ард 2 дугаар байр 3р орц 33 тоот.	3	0.00	Сүүдрэвч шар 6х4.5. 17:00 цагаас өмнө авна.	50	f	0	cJaR4D4qOk	2025-08-21 09:37:08.666+00	2025-08-22 06:15:31.631+00	f	f	2025-08-22 06:15:31.631+00	0	f
1961	52	89059350	KhanUul tower	3	6000.00	Ajiliin tsagaar !	73	f	0	wTzzyvXJEr	2025-08-21 19:21:37.417+00	2025-08-22 08:14:18.972+00	f	f	2025-08-22 08:14:18.972+00	0	f
1950	21	99193547	1r turuhiin hajud Azmon tuv haruuld uldeeh	3	0.00	Baljidmaa-d	50	f	0	yiPS5Yzqgb	2025-08-21 12:53:14.235+00	2025-08-22 08:18:10.434+00	t	f	2025-08-22 08:18:10.434+00	0	f
1952	21	88888262	zaisan HAAIS-n ard Altanbogd hothon A block 2d 2toot.	3	0.00	Gerelee-d. kod: tulhuur0002. HAAIS-n ard 35r tsetserlegin urd	73	f	0	51Ll7s5ee9	2025-08-21 12:55:35.783+00	2025-08-22 08:43:01.911+00	t	f	2025-08-22 08:43:01.911+00	0	f
1966	52	99902986	SBD 11r horoo Pro One office 4-402 toot	3	6000.00	b	50	f	0	WbszH7iXYU	2025-08-21 19:25:41.948+00	2025-08-22 09:25:44.631+00	f	f	2025-08-22 09:25:44.631+00	0	f
1971	52	85780425	SBD 10r horoo 44r bair 1 orts 10-48 toot	3	6000.00	b	50	f	0	5hFp5KYZkb	2025-08-21 19:29:36.956+00	2025-08-22 10:11:10.414+00	f	f	2025-08-22 10:11:10.414+00	0	f
1960	52	99825111	HUD 20r horoo Lawai zahiin urd Jargalan erdene hothon 16-137 toot	3	6000.00	Kod #2580	73	f	0	eQKlY2hwN5	2025-08-21 19:21:00.144+00	2025-08-22 10:16:46.883+00	f	f	2025-08-22 10:16:46.883+00	0	f
1951	21	99285305	BGD 24 horoo 35-3 bair	3	0.00	Ariunaa-d	73	f	0	ZsvcoNr8rq	2025-08-21 12:54:00.56+00	2025-08-22 11:35:34.819+00	t	f	2025-08-22 11:35:34.819+00	0	f
1957	59	94730588	Naturiin zam daguu uruudaad zam daguu golomt banktai 6davhar bair baigaa 6davhart 12toot	3	0.00	0	14	f	0	ZQ6rJrUGCb	2025-08-21 17:15:29.037+00	2025-08-22 11:49:54.51+00	f	f	2025-08-22 11:49:54.51+00	0	f
2027	59	80956535	ургах наран 	3	0.00	0	66	f	0	CQjORmIoK2	2025-08-23 01:39:43.424+00	2025-08-25 10:10:15.723+00	f	f	2025-08-25 10:10:15.723+00	utsa avaguu	f
1994	6	89140903	bzd 16-r horoolol 72-r hothon 52.6 bair imij salon	3	0.00	onoodor	14	f	0	3TFFfrBdk6	2025-08-22 05:35:03.886+00	2025-08-22 11:07:36.501+00	t	f	2025-08-22 11:07:36.501+00	0	f
2002	59	80974047	Муис 2байрны ард 48р байр 12давхар 65тооь	3	0.00	байхгүй	50	f	0	0XxuC80Ifh	2025-08-22 10:37:11.15+00	2025-08-22 11:34:35.552+00	f	f	2025-08-22 11:34:35.552+00	0	f
2114	77	95105818 	 narantuul baylag undraa	5	20000.00	99219498  	66	f	0	dH6JHpPlFY	2025-08-23 12:58:54.178+00	2025-08-25 14:31:30.703+00	f	f	\N	bolison	f
2335	59	85739880	suhbaatar aimag baruun urt sum	2	0.00	0	66	f	0	nHzhG3oZYO	2025-08-25 16:28:48.319+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2009	59	85206069	10horoolol 80a bair 13 dawhart	3	0.00	o	73	f	0	HhEwJKWBRp	2025-08-22 13:02:56.987+00	2025-08-22 13:41:37.267+00	f	f	2025-08-22 13:41:37.267+00	0	f
2001	72	80807609,,,,91545455	Cхд _н 6 р хороо ханын материалын эцэс 5 р байр 32тоот	3	65000.00	Гэрээс ирж авна. Мөнгийг нь заавал авна	50	f	0	aWD1yuJjp0	2025-08-22 09:02:32.167+00	2025-08-23 12:26:12.843+00	f	f	2025-08-23 12:26:12.843+00	0	f
1974	52	88845212	BGD 27 r horoo 54 r bair 46 toot	3	6000.00	n	73	f	0	x9O6AdHE3h	2025-08-21 19:31:51.002+00	2025-08-22 12:54:53.038+00	f	f	2025-08-22 12:54:53.038+00	0	f
1967	52	88358080	Hoimor Office iin baruun hoino 284r bair	3	6000.00	dor ireed zalgah	50	f	0	2wi8AVTTM6	2025-08-21 19:26:26.499+00	2025-08-23 03:43:02.791+00	f	f	2025-08-23 03:43:02.791+00	utasaa awaagvi	f
1991	58	88002066	СХД 6 дугаар хороо дүүхээ 2 дэлгүүр.	3	0.00	усан буу дахин өгнө.	73	f	0	6EPELOoKBt	2025-08-22 04:50:42.094+00	2025-08-22 06:15:37.612+00	f	f	2025-08-22 06:15:37.612+00	0	f
1976	71	99390967 99400126	wogzalas awna 3as hoish 6 bogand ssuna	3	6000.00	unaand taviulna	73	f	0	Mv1pnZuGuR	2025-08-22 00:46:16.63+00	2025-08-22 07:53:49.35+00	f	f	2025-08-22 07:53:49.35+00	0	f
1988	72	99060813	Драгон-Дарханы унаанд тавих	3	65000.00	Мөнгийг нь заавал авна.	73	f	0	asC5eul2QQ	2025-08-22 02:50:20.654+00	2025-08-22 07:54:10.126+00	f	f	2025-08-22 07:54:10.125+00	0	f
1986	72	99062920	Драгон- Дархан явах машинд тавина	3	65000.00	Унаанд тавиад мөнгөө заавал авна.Өнөөдөртөө амжиж унаанд тавих.Манайх хүргэлт үнэгүй гэдэг болохоор 65к аа л авна	73	f	0	JfLwKLi5aG	2025-08-22 02:42:12.595+00	2025-08-22 07:54:21.6+00	f	f	2025-08-22 07:54:21.599+00	0	f
1970	52	94416319	Mubis Oyutnii bair -1 4n dawhar tsagaan baishin	3	6000.00	gada ired heleh	50	f	0	gD4Ox1e9um	2025-08-21 19:28:46.69+00	2025-08-22 08:25:05.141+00	f	f	2025-08-22 08:25:05.141+00	0	f
1985	21	99459414	11r horoolold. deerh utasruu zalgaj hayag asuuh	3	0.00	T.Namuun-d	50	f	0	TB2wULUwE1	2025-08-22 02:40:28.891+00	2025-08-22 08:48:14.862+00	t	f	2025-08-22 08:48:14.862+00	0	f
1984	21	80881870	Gaaliin erunhii gazar	3	0.00	sunny sun-d. ajiliin tsagaar awna	50	f	0	mTB2DkEJxN	2025-08-22 01:43:45.493+00	2025-08-22 09:05:40.637+00	t	f	2025-08-22 09:05:40.637+00	0	f
1997	6	95134114	suhbaatar aimag bayn delger sum	3	0.00	onoodor	14	f	0	5StGoWGuiK	2025-08-22 05:37:53.376+00	2025-08-22 09:46:42.97+00	t	f	2025-08-22 09:46:42.97+00	0	f
1973	52	89141451	Tenger Plaza- S Baganuuriin unaand	3	6000.00	Ogood heleh	14	f	0	EtYWPpVutm	2025-08-21 19:31:08.014+00	2025-08-22 09:53:25.833+00	f	f	2025-08-22 09:53:25.833+00	0	f
1992	6	89102691	sbd 11-horoo 912b 1orts 12-41 toot	3	0.00	onoodor	50	f	0	7jXRPtyAzZ	2025-08-22 05:31:06.938+00	2025-08-22 09:56:32.491+00	t	f	2025-08-22 09:56:32.49+00	0	f
1965	52	89861486	BZD 44 r surguuliin zvvn tald Mansarttai 27a bair	3	6000.00	Gada garad awna	14	f	0	TeKQsqSzNu	2025-08-21 19:25:07.135+00	2025-08-22 10:23:08.013+00	f	f	2025-08-22 10:23:08.012+00	0	f
1995	6	88102504	3-4 horoolol etses emart ogloo 12os omno hurgeh	5	0.00	hurgeh	50	f	0	rj5vlNzibw	2025-08-22 05:35:56.554+00	2025-08-22 10:41:36.166+00	t	f	\N	0	f
1993	6	88010073	tsagdaagin akademiin hajuud shar hadruu ywdag zamd herlen hothon gs tei bair utas	3	0.00	onoodor	14	f	0	52UIVDdKyq	2025-08-22 05:32:54.644+00	2025-08-22 10:43:05.991+00	t	f	2025-08-22 10:43:05.991+00	0	f
1983	19	99234075	niseh ajil deeree awna 	2	86000.00	төлбөр танайх авна	78	f	0	EYbnShCtrH	2025-08-22 01:37:32.34+00	2025-08-26 04:54:06.503+00	f	f	\N	margaash awna	f
2380	71	95341986	erdenet	2	0.00	.	9	f	0	G2923ElslM	2025-08-26 05:51:20.574+00	2025-08-26 06:21:35.685+00	f	f	\N	0	f
1998	10	88890940	narnii horoolol 7bair 2orts 65toot	3	0.00	onoodor	73	f	0	F1PUIoXwva	2025-08-22 05:39:16.498+00	2025-08-22 11:03:16.001+00	t	f	2025-08-22 11:03:16.001+00	0	f
1999	10	89077729	shd 6horoo toosgonii 24-65a 	3	0.00	onoodor	73	f	0	vwZLxqxiTf	2025-08-22 05:40:28.382+00	2025-08-22 13:46:56.323+00	t	f	2025-08-22 13:46:56.323+00	0	f
1969	52	95565935	Arkhangai aimag Erdene bulgan sumruu	3	0.00	Shuudand	50	f	0	nTXnO0qVi5	2025-08-21 19:27:52.819+00	2025-08-23 11:14:06.711+00	f	f	2025-08-23 11:14:06.711+00	martawina	f
1980	71	88669056	Dornod halh gol	3	6000.00	ogoomor zahd 88810434 gesen dugaartai hund ogno	14	f	0	0OKIeNGoBz	2025-08-22 01:00:14.546+00	2025-08-22 15:40:42.695+00	f	f	2025-08-22 15:40:42.695+00	0	f
1972	52	86119656	Central Tower 15 dawhart	3	6000.00	Oroin tsagaar Baraan deer dood hayg!	73	f	0	ZdfeqNbsYc	2025-08-21 19:30:17.416+00	2025-08-22 15:55:57.657+00	f	f	2025-08-22 15:55:57.656+00	0	f
2007	59	85206069	10horoolol 80a bair 13 dawhart	1	0.00	o	\N	f	0	qqrm0GzgNz	2025-08-22 13:02:18+00	2025-08-23 00:44:54.732+00	f	f	\N	0	t
2004	75	89502889	govi Altai aimag esonbulag avtobusand tavih	1	6000.00	coach tsvnh kod:55398  tom ulaan -1sh	\N	f	0	YajKKpfLq9	2025-08-22 10:58:25.044+00	2025-08-23 02:30:15.693+00	f	f	\N	0	t
2006	75	90009593	Bzd 10r horoo hangamj 10iin 330.	1	6000.00	coach 8885 har ungu-1 sh	\N	f	0	dW9cuyy34o	2025-08-22 11:09:01.644+00	2025-08-23 02:30:39.448+00	f	f	\N	0	t
2094	71	982841199	dornod	3	0.00	onoodor	9	f	0	MXZSJPIja0	2025-08-23 06:02:33.126+00	2025-08-23 07:53:30.038+00	t	f	2025-08-23 07:53:30.038+00	0	f
2013	6	99819352	бгд 4 хороолол 32хороо 16-86	3	1.00	өдөртөө багтааж хүргэх	50	f	0	deYH0EudGH	2025-08-22 14:17:26.048+00	2025-08-23 14:06:36.394+00	f	f	2025-08-23 14:06:36.394+00	0	f
2115	77	99275448 	altai hothoni 21r bair deer ireed zalga	3	18000.00	baihgu bol delguurt uldeelgen	78	f	0	cq1oMJSU1T	2025-08-23 12:59:29.815+00	2025-08-24 10:38:27.855+00	f	f	2025-08-24 10:38:27.855+00	0	f
2078	77	88316799	hoshuunii huuhed zaluuchudiin teatr	3	19000.00	88595510	50	f	0	IiVsNhFmlL	2025-08-23 04:06:00.008+00	2025-08-23 12:37:16.321+00	f	f	2025-08-23 12:37:16.32+00	0	f
2084	77	80696825	modni 2	3	19000.00	huuhdin tov suvilal	50	f	0	G3HmJHEjo8	2025-08-23 04:11:00.352+00	2025-08-23 08:57:18.857+00	f	f	2025-08-23 08:57:18.857+00	0	f
1975	52	99272345	BZD 26r horoo Olimp village 200r bair 2 orts 12-187 toot	3	6000.00	kod 2002#	78	f	0	BcyBNT08IV	2025-08-21 19:33:02.683+00	2025-08-23 07:12:52.775+00	f	f	2025-08-23 07:12:52.775+00		f
2011	60	95959572	Bella vista 500 bair 1602	3	85000.00	Модон хатаагч	78	f	0	BUdF34zyem	2025-08-22 13:49:33.955+00	2025-08-23 08:59:50.728+00	f	f	2025-08-23 08:59:50.728+00	0	f
2014	6	89217707	чингэлтэй дүүрэг 3р хороо 8р байр 1орц 13тоот	5	1.00	их  дэлгүүрийн чанх арын байр	9	f	0	zetwFHmcu7	2025-08-22 14:53:08.173+00	2025-08-24 04:42:59.771+00	f	f	\N	0	f
2336	59	99502710	схд  22 horoo hilchingiin77/31	2	0.00	0	9	f	0	HSjVhuKuoY	2025-08-25 16:36:04.629+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
2043	77	80005258	Хуучин газарчин И Старт	3	22000.00	Газарчин сур дээр ирээд залга 80005257	66	f	0	DmiKMHFn5U	2025-08-23 03:18:25.367+00	2025-08-25 12:25:58.931+00	f	f	2025-08-25 12:25:58.931+00	0	f
2049	77	94240654	Баян хошуу	3	19000.00	112р буудал дээр 99940675	50	f	0	jLQMJHNUXp	2025-08-23 03:29:41.932+00	2025-08-25 13:53:40.555+00	f	f	2025-08-25 13:53:40.555+00	holbogdoh bolomjgvi	f
2008	59	85206069	10horoolol 80a bair 13 dawhart	1	0.00	o	\N	f	0	FZxOirHhLI	2025-08-22 13:02:18.308+00	2025-08-23 00:44:54.732+00	f	f	\N	0	t
2048	77	99087454	яармаг силар сити	5	23000.00	1275р байр 1505 тоот	78	f	0	MTB2ghfxdn	2025-08-23 03:28:32.841+00	2025-08-26 04:07:13.781+00	f	f	\N	huduu baigaa gesen	f
2003	75	99415000	худ 23хороо  Яармаг  Хучнаар Арцатын Ам 1465 байр 03тоот	1	6000.00	coach tsvnh kid:8885  har ungu-1sh	\N	f	0	9CNx4jMYSK	2025-08-22 10:54:59.993+00	2025-08-23 02:30:15.693+00	f	f	\N	0	t
2005	75	89848799	govialtai aimag esonbulag avtobusand hiih	1	6000.00	coach tsvnh kod 55398 Tom ulaan -1sh (zaaval avtobusnd higere gsn yrij bgad unaand higerei bus n 15tsagaas huduldug gsn bn)	\N	f	0	gCO7LugUQI	2025-08-22 11:06:48.001+00	2025-08-23 02:30:15.693+00	f	f	\N	0	t
2381	71	94644636	gobi altai	2	0.00	.	66	f	0	Dydtlpg9Yb	2025-08-26 05:52:38.268+00	2025-08-26 06:21:11.646+00	f	f	\N	0	f
2019	61	89057511	BZD Amar hoteliin zergeldee undur shar baishin 89057511	5	29900.00	Тооцоо хийгээгүй. 94609992 дугаараар холбогдсон	66	f	0	UbiYuWwJ8Z	2025-08-22 20:11:59.412+00	2025-08-26 04:21:13.95+00	f	f	\N	utsaa avaagui	f
2028	59	96830247	БЗД 38 хороо garden residence 1 хотхон 51а байрны 3 давхар 28 тоот	2	0.00	0	66	f	0	dymTDkDVwL	2025-08-23 01:41:53.383+00	2025-08-26 06:29:39.078+00	f	f	2025-08-24 13:08:01.968+00	0	f
2038	77	91281210	Monel iin gerlen dohiogoor ergeed 4 buudal yvaad tselmeg hunsni delguur deer	1	19000.00	Хөмсөгний хэв 1ш 19000₮	\N	f	0	sWhu5s96wp	2025-08-23 03:09:49.753+00	2025-08-23 03:11:42.687+00	f	f	\N	0	t
2029	77	99377653	Ахмадын хороолол 51ийн 100тоои	1	19000.00	Хялбар вакс 1ш 19000₮	\N	f	0	rT9qGIrfcJ	2025-08-23 02:12:20.066+00	2025-08-23 03:14:06.573+00	f	f	\N	0	t
2037	77	91281210	Monel iin gerlen dohiogoor ergeed 4deh buudal tselmeg delguur deer	1	19000.00	Хөмсөгний хэв 1ш 19000₮	\N	f	0	RuTboVFpIR	2025-08-23 03:08:22.686+00	2025-08-23 03:14:06.573+00	f	f	\N	0	t
2045	77	99717353	temuulel hothon 104r bair 9davhar 74r toot	3	18000.00	3r emnelegin hajud	50	f	0	VJUWGTQqMr	2025-08-23 03:23:42.738+00	2025-08-24 16:43:03.801+00	f	f	2025-08-24 16:43:03.801+00	0	f
2015	21	99187906	Darhanii unaand ugnu, Teevriin tovchoonoos tender jolooch 99995957 joloochid uguh	3	0.00	Baya Uka-d. teevriin tovchoon deer tender jolooch 99995957 gsn unaand uguh,	50	f	0	X7KUkLJLBf	2025-08-22 15:16:46.141+00	2025-08-23 11:15:03.038+00	t	t	2025-08-23 11:15:03.038+00	0	f
2016	21	90209948	Umnu gobi aimag Tsogttsetsii sumruu	3	0.00	B.Buyantogtoh-d. tsogttsetsii unaand uguh, joloochiin dugaariig zaawal yawuulah.	50	f	0	ybKgIwfcC7	2025-08-22 15:17:58.607+00	2025-08-23 11:15:17.578+00	t	t	2025-08-23 11:15:17.578+00	0	f
2041	77	99377653	ahmadin horoolol 51r bair 100toot	5	19000.00	hylbar wax - 19000₮	9	f	0	LsUatZrvSt	2025-08-23 03:15:55.338+00	2025-08-25 03:50:09.935+00	f	f	\N	uur hvn hurgej ugsun	f
2018	72	88225512	Драгон- Говь Алтай аймаг руу явах унаанд тавина	5	65000.00	Мөнгөө заавал авна	3	f	0	vuL5OWZqKc	2025-08-22 16:22:58.546+00	2025-08-24 06:33:06.72+00	f	f	\N	3zalgasan utasaa awaagvi	f
2012	60	91915665	их дэлгүүрий баруун хойно 10 байр 4 оц 2 давхарт 53 тоот	3	160000.00	1 автомат хатаагч 1 модон хатаагч Бүтэн сайн өдөр үдээс хойш авах төлбөр хийгдээгүй	78	f	0	78EoAX36Bl	2025-08-22 13:55:52.27+00	2025-08-24 07:21:39.67+00	f	f	2025-08-24 07:21:39.67+00	margash avna	f
2047	77	88618873	Дарь их 127р сургууль ийн хажууд	3	18000.00	4р гудамж 1640тоот 80271220	73	f	0	SUbjwimSTc	2025-08-23 03:27:32.892+00	2025-08-23 12:23:22.497+00	f	f	2025-08-23 12:23:22.497+00	0	f
2030	75	98240002	hentii aimag dadal sum (narantuulaas unaand tavih)	3	0.00	coach kod:8885 har ungu-1sh	9	f	0	M19O3Z5R98	2025-08-23 02:37:27.382+00	2025-08-24 08:54:13.29+00	f	f	2025-08-24 08:54:13.29+00	margash unand tavin	f
2017	21	99024707	BZD26 horoo Timetower hothon 218 bair Zara delguur	3	0.00	Zara delguur deer.	78	f	0	y1YuF6lxW7	2025-08-22 15:19:02.209+00	2025-08-23 07:15:23.355+00	t	f	2025-08-23 07:15:23.355+00	0	f
2020	61	80898686	Дэлгэрэх хотхон 80-3 орц 9 давхар 80 тоот 	3	29900.00	Тооцоо хийгээгүй	78	f	0	208H5iuzCy	2025-08-22 20:15:19.205+00	2025-08-23 10:11:46.988+00	f	f	2025-08-23 10:11:46.988+00	0	f
2033	75	88247086	БЗД улаанхуаран конфорт хотхон 71в 225 тоот	3	0.00	coach kod:8885 Tsagaan ungu-1sh	9	f	0	IyEZbMPVbN	2025-08-23 02:42:09.039+00	2025-08-23 10:32:58.678+00	f	f	2025-08-23 10:32:58.678+00	0	f
2035	75	99415000	hud 23r horoo Yaarmag artsadiin am 1465r bair 03toot	3	72000.00	coach kod:8885 har ungu-1sh	78	f	0	XbbARPZk4a	2025-08-23 02:43:46.279+00	2025-08-23 11:06:25.193+00	f	f	2025-08-23 11:06:25.192+00	0	f
2042	77	91281210	monel iin tselmeg hunsni delguur	3	19000.00	monel iin gerlen dohiogoor zuun erged 4deh avtobusni buudal	73	f	0	S3OQPDuRGj	2025-08-23 03:17:21.422+00	2025-08-23 11:08:32.509+00	f	f	2025-08-23 11:08:32.509+00	0	f
2064	77	86009570	sbd 8-horoo isb san  	3	39000.00	48r bair 6davhar 17toot	73	f	0	4mJeDCGqbh	2025-08-23 03:53:19.215+00	2025-08-25 08:10:17.684+00	f	f	2025-08-25 08:10:17.684+00	0	f
2077	77	99800085	bgd 17khoroo modni 2	3	19000.00	36a bair 2orts 43toot	9	f	0	cO5kfktBVf	2025-08-23 04:05:21.27+00	2025-08-25 09:07:55.092+00	f	f	2025-08-25 09:07:55.092+00	utasaa awaagvi msj uldeesen	f
2066	77	98112827	bayn hoshuu shin etes	2	18000.00	91881357	9	f	0	aJfTuCs4Ec	2025-08-23 03:54:51.859+00	2025-08-26 05:10:35.085+00	f	f	\N	holbogdoh bolomjgvi	f
2039	60	99928134	ХУД, 11-р хороо, kingtower 122 байр 240 тоот	3	85000.00	модон хатаагч	78	f	0	FkONmdxL5s	2025-08-23 03:11:49.427+00	2025-08-23 08:09:55.591+00	f	f	2025-08-23 08:09:55.59+00	0	f
2046	77	88618873	Дарь их 127р сургуулийн хажууд	1	18000.00	4р гудамж 1640тоот	\N	f	0	QhUjOc2nbu	2025-08-23 03:24:56.204+00	2025-08-23 03:46:25.106+00	f	f	\N	0	t
2075	77	86012300	hangai hothon 502r bairni urd tald	3	18000.00	mc international 4hurtel bain	9	f	0	MBWUaTv8jh	2025-08-23 04:03:13.756+00	2025-08-23 12:59:47.35+00	f	f	2025-08-23 12:59:47.35+00	0	f
2337	26	86067374	misheel expo baruuhan tald misheel tsogtsolbor hothon 91b bair ochood zalgarai yagaan tsag	2	50000.00	yagaan tsag	78	f	0	3xS2pOpliK	2025-08-25 16:46:46.106+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2382	71	91350014	Saruul tenger2 104r bair 11 toot	2	0.00	.	66	f	0	6hwZCwCC4c	2025-08-26 05:53:17.197+00	2025-08-26 06:05:46.125+00	f	f	\N	0	f
2050	77	72706287	СХД 27 хороо орчлон хороолол ийн хажууд 66ийн 405тоот	3	19000.00	66р гудамж 405тоот 88898931	50	f	0	wx2vneV3HC	2025-08-23 03:31:19.727+00	2025-08-24 12:32:33.942+00	f	f	2025-08-24 12:32:33.942+00	0	f
2086	10	89063247	hud duureg 21-horoo buyntuhaa 2 horoolol 1039 bair 6-32 toot	3	0.00	onooodor	78	f	0	RyylRbV429	2025-08-23 04:22:40.835+00	2025-08-23 14:45:35.391+00	t	f	2025-08-23 14:45:35.391+00	0	f
2057	77	94633930	enhbayrin zamaar ogsood bayngol delguur deer avna	3	22000.00	99797139	50	f	0	DY15OGE2iR	2025-08-23 03:39:22.291+00	2025-08-23 15:24:23.975+00	f	f	2025-08-23 15:24:23.975+00	0	f
2067	77	99928512	2tsag hurtel harhorin zah	3	19000.00	B1 90noimorin languu	50	f	0	6uVWny9Yfv	2025-08-23 03:56:00.228+00	2025-08-24 03:30:51.705+00	f	f	2025-08-24 03:30:51.705+00	0	f
2065	77	95080990	offitser town	3	20000.00	19v bair 707 toot	9	f	0	gfXsOCnHqv	2025-08-23 03:54:04.885+00	2025-08-23 16:00:02.734+00	f	f	2025-08-23 16:00:02.733+00	0	f
2071	77	99067409	6davhar 22toot	3	18000.00	Хан-уул дүүрэг 3 хороо Алтай хотхоны гэрлийн дохиотой уулзвараас говийн зам 100м-т Хаан банктай байр	78	f	0	mnx3kPAJlY	2025-08-23 03:59:59.356+00	2025-08-23 09:52:49.356+00	f	f	2025-08-23 09:52:49.356+00	0	f
2076	77	80125844	Шархадны эцэс дээр	3	20000.00	ирээд ярихад болноо 89683930	9	f	0	mQXnEaCXjN	2025-08-23 04:04:39.043+00	2025-08-23 10:52:19.003+00	f	f	2025-08-23 10:52:19.002+00	0	f
2074	77	99525600	hunnu 22plus	3	18000.00	209r bair 1 orts 9davhar 902toot	78	f	0	Edc8ip4pH8	2025-08-23 04:02:18.075+00	2025-08-23 08:24:37.707+00	f	f	2025-08-23 08:24:37.707+00	0	f
2021	20	80801509	Хан уул хантүшээ хотхон 101р байр 6давхар 4тоот	3	1.00	төлбөр авахгүй	78	f	0	tqeVqJv0f3	2025-08-23 00:18:19.454+00	2025-08-23 08:53:39.464+00	f	f	2025-08-23 08:53:39.464+00	0	f
1996	6	99492225	bzd 26-horoo taimtaur hothon 217 bair 2orts 5-92toot	3	0.00	onoodor	9	f	0	A7us3qBoFn	2025-08-22 05:37:09.63+00	2025-08-23 09:27:29.982+00	t	f	2025-08-23 09:27:29.982+00	unand tawh	f
2051	77	86555461	цайз 16 автобусны буудал дээр ирээд залга	3	18000.00	86655461	9	f	0	5U4c0Rj0Cc	2025-08-23 03:32:48.137+00	2025-08-23 10:57:53.714+00	f	f	2025-08-23 10:57:53.714+00	0	f
2058	77	89110639	BGD 29horoo harharon zahiin zuun tald	3	18000.00	47r bair 1r orts 9davhar 54toot	50	f	0	DIhVUhb8WP	2025-08-23 03:40:23.359+00	2025-08-24 03:16:37.114+00	f	f	2025-08-24 03:16:37.114+00	0	f
2068	77	90164348	misheel expo C35povilon	3	18000.00	10-19tsagiin hoorond	78	f	0	vtUvGB0cyZ	2025-08-23 03:56:54.236+00	2025-08-23 09:41:58.217+00	f	f	2025-08-23 09:41:58.217+00	0	f
2024	20	90902090	ХУД 20р хороо мишээл экспогийн зүүн талын гэрлэн дохиогоор эргээд 112/4 байр 11давхар 66 тоот	3	1.00	төлбөр авахгүй	78	f	0	lewzPv4231	2025-08-23 00:19:36.34+00	2025-08-23 09:42:09.382+00	f	f	2025-08-23 09:42:09.382+00	0	f
2052	77	88103373	зүүн 4 зам жоби 72	3	18000.00	ард талд 43р байр 2орц 5давхар 68тоот	9	f	0	3xatH0EXQW	2025-08-23 03:33:45.261+00	2025-08-23 13:57:09.672+00	f	f	2025-08-23 13:57:09.672+00	0	f
2081	77	99964015	bayn hoshuuni baruun salaa	3	20000.00	4r delguur deer 93110233	50	f	0	u7mKutHRqx	2025-08-23 04:08:24.424+00	2025-08-24 12:56:14.765+00	f	f	2025-08-24 12:56:14.765+00	0	f
2088	10	88702134	BGD 8r horoo 4r horoolol 11r bair 1r orts 33 toot	3	0.00	onoodor	50	f	0	n7d1I2zEb5	2025-08-23 04:55:11.673+00	2025-08-23 14:23:31.837+00	t	f	2025-08-23 14:23:31.837+00	0	f
2022	20	86041378	Хануул дүүрэг 25р хороо 4 бэрх хотхон 424-31 тоот	3	1.00	төлбөр авахгүй	78	f	0	tqGMk0z5uC	2025-08-23 00:18:46.522+00	2025-08-23 14:45:19.086+00	f	f	2025-08-23 14:45:19.086+00	0	f
2044	60	99739615	Хүннү вилла 1403 байр очиод залга	3	170000.00	Модон хатаагч 2 ширхэг Өнөөдөртөө авах.	78	f	0	bAav8Uc3wZ	2025-08-23 03:22:14.714+00	2025-08-23 11:02:57.315+00	f	f	2025-08-23 11:02:57.315+00	0	f
2087	10	90901299	olymp hothon 426bair 2r orts 10 davhar 107 toot	3	0.00	unuudur	78	f	0	qf2IdozSjQ	2025-08-23 04:53:25.443+00	2025-08-23 06:31:26.584+00	t	f	2025-08-23 06:31:26.584+00	0	f
2073	77	99097589	Crystal town	3	19000.00	803r bair 1608toot	78	f	0	zYThpaqyNb	2025-08-23 04:01:25.01+00	2025-08-23 06:48:55.832+00	f	f	2025-08-23 06:48:55.831+00	0	f
2054	77	99044630	bayn mongol horoolol	3	20000.00	408r bair 2orts 5 davhar 90toot	78	f	0	n0SZQgHIs6	2025-08-23 03:35:04.443+00	2025-08-23 07:06:18.258+00	f	f	2025-08-23 07:06:18.258+00	0	f
2056	77	85529567	uvurhangai arvai heer	3	0.00	tolbor batalgaajsan	50	f	0	3ehCoCbGPa	2025-08-23 03:38:02.985+00	2025-08-23 11:15:53.232+00	f	f	2025-08-23 11:15:53.232+00	0	f
2070	77	99238364	1horoolol 1r bair	3	18000.00	10orts 5davhar 344toot	50	f	0	MVQbtC5drR	2025-08-23 03:59:01.295+00	2025-08-23 11:17:37.744+00	f	f	2025-08-23 11:17:37.744+00	0	f
2055	77	80704149	Yarmag orgil hudaldaanii tov	3	19000.00	23tsag hurtel ajillan	78	f	0	gUuKmBfjCn	2025-08-23 03:36:27.745+00	2025-08-23 14:45:27.54+00	f	f	2025-08-23 14:45:27.54+00	0	f
2103	77	88552582 	 Өмнөговь аймаг 	3	0.00	Даланзадгад	50	f	0	FoqjaJ9xGu	2025-08-23 12:46:31.545+00	2025-08-25 08:30:48.227+00	t	t	2025-08-25 08:30:48.227+00	0	f
2095	60	86110048	БГД, Гранд плазагийн урд 81 дүгээр байр	2	85000.00	модон хатаагч очихдоо залгаж асууж очих төлбөр хийгдээгүй	9	f	0	7DrJOOdyXY	2025-08-23 06:25:08.645+00	2025-08-26 06:32:21.323+00	f	f	\N	dugaar holbogdoh bolomjgvi	f
2010	60	88009660	Американ дэнжрүү явахад байдаг Номин худалдааны төвийн баруун урд зам дагуу Эрхэмхүслэн шилэн 4-р байр 2 орц 3 давхарт 78 тоот	5	85000.00	Модон хатаагч	66	f	0	A551jyMkeR	2025-08-22 13:48:46.035+00	2025-08-25 10:11:14.101+00	f	f	\N	utsa avaguu	f
2089	60	88015287	Зүүн 4 зам Баянцээлийн 23 дугаар байр	2	85000.00	Модон хатаагч төлбөр хийгдээгүй	66	f	0	7MObNiLeEY	2025-08-23 05:37:22.365+00	2025-08-26 04:35:26.807+00	f	f	\N	utas holbogdohgui	f
2338	26	86051414	Худ 21р хороо шүрт хотхон 811-2р орц 5-99 тоот har tsag	2	50000.00	har tsag	78	f	0	aQvoLu37Jt	2025-08-25 16:47:27.461+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2036	75	89848799	govialtai aimag esonbulag unaand hiih avtobusand	3	0.00	coach kod:55398 tom ulaan tsvnh-1sh	50	f	0	855ZFRKgIL	2025-08-23 02:45:37.008+00	2025-08-23 11:51:48.683+00	f	f	2025-08-23 11:51:48.683+00	0	f
2063	77	99159947	dari ih 127r surguuli	5	25000.00	95281471	73	f	0	JdSwhy8zcz	2025-08-23 03:51:43.547+00	2025-08-26 04:09:02.523+00	f	f	\N	Utsaa avaagui	f
2032	75	88994630	21 sodon horoolold	3	0.00	coach tsvnh kod:8885  har ungu -1sh	3	f	0	Y4chDxyq3f	2025-08-23 02:40:16.029+00	2025-08-24 10:21:36.054+00	f	f	2025-08-24 10:21:36.054+00		f
2059	77	80202125	jukowin 9r bair	5	19000.00	jijuur deer avnaa	9	f	0	nQbN1DzUFD	2025-08-23 03:41:52.118+00	2025-08-26 06:38:28.869+00	f	f	\N	Дуудлага хүлээн авагүй	f
2061	77	86096649	naturin ger bordoon tsetserltei bair	3	20000.00	68r bair 21toot	9	f	0	S1AiYydrAB	2025-08-23 03:43:42.868+00	2025-08-23 09:37:41.636+00	f	f	2025-08-23 09:37:41.635+00	0	f
2060	77	99190493	natur hudaldaani tov	3	19000.00	chirs karaoke deer avna	9	f	0	9Z2wEXObUQ	2025-08-23 03:42:49.382+00	2025-08-23 09:56:40.331+00	f	f	2025-08-23 09:56:40.331+00	0	f
2106	77	88013082 	1horoolol eren horoolol 	3	20000.00	53/9r bair 66toot 	50	f	0	4gf6hGc7XL	2025-08-23 12:50:20.862+00	2025-08-24 10:59:36.156+00	f	f	2025-08-24 10:59:36.156+00	0	f
2031	19	80158732	Huwsgul hatgal janhai 80158732	5	86000.00	төлбөр танайх авна	50	f	0	AOYFunbzVa	2025-08-23 02:37:46.395+00	2025-08-23 11:07:23.17+00	f	f	\N	0	f
2062	77	88225341	dari ih huuchin etses	5	20000.00	94020924	73	f	0	fXLUHsHtVd	2025-08-23 03:50:52.055+00	2025-08-23 12:12:46.349+00	f	f	\N	0	f
2023	20	99915083	СХД Залуус хороолол 48б байр 3р орц 473 тоот	3	1.00	талбөр авахгүй	3	f	0	B7lk8KNpD6	2025-08-23 00:19:12.792+00	2025-08-24 08:16:39.17+00	f	f	2025-08-24 08:16:39.17+00	0	f
2069	77	80210755	monel ulaan toosgon emiin sangiin haraldaa	3	19000.00	15iin 35toot	73	f	0	eHtIXlWhHP	2025-08-23 03:58:12.62+00	2025-08-23 12:40:56.398+00	f	f	2025-08-23 12:40:56.398+00	0	f
2383	71	80920022	selenge	2	0.00	.	9	f	0	HABXrjQLxn	2025-08-26 05:53:45.664+00	2025-08-26 06:07:36.886+00	f	f	\N	0	f
2079	77	80477404	jukowin suvdan sondor	3	22000.00	71b bair 1orts 13davhar 1301 toot	73	f	0	b95ToCzDgl	2025-08-23 04:06:43.349+00	2025-08-23 13:38:00.827+00	f	f	2025-08-23 13:38:00.826+00	0	f
2091	71	 99570976	BGD 34r horoo 21r bair70 toot	3	0.00	unuudur	50	f	0	VagDl8asRu	2025-08-23 06:00:30.424+00	2025-08-23 15:37:58.323+00	t	f	2025-08-23 15:37:58.323+00	0	f
2105	77	72706287 	 Схд 27 хороо орчлон хороолол ийн хажууд 66 ийн 405 тоот	3	19000.00	88898931 	50	f	0	X5avi1WmQf	2025-08-23 12:48:07.967+00	2025-08-24 12:32:56.315+00	f	f	2025-08-24 12:32:56.314+00	0	f
2034	75	96050164	схд 6р хороо Дүүхээ 2	5	0.00	coach kod:8885 Tsagaan ungu-1sh	3	f	0	8e5XFmQCHW	2025-08-23 02:42:57.433+00	2025-08-24 12:01:44.012+00	f	f	\N	0	f
2098	21	89042398	1 horoolol tsambagaraw, nomingiin urd shar 46/1 bair 3dav 10toot	3	0.00	Oyun-Erdene-d	50	f	0	0KsULXcDFo	2025-08-23 12:32:13.015+00	2025-08-24 09:49:40.004+00	t	f	2025-08-24 09:49:40.004+00	0	f
2111	77	95207319 	Өвөрхангай аймгийн 	3	0.00	хархорин сум 	3	f	0	2yf2dFt7WX	2025-08-23 12:56:55.789+00	2025-08-24 12:01:57.481+00	t	t	2025-08-24 12:01:57.481+00	0	f
2104	77	85436164 	happy residense 881bair 	5	20000.00	2r orts 3dawhr 305 toot	78	f	0	d6i1ZupKNH	2025-08-23 12:47:13.852+00	2025-08-24 15:10:09.482+00	f	f	\N	0	f
2096	19	94496826	Дарханы  автобус, унаанд тавих	5	86000.00	төлбөр танайх авна	3	f	0	NO4DyIaTeW	2025-08-23 11:03:56.741+00	2025-08-25 03:49:22.513+00	f	f	\N	darhanii unaand tavih gd zalgasan tootsoogoo hiihgvi oroi dahij ochood zalgasan utsaa avaagvi	f
2100	21	88066007	Jukoviin hushuunii zuun hoino 42 bair 1 orts. Tarvaliin hothonii zamiin urd 7dav yagaan bair	3	0.00	Zolboo-d. Kod; 4551#	9	f	0	Mmmh7Y6Lna	2025-08-23 12:34:42.422+00	2025-08-24 13:48:08.534+00	t	f	2025-08-24 13:48:08.534+00	0	f
2097	26	99132681	100 ail 16 dugaar surguuliin hajuud cu tei 23 bair b1 dawhar 3 toot	3	50000.00	Yagaan tsag	78	f	0	VBXBRdxrTp	2025-08-23 11:57:20.431+00	2025-08-24 09:57:24.326+00	f	f	2025-08-24 09:57:24.326+00	0	f
2025	20	99329680	99329680 orbit hvns treid	3	1.00	төлбөр авахгүй	3	f	0	oJWBIk77tc	2025-08-23 00:20:27.759+00	2025-08-24 10:06:46.483+00	f	f	2025-08-24 10:06:46.483+00	0	f
2072	77	99084292	12.00- 15.00 цагийн хооронд Бөхийн өргөөний баруун талд	3	18000.00	Эрхэт оффис төвийн 10н давхарт 1002 тоотод байна	78	f	0	WfnIDygNaX	2025-08-23 04:00:44.901+00	2025-08-24 07:21:55.017+00	f	f	2025-08-24 07:21:55.017+00	0	f
2101	21	99873799	BGD 27 horoo 29 bair Zoos delguurt uldeeh.	3	0.00	Oogii Oogii-d. delguurt uldeegeed heleh, utas holbigdohgui bwal SMS bicheed uldeeh	50	f	0	OuyvggjuZc	2025-08-23 12:36:12.911+00	2025-08-24 07:51:19.364+00	t	f	2025-08-24 07:51:19.364+00	0	f
2099	21	96880980	5shar 13A bair 34	3	0.00	Batsuh Ganaa-d	3	f	0	Lxf2eyAAm4	2025-08-23 12:32:56.215+00	2025-08-24 08:04:21.74+00	t	f	2025-08-24 08:04:21.74+00	0	f
2083	77	88207894	Схд дүүрэг Алтан мед нурууны эмнэлэг	3	20000.00	ajildag hun	50	f	0	nOn8DGUPHn	2025-08-23 04:09:37.26+00	2025-08-24 12:30:07.826+00	f	f	2025-08-24 12:30:07.826+00	0	f
2339	26	88183429	yaarmagiin 1 r buudal sansar hudaldanii ariin 909/1 bair 120 toot tsenher tsag	2	50000.00	tsenher tsag	78	f	0	JCR7bcHsE5	2025-08-25 16:48:07.601+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2150	59	88173959	БГД 8-хороо 27/1 14 давхар 70тоот	3	0.00	0	9	f	0	XxhJ7gyxjd	2025-08-23 15:59:28.209+00	2025-08-25 08:41:53.928+00	f	f	2025-08-25 08:41:53.927+00	0	f
2159	77	99166637 	 dahilt 3r buudal buudai toviin uschind 	3	19000.00	7tsag hurtel	50	f	0	g9U7EMDWHb	2025-08-24 02:47:03.792+00	2025-08-25 12:11:11.148+00	f	f	2025-08-25 12:11:11.148+00	0	f
2080	77	98118454	bzd sengur gorhi hothon	3	18000.00	53A bair 1orts 1toot	73	f	0	m7jYbjAKRx	2025-08-23 04:07:34.394+00	2025-08-23 13:12:39.097+00	f	f	2025-08-23 13:12:39.096+00	0	f
1958	59	89861629	ЧХД 6 хороо 62а	3	0.00	0	9	f	0	p0a7ppRCNQ	2025-08-21 17:18:01.724+00	2025-08-23 13:16:14.972+00	f	f	2025-08-23 13:16:14.972+00		f
2139	59	86501006	Дэнжийн1000 Зам гүүрийн авто базз	3	0.00	0	50	f	0	TOQnuEsnTL	2025-08-23 14:28:04.29+00	2025-08-25 14:16:10.98+00	f	f	2025-08-25 14:16:10.98+00	0	f
2152	60	89002729	Монос 25 эмийн сангийн замын эсрэг талын байр   K104 байрны 3 тоот	2	85000.00	модон хатаагч БГД 6 хороо чингүнжавын гудамж	73	f	0	cSbtb6NaRT	2025-08-23 16:37:33.531+00	2025-08-26 05:05:47.598+00	f	f	\N	margash avna odogor gertee bhguu bga	f
2384	71	90144447	zamiin uud	2	0.00	.	9	f	0	WvmAS0Iv8E	2025-08-26 05:54:08.614+00	2025-08-26 06:06:36.872+00	f	f	\N	0	f
2131	77	80118085 	 darhan huree tehnikin zah 	2	22000.00	mongol huleg deer avna	66	f	0	Nw1C5Sohtt	2025-08-23 13:12:40.364+00	2025-08-26 04:35:26.807+00	f	f	\N	hoyordoh udur avna	f
2040	60	99103959	10 р хороолол гермес худалдааны төвийн баруун хоыно байрлалтай мая таун хотхон 113 р байр 1 р орц 3 давхарт 17 тоот	3	240000.00	3 ширхэг модон хатаагч төлбөр хийгдээгүф	50	f	0	R7yxlqSRzJ	2025-08-23 03:13:46.747+00	2025-08-24 01:50:30.29+00	f	f	2025-08-24 01:50:30.289+00	0	f
2122	77	86021000 	 BZD 43horoo narni zamin minii delguurin hajuu talin nomno hothon	3	22000.00	 47r bair 5davhar 27toot 	9	f	0	Zo9Tqryy1E	2025-08-23 13:04:33.262+00	2025-08-24 12:04:15.419+00	f	f	2025-08-24 12:04:15.419+00	0	f
2153	59	88263682	Chuluun ovooni nomingiin hajuud ornokh horoolol 9Б байр 6н давхар 607тоот орцны код#0852	3	0.00	0	9	f	0	86VYbaWmSe	2025-08-23 16:51:05.439+00	2025-08-24 13:47:30.736+00	f	f	2025-08-24 13:47:30.735+00	0	f
2126	77	88079887 	arhorin giin sholondo baruun tald hoh chono uschin	3	36000.00	88597979 	50	f	0	VB78ahR2B5	2025-08-23 13:07:11.82+00	2025-08-24 10:18:10.188+00	f	f	2025-08-24 10:18:10.188+00	0	f
2121	77	86303570 	buynt uhaa 2 togs orchin 2 hothon 	3	20000.00	1218r bair 1orts 7davhar 37toot 	78	f	0	C0CwvXWA9c	2025-08-23 13:03:57.989+00	2025-08-24 14:33:06.581+00	f	f	2025-08-24 14:33:06.581+00	0	f
2120	77	90006590 	13horoolol 3ondorin urd talin	3	20000.00	5r bair 2orts 5davhar 55toot 	9	f	0	6hoLH5MWIn	2025-08-23 13:03:18.74+00	2025-08-24 11:47:55.748+00	f	f	2025-08-24 11:47:55.748+00	0	f
2130	77	80029364 	SHD 39r horoo 61iin 1toot 34iin 284r tsetserlgiin deeshee yvad sod hangai delguur deer	3	23000.00	90271247 	50	f	0	lfO4baI1VV	2025-08-23 13:10:39.928+00	2025-08-24 14:38:59.822+00	f	f	2025-08-24 14:38:59.822+00	0	f
2135	59	86107474	чулуу овооны номингийн хажуу талын өрнөх хороолол	3	35000.00	0	9	f	0	WYtu3YucPN	2025-08-23 13:49:32.7+00	2025-08-24 13:47:40.669+00	f	f	2025-08-24 13:47:40.669+00	0	f
2123	77	80447968 	songino hairhan dvvreg sodon horolol	3	20000.00	70b bair 11 dawhar 90 toot	3	f	0	HNjQl7e7rl	2025-08-23 13:05:02.728+00	2025-08-24 10:23:03.949+00	f	f	2025-08-24 10:23:03.949+00	0	f
2132	77	99954949 	SHD har horinii ard tald	3	22000.00	26r bair 3 orts  9davhar 212 toot	50	f	0	KAiPasM7WK	2025-08-23 13:13:30.062+00	2025-08-24 10:31:21+00	f	f	2025-08-24 10:31:21+00	0	f
2136	59	96069599	хорооллын эцэс говь complex эсрэг талд талст авто угаалга 	3	0.00	0	50	f	0	KwDTDgIs4c	2025-08-23 14:10:52.012+00	2025-08-24 09:00:59.993+00	f	f	2025-08-24 09:00:59.993+00	0	f
2116	77	95559412 	darhan	3	0.00	tolbor batalgaajsan 	3	f	0	3QpeyArswy	2025-08-23 13:00:40.859+00	2025-08-24 11:58:04.575+00	t	t	2025-08-24 11:58:04.575+00	0	f
2118	77	99872078 	21horoolol SHD shin negdsen emlengiin baruun urd	3	20000.00	98r bairni 21 toot	3	f	0	Q0gHcZ9OOl	2025-08-23 13:02:12.562+00	2025-08-24 09:25:03.715+00	f	f	2025-08-24 09:25:03.715+00	0	f
2117	77	99404045 	haniin metirial huuchin davharin buudal deer 	3	18000.00	98113824 	3	f	0	XR5AqkIAqG	2025-08-23 13:01:38.386+00	2025-08-24 09:34:52.691+00	f	f	2025-08-24 09:34:52.691+00	0	f
2133	59	99256632	Баянзүрх 12-р хороо Ботаник центр 7-р байрны 5 давхар 18 тоот	3	6000.00	0	9	f	0	vDyJbRlSAj	2025-08-23 13:46:39.802+00	2025-08-24 09:39:33.501+00	f	f	2025-08-24 09:39:33.5+00	0	f
2119	77	95561885 	SHD duureg 22 horoo dahiltiin jargalant delguur 	5	20000.00	85728895 	3	f	0	6cydE7fIzm	2025-08-23 13:02:45.03+00	2025-08-24 15:01:57.845+00	f	f	\N	baynhoshuunii toirogt ochood nemelt 6k avaad Hvrgej ogno esvel hvrj ireed avchihuu gesen oirhon gazraas avay gd butsaasan	f
2142	59	86590088	Tsaiz 16 shine ger xotxon 55a bair 14 davhar 116 toot	3	0.00	0	9	f	0	Ue84iYUQ0L	2025-08-23 14:45:44.431+00	2025-08-24 10:52:32.105+00	f	f	2025-08-24 10:52:32.105+00	0	f
2127	77	80427778 	100 ailin khaan banktai 12davhar bair	3	20000.00	12davhar 113toot	78	f	0	IwCbUcXHO8	2025-08-23 13:07:51.825+00	2025-08-24 09:57:36.349+00	f	f	2025-08-24 09:57:36.349+00	0	f
2140	59	94768124	андуудаас унаанд тавина хөтөл	3	0.00	эрдэнэт дархан хоёрийн голд 	3	f	0	DQzBXhZdhK	2025-08-23 14:32:25.41+00	2025-08-24 06:25:04.741+00	f	f	2025-08-24 06:25:04.741+00	0	f
2143	59	85361477	өмөнговь гурвантэс	3	0.00	0	3	f	0	vSug41OiWc	2025-08-23 15:15:05.34+00	2025-08-24 07:16:03.497+00	f	f	2025-08-24 07:16:03.497+00	0	f
2161	76	89977353	Схд 29р хороо Драгон төвийн хойно 18р байр 1орц 6-28тоот 89977353	3	50000.00	Ger bvl bagt, Tulbur avah	3	f	0	VTo25GD7MZ	2025-08-24 03:10:41.254+00	2025-08-24 07:49:57.648+00	f	f	2025-08-24 07:49:57.648+00	0	f
2138	59	99737932	Сонгино хайрхан дүүрэг 38-р хороо Аптаун вилла хотхон 53А 1-р орц 1 давхар 3 тоот	3	0.00	0	3	f	0	a0Qts7OXlk	2025-08-23 14:25:44.281+00	2025-08-24 08:09:31.729+00	f	f	2025-08-24 08:09:31.729+00	0	f
2137	59	96069599	хорооллын эцэс говь complex эсрэг талд талст авто угаалга 	3	0.00	0	50	f	0	he7tF6DBwF	2025-08-23 14:10:52.351+00	2025-08-24 09:00:45.837+00	f	f	2025-08-24 09:00:45.836+00	0	f
2163	10	89035511	Хан уул 120мянгат 3р байр 3р орц 31 тоот	3	35000.00	onoodor	78	f	0	SMqjTzHr4m	2025-08-24 03:13:01.196+00	2025-08-24 11:45:07.887+00	f	f	2025-08-24 11:45:07.887+00	0	f
2144	59	89959236	Husliin orgoo hothon 100bair 2-r orts #3399 10dawhar 95 toot 	3	0.00	0	9	f	0	Sml76MWmJy	2025-08-23 15:16:10.805+00	2025-08-24 12:25:50.984+00	f	f	2025-08-24 12:25:50.984+00	0	f
2156	26	99780367	baynzurh duureg shar hadnii emneleg deer 4 tsag hurtel eeljtei baina tsenher tsag	2	50000.00	tsenher tsag 4 hurtel ajil dre baina gene	66	f	0	aFIS1jzDn6	2025-08-24 01:44:44.375+00	2025-08-26 04:40:43.104+00	f	f	\N	margaash awna	f
2179	71	88600628	Sansar home plaza 97r surguuli	3	0.00	.	9	f	0	iTguoYuhyA	2025-08-24 04:20:12.786+00	2025-08-24 11:33:05.139+00	f	f	2025-08-24 11:33:05.139+00	0	f
2109	77	88765866 	bzd 32horoo monel baruun altan olgii huchten gd delguurin hajud 	3	25000.00	34iin 564 	9	f	0	KzAnSbeI2n	2025-08-23 12:55:20.853+00	2025-08-24 11:09:46.938+00	f	f	2025-08-24 11:09:46.938+00	0	f
2125	77	89858092 	 buynt uhaa 1	3	19000.00	711r bair 7davhar 47toot 	78	f	0	HHvyIKc2X2	2025-08-23 13:06:14.104+00	2025-08-24 13:42:33.342+00	f	f	2025-08-24 13:42:33.342+00	0	f
2154	26	99003826	Han uul duureg ub subilaliin hajuud saruul shiltgeen 98/1/1 15davhar 1503 toot цэнхэр цаг	3	50000.00	Tsenher tsag	78	f	0	oOOuYqNJH5	2025-08-24 01:27:44.344+00	2025-08-24 12:45:00.535+00	f	f	2025-08-24 12:45:00.535+00	0	f
2110	77	99032281 	Жуков Поларинс хотхон 	3	20000.00	59Б байр 1.орц 1602 тоот	9	f	0	cEs0lW5rXl	2025-08-23 12:55:55.236+00	2025-08-24 13:47:52.467+00	f	f	2025-08-24 13:47:52.467+00	0	f
1814	61	99018657	13р хороолол channel center 402 тоот	3	29900.00	тооцоо хийгээгүй	73	f	0	9xaQM5EpPP	2025-08-17 01:52:49.716+00	2025-08-25 10:42:21.967+00	f	f	2025-08-25 10:42:21.967+00	utsa avaguu	f
2124	77	99119822 	HUD emartin iin baruun tald alpha zone	3	19000.00	 64/4r bair 20 davhar 76toot	78	f	0	Repdv4ywtj	2025-08-23 13:05:41.708+00	2025-08-24 11:55:57.822+00	f	f	2025-08-24 11:55:57.822+00	0	f
2177	71	88600628	Sansar home plaza 97r surguuli	1	0.00	.	\N	f	0	nLfYoIVjxB	2025-08-24 04:19:52.765+00	2025-08-24 04:30:39.801+00	f	f	\N	0	t
2178	71	88600628	Sansar home plaza 97r surguuli	1	0.00	.	\N	f	0	83sW56WUyP	2025-08-24 04:19:55.079+00	2025-08-24 04:30:39.801+00	f	f	\N	0	t
2165	10	80298841	buhiin urguu 59-8toot 2 davhart kod 86 21r surguuliin chanh zuun tald 	3	0.00	tootsoo hiisen	78	f	0	Z86Vz4c6H1	2025-08-24 03:22:50.597+00	2025-08-24 07:22:26.394+00	t	f	2025-08-24 07:22:26.393+00	0	f
2026	59	86113131	БГД 4 р хороо ханбүргэдэйтэйн зүүн талын 10 р байр 5н тоот	3	35000.00	0	50	f	0	SsCsJ9IgTk	2025-08-23 01:39:07.873+00	2025-08-24 06:08:09.683+00	f	f	2025-08-24 06:08:09.683+00	utasaa awaagvi 7 8 zalgasan msj bichsn	f
2164	76	98115036	сбд 9хороо алтайн гудамж хоймор оффисийн урд mgl радиогийн чанх урд саарал 32р байр 7давхар 32тоот орцны код 98115036#	3	96000.00	Ger bvl+Tsetserleg bagts	78	f	0	SvE7bmmeGj	2025-08-24 03:15:35.719+00	2025-08-24 09:57:06.557+00	f	f	2025-08-24 09:57:06.556+00	0	f
2166	10	80979770	BGD altai hothon 27r bair 1r orts 8 davhar 48 toot	3	0.00	.	78	f	0	mF4K8CpFPE	2025-08-24 03:23:43.784+00	2025-08-24 10:38:06.045+00	t	f	2025-08-24 10:38:06.044+00	0	f
2167	10	99734001	1r horoolol erind harhorinii zuun tal	3	0.00	.	50	f	0	wLbCPl7X10	2025-08-24 03:24:38.148+00	2025-08-24 11:14:53.966+00	t	f	2025-08-24 11:14:53.966+00	0	f
2170	6	86994059	1odor river garden 	3	0.00	18tsagaas omno awah	9	f	0	VJGPPfJPzN	2025-08-24 03:52:50.247+00	2025-08-25 15:12:02.92+00	t	f	2025-08-25 15:12:02.919+00	ajliin udur awna gsen	f
2171	6	90910011 99557200	jukaw suvdan sondor hothon 74a 3-11toot	3	0.00	onoodor	9	f	0	c60hJQtC67	2025-08-24 03:53:55.738+00	2025-08-24 13:47:02.634+00	t	f	2025-08-24 13:47:02.634+00	0	f
2180	71	91777711	Uvs	3	0.00	.	3	f	0	4Iep4KEvgF	2025-08-24 04:20:20.968+00	2025-08-24 08:51:52.208+00	f	f	2025-08-24 08:51:52.208+00	0	f
2148	59	99018850	120 myngat Tsengeldeh hothon 210 bair 1802 toot. Hashaa/orts kod 1802	3	0.00	0	78	f	0	frzzWZhlY0	2025-08-23 15:46:35.672+00	2025-08-24 11:34:01.141+00	f	f	2025-08-24 11:34:01.141+00	0	f
2186	71	80030196	Orbit tsergiin hothon	3	0.00	85585988	3	f	0	Z2X1th2wLi	2025-08-24 04:23:36.378+00	2025-08-24 08:58:01.423+00	f	f	2025-08-24 08:58:01.423+00	0	f
2340	26	99010797	Хан уул емарт вегасити хотхон 403 байр 901 тоот кодгүй цэнхэр цаг	2	50000.00	tsenher	78	f	0	EJJENq9c9C	2025-08-25 16:48:57.472+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2174	71	88776216	moskva horoolol baruun MT klonk ariin 143 2orts 148 toot	3	0.00	kod 140	3	f	0	5M4WAoQ0fE	2025-08-24 04:17:40.139+00	2025-08-24 07:07:45.936+00	f	f	2025-08-24 07:07:45.936+00	0	f
2168	77	86115460 	moscow horoolol	3	19000.00	 141/1r bair 1iin 44toot 	3	f	0	ouFlvI4P0R	2025-08-24 03:24:39.631+00	2025-08-24 07:09:29.442+00	f	f	2025-08-24 07:09:29.442+00	0	f
2129	77	98989607 	belhin 71r surguuli	3	0.00	98170888 	73	f	0	cixFHT5n2L	2025-08-23 13:09:05.77+00	2025-08-25 12:32:48.556+00	t	t	2025-08-25 12:32:48.555+00	0	f
2162	76	99791847	120-ийн зүчи зочид буудлын баруун талд tagnuuliin 25r bair, 1r orts 11-40 toot nomergvi haalga 0125# ortsnii kod	3	60000.00	Ger bvl bagts+32tai tsaas	78	f	0	DNVfP3O6tf	2025-08-24 03:12:59.863+00	2025-08-24 11:35:00.28+00	f	f	2025-08-24 11:35:00.28+00	0	f
2053	77	88103373	зүүн 4 зам жоби 72	5	18000.00	ард талд 43р байр 2орц 5давхар 68тоот	73	f	0	8ciCUTkE9a	2025-08-23 03:33:45.462+00	2025-08-26 04:07:13.781+00	f	f	\N	baraa avchihsn	f
2169	26	94974027	bzd 16 horoolol batlan hamgaalahiin surguuliin baruun 13 bair 4 orts 4 dawhar 53 toot har tsag	3	50000.00	Har tsag	9	f	0	4HShdnHIOR	2025-08-24 03:51:50.452+00	2025-08-24 13:47:18.654+00	f	f	2025-08-24 13:47:18.654+00	0	f
2160	60	91116903	ХУД 22-р хороо 48-р байр 20А тоот	3	85000.00	modon hataagch tulbur hiigdeegui	78	f	0	WpnoXcXqlZ	2025-08-24 03:07:22.234+00	2025-08-24 13:12:56.053+00	f	f	2025-08-24 13:12:56.053+00	0	f
2173	71	94727227	yarmagiin orgil mobicom dotor	3	0.00	onoodor	78	f	0	WDfde0Sq62	2025-08-24 04:13:32.398+00	2025-08-24 13:28:23.529+00	t	f	2025-08-24 13:28:23.529+00	0	f
2085	77	99987370	shd 8horoo byanhoshuu 112r ireed zalga	3	18000.00	nuurin 5iin 5b 88042337	50	f	0	EDEXcXL8Ez	2025-08-23 04:12:02.447+00	2025-08-24 13:29:55.871+00	f	f	2025-08-24 13:29:55.871+00		f
2155	26	80027847	hanuul duureg niseh buyanuhaa 2 1003 bair 6 dawhar 35 toot	3	50000.00	Har tsag	78	f	0	SuLVZIgozY	2025-08-24 01:33:22.118+00	2025-08-24 14:31:41.225+00	f	f	2025-08-24 14:31:41.225+00	0	f
2102	77	86096649 	 натурыун гэр бордоон цэцэрглэг 	5	20000.00	68р байр 21тоот 	9	f	0	f5Ri3UNING	2025-08-23 12:44:45.173+00	2025-08-25 03:47:07.88+00	f	f	\N	davtan oruulsan	f
2146	59	91304848	Бзд 23-р хороо улиастайн хуучин эцэс	3	0.00	0	66	f	0	XmEIVhO5k6	2025-08-23 15:25:00.747+00	2025-08-25 10:38:14.367+00	f	f	2025-08-25 10:38:14.367+00	0	f
2385	71	91113573	hentii	2	0.00	.	66	f	0	MhBIPU4z8t	2025-08-26 05:54:28.773+00	2025-08-26 06:05:46.125+00	f	f	\N	0	f
2172	10	99110747	zuun 4 zam peprowisin urd saaral bair	2	0.00	onoodor	66	f	0	pQXxViqC1r	2025-08-24 03:56:52.35+00	2025-08-26 06:33:06.432+00	t	f	\N	margash ajil ehelheer avna	f
2191	4	99049836	оросын элчингийн баруун талд Сарнайх салон ажлын цагаар	3	1.00	.	73	f	0	Ih3g0nMu7e	2025-08-24 10:39:35.518+00	2025-08-25 06:48:33.871+00	f	f	2025-08-25 06:48:33.87+00	0	f
2188	71	88776216	moskva horoolol  baruun tal MT klonk ariin 143 2r orts 148 toot	1	0.00	.	\N	f	0	D1AMDzkNxS	2025-08-24 05:06:36.125+00	2025-08-24 05:08:41.894+00	t	f	\N	0	t
2214	77	80229464 	Баянхонгор	3	18000.00	tolbor batalgaajsan 	50	f	0	HFhDInZEE0	2025-08-24 14:02:29.562+00	2025-08-25 08:25:04.19+00	f	f	2025-08-25 08:25:04.19+00	0	f
2175	71	88035190	choir	3	0.00	.	3	f	0	NOLBFyc2n5	2025-08-24 04:18:15.161+00	2025-08-24 06:04:59.141+00	f	f	2025-08-24 06:04:59.141+00	0	f
2128	77	88930211 	dorno govi	3	0.00	zamiin uud	3	f	0	PKBrstXYLt	2025-08-23 13:08:22.808+00	2025-08-24 06:08:10.364+00	t	t	2025-08-24 06:08:10.363+00	0	f
2181	71	99443522	Dundgobi	3	0.00	.	3	f	0	QAlYkp35KX	2025-08-24 04:20:47.071+00	2025-08-24 07:40:52.359+00	f	f	2025-08-24 07:40:52.359+00	0	f
2158	26	88501430	13 horoolol uguumur zahiin 84 toot languu ugumur gsn bichignii yag hajuud tsenher tsag	3	50000.00	Tsenher tsag	9	f	0	3O8k9XQHrx	2025-08-24 02:44:10.294+00	2025-08-24 07:50:38.851+00	f	f	2025-08-24 07:50:38.851+00	0	f
2184	71	96363737	Huvsgul	3	0.00	.	3	f	0	EPsgpQKokj	2025-08-24 04:22:10.972+00	2025-08-24 07:51:55.376+00	f	f	2025-08-24 07:51:55.376+00	0	f
2134	59	99768267	архангай	3	0.00	0	3	f	0	uKfR4Xokny	2025-08-23 13:47:10.086+00	2025-08-24 07:59:24.112+00	f	f	2025-08-24 07:59:24.112+00	0	f
2145	59	90080323	дархан 	3	0.00	0	3	f	0	Uupyn5lowH	2025-08-23 15:19:25.948+00	2025-08-24 08:25:05.661+00	f	f	2025-08-24 08:25:05.661+00	0	f
2108	77	89890960 	enhboldin zamiin etses  	3	18000.00	86853068	50	f	0	s7fUMWLbFt	2025-08-23 12:53:42.578+00	2025-08-24 08:47:40.362+00	f	f	2025-08-24 08:47:40.362+00	0	f
2147	59	86234674	21	3	0.00	0	3	f	0	OImL2QqjH5	2025-08-23 15:40:14.693+00	2025-08-24 10:06:00.442+00	f	f	2025-08-24 10:06:00.442+00	0	f
2215	77	95905051 	CHD 10horoo 39r surguulin baruun talin shinchlel horoolol 	3	19000.00	 802r bair 3 orts 85toot 	50	f	0	ABaG7AGDPn	2025-08-24 14:02:58.924+00	2025-08-25 14:36:01.362+00	f	f	2025-08-25 14:36:01.362+00	0	f
2196	77	95106009 	bohiin urguuni jijuurt 	3	18000.00	naranhuu-d	73	f	0	k2SYO96X4L	2025-08-24 13:48:17.684+00	2025-08-25 07:02:13.342+00	f	f	2025-08-25 07:02:13.342+00	0	f
2204	77	89038858 	 10-р хороолол, хотын төв рүү явдаг буудлын урд талын	5	25000.00	45-р байр, 6-р орц, 38 тоот, 	\N	f	0	goN5AXPIub	2025-08-24 13:56:21.628+00	2025-08-25 03:53:40.997+00	f	f	\N	0	f
2113	77	89295888 	zuragtin huuchin etses iin baruun talin busni buudal 	3	18000.00	tseverhen haluun usni gazar 	50	f	0	KjpwIJVJnR	2025-08-23 12:58:05.347+00	2025-08-24 13:51:31.94+00	f	f	2025-08-24 13:51:31.94+00	0	f
2209	77	80343853 	dorno govi sasinshand	3	0.00	tolbor batalgaajsan 	50	f	0	IYjAbRe8qW	2025-08-24 13:58:52.539+00	2025-08-25 07:18:00.186+00	t	t	2025-08-25 07:18:00.186+00	0	f
2341	26	88867603	kingtower 121 r bair 15 davhrt 159 toot yagaan ongiin tsag	5	50000.00	yagaan	9	f	0	dW4t7ealg8	2025-08-25 16:50:12.99+00	2025-08-26 06:26:25.08+00	f	f	\N	0	f
2197	77	89359911 	 da huree zahin mt klonk ireed zalga 	2	19000.00	86745456 	66	f	0	cynVeIgWJ7	2025-08-24 13:48:41.271+00	2025-08-26 04:35:26.807+00	f	f	\N	margaash avna	f
2203	77	99034548 	 hovsgol	3	0.00	tolbor batalgaajsan 	50	f	0	9RvIMbvEPz	2025-08-24 13:55:27.691+00	2025-08-25 08:18:49.662+00	t	t	2025-08-25 08:18:49.662+00	0	f
2195	77	99365005 	bayn hongor	3	0.00	 tolbor batalgaajsan 	50	f	0	kP62j8qMSZ	2025-08-24 13:47:29.516+00	2025-08-25 08:22:22.526+00	t	t	2025-08-25 08:22:22.526+00	0	f
2193	77	99579088 	sansarin kolonkin hajuud	3	25000.00	403 байр	73	f	0	70fYc5ohJM	2025-08-24 13:46:10.352+00	2025-08-25 08:44:16.108+00	f	f	2025-08-25 08:44:16.107+00	0	f
2211	77	88025318 	misheel expo giin hajuu taliin 	3	19000.00	84r bair 3orts 149toot	78	f	0	UnJo4H3l56	2025-08-24 14:00:21.567+00	2025-08-25 08:57:47.584+00	f	f	2025-08-25 08:57:47.584+00	0	f
2213	77	86225865 	 yarmag orgil sonsoglongiin 1iin 56toot 	2	20000.00	88225864 	78	f	0	5pNi8QDDbM	2025-08-24 14:01:57.501+00	2025-08-26 04:54:06.503+00	f	f	\N	mar awna shuwuud bn	f
2082	77	88015609	modni 2in dund talin zam	2	19000.00	37r bair 1 orts 7 davhar 42toot	73	f	0	Jj0KsxV7vl	2025-08-23 04:09:05.056+00	2025-08-26 05:05:47.598+00	f	f	\N	utsa avaguu	f
2194	77	99955090 	7tsag hurtel  offitseruudin MIU deer ireed zalga	3	19000.00	 tend ajildag hun 	73	f	0	xoRiPlEjfM	2025-08-24 13:46:58.921+00	2025-08-25 10:15:50.172+00	f	f	2025-08-25 10:15:50.172+00	0	f
2189	26	88090942	oficer tenger plazagaas dornod aimgiin towruu har tsag	3	1.00	Har tsag tootsoogui	66	f	0	6mMhTyFIdV	2025-08-24 05:11:51.398+00	2025-08-25 10:46:14.124+00	f	f	2025-08-25 10:46:14.124+00	margash avna	f
2112	77	88985916 	СХД 42р хороо одонт 	2	18000.00	 25р гудамж 80тоот	9	f	0	VyCVgEsrKt	2025-08-23 12:57:27.93+00	2025-08-26 05:10:35.085+00	f	f	\N	utasaa awaagvi msj bichsn	f
2201	77	80072367 	narangiin gol dund buudal 	2	19000.00	91230599 	9	f	0	TLz9vHaFt2	2025-08-24 13:54:12.199+00	2025-08-26 05:10:35.085+00	f	f	\N	utas n holbogdoogvi	f
2206	77	95567633 	bayan ulgii	3	0.00	 tolbor batalgaajsan 	50	f	0	2wpJ4En3GM	2025-08-24 13:57:33.562+00	2025-08-25 10:53:35.243+00	t	t	2025-08-25 10:53:35.243+00	0	f
2199	77	99971285 	arsalntai guurnii hajuud Oyutni orgoo 2 toduur bair	2	20000.00	91363545 	73	f	0	gU10spnVMG	2025-08-24 13:49:36.705+00	2025-08-26 05:05:47.598+00	f	f	\N	Утсаа аваагүй	f
2192	4	99126166	Нисэх спорт цогцолборын автобусны хойно Aero town хотхон 302-р байр ирээд залгах 8-аас хойш байна.	3	1.00	.	78	f	0	qCkuiJsPGP	2025-08-24 12:06:18.425+00	2025-08-25 14:00:12.956+00	f	f	2025-08-25 14:00:12.956+00	0	f
2207	77	88220979 	 niseh garden hill	3	19000.00	 661r bair 15davhar 1501toot 	78	f	0	OlA7vEl0Hx	2025-08-24 13:58:00.01+00	2025-08-25 14:00:19.917+00	f	f	2025-08-25 14:00:19.917+00	0	f
2107	77	88650262 	CHD 21horoo bulgin 19iin 999Я 	3	18000.00	88188277 	50	f	0	3LGGnNBdR9	2025-08-23 12:51:13.725+00	2025-08-25 14:21:08.498+00	f	f	2025-08-25 14:21:08.498+00	0	f
2198	77	88550288 	 5tsagaas hoish altai hothon	5	19000.00	50g bair 50toot 	9	f	0	PQYFFd2esz	2025-08-24 13:49:07.415+00	2025-08-26 04:07:13.781+00	f	f	\N	avhaa bolison	f
2386	71	99090023	erdenet	2	0.00	.	9	f	0	qQU2pP0UmH	2025-08-26 05:54:51.046+00	2025-08-26 06:06:36.872+00	f	f	\N	0	f
2200	77	88715936 	bagshiin deed mubis oyutni 1r bairni	2	20000.00	103toot 	73	f	0	zDigeIGy7Z	2025-08-24 13:50:33.308+00	2025-08-26 05:05:47.598+00	f	f	\N	Утас авсангүй	f
2228	59	99932619	сансарын түнэлийн эсрэг талын pizza hutiin хажууд сансар захын 3 давхар 7 номрийн лангуу	3	35000.00	0	73	f	0	HKpgPDk9PU	2025-08-24 16:11:16.27+00	2025-08-25 08:33:53.773+00	f	f	2025-08-25 08:33:53.773+00	0	f
2239	52	85121404	Dunjin garawiin urd Park east 133 r surguliin zvvn tald	5	0.00	Mash yaaraltai uchir ehnii hvrgeltend ugvvleh ...	\N	f	0	rV1ngDBHfu	2025-08-24 18:33:08.205+00	2025-08-26 04:09:46.375+00	f	f	\N	0	f
2227	59	96620228	ХУД яармагийн шинэ эцэс сонсоглон 21 721 тоот	3	10500.00	0	3	f	0	TeYMQ9ddtU	2025-08-24 16:08:59.644+00	2025-08-25 08:53:32.825+00	f	f	2025-08-25 08:53:32.825+00	0	f
2254	26	99669564	jukowiin hushunii zuun tald ugsuhud baidag 10 bair 2 orts 3 dawhar 24 toot yagaan tsag	3	50000.00	yagaan tsag	73	f	0	1KQJtbMelE	2025-08-25 01:28:42.468+00	2025-08-25 08:56:36.682+00	f	f	2025-08-25 08:56:36.682+00	0	f
2234	26	91929345	19-n APU-s uragshaa Orkhon ih surguuli oroh zamd barigdaj baigaa barilgiin hashaand. Har ongotoi tsag	3	50000.00	Har tsag	78	f	0	EfVoxO9j6Z	2025-08-24 16:28:30.015+00	2025-08-25 08:57:58.532+00	f	f	2025-08-25 08:57:58.532+00	0	f
2235	26	91009030	hanuul duureg Misheel expo M2 tower 16davhar 1607 toot, ажлын цагаар ягаан цаг	3	50000.00	Yagaan tsag ajliin tsagaar	78	f	0	bk5wGAbaEl	2025-08-24 16:29:26.445+00	2025-08-25 08:58:14.297+00	f	f	2025-08-25 08:58:14.297+00	0	f
2222	77	91216685 	Хуучин доргион	3	20000.00	 5 давхарт	50	f	0	H65P8lEHzf	2025-08-24 14:08:16.898+00	2025-08-25 09:22:15.747+00	f	f	2025-08-25 09:22:15.746+00	utasaa awaagvi 4zalgasan msj bichsn	f
2226	6	88060320	BZD ulaanhuaran batlan hamgaalah ih surguuli	3	1.00	hurdan	73	f	0	GEZtwrGbxs	2025-08-24 14:53:35.536+00	2025-08-25 09:45:25.904+00	f	f	2025-08-25 09:45:25.904+00	0	f
2276	71	86085855	Baganuur	3	0.00	.	66	f	0	3v3LPCzf80	2025-08-25 04:10:00.169+00	2025-08-25 10:13:41.792+00	f	f	2025-08-25 10:13:41.792+00	0	f
2258	82	80462404	Чулуун овоо, Номингийн зүүн талд Өрнөх хороолол, 9А байр, 1-р орц, 12 давхар, 1202 тоот	3	69000.00	.	66	f	0	xf1ofatkwu	2025-08-25 02:17:01.401+00	2025-08-25 10:46:58.956+00	f	f	2025-08-25 10:46:58.956+00	0	f
2229	59	80191451	шар хад эрдэнэ толгой баганат өргөө хороолол	3	35000.00	0	66	f	0	7kpNwL2SrH	2025-08-24 16:14:14.452+00	2025-08-25 10:47:43.498+00	f	f	2025-08-25 10:47:43.498+00	0	f
2212	77	95598673 	 bayn olgii 	2	0.00	tolbor batalgaajsan 	66	f	0	kGHqzQMgm9	2025-08-24 14:00:43.653+00	2025-08-26 05:09:50.496+00	f	f	\N	dugaar n ashiglaltand baihgvi	f
2270	81	98206313	gobi altai	3	0.00	.	50	f	0	yOxx8H2Og2	2025-08-25 04:01:01.982+00	2025-08-25 10:56:30.978+00	f	f	2025-08-25 10:56:30.978+00	0	f
2342	26	88867603	kingtower 121 r bair 15 davhrt 159 toot yagaan ongiin tsag	2	50000.00	yagaan	78	f	0	TgaesoD2SC	2025-08-25 16:50:26.78+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2225	6	99055633	BZD tsetserlegt hureelengiin hoino olonlog surguuliin baruun bald sunshine village nothing 333-2-602	3	1.00	odortoo zaaval bagtaaj burger	66	f	0	AYVXx87BFa	2025-08-24 14:52:33.867+00	2025-08-25 13:57:58.326+00	f	f	2025-08-25 13:57:58.326+00	0	f
2232	26	88116338	dunjingarav hudaldaanii tuviin hajuud mongol art gallery 1 davhart  har tsag	3	50000.00	Har tsag ajliim tsagaar	66	f	0	fb0Sa2Ee2Z	2025-08-24 16:25:43.517+00	2025-08-25 12:26:42.452+00	f	f	2025-08-25 12:26:42.451+00	0	f
2223	77	94671517 	tenger plaza gaas herlen cargo 	3	0.00	dornod	66	f	0	kmHgM1uF5a	2025-08-24 14:09:48.18+00	2025-08-25 13:59:29.582+00	t	t	2025-08-25 13:59:29.582+00	0	f
2231	26	99040945	hanuul duureg hunnu22, 214 bair 202 toot tsenher tsag	3	50000.00	Tsenher tsag	9	f	0	woM2r3fW1N	2025-08-24 16:24:17.399+00	2025-08-25 13:30:23.663+00	f	f	2025-08-25 13:30:23.662+00	0	f
2387	71	89935100	viva city 13.2.5 toot	1	0.00	.	\N	f	0	A7ULZe4teN	2025-08-26 05:55:35.482+00	2025-08-26 06:20:37.739+00	f	f	\N	0	t
2230	59	97077077	СХД 6 хороо давхар дэлгүүр гэдэг автобусны буудал өнгөрөөд баруун салаад best авто засвар гэсэн байр	3	35000.00	0	50	f	0	U4l2tHO3F8	2025-08-24 16:18:35.602+00	2025-08-25 13:32:22.084+00	f	f	2025-08-25 13:32:22.084+00	0	f
2238	26	99024042	13 horoolol Натурын зам дагуу MPM барилгын 1 давхарт MPM барилга нь- Далай tower-н замын эсрэг талд ханбүргэдэй дэлгүүртэй барилга/  ажлын цагаар tsenher tsag	2	50000.00	Ajliin tsagaar tsenher tsag	66	f	0	vfvCREOWCK	2025-08-24 16:35:02.131+00	2025-08-26 04:40:43.104+00	f	f	\N	Маргааш авна	f
2233	26	90900801	hanuul duureg king tower 135 bair 1 orts 6 dawhar 113 toot yagaam tsag	3	50000.00	Yagaan tsag	9	f	0	gRsl7dd43I	2025-08-24 16:27:11.379+00	2025-08-25 13:36:55.517+00	f	f	2025-08-25 13:36:55.517+00	utsa avaguu	f
2257	82	99579189	БЗД Тэнгэр Плаза-с Дорнод явах унаанд тавиулах	3	69000.00	Унаанд тавиад захиалагч руу машины, жолоочийн дугаарыг өгөөд төлбөрөө шилжүүлж авна.	66	f	0	UppzqtDWG5	2025-08-25 02:15:01.801+00	2025-08-25 13:56:55.462+00	f	f	2025-08-25 13:56:55.461+00	0	f
2237	26	88899912	цэцэрлэгт хүрээлэн ард сантолас сүмбэр орд урд 714 байр 1 орц 7 дав 703 тоот хар цаг	3	50000.00	Har tsag	66	f	0	8JTQYHBS4g	2025-08-24 16:33:51.246+00	2025-08-25 14:29:16.987+00	f	f	2025-08-25 14:29:16.987+00	0	f
2253	26	96060460	Төмөр зам 20р сургуулийн урд талын 13р байр 2орц 26тоот yagaan tsag	3	50000.00	yagaan tsag	50	f	0	st014NTIkW	2025-08-25 01:15:01.167+00	2025-08-25 15:15:17.043+00	f	f	2025-08-25 15:15:17.042+00	0	f
2224	6	99060138	HUD 3r horoo uildver gudamj 20r bair 11 davhar 51 toot	3	1.00	river stonii yg zuun taliin bair	78	f	0	OWbpqkQkma	2025-08-24 14:50:47.465+00	2025-08-26 07:05:58.094+00	f	f	2025-08-26 07:05:58.093+00	utsa avaguu	f
2251	26	90299610	tow basseinii hajuud baidag etugen ih surguuliin 1 dugeer bair 304 toot 3 dawhart garaad zalgah tsenher tsag	2	50000.00	tsenher ajliin tsagaar	73	f	0	tsY4VudrxI	2025-08-25 00:23:39.418+00	2025-08-26 05:05:47.598+00	f	f	\N	utsa avaguu	f
2236	26	94070746	yarmag hangarid 2 hothon 1554 bair 1 orts 48 toot 2 yagaan tsag	5	100000.00	yagaan tsag 2 sh	78	f	0	xOX59lipcd	2025-08-24 16:32:48.18+00	2025-08-26 05:11:23.214+00	f	f	2025-08-25 14:00:04.743+00	0	f
2256	19	99881616	Чд 4р хороо 41-45тоот	2	86000.00	төлбөр танайх авна	73	f	0	CILXTMBvQe	2025-08-25 01:39:01.893+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
2388	71	89935100	viva city 13.2.5 toot	2	0.00	.	78	f	0	KJP1umZKG1	2025-08-26 05:55:35.82+00	2025-08-26 06:06:54.169+00	f	f	\N	0	f
2278	71	80920022	zamiin uud	3	0.00	.	50	f	0	6sneGcr4IX	2025-08-25 04:11:17.991+00	2025-08-25 07:11:25.462+00	f	f	2025-08-25 07:11:25.462+00	0	f
2262	77	88017415 	bagshiin ordon 4tsagaas omno	5	25000.00	 5davhart manal d ogno 	\N	f	0	69vNIAeD6E	2025-08-25 03:00:26.015+00	2025-08-25 03:53:24.17+00	f	f	\N	0	f
2273	71	80906724	umnu gobi gurvan tes sum hurst tuvuus unaa yawna	3	0.00	.	50	f	0	5KjsYqMuZ6	2025-08-25 04:08:17.372+00	2025-08-25 08:28:42.604+00	f	f	2025-08-25 08:28:42.604+00	0	f
2190	71	88987883	Bayanhongor unaa	3	0.00	dargon	50	f	0	Di7jNusC8z	2025-08-24 06:28:58.737+00	2025-08-25 08:38:46.667+00	f	f	2025-08-25 08:38:46.667+00	0	f
2205	77	99582749 	3tsagaas hoish BZD central mall iin hoid tald huree hothon	5	19000.00	 9r bair 139toot 	73	f	0	mGdyNLCrug	2025-08-24 13:56:58.727+00	2025-08-26 04:10:47.817+00	f	f	\N	Хол явсан авах хүн байхгүй	f
2266	84	91920903	niseh shvrt hothon 811r bair 8-121 toot	3	51000.00	.	78	f	0	acwzywbZMs	2025-08-25 03:52:57.769+00	2025-08-25 14:00:25.689+00	f	f	2025-08-25 14:00:25.689+00	0	f
2279	71	99175425	american denjin urd 9r bair 54 toot	3	0.00	.	73	f	0	wk6NO4i3ql	2025-08-25 04:12:33.945+00	2025-08-25 10:27:40.263+00	f	f	2025-08-25 10:27:40.263+00	0	f
2157	26	99266868	Bayznurh duureg 2 horoo ktms hajuud tsagda hothon 13/5 bair 78 toot kod #5060 4 dawhart tsenehr tsag	3	50000.00	Tsenher tsag	73	f	0	fnbFmhtG2a	2025-08-24 01:54:27.133+00	2025-08-25 09:11:28.74+00	f	f	2025-08-25 09:11:28.74+00	utsa. holbogdoh bolomjguu	f
2202	77	80214441 	narantuul 7hurtel zahin urd talin od barilg	3	18000.00	 dotor baidag maliin emiin san 	66	f	0	ZtidSfkI01	2025-08-24 13:54:43.22+00	2025-08-25 10:44:17.013+00	f	f	2025-08-25 10:44:17.013+00	0	f
2220	77	80185597 	БЗД-ийн эмнэлэгийн ард 	2	25000.00	115  ногоон цэцэрлэг дээр авнаа	66	f	0	er54Y7d5DZ	2025-08-24 14:06:12.881+00	2025-08-26 04:35:26.807+00	f	f	\N	Утас аа аваагүй	f
2240	52	80201009	Niseh Buynt uhaa 1 n ard 616r bair Undur nogoon alag bair	2	6000.00	Gada ird zalgah	78	f	0	8mu06HeK38	2025-08-24 18:33:50.076+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2272	71	86176064	suhbaatar munhhaan sum	3	0.00	93059228	66	f	0	cQ2OUKjVaw	2025-08-25 04:07:18.344+00	2025-08-25 10:14:01.115+00	f	f	2025-08-25 10:14:01.115+00	0	f
2252	76	99525755	Gurvaljin Delgereh hothonii zvvn tal san construction barilgiin 1 davhar technomix	2	78100.00	Дамартай 00цаас+Хогны уут	78	f	0	CSBCSs8CbZ	2025-08-25 00:34:47.244+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2208	77	80134444 	7buudal ireed zalga 	3	20000.00	99080813 	73	f	0	KI5nmebvmD	2025-08-24 13:58:24.562+00	2025-08-25 11:38:26.396+00	f	f	2025-08-25 11:38:26.396+00	Utsaa avaagui	f
2255	26	99171939	Hanuul15 horoo vega city 102/804 tsenher	3	50000.00	Tsenher tsag	9	f	0	cUWIXd5HoE	2025-08-25 01:38:14.262+00	2025-08-25 14:02:25.742+00	f	f	2025-08-25 14:02:25.741+00	0	f
2268	81	80608855	BZD -32 horoo narantuul zahiin hajuud ih mandah hothon 53/2 bair	3	0.00	.	66	f	0	5BFKZW3n3e	2025-08-25 03:58:46.185+00	2025-08-25 10:14:30.682+00	f	f	2025-08-25 10:14:30.682+00	0	f
2210	77	94164616 	7hurtel narantuul zah	3	22000.00	14r tsaini gazar 	66	f	0	7pXSSCEp9X	2025-08-24 13:59:24.221+00	2025-08-25 10:38:58.603+00	f	f	2025-08-25 10:38:58.603+00	0	f
2264	26	89075333	21 nomin aguulahaas howiin autobusand	3	2.00	tsenher , har tsag	50	f	0	ECHNuZEfAo	2025-08-25 03:16:13.18+00	2025-08-25 10:47:07.009+00	f	f	2025-08-25 10:47:07.008+00	0	f
2260	26	80009450	17 цагаас өмнө СБД 6-р хороо бага тойруу Эрчим хүчний зохицуулах хороо7 цагаас хойш кинг тауэр 145 байр 303 тоот орой ,	2	50000.00	Ajliin tsgaar bol sbd oroi bol hud har tsag	73	f	0	KPVZ2DyfMB	2025-08-25 02:52:04.208+00	2025-08-26 05:05:47.598+00	f	f	\N	5аас өмнө хүргэнэ	f
2219	77	99754857 	3tsag hurtel narantuul orogtgol 	3	25000.00	86693450 	66	f	0	GvZ4MMcfeB	2025-08-24 14:05:30.497+00	2025-08-25 14:29:42.284+00	f	f	2025-08-25 14:29:42.284+00	0	f
2218	77	86110060 	21 horoolol chingos coco baruun tal	3	18000.00	chuhag hothon 32 b .bair 12 r dawhar 68 toot	50	f	0	cMZ8wRMYCI	2025-08-24 14:04:50.761+00	2025-08-25 13:09:16.202+00	f	f	2025-08-25 13:09:16.201+00	0	f
2267	10	96599644	16 horoolol bus buudal deer mc zaswar deer awna 	3	0.00	5tsagaas hoish awna	66	f	0	sBfjEGqD4g	2025-08-25 03:55:49.092+00	2025-08-25 13:58:27.31+00	t	f	2025-08-25 13:58:27.31+00	0	f
2265	26	99061945	Бгд хорооллын эцэст сотын ногоон байрны хойно дулаахан байр 45-34 тоот 5 давхарт  tsenher	2	50000.00	tsenher	73	f	0	IgKHWAhHC9	2025-08-25 03:40:16.873+00	2025-08-26 05:05:47.598+00	f	f	\N	0	f
2261	26	89881818	Зайсан оргилстар хотхон 59р байр 83 тоот	3	50000.00	tsenher	9	f	0	nAQb8fTyu1	2025-08-25 02:58:31.126+00	2025-08-25 13:40:42.674+00	f	f	2025-08-25 13:40:42.674+00	0	f
2259	26	99992687	hanuul duureg king tower 135 bair 140 toot	3	50000.00	Tsenher tsav	9	f	0	WZ2VUEFBLU	2025-08-25 02:38:16.874+00	2025-08-25 13:18:48.607+00	f	f	2025-08-25 13:18:48.607+00	0	f
2217	77	85599905 	sodon horoollin hoid talin haniin metiral iin avotbusni buudal deer	2	18000.00	95373316 	9	f	0	XxCCxzwE23	2025-08-24 14:04:02.276+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
2221	77	91851414 	hayg soliw howdiin bus d tawina 	2	20000.00	99270835 	9	f	0	y4vNK1zSJm	2025-08-24 14:07:01.052+00	2025-08-26 05:10:35.085+00	f	f	\N	Ховдын автобусанд тавина	f
2281	71	80117685	moskva apartment 132/4	2	0.00	shd 29r horoo	9	f	0	pQTIV3sOME	2025-08-25 04:28:38.798+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
2343	59	95501012	arhangai aimag	2	0.00	0	9	f	0	Ik0U2iNyOB	2025-08-25 16:51:00.379+00	2025-08-26 05:10:35.085+00	f	f	\N	0	f
2389	71	88353566	bayanhongor	2	0.00	.	9	f	0	CKsALnnkYS	2025-08-26 05:55:59.706+00	2025-08-26 06:06:36.872+00	f	f	\N	0	f
2216	77	95157154  99419504	 bayn olgii bayan nuur sum	2	0.00	 tolbor batalgaajsan 	66	f	0	MWJ7MzLOkN	2025-08-24 14:03:31.326+00	2025-08-26 06:10:20.269+00	t	t	\N	utas n holbogdoogvi	f
2285	4	86646055	arslantai guur oyuinii undraa tuv TSE pub	3	0.00	.	73	f	0	jdLvAElPn3	2025-08-25 05:38:02.344+00	2025-08-25 06:23:34.156+00	t	f	2025-08-25 06:23:34.156+00	0	f
2277	71	95059950	narnii horoolol 21r bair 2302	3	0.00	.	78	f	0	OlGMfVXCGp	2025-08-25 04:10:49.835+00	2025-08-25 09:13:18.384+00	f	f	2025-08-25 09:13:18.384+00	0	f
2269	81	99216655	HUD 3r horoo Tets-3 gobi uildverin hoid tald sutai town	3	0.00	.	78	f	0	kO659S8HBg	2025-08-25 04:00:36.691+00	2025-08-25 10:53:23.798+00	f	f	2025-08-25 10:53:23.798+00	0	f
2286	84	96699279	SBD 15r horoo Damba-iin minii delguur 	3	51000.00	.	73	f	0	73EG7A4usx	2025-08-25 05:43:19.236+00	2025-08-25 12:13:32.611+00	f	f	2025-08-25 12:13:32.611+00	0	f
2263	26	99109737	river garden 302 bair. Bairnii gadaa ireed zalgakh	3	50000.00	Garaad awchihnaa tsenher tsag	9	f	0	eGjqpppPCJ	2025-08-25 03:13:05.567+00	2025-08-25 12:55:13.621+00	f	f	2025-08-25 12:55:13.621+00	0	f
2271	71	85117859	niseh denj piramide apartment 294 2 toot	3	0.00	.	78	f	0	hgsMB9BbwX	2025-08-25 04:06:04.804+00	2025-08-25 14:00:30.334+00	f	f	2025-08-25 14:00:30.333+00	0	f
2287	84	99533112	bayanmongol 412bair uilchilgee-pizza der avah	2	66000.00	.	66	f	0	ASQrc3AksL	2025-08-25 05:44:55.537+00	2025-08-26 04:31:20.836+00	f	f	\N	margash avjlin tsagaar avna	f
2344	26	88075933	bayanmongol urd elezabet hothonii 221 bair 1 orts 62 toot kod: #2 123654# Tsenher tsag	2	50000.00	tsenher	66	f	0	L4VmvmzpA3	2025-08-25 16:51:54.722+00	2025-08-26 04:31:20.836+00	f	f	\N	0	f
2282	60	85454456	Нарны хороолол27а 6давхар 602 85454456	2	85000.00	modon hataagch unuudur hurguuleh	78	f	0	sGfy35PiSV	2025-08-25 05:21:30.734+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2283	60	86003890	Хан уул дүүрэг 11р хороо Peace Village хотхон 208р байр 1-р орц 1- давхарт 43 тоот орцны код 2081# / уулын зам буган халиунаар өгсөөд явах замд байдаг хотхон	2	85000.00	modon hataagch	78	f	0	oxin3mCa4n	2025-08-25 05:22:57.482+00	2025-08-26 04:54:06.503+00	f	f	\N	0	f
2390	71	85944499	govi altai	2	0.00	.	66	f	0	0KtfYQW5rJ	2025-08-26 05:56:30.224+00	2025-08-26 06:05:46.125+00	f	f	\N	0	f
\.


--
-- Data for Name: delivery_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.delivery_items (id, delivery_id, good_id, quantity, "createdAt", "updatedAt") FROM stdin;
6	1154	31	1	2025-07-24 08:38:51.485+00	2025-07-24 08:38:51.485+00
7	1155	31	1	2025-07-25 01:47:33.502+00	2025-07-25 01:47:33.502+00
8	1159	31	1	2025-07-25 04:40:37.334+00	2025-07-25 04:40:37.334+00
9	1160	31	1	2025-07-25 04:41:55.711+00	2025-07-25 04:41:55.711+00
10	1166	31	1	2025-07-25 06:04:18.396+00	2025-07-25 06:04:18.396+00
11	1167	31	1	2025-07-25 06:05:35.427+00	2025-07-25 06:05:35.427+00
12	1168	31	1	2025-07-25 06:08:21.197+00	2025-07-25 06:08:21.197+00
13	1169	31	1	2025-07-25 06:12:29.819+00	2025-07-25 06:12:29.819+00
14	1170	31	1	2025-07-25 06:20:21.273+00	2025-07-25 06:20:21.273+00
15	1171	31	2	2025-07-25 07:13:52.03+00	2025-07-25 07:13:52.03+00
16	1172	31	1	2025-07-25 07:25:31.724+00	2025-07-25 07:25:31.724+00
17	1173	31	1	2025-07-25 07:40:31.278+00	2025-07-25 07:40:31.278+00
18	1174	31	1	2025-07-25 07:42:54.076+00	2025-07-25 07:42:54.076+00
19	1175	31	2	2025-07-25 07:46:52.288+00	2025-07-25 07:46:52.288+00
20	1176	31	1	2025-07-25 07:49:13.036+00	2025-07-25 07:49:13.036+00
21	1177	31	3	2025-07-25 07:59:36.877+00	2025-07-25 07:59:36.877+00
22	1178	31	1	2025-07-25 08:06:03.876+00	2025-07-25 08:06:03.876+00
23	1179	31	1	2025-07-25 08:55:31.832+00	2025-07-25 08:55:31.832+00
24	1185	31	1	2025-07-26 01:02:33.176+00	2025-07-26 01:02:33.176+00
25	1186	31	1	2025-07-26 01:15:22.675+00	2025-07-26 01:15:22.675+00
26	1190	31	1	2025-07-26 03:12:28.648+00	2025-07-26 03:12:28.648+00
27	1191	31	1	2025-07-26 03:18:41.345+00	2025-07-26 03:18:41.345+00
28	1192	31	1	2025-07-26 03:19:42.697+00	2025-07-26 03:19:42.697+00
29	1193	31	1	2025-07-26 03:27:46.042+00	2025-07-26 03:27:46.042+00
30	1194	31	1	2025-07-26 03:32:41.197+00	2025-07-26 03:32:41.197+00
31	1195	31	1	2025-07-26 04:16:40.378+00	2025-07-26 04:16:40.378+00
32	1199	31	1	2025-07-26 06:09:54.512+00	2025-07-26 06:09:54.512+00
33	1200	31	1	2025-07-26 06:14:12.132+00	2025-07-26 06:14:12.132+00
34	1202	31	1	2025-07-26 07:01:42.475+00	2025-07-26 07:01:42.475+00
35	1239	31	1	2025-07-28 02:05:39.461+00	2025-07-28 02:05:39.461+00
36	1240	31	1	2025-07-28 02:12:56.705+00	2025-07-28 02:12:56.705+00
37	1241	31	1	2025-07-28 02:16:42.877+00	2025-07-28 02:16:42.877+00
38	1242	31	1	2025-07-28 02:22:31.17+00	2025-07-28 02:22:31.17+00
39	1243	31	1	2025-07-28 02:28:54.527+00	2025-07-28 02:28:54.527+00
40	1244	31	1	2025-07-28 02:35:43.61+00	2025-07-28 02:35:43.61+00
41	1245	31	1	2025-07-28 02:56:38.823+00	2025-07-28 02:56:38.823+00
42	1246	31	1	2025-07-28 02:58:17.036+00	2025-07-28 02:58:17.036+00
43	1247	31	1	2025-07-28 03:10:00.934+00	2025-07-28 03:10:00.934+00
44	1248	31	1	2025-07-28 03:13:52.678+00	2025-07-28 03:13:52.678+00
45	1249	31	1	2025-07-28 03:16:00.225+00	2025-07-28 03:16:00.225+00
46	1250	31	1	2025-07-28 03:17:15.408+00	2025-07-28 03:17:15.408+00
47	1251	31	1	2025-07-28 03:24:05.688+00	2025-07-28 03:24:05.688+00
48	1252	31	1	2025-07-28 06:18:14.2+00	2025-07-28 06:18:14.2+00
49	1253	31	1	2025-07-28 06:26:40.267+00	2025-07-28 06:26:40.267+00
50	1254	31	1	2025-07-28 06:38:41.745+00	2025-07-28 06:38:41.745+00
51	1256	31	1	2025-07-28 06:42:57.422+00	2025-07-28 06:42:57.422+00
52	1266	31	1	2025-07-28 08:20:48.903+00	2025-07-28 08:20:48.903+00
53	1287	31	1	2025-07-29 02:13:29.691+00	2025-07-29 02:13:29.691+00
54	1288	31	1	2025-07-29 02:16:35.495+00	2025-07-29 02:16:35.495+00
55	1289	31	1	2025-07-29 02:20:42.925+00	2025-07-29 02:20:42.925+00
56	1290	31	1	2025-07-29 02:22:19.306+00	2025-07-29 02:22:19.306+00
57	1291	31	1	2025-07-29 02:30:51.105+00	2025-07-29 02:30:51.105+00
58	1292	31	1	2025-07-29 02:39:53.952+00	2025-07-29 02:39:53.952+00
59	1294	31	1	2025-07-29 03:47:13.953+00	2025-07-29 03:47:13.953+00
60	1295	31	1	2025-07-29 03:48:52.013+00	2025-07-29 03:48:52.013+00
61	1296	31	1	2025-07-29 03:50:43.999+00	2025-07-29 03:50:43.999+00
62	1298	31	1	2025-07-29 04:37:54.759+00	2025-07-29 04:37:54.759+00
63	1299	31	1	2025-07-29 04:39:45.922+00	2025-07-29 04:39:45.922+00
64	1304	31	1	2025-07-29 06:25:31.969+00	2025-07-29 06:25:31.969+00
65	1305	31	1	2025-07-29 06:33:12.781+00	2025-07-29 06:33:12.781+00
66	1306	34	1	2025-07-29 06:38:44.905+00	2025-07-29 06:38:44.905+00
67	1307	31	1	2025-07-29 06:44:50.822+00	2025-07-29 06:44:50.822+00
68	1308	34	1	2025-07-29 06:49:58.127+00	2025-07-29 06:49:58.127+00
69	1309	31	1	2025-07-29 06:58:49.696+00	2025-07-29 06:58:49.696+00
70	1310	31	1	2025-07-29 07:01:01.825+00	2025-07-29 07:01:01.825+00
71	1311	34	1	2025-07-29 07:05:08.467+00	2025-07-29 07:05:08.467+00
72	1312	34	1	2025-07-29 07:11:15.794+00	2025-07-29 07:11:15.794+00
73	1313	31	1	2025-07-29 07:28:04.923+00	2025-07-29 07:28:04.923+00
74	1314	31	1	2025-07-29 07:57:29.026+00	2025-07-29 07:57:29.026+00
75	1315	31	1	2025-07-29 08:17:02.867+00	2025-07-29 08:17:02.867+00
76	1316	34	1	2025-07-29 08:29:55.706+00	2025-07-29 08:29:55.706+00
77	1327	31	1	2025-07-30 01:28:39.343+00	2025-07-30 01:28:39.343+00
78	1328	31	1	2025-07-30 01:35:08.981+00	2025-07-30 01:35:08.981+00
79	1329	31	1	2025-07-30 02:25:35.994+00	2025-07-30 02:25:35.994+00
80	1331	31	1	2025-07-30 03:07:30.069+00	2025-07-30 03:07:30.069+00
81	1332	31	1	2025-07-30 03:11:35.166+00	2025-07-30 03:11:35.166+00
82	1333	31	1	2025-07-30 03:14:17.262+00	2025-07-30 03:14:17.262+00
83	1334	31	1	2025-07-30 03:16:17.868+00	2025-07-30 03:16:17.868+00
84	1335	31	1	2025-07-30 03:18:03.201+00	2025-07-30 03:18:03.201+00
85	1336	31	1	2025-07-30 04:20:56.56+00	2025-07-30 04:20:56.56+00
86	1337	31	1	2025-07-30 04:22:38.579+00	2025-07-30 04:22:38.579+00
87	1338	34	1	2025-07-30 04:24:17.303+00	2025-07-30 04:24:17.303+00
88	1339	31	1	2025-07-30 04:26:22.949+00	2025-07-30 04:26:22.949+00
89	1340	31	1	2025-07-30 04:28:19.276+00	2025-07-30 04:28:19.276+00
90	1341	34	1	2025-07-30 04:40:59.336+00	2025-07-30 04:40:59.336+00
91	1372	31	1	2025-08-01 01:20:35.838+00	2025-08-01 01:20:35.838+00
92	1373	31	1	2025-08-01 01:25:38.234+00	2025-08-01 01:25:38.234+00
93	1375	31	1	2025-08-01 01:33:31.788+00	2025-08-01 01:33:31.788+00
94	1376	31	1	2025-08-01 01:35:33.055+00	2025-08-01 01:35:33.055+00
95	1377	31	1	2025-08-01 01:40:01.481+00	2025-08-01 01:40:01.481+00
96	1378	31	1	2025-08-01 01:45:30.049+00	2025-08-01 01:45:30.049+00
97	1555	9	3	2025-08-09 06:24:07.252+00	2025-08-09 06:24:07.252+00
98	1555	4	1	2025-08-09 06:24:07.252+00	2025-08-09 06:24:07.252+00
99	1556	9	2	2025-08-09 06:24:59.987+00	2025-08-09 06:24:59.987+00
100	1666	35	1	2025-08-14 03:33:39.44+00	2025-08-14 03:33:39.44+00
101	1666	36	1	2025-08-14 03:33:39.44+00	2025-08-14 03:33:39.44+00
102	1666	37	1	2025-08-14 03:33:39.44+00	2025-08-14 03:33:39.44+00
103	1667	35	1	2025-08-14 03:38:14.248+00	2025-08-14 03:38:14.248+00
104	1667	36	1	2025-08-14 03:38:14.248+00	2025-08-14 03:38:14.248+00
105	1667	37	1	2025-08-14 03:38:14.248+00	2025-08-14 03:38:14.248+00
106	1668	35	1	2025-08-14 03:41:03.828+00	2025-08-14 03:41:03.828+00
107	1668	36	1	2025-08-14 03:41:03.828+00	2025-08-14 03:41:03.828+00
108	1668	37	1	2025-08-14 03:41:03.828+00	2025-08-14 03:41:03.828+00
109	1669	35	2	2025-08-14 03:44:38.061+00	2025-08-14 03:44:38.061+00
110	1669	36	2	2025-08-14 03:44:38.061+00	2025-08-14 03:44:38.061+00
111	1669	37	2	2025-08-14 03:44:38.061+00	2025-08-14 03:44:38.061+00
112	1670	35	1	2025-08-14 03:46:42.919+00	2025-08-14 03:46:42.919+00
113	1670	36	1	2025-08-14 03:46:42.919+00	2025-08-14 03:46:42.919+00
114	1670	37	1	2025-08-14 03:46:42.919+00	2025-08-14 03:46:42.919+00
115	1671	35	1	2025-08-14 03:49:18.828+00	2025-08-14 03:49:18.828+00
116	1671	36	1	2025-08-14 03:49:18.828+00	2025-08-14 03:49:18.828+00
117	1671	37	1	2025-08-14 03:49:18.828+00	2025-08-14 03:49:18.828+00
118	1672	35	1	2025-08-14 03:52:29.911+00	2025-08-14 03:52:29.911+00
119	1672	36	1	2025-08-14 03:52:29.911+00	2025-08-14 03:52:29.911+00
120	1672	37	1	2025-08-14 03:52:29.911+00	2025-08-14 03:52:29.911+00
121	1673	35	1	2025-08-14 03:56:05.427+00	2025-08-14 03:56:05.427+00
122	1673	36	1	2025-08-14 03:56:05.427+00	2025-08-14 03:56:05.427+00
123	1673	37	1	2025-08-14 03:56:05.427+00	2025-08-14 03:56:05.427+00
124	1674	35	1	2025-08-14 03:58:23.355+00	2025-08-14 03:58:23.355+00
125	1674	36	1	2025-08-14 03:58:23.355+00	2025-08-14 03:58:23.355+00
126	1674	37	1	2025-08-14 03:58:23.355+00	2025-08-14 03:58:23.355+00
127	1675	35	1	2025-08-14 04:04:28.026+00	2025-08-14 04:04:28.026+00
128	1675	36	1	2025-08-14 04:04:28.026+00	2025-08-14 04:04:28.026+00
129	1675	37	1	2025-08-14 04:04:28.026+00	2025-08-14 04:04:28.026+00
130	1676	35	1	2025-08-14 04:16:29.2+00	2025-08-14 04:16:29.2+00
131	1676	36	1	2025-08-14 04:16:29.2+00	2025-08-14 04:16:29.2+00
132	1676	37	1	2025-08-14 04:16:29.2+00	2025-08-14 04:16:29.2+00
133	1677	35	1	2025-08-14 04:19:11.992+00	2025-08-14 04:19:11.992+00
134	1677	36	1	2025-08-14 04:19:11.992+00	2025-08-14 04:19:11.992+00
135	1677	37	1	2025-08-14 04:19:11.992+00	2025-08-14 04:19:11.992+00
136	1678	35	1	2025-08-14 04:23:35.871+00	2025-08-14 04:23:35.871+00
137	1678	36	1	2025-08-14 04:23:35.871+00	2025-08-14 04:23:35.871+00
138	1678	37	1	2025-08-14 04:23:35.871+00	2025-08-14 04:23:35.871+00
139	1679	37	1	2025-08-14 04:29:08.867+00	2025-08-14 04:29:08.867+00
140	1679	36	4	2025-08-14 04:29:08.867+00	2025-08-14 04:29:08.867+00
141	1684	35	1	2025-08-14 04:39:59.197+00	2025-08-14 04:39:59.197+00
142	1684	36	1	2025-08-14 04:39:59.197+00	2025-08-14 04:39:59.197+00
143	1684	37	1	2025-08-14 04:39:59.197+00	2025-08-14 04:39:59.197+00
144	1685	35	1	2025-08-14 05:17:13.896+00	2025-08-14 05:17:13.896+00
145	1685	36	1	2025-08-14 05:17:13.896+00	2025-08-14 05:17:13.896+00
146	1685	37	1	2025-08-14 05:17:13.896+00	2025-08-14 05:17:13.896+00
147	1686	35	1	2025-08-14 05:23:38.852+00	2025-08-14 05:23:38.852+00
148	1686	36	1	2025-08-14 05:23:38.852+00	2025-08-14 05:23:38.852+00
149	1686	37	1	2025-08-14 05:23:38.852+00	2025-08-14 05:23:38.852+00
150	1687	35	1	2025-08-14 05:26:45.751+00	2025-08-14 05:26:45.751+00
151	1687	36	1	2025-08-14 05:26:45.751+00	2025-08-14 05:26:45.751+00
152	1687	37	1	2025-08-14 05:26:45.751+00	2025-08-14 05:26:45.751+00
153	1694	35	1	2025-08-14 09:00:23.541+00	2025-08-14 09:00:23.541+00
154	1694	36	1	2025-08-14 09:00:23.541+00	2025-08-14 09:00:23.541+00
155	1694	37	1	2025-08-14 09:00:23.541+00	2025-08-14 09:00:23.541+00
156	1699	35	1	2025-08-14 09:19:25.498+00	2025-08-14 09:19:25.498+00
157	1699	36	1	2025-08-14 09:19:25.498+00	2025-08-14 09:19:25.498+00
158	1699	37	1	2025-08-14 09:19:25.498+00	2025-08-14 09:19:25.498+00
159	1700	35	1	2025-08-14 09:21:24.346+00	2025-08-14 09:21:24.346+00
160	1700	36	1	2025-08-14 09:21:24.346+00	2025-08-14 09:21:24.346+00
161	1700	37	1	2025-08-14 09:21:24.346+00	2025-08-14 09:21:24.346+00
162	1702	35	1	2025-08-14 09:24:09.356+00	2025-08-14 09:24:09.356+00
163	1702	36	1	2025-08-14 09:24:09.356+00	2025-08-14 09:24:09.356+00
164	1702	37	1	2025-08-14 09:24:09.356+00	2025-08-14 09:24:09.356+00
165	1703	35	1	2025-08-14 09:26:59.684+00	2025-08-14 09:26:59.684+00
166	1703	36	1	2025-08-14 09:26:59.684+00	2025-08-14 09:26:59.684+00
167	1703	37	1	2025-08-14 09:26:59.684+00	2025-08-14 09:26:59.684+00
168	1705	35	1	2025-08-14 09:29:13.479+00	2025-08-14 09:29:13.479+00
169	1705	36	1	2025-08-14 09:29:13.479+00	2025-08-14 09:29:13.479+00
170	1705	37	1	2025-08-14 09:29:13.479+00	2025-08-14 09:29:13.479+00
171	1706	35	1	2025-08-14 09:31:03.602+00	2025-08-14 09:31:03.602+00
172	1706	36	1	2025-08-14 09:31:03.602+00	2025-08-14 09:31:03.602+00
173	1706	37	1	2025-08-14 09:31:03.602+00	2025-08-14 09:31:03.602+00
174	1724	35	1	2025-08-15 02:46:58.788+00	2025-08-15 02:46:58.788+00
175	1724	36	1	2025-08-15 02:46:58.788+00	2025-08-15 02:46:58.788+00
176	1724	37	1	2025-08-15 02:46:58.788+00	2025-08-15 02:46:58.788+00
177	1725	35	1	2025-08-15 02:48:21.066+00	2025-08-15 02:48:21.066+00
178	1725	36	1	2025-08-15 02:48:21.066+00	2025-08-15 02:48:21.066+00
179	1725	37	1	2025-08-15 02:48:21.066+00	2025-08-15 02:48:21.066+00
180	1726	35	1	2025-08-15 02:51:29.035+00	2025-08-15 02:51:29.035+00
181	1726	36	1	2025-08-15 02:51:29.035+00	2025-08-15 02:51:29.035+00
182	1726	37	1	2025-08-15 02:51:29.035+00	2025-08-15 02:51:29.035+00
183	1727	35	1	2025-08-15 02:53:38.462+00	2025-08-15 02:53:38.462+00
184	1727	36	1	2025-08-15 02:53:38.462+00	2025-08-15 02:53:38.462+00
185	1727	37	1	2025-08-15 02:53:38.462+00	2025-08-15 02:53:38.462+00
186	1728	35	1	2025-08-15 02:55:35.012+00	2025-08-15 02:55:35.012+00
187	1728	36	1	2025-08-15 02:55:35.012+00	2025-08-15 02:55:35.012+00
188	1728	37	1	2025-08-15 02:55:35.012+00	2025-08-15 02:55:35.012+00
189	1754	35	1	2025-08-15 15:29:10.567+00	2025-08-15 15:29:10.567+00
190	1754	36	1	2025-08-15 15:29:10.567+00	2025-08-15 15:29:10.567+00
191	1754	37	1	2025-08-15 15:29:10.567+00	2025-08-15 15:29:10.567+00
192	1755	35	1	2025-08-15 15:32:40.918+00	2025-08-15 15:32:40.918+00
193	1755	36	1	2025-08-15 15:32:40.918+00	2025-08-15 15:32:40.918+00
194	1755	37	1	2025-08-15 15:32:40.918+00	2025-08-15 15:32:40.918+00
195	1756	35	1	2025-08-15 15:35:06.313+00	2025-08-15 15:35:06.313+00
196	1756	36	1	2025-08-15 15:35:06.313+00	2025-08-15 15:35:06.313+00
197	1756	37	1	2025-08-15 15:35:06.313+00	2025-08-15 15:35:06.313+00
198	1757	35	1	2025-08-15 15:37:20.045+00	2025-08-15 15:37:20.045+00
199	1757	36	1	2025-08-15 15:37:20.045+00	2025-08-15 15:37:20.045+00
200	1757	37	1	2025-08-15 15:37:20.045+00	2025-08-15 15:37:20.045+00
201	1758	35	1	2025-08-15 15:39:54.149+00	2025-08-15 15:39:54.149+00
202	1758	36	1	2025-08-15 15:39:54.149+00	2025-08-15 15:39:54.149+00
203	1758	37	1	2025-08-15 15:39:54.149+00	2025-08-15 15:39:54.149+00
204	1759	35	1	2025-08-15 15:42:41.45+00	2025-08-15 15:42:41.45+00
205	1759	36	1	2025-08-15 15:42:41.45+00	2025-08-15 15:42:41.45+00
206	1759	37	1	2025-08-15 15:42:41.45+00	2025-08-15 15:42:41.45+00
207	1760	35	1	2025-08-15 15:44:35.469+00	2025-08-15 15:44:35.469+00
208	1760	36	1	2025-08-15 15:44:35.469+00	2025-08-15 15:44:35.469+00
209	1760	37	1	2025-08-15 15:44:35.469+00	2025-08-15 15:44:35.469+00
210	1761	35	1	2025-08-15 15:56:08.606+00	2025-08-15 15:56:08.606+00
211	1761	36	1	2025-08-15 15:56:08.606+00	2025-08-15 15:56:08.606+00
212	1761	37	1	2025-08-15 15:56:08.606+00	2025-08-15 15:56:08.606+00
213	1762	35	1	2025-08-15 16:00:52.771+00	2025-08-15 16:00:52.771+00
214	1762	36	1	2025-08-15 16:00:52.771+00	2025-08-15 16:00:52.771+00
215	1762	37	1	2025-08-15 16:00:52.771+00	2025-08-15 16:00:52.771+00
216	1779	35	1	2025-08-16 02:12:04.383+00	2025-08-16 02:12:04.383+00
217	1779	36	1	2025-08-16 02:12:04.383+00	2025-08-16 02:12:04.383+00
218	1779	37	1	2025-08-16 02:12:04.383+00	2025-08-16 02:12:04.383+00
219	1780	35	1	2025-08-16 02:17:24.407+00	2025-08-16 02:17:24.407+00
220	1780	36	1	2025-08-16 02:17:24.407+00	2025-08-16 02:17:24.407+00
221	1780	37	1	2025-08-16 02:17:24.407+00	2025-08-16 02:17:24.407+00
222	1781	35	1	2025-08-16 02:26:16.517+00	2025-08-16 02:26:16.517+00
223	1781	36	1	2025-08-16 02:26:16.517+00	2025-08-16 02:26:16.517+00
224	1781	37	1	2025-08-16 02:26:16.517+00	2025-08-16 02:26:16.517+00
225	1810	35	1	2025-08-17 01:40:30.065+00	2025-08-17 01:40:30.065+00
226	1810	36	1	2025-08-17 01:40:30.065+00	2025-08-17 01:40:30.065+00
227	1810	37	1	2025-08-17 01:40:30.065+00	2025-08-17 01:40:30.065+00
228	1811	35	1	2025-08-17 01:43:22.167+00	2025-08-17 01:43:22.167+00
229	1811	36	1	2025-08-17 01:43:22.167+00	2025-08-17 01:43:22.167+00
230	1811	37	1	2025-08-17 01:43:22.167+00	2025-08-17 01:43:22.167+00
231	1812	35	1	2025-08-17 01:45:13.946+00	2025-08-17 01:45:13.946+00
232	1812	36	1	2025-08-17 01:45:13.946+00	2025-08-17 01:45:13.946+00
233	1812	37	1	2025-08-17 01:45:13.946+00	2025-08-17 01:45:13.946+00
234	1813	35	1	2025-08-17 01:51:22.292+00	2025-08-17 01:51:22.292+00
235	1813	36	1	2025-08-17 01:51:22.292+00	2025-08-17 01:51:22.292+00
236	1813	37	1	2025-08-17 01:51:22.292+00	2025-08-17 01:51:22.292+00
237	1814	35	1	2025-08-17 01:52:49.719+00	2025-08-17 01:52:49.719+00
238	1814	36	1	2025-08-17 01:52:49.719+00	2025-08-17 01:52:49.719+00
239	1814	37	1	2025-08-17 01:52:49.719+00	2025-08-17 01:52:49.719+00
240	1815	35	1	2025-08-17 01:55:00.678+00	2025-08-17 01:55:00.678+00
241	1815	36	1	2025-08-17 01:55:00.678+00	2025-08-17 01:55:00.678+00
242	1815	37	1	2025-08-17 01:55:00.678+00	2025-08-17 01:55:00.678+00
243	1816	35	1	2025-08-17 01:57:09.487+00	2025-08-17 01:57:09.487+00
244	1816	36	1	2025-08-17 01:57:09.487+00	2025-08-17 01:57:09.487+00
245	1816	37	1	2025-08-17 01:57:09.487+00	2025-08-17 01:57:09.487+00
246	1817	35	1	2025-08-17 01:59:18.315+00	2025-08-17 01:59:18.315+00
247	1817	36	1	2025-08-17 01:59:18.315+00	2025-08-17 01:59:18.315+00
248	1817	37	1	2025-08-17 01:59:18.315+00	2025-08-17 01:59:18.315+00
249	1818	35	1	2025-08-17 02:01:33.78+00	2025-08-17 02:01:33.78+00
250	1818	36	1	2025-08-17 02:01:33.78+00	2025-08-17 02:01:33.78+00
251	1818	37	1	2025-08-17 02:01:33.78+00	2025-08-17 02:01:33.78+00
252	1819	35	1	2025-08-17 02:06:31.248+00	2025-08-17 02:06:31.248+00
253	1819	36	1	2025-08-17 02:06:31.248+00	2025-08-17 02:06:31.248+00
254	1819	37	1	2025-08-17 02:06:31.248+00	2025-08-17 02:06:31.248+00
255	1840	35	1	2025-08-17 17:53:47.207+00	2025-08-17 17:53:47.207+00
256	1840	36	1	2025-08-17 17:53:47.207+00	2025-08-17 17:53:47.207+00
257	1862	37	1	2025-08-18 10:08:45.045+00	2025-08-18 10:08:45.045+00
258	1862	35	1	2025-08-18 10:08:45.045+00	2025-08-18 10:08:45.045+00
259	1862	36	1	2025-08-18 10:08:45.045+00	2025-08-18 10:08:45.045+00
260	1904	37	1	2025-08-20 02:20:16.908+00	2025-08-20 02:20:16.908+00
261	1904	35	1	2025-08-20 02:20:16.908+00	2025-08-20 02:20:16.908+00
262	1904	36	1	2025-08-20 02:20:16.908+00	2025-08-20 02:20:16.908+00
263	1905	37	1	2025-08-20 02:38:45.137+00	2025-08-20 02:38:45.137+00
264	1905	35	1	2025-08-20 02:38:45.137+00	2025-08-20 02:38:45.137+00
265	1905	36	1	2025-08-20 02:38:45.137+00	2025-08-20 02:38:45.137+00
266	1944	37	1	2025-08-21 02:36:57.089+00	2025-08-21 02:36:57.089+00
267	1944	35	1	2025-08-21 02:36:57.089+00	2025-08-21 02:36:57.089+00
268	1944	36	1	2025-08-21 02:36:57.089+00	2025-08-21 02:36:57.089+00
269	1945	37	1	2025-08-21 02:41:33.071+00	2025-08-21 02:41:33.071+00
270	1945	35	1	2025-08-21 02:41:33.071+00	2025-08-21 02:41:33.071+00
271	1945	36	1	2025-08-21 02:41:33.071+00	2025-08-21 02:41:33.071+00
272	1989	24	1	2025-08-22 04:48:10.596+00	2025-08-22 04:48:10.596+00
273	1990	26	1	2025-08-22 04:49:07.145+00	2025-08-22 04:49:07.145+00
274	1991	24	1	2025-08-22 04:50:42.097+00	2025-08-22 04:50:42.097+00
275	2000	57	1	2025-08-22 07:12:44.847+00	2025-08-22 07:12:44.847+00
276	2019	37	1	2025-08-22 20:11:59.417+00	2025-08-22 20:11:59.417+00
277	2019	35	1	2025-08-22 20:11:59.417+00	2025-08-22 20:11:59.417+00
278	2019	36	1	2025-08-22 20:11:59.417+00	2025-08-22 20:11:59.417+00
279	2020	37	1	2025-08-22 20:15:19.208+00	2025-08-22 20:15:19.208+00
280	2020	35	1	2025-08-22 20:15:19.208+00	2025-08-22 20:15:19.208+00
281	2020	36	1	2025-08-22 20:15:19.208+00	2025-08-22 20:15:19.208+00
282	2041	62	1	2025-08-23 03:15:55.343+00	2025-08-23 03:15:55.343+00
283	2042	65	1	2025-08-23 03:17:21.428+00	2025-08-23 03:17:21.428+00
284	2043	66	1	2025-08-23 03:18:25.37+00	2025-08-23 03:18:25.37+00
285	2045	63	2	2025-08-23 03:23:42.742+00	2025-08-23 03:23:42.742+00
286	2047	63	2	2025-08-23 03:27:32.895+00	2025-08-23 03:27:32.895+00
287	2048	64	2	2025-08-23 03:28:32.845+00	2025-08-23 03:28:32.845+00
288	2049	62	1	2025-08-23 03:29:41.936+00	2025-08-23 03:29:41.936+00
289	2050	65	1	2025-08-23 03:31:19.732+00	2025-08-23 03:31:19.732+00
290	2051	63	2	2025-08-23 03:32:48.142+00	2025-08-23 03:32:48.142+00
291	2052	63	2	2025-08-23 03:33:45.266+00	2025-08-23 03:33:45.266+00
292	2053	63	2	2025-08-23 03:33:45.464+00	2025-08-23 03:33:45.464+00
293	2054	59	2	2025-08-23 03:35:04.445+00	2025-08-23 03:35:04.445+00
294	2055	65	1	2025-08-23 03:36:27.749+00	2025-08-23 03:36:27.749+00
295	2056	65	1	2025-08-23 03:38:02.989+00	2025-08-23 03:38:02.989+00
296	2057	66	1	2025-08-23 03:39:22.295+00	2025-08-23 03:39:22.295+00
297	2058	63	2	2025-08-23 03:40:23.361+00	2025-08-23 03:40:23.361+00
298	2059	62	1	2025-08-23 03:41:52.122+00	2025-08-23 03:41:52.122+00
299	2060	62	1	2025-08-23 03:42:49.387+00	2025-08-23 03:42:49.387+00
300	2061	59	2	2025-08-23 03:43:42.871+00	2025-08-23 03:43:42.871+00
301	2062	67	2	2025-08-23 03:50:52.06+00	2025-08-23 03:50:52.06+00
302	2063	68	2	2025-08-23 03:51:43.55+00	2025-08-23 03:51:43.55+00
303	2064	62	1	2025-08-23 03:53:19.218+00	2025-08-23 03:53:19.218+00
304	2064	59	2	2025-08-23 03:53:19.218+00	2025-08-23 03:53:19.218+00
305	2065	59	2	2025-08-23 03:54:04.889+00	2025-08-23 03:54:04.889+00
306	2066	63	2	2025-08-23 03:54:51.861+00	2025-08-23 03:54:51.861+00
307	2067	60	2	2025-08-23 03:56:00.232+00	2025-08-23 03:56:00.232+00
308	2068	63	2	2025-08-23 03:56:54.241+00	2025-08-23 03:56:54.241+00
309	2069	60	2	2025-08-23 03:58:12.625+00	2025-08-23 03:58:12.625+00
310	2070	63	2	2025-08-23 03:59:01.298+00	2025-08-23 03:59:01.298+00
311	2071	63	2	2025-08-23 03:59:59.36+00	2025-08-23 03:59:59.36+00
312	2072	63	2	2025-08-23 04:00:44.907+00	2025-08-23 04:00:44.907+00
313	2073	60	2	2025-08-23 04:01:25.017+00	2025-08-23 04:01:25.017+00
314	2074	63	2	2025-08-23 04:02:18.078+00	2025-08-23 04:02:18.078+00
315	2075	63	2	2025-08-23 04:03:13.759+00	2025-08-23 04:03:13.759+00
316	2076	67	2	2025-08-23 04:04:39.047+00	2025-08-23 04:04:39.047+00
317	2077	60	2	2025-08-23 04:05:21.274+00	2025-08-23 04:05:21.274+00
318	2078	60	2	2025-08-23 04:06:00.012+00	2025-08-23 04:06:00.012+00
319	2079	66	1	2025-08-23 04:06:43.352+00	2025-08-23 04:06:43.352+00
320	2080	63	2	2025-08-23 04:07:34.398+00	2025-08-23 04:07:34.398+00
321	2081	67	2	2025-08-23 04:08:24.429+00	2025-08-23 04:08:24.429+00
322	2082	65	2	2025-08-23 04:09:05.059+00	2025-08-23 04:09:05.059+00
323	2083	59	2	2025-08-23 04:09:37.264+00	2025-08-23 04:09:37.264+00
324	2084	65	1	2025-08-23 04:11:00.355+00	2025-08-23 04:11:00.355+00
325	2085	63	2	2025-08-23 04:12:02.451+00	2025-08-23 04:12:02.451+00
326	2097	69	1	2025-08-23 11:57:20.434+00	2025-08-23 11:57:20.434+00
327	2102	59	2	2025-08-23 12:44:45.178+00	2025-08-23 12:44:45.178+00
328	2103	62	1	2025-08-23 12:46:31.549+00	2025-08-23 12:46:31.549+00
329	2104	59	1	2025-08-23 12:47:13.855+00	2025-08-23 12:47:13.855+00
330	2105	65	1	2025-08-23 12:48:07.971+00	2025-08-23 12:48:07.971+00
331	2106	67	2	2025-08-23 12:50:20.866+00	2025-08-23 12:50:20.866+00
332	2107	63	2	2025-08-23 12:51:13.73+00	2025-08-23 12:51:13.73+00
333	2108	63	2	2025-08-23 12:53:42.583+00	2025-08-23 12:53:42.583+00
334	2109	68	2	2025-08-23 12:55:20.857+00	2025-08-23 12:55:20.857+00
335	2110	67	2	2025-08-23 12:55:55.243+00	2025-08-23 12:55:55.243+00
336	2111	62	1	2025-08-23 12:56:55.793+00	2025-08-23 12:56:55.793+00
337	2112	63	2	2025-08-23 12:57:27.934+00	2025-08-23 12:57:27.934+00
338	2113	63	2	2025-08-23 12:58:05.35+00	2025-08-23 12:58:05.35+00
339	2114	62	2	2025-08-23 12:58:54.182+00	2025-08-23 12:58:54.182+00
340	2115	63	2	2025-08-23 12:59:29.82+00	2025-08-23 12:59:29.82+00
341	2116	66	1	2025-08-23 13:00:40.864+00	2025-08-23 13:00:40.864+00
342	2117	63	2	2025-08-23 13:01:38.39+00	2025-08-23 13:01:38.39+00
343	2118	67	2	2025-08-23 13:02:12.567+00	2025-08-23 13:02:12.567+00
344	2119	67	2	2025-08-23 13:02:45.034+00	2025-08-23 13:02:45.034+00
345	2120	59	2	2025-08-23 13:03:18.745+00	2025-08-23 13:03:18.745+00
346	2121	67	2	2025-08-23 13:03:57.991+00	2025-08-23 13:03:57.991+00
347	2122	66	1	2025-08-23 13:04:33.268+00	2025-08-23 13:04:33.268+00
348	2123	67	2	2025-08-23 13:05:02.733+00	2025-08-23 13:05:02.733+00
349	2124	60	2	2025-08-23 13:05:41.713+00	2025-08-23 13:05:41.713+00
350	2125	60	2	2025-08-23 13:06:14.109+00	2025-08-23 13:06:14.109+00
351	2126	63	4	2025-08-23 13:07:11.823+00	2025-08-23 13:07:11.823+00
352	2127	67	2	2025-08-23 13:07:51.829+00	2025-08-23 13:07:51.829+00
353	2128	62	1	2025-08-23 13:08:22.812+00	2025-08-23 13:08:22.812+00
354	2129	66	1	2025-08-23 13:09:05.773+00	2025-08-23 13:09:05.773+00
355	2130	64	2	2025-08-23 13:10:39.931+00	2025-08-23 13:10:39.931+00
356	2131	66	1	2025-08-23 13:12:40.367+00	2025-08-23 13:12:40.367+00
357	2132	66	1	2025-08-23 13:13:30.066+00	2025-08-23 13:13:30.066+00
358	2154	70	1	2025-08-24 01:27:44.347+00	2025-08-24 01:27:44.347+00
359	2155	71	1	2025-08-24 01:33:22.123+00	2025-08-24 01:33:22.123+00
360	2156	70	1	2025-08-24 01:44:44.379+00	2025-08-24 01:44:44.379+00
361	2157	70	1	2025-08-24 01:54:27.139+00	2025-08-24 01:54:27.139+00
362	2158	70	1	2025-08-24 02:44:10.298+00	2025-08-24 02:44:10.298+00
363	2159	62	1	2025-08-24 02:47:03.796+00	2025-08-24 02:47:03.796+00
364	2161	58	1	2025-08-24 03:10:41.258+00	2025-08-24 03:10:41.258+00
365	2162	58	1	2025-08-24 03:12:59.866+00	2025-08-24 03:12:59.866+00
366	2163	9	2	2025-08-24 03:13:01.198+00	2025-08-24 03:13:01.198+00
367	2164	57	1	2025-08-24 03:15:35.723+00	2025-08-24 03:15:35.723+00
368	2164	58	1	2025-08-24 03:15:35.723+00	2025-08-24 03:15:35.723+00
369	2168	62	1	2025-08-24 03:24:39.634+00	2025-08-24 03:24:39.634+00
370	2169	71	1	2025-08-24 03:51:50.456+00	2025-08-24 03:51:50.456+00
371	2189	71	1	2025-08-24 05:11:51.402+00	2025-08-24 05:11:51.402+00
372	2193	68	1	2025-08-24 13:46:10.356+00	2025-08-24 13:46:10.356+00
373	2194	60	2	2025-08-24 13:46:58.925+00	2025-08-24 13:46:58.925+00
374	2195	62	1	2025-08-24 13:47:29.519+00	2025-08-24 13:47:29.519+00
375	2196	63	2	2025-08-24 13:48:17.687+00	2025-08-24 13:48:17.687+00
376	2197	62	1	2025-08-24 13:48:41.275+00	2025-08-24 13:48:41.275+00
377	2198	60	2	2025-08-24 13:49:07.418+00	2025-08-24 13:49:07.418+00
378	2199	59	2	2025-08-24 13:49:36.709+00	2025-08-24 13:49:36.709+00
379	2200	67	2	2025-08-24 13:50:33.313+00	2025-08-24 13:50:33.313+00
380	2201	60	2	2025-08-24 13:54:12.203+00	2025-08-24 13:54:12.203+00
381	2202	63	2	2025-08-24 13:54:43.223+00	2025-08-24 13:54:43.223+00
382	2203	63	2	2025-08-24 13:55:27.697+00	2025-08-24 13:55:27.697+00
383	2204	68	2	2025-08-24 13:56:21.631+00	2025-08-24 13:56:21.631+00
384	2205	62	1	2025-08-24 13:56:58.732+00	2025-08-24 13:56:58.732+00
385	2206	68	2	2025-08-24 13:57:33.565+00	2025-08-24 13:57:33.565+00
386	2207	62	1	2025-08-24 13:58:00.014+00	2025-08-24 13:58:00.014+00
387	2208	59	2	2025-08-24 13:58:24.567+00	2025-08-24 13:58:24.567+00
388	2209	67	2	2025-08-24 13:58:52.543+00	2025-08-24 13:58:52.543+00
389	2210	66	1	2025-08-24 13:59:24.226+00	2025-08-24 13:59:24.226+00
390	2211	62	1	2025-08-24 14:00:21.576+00	2025-08-24 14:00:21.576+00
391	2212	62	1	2025-08-24 14:00:43.658+00	2025-08-24 14:00:43.658+00
392	2213	67	2	2025-08-24 14:01:57.506+00	2025-08-24 14:01:57.506+00
393	2214	63	2	2025-08-24 14:02:29.566+00	2025-08-24 14:02:29.566+00
394	2215	62	1	2025-08-24 14:02:58.928+00	2025-08-24 14:02:58.928+00
395	2216	59	2	2025-08-24 14:03:31.33+00	2025-08-24 14:03:31.33+00
396	2217	63	2	2025-08-24 14:04:02.28+00	2025-08-24 14:04:02.28+00
397	2218	63	2	2025-08-24 14:04:50.769+00	2025-08-24 14:04:50.769+00
398	2219	68	2	2025-08-24 14:05:30.501+00	2025-08-24 14:05:30.501+00
399	2220	68	2	2025-08-24 14:06:12.885+00	2025-08-24 14:06:12.885+00
400	2221	59	2	2025-08-24 14:07:01.058+00	2025-08-24 14:07:01.058+00
401	2222	67	2	2025-08-24 14:08:16.902+00	2025-08-24 14:08:16.902+00
402	2223	63	2	2025-08-24 14:09:48.186+00	2025-08-24 14:09:48.186+00
403	2231	70	1	2025-08-24 16:24:17.402+00	2025-08-24 16:24:17.402+00
404	2232	71	1	2025-08-24 16:25:43.521+00	2025-08-24 16:25:43.521+00
405	2233	69	1	2025-08-24 16:27:11.382+00	2025-08-24 16:27:11.382+00
406	2234	71	1	2025-08-24 16:28:30.018+00	2025-08-24 16:28:30.018+00
407	2235	69	1	2025-08-24 16:29:26.449+00	2025-08-24 16:29:26.449+00
408	2236	69	2	2025-08-24 16:32:48.185+00	2025-08-24 16:32:48.185+00
409	2237	71	1	2025-08-24 16:33:51.253+00	2025-08-24 16:33:51.253+00
410	2238	70	1	2025-08-24 16:35:02.135+00	2025-08-24 16:35:02.135+00
411	2251	70	1	2025-08-25 00:23:39.421+00	2025-08-25 00:23:39.421+00
412	2252	72	1	2025-08-25 00:34:47.251+00	2025-08-25 00:34:47.251+00
413	2253	69	1	2025-08-25 01:15:01.171+00	2025-08-25 01:15:01.171+00
414	2254	69	1	2025-08-25 01:28:42.472+00	2025-08-25 01:28:42.472+00
415	2255	70	1	2025-08-25 01:38:14.268+00	2025-08-25 01:38:14.268+00
416	2259	70	1	2025-08-25 02:38:16.877+00	2025-08-25 02:38:16.877+00
417	2260	71	1	2025-08-25 02:52:04.215+00	2025-08-25 02:52:04.215+00
418	2261	70	1	2025-08-25 02:58:31.13+00	2025-08-25 02:58:31.13+00
419	2262	68	2	2025-08-25 03:00:26.021+00	2025-08-25 03:00:26.021+00
420	2263	70	1	2025-08-25 03:13:05.571+00	2025-08-25 03:13:05.571+00
421	2264	71	1	2025-08-25 03:16:13.183+00	2025-08-25 03:16:13.183+00
422	2264	70	1	2025-08-25 03:16:13.183+00	2025-08-25 03:16:13.183+00
423	2265	70	1	2025-08-25 03:40:16.877+00	2025-08-25 03:40:16.877+00
424	2291	61	2	2025-08-25 13:29:54.574+00	2025-08-25 13:29:54.574+00
425	2292	63	2	2025-08-25 13:30:33.108+00	2025-08-25 13:30:33.108+00
426	2293	67	2	2025-08-25 13:31:05.052+00	2025-08-25 13:31:05.052+00
427	2294	67	2	2025-08-25 13:31:41.986+00	2025-08-25 13:31:41.986+00
428	2295	68	2	2025-08-25 13:32:31.268+00	2025-08-25 13:32:31.268+00
429	2296	62	1	2025-08-25 13:33:00.778+00	2025-08-25 13:33:00.778+00
430	2297	68	2	2025-08-25 13:33:31.693+00	2025-08-25 13:33:31.693+00
431	2298	59	2	2025-08-25 13:34:01.483+00	2025-08-25 13:34:01.483+00
432	2299	59	2	2025-08-25 13:34:25.41+00	2025-08-25 13:34:25.41+00
433	2300	68	2	2025-08-25 13:34:52.472+00	2025-08-25 13:34:52.472+00
434	2301	63	2	2025-08-25 13:35:59.669+00	2025-08-25 13:35:59.669+00
435	2302	63	2	2025-08-25 13:36:53.598+00	2025-08-25 13:36:53.598+00
436	2303	63	2	2025-08-25 13:37:35.222+00	2025-08-25 13:37:35.222+00
437	2304	59	2	2025-08-25 13:38:25.406+00	2025-08-25 13:38:25.406+00
438	2305	63	2	2025-08-25 13:57:08.605+00	2025-08-25 13:57:08.605+00
439	2306	63	2	2025-08-25 13:57:48.265+00	2025-08-25 13:57:48.265+00
440	2307	59	2	2025-08-25 13:58:10.98+00	2025-08-25 13:58:10.98+00
441	2308	62	1	2025-08-25 13:58:36.692+00	2025-08-25 13:58:36.692+00
442	2309	59	2	2025-08-25 13:59:06.147+00	2025-08-25 13:59:06.147+00
443	2310	63	2	2025-08-25 13:59:32.006+00	2025-08-25 13:59:32.006+00
444	2311	59	2	2025-08-25 13:59:58.202+00	2025-08-25 13:59:58.202+00
445	2312	66	1	2025-08-25 14:01:05.099+00	2025-08-25 14:01:05.099+00
446	2313	66	1	2025-08-25 14:01:32.381+00	2025-08-25 14:01:32.381+00
447	2314	59	2	2025-08-25 14:01:59.413+00	2025-08-25 14:01:59.413+00
448	2315	62	1	2025-08-25 14:02:30.721+00	2025-08-25 14:02:30.721+00
449	2316	63	2	2025-08-25 14:03:01.812+00	2025-08-25 14:03:01.812+00
450	2317	62	1	2025-08-25 14:03:40.232+00	2025-08-25 14:03:40.232+00
451	2318	63	2	2025-08-25 14:04:08.176+00	2025-08-25 14:04:08.176+00
452	2319	68	2	2025-08-25 14:04:38.38+00	2025-08-25 14:04:38.38+00
453	2320	59	2	2025-08-25 14:05:04.017+00	2025-08-25 14:05:04.017+00
454	2321	59	2	2025-08-25 14:05:34.892+00	2025-08-25 14:05:34.892+00
455	2322	66	1	2025-08-25 14:06:02.428+00	2025-08-25 14:06:02.428+00
456	2323	63	2	2025-08-25 14:06:27.17+00	2025-08-25 14:06:27.17+00
457	2324	63	2	2025-08-25 14:06:52.635+00	2025-08-25 14:06:52.635+00
458	2325	68	2	2025-08-25 14:07:18.717+00	2025-08-25 14:07:18.717+00
459	2326	59	2	2025-08-25 14:07:52.817+00	2025-08-25 14:07:52.817+00
460	2327	68	2	2025-08-25 14:08:17.219+00	2025-08-25 14:08:17.219+00
461	2337	69	1	2025-08-25 16:46:46.111+00	2025-08-25 16:46:46.111+00
462	2338	71	1	2025-08-25 16:47:27.465+00	2025-08-25 16:47:27.465+00
463	2339	70	1	2025-08-25 16:48:07.604+00	2025-08-25 16:48:07.604+00
464	2340	70	1	2025-08-25 16:48:57.475+00	2025-08-25 16:48:57.475+00
465	2341	69	1	2025-08-25 16:50:12.994+00	2025-08-25 16:50:12.994+00
466	2342	69	1	2025-08-25 16:50:26.785+00	2025-08-25 16:50:26.785+00
467	2344	70	1	2025-08-25 16:51:54.728+00	2025-08-25 16:51:54.728+00
468	2345	70	1	2025-08-25 16:52:41.533+00	2025-08-25 16:52:41.533+00
469	2346	69	1	2025-08-25 16:53:26.319+00	2025-08-25 16:53:26.319+00
470	2347	70	1	2025-08-25 16:54:18.81+00	2025-08-25 16:54:18.81+00
471	2348	71	1	2025-08-25 16:55:11.028+00	2025-08-25 16:55:11.028+00
472	2365	69	1	2025-08-26 01:46:06.339+00	2025-08-26 01:46:06.339+00
473	2366	69	1	2025-08-26 01:46:56.687+00	2025-08-26 01:46:56.687+00
474	2367	69	1	2025-08-26 01:47:36.484+00	2025-08-26 01:47:36.484+00
475	2369	70	1	2025-08-26 02:42:17.67+00	2025-08-26 02:42:17.67+00
476	2370	63	2	2025-08-26 03:14:55.901+00	2025-08-26 03:14:55.901+00
477	2371	74	1	2025-08-26 03:16:20.622+00	2025-08-26 03:16:20.622+00
478	2372	70	1	2025-08-26 03:20:32.815+00	2025-08-26 03:20:32.815+00
479	2373	63	2	2025-08-26 03:24:57.65+00	2025-08-26 03:24:57.65+00
480	2374	71	1	2025-08-26 03:25:35.731+00	2025-08-26 03:25:35.731+00
481	2375	58	1	2025-08-26 03:35:47.449+00	2025-08-26 03:35:47.449+00
482	2375	75	2	2025-08-26 03:35:47.449+00	2025-08-26 03:35:47.449+00
\.


--
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctors (id, prof, name, image, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: goods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.goods (id, ware_id, merchant_id, stock, name, "createdAt", "updatedAt", delivered, in_delivery) FROM stdin;
62	1	77	-5	hyalbar wax	2025-08-23 02:45:29.644+00	2025-08-25 14:03:40.235+00	0	0
5	1	11	24	5L shingen bordoo	2025-06-17 09:27:50.515+00	2025-06-17 09:27:50.515+00	0	0
6	1	11	20	1L shingen bordoo	2025-06-17 09:28:10.991+00	2025-06-17 09:28:10.991+00	0	0
63	2	77	-26	tamhinii filter	2025-08-23 02:45:30.905+00	2025-08-26 03:24:57.652+00	0	0
64	1	77	56	bugiin evertei uvchin namdaah tos	2025-08-23 02:45:31.673+00	2025-08-23 13:10:39.933+00	0	0
37	1	61	38	nogoon tawiur 	2025-07-31 05:54:19.842+00	2025-08-22 20:15:19.21+00	0	0
35	1	61	45	tor	2025-07-31 05:53:17.424+00	2025-08-22 20:15:19.211+00	0	0
36	1	61	44	soitog 	2025-07-31 05:53:44.843+00	2025-08-22 20:15:19.212+00	0	0
34	1	63	113	элэгны цай	2025-07-28 10:32:34.301+00	2025-07-30 04:40:59.338+00	0	0
11	1	16	231	mashini zoontog	2025-07-02 02:58:43.403+00	2025-07-02 02:59:09.12+00	0	0
12	1	22	12	sandaal	2025-07-02 02:59:29.204+00	2025-07-02 02:59:29.204+00	0	0
13	1	16	115	mashini narnii haalt	2025-07-03 07:04:53.792+00	2025-07-03 07:04:53.792+00	0	0
14	1	19	91	moringa	2025-07-03 07:07:03.553+00	2025-07-03 07:07:03.553+00	0	0
15	1	17	15	kamer 	2025-07-03 07:07:44.324+00	2025-07-03 07:07:44.324+00	0	0
16	1	17	10	naran tsetseg 	2025-07-03 07:08:35.152+00	2025-07-03 07:08:35.152+00	0	0
19	1	17	5	lampan gerel	2025-07-03 07:29:50.917+00	2025-07-03 07:29:50.917+00	0	0
20	1	17	3	400 batt	2025-07-03 07:30:59.953+00	2025-07-03 07:30:59.953+00	0	0
21	1	17	3	geriin jijig kamer	2025-07-03 07:31:49.19+00	2025-07-03 07:31:49.19+00	0	0
22	1	17	2	kamer gerel	2025-07-03 07:33:22.437+00	2025-07-03 07:33:22.437+00	0	0
23	1	10	10	test	2025-07-21 16:49:33.59+00	2025-07-21 16:50:32.579+00	0	0
27	1	58	10	module world 294sh	2025-07-22 04:20:37.045+00	2025-07-22 04:20:37.045+00	0	0
30	1	61	19	Ногоон сойтог	2025-07-22 10:30:45.819+00	2025-07-22 10:30:45.819+00	0	0
32	1	60	23	Хатаагч	2025-07-23 11:09:11.881+00	2025-07-23 11:09:11.881+00	0	0
38	1	19	69	eruul mendiin hool	2025-07-31 05:55:49.638+00	2025-07-31 05:55:49.638+00	0	0
1	1	2	8	Машины хөргөгч 50 л	2025-06-06 12:24:24.442+00	2025-07-31 05:57:34.477+00	0	0
39	1	2	11	40l horogch	2025-07-31 05:57:59.043+00	2025-07-31 05:57:59.043+00	0	0
40	1	2	10	30 l horogch	2025-07-31 05:58:19.074+00	2025-07-31 05:58:19.074+00	0	0
41	1	2	22	20 l horogch	2025-07-31 05:58:35.537+00	2025-07-31 05:58:35.537+00	0	0
33	1	63	0	ekegnii tsai	2025-07-28 10:27:37.045+00	2025-07-28 10:29:56.183+00	0	0
42	1	46	7	porogter	2025-07-31 05:59:11.268+00	2025-07-31 05:59:11.268+00	0	0
8	1	2	0	sk	2025-06-22 10:33:00.131+00	2025-07-31 05:59:31.848+00	0	0
29	1	54	37	nudnii aprat	2025-07-22 04:23:12.348+00	2025-07-31 06:00:41.508+00	0	0
28	1	58	7	module world 248 sh	2025-07-22 04:21:00.916+00	2025-07-31 06:02:22.589+00	0	0
31	1	63	150	Эрүүл мэндийн цай	2025-07-23 05:32:56.401+00	2025-08-01 01:45:30.05+00	0	0
25	1	58	0	aylalin suudrewch 3-4.5	2025-07-22 04:19:31.984+00	2025-08-01 19:39:17.205+00	0	0
43	1	58	2	3x3 suuderwch	2025-07-31 06:03:02.587+00	2025-08-01 19:39:27.95+00	0	0
44	1	58	0	Ванны багц тоглоом	2025-08-01 19:39:53.989+00	2025-08-01 19:39:53.989+00	0	0
45	1	58	6	3x4.5 suuderwch	2025-08-11 05:53:31.582+00	2025-08-11 05:53:31.582+00	0	0
46	1	58	6	4.5x4.5 suuderwch	2025-08-11 05:53:48.159+00	2025-08-11 05:53:48.159+00	0	0
51	1	19	17	moringa	2025-08-18 04:28:05.849+00	2025-08-18 04:28:05.849+00	0	0
47	1	58	6	4.5x6 suuderwch	2025-08-11 05:53:59.492+00	2025-08-11 05:53:59.492+00	0	0
48	1	58	6	 huuhed bann togloom 	2025-08-11 05:54:27.226+00	2025-08-11 05:54:27.226+00	0	0
49	1	58	15	huuhdedin tsunh	2025-08-11 05:54:56.346+00	2025-08-11 05:54:56.346+00	0	0
50	1	58	8	tsunhen sandal	2025-08-11 05:55:12.875+00	2025-08-11 05:55:12.875+00	0	0
73	1	82	8	huuhdiin GPS	2025-08-25 05:23:01.315+00	2025-08-25 05:23:01.315+00	0	0
61	1	77	18	huwtsas tsairuulagch	2025-08-23 02:45:28.267+00	2025-08-25 13:29:54.576+00	0	0
58	1	76	17	ger bul bagts	2025-08-22 07:11:35.171+00	2025-08-26 03:35:47.454+00	0	0
52	1	10	58	eregte oims har tsagaan	2025-08-19 04:26:44.997+00	2025-08-19 04:26:44.997+00	0	0
53	1	10	143	eregte tsagaan	2025-08-19 04:27:06.623+00	2025-08-19 04:27:06.623+00	0	0
54	1	10	50	emegte oims tsagaan	2025-08-19 04:27:27.424+00	2025-08-19 04:27:27.424+00	0	0
55	1	10	50	emegte oims holimog	2025-08-19 04:27:50.176+00	2025-08-19 04:27:50.176+00	0	0
56	1	60	4	modon hataagch 	2025-08-19 04:44:16.628+00	2025-08-19 04:44:16.628+00	0	0
75	1	76	13	18ш-тэй Ариун цэврийн цэврийн цаас	2025-08-26 03:34:09.205+00	2025-08-26 03:35:47.455+00	0	0
72	1	76	0	Хайрцагтай+Шар тортой бараа	2025-08-25 00:30:41.847+00	2025-08-25 00:34:47.254+00	0	0
66	1	77	18	avtomat hamarnii us awagch	2025-08-23 02:45:34.102+00	2025-08-25 14:06:02.43+00	0	0
67	1	77	28	shudni oo	2025-08-23 02:45:35.051+00	2025-08-25 13:31:41.988+00	0	0
60	2	77	36	nuurnii begnuur	2025-08-23 02:45:25.763+00	2025-08-24 13:54:12.205+00	0	0
71	1	26	14	huuhediin tsag har	2025-08-23 08:02:26.406+00	2025-08-26 05:42:35.535+00	0	0
69	1	26	66	huuhediin tsag ygaan	2025-08-23 08:01:31.8+00	2025-08-26 05:43:03.718+00	0	0
17	1	26	0	mashinii tsonhnii tor	2025-07-03 07:10:03.486+00	2025-08-26 05:45:26.447+00	0	0
59	1	77	-13	har batga mask	2025-08-23 02:45:24.577+00	2025-08-25 14:07:52.819+00	0	0
9	1	10	23	huwtsasni hairtsag 	2025-06-24 12:24:45.623+00	2025-08-24 03:13:01.199+00	0	0
26	1	58	-1	aylalin suudrewch 4.5-4.5	2025-07-22 04:19:53.668+00	2025-08-22 04:49:07.148+00	0	0
24	1	58	9	usan buu	2025-07-22 04:18:55.311+00	2025-08-22 04:50:42.098+00	0	0
65	1	77	22	humsugni hew harandaa pretka	2025-08-23 02:45:32.991+00	2025-08-23 12:48:07.973+00	0	0
57	2	76	19	 ger bul tsetserleg bagts	2025-08-22 07:11:16.516+00	2025-08-24 03:15:35.725+00	0	0
68	1	77	33	hairst uldni tos	2025-08-23 02:45:35.75+00	2025-08-25 14:08:17.22+00	0	0
70	1	26	55	huuhedin tsag tsenher	2025-08-23 08:02:05.075+00	2025-08-26 05:45:43.18+00	0	0
4	1	10	-26	mask	2025-06-17 01:30:25.47+00	2025-08-24 15:14:14.508+00	0	0
74	1	26	0	tsahilgaanii bahi	2025-08-26 03:09:37.565+00	2025-08-26 03:16:20.624+00	0	0
\.


--
-- Data for Name: infos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.infos (id, richtext, doctor, image, audio, title, isactive, category, gender, age, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, title, body, type, "createdAt", "updatedAt") FROM stdin;
1	anhaaruulg	13 tsagaas office dr uuzlah	2	2025-06-06 14:33:13.956+00	2025-06-06 14:33:13.956+00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, merchant_id, phone, address, status, driver_id, comment, "createdAt", "updatedAt") FROM stdin;
16	23	88606649	bgd 14r horoo. 6r bichil horoolol 85r tsetserleg zuun tald tenger eel hhk bair 2 davhar 2 toot	3	3	10	2025-07-04 09:03:13.99+00	2025-07-06 07:42:49.251+00
13	23	88606649	bgd 14r horoo. 6r bichil horoolol 85r tsetserleg zuun tald tenger eel hhk bair 2 davhar 2 toot	3	3	10	2025-07-02 08:51:16.61+00	2025-07-06 07:42:53.404+00
20	23	88606649	bgd 14r horoo. 6r bichil horoolol 85r tsetserleg zuun tald tenger eel hhk bair 2 davhar 2 toot	3	3	10	2025-07-06 08:54:39.171+00	2025-07-06 12:20:22.42+00
21	18	88077471	1 horoolol tsambagaraw 8r bair 	3	3	2 hurgelt	2025-07-06 11:52:36.198+00	2025-07-06 12:20:29.392+00
32	62	99021787	ХУД, и-март, 3-н давхарт кирей дэлгүүр	3	3	8/2-ны захиалга	2025-08-02 02:03:00.723+00	2025-08-08 02:38:12.011+00
27	62	99021787	ХУД, И-март, 3-н давхар кирей дэлгүүр	3	3	7/23-ны татан авалт 	2025-07-22 14:53:03.916+00	2025-07-30 15:28:44.053+00
30	58	80084081	Bayanzurh duureg 26-r horoo Santo smart hothon 714-r bair	3	3	Ванны тоглоомын багц-2 ш\nҮнэ-75к (1 багц)	2025-07-28 13:15:17.764+00	2025-07-30 15:28:49.995+00
31	18	88077471	1 horoolol tsambagaraw 8r bair 11 orts	3	3	2 hurgelt	2025-07-29 09:25:40.869+00	2025-07-30 15:28:54.306+00
24	18	88077471	1 хороолол 32 буудал Шинэ сандэй 4027	3	14	2	2025-07-08 10:11:51.404+00	2025-07-17 14:18:26.981+00
23	23	88606649	bgd 14r horoo. 6r bichil horoolol 85r tsetserleg zuun tald tenger eel hhk bair 2 davhar 2 toot	3	14	10	2025-07-08 08:58:24.726+00	2025-07-17 14:18:31.96+00
22	23	88606649	bgd 14r horoo. 6r bichil horoolol 85r tsetserleg zuun tald tenger eel hhk bair 2 davhar 2 toot	3	24	10	2025-07-07 09:01:27.98+00	2025-07-17 14:19:45.32+00
19	18	88077471	1 horoolol tsambagaraw 8r bair 11 orts	3	24	1	2025-07-05 11:26:36.568+00	2025-07-05 17:16:37.057+00
18	23	bgd 14r horoo. 6r bichil horoolol 85r tsetserleg zuun tald tenger eel hhk bair 2 davhar 2 toot	bgd 14r horoo. 6r bichil horoolol 85r tsetserleg zuun tald tenger eel hhk bair 2 davhar 2 toot	3	24	10	2025-07-05 09:09:26.659+00	2025-07-05 17:16:41.313+00
11	4	72107041	багшмйн дээд Танан төвийн мкм 24 байр хуучин хобби сургуулийн хажууд	3	3	.	2025-06-29 12:11:37.381+00	2025-07-06 07:42:07.66+00
12	4	99869623	хангай хотхоны баруун тал сүхбаатар дүүргийн татварын хэлтэст	3	3	.	2025-06-30 16:32:01.954+00	2025-07-06 07:42:14.766+00
15	4	88470099	Төв шуудангийн замын урд Эко товер 14 давхар 1403тоот ажлын цагаар 09:00-17:00	3	3	.	2025-07-03 13:56:18.178+00	2025-07-06 07:42:21.571+00
25	10	88031991	hud yarmag	3	3	11gj untana	2025-07-17 14:12:34.211+00	2025-07-30 15:29:04.438+00
17	18	88077471	1 horoolol tsambagaraw 8r bair	3	3	hurgelt 3	2025-07-04 11:36:32.992+00	2025-07-06 07:42:37.55+00
14	23	88606649	bgd 14r horoo. 6r bichil horoolol 85r tsetserleg zuun tald tenger eel hhk bair 2 davhar 2 too	3	3	10	2025-07-03 08:56:18.303+00	2025-07-06 07:42:43.584+00
28	62	99021787	ХУД, И-март, 3-н давхар кирей дэлгүүр	1	\N	7/26-ны захиалга	2025-07-26 04:30:41.059+00	2025-07-26 04:30:41.059+00
29	61	72122597	КТМС иин замын урд талд Баянбулаг төвийн 2 давхарт	3	14	Ачааг каргоноос очиж авах бөгөөд 94894994 дугаар дээр ирсэн ачааг авахюм. Карго төлбөр төлсөн. 7/27 ны өдөр 11-15 цаг хүртэл хагас ажиллана.	2025-07-27 05:02:57.765+00	2025-07-27 05:42:46.011+00
46	62	99021787	ХУД, И-март, 3-н давхар, кирей дэлгүүр	3	3	8/13-ны захиалга	2025-08-13 02:04:25.526+00	2025-08-22 08:02:54.864+00
44	62	99021787	ХУД,имарт,3-н давхар кирей дэлгүүр	3	3	8/12-ны захиалга	2025-08-12 02:23:16.56+00	2025-08-22 08:02:59.222+00
34	62	99021787	Хан-Уул, и-март, 3-н давхар кирей дэлгүүр	3	3	8/-4ний захиалга	2025-08-04 04:23:06.885+00	2025-08-08 02:38:02.112+00
33	62	99021787	ХУД, и-март, 3-н давхар кирей дэлгүүр	3	3	8/3-ны захиалга	2025-08-03 09:43:33.478+00	2025-08-08 02:38:06.788+00
35	62	99021787	ХУД, и-март, 3-н давхар Кирей дэлгүүр	3	3	8/4-ны захиалга	2025-08-04 10:04:37.273+00	2025-08-22 08:02:50.205+00
55	18	88077471	1 хороолол цамбагарав 8р байр 11 орц 	1	\N	1 хүргэлт	2025-08-25 09:38:43.928+00	2025-08-25 09:38:43.928+00
54	6	96141418	Бзд цагдаагын акдем монгол шуудан 32салбар дээр	3	3	08 сарын 18нд Өдөр 14 цагаас өмнө өгөх 	2025-08-16 03:51:24.496+00	2025-08-22 08:01:25.67+00
53	6	99122704	hud 23r horoo Yarmag hunnu mall in barun urd Shunshig villa2 hothn 61a 7toot	3	3	өдөртөө багтаж өгөх	2025-08-16 03:48:55.345+00	2025-08-22 08:01:39.212+00
52	6	99122704	hud 23r horoo Yarmag hunnu mall in barun urd Shunshig villa2 hothn 61a 7toot	3	3	өдөртөө багтаж өгөх	2025-08-16 03:48:55.065+00	2025-08-22 08:01:43.982+00
51	6	89941800	СХД 19 хороо 1.58-51 тоот	3	3	2025.08.17нд үдээс хойш өгөх	2025-08-16 03:46:47.608+00	2025-08-22 08:01:48.686+00
42	6	88541771 80044337	БЗД 39 хороо улаанхуаран эцэс 75а байр 1 орц 12 дав 113 тоот	3	3	Шилэн аяга учир хагарах эрсдэлтэй. 	2025-08-09 15:02:00.98+00	2025-08-22 08:01:53.374+00
40	6	94393779	Говь алтай Дарви сум нарантуул өргөтгөлөөс тавина 	3	3	тавих унааны дугаар 99999210\nунаанаас хоцроож болохгүй	2025-08-09 13:29:36.678+00	2025-08-22 08:01:57.785+00
41	6	99666920	Нарантуул захад хүргэж өгөх	3	3	Хүнд зүйлээр дарахгүй. 18 цагаас өмнө өгөх	2025-08-09 14:59:59.85+00	2025-08-22 08:02:02.048+00
36	6	88369606	БЗд 19р хороо газарчин 1р байр 24тоот	3	3	өдөртөө багтааж хүргэх	2025-08-07 14:43:42.739+00	2025-08-22 08:02:06.172+00
37	6	88125424	Оргил стар хотхон 59байр 3орц 8давхар 77тоот 	3	3	орцны код 5903#	2025-08-07 14:45:03.4+00	2025-08-22 08:02:11.373+00
38	6	86981089	БЗд 26р хороо элизабит хотхон баян монголын урд 214р байр 3орц 9давхар 213тоот	3	3	өдөртөө багтааж хүргэх	2025-08-07 14:46:30.448+00	2025-08-22 08:02:16.411+00
45	6	88082080	Зайсан улаанбаатар сувилал явах замд шүдний эмнэлэгтэй 55 байр 8 тоот	3	3	утсаар холбогдоод өгөх	2025-08-12 14:13:10.787+00	2025-08-22 08:02:20.414+00
39	18	88077471	1 horoolol taambagarw 8r bair	3	3	1 hurgelt	2025-08-08 12:37:16.345+00	2025-08-22 08:02:24.882+00
43	58	95568264	Нисэх, Eagle town хотхон, 436-р байр	3	3	bobdog цүнх-15ш(хар, цэнхэр, ягаан, нил ягаан), ванны багц-5ш, сандал-8ш(хар, шар), сүүдрэвч-18ш(3 өөр хэмжээтэй шар, цэнхэр, ногоон))	2025-08-10 05:42:45.209+00	2025-08-22 08:02:29.405+00
50	62	99021787	ХУД, и-март,3-н давхар кирей дэлгүүр	3	3	8/14-ны захиалга	2025-08-13 16:12:59.035+00	2025-08-22 08:02:33.453+00
49	62	99021787	ХУД, и-март,3-н давхар, кирей дэлгүүр	3	3	8/14-ний захиалга	2025-08-13 10:55:21.434+00	2025-08-22 08:02:37.583+00
48	62	99021787	ХУД, И-март,3-н давхар, кирей дэлгүүр	3	3	8/13-ны захиалга	2025-08-13 04:49:34.084+00	2025-08-22 08:02:41.605+00
47	62	99021787	ХУД, и-март, 3-н давхар, кирей дэлгүүр	3	3	8/13-ны захиалга	2025-08-13 03:39:45.384+00	2025-08-22 08:02:45.862+00
56	62	99021787	ХУД, и-март 3-н давхар кирей дэлгүүр, 	1	\N	8/26-ны захиалга	2025-08-26 02:29:27.034+00	2025-08-26 02:29:27.034+00
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, module, action, description, "createdAt", "updatedAt") FROM stdin;
1	delivery	create_delivery	create delivery	2025-06-06 12:16:33.3+00	2025-06-06 12:16:33.3+00
2	delivery	view_delivery	view delivery	2025-06-06 12:16:33.314+00	2025-06-06 12:16:33.314+00
3	delivery	update_delivery	update delivery	2025-06-06 12:16:33.319+00	2025-06-06 12:16:33.319+00
4	delivery	delete_delivery	delete delivery	2025-06-06 12:16:33.325+00	2025-06-06 12:16:33.325+00
5	delivery	allocate_delivery	allocate delivery	2025-06-06 12:16:33.33+00	2025-06-06 12:16:33.33+00
6	delivery	excel_import_delivery	excel_import delivery	2025-06-06 12:16:33.334+00	2025-06-06 12:16:33.334+00
7	delivery	manage_delivery	manage delivery	2025-06-06 12:16:33.339+00	2025-06-06 12:16:33.339+00
8	order	create_order	create order	2025-06-06 12:16:33.343+00	2025-06-06 12:16:33.343+00
9	order	view_order	view order	2025-06-06 12:16:33.347+00	2025-06-06 12:16:33.347+00
10	order	update_order	update order	2025-06-06 12:16:33.351+00	2025-06-06 12:16:33.351+00
11	order	delete_order	delete order	2025-06-06 12:16:33.354+00	2025-06-06 12:16:33.354+00
12	order	allocate_order	allocate order	2025-06-06 12:16:33.357+00	2025-06-06 12:16:33.357+00
13	order	excel_import_order	excel_import order	2025-06-06 12:16:33.36+00	2025-06-06 12:16:33.36+00
14	order	manage_order	manage order	2025-06-06 12:16:33.363+00	2025-06-06 12:16:33.363+00
15	product	create_product	create product	2025-06-06 12:16:33.366+00	2025-06-06 12:16:33.366+00
16	product	view_product	view product	2025-06-06 12:16:33.368+00	2025-06-06 12:16:33.368+00
17	product	update_product	update product	2025-06-06 12:16:33.371+00	2025-06-06 12:16:33.371+00
18	product	delete_product	delete product	2025-06-06 12:16:33.374+00	2025-06-06 12:16:33.374+00
19	product	allocate_product	allocate product	2025-06-06 12:16:33.377+00	2025-06-06 12:16:33.377+00
20	product	excel_import_product	excel_import product	2025-06-06 12:16:33.379+00	2025-06-06 12:16:33.379+00
21	product	manage_product	manage product	2025-06-06 12:16:33.382+00	2025-06-06 12:16:33.382+00
22	good	create_good	create good	2025-06-06 12:16:33.384+00	2025-06-06 12:16:33.384+00
23	good	view_good	view good	2025-06-06 12:16:33.387+00	2025-06-06 12:16:33.387+00
24	good	update_good	update good	2025-06-06 12:16:33.39+00	2025-06-06 12:16:33.39+00
25	good	delete_good	delete good	2025-06-06 12:16:33.393+00	2025-06-06 12:16:33.393+00
26	good	allocate_good	allocate good	2025-06-06 12:16:33.396+00	2025-06-06 12:16:33.396+00
27	good	excel_import_good	excel_import good	2025-06-06 12:16:33.4+00	2025-06-06 12:16:33.4+00
28	good	manage_good	manage good	2025-06-06 12:16:33.403+00	2025-06-06 12:16:33.403+00
29	user	create_user	create user	2025-06-06 12:16:33.405+00	2025-06-06 12:16:33.405+00
30	user	view_user	view user	2025-06-06 12:16:33.41+00	2025-06-06 12:16:33.41+00
31	user	update_user	update user	2025-06-06 12:16:33.415+00	2025-06-06 12:16:33.415+00
32	user	delete_user	delete user	2025-06-06 12:16:33.419+00	2025-06-06 12:16:33.419+00
33	user	allocate_user	allocate user	2025-06-06 12:16:33.422+00	2025-06-06 12:16:33.422+00
34	user	excel_import_user	excel_import user	2025-06-06 12:16:33.426+00	2025-06-06 12:16:33.426+00
35	user	manage_user	manage user	2025-06-06 12:16:33.428+00	2025-06-06 12:16:33.428+00
36	settings	create_settings	create settings	2025-06-06 12:16:33.431+00	2025-06-06 12:16:33.431+00
37	settings	view_settings	view settings	2025-06-06 12:16:33.434+00	2025-06-06 12:16:33.434+00
38	settings	update_settings	update settings	2025-06-06 12:16:33.436+00	2025-06-06 12:16:33.436+00
39	settings	delete_settings	delete settings	2025-06-06 12:16:33.439+00	2025-06-06 12:16:33.439+00
40	settings	allocate_settings	allocate settings	2025-06-06 12:16:33.443+00	2025-06-06 12:16:33.443+00
41	settings	excel_import_settings	excel_import settings	2025-06-06 12:16:33.447+00	2025-06-06 12:16:33.447+00
42	settings	manage_settings	manage settings	2025-06-06 12:16:33.45+00	2025-06-06 12:16:33.45+00
43	role	create_role	create role	2025-06-06 12:16:33.453+00	2025-06-06 12:16:33.453+00
44	role	view_role	view role	2025-06-06 12:16:33.456+00	2025-06-06 12:16:33.456+00
45	role	update_role	update role	2025-06-06 12:16:33.459+00	2025-06-06 12:16:33.459+00
46	role	delete_role	delete role	2025-06-06 12:16:33.462+00	2025-06-06 12:16:33.462+00
47	role	allocate_role	allocate role	2025-06-06 12:16:33.465+00	2025-06-06 12:16:33.465+00
48	role	excel_import_role	excel_import role	2025-06-06 12:16:33.468+00	2025-06-06 12:16:33.468+00
49	role	manage_role	manage role	2025-06-06 12:16:33.472+00	2025-06-06 12:16:33.472+00
50	warehouse	create_warehouse	create warehouse	2025-06-06 12:16:33.476+00	2025-06-06 12:16:33.476+00
51	warehouse	view_warehouse	view warehouse	2025-06-06 12:16:33.479+00	2025-06-06 12:16:33.479+00
52	warehouse	update_warehouse	update warehouse	2025-06-06 12:16:33.482+00	2025-06-06 12:16:33.482+00
53	warehouse	delete_warehouse	delete warehouse	2025-06-06 12:16:33.485+00	2025-06-06 12:16:33.485+00
54	warehouse	allocate_warehouse	allocate warehouse	2025-06-06 12:16:33.488+00	2025-06-06 12:16:33.488+00
55	warehouse	excel_import_warehouse	excel_import warehouse	2025-06-06 12:16:33.491+00	2025-06-06 12:16:33.491+00
56	warehouse	manage_warehouse	manage warehouse	2025-06-06 12:16:33.493+00	2025-06-06 12:16:33.493+00
57	status	create_status	create status	2025-06-06 12:16:33.496+00	2025-06-06 12:16:33.496+00
58	status	view_status	view status	2025-06-06 12:16:33.498+00	2025-06-06 12:16:33.498+00
59	status	update_status	update status	2025-06-06 12:16:33.501+00	2025-06-06 12:16:33.501+00
60	status	delete_status	delete status	2025-06-06 12:16:33.504+00	2025-06-06 12:16:33.504+00
61	status	allocate_status	allocate status	2025-06-06 12:16:33.507+00	2025-06-06 12:16:33.507+00
62	status	excel_import_status	excel_import status	2025-06-06 12:16:33.509+00	2025-06-06 12:16:33.509+00
63	status	manage_status	manage status	2025-06-06 12:16:33.512+00	2025-06-06 12:16:33.512+00
64	log	create_log	create log	2025-06-06 12:16:33.515+00	2025-06-06 12:16:33.515+00
65	log	view_log	view log	2025-06-06 12:16:33.517+00	2025-06-06 12:16:33.517+00
66	log	update_log	update log	2025-06-06 12:16:33.52+00	2025-06-06 12:16:33.52+00
67	log	delete_log	delete log	2025-06-06 12:16:33.522+00	2025-06-06 12:16:33.522+00
68	log	allocate_log	allocate log	2025-06-06 12:16:33.525+00	2025-06-06 12:16:33.525+00
69	log	excel_import_log	excel_import log	2025-06-06 12:16:33.528+00	2025-06-06 12:16:33.528+00
70	log	manage_log	manage log	2025-06-06 12:16:33.53+00	2025-06-06 12:16:33.53+00
71	dashboard	create_dashboard	create dashboard	2025-06-06 12:16:33.532+00	2025-06-06 12:16:33.532+00
72	dashboard	view_dashboard	view dashboard	2025-06-06 12:16:33.535+00	2025-06-06 12:16:33.535+00
73	dashboard	update_dashboard	update dashboard	2025-06-06 12:16:33.538+00	2025-06-06 12:16:33.538+00
74	dashboard	delete_dashboard	delete dashboard	2025-06-06 12:16:33.541+00	2025-06-06 12:16:33.541+00
75	dashboard	allocate_dashboard	allocate dashboard	2025-06-06 12:16:33.543+00	2025-06-06 12:16:33.543+00
76	dashboard	excel_import_dashboard	excel_import dashboard	2025-06-06 12:16:33.546+00	2025-06-06 12:16:33.546+00
77	dashboard	manage_dashboard	manage dashboard	2025-06-06 12:16:33.548+00	2025-06-06 12:16:33.548+00
78	region	create_region	create region	2025-06-06 12:16:33.55+00	2025-06-06 12:16:33.55+00
79	region	view_region	view region	2025-06-06 12:16:33.552+00	2025-06-06 12:16:33.552+00
80	region	update_region	update region	2025-06-06 12:16:33.555+00	2025-06-06 12:16:33.555+00
81	region	delete_region	delete region	2025-06-06 12:16:33.558+00	2025-06-06 12:16:33.558+00
82	region	allocate_region	allocate region	2025-06-06 12:16:33.56+00	2025-06-06 12:16:33.56+00
83	region	excel_import_region	excel_import region	2025-06-06 12:16:33.562+00	2025-06-06 12:16:33.562+00
84	region	manage_region	manage region	2025-06-06 12:16:33.565+00	2025-06-06 12:16:33.565+00
85	notification	create_notification	create notification	2025-06-06 12:16:33.572+00	2025-06-06 12:16:33.572+00
86	notification	view_notification	view notification	2025-06-06 12:16:33.576+00	2025-06-06 12:16:33.576+00
87	notification	update_notification	update notification	2025-06-06 12:16:33.578+00	2025-06-06 12:16:33.578+00
88	notification	delete_notification	delete notification	2025-06-06 12:16:33.58+00	2025-06-06 12:16:33.58+00
89	notification	allocate_notification	allocate notification	2025-06-06 12:16:33.583+00	2025-06-06 12:16:33.583+00
90	notification	excel_import_notification	excel_import notification	2025-06-06 12:16:33.586+00	2025-06-06 12:16:33.586+00
91	notification	manage_notification	manage notification	2025-06-06 12:16:33.588+00	2025-06-06 12:16:33.588+00
92	reports	create_reports	create reports	2025-06-06 12:16:33.591+00	2025-06-06 12:16:33.591+00
93	reports	view_reports	view reports	2025-06-06 12:16:33.594+00	2025-06-06 12:16:33.594+00
94	reports	update_reports	update reports	2025-06-06 12:16:33.597+00	2025-06-06 12:16:33.597+00
95	reports	delete_reports	delete reports	2025-06-06 12:16:33.599+00	2025-06-06 12:16:33.599+00
96	reports	allocate_reports	allocate reports	2025-06-06 12:16:33.602+00	2025-06-06 12:16:33.602+00
97	reports	excel_import_reports	excel_import reports	2025-06-06 12:16:33.605+00	2025-06-06 12:16:33.605+00
98	reports	manage_reports	manage reports	2025-06-06 12:16:33.608+00	2025-06-06 12:16:33.608+00
\.


--
-- Data for Name: privacies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.privacies (id, privacy, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name, status, "catId", description, stock, image, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, lastname, firstname, email, role, phone, isactive, school, member_type, start_date, end_date, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.regions (id, name, "createdAt", "updatedAt") FROM stdin;
6	baruun bus 	2025-08-09 06:44:22.387+00	2025-08-09 06:44:22.387+00
7	zuun bus	2025-08-09 06:44:36.318+00	2025-08-09 06:44:36.318+00
8	hoid bus	2025-08-09 06:44:44.001+00	2025-08-09 06:44:44.001+00
9	urd bus	2025-08-09 06:44:50.959+00	2025-08-09 06:44:50.959+00
\.


--
-- Data for Name: requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requests (id, ware_id, merchant_id, stock, status, good_id, name, type, "createdAt", "updatedAt") FROM stdin;
10	1	22	12	2	\N	sandaal	1	2025-07-01 16:04:29.202+00	2025-07-02 02:59:29.202+00
9	1	22	12	3	\N	Sandaal	1	2025-07-01 15:59:15.031+00	2025-07-02 02:59:33.457+00
11	1	16	115	2	\N	mashini narnii haalt	1	2025-07-03 07:04:43.798+00	2025-07-03 07:04:53.79+00
12	1	19	91	2	\N	moringa	1	2025-07-03 07:07:01.419+00	2025-07-03 07:07:03.551+00
13	1	17	15	2	\N	kamer 	1	2025-07-03 07:07:42.031+00	2025-07-03 07:07:44.323+00
14	1	17	10	2	\N	naran tsetseg 	1	2025-07-03 07:08:33.438+00	2025-07-03 07:08:35.15+00
15	1	26	50	2	\N	mashinii tsonhnii tor	1	2025-07-03 07:09:59.232+00	2025-07-03 07:10:03.484+00
18	1	17	5	2	\N	lampan gerel	1	2025-07-03 07:29:47.195+00	2025-07-03 07:29:50.915+00
19	1	17	3	2	\N	400 batt	1	2025-07-03 07:30:58.823+00	2025-07-03 07:30:59.951+00
20	1	17	3	2	\N	geriin jijig kamer	1	2025-07-03 07:31:47.988+00	2025-07-03 07:31:49.187+00
21	1	17	2	2	\N	kamer gerel	1	2025-07-03 07:32:37.505+00	2025-07-03 07:33:22.435+00
31	1	77	30	2	\N	har batga mask	1	2025-08-23 02:43:57.127+00	2025-08-23 02:45:24.574+00
30	2	77	56	2	\N	nuurnii begnuur	1	2025-08-23 02:43:00.805+00	2025-08-23 02:45:25.76+00
29	1	77	20	2	\N	huwtsas tsairuulagch	1	2025-08-23 02:42:47.065+00	2025-08-23 02:45:28.265+00
28	1	77	18	2	\N	hyalbar wax	1	2025-08-23 02:42:32.7+00	2025-08-23 02:45:29.641+00
27	2	77	60	2	\N	tamhinii filter	1	2025-08-23 02:42:19.898+00	2025-08-23 02:45:30.902+00
26	1	77	60	2	\N	bugiin evertei uvchin namdaah tos	1	2025-08-23 02:42:03.774+00	2025-08-23 02:45:31.67+00
25	1	77	30	2	\N	humsugni hew harandaa pretka	1	2025-08-23 02:41:43.733+00	2025-08-23 02:45:32.988+00
24	1	77	30	2	\N	avtomat hamarnii us awagch	1	2025-08-23 02:41:14.149+00	2025-08-23 02:45:34.099+00
23	1	77	60	2	\N	shudni oo	1	2025-08-23 02:40:49.983+00	2025-08-23 02:45:35.047+00
22	1	77	60	2	\N	hairst uldni tos	1	2025-08-23 02:40:09.422+00	2025-08-23 02:45:35.747+00
32	1	26	50	2	35	\N	3	2025-08-23 08:06:49.568+00	2025-08-24 05:16:37.26+00
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_id, permission_id) FROM stdin;
1	1
1	2
1	3
1	4
1	5
1	6
1	7
1	8
1	9
1	10
1	11
1	12
1	13
1	14
1	15
1	16
1	17
1	18
1	19
1	20
1	21
1	22
1	23
1	24
1	25
1	26
1	27
1	28
1	29
1	30
1	31
1	32
1	33
1	34
1	35
1	36
1	37
1	38
1	39
1	40
1	41
1	42
1	43
1	44
1	45
1	46
1	47
1	48
1	49
1	50
1	51
1	52
1	53
1	54
1	55
1	56
1	57
1	58
1	59
1	60
1	61
1	62
1	63
1	64
1	65
1	66
1	67
1	68
1	69
1	70
1	71
1	72
1	73
1	74
1	75
1	76
1	77
1	78
1	79
1	80
1	81
1	82
1	83
1	84
1	85
1	86
1	87
1	88
1	89
1	90
1	91
1	92
1	93
1	94
1	95
1	96
1	97
1	98
2	1
2	2
2	3
2	4
2	5
2	7
2	8
2	9
2	10
2	11
2	12
2	14
2	22
2	23
2	24
2	25
2	26
2	28
2	71
2	72
2	73
2	74
2	75
2	76
2	77
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, "createdAt", "updatedAt") FROM stdin;
1	admin	2025-06-06 10:16:26.724+00	2025-06-06 10:16:26.724+00
2	customer	2025-06-06 10:16:41.539+00	2025-06-06 10:16:41.539+00
3	driver	2025-06-06 10:16:45.194+00	2025-06-06 10:16:45.194+00
\.


--
-- Data for Name: statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.statuses (id, status, color, "createdAt", "updatedAt") FROM stdin;
1	шинэ	yellow	2025-06-06 12:36:36.446+00	2025-06-06 12:36:36.446+00
2	жолоочид	blue	2025-06-06 12:36:51.531+00	2025-06-06 12:36:51.531+00
3	хүргэгдсэн	green	2025-06-06 12:36:58.879+00	2025-06-06 12:36:58.879+00
5	буцаасан	orange	2025-06-06 12:37:09.247+00	2025-06-06 12:37:09.247+00
7	хаягаар очсон	indigo	2025-07-03 13:19:11.84+00	2025-07-03 13:19:11.84+00
8	дараа авна	brown	2025-07-03 13:19:46.229+00	2025-07-03 13:19:46.229+00
9	маргааш авна	cyan	2025-07-06 08:06:34.605+00	2025-07-06 08:06:34.605+00
6	утсаа аваагүй	purple	2025-06-06 12:59:22.57+00	2025-06-06 12:59:22.57+00
\.


--
-- Data for Name: summaries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.summaries (id, merchant_id, number_delivery, total, driver, account, comment, driver_id, "createdAt", "updatedAt") FROM stdin;
1	\N	10	349400.00	40000.00	309400.00	0	24	2025-07-05 11:14:26.63+00	2025-07-05 11:14:26.63+00
2	\N	19	977900.00	76000.00	901900.00	0	8	2025-07-18 12:08:11.982+00	2025-07-18 12:08:11.982+00
3	\N	12	182000.00	48000.00	134000.00	0	14	2025-07-22 05:03:44.779+00	2025-07-22 05:03:44.779+00
6	\N	12	278000.00	48000.00	230000.00	0	14	2025-07-22 05:07:54.011+00	2025-07-22 05:07:54.011+00
7	\N	5	150001.00	20000.00	130001.00	0	14	2025-07-25 06:14:48.823+00	2025-07-25 06:14:48.823+00
8	\N	11	649000.00	44000.00	605000.00	0	14	2025-07-25 06:15:20.101+00	2025-07-25 06:15:20.101+00
9	\N	7	190900.00	28000.00	162900.00	0	14	2025-07-25 06:15:33.971+00	2025-07-25 06:15:33.971+00
10	\N	11	919000.00	44000.00	875000.00	0	9	2025-07-25 06:16:46.594+00	2025-07-25 06:16:46.594+00
11	\N	11	297000.70	44000.00	253000.70	0	9	2025-07-25 06:17:06.422+00	2025-07-25 06:17:06.422+00
14	\N	8	458000.00	32000.00	426000.00	0	14	2025-07-27 04:04:40.902+00	2025-07-27 04:04:40.902+00
15	\N	11	331003.00	44000.00	287003.00	0	9	2025-07-27 05:28:48.891+00	2025-07-27 05:28:48.891+00
16	\N	40	2400000.00	160000.00	2240000.00	0	14	2025-07-30 15:10:50.853+00	2025-07-30 15:10:50.853+00
17	\N	15	247000.00	60000.00	187000.00	0	9	2025-08-08 02:44:31.451+00	2025-08-08 02:44:31.451+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, role_id, phone, email, "createdAt", "updatedAt") FROM stdin;
1	admin	$2b$10$pXXJZTHW8Sgt0N8bz2LA5uH9ZkFhiJAQ9gf8sQ.elX0Xjt1kDKgLy	1	88064537	bayka.lkh@gmail.com	2025-06-06 10:18:34.556+00	2025-06-06 10:18:34.556+00
2	fourfeeling	$2b$10$en9l2NxdcQuRYqQI3RT9fehAf5BKYDB/CYkB39nnR8uTdPhCF9HLu	2	96697888	fourfeeling@gmail.com	2025-06-06 12:20:36.602+00	2025-06-06 12:20:36.602+00
3	seku	$2b$10$RCzq9SLQc6x/5KSao3nTDO250hRW.lvY8WkvuneTR4T88QmmySAAm	3	90095797	seku@gmail.com	2025-06-06 12:21:30.71+00	2025-06-06 12:21:30.71+00
4	har suvd	$2b$10$vQSQ7kKhwGygjPAdr5cJkOmmChXHl5NlL9uQE9hYi/QDx4nYY4bHq	2	90990429	harsuvd@gmail.com	2025-06-06 13:10:25.54+00	2025-06-06 13:10:25.54+00
6	mogjoohon jogjoohon	$2b$10$6C3mIPt9llAh.bQtkYybhusdPMhB4T46jCkA1yAwMDjf.MjT10G0a	2	88212051	mj@gmail.com	2025-06-06 13:13:10.403+00	2025-06-06 13:13:10.403+00
7	103	$2b$10$q2qbpDRPbK3zsPseBbKTdOdfAvDj44BwfUZLE.nT7lZF9lWzd05RO	2	99904475	103@gmail.com	2025-06-06 13:13:46.058+00	2025-06-06 13:13:46.058+00
8	hosoo	$2b$10$k865l9LSVqhts.wix12laOzpAQ9n9n6UI5YHu8HTLTpa6ZjUR5yGu	3	85303522	hosoo@gmail.com	2025-06-16 10:32:16.104+00	2025-06-16 10:32:16.104+00
9	Roma	$2b$10$Hdd/LZzKdlrQjAxT.pt9D.wkOoeUdAqnbIMOSdexHcxqenOG9.s6u	3	95683171	Roma@gmail.com	2025-06-16 10:33:51.299+00	2025-06-16 10:33:51.299+00
10	seku online shop	$2b$10$P.IrwAGs3cM1QJJaJ7EMGO7Rk.9qnLDPbi0/B2T.t2s4aH/ydZQim	2	88031991	seku@gmail.com	2025-06-16 10:42:47.8+00	2025-06-16 10:42:47.8+00
11	super nova	$2b$10$TTPRfhlewSs9K8CKvLvYz.0DKF7W14AeCLZiADtJzcQAG4TcAGe6e	2	99280145	super nova @gmail.com	2025-06-17 09:11:26.844+00	2025-06-17 09:11:26.844+00
14	tema	$2b$10$W/alLLBaCzUco6nUoWoTxeSp9cFavei6nleW6svktEqS7uCLRP7Si	3	95713161	tema@gmail.com	2025-06-29 10:45:12.004+00	2025-06-29 10:45:12.004+00
15	M blanc 	$2b$10$fkjebNy1b9qv3ZSLLQ47muZcLhHKNlC0Gc8icPCJCuIkHSAIZa9sG	2	99035829	M blanc@gmail.com	2025-06-29 10:50:09.117+00	2025-06-29 10:50:09.117+00
16	undarga shop	$2b$10$e4u4h6RSrKgUIar94gnFA.6mUCi7Un5tfjGdXrplW3F.1t2eczZdq	2	88018953	undarga@gmail.com	2025-06-30 15:07:20.157+00	2025-06-30 15:07:20.157+00
17	solar tech	$2b$10$wIM.GlktbjmyN0XxezSWCuBkMt61FWfQo/3K6OtlO6Br8jOMOvLiy	2	86870620	Solar@gmail.com	2025-06-30 15:10:09.745+00	2025-06-30 15:10:09.745+00
18	Toorkhon fashion shop	$2b$10$640KqdhdB5t8u3ckZ2yA4u1ab7F.QtZYu5VpS4Gik/nOZ0EZSwiRC	2	88077471	Toorkhon@gmail.com	2025-06-30 15:13:14.676+00	2025-06-30 15:13:14.676+00
19	eruul orshihui	$2b$10$0MvDiDhugZtkSjsja.UU3uNIkxZ8WAOFGxHnB6jjE5kFVy.TH0vtG	2	94682188	eruul@gmail.com	2025-06-30 15:15:45.11+00	2025-06-30 15:15:45.11+00
20	m blanc	$2b$10$7PpRlB8b9ZdJ5vxC6DiIS.NQTojpvD7yweF4AyccLVLNVG7VvFwFS	2	99035829	blanc@gmail.com	2025-06-30 15:21:15.035+00	2025-06-30 15:21:15.035+00
21	suvdhan shop	$2b$10$1mHW5wz5rv8ESDkfSFZr3OF0VSORq7ZCuSXbJ2S11zJ24Jbfev/1S	2	99231930	shuvdhan@gmail.com	2025-07-01 01:50:13.325+00	2025-07-01 01:50:13.325+00
22	Egshiglen shop	$2b$10$DSQL5ZPfx.6hmXT.pUum/OdA8ix9LEbFAIu1B3k/zq.XwAf8Ni5h.	2	99300713	egshiglen@gmail.com	2025-07-01 09:29:55.159+00	2025-07-01 09:29:55.159+00
23	uj shop	$2b$10$a8E.PmgmPeGd0yEPEMknUu1.rYG6gN.eblipKzjKw3/.xX3vR0vn6	2	88606649	uj@gmail.com	2025-07-01 11:27:30.661+00	2025-07-01 11:27:30.661+00
24	aldaraa	$2b$10$z2OGz3wHDiaSwT3AvFXBWeYUuekk/tTjosbvhq0g.DYhqTjID6vLK	3	88053358	aldaraa@gmail.com	2025-07-02 02:38:59.85+00	2025-07-02 02:38:59.85+00
26	ub76	$2b$10$mR4KMe4UQUpjXzLGTiJl0O5EJmQnbdLP5W6F7i4aaM89vozjNqyOy	2	90084007	ub76@gmail.com	2025-07-02 09:41:55.433+00	2025-07-02 09:41:55.433+00
31	Enkh Esen	$2b$10$8Q7MkXqjSpYLFg0QEIPzN.cm90uTLvbBRlNmN/dUvd8MVJ9cG4JkG	2	99689213	Enkh Esen@gmail.com	2025-07-04 07:02:18.347+00	2025-07-04 07:02:18.347+00
46	Negma	$2b$10$gUaDsa8t9LWnbObrtyMci.CMIhxqU2rYK4gxhSo8GDk2uxqTllXu.	2	99235552	Negma@gmail.com	2025-07-04 07:12:38.899+00	2025-07-04 07:12:38.899+00
48	test	$2b$10$AovaW9VUoPJXnInXJDS/v.AeY/wJ7Bm6QpWlMfKVsIQJO4wNJeYAS	2	88064537	testdriver@gmail.com	2025-07-07 12:15:31.301+00	2025-07-07 12:15:31.301+00
50	haliuna	$2b$10$D47Spq3MpyxpXmJkCkfyn.T3Cg07iE312GAMtLfUiG0wGbAHKmYHS	3	99133154	haliuna@gmail.com	2025-07-16 06:35:26.595+00	2025-07-16 06:35:26.595+00
52	ou shop	$2b$10$W6CCeqZCBjDNTHulIGZUjOeG3m7BrtPxy8oCETaa4KLVvKjVOvQHG	2	90817060	ou shop@gmail.com	2025-07-19 04:36:52.285+00	2025-07-19 04:36:52.285+00
54	eye massge	$2b$10$IKr.t3xGtMJP3NYnh0OAQO6iwMZ4pf3Zp92WM7C7E5Dgyr9UzJ0sO	2	88441240	eye massge@gmail.com	2025-07-21 04:03:02.002+00	2025-07-21 04:03:02.002+00
58	arail hymd delguur	$2b$10$nqKiQDCrSt7UZucUptKbROqXYwbu.jOjasfOb/gEwoEZq7UJfssTS	2	99988007	arail hymd@gmail.com	2025-07-21 04:09:47.425+00	2025-07-21 04:09:47.425+00
59	khalk store	$2b$10$Uzi6TXdCOzdb6ezWnlWHYeMqBiv6L5Wb2CI.fuJifHKhvagWHC2yW	2	88580646	khalk store@gmail.com	2025-07-21 16:21:05.184+00	2025-07-21 16:21:05.184+00
60	amar home shop	$2b$10$V7kPAe12WK6C0lFDS.Eh8OX/p7B521W/y6b6ZVQj6ju93eA3bGtDG	2	95997770	amar home@gmail.com	2025-07-22 05:21:19.88+00	2025-07-22 05:21:19.88+00
61	home trend 24/7	$2b$10$ODp0rru1HgB93FKngohg...T.Q/nHVu9Mn2.Su8LTihshsEMaXaGW	2	89936389	home trend@gmail.com	2025-07-22 10:20:29.846+00	2025-07-22 10:20:29.846+00
62	sora japan store	$2b$10$bIBgBled2HD/Hy9Wt6wENOAciw5VSw.9/V0SXgxAdekCtxalN8.5y	2	99021787	solongo@gmail.com	2025-07-22 14:39:16.389+00	2025-07-22 14:39:16.389+00
63	sunpharma	$2b$10$mD2.ZExq3qE6JtQYaWl80u/DJ.EyUf2UrYdve3NHy64XQXX7jR63O	2	90100140	sunpharma@gmail.com	2025-07-23 05:24:07.299+00	2025-07-23 05:24:07.299+00
64	shine store	$2b$10$vmJahR5IjGo0sIrctFP9MOCdjtE8162StsxVH1l79KHd/bLHicIZm	2	80675008	shine store@gmail.com	2025-07-23 05:41:28.746+00	2025-07-23 05:41:28.746+00
65	baaska	$2b$10$iTuqMgBCGsU4p44BCPk9huNYfV35Fqzy6gSVHaCFLc8V.AGXIAbP.	3	85785029	baaska@gmail.com	2025-07-23 07:23:50.703+00	2025-07-23 07:23:50.703+00
66	zulaaa	$2b$10$CbeszSogXuOlb2f8JMuFgulkFgzvn5qXShluTnl83w.UvTvk7dTmm	3	88031991	ou@gmail.com	2025-07-23 07:45:42.261+00	2025-07-23 07:45:42.261+00
67	tsatsaa	$2b$10$.O2dNBCG58ddBGdoUvdwYOE1R9TNklm/oYUiWEognceBTNzdWW1om	3	88052898	tsatsaa@gmail.com	2025-07-29 05:02:14.442+00	2025-07-29 05:02:14.442+00
68	tsendee	$2b$10$ncULQ3wanVdwfTMqEyLuLOHG6p77h1/lLf5uGzGC59ERjExJEAwLW	3	88126326	tsendee@gmail.com	2025-08-15 01:48:29.239+00	2025-08-15 01:48:29.239+00
69	bayraaa	$2b$10$FNCCNyX5gO8AI/O489toouRm18MBXyaU3K0ZTH5ApVR/X5IiC/iPC	3	99376851	bayraa@gmail.com	2025-08-15 01:51:49.556+00	2025-08-15 01:51:49.556+00
70	huugiin gutal	$2b$10$ZH/u29imt5leVtu01dTLVu5Nu.uh514OLXqDIsztY5P9TnEvz0orq	2	88068988	huu@gmail.com	2025-08-18 05:32:00.789+00	2025-08-18 05:32:00.789+00
71	Duudee	$2b$10$Sq8Ecd3gFLPdFD9p0tT3r.LxKyqgt34FIhDom6hNeAGlqd992RDoy	2	90551155	Duudee@gmail.com	2025-08-21 17:55:46.767+00	2025-08-21 17:55:46.767+00
72	Mongol 87 shop	$2b$10$Hp8BdB3d9figPCFozbc8IeAnFQ2EBBY5j5XQ2pZhlMdVLZMhc2gwu	2	85119548	Mongol 87 shop@gmail.com	2025-08-21 17:59:34.409+00	2025-08-21 17:59:34.409+00
73	bathuu	$2b$10$xR6AGwf3lsoOHTWcJml/T.tbYT8LNlFsEHY4VOeamW3eF7N1DhdDy	3	94146700	bathuu@gmail.com	2025-08-22 05:18:29.916+00	2025-08-22 05:18:29.916+00
75	Гэгээхэй online shop	$2b$10$fX8MtQ9BUXmW8eRLGBxo3uuUjKQmS3WYBQEJcmpR6ypXg4KMnjoTe	2	88003194	Гэгээхэй online shop@gmail.com	2025-08-22 05:46:05.55+00	2025-08-22 05:46:05.55+00
76	bambaruushtai	$2b$10$RATxm2q8uTFg9zSLL84uJOsbvkXMjzHh67TDfS/wabEvM0Jk4bbtu	2	88087137	bambaruushtai@gmail.com	2025-08-22 06:56:46.104+00	2025-08-22 06:56:46.104+00
77	Modo shop	$2b$10$VuUazb4V/wHNMbju4BMNaOT3p4oB85E8xSo1GVKrcvd3vXPQF68rO	2	77457070	Modo shop@gmail.com	2025-08-22 11:32:35.22+00	2025-08-22 11:32:35.22+00
78	Marlaa	$2b$10$Q20lN7PGsxJs5AuTwOcGFejuljQr.PIyDsCXVGuLJB5aybrftSvWe	3	88081666	Marlaa@gmail.com	2025-08-23 04:08:20.847+00	2025-08-23 04:08:20.847+00
81	Feel.mn	$2b$10$ZJ/wgj5EovL4Fw6xRqZaReYmjuttlABpqKXBBf0TsBMoW6/vZD.GO	2	96461881	Feel@gmail.com	2025-08-24 11:21:38.139+00	2025-08-24 11:21:38.139+00
82	Lite store	$2b$10$TbJ/wjbvb6fUcGx0a0d8qO8y41oIO5Gv8JYkFwlruBo4oO7NVuOMy	2	89801796	Lite@gmail.com	2025-08-25 01:42:27.509+00	2025-08-25 01:42:27.509+00
84	boxmongolia	$2b$10$Kp5yOcW6aLVngFkw2TkrOuimtfr6YCXSQ5tpkVs8F/PJvkmGDYGPy	2	88034546	box@gmail.com	2025-08-25 03:41:51.728+00	2025-08-25 03:41:51.728+00
\.


--
-- Data for Name: wares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wares (id, name, "createdAt", "updatedAt") FROM stdin;
1	localexpress	2025-06-06 10:35:18.964+00	2025-06-06 10:35:18.964+00
2	localexpress	2025-06-06 10:35:23.303+00	2025-06-06 10:35:23.303+00
\.


--
-- Data for Name: words; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.words (id, ware_id, merchant_id, stock, name, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: Logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Logs_id_seq"', 1, false);


--
-- Name: ProductImages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ProductImages_id_seq"', 1, false);


--
-- Name: ages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ages_id_seq', 1, false);


--
-- Name: banners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.banners_id_seq', 1, false);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 1, false);


--
-- Name: deliveries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deliveries_id_seq', 2398, true);


--
-- Name: delivery_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.delivery_items_id_seq', 482, true);


--
-- Name: doctors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctors_id_seq', 1, false);


--
-- Name: goods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goods_id_seq', 75, true);


--
-- Name: infos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.infos_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 56, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 98, true);


--
-- Name: privacies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.privacies_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 1, false);


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profiles_id_seq', 1, false);


--
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.regions_id_seq', 9, true);


--
-- Name: requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.requests_id_seq', 32, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 3, true);


--
-- Name: statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statuses_id_seq', 9, true);


--
-- Name: summaries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.summaries_id_seq', 17, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 85, true);


--
-- Name: wares_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wares_id_seq', 2, true);


--
-- Name: words_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.words_id_seq', 1, false);


--
-- Name: Logs Logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Logs"
    ADD CONSTRAINT "Logs_pkey" PRIMARY KEY (id);


--
-- Name: ProductImages ProductImages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ProductImages"
    ADD CONSTRAINT "ProductImages_pkey" PRIMARY KEY (id);


--
-- Name: ages ages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ages
    ADD CONSTRAINT ages_pkey PRIMARY KEY (id);


--
-- Name: banners banners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banners
    ADD CONSTRAINT banners_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: deliveries deliveries_delivery_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_delivery_id_key UNIQUE (delivery_id);


--
-- Name: deliveries deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_pkey PRIMARY KEY (id);


--
-- Name: delivery_items delivery_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_items
    ADD CONSTRAINT delivery_items_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: goods goods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goods
    ADD CONSTRAINT goods_pkey PRIMARY KEY (id);


--
-- Name: infos infos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.infos
    ADD CONSTRAINT infos_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: privacies privacies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privacies
    ADD CONSTRAINT privacies_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: requests requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: statuses statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- Name: summaries summaries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summaries
    ADD CONSTRAINT summaries_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wares wares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wares
    ADD CONSTRAINT wares_pkey PRIMARY KEY (id);


--
-- Name: words words_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.words
    ADD CONSTRAINT words_pkey PRIMARY KEY (id);


--
-- Name: deliveries deliveries_driver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: deliveries deliveries_merchant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: deliveries deliveries_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_status_fkey FOREIGN KEY (status) REFERENCES public.statuses(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: delivery_items delivery_items_delivery_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_items
    ADD CONSTRAINT delivery_items_delivery_id_fkey FOREIGN KEY (delivery_id) REFERENCES public.deliveries(id) ON DELETE CASCADE;


--
-- Name: delivery_items delivery_items_good_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_items
    ADD CONSTRAINT delivery_items_good_id_fkey FOREIGN KEY (good_id) REFERENCES public.goods(id) ON DELETE SET NULL;


--
-- Name: goods goods_merchant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goods
    ADD CONSTRAINT goods_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: goods goods_ware_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goods
    ADD CONSTRAINT goods_ware_id_fkey FOREIGN KEY (ware_id) REFERENCES public.wares(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders orders_driver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders orders_merchant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: requests requests_good_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_good_id_fkey FOREIGN KEY (good_id) REFERENCES public.goods(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: requests requests_merchant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: requests requests_ware_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_ware_id_fkey FOREIGN KEY (ware_id) REFERENCES public.wares(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: summaries summaries_driver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summaries
    ADD CONSTRAINT summaries_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: summaries summaries_merchant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summaries
    ADD CONSTRAINT summaries_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

