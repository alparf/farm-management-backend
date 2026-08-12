--
-- PostgreSQL database dump
--

\restrict yYs7sIWrNUieqGZCIv7U78KabDF1KTRxetmKptHTz6wPiCtECtdU6xWBXZyknmR

-- Dumped from database version 15.18 (Debian 15.18-1.pgdg13+1)
-- Dumped by pg_dump version 15.18 (Debian 15.18-1.pgdg13+1)

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

--
-- Name: inventory_transactions_referencetype_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.inventory_transactions_referencetype_enum AS ENUM (
    'TREATMENT',
    'MANUAL_IN',
    'MANUAL_ADJUST',
    'MANUAL_OUT'
);


ALTER TYPE public.inventory_transactions_referencetype_enum OWNER TO postgres;

--
-- Name: inventory_transactions_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.inventory_transactions_type_enum AS ENUM (
    'IN',
    'OUT',
    'ADJUSTMENT'
);


ALTER TYPE public.inventory_transactions_type_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    name character varying NOT NULL,
    phone character varying,
    address character varying,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.clients OWNER TO postgres;

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clients_id_seq OWNER TO postgres;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: equipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    type character varying(50) NOT NULL,
    model character varying(100),
    "serialNumber" character varying(100),
    "verificationDate" date NOT NULL,
    notes text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.equipment OWNER TO postgres;

--
-- Name: equipment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.equipment_id_seq OWNER TO postgres;

--
-- Name: equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipment_id_seq OWNED BY public.equipment.id;


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    type character varying(50) NOT NULL,
    unit character varying(20) NOT NULL,
    notes text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.inventory OWNER TO postgres;

--
-- Name: inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_id_seq OWNER TO postgres;

--
-- Name: inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_id_seq OWNED BY public.inventory.id;


--
-- Name: inventory_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_transactions (
    id integer NOT NULL,
    "productId" integer NOT NULL,
    type public.inventory_transactions_type_enum NOT NULL,
    quantity numeric(10,3) NOT NULL,
    "balanceAfter" numeric(10,3) NOT NULL,
    "referenceType" public.inventory_transactions_referencetype_enum,
    "referenceId" integer,
    description text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.inventory_transactions OWNER TO postgres;

--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_transactions_id_seq OWNER TO postgres;

--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_transactions_id_seq OWNED BY public.inventory_transactions.id;


--
-- Name: maintenance_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maintenance_records (
    id integer NOT NULL,
    "vehicleId" integer NOT NULL,
    "vehicleName" character varying(200) NOT NULL,
    type character varying(50) NOT NULL,
    date date NOT NULL,
    hours numeric(8,1),
    description text NOT NULL,
    notes text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.maintenance_records OWNER TO postgres;

--
-- Name: maintenance_records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.maintenance_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.maintenance_records_id_seq OWNER TO postgres;

--
-- Name: maintenance_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.maintenance_records_id_seq OWNED BY public.maintenance_records.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying NOT NULL,
    unit character varying NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
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
-- Name: shipment_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipment_items (
    id integer NOT NULL,
    "shipmentId" integer NOT NULL,
    "productId" integer NOT NULL,
    quantity numeric(10,2) NOT NULL,
    "returnQuantity" numeric(10,2),
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "pricePerUnit" numeric(10,2) DEFAULT '0'::numeric NOT NULL
);


ALTER TABLE public.shipment_items OWNER TO postgres;

--
-- Name: shipment_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shipment_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shipment_items_id_seq OWNER TO postgres;

--
-- Name: shipment_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shipment_items_id_seq OWNED BY public.shipment_items.id;


--
-- Name: shipments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipments (
    id integer NOT NULL,
    "clientId" integer NOT NULL,
    date date NOT NULL,
    notes text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.shipments OWNER TO postgres;

--
-- Name: shipments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shipments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shipments_id_seq OWNER TO postgres;

--
-- Name: shipments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shipments_id_seq OWNED BY public.shipments.id;


--
-- Name: treatment_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.treatment_products (
    id integer NOT NULL,
    "productId" integer NOT NULL,
    "ratePerHa" numeric(10,2) NOT NULL,
    unit character varying(10) DEFAULT 'л/га'::character varying NOT NULL,
    "treatmentId" integer NOT NULL
);


ALTER TABLE public.treatment_products OWNER TO postgres;

--
-- Name: treatment_products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.treatment_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.treatment_products_id_seq OWNER TO postgres;

--
-- Name: treatment_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.treatment_products_id_seq OWNED BY public.treatment_products.id;


--
-- Name: treatments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.treatments (
    id integer NOT NULL,
    culture character varying(100) NOT NULL,
    area numeric(10,2) NOT NULL,
    completed boolean DEFAULT false NOT NULL,
    "dueDate" date,
    "actualDate" date,
    "isTankMix" boolean DEFAULT false NOT NULL,
    "hasCompatibilityIssues" boolean DEFAULT false NOT NULL,
    "compatibilityWarnings" text,
    notes text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.treatments OWNER TO postgres;

--
-- Name: treatments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.treatments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.treatments_id_seq OWNER TO postgres;

--
-- Name: treatments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.treatments_id_seq OWNED BY public.treatments.id;


--
-- Name: vehicles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicles (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    type character varying(50) NOT NULL,
    model character varying(100),
    year integer,
    vin character varying(100),
    "insuranceDate" date,
    "roadLegalUntil" date,
    notes text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.vehicles OWNER TO postgres;

--
-- Name: vehicles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vehicles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vehicles_id_seq OWNER TO postgres;

--
-- Name: vehicles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vehicles_id_seq OWNED BY public.vehicles.id;


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: equipment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment ALTER COLUMN id SET DEFAULT nextval('public.equipment_id_seq'::regclass);


--
-- Name: inventory id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory ALTER COLUMN id SET DEFAULT nextval('public.inventory_id_seq'::regclass);


--
-- Name: inventory_transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_transactions ALTER COLUMN id SET DEFAULT nextval('public.inventory_transactions_id_seq'::regclass);


--
-- Name: maintenance_records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_records ALTER COLUMN id SET DEFAULT nextval('public.maintenance_records_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: shipment_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipment_items ALTER COLUMN id SET DEFAULT nextval('public.shipment_items_id_seq'::regclass);


--
-- Name: shipments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments ALTER COLUMN id SET DEFAULT nextval('public.shipments_id_seq'::regclass);


--
-- Name: treatment_products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.treatment_products ALTER COLUMN id SET DEFAULT nextval('public.treatment_products_id_seq'::regclass);


--
-- Name: treatments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.treatments ALTER COLUMN id SET DEFAULT nextval('public.treatments_id_seq'::regclass);


--
-- Name: vehicles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles ALTER COLUMN id SET DEFAULT nextval('public.vehicles_id_seq'::regclass);


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clients (id, name, phone, address, "createdAt", "updatedAt") FROM stdin;
3	Новобелицкий рынок	+375 (25) 762 77 22	Гомель, улица Ильича, 78	2026-08-05 11:36:01.17121	2026-08-05 11:37:09.818635
4	Прудковский рынок	+375 (29) 144 27 01	 Гомель, улица Каменщикова, 3	2026-08-05 11:39:29.195238	2026-08-05 11:55:09.606836
7	Центральный Рынок	\N	Гомель, ул. Карповича, 28	2026-08-06 08:11:37.476697	2026-08-06 08:31:41.390492
9	Давыдовский рынок	\N	Гомель, Речицкий просп., 40/1	2026-08-06 08:32:09.467397	2026-08-06 08:33:00.881074
8	Сельмашевский рынок	\N	Гомель, улица Бориса Царикова, 1	2026-08-06 08:17:23.721165	2026-08-06 08:34:41.258875
5	ООО «Мувегрупп»	+375291260877	ГОМЕЛЬ	2026-08-05 15:01:21.127838	2026-08-06 08:47:52.434303
6	ЧП "Ан марше"	+375296663077	\N	2026-08-06 06:56:29.902112	2026-08-06 08:49:51.764141
\.


--
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equipment (id, name, type, model, "serialNumber", "verificationDate", notes, "createdAt", "updatedAt") FROM stdin;
1	Мегеон	ph-метр	Мегеон 17001		2027-05-07		2026-05-16 04:58:20.790439	2026-05-16 04:58:20.790439
2	MASSA-K	весы	MK-15.2-T11	00121	2026-02-01	Резерв	2026-05-16 04:58:20.795831	2026-05-16 04:58:20.795831
3	MASSA-K ПЛАТФОРМА	весы		2622	2006-05-13	Складские	2026-05-16 04:58:20.800304	2026-05-16 04:58:20.800304
6	MASSA-K	весы	MK-15.2-TH11	03731	2026-11-01	Сельмашевский рынок	2026-05-16 04:58:20.813412	2026-08-07 06:04:19.277368
4	MASSA-K	весы	MK-15.2-T11	1802	2027-03-01	Новобелицкий рынок	2026-05-16 04:58:20.804749	2026-08-07 06:04:33.11851
5	MASSA-K	весы	MK-15.2-TB21	64214	2027-07-01	Центральный рынок	2026-05-16 04:58:20.808954	2026-08-07 06:04:40.477768
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory (id, name, type, unit, notes, "createdAt", "updatedAt") FROM stdin;
357	Актелик	инсектицид	л	500 г/л пиримифос-метил	2026-05-16 07:06:15.966178	2026-05-16 07:06:15.966178
358	Агровиталь	инсектицид	л	600 г/л имидаклоприд	2026-05-16 07:06:15.976318	2026-05-16 07:06:15.976318
359	Табу	инсектицид	л	500 г/л имидаклоприд	2026-05-16 07:06:15.979624	2026-05-16 07:06:15.979624
360	Цепеллин	инсектицид	л	100 г/л альфа-циперметрин	2026-05-16 07:06:15.982954	2026-05-16 07:06:15.982954
361	Сектор	инсектицид	л	500 г/л хлорпирифос, 50 г/л циперметрин	2026-05-16 07:06:15.985801	2026-05-16 07:06:15.985801
363	Борей Нео	инсектицид	л	125 г/л альфа-циперметрин, 100 г/л имидаклоприд, 50 г/л клотианидин	2026-05-16 07:06:15.992467	2026-05-16 07:06:15.992467
364	Молния Дуо	инсектицид	л	106 г/л лямбда-цигалотрин, 141 г/л тиаметоксам	2026-05-16 07:06:15.995637	2026-05-16 07:06:15.995637
365	Ломбардо	инсектицид	л	50 г/л лямбда-цигалотрин	2026-05-16 07:06:15.998844	2026-05-16 07:06:15.998844
366	Фаскорд	инсектицид	л	100 г/л альфа-циперметрин	2026-05-16 07:06:16.002686	2026-05-16 07:06:16.002686
367	Агролан	инсектицид	кг	200 г/кг ацетамиприд	2026-05-16 07:06:16.00613	2026-05-16 07:06:16.00613
368	Волиам Тарго	инсектицид	л	18 г/л абамектин, 45 г/л хлорантранилипрол	2026-05-16 07:06:16.009476	2026-05-16 07:06:16.009476
369	Интрада	фунгицид	л	250 г/л азоксистробин	2026-05-16 07:06:16.012608	2026-05-16 07:06:16.012608
370	Квадрис	фунгицид	л	250 г/л азоксистробин	2026-05-16 07:06:16.015651	2026-05-16 07:06:16.015651
371	Пропульс	фунгицид	л	125 г/л флуопирам, 125 г/л протиоконазол	2026-05-16 07:06:16.019293	2026-05-16 07:06:16.019293
372	Браво	фунгицид	л	500 г/л хлороталонил	2026-05-16 07:06:16.022281	2026-05-16 07:06:16.022281
373	Инфинито	фунгицид	л	62,5 г/л флуопиколид, 625 г/л пропамокарб гидрохлорид	2026-05-16 07:06:16.025173	2026-05-16 07:06:16.025173
374	Орондис Ультра	фунгицид	л	250 г/л мандипропамид, 30 г/л оксатиапипролин	2026-05-16 07:06:16.028196	2026-05-16 07:06:16.028196
375	Белис	фунгицид	кг	252 г/кг боскалид, 128 г/кг пираклостробин	2026-05-16 07:06:16.031033	2026-05-16 07:06:16.031033
376	Раёк	фунгицид	л	250 г/л дифеноконазол	2026-05-16 07:06:16.033921	2026-05-16 07:06:16.033921
377	Акробат МЦ	фунгицид	кг	90 г/кг диметоморф, 600 г/кг манкоцеб	2026-05-16 07:06:16.037076	2026-05-16 07:06:16.037076
378	Карамба	фунгицид	л	60 г/л метконазол	2026-05-16 07:06:16.040293	2026-05-16 07:06:16.040293
379	Бетанал 22	фунгицид	л	160 г/л фенмедифам, 160 г/л десмедифам	2026-05-16 07:06:16.0435	2026-05-16 07:06:16.0435
380	Трайдекс	фунгицид	кг	750 г/кг манкоцеб	2026-05-16 07:06:16.046664	2026-05-16 07:06:16.046664
381	Антракол	фунгицид	кг	700 г/кг пропинеб	2026-05-16 07:06:16.049907	2026-05-16 07:06:16.049907
382	Фазор	регулятор роста	кг	800 г/кг малеинового гидразида (калиевая соль)	2026-05-16 07:06:16.053031	2026-05-16 07:06:16.053031
383	Хорус	фунгицид	кг	750 г/кг ципродинил	2026-05-16 07:06:16.056029	2026-05-16 07:06:16.056029
384	Ридомил Голд	фунгицид	кг	640 г/л манкоцеб, 40 г/кг мефеноксам	2026-05-16 07:06:16.059049	2026-05-16 07:06:16.059049
385	Луна Транквилити	фунгицид	л	125 г/л флуопирам, 375 г/л пириметанил	2026-05-16 07:06:16.062356	2026-05-16 07:06:16.062356
388	Топаз	фунгицид	л	100 г/л пенконазол	2026-05-16 07:06:16.071239	2026-05-16 07:06:16.071239
389	Авант	инсектицид	л	150 г/л индоксакарб	2026-05-16 07:06:16.074451	2026-05-16 07:06:16.074451
390	Миравис	фунгицид	л	200 г/л пидифлуметофен	2026-05-16 07:06:16.077208	2026-05-16 07:06:16.077208
394	Экосил	регулятор роста	л	50 г/л тритерпеновая кислота	2026-05-16 07:06:16.089187	2026-05-16 07:06:16.089187
397	Текнофит pH	адъювант	л	 20% поли-гидрокси-карбокислота	2026-05-16 07:06:16.097778	2026-05-16 07:06:16.097778
398	Бор	удобрение	л	\N	2026-05-16 07:06:16.100696	2026-05-16 07:06:16.100696
400	Свитч	фунгицид	кг	375 г/кг ципродинил, 250 г/кг флудиоксонил	2026-05-16 07:06:16.106126	2026-05-16 07:06:16.106126
401	Луна Экспириенс	фунгицид	л	200 г/л флуопирам, 200 г/л тебуконазол	2026-05-16 07:06:16.109028	2026-05-16 07:06:16.109028
402	Эфория	инсектицид	л	141 г/л тиаметоксам, 106 г/л лямбда-цигалотрин 	2026-05-16 07:06:16.112232	2026-05-16 07:06:16.112232
403	Дискор	фунгицид	л	250 г/л дифеноконазол	2026-05-16 07:06:16.115295	2026-05-16 07:06:16.115295
404	Скорошанс	фунгицид	л	250 г/л дифеноконазол	2026-05-16 07:06:16.118331	2026-05-16 07:06:16.118331
399	Азофос	фунгицид	кг	65% аммоний-медь-фосфат	2026-05-16 07:06:16.103458	2026-05-16 07:43:03.838215
386	Сатир	гербицид	кг	500 г/кг римсульфурон, 250 г/кг тифенсульфурон-метил	2026-05-16 07:06:16.065377	2026-05-17 09:30:32.571846
387	Эскудо	гербицид	кг	500 г/кг римсульфурон	2026-05-16 07:06:16.068549	2026-05-17 09:30:54.529617
362	Кораген	инсектицид	л	500 г/л хлорпирифос, 50 г/л циперметрин\\n	2026-05-16 07:06:15.988833	2026-05-17 10:04:39.755438
405	AMINOMAX 10	регулятор роста	л	Свободные аминокислоты: 10,0%. Общий азот (N): 3,2% (полностью в органической форме). Кислотность (pH 1% раствора): 4,1.	2026-05-16 07:06:16.121244	2026-06-25 11:22:47.835953
395	Folcrop Protec AI	регулятор роста	л	Медь (Cu): 1,75%. Железо (Fe): 2,0%. Марганец (Mn): 0,75%. Цинк (Zn): 0,5%.	2026-05-16 07:06:16.09212	2026-06-25 11:23:48.131454
391	Folcrop Set+	регулятор роста	л	Фосфор (P₂O₅): 9,34%  Калий (K₂O): 12,41%  Свободные аминокислоты: 6,67% Экстракты морских водорослей: 10,9%  Бор (B): 1,33% и Молибден (Mo): 0,13% Азот (N): 2,53%. 	2026-05-16 07:06:16.080364	2026-06-25 11:24:15.116571
393	Frutibooster+	регулятор роста	л	Свободные аминокислоты: 11,55% (w/v)  Экстракты морских водорослей: 9,4% (w/v)  Азот (N): 3,46% и Калий (K₂O): 1,96% Бор (B): 1,15% и Молибден (Mo): 0,11% 	2026-05-16 07:06:16.086402	2026-06-25 11:24:56.139187
396	Radix TIM Forte+	регулятор роста	л	Свободные аминокислоты: 4,37% – 5,7% Фосфор (P₂O₅): 9,2% – 11,1%  Азот (N): 3,1% – 3,77%  Калий (K₂O): 3,28% – 4,1%. Цинк (Zn): 0,4% – 0,44% 	2026-05-16 07:06:16.095005	2026-06-25 11:25:42.335133
407	Текамин Макс	регулятор роста	л	Свободные L-аминокислоты растительного происхождения: около 14,4% (в некоторых источниках указывается содержание до 30% от общей массы).\\nОбщий азот (N): 7,0%.	2026-05-16 07:06:16.127572	2026-05-16 07:06:16.127572
408	Магний сернокислый	удобрение	кг	16–17% магний (MgO), 13% сера (S)	2026-05-16 07:06:16.130925	2026-05-16 07:06:16.130925
409	Монокалий фосфат	удобрение	кг	 50-52% фосфор (P₂O₅), 33-34% калий (K₂O)	2026-05-16 07:06:16.133887	2026-05-16 07:06:16.133887
410	Сульфат калия	удобрение	кг	50% калий (K₂O), 17–18% сера (S)	2026-05-16 07:06:16.13691	2026-05-16 07:06:16.13691
411	Нитрат кальция	удобрение	кг	15% азот, 26–27% кальций (CaO)	2026-05-16 07:06:16.139838	2026-05-16 07:06:16.139838
414	Касуген	биопрепарат	л	20 г/л касугамицин	2026-05-16 07:06:16.149213	2026-05-16 07:06:16.149213
415	МайсТер Пауэр	гербицид	л	31.5 г/л форамсульфурон, 1 г/л йодосульфурон-метил-натрий, 10 г/л тиенкарбазон-метил, 15 г/л ципросульфамид\\n	2026-05-16 07:06:16.152196	2026-05-16 07:06:16.152196
416	Пирамин Турбо	гербицид	л	520 г/л хлоридазон	2026-05-16 07:06:16.154892	2026-05-16 07:06:16.154892
417	Гезагард	гербицид	л	500 г/л прометрин	2026-05-16 07:06:16.157693	2026-05-16 07:06:16.157693
418	Дуал Голд	гербицид	л	960 г/л s-метолахлор	2026-05-16 07:06:16.160514	2026-05-16 07:06:16.160514
419	Султан	гербицид	л	500 г/л метазахлор	2026-05-16 07:06:16.163305	2026-05-16 07:06:16.163305
420	Бутизан	гербицид	л	500 г/л метазахлор	2026-05-16 07:06:16.166341	2026-05-16 07:06:16.166341
421	Боксер	гербицид	л	800 г/л просульфокарб	2026-05-16 07:06:16.16945	2026-05-16 07:06:16.16945
422	Стомп Профессионал	гербицид	л	455 г/л пендиметалин	2026-05-16 07:06:16.172521	2026-05-16 07:06:16.172521
423	Баста	десикант	л	150 г/л глюфосинат аммония	2026-05-16 07:06:16.175622	2026-05-16 07:06:16.175622
424	Реглон Форте	десикант	л	200 г/л дикват (ион)  (в форме дикват дибромида 400 г/л).	2026-05-16 07:06:16.179219	2026-05-16 07:06:16.179219
425	Митрон	гербицид	л	700 г/л метамитрон	2026-05-16 07:06:16.182326	2026-05-16 07:06:16.182326
427	Бельведер Форте	гербицид	л	100 г/л фенмедифам, 100 г/л десмедифам, 200 г/л этофумезат	2026-05-16 07:06:16.188069	2026-05-16 07:06:16.188069
428	Сармат	гербицид	л	500 г/л прометрин	2026-05-16 07:06:16.190947	2026-05-16 07:06:16.190947
429	Нуфлон	гербицид	л	450 г/л линурон	2026-05-16 07:06:16.19358	2026-05-16 07:06:16.19358
430	Базагран	гербицид	л	480 г/л бентазон	2026-05-16 07:06:16.196366	2026-05-16 07:06:16.196366
413	Актара	инсектицид	кг	250 г/кг тиаметоксам	2026-05-16 07:06:16.146082	2026-05-17 08:47:29.341456
432	Шанситек	инсектицид	л	18 г/л абамектин	2026-05-17 08:48:55.271847	2026-05-17 08:48:55.271847
431	Альверде	инсектицид	л	240 г/л метафлумизон	2026-05-17 08:46:59.108735	2026-05-17 08:49:35.343675
433	Вирий	инсектицид	л	245 г/л тиаклоприд	2026-05-17 10:48:36.390498	2026-05-17 10:48:36.390498
434	Фитоверм	биопрепарат	л	Аверсектин С	2026-05-17 10:50:33.246176	2026-05-17 10:50:33.246176
435	Фитолавин	биопрепарат	л	Фитобактериомицин	2026-05-17 10:51:35.62586	2026-05-17 10:51:35.62586
436	Химера	гербицид	л	125 г/л хизалофоп-П-этил в концентрации 	2026-05-17 10:52:57.983772	2026-05-17 10:52:57.983772
437	Тиамакс	инсектицид	л	240 г/л тиаметоксам	2026-05-17 10:54:39.886526	2026-05-17 10:54:39.886526
438	Спрут Экстра	гербицид	л	 540 г/л глифосат	2026-05-17 10:55:54.908023	2026-05-17 10:55:54.908023
439	Квикстеп	гербицид	л	130 г/л клетодим, 80 г/л галоксифоп-Р-метил	2026-05-17 10:57:57.025888	2026-05-17 10:57:57.025888
440	Акзифор	гербицид	л	240 г/л оксифлуорфен	2026-05-17 10:59:03.062567	2026-05-17 10:59:03.062567
441	Примадонна	гербицид	л	200 г/л 2,4-Д кислота в виде сложного 2-этилгексилового эфира, 3.7 г/л флорасулам	2026-05-17 11:00:42.814751	2026-05-17 11:00:42.814751
442	Бетанал максПро	гербицид	л	75 г/л этофумезат, 60 г/л фенмедифам, 47 г/л десмедифам, 27 г/л ленацил	2026-05-17 11:02:35.795879	2026-05-17 11:02:35.795879
443	Балерина	гербицид	л	410 г/л 2,4-Д кислота в виде сложного 2-этилгексилового эфира, 7.4 г/л флорасулам	2026-05-17 11:04:13.385115	2026-05-17 11:04:13.385115
444	Миура	гербицид	л	125 г/л хизалофоп-П-этил в концентрации	2026-05-17 11:05:13.316125	2026-05-17 11:05:13.316125
445	Фюзилад Форте	гербицид	л	150 г/л флуазифоп-П-бутил в концентрации	2026-05-17 11:06:26.476123	2026-05-17 11:06:26.476123
446	Голден Ринг	гербицид	л	150 г/л дикват	2026-05-17 11:08:41.941609	2026-05-17 11:08:41.941609
447	Рейсер	гербицид	л	250 г/л флурохлоридон	2026-05-17 11:10:56.257512	2026-05-17 11:10:56.257512
448	Даш	адъювант	л	этоксилат изодецилового спирта	2026-05-17 11:12:12.009013	2026-05-17 11:12:12.009013
449	Ширма	фунгицид	л	500 г/л флуазинам	2026-05-17 11:32:18.684446	2026-05-17 11:32:18.684446
450	Таргет Супер	гербицид	л	51.6 г/л Хизалофоп-П-этил в концентрации	2026-05-21 11:42:18.428354	2026-05-21 11:42:18.428354
452	Тотал 480	гербицид	л	480 г/л глифосад	2026-05-22 13:27:36.167577	2026-05-22 13:27:36.167577
453	Молбузин	гербицид	кг	750 г/кг метрибузин	2026-05-31 11:19:06.399473	2026-05-31 11:19:06.399473
454	Forcrop Golden 10-14-4	регулятор роста	л	Азот (N) — 10,4%. Фосфор (P₂O₅) — 14,3%. Калий (K₂O) — 3,9%. Свободные аминокислоты — 10,66%. Микроэлементы: Марганец (Mn) — 0,98%, Цинк (Zn) — 0,68%, Магний (MgO) — 0,39%, Бор (B) — 0,14%	2026-06-25 11:20:17.67689	2026-06-25 11:21:53.15554
392	Folcrop Titan	регулятор роста	л	Свободные аминокислоты: 17,16% Органическое вещество: 47,38%. Азот (N): 6,0%. Оксид кальция (CaO): 4,09%. Бор (B): 0,26%. Триоксид серы (SO₃): 2,31%	2026-05-16 07:06:16.083321	2026-06-25 11:22:29.847934
412	Folcrop Amin	регулятор роста	л	Свободные аминокислоты (14.0% – 16.6%). Азот (N) (4.4% – 5.2%). Железо (Fe) (2.0% – 2.4%). Цинк (Zn) (1.0% – 1.19%)	2026-05-16 07:06:16.142844	2026-06-25 11:23:19.94448
406	Leafdrip (Урожай)	удобрение	кг	Азот (N): 10% Фосфор (P₂O₅): 8% Калий (K₂O): 42% Магний (MgO): 1% Микроэлементы (ME): бор, медь, железо, марганец, молибден, цинк	2026-05-16 07:06:16.124275	2026-06-25 11:24:35.943972
455	Folcrop Stim	регулятор роста	л	Свободные аминокислоты растительного происхождения — 10,1%. Азот (N) — 8,1%.Органическое вещество — 3,9%. Стимуляторы роста (включая NATCA/AATC) — 0,39%	2026-06-25 11:26:49.829085	2026-06-25 11:26:49.829085
456	Кондор	гербицид	кг	\N	2026-06-26 08:03:36.915565	2026-06-26 08:03:36.915565
457	Метамил	фунгицид	кг	\N	2026-06-30 08:14:09.803165	2026-06-30 08:14:09.803165
458	PICO-800	адъювант	л	\N	2026-07-02 07:31:00.746418	2026-07-02 07:31:00.746418
459	Бандуро	гербицид	л	600 г/л аклонифен	2026-07-02 08:24:02.937344	2026-07-02 08:24:02.937344
\.


--
-- Data for Name: inventory_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_transactions (id, "productId", type, quantity, "balanceAfter", "referenceType", "referenceId", description, "createdAt") FROM stdin;
1	365	OUT	1.500	-1.500	TREATMENT	41	Создание обработки #41: груша, 2 га, норма 0.75 л/га	2026-05-16 13:59:43.812184
2	365	OUT	0.045	-1.545	TREATMENT	49	Создание обработки #49: другое, 0.15 га, норма 0.3 л/га	2026-05-16 13:59:43.817429
3	381	OUT	4.000	-4.000	TREATMENT	41	Создание обработки #41: груша, 2 га, норма 2 кг/га	2026-05-16 13:59:43.822573
4	422	OUT	4.500	-4.500	TREATMENT	42	Создание обработки #42: другое, 1.5 га, норма 3 л/га	2026-05-16 13:59:43.826253
5	422	OUT	6.000	-10.500	TREATMENT	51	Создание обработки #51: лук, 4 га, норма 1.5 л/га	2026-05-16 13:59:43.829523
6	417	OUT	3.000	-3.000	TREATMENT	43	Создание обработки #43: морковь, 1.5 га, норма 2 л/га	2026-05-16 13:59:43.833604
7	416	OUT	3.750	-3.750	TREATMENT	44	Создание обработки #44: свекла, 1.5 га, норма 2.5 л/га	2026-05-16 13:59:43.838445
8	416	OUT	1.600	-5.350	TREATMENT	60	Создание обработки #60: лук, 4 га, норма 0.4 л/га	2026-05-16 13:59:43.842362
9	418	OUT	2.250	-2.250	TREATMENT	44	Создание обработки #44: свекла, 1.5 га, норма 1.5 л/га	2026-05-16 13:59:43.846637
10	420	OUT	0.300	-0.300	TREATMENT	45	Создание обработки #45: другое, 0.15 га, норма 2 л/га	2026-05-16 13:59:43.851695
11	402	OUT	1.200	-1.200	TREATMENT	46	Создание обработки #46: груша, 3 га, норма 0.4 л/га	2026-05-16 13:59:43.856111
13	402	OUT	0.225	-7.825	TREATMENT	57	Создание обработки #57: свекла, 1.5 га, норма 0.15 л/га	2026-05-16 13:59:43.863188
14	402	OUT	0.225	-8.050	TREATMENT	58	Создание обработки #58: капуста, 1.5 га, норма 0.15 л/га	2026-05-16 13:59:43.866527
15	403	OUT	3.200	-3.200	TREATMENT	47	Создание обработки #47: груша, 16 га, норма 0.2 л/га	2026-05-16 13:59:43.871142
16	380	OUT	24.000	-24.000	TREATMENT	47	Создание обработки #47: груша, 16 га, норма 1.5 кг/га	2026-05-16 13:59:43.875184
17	424	OUT	6.800	-6.800	TREATMENT	50	Создание обработки #50: лук, 4 га, норма 1.7 л/га	2026-05-16 13:59:43.879269
18	421	OUT	2.000	-2.000	TREATMENT	50	Создание обработки #50: лук, 4 га, норма 0.5 л/га	2026-05-16 13:59:43.883716
19	421	OUT	2.000	-4.000	TREATMENT	51	Создание обработки #51: лук, 4 га, норма 0.5 л/га	2026-05-16 13:59:43.887665
20	427	OUT	1.200	-1.200	TREATMENT	52	Создание обработки #52: свекла, 1.5 га, норма 0.8 л/га	2026-05-16 13:59:43.89165
21	425	OUT	1.800	-1.800	TREATMENT	52	Создание обработки #52: свекла, 1.5 га, норма 1.2 л/га	2026-05-16 13:59:43.897391
22	425	OUT	0.750	-2.550	TREATMENT	59	Создание обработки #59: морковь, 1.5 га, норма 0.5 л/га	2026-05-16 13:59:43.901775
23	428	OUT	1.800	-1.800	TREATMENT	53	Создание обработки #53: морковь, 1.5 га, норма 1.2 л/га	2026-05-16 13:59:43.905659
24	399	OUT	225.000	-225.000	TREATMENT	54	Создание обработки #54: груша, 22.5 га, норма 10 кг/га	2026-05-16 13:59:43.909487
25	399	OUT	50.000	-275.000	TREATMENT	55	Создание обработки #55: черешня, 5 га, норма 10 кг/га	2026-05-16 13:59:43.913221
26	399	OUT	4.000	-279.000	TREATMENT	56	Создание обработки #56: слива, 0.4 га, норма 10 кг/га	2026-05-16 13:59:43.916759
27	429	OUT	0.525	-0.525	TREATMENT	59	Создание обработки #59: морковь, 1.5 га, норма 0.35 л/га	2026-05-16 13:59:43.920814
28	430	OUT	0.400	-0.400	TREATMENT	60	Создание обработки #60: лук, 4 га, норма 0.1 л/га	2026-05-16 13:59:43.924878
29	430	IN	0.800	0.400	MANUAL_IN	\N	Ручной приход: +0.8 л	2026-05-16 14:13:07.048288
49	369	IN	35.000	35.000	MANUAL_IN	\N	Ручной приход: +35 л	2026-05-17 08:55:44.338015
12	402	OUT	6.400	-7.600	TREATMENT	47	Создание обработки #47: груша, 16 га, норма 0.4 л/га	2026-05-16 13:59:43.859725
32	430	OUT	0.400	0.000	TREATMENT	77	Создание обработки #77: Базагран - лук, 4 га, норма 0.1 л/га	2026-05-16 14:14:44.114735
33	402	IN	20.000	11.950	MANUAL_IN	\N	Ручной приход: +20 л	2026-05-17 08:44:15.194883
34	360	IN	20.000	20.000	MANUAL_IN	\N	Ручной приход: +20 л	2026-05-17 08:44:30.545149
35	361	IN	20.000	20.000	MANUAL_IN	\N	Ручной приход: +20 л	2026-05-17 08:44:41.616945
36	363	IN	5.000	5.000	MANUAL_IN	\N	Ручной приход: +5 л	2026-05-17 08:45:09.434348
37	364	IN	10.000	10.000	MANUAL_IN	\N	Ручной приход: +10 л	2026-05-17 08:45:22.83766
38	431	IN	2.000	2.000	MANUAL_IN	\N	Начальный остаток при создании: 2 л	2026-05-17 08:46:59.138607
39	413	IN	1.000	1.000	MANUAL_IN	\N	Ручной приход: +1 кг	2026-05-17 08:47:36.870349
40	432	IN	10.000	10.000	MANUAL_IN	\N	Начальный остаток при создании: 10 л	2026-05-17 08:48:55.278234
41	366	IN	2.500	2.500	MANUAL_IN	\N	Ручной приход: +2.5 л	2026-05-17 08:49:50.075547
42	368	IN	2.000	2.000	MANUAL_IN	\N	Ручной приход: +2 л	2026-05-17 08:50:04.564706
43	367	IN	3.000	3.000	MANUAL_IN	\N	Ручной приход: +3 кг	2026-05-17 08:50:23.32948
44	389	IN	5.000	5.000	MANUAL_IN	\N	Ручной приход: +5 л	2026-05-17 08:50:36.675792
45	370	IN	6.000	6.000	MANUAL_IN	\N	Ручной приход: +6 л	2026-05-17 08:54:11.135853
46	385	IN	20.000	20.000	MANUAL_IN	\N	Ручной приход: +20 л	2026-05-17 08:54:23.394457
47	403	IN	15.000	11.800	MANUAL_IN	\N	Ручной приход: +15 л	2026-05-17 08:55:10.204138
48	404	IN	20.000	20.000	MANUAL_IN	\N	Ручной приход: +20 л	2026-05-17 08:55:29.813003
50	372	IN	25.000	25.000	MANUAL_IN	\N	Ручной приход: +25 л	2026-05-17 08:55:53.103007
51	375	IN	16.000	16.000	MANUAL_IN	\N	Ручной приход: +16 кг	2026-05-17 08:56:11.879282
52	378	IN	10.000	10.000	MANUAL_IN	\N	Ручной приход: +10 л	2026-05-17 08:56:34.181851
53	373	IN	5.000	5.000	MANUAL_IN	\N	Ручной приход: +5 л	2026-05-17 08:56:49.341941
54	376	IN	27.000	27.000	MANUAL_IN	\N	Ручной приход: +27 л	2026-05-17 08:58:12.575099
55	395	IN	1.000	1.000	MANUAL_IN	\N	Ручной приход: +1 л	2026-05-17 08:58:58.802827
56	412	IN	2.000	2.000	MANUAL_IN	\N	Ручной приход: +2 л	2026-05-17 08:59:12.983739
57	391	IN	1.000	1.000	MANUAL_IN	\N	Ручной приход: +1 л	2026-05-17 08:59:22.754455
58	393	IN	1.000	1.000	MANUAL_IN	\N	Ручной приход: +1 л	2026-05-17 08:59:39.671215
59	392	IN	5.000	5.000	MANUAL_IN	\N	Ручной приход: +5 л	2026-05-17 08:59:48.913469
60	388	IN	3.000	3.000	MANUAL_IN	\N	Ручной приход: +3 л	2026-05-17 09:00:11.363813
61	390	IN	1.000	1.000	MANUAL_IN	\N	Ручной приход: +1 л	2026-05-17 09:00:22.519874
62	396	IN	1.000	1.000	MANUAL_IN	\N	Ручной приход: +1 л	2026-05-17 09:00:35.08286
63	410	IN	100.000	100.000	MANUAL_IN	\N	Ручной приход: +100 кг	2026-05-17 09:01:07.392071
64	411	IN	100.000	100.000	MANUAL_IN	\N	Ручной приход: +100 кг	2026-05-17 09:01:19.940254
65	408	IN	60.000	60.000	MANUAL_IN	\N	Ручной приход: +60 кг	2026-05-17 09:01:29.418723
66	412	IN	8.000	10.000	MANUAL_IN	\N	Ручной приход: +8 л	2026-05-17 09:01:54.236586
67	394	IN	10.000	10.000	MANUAL_IN	\N	Ручной приход: +10 л	2026-05-17 09:02:19.07952
68	407	IN	15.000	15.000	MANUAL_IN	\N	Ручной приход: +15 л	2026-05-17 09:02:40.775721
69	397	IN	10.000	10.000	MANUAL_IN	\N	Ручной приход: +10 л	2026-05-17 09:02:55.412148
70	398	IN	30.000	30.000	MANUAL_IN	\N	Ручной приход: +30 л	2026-05-17 09:03:45.281136
71	405	IN	8.000	8.000	MANUAL_IN	\N	Ручной приход: +8 л	2026-05-17 09:03:59.781086
72	406	IN	50.000	50.000	MANUAL_IN	\N	Ручной приход: +50 кг	2026-05-17 09:04:14.48723
73	409	IN	60.000	60.000	MANUAL_IN	\N	Ручной приход: +60 кг	2026-05-17 09:04:25.973537
115	436	IN	3.000	3.000	MANUAL_IN	\N	Начальный остаток при создании: 3 л	2026-05-17 10:52:58.005207
75	416	OUT	7.000	0.050	MANUAL_ADJUST	\N	Корректировка остатка: 7.05 → 0.05 л	2026-05-17 09:13:17.52527
79	402	OUT	4.000	7.950	TREATMENT	79	Создание обработки #79: Эфория - яблоко, 10 га, норма 0.4 л/га	2026-05-17 09:25:26.06857
74	416	IN	7.000	7.050	MANUAL_IN	\N	Ручной приход: +7 л	2026-05-17 09:11:26.395143
76	422	IN	17.500	7.000	MANUAL_IN	\N	Ручной приход: +17.5 л	2026-05-17 09:13:36.98302
77	422	OUT	7.000	0.000	TREATMENT	78	Создание обработки #78: Стомп Профессионал - другое, 2 га, норма 3.5 л/га	2026-05-17 09:14:07.203229
78	385	OUT	10.000	10.000	TREATMENT	79	Создание обработки #79: Луна Транквилити - яблоко, 10 га, норма 1 л/га	2026-05-17 09:25:26.054713
80	407	OUT	15.000	0.000	TREATMENT	79	Создание обработки #79: Текамин Макс - яблоко, 10 га, норма 1.5 л/га	2026-05-17 09:25:26.088086
81	399	IN	300.000	21.000	MANUAL_IN	\N	Ручной приход: +300 кг	2026-05-17 09:28:57.99687
82	381	IN	34.000	30.000	MANUAL_IN	\N	Ручной приход: +34 кг	2026-05-17 09:29:39.600268
83	386	IN	1.000	1.000	MANUAL_IN	\N	Ручной приход: +1 кг	2026-05-17 09:30:42.424658
84	387	IN	0.300	0.300	MANUAL_IN	\N	Ручной приход: +0.3 кг	2026-05-17 09:31:23.371224
85	400	IN	1.000	1.000	MANUAL_IN	\N	Ручной приход: +1 кг	2026-05-17 09:31:59.844486
86	374	IN	12.000	12.000	MANUAL_IN	\N	Ручной приход: +12 л	2026-05-17 09:32:16.025059
87	401	IN	5.000	5.000	MANUAL_IN	\N	Ручной приход: +5 л	2026-05-17 09:32:31.292098
88	377	IN	20.000	20.000	MANUAL_IN	\N	Ручной приход: +20 кг	2026-05-17 09:32:51.971067
89	379	IN	10.000	10.000	MANUAL_IN	\N	Ручной приход: +10 л	2026-05-17 09:33:09.686297
90	371	IN	5.000	5.000	MANUAL_IN	\N	Ручной приход: +5 л	2026-05-17 09:33:19.545614
91	425	IN	10.000	7.450	MANUAL_IN	\N	Ручной приход: +10 л	2026-05-17 09:34:17.775542
92	383	IN	1.000	1.000	MANUAL_IN	\N	Ручной приход: +1 кг	2026-05-17 09:34:28.740083
93	419	IN	5.000	5.000	MANUAL_IN	\N	Ручной приход: +5 л	2026-05-17 09:34:48.478092
94	384	IN	5.000	5.000	MANUAL_IN	\N	Ручной приход: +5 кг	2026-05-17 09:34:59.899747
95	424	IN	11.500	4.700	MANUAL_IN	\N	Ручной приход: +11.5 л	2026-05-17 09:35:15.753382
96	380	IN	24.000	0.000	MANUAL_IN	\N	Ручной приход: +24 кг	2026-05-17 09:37:03.290718
97	421	IN	4.000	0.000	MANUAL_IN	\N	Ручной приход: +4 л	2026-05-17 09:37:15.900667
98	429	IN	15.000	14.475	MANUAL_IN	\N	Ручной приход: +15 л	2026-05-17 09:37:40.011828
99	365	IN	5.000	3.455	MANUAL_IN	\N	Ручной приход: +5 л	2026-05-17 09:38:57.982675
100	428	IN	1.800	0.000	MANUAL_IN	\N	Ручной приход: +1.8 л	2026-05-17 09:39:46.902577
101	418	IN	2.250	0.000	MANUAL_IN	\N	Ручной приход: +2.25 л	2026-05-17 09:39:58.826118
102	427	IN	1.200	0.000	MANUAL_IN	\N	Ручной приход: +1.2 л	2026-05-17 09:40:10.805495
103	417	IN	3.000	0.000	MANUAL_IN	\N	Ручной приход: +3 л	2026-05-17 09:40:15.397397
104	357	IN	15.000	15.000	MANUAL_IN	\N	Ручной приход: +15 л	2026-05-17 09:42:14.030773
105	382	IN	45.000	45.000	MANUAL_IN	\N	Ручной приход: +45 кг	2026-05-17 09:51:25.542765
106	362	IN	8.800	8.800	MANUAL_IN	\N	Ручной приход: +8.8 л	2026-05-17 10:04:52.805456
107	420	IN	0.300	0.000	MANUAL_IN	\N	Ручной приход: +0.3 л	2026-05-17 10:05:07.741662
108	359	IN	2.000	2.000	MANUAL_IN	\N	Ручной приход: +2 л	2026-05-17 10:46:52.148704
109	423	IN	18.000	18.000	MANUAL_IN	\N	Ручной приход: +18 л	2026-05-17 10:47:01.357794
110	414	IN	8.000	8.000	MANUAL_IN	\N	Ручной приход: +8 л	2026-05-17 10:47:12.878108
111	433	IN	3.000	3.000	MANUAL_IN	\N	Начальный остаток при создании: 3 л	2026-05-17 10:48:36.398013
112	434	IN	3.500	3.500	MANUAL_IN	\N	Начальный остаток при создании: 3.5 л	2026-05-17 10:50:33.252913
113	435	IN	5.000	5.000	MANUAL_IN	\N	Начальный остаток при создании: 5 л	2026-05-17 10:51:35.648346
114	383	IN	2.000	3.000	MANUAL_IN	\N	Ручной приход: +2 кг	2026-05-17 10:52:01.275251
116	437	IN	10.000	10.000	MANUAL_IN	\N	Начальный остаток при создании: 10 л	2026-05-17 10:54:39.89215
117	438	IN	10.000	10.000	MANUAL_IN	\N	Начальный остаток при создании: 10 л	2026-05-17 10:55:54.91414
118	421	IN	24.000	24.000	MANUAL_IN	\N	Ручной приход: +24 л	2026-05-17 10:56:20.440238
119	424	IN	7.300	12.000	MANUAL_ADJUST	\N	Корректировка остатка: 4.7 → 12 л	2026-05-17 10:56:45.24393
120	415	IN	20.000	20.000	MANUAL_IN	\N	Ручной приход: +20 л	2026-05-17 10:57:00.209927
121	439	IN	8.000	8.000	MANUAL_IN	\N	Начальный остаток при создании: 8 л	2026-05-17 10:57:57.032172
122	440	IN	7.000	7.000	MANUAL_IN	\N	Начальный остаток при создании: 7 л	2026-05-17 10:59:03.083858
123	441	IN	5.000	5.000	MANUAL_IN	\N	Начальный остаток при создании: 5 л	2026-05-17 11:00:42.834468
124	418	IN	9.000	9.000	MANUAL_IN	\N	Ручной приход: +9 л	2026-05-17 11:00:53.73086
125	422	IN	5.000	5.000	MANUAL_IN	\N	Ручной приход: +5 л	2026-05-17 11:01:04.323461
126	442	IN	12.500	12.500	MANUAL_IN	\N	Начальный остаток при создании: 12.5 л	2026-05-17 11:02:35.802043
127	443	IN	5.000	5.000	MANUAL_IN	\N	Начальный остаток при создании: 5 л	2026-05-17 11:04:13.391119
128	430	IN	10.000	10.000	MANUAL_IN	\N	Ручной приход: +10 л	2026-05-17 11:04:25.198698
129	444	IN	1.000	1.000	MANUAL_IN	\N	Начальный остаток при создании: 1 л	2026-05-17 11:05:13.337718
130	445	IN	5.000	5.000	MANUAL_IN	\N	Начальный остаток при создании: 5 л	2026-05-17 11:06:26.483238
131	446	IN	3.000	3.000	MANUAL_IN	\N	Начальный остаток при создании: 3 л	2026-05-17 11:08:41.948114
132	389	IN	1.000	6.000	MANUAL_IN	\N	Ручной приход: +1 л	2026-05-17 11:08:52.913169
133	384	IN	10.000	15.000	MANUAL_IN	\N	Ручной приход: +10 кг	2026-05-17 11:09:15.637877
134	416	IN	40.000	40.050	MANUAL_IN	\N	Ручной приход: +40 л	2026-05-17 11:09:28.849947
135	419	OUT	2.000	3.000	MANUAL_ADJUST	\N	Корректировка остатка: 5 → 3 л	2026-05-17 11:09:46.505956
136	447	IN	5.000	5.000	MANUAL_IN	\N	Начальный остаток при создании: 5 л	2026-05-17 11:10:56.279078
137	428	IN	15.000	15.000	MANUAL_IN	\N	Ручной приход: +15 л	2026-05-17 11:11:07.755947
138	448	IN	3.500	3.500	MANUAL_IN	\N	Начальный остаток при создании: 3.5 л	2026-05-17 11:12:12.0301
140	427	IN	10.000	10.000	MANUAL_IN	\N	Ручной приход: +10 л	2026-05-17 11:30:48.339614
141	380	IN	10.000	10.000	MANUAL_IN	\N	Ручной приход: +10 кг	2026-05-17 11:31:17.050499
142	449	IN	10.000	10.000	MANUAL_IN	\N	Начальный остаток при создании: 10 л	2026-05-17 11:32:18.704485
167	369	OUT	8.000	27.000	TREATMENT	92	Создание обработки #92: Интрада - груша, 16 га, норма 0.5 л/га	2026-05-27 08:21:36.214805
144	403	OUT	0.080	11.720	TREATMENT	80	Создание обработки #80: Дискор - слива, 0.4 га, норма 0.2 л/га	2026-05-19 09:11:54.033103
168	381	OUT	24.000	6.000	TREATMENT	92	Создание обработки #92: Антракол - груша, 16 га, норма 1.5 кг/га	2026-05-27 08:21:36.235155
143	402	OUT	0.160	7.790	TREATMENT	80	Создание обработки #80: Эфория - слива, 0.4 га, норма 0.4 л/га	2026-05-19 09:11:53.999876
147	362	OUT	0.300	8.500	TREATMENT	82	Создание обработки #82: Кораген - капуста, 1.5 га, норма 0.2 л/га	2026-05-20 05:01:30.669398
148	438	OUT	10.000	0.000	TREATMENT	83	Создание обработки #83: Спрут Экстра - другое, 2 га, норма 5 л/га	2026-05-21 07:02:09.980604
150	422	IN	9.950	10.000	MANUAL_IN	\N	Ручной приход: +9.95 л	2026-05-21 11:40:44.54402
159	422	OUT	9.990	0.010	TREATMENT	88	Создание обработки #88: Стомп Профессионал - другое, 3 га, норма 3.33 л/га	2026-05-23 10:19:21.155936
151	450	IN	20.000	20.000	MANUAL_IN	\N	Начальный остаток при создании: 20 л	2026-05-21 11:42:18.46177
146	403	OUT	0.700	11.020	TREATMENT	81	Создание обработки #81: Дискор - черешня, 3.5 га, норма 0.2 л/га	2026-05-19 09:16:03.185001
30	416	IN	7.000	1.650	MANUAL_IN	\N	Ручной приход: +7 л	2026-05-16 14:13:42.283947
31	416	OUT	1.600	0.050	TREATMENT	77	Создание обработки #77: Пирамин Турбо - лук, 4 га, норма 0.4 л/га	2026-05-16 14:14:44.088133
153	430	OUT	0.600	9.400	TREATMENT	85	Создание обработки #85: Базагран - лук, 4 га, норма 0.15 л/га	2026-05-21 12:59:36.744873
154	385	OUT	0.400	9.600	TREATMENT	86	Создание обработки #86: Луна Транквилити - яблоко, 2 га, норма 0.2 л/га	2026-05-22 09:33:07.719966
155	385	IN	0.400	10.000	MANUAL_IN	\N	Удаление обработки #86: Луна Транквилити - яблоко, 2 га, норма 0.2 л/га	2026-05-22 09:35:36.502818
157	452	IN	40.000	40.000	MANUAL_IN	\N	Начальный остаток при создании: 40 л	2026-05-22 13:27:36.18594
158	452	OUT	20.000	20.000	TREATMENT	87	Создание обработки #87: Тотал 480 - другое, 4 га, норма 5 л/га	2026-05-22 13:28:28.36334
161	422	OUT	6.600	3.400	TREATMENT	89	Создание обработки #89: Стомп Профессионал - другое, 2 га, норма 3.3 л/га	2026-05-23 11:21:56.101306
145	402	OUT	1.400	6.390	TREATMENT	81	Создание обработки #81: Эфория - черешня, 3.5 га, норма 0.4 л/га	2026-05-19 09:16:03.153752
160	422	IN	9.990	10.000	MANUAL_IN	\N	Удаление обработки #88: Стомп Профессионал - другое, 3 га, норма 3.33 л/га	2026-05-23 11:21:25.428
170	397	OUT	8.000	2.000	TREATMENT	92	Создание обработки #92: Текнофит pH - груша, 16 га, норма 0.5 л/га	2026-05-27 08:21:36.273096
162	445	IN	20.000	25.000	MANUAL_IN	\N	Ручной приход: +20 л	2026-05-26 09:12:30.929129
163	445	OUT	8.000	17.000	TREATMENT	90	Создание обработки #90: Фюзилад Форте - лук, 4 га, норма 2 л/га	2026-05-26 09:13:09.286915
164	385	OUT	4.000	6.000	TREATMENT	91	Создание обработки #91: Луна Транквилити - яблоко, 4 га, норма 1 л/га	2026-05-27 06:34:00.319763
165	402	OUT	1.600	4.790	TREATMENT	91	Создание обработки #91: Эфория - яблоко, 4 га, норма 0.4 л/га	2026-05-27 06:34:00.340657
149	422	OUT	4.950	0.050	TREATMENT	84	Создание обработки #84: Стомп Профессионал - другое, 1.5 га, норма 3.3 л/га	2026-05-21 09:10:34.781533
152	416	OUT	1.600	38.450	TREATMENT	85	Создание обработки #85: Пирамин Турбо - лук, 4 га, норма 0.4 л/га	2026-05-21 12:59:36.70713
166	405	OUT	2.000	6.000	TREATMENT	91	Создание обработки #91: AMINOMAX 10 - яблоко, 4 га, норма 0.5 л/га	2026-05-27 06:34:00.381654
171	438	IN	20.000	20.000	MANUAL_IN	\N	Ручной приход: +20 л	2026-05-28 05:00:03.013214
172	453	IN	10.000	10.000	MANUAL_IN	\N	Начальный остаток при создании: 10 кг	2026-05-31 11:19:06.50368
173	405	OUT	6.000	0.000	TREATMENT	93	Создание обработки #93: AMINOMAX 10 - груша, 12 га, норма 0.5 л/га	2026-05-31 11:21:30.642972
174	405	IN	6.000	6.000	MANUAL_IN	\N	Удаление обработки #93: AMINOMAX 10 - груша, 12 га, норма 0.5 л/га	2026-05-31 11:22:31.047837
175	405	OUT	6.000	0.000	TREATMENT	94	Создание обработки #94: AMINOMAX 10 - груша, 12 га, норма 0.5 л/га	2026-05-31 11:23:55.895207
176	405	IN	36.000	36.000	MANUAL_IN	\N	Ручной приход: +36 л	2026-06-02 08:46:17.546613
177	430	OUT	0.600	8.800	TREATMENT	95	Создание обработки #95: Базагран - лук, 4 га, норма 0.15 л/га	2026-06-02 09:50:26.762303
178	440	OUT	0.200	6.800	TREATMENT	95	Создание обработки #95: Акзифор - лук, 4 га, норма 0.05 л/га	2026-06-02 09:50:26.78437
211	405	OUT	2.000	27.010	TREATMENT	103	Создание обработки #103: AMINOMAX 10 - лук, 4 га, норма 0.5 л/га	2026-06-05 06:29:22.478432
180	440	OUT	0.200	6.600	TREATMENT	96	Создание обработки #96: Акзифор - лук, 4 га, норма 0.05 л/га	2026-06-02 10:02:18.288365
181	430	IN	0.600	8.800	MANUAL_IN	\N	Удаление обработки #96: Базагран - лук, 4 га, норма 0.15 л/га	2026-06-02 10:02:34.881796
182	440	IN	0.200	6.800	MANUAL_IN	\N	Удаление обработки #96: Акзифор - лук, 4 га, норма 0.05 л/га	2026-06-02 10:02:34.901374
169	389	OUT	4.800	1.200	TREATMENT	92	Создание обработки #92: Авант - груша, 16 га, норма 0.3 л/га	2026-05-27 08:21:36.253261
183	389	OUT	1.200	0.000	MANUAL_ADJUST	\N	Корректировка остатка: 1.2 → 0 л	2026-06-02 10:05:56.042391
184	366	OUT	0.225	2.275	TREATMENT	97	Создание обработки #97: Фаскорд - капуста, 1.5 га, норма 0.15 л/га	2026-06-02 10:50:21.392238
185	397	OUT	0.150	1.850	TREATMENT	97	Создание обработки #97: Текнофит pH - капуста, 1.5 га, норма 0.1 л/га	2026-06-02 10:50:21.407633
186	405	OUT	0.990	35.010	TREATMENT	97	Создание обработки #97: AMINOMAX 10 - капуста, 1.5 га, норма 0.66 л/га	2026-06-02 10:50:21.422807
187	431	OUT	1.500	0.500	TREATMENT	97	Создание обработки #97: Альверде - капуста, 1.5 га, норма 1 л/га	2026-06-02 10:50:21.438647
188	450	OUT	4.500	15.500	TREATMENT	98	Создание обработки #98: Таргет Супер - свекла, 1.5 га, норма 3 л/га	2026-06-03 06:39:30.080665
189	376	OUT	2.000	25.000	TREATMENT	99	Создание обработки #99: Раёк - яблоко, 10 га, норма 0.2 л/га	2026-06-03 06:55:41.120235
210	362	OUT	2.400	6.100	TREATMENT	102	Создание обработки #102: Кораген - яблоко, 12 га, норма 0.2 л/га	2026-06-04 06:33:18.735204
191	362	OUT	2.000	6.500	TREATMENT	99	Создание обработки #99: Кораген - яблоко, 10 га, норма 0.2 л/га	2026-06-03 06:55:41.158918
192	411	OUT	40.000	60.000	TREATMENT	99	Создание обработки #99: Нитрат кальция - яблоко, 10 га, норма 4 кг/га	2026-06-03 06:55:41.175896
193	453	OUT	4.995	5.005	TREATMENT	100	Создание обработки #100: Молбузин - картофель, 6.66 га, норма 0.75 кг/га	2026-06-03 14:02:59.564991
194	376	IN	2.000	27.000	MANUAL_IN	\N	Удаление обработки #99: Раёк - яблоко, 10 га, норма 0.2 л/га	2026-06-04 04:45:36.373046
195	405	IN	5.000	35.010	MANUAL_IN	\N	Удаление обработки #99: AMINOMAX 10 - яблоко, 10 га, норма 0.5 л/га	2026-06-04 04:45:36.39398
196	362	IN	2.000	8.500	MANUAL_IN	\N	Удаление обработки #99: Кораген - яблоко, 10 га, норма 0.2 л/га	2026-06-04 04:45:36.415912
197	411	IN	40.000	100.000	MANUAL_IN	\N	Удаление обработки #99: Нитрат кальция - яблоко, 10 га, норма 4 кг/га	2026-06-04 04:45:36.435249
198	397	IN	10.000	11.850	MANUAL_IN	\N	Ручной приход: +10 л	2026-06-04 04:48:52.890384
199	376	OUT	2.000	25.000	TREATMENT	101	Создание обработки #101: Раёк - яблоко, 10 га, норма 0.2 л/га	2026-06-04 04:52:55.377313
200	397	OUT	5.000	6.850	TREATMENT	101	Создание обработки #101: Текнофит pH - яблоко, 10 га, норма 0.5 л/га	2026-06-04 04:52:55.392316
220	397	OUT	8.000	7.700	TREATMENT	107	Создание обработки #107: Текнофит pH - груша, 16 га, норма 0.5 л/га	2026-06-06 13:50:08.225969
213	405	OUT	0.500	26.510	TREATMENT	105	Создание обработки #105: AMINOMAX 10 - капуста, 1 га, норма 0.5 л/га	2026-06-05 13:48:21.588183
202	362	OUT	2.000	6.500	TREATMENT	101	Создание обработки #101: Кораген - яблоко, 10 га, норма 0.2 л/га	2026-06-04 04:52:55.431156
203	376	IN	2.000	27.000	MANUAL_IN	\N	Удаление обработки #101: Раёк - яблоко, 10 га, норма 0.2 л/га	2026-06-04 06:25:24.171305
204	397	IN	5.000	11.850	MANUAL_IN	\N	Удаление обработки #101: Текнофит pH - яблоко, 10 га, норма 0.5 л/га	2026-06-04 06:25:24.191725
205	405	IN	5.000	35.010	MANUAL_IN	\N	Удаление обработки #101: AMINOMAX 10 - яблоко, 10 га, норма 0.5 л/га	2026-06-04 06:25:24.203745
216	417	IN	5.000	5.000	MANUAL_IN	\N	Ручной приход: +5 л	2026-06-06 13:40:38.352937
217	397	IN	10.000	15.700	MANUAL_IN	\N	Ручной приход: +10 л	2026-06-06 13:48:34.773438
206	362	IN	2.000	8.500	MANUAL_IN	\N	Удаление обработки #101: Кораген - яблоко, 10 га, норма 0.2 л/га	2026-06-04 06:25:24.226841
207	376	OUT	2.400	24.600	TREATMENT	102	Создание обработки #102: Раёк - яблоко, 12 га, норма 0.2 л/га	2026-06-04 06:33:18.672921
208	397	OUT	6.000	5.850	TREATMENT	102	Создание обработки #102: Текнофит pH - яблоко, 12 га, норма 0.5 л/га	2026-06-04 06:33:18.690402
214	368	OUT	0.990	1.010	TREATMENT	106	Создание обработки #106: Волиам Тарго - капуста, 1.5 га, норма 0.66 л/га	2026-06-05 14:01:00.335569
212	452	OUT	6.000	14.000	TREATMENT	104	Создание обработки #104: Тотал 480 - другое, 2 га, норма 3 л/га	2026-06-05 09:28:05.486226
201	405	OUT	5.000	30.010	TREATMENT	101	Создание обработки #101: AMINOMAX 10 - яблоко, 10 га, норма 0.5 л/га	2026-06-04 04:52:55.409078
209	405	OUT	6.000	29.010	TREATMENT	102	Создание обработки #102: AMINOMAX 10 - яблоко, 12 га, норма 0.5 л/га	2026-06-04 06:33:18.706114
221	405	OUT	8.000	18.510	TREATMENT	107	Создание обработки #107: AMINOMAX 10 - груша, 16 га, норма 0.5 л/га	2026-06-06 13:50:08.259899
219	375	OUT	12.800	3.200	TREATMENT	107	Создание обработки #107: Белис - груша, 16 га, норма 0.8 кг/га	2026-06-06 13:50:08.194505
218	364	OUT	4.800	5.200	TREATMENT	107	Создание обработки #107: Молния Дуо - груша, 16 га, норма 0.3 л/га	2026-06-06 13:50:08.163003
179	430	OUT	0.600	8.200	TREATMENT	96	Создание обработки #96: Базагран - лук, 4 га, норма 0.15 л/га	2026-06-02 10:02:18.244239
190	405	OUT	5.000	30.010	TREATMENT	99	Создание обработки #99: AMINOMAX 10 - яблоко, 10 га, норма 0.5 л/га	2026-06-03 06:55:41.136989
222	417	OUT	2.000	3.000	TREATMENT	108	Создание обработки #108: Гезагард - морковь, 1 га, норма 2 л/га	2026-06-06 13:53:43.899315
223	447	OUT	0.500	4.500	TREATMENT	108	Создание обработки #108: Рейсер - морковь, 1 га, норма 0.5 л/га	2026-06-06 13:53:43.915169
224	368	IN	0.990	2.000	MANUAL_IN	\N	Удаление обработки #106: Волиам Тарго - капуста, 1.5 га, норма 0.66 л/га	2026-06-09 12:53:48.188649
225	397	IN	0.150	7.850	MANUAL_IN	\N	Удаление обработки #106: Текнофит pH - капуста, 1.5 га, норма 0.1 л/га	2026-06-09 12:53:48.233857
226	357	OUT	0.990	14.010	TREATMENT	109	Создание обработки #109: Актелик - капуста, 1.5 га, норма 0.66 л/га	2026-06-09 12:56:03.408094
227	368	OUT	0.750	1.250	TREATMENT	109	Создание обработки #109: Волиам Тарго - капуста, 1.5 га, норма 0.5 л/га	2026-06-09 12:56:03.425952
229	440	OUT	0.400	6.400	TREATMENT	110	Создание обработки #110: Акзифор - лук, 4 га, норма 0.1 л/га	2026-06-11 11:00:23.195779
265	364	OUT	0.120	5.080	TREATMENT	121	Создание обработки #121: Молния Дуо - слива, 0.4 га, норма 0.3 л/га	2026-06-23 14:58:11.7051
231	362	OUT	0.300	5.800	TREATMENT	111	Создание обработки #111: Кораген - капуста, 1.5 га, норма 0.2 л/га	2026-06-12 08:17:51.801863
268	387	OUT	0.086	0.214	TREATMENT	122	Создание обработки #122: Эскудо - томаты, 4.3 га, норма 0.02 кг/га	2026-06-24 14:39:37.964438
255	357	OUT	1.000	13.010	TREATMENT	118	Создание обработки #118: Актелик - груша, 2 га, норма 0.5 л/га	2026-06-20 09:45:47.671912
234	418	OUT	2.250	6.750	TREATMENT	113	Создание обработки #113: Дуал Голд - свекла, 1.5 га, норма 1.5 л/га	2026-06-18 08:02:13.82671
235	417	OUT	1.200	1.800	TREATMENT	114	Создание обработки #114: Гезагард - морковь, 1.2 га, норма 1 л/га	2026-06-18 12:48:25.26944
236	447	OUT	0.120	4.380	TREATMENT	114	Создание обработки #114: Рейсер - морковь, 1.2 га, норма 0.1 л/га	2026-06-18 12:48:25.287401
237	453	OUT	0.180	4.825	TREATMENT	114	Создание обработки #114: Молбузин - морковь, 1.2 га, норма 0.15 л/га	2026-06-18 12:48:25.306424
238	417	IN	1.200	3.000	MANUAL_IN	\N	Удаление обработки #114: Гезагард - морковь, 1.2 га, норма 1 л/га	2026-06-18 12:48:43.593012
239	447	IN	0.120	4.500	MANUAL_IN	\N	Удаление обработки #114: Рейсер - морковь, 1.2 га, норма 0.1 л/га	2026-06-18 12:48:43.607014
240	453	IN	0.180	5.005	MANUAL_IN	\N	Удаление обработки #114: Молбузин - морковь, 1.2 га, норма 0.15 л/га	2026-06-18 12:48:43.621291
241	417	OUT	1.300	1.700	TREATMENT	115	Создание обработки #115: Гезагард - морковь, 1.3 га, норма 1 л/га	2026-06-18 12:49:15.666934
242	447	OUT	0.130	4.370	TREATMENT	115	Создание обработки #115: Рейсер - морковь, 1.3 га, норма 0.1 л/га	2026-06-18 12:49:15.682487
243	453	OUT	0.195	4.810	TREATMENT	115	Создание обработки #115: Молбузин - морковь, 1.3 га, норма 0.15 л/га	2026-06-18 12:49:15.698993
244	417	IN	1.300	3.000	MANUAL_IN	\N	Удаление обработки #115: Гезагард - морковь, 1.3 га, норма 1 л/га	2026-06-18 12:49:31.005904
245	447	IN	0.130	4.500	MANUAL_IN	\N	Удаление обработки #115: Рейсер - морковь, 1.3 га, норма 0.1 л/га	2026-06-18 12:49:31.029285
246	453	IN	0.195	5.005	MANUAL_IN	\N	Удаление обработки #115: Молбузин - морковь, 1.3 га, норма 0.15 л/га	2026-06-18 12:49:31.0463
256	432	OUT	2.000	8.000	TREATMENT	118	Создание обработки #118: Шанситек - груша, 2 га, норма 1 л/га	2026-06-20 09:45:47.687349
257	425	OUT	2.250	5.200	TREATMENT	119	Создание обработки #119: Митрон - яблоко, 1.5 га, норма 1.5 л/га	2026-06-20 09:51:04.556629
248	418	OUT	2.250	4.500	TREATMENT	116	Создание обработки #116: Дуал Голд - морковь, 1.5 га, норма 1.5 л/га	2026-06-19 09:07:54.042626
233	416	OUT	3.000	35.450	TREATMENT	113	Создание обработки #113: Пирамин Турбо - свекла, 1.5 га, норма 2 л/га	2026-06-18 08:02:13.781971
247	416	OUT	3.000	32.450	TREATMENT	116	Создание обработки #116: Пирамин Турбо - морковь, 1.5 га, норма 2 л/га	2026-06-19 09:07:53.994809
249	416	IN	3.000	35.450	MANUAL_IN	\N	Удаление обработки #116: Пирамин Турбо - морковь, 1.5 га, норма 2 л/га	2026-06-19 13:16:41.725802
250	418	IN	2.250	6.750	MANUAL_IN	\N	Удаление обработки #116: Дуал Голд - морковь, 1.5 га, норма 1.5 л/га	2026-06-19 13:16:41.802932
251	417	OUT	1.500	1.500	TREATMENT	117	Создание обработки #117: Гезагард - морковь, 1.5 га, норма 1 л/га	2026-06-19 13:17:54.57091
252	447	OUT	0.150	4.350	TREATMENT	117	Создание обработки #117: Рейсер - морковь, 1.5 га, норма 0.1 л/га	2026-06-19 13:17:54.58825
253	453	OUT	0.225	4.780	TREATMENT	117	Создание обработки #117: Молбузин - морковь, 1.5 га, норма 0.15 л/га	2026-06-19 13:17:54.604837
254	385	IN	20.000	26.000	MANUAL_IN	\N	Ручной приход: +20 л	2026-06-20 08:01:47.700127
258	442	OUT	3.000	9.500	TREATMENT	119	Создание обработки #119: Бетанал максПро - яблоко, 1.5 га, норма 2 л/га	2026-06-20 09:51:04.573098
259	425	IN	2.250	7.450	MANUAL_IN	\N	Удаление обработки #119: Митрон - яблоко, 1.5 га, норма 1.5 л/га	2026-06-20 09:51:34.293387
260	442	IN	3.000	12.500	MANUAL_IN	\N	Удаление обработки #119: Бетанал максПро - яблоко, 1.5 га, норма 2 л/га	2026-06-20 09:51:34.309527
261	425	OUT	2.250	5.200	TREATMENT	119	Создание обработки #119: Митрон - свекла, 1.5 га, норма 1.5 л/га	2026-06-20 09:51:34.343304
262	442	OUT	3.000	9.500	TREATMENT	119	Создание обработки #119: Бетанал максПро - свекла, 1.5 га, норма 2 л/га	2026-06-20 09:51:34.358598
263	430	OUT	0.600	7.600	TREATMENT	120	Создание обработки #120: Базагран - лук, 4 га, норма 0.15 л/га	2026-06-20 11:01:39.741678
264	440	OUT	0.600	5.800	TREATMENT	120	Создание обработки #120: Акзифор - лук, 4 га, норма 0.15 л/га	2026-06-20 11:01:39.778286
230	402	OUT	0.225	4.565	TREATMENT	111	Создание обработки #111: Эфория - капуста, 1.5 га, норма 0.15 л/га	2026-06-12 08:17:51.74964
266	375	OUT	0.320	2.880	TREATMENT	121	Создание обработки #121: Белис - слива, 0.4 га, норма 0.8 кг/га	2026-06-23 14:58:11.723654
267	405	OUT	0.200	16.310	TREATMENT	121	Создание обработки #121: AMINOMAX 10 - слива, 0.4 га, норма 0.5 л/га	2026-06-23 14:58:11.752667
232	405	OUT	2.000	16.510	TREATMENT	112	Создание обработки #112: AMINOMAX 10 - лук, 4 га, норма 0.5 л/га	2026-06-16 09:31:47.736997
228	430	OUT	0.600	8.200	TREATMENT	110	Создание обработки #110: Базагран - лук, 4 га, норма 0.15 л/га	2026-06-11 11:00:23.161071
314	448	OUT	0.750	0.170	TREATMENT	132	Создание обработки #132: Даш - капуста, 1.5 га, норма 0.5 л/га	2026-07-02 08:38:01.211469
298	439	OUT	0.900	7.100	TREATMENT	126	Создание обработки #126: Квикстеп - свекла, 1.5 га, норма 0.6 л/га	2026-07-02 07:46:50.131394
271	454	IN	20.000	20.000	MANUAL_IN	\N	Начальный остаток при создании: 20 л	2026-06-25 11:20:17.737499
272	455	IN	24.000	24.000	MANUAL_IN	\N	Начальный остаток при создании: 24 л	2026-06-25 11:26:49.839092
273	456	IN	0.060	0.060	MANUAL_IN	\N	Начальный остаток при создании: 0.06 кг	2026-06-26 08:03:36.937572
274	425	OUT	1.500	3.700	TREATMENT	123	Создание обработки #123: Митрон - свекла, 1.5 га, норма 1 л/га	2026-06-26 08:18:05.699552
275	427	OUT	1.200	8.800	TREATMENT	123	Создание обработки #123: Бельведер Форте - свекла, 1.5 га, норма 0.8 л/га	2026-06-26 08:18:05.717647
276	456	OUT	0.045	0.015	TREATMENT	123	Создание обработки #123: Кондор - свекла, 1.5 га, норма 0.03 кг/га	2026-06-26 08:18:05.730752
277	397	OUT	7.850	0.000	MANUAL_ADJUST	\N	Корректировка остатка: 7.85 → 0 л	2026-06-27 06:16:47.875729
215	397	OUT	0.150	5.700	TREATMENT	106	Создание обработки #106: Текнофит pH - капуста, 1.5 га, норма 0.1 л/га	2026-06-05 14:01:00.352847
278	430	OUT	0.600	7.000	TREATMENT	124	Создание обработки #124: Базагран - лук, 4 га, норма 0.15 л/га	2026-06-27 11:46:57.966136
279	440	OUT	0.800	5.000	TREATMENT	124	Создание обработки #124: Акзифор - лук, 4 га, норма 0.2 л/га	2026-06-27 11:46:58.001673
280	457	IN	10.000	10.000	MANUAL_IN	\N	Начальный остаток при создании: 10 кг	2026-06-30 08:14:09.860594
281	457	IN	20.000	30.000	MANUAL_IN	\N	Ручной приход: +20 кг	2026-07-01 04:59:25.206413
282	458	IN	10.000	10.000	MANUAL_IN	\N	Начальный остаток при создании: 10 л	2026-07-02 07:31:00.765158
283	417	OUT	1.500	0.000	TREATMENT	125	Создание обработки #125: Гезагард - морковь, 1 га, норма 1.5 л/га	2026-07-02 07:32:43.123254
270	453	OUT	3.010	1.770	TREATMENT	122	Создание обработки #122: Молбузин - томаты, 4.3 га, норма 0.7 кг/га	2026-06-24 14:39:38.008041
285	453	OUT	0.250	1.520	TREATMENT	125	Создание обработки #125: Молбузин - морковь, 1 га, норма 0.25 кг/га	2026-07-02 07:32:43.166545
286	458	OUT	0.300	9.700	TREATMENT	125	Создание обработки #125: PICO-800 - морковь, 1 га, норма 0.3 л/га	2026-07-02 07:32:43.189275
287	456	IN	0.540	0.555	MANUAL_IN	\N	Ручной приход: +0.54 кг	2026-07-02 07:46:07.002609
299	456	OUT	0.045	0.510	TREATMENT	126	Создание обработки #126: Кондор - свекла, 1.5 га, норма 0.03 кг/га	2026-07-02 07:46:50.142165
290	439	OUT	0.900	7.100	TREATMENT	126	Создание обработки #126: Квикстеп - свекла, 1.5 га, норма 0.6 л/га	2026-07-02 07:46:31.063654
291	456	OUT	0.045	0.510	TREATMENT	126	Создание обработки #126: Кондор - свекла, 1.5 га, норма 0.03 кг/га	2026-07-02 07:46:31.075597
292	425	IN	1.470	3.700	MANUAL_IN	\N	Удаление обработки #126: Митрон - свекла, 1.5 га, норма 0.98 л/га	2026-07-02 07:46:49.991522
300	364	OUT	4.800	0.280	TREATMENT	127	Создание обработки #127: Молния Дуо - яблоко, 12 га, норма 0.4 л/га	2026-07-02 08:01:35.713949
293	427	IN	1.200	8.800	MANUAL_IN	\N	Удаление обработки #126: Бельведер Форте - свекла, 1.5 га, норма 0.8 л/га	2026-07-02 07:46:50.00967
301	385	OUT	14.400	11.600	TREATMENT	127	Создание обработки #127: Луна Транквилити - яблоко, 12 га, норма 1.2 л/га	2026-07-02 08:01:35.739975
294	439	IN	0.900	8.000	MANUAL_IN	\N	Удаление обработки #126: Квикстеп - свекла, 1.5 га, норма 0.6 л/га	2026-07-02 07:46:50.027937
295	456	IN	0.045	0.555	MANUAL_IN	\N	Удаление обработки #126: Кондор - свекла, 1.5 га, норма 0.03 кг/га	2026-07-02 07:46:50.039833
296	425	OUT	1.500	2.200	TREATMENT	126	Создание обработки #126: Митрон - свекла, 1.5 га, норма 1 л/га	2026-07-02 07:46:50.093045
288	425	OUT	1.470	2.230	TREATMENT	126	Создание обработки #126: Митрон - свекла, 1.5 га, норма 0.98 л/га	2026-07-02 07:46:31.031267
289	427	OUT	1.200	7.600	TREATMENT	126	Создание обработки #126: Бельведер Форте - свекла, 1.5 га, норма 0.8 л/га	2026-07-02 07:46:31.048818
297	427	OUT	1.200	7.600	TREATMENT	126	Создание обработки #126: Бельведер Форте - свекла, 1.5 га, норма 0.8 л/га	2026-07-02 07:46:50.111148
302	403	OUT	2.400	8.620	TREATMENT	127	Создание обработки #127: Дискор - яблоко, 12 га, норма 0.2 л/га	2026-07-02 08:01:35.758862
303	378	OUT	10.000	0.000	TREATMENT	128	Создание обработки #128: Карамба - груша, 8 га, норма 1.25 л/га	2026-07-02 08:13:22.849198
304	404	OUT	1.600	18.400	TREATMENT	128	Создание обработки #128: Скорошанс - груша, 8 га, норма 0.2 л/га	2026-07-02 08:13:22.86983
305	404	OUT	3.200	15.200	TREATMENT	129	Создание обработки #129: Скорошанс - груша, 8 га, норма 0.4 л/га	2026-07-02 08:15:30.085134
306	437	OUT	1.200	8.800	TREATMENT	129	Создание обработки #129: Тиамакс - груша, 8 га, норма 0.15 л/га	2026-07-02 08:15:30.101297
307	367	OUT	0.129	2.871	TREATMENT	130	Создание обработки #130: Агролан - томаты, 4.3 га, норма 0.03 л/га	2026-07-02 08:22:13.684403
308	457	OUT	10.750	19.250	TREATMENT	130	Создание обработки #130: Метамил - томаты, 4.3 га, норма 2.5 кг/га	2026-07-02 08:22:13.70165
309	458	OUT	1.290	8.410	TREATMENT	130	Создание обработки #130: PICO-800 - томаты, 4.3 га, норма 0.3 л/га	2026-07-02 08:22:13.719792
310	459	IN	5.000	5.000	MANUAL_IN	\N	Начальный остаток при создании: 5 л	2026-07-02 08:24:02.946698
311	421	OUT	2.000	22.000	TREATMENT	131	Создание обработки #131: Боксер - лук, 4 га, норма 0.5 л/га	2026-07-02 08:24:31.147463
312	459	OUT	2.000	3.000	TREATMENT	131	Создание обработки #131: Бандуро - лук, 4 га, норма 0.5 л/га	2026-07-02 08:24:31.163984
313	402	OUT	0.450	4.115	TREATMENT	132	Создание обработки #132: Эфория - капуста, 1.5 га, норма 0.3 л/га	2026-07-02 08:38:01.16585
284	447	OUT	0.200	4.150	TREATMENT	125	Создание обработки #125: Рейсер - морковь, 1 га, норма 0.2 л/га	2026-07-02 07:32:43.142593
269	448	OUT	2.580	0.920	TREATMENT	122	Создание обработки #122: Даш - томаты, 4.3 га, норма 0.6 л/га	2026-06-24 14:39:37.979711
315	413	OUT	0.300	0.700	TREATMENT	133	Создание обработки #133: Актара - капуста, 1 га, норма 0.3 кг/га	2026-07-02 09:03:17.726247
316	458	OUT	0.300	8.110	TREATMENT	133	Создание обработки #133: PICO-800 - капуста, 1 га, норма 0.3 л/га	2026-07-02 09:03:17.742601
317	385	IN	20.000	31.600	MANUAL_IN	\N	Ручной приход: +20 л	2026-07-02 10:57:33.808299
318	378	IN	10.000	10.000	MANUAL_IN	\N	Удаление обработки #128: Карамба - груша, 8 га, норма 1.25 л/га	2026-07-02 10:58:52.960374
319	404	IN	1.600	16.800	MANUAL_IN	\N	Удаление обработки #128: Скорошанс - груша, 8 га, норма 0.2 л/га	2026-07-02 10:58:52.974234
320	433	IN	3.040	6.040	MANUAL_IN	\N	Удаление обработки #128: Вирий - груша, 8 га, норма 0.38 л/га	2026-07-02 10:58:52.988742
321	404	IN	3.200	20.000	MANUAL_IN	\N	Удаление обработки #129: Скорошанс - груша, 8 га, норма 0.4 л/га	2026-07-02 10:58:54.515993
322	437	IN	1.200	10.000	MANUAL_IN	\N	Удаление обработки #129: Тиамакс - груша, 8 га, норма 0.15 л/га	2026-07-02 10:58:54.530161
335	405	OUT	1.500	14.810	TREATMENT	137	Создание обработки #137: AMINOMAX 10 - морковь, 1.5 га, норма 1 л/га	2026-07-02 11:15:04.972918
324	404	OUT	2.400	17.600	TREATMENT	134	Создание обработки #134: Скорошанс - груша, 12 га, норма 0.2 л/га	2026-07-02 11:01:25.25041
325	433	OUT	3.000	3.040	TREATMENT	134	Создание обработки #134: Вирий - груша, 12 га, норма 0.25 л/га	2026-07-02 11:01:25.264733
323	385	OUT	14.400	17.200	TREATMENT	134	Создание обработки #134: Луна Транквилити - груша, 12 га, норма 1.2 л/га	2026-07-02 11:01:25.230525
326	385	OUT	4.800	12.400	TREATMENT	135	Создание обработки #135: Луна Транквилити - груша, 4 га, норма 1.2 л/га	2026-07-02 11:02:12.414443
327	404	OUT	0.800	16.800	TREATMENT	135	Создание обработки #135: Скорошанс - груша, 4 га, норма 0.2 л/га	2026-07-02 11:02:12.436072
328	437	OUT	0.600	9.400	TREATMENT	135	Создание обработки #135: Тиамакс - груша, 4 га, норма 0.15 л/га	2026-07-02 11:02:12.451721
329	417	IN	1.500	1.500	MANUAL_IN	\N	Удаление обработки #125: Гезагард - морковь, 1 га, норма 1.5 л/га	2026-07-02 11:11:03.031434
330	447	IN	0.200	4.350	MANUAL_IN	\N	Удаление обработки #125: Рейсер - морковь, 1 га, норма 0.2 л/га	2026-07-02 11:11:03.045428
358	453	IN	1.299	1.770	MANUAL_IN	\N	Удаление обработки #143: Молбузин - томаты, 4.33 га, норма 0.3 кг/га	2026-07-10 11:02:09.649636
332	458	IN	0.300	8.410	MANUAL_IN	\N	Удаление обработки #125: PICO-800 - морковь, 1 га, норма 0.3 л/га	2026-07-02 11:11:03.086062
333	429	OUT	1.200	13.275	TREATMENT	136	Создание обработки #136: Нуфлон - морковь, 1 га, норма 1.2 л/га	2026-07-02 11:12:46.410889
334	439	OUT	0.800	6.300	TREATMENT	136	Создание обработки #136: Квикстеп - морковь, 1 га, норма 0.8 л/га	2026-07-02 11:12:46.42397
338	405	OUT	2.000	14.810	TREATMENT	138	Создание обработки #138: AMINOMAX 10 - лук, 4 га, норма 0.5 л/га	2026-07-04 07:00:36.836376
336	408	OUT	4.500	55.500	TREATMENT	137	Создание обработки #137: Магний сернокислый - морковь, 1.5 га, норма 3 кг/га	2026-07-02 11:15:05.0216
337	405	IN	2.000	16.810	MANUAL_IN	\N	Удаление обработки #112: AMINOMAX 10 - лук, 4 га, норма 0.5 л/га	2026-07-04 06:59:30.314384
345	457	OUT	8.000	11.250	TREATMENT	139	Создание обработки #139: Метамил - лук, 4 га, норма 2 кг/га	2026-07-04 09:55:05.185373
346	458	OUT	1.200	7.210	TREATMENT	139	Создание обработки #139: PICO-800 - лук, 4 га, норма 0.3 л/га	2026-07-04 09:55:05.199562
347	419	OUT	2.000	1.000	TREATMENT	140	Создание обработки #140: Султан - капуста, 1 га, норма 2 л/га	2026-07-05 07:20:18.677096
339	457	OUT	10.000	9.250	TREATMENT	138	Создание обработки #138: Метамил - лук, 4 га, норма 2.5 кг/га	2026-07-04 07:00:36.889554
340	458	OUT	1.200	7.210	TREATMENT	138	Создание обработки #138: PICO-800 - лук, 4 га, норма 0.3 л/га	2026-07-04 07:00:36.909176
341	405	IN	2.000	16.810	MANUAL_IN	\N	Удаление обработки #138: AMINOMAX 10 - лук, 4 га, норма 0.5 л/га	2026-07-04 09:53:38.856921
348	419	OUT	1.000	0.000	MANUAL_ADJUST	\N	Корректировка остатка: 1 → 0 л	2026-07-05 10:30:43.44316
344	405	OUT	2.000	14.810	TREATMENT	139	Создание обработки #139: AMINOMAX 10 - лук, 4 га, норма 0.5 л/га	2026-07-04 09:55:05.125058
342	457	IN	10.000	19.250	MANUAL_IN	\N	Удаление обработки #138: Метамил - лук, 4 га, норма 2.5 кг/га	2026-07-04 09:53:38.915096
343	458	IN	1.200	8.410	MANUAL_IN	\N	Удаление обработки #138: PICO-800 - лук, 4 га, норма 0.3 л/га	2026-07-04 09:53:38.931978
351	405	OUT	0.750	15.560	TREATMENT	141	Создание обработки #141: AMINOMAX 10 - морковь, 1.5 га, норма 0.5 л/га	2026-07-09 06:36:58.059552
349	405	IN	1.500	16.310	MANUAL_IN	\N	Удаление обработки #137: AMINOMAX 10 - морковь, 1.5 га, норма 1 л/га	2026-07-09 06:35:36.860277
352	408	OUT	4.500	55.500	TREATMENT	141	Создание обработки #141: Магний сернокислый - морковь, 1.5 га, норма 3 кг/га	2026-07-09 06:36:58.142379
353	445	OUT	3.000	14.000	TREATMENT	142	Создание обработки #142: Фюзилад Форте - свекла, 1.5 га, норма 2 л/га	2026-07-09 08:00:19.345524
354	387	OUT	0.087	0.127	TREATMENT	143	Создание обработки #143: Эскудо - томаты, 4.33 га, норма 0.02 кг/га	2026-07-10 07:17:36.141127
350	408	IN	4.500	60.000	MANUAL_IN	\N	Удаление обработки #137: Магний сернокислый - морковь, 1.5 га, норма 3 кг/га	2026-07-09 06:35:37.06869
355	453	OUT	1.299	0.471	TREATMENT	143	Создание обработки #143: Молбузин - томаты, 4.33 га, норма 0.3 кг/га	2026-07-10 07:17:36.164693
356	458	OUT	1.299	5.911	TREATMENT	143	Создание обработки #143: PICO-800 - томаты, 4.33 га, норма 0.3 л/га	2026-07-10 07:17:36.203189
357	387	IN	0.087	0.214	MANUAL_IN	\N	Удаление обработки #143: Эскудо - томаты, 4.33 га, норма 0.02 кг/га	2026-07-10 11:02:09.59905
360	387	OUT	0.090	0.124	TREATMENT	144	Создание обработки #144: Эскудо - томаты, 4.5 га, норма 0.02 кг/га	2026-07-10 11:03:15.489186
387	384	OUT	10.000	5.000	TREATMENT	149	Создание обработки #149: Ридомил Голд - лук, 4 га, норма 2.5 кг/га	2026-07-25 11:29:17.859754
376	404	IN	0.800	17.600	MANUAL_IN	\N	Удаление обработки #135: Скорошанс - груша, 4 га, норма 0.2 л/га	2026-07-25 11:26:44.564472
377	437	IN	0.600	10.000	MANUAL_IN	\N	Удаление обработки #135: Тиамакс - груша, 4 га, норма 0.15 л/га	2026-07-25 11:26:44.581812
378	385	IN	14.400	31.600	MANUAL_IN	\N	Удаление обработки #134: Луна Транквилити - груша, 12 га, норма 1.2 л/га	2026-07-25 11:26:47.0277
363	387	IN	0.090	0.214	MANUAL_IN	\N	Удаление обработки #144: Эскудо - томаты, 4.5 га, норма 0.02 кг/га	2026-07-10 11:03:25.660611
379	404	IN	2.400	20.000	MANUAL_IN	\N	Удаление обработки #134: Скорошанс - груша, 12 га, норма 0.2 л/га	2026-07-25 11:26:47.055322
380	433	IN	3.000	6.040	MANUAL_IN	\N	Удаление обработки #134: Вирий - груша, 12 га, норма 0.25 л/га	2026-07-25 11:26:47.073386
375	385	IN	4.800	17.200	MANUAL_IN	\N	Удаление обработки #135: Луна Транквилити - груша, 4 га, норма 1.2 л/га	2026-07-25 11:26:44.528865
381	385	OUT	19.200	12.400	TREATMENT	148	Создание обработки #148: Луна Транквилити - груша, 16 га, норма 1.2 л/га	2026-07-25 11:27:38.20563
366	387	OUT	0.090	0.124	TREATMENT	144	Создание обработки #144: Эскудо - томаты, 4.5 га, норма 0.02 кг/га	2026-07-10 11:03:25.936148
331	453	IN	0.250	1.770	MANUAL_IN	\N	Удаление обработки #125: Молбузин - морковь, 1 га, норма 0.25 кг/га	2026-07-02 11:11:03.06232
361	453	OUT	1.350	0.420	TREATMENT	144	Создание обработки #144: Молбузин - томаты, 4.5 га, норма 0.3 кг/га	2026-07-10 11:03:15.506829
364	453	IN	1.350	1.770	MANUAL_IN	\N	Удаление обработки #144: Молбузин - томаты, 4.5 га, норма 0.3 кг/га	2026-07-10 11:03:25.679184
367	453	OUT	1.350	0.420	TREATMENT	144	Создание обработки #144: Молбузин - томаты, 4.5 га, норма 0.3 кг/га	2026-07-10 11:03:25.953613
382	404	OUT	3.200	16.800	TREATMENT	148	Создание обработки #148: Скорошанс - груша, 16 га, норма 0.2 л/га	2026-07-25 11:27:38.237778
383	437	OUT	5.600	4.400	TREATMENT	148	Создание обработки #148: Тиамакс - груша, 16 га, норма 0.35 л/га	2026-07-25 11:27:38.253924
384	384	IN	8.000	15.000	MANUAL_IN	\N	Удаление обработки #147: Ридомил Голд - лук, 4 га, норма 2 кг/га	2026-07-25 11:28:35.955547
369	445	OUT	2.000	12.000	TREATMENT	145	Создание обработки #145: Фюзилад Форте - морковь, 1 га, норма 2 л/га	2026-07-12 08:10:40.175179
370	438	OUT	10.000	10.000	TREATMENT	146	Создание обработки #146: Спрут Экстра - другое, 2 га, норма 5 л/га	2026-07-12 09:08:44.433642
371	438	OUT	10.000	0.000	MANUAL_ADJUST	\N	Корректировка остатка: 10 → 0 л	2026-07-12 09:09:26.571657
372	384	OUT	8.000	7.000	TREATMENT	147	Создание обработки #147: Ридомил Голд - лук, 4 га, норма 2 кг/га	2026-07-25 08:18:45.423965
388	405	OUT	2.000	13.560	TREATMENT	149	Создание обработки #149: AMINOMAX 10 - лук, 4 га, норма 0.5 л/га	2026-07-25 11:29:17.876281
403	405	OUT	2.000	11.560	TREATMENT	154	Создание обработки #154: AMINOMAX 10 - лук, 4 га, норма 0.5 л/га	2026-08-02 08:38:44.524407
365	458	IN	1.350	7.210	MANUAL_IN	\N	Удаление обработки #144: PICO-800 - томаты, 4.5 га, норма 0.3 л/га	2026-07-10 11:03:25.725946
368	458	OUT	1.350	5.860	TREATMENT	144	Создание обработки #144: PICO-800 - томаты, 4.5 га, норма 0.3 л/га	2026-07-10 11:03:26.00555
392	370	OUT	2.000	4.000	TREATMENT	150	Создание обработки #150: Квадрис - яблоко, 1 га, норма 2 л/га	2026-07-25 12:34:26.025292
393	370	IN	2.000	6.000	MANUAL_IN	\N	Удаление обработки #150: Квадрис - яблоко, 1 га, норма 2 л/га	2026-07-25 12:34:51.019325
394	398	OUT	2.250	27.750	TREATMENT	151	Создание обработки #151: Бор - свекла, 1.5 га, норма 1.5 л/га	2026-07-26 09:38:25.469236
395	422	IN	10.000	13.400	MANUAL_IN	\N	Ручной приход: +10 л	2026-07-30 08:06:39.355388
396	452	OUT	10.000	4.000	MANUAL_ADJUST	\N	Корректировка остатка: 14 → 4 л	2026-07-30 08:07:18.883176
397	452	IN	10.000	14.000	MANUAL_IN	\N	Ручной приход: +10 л	2026-07-30 13:30:59.539264
374	458	OUT	1.000	4.860	TREATMENT	147	Создание обработки #147: PICO-800 - лук, 4 га, норма 0.25 л/га	2026-07-25 08:18:45.532263
386	458	IN	1.000	5.860	MANUAL_IN	\N	Удаление обработки #147: PICO-800 - лук, 4 га, норма 0.25 л/га	2026-07-25 11:28:36.031121
389	458	OUT	1.000	4.860	TREATMENT	149	Создание обработки #149: PICO-800 - лук, 4 га, норма 0.25 л/га	2026-07-25 11:29:17.947367
404	458	OUT	1.000	3.860	TREATMENT	154	Создание обработки #154: PICO-800 - лук, 4 га, норма 0.25 л/га	2026-08-02 08:38:44.617753
373	405	OUT	2.000	13.560	TREATMENT	147	Создание обработки #147: AMINOMAX 10 - лук, 4 га, норма 0.5 л/га	2026-07-25 08:18:45.448765
398	452	IN	10.000	24.000	MANUAL_IN	\N	Ручной приход: +10 л	2026-07-30 13:32:09.283877
399	452	OUT	20.000	4.000	TREATMENT	152	Создание обработки #152: Тотал 480 - другое, 4 га, норма 5 л/га	2026-07-30 13:32:24.650522
400	411	OUT	12.000	88.000	TREATMENT	153	Создание обработки #153: Нитрат кальция - лук, 4 га, норма 3 кг/га	2026-07-31 09:04:36.652736
401	369	OUT	4.000	23.000	TREATMENT	154	Создание обработки #154: Интрада - лук, 4 га, норма 1 л/га	2026-08-02 08:38:44.488438
402	376	OUT	1.600	23.000	TREATMENT	154	Создание обработки #154: Раёк - лук, 4 га, норма 0.4 л/га	2026-08-02 08:38:44.507654
385	405	IN	2.000	15.560	MANUAL_IN	\N	Удаление обработки #147: AMINOMAX 10 - лук, 4 га, норма 0.5 л/га	2026-07-25 11:28:35.971476
362	458	OUT	1.350	5.860	TREATMENT	144	Создание обработки #144: PICO-800 - томаты, 4.5 га, норма 0.3 л/га	2026-07-10 11:03:15.549863
405	411	OUT	36.000	52.000	TREATMENT	155	Создание обработки #155: Нитрат кальция - яблоко, 12 га, норма 3 кг/га	2026-08-02 08:40:31.340774
406	398	OUT	4.500	23.250	TREATMENT	156	Создание обработки #156: Бор - свекла, 1.5 га, норма 3 л/га	2026-08-04 09:44:35.194074
407	398	IN	4.500	27.750	MANUAL_IN	\N	Удаление обработки #156: Бор - свекла, 1.5 га, норма 3 л/га	2026-08-04 09:44:50.217473
408	398	OUT	4.500	23.250	TREATMENT	157	Создание обработки #157: Бор - свекла, 1.5 га, норма 3 л/га	2026-08-04 09:45:41.440911
409	398	IN	4.500	27.750	MANUAL_IN	\N	Удаление обработки #157: Бор - свекла, 1.5 га, норма 3 л/га	2026-08-04 09:46:05.457357
410	398	OUT	2.250	25.500	TREATMENT	158	Создание обработки #158: Бор - свекла, 1.5 га, норма 1.5 л/га	2026-08-04 09:46:19.577472
411	398	IN	2.250	27.750	MANUAL_IN	\N	Удаление обработки #158: Бор - свекла, 1.5 га, норма 1.5 л/га	2026-08-04 09:46:49.624553
412	398	OUT	4.500	23.250	TREATMENT	158	Создание обработки #158: Бор - свекла, 1.5 га, норма 3 л/га	2026-08-04 09:46:49.670653
413	398	IN	4.500	27.750	MANUAL_IN	\N	Удаление обработки #158: Бор - свекла, 1.5 га, норма 3 л/га	2026-08-04 09:47:17.414549
414	398	OUT	2.250	25.500	TREATMENT	158	Создание обработки #158: Бор - свекла, 1.5 га, норма 1.5 л/га	2026-08-04 09:47:17.46167
415	369	OUT	1.500	21.500	TREATMENT	159	Создание обработки #159: Интрада - свекла, 1.5 га, норма 1 л/га	2026-08-05 06:37:04.278616
416	376	OUT	0.600	22.400	TREATMENT	159	Создание обработки #159: Раёк - свекла, 1.5 га, норма 0.4 л/га	2026-08-05 06:37:04.297077
359	458	IN	1.299	7.210	MANUAL_IN	\N	Удаление обработки #143: PICO-800 - томаты, 4.33 га, норма 0.3 л/га	2026-07-10 11:02:09.713927
417	458	OUT	0.375	3.485	TREATMENT	159	Создание обработки #159: PICO-800 - свекла, 1.5 га, норма 0.25 л/га	2026-08-05 06:37:04.309686
418	405	IN	0.750	12.310	MANUAL_IN	\N	Удаление обработки #141: AMINOMAX 10 - морковь, 1.5 га, норма 0.5 л/га	2026-08-06 13:48:41.578088
419	408	IN	4.500	60.000	MANUAL_IN	\N	Удаление обработки #141: Магний сернокислый - морковь, 1.5 га, норма 3 кг/га	2026-08-06 13:48:41.724214
\.


--
-- Data for Name: maintenance_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maintenance_records (id, "vehicleId", "vehicleName", type, date, hours, description, notes, "createdAt") FROM stdin;
4	12	МТЗ 80 [ГТ 9230]	Плановое ТО	2026-03-10	\N	-Замена рулевой колонки\n-Замена рулевого цилиндра	\N	2026-05-17 11:49:34.951744
5	6	ГАЗ 377030 [AA 2655-3]	Внеплановый ремонт	2026-04-01	\N	-Замена топливных форсунок\n-Замена ТНВД	\N	2026-05-17 11:50:33.139475
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name, unit, "createdAt", "updatedAt") FROM stdin;
2	Груша	кг	2026-08-05 08:09:21.725659	2026-08-05 08:09:21.725659
4	Яблоко	кг	2026-08-05 09:29:50.275304	2026-08-05 09:29:50.275304
5	Картофель	кг	2026-08-05 09:30:23.906104	2026-08-05 09:30:23.906104
6	Огурец	кг	2026-08-05 09:30:45.232262	2026-08-05 09:30:45.232262
1	Томат	кг	2026-08-05 08:09:16.939253	2026-08-05 09:30:56.598925
7	Свёкла	кг	2026-08-05 09:31:29.758778	2026-08-05 09:31:29.758778
8	Морковь	кг	2026-08-05 09:31:52.751158	2026-08-05 09:31:52.751158
9	Белокочанная капуста	кг	2026-08-05 09:32:08.393935	2026-08-05 09:32:08.393935
10	Слива	кг	2026-08-05 11:54:38.372136	2026-08-05 11:54:38.372136
11	Кабачок	кг	2026-08-05 11:56:20.530655	2026-08-05 11:56:20.530655
12	Лук	кг	2026-08-05 15:06:19.468852	2026-08-05 15:06:19.468852
\.


--
-- Data for Name: shipment_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipment_items (id, "shipmentId", "productId", quantity, "returnQuantity", "createdAt", "updatedAt", "pricePerUnit") FROM stdin;
91	19	12	834.00	\N	2026-08-06 06:42:01.121299	2026-08-06 06:42:01.121299	0.88
92	20	12	1358.00	\N	2026-08-06 06:42:48.137872	2026-08-06 06:42:48.137872	0.88
94	17	9	4366.00	\N	2026-08-06 06:43:29.180047	2026-08-06 06:43:29.180047	1.10
95	21	9	3540.00	\N	2026-08-06 06:44:22.036398	2026-08-06 06:44:22.036398	1.10
96	22	9	5227.00	\N	2026-08-06 06:45:17.919602	2026-08-06 06:45:17.919602	1.10
97	23	12	2023.00	\N	2026-08-06 06:47:36.652254	2026-08-06 06:47:36.652254	0.88
98	23	7	1087.00	\N	2026-08-06 06:47:36.652254	2026-08-06 06:47:36.652254	0.61
99	24	9	66.50	33.00	2026-08-06 06:51:12.145236	2026-08-06 06:51:12.145236	1.30
100	24	4	51.00	31.70	2026-08-06 06:51:12.145236	2026-08-06 06:51:12.145236	1.00
101	24	2	62.00	47.00	2026-08-06 06:51:12.145236	2026-08-06 06:51:12.145236	5.50
102	24	6	43.30	17.35	2026-08-06 06:51:12.145236	2026-08-06 06:51:12.145236	3.00
103	24	11	84.00	64.00	2026-08-06 06:51:12.145236	2026-08-06 06:51:12.145236	1.00
104	24	8	41.00	10.00	2026-08-06 06:51:12.145236	2026-08-06 06:51:12.145236	1.50
105	24	5	30.00	29.50	2026-08-06 06:51:12.145236	2026-08-06 06:51:12.145236	0.70
106	24	7	24.50	9.40	2026-08-06 06:51:12.145236	2026-08-06 06:51:12.145236	2.00
107	24	1	230.50	170.50	2026-08-06 06:51:12.145236	2026-08-06 06:51:12.145236	4.00
108	24	5	57.50	55.00	2026-08-06 06:51:12.145236	2026-08-06 06:51:12.145236	1.70
109	25	9	78.00	65.50	2026-08-06 06:55:39.764544	2026-08-06 06:55:39.764544	1.30
110	25	4	50.50	25.45	2026-08-06 06:55:39.764544	2026-08-06 06:55:39.764544	1.00
111	25	2	62.50	45.00	2026-08-06 06:55:39.764544	2026-08-06 06:55:39.764544	5.50
112	25	6	51.10	31.40	2026-08-06 06:55:39.764544	2026-08-06 06:55:39.764544	3.00
113	25	11	95.00	77.00	2026-08-06 06:55:39.764544	2026-08-06 06:55:39.764544	1.00
114	25	8	33.00	33.00	2026-08-06 06:55:39.764544	2026-08-06 06:55:39.764544	1.50
115	25	5	45.00	37.50	2026-08-06 06:55:39.764544	2026-08-06 06:55:39.764544	1.70
116	25	5	40.00	33.50	2026-08-06 06:55:39.764544	2026-08-06 06:55:39.764544	0.70
117	25	7	18.50	12.35	2026-08-06 06:55:39.764544	2026-08-06 06:55:39.764544	2.00
118	25	1	233.50	99.00	2026-08-06 06:55:39.764544	2026-08-06 06:55:39.764544	4.00
119	26	2	500.00	\N	2026-08-06 06:57:32.58149	2026-08-06 06:57:32.58149	4.07
120	27	9	68.50	47.00	2026-08-06 07:08:57.304502	2026-08-06 07:08:57.304502	1.30
121	27	4	41.00	22.00	2026-08-06 07:08:57.304502	2026-08-06 07:08:57.304502	1.00
122	27	2	15.20	6.00	2026-08-06 07:08:57.304502	2026-08-06 07:08:57.304502	5.50
123	27	6	42.50	36.75	2026-08-06 07:08:57.304502	2026-08-06 07:08:57.304502	3.00
124	27	11	95.00	70.00	2026-08-06 07:08:57.304502	2026-08-06 07:08:57.304502	1.00
125	27	8	29.00	12.00	2026-08-06 07:08:57.304502	2026-08-06 07:08:57.304502	1.50
126	27	1	252.90	161.00	2026-08-06 07:08:57.304502	2026-08-06 07:08:57.304502	4.00
127	27	5	39.00	30.00	2026-08-06 07:08:57.304502	2026-08-06 07:08:57.304502	0.70
128	27	5	68.70	61.00	2026-08-06 07:08:57.304502	2026-08-06 07:08:57.304502	1.70
129	27	10	18.60	1.00	2026-08-06 07:08:57.304502	2026-08-06 07:08:57.304502	3.50
130	27	7	21.20	7.50	2026-08-06 07:08:57.304502	2026-08-06 07:08:57.304502	2.00
131	28	9	59.50	28.00	2026-08-06 07:14:20.567613	2026-08-06 07:14:20.567613	1.30
132	28	4	42.00	21.50	2026-08-06 07:14:20.567613	2026-08-06 07:14:20.567613	1.00
133	28	2	25.20	16.00	2026-08-06 07:14:20.567613	2026-08-06 07:14:20.567613	5.50
134	28	6	42.40	35.95	2026-08-06 07:14:20.567613	2026-08-06 07:14:20.567613	3.00
45	7	9	59.00	40.00	2026-08-05 14:07:19.023904	2026-08-05 14:07:19.023904	1.30
46	7	4	35.50	33.00	2026-08-05 14:07:19.023904	2026-08-05 14:07:19.023904	1.00
47	7	2	45.00	30.50	2026-08-05 14:07:19.023904	2026-08-05 14:07:19.023904	5.50
48	7	6	46.90	45.45	2026-08-05 14:07:19.023904	2026-08-05 14:07:19.023904	3.00
49	7	11	74.50	59.50	2026-08-05 14:07:19.023904	2026-08-05 14:07:19.023904	1.00
50	7	8	32.90	29.00	2026-08-05 14:07:19.023904	2026-08-05 14:07:19.023904	1.50
51	7	5	35.50	22.00	2026-08-05 14:07:19.023904	2026-08-05 14:07:19.023904	0.70
52	7	5	37.50	17.50	2026-08-05 14:07:19.023904	2026-08-05 14:07:19.023904	1.70
53	7	7	22.40	19.50	2026-08-05 14:07:19.023904	2026-08-05 14:07:19.023904	2.00
54	7	1	181.50	122.50	2026-08-05 14:07:19.023904	2026-08-05 14:07:19.023904	4.00
55	8	9	61.50	23.00	2026-08-05 14:56:30.689609	2026-08-05 14:56:30.689609	1.30
56	8	4	46.00	41.00	2026-08-05 14:56:30.689609	2026-08-05 14:56:30.689609	1.00
57	8	2	47.00	26.00	2026-08-05 14:56:30.689609	2026-08-05 14:56:30.689609	5.50
58	8	6	55.35	38.15	2026-08-05 14:56:30.689609	2026-08-05 14:56:30.689609	3.00
59	8	11	79.50	55.80	2026-08-05 14:56:30.689609	2026-08-05 14:56:30.689609	1.00
60	8	8	39.00	26.50	2026-08-05 14:56:30.689609	2026-08-05 14:56:30.689609	1.50
61	8	5	40.00	31.50	2026-08-05 14:56:30.689609	2026-08-05 14:56:30.689609	0.70
62	8	5	55.00	51.50	2026-08-05 14:56:30.689609	2026-08-05 14:56:30.689609	1.70
63	8	7	15.60	8.50	2026-08-05 14:56:30.689609	2026-08-05 14:56:30.689609	2.00
64	8	1	228.00	166.00	2026-08-05 14:56:30.689609	2026-08-05 14:56:30.689609	4.00
65	9	2	1069.00	\N	2026-08-05 15:03:02.030272	2026-08-05 15:03:02.030272	3.63
66	10	9	2097.00	\N	2026-08-05 15:08:47.441128	2026-08-05 15:08:47.441128	0.60
67	10	12	2685.00	\N	2026-08-05 15:08:47.441128	2026-08-05 15:08:47.441128	0.88
68	11	9	2029.00	\N	2026-08-05 15:10:42.690541	2026-08-05 15:10:42.690541	0.61
69	11	8	1529.00	\N	2026-08-05 15:10:42.690541	2026-08-05 15:10:42.690541	0.50
70	12	7	2179.00	\N	2026-08-05 15:12:37.788649	2026-08-05 15:12:37.788649	0.61
71	13	9	2025.00	\N	2026-08-05 15:14:15.027293	2026-08-05 15:14:15.027293	0.61
72	13	8	446.00	\N	2026-08-05 15:14:15.027293	2026-08-05 15:14:15.027293	0.50
135	28	11	59.50	36.00	2026-08-06 07:14:20.567613	2026-08-06 07:14:20.567613	1.00
136	28	8	20.50	17.50	2026-08-06 07:14:20.567613	2026-08-06 07:14:20.567613	1.50
137	28	5	37.50	24.00	2026-08-06 07:14:20.567613	2026-08-06 07:14:20.567613	0.70
138	28	5	48.00	45.50	2026-08-06 07:14:20.567613	2026-08-06 07:14:20.567613	1.70
139	28	10	14.10	0.45	2026-08-06 07:14:20.567613	2026-08-06 07:14:20.567613	3.50
140	28	7	20.70	7.50	2026-08-06 07:14:20.567613	2026-08-06 07:14:20.567613	2.00
141	29	9	83.00	45.00	2026-08-06 07:21:49.30431	2026-08-06 07:21:49.30431	1.30
80	15	12	600.00	\N	2026-08-06 06:27:25.706836	2026-08-06 06:27:25.706836	0.88
142	29	4	49.00	41.00	2026-08-06 07:21:49.30431	2026-08-06 07:21:49.30431	1.00
143	29	2	39.00	17.90	2026-08-06 07:21:49.30431	2026-08-06 07:21:49.30431	5.50
144	29	6	74.90	43.45	2026-08-06 07:21:49.30431	2026-08-06 07:21:49.30431	3.50
145	29	11	123.00	100.50	2026-08-06 07:21:49.30431	2026-08-06 07:21:49.30431	1.00
146	29	8	36.00	12.00	2026-08-06 07:21:49.30431	2026-08-06 07:21:49.30431	1.50
147	29	1	208.70	129.45	2026-08-06 07:21:49.30431	2026-08-06 07:21:49.30431	5.00
88	16	12	1608.00	\N	2026-08-06 06:37:13.34095	2026-08-06 06:37:13.34095	0.88
89	14	9	2081.00	\N	2026-08-06 06:39:08.161381	2026-08-06 06:39:08.161381	1.00
148	29	5	76.50	36.00	2026-08-06 07:21:49.30431	2026-08-06 07:21:49.30431	0.70
149	29	1	20.00	4.75	2026-08-06 07:21:49.30431	2026-08-06 07:21:49.30431	2.50
150	29	10	51.10	2.80	2026-08-06 07:21:49.30431	2026-08-06 07:21:49.30431	3.50
151	30	9	89.00	56.50	2026-08-06 07:28:54.568916	2026-08-06 07:28:54.568916	1.30
152	30	4	59.50	44.50	2026-08-06 07:28:54.568916	2026-08-06 07:28:54.568916	1.00
153	30	2	35.00	25.20	2026-08-06 07:28:54.568916	2026-08-06 07:28:54.568916	5.50
154	30	6	35.00	25.20	2026-08-06 07:28:54.568916	2026-08-06 07:28:54.568916	3.50
155	30	11	89.00	62.50	2026-08-06 07:28:54.568916	2026-08-06 07:28:54.568916	1.00
156	30	8	23.20	20.50	2026-08-06 07:28:54.568916	2026-08-06 07:28:54.568916	1.50
157	30	5	81.50	48.00	2026-08-06 07:28:54.568916	2026-08-06 07:28:54.568916	1.70
158	30	1	232.00	165.50	2026-08-06 07:28:54.568916	2026-08-06 07:28:54.568916	5.00
159	30	10	37.00	1.60	2026-08-06 07:28:54.568916	2026-08-06 07:28:54.568916	3.50
160	31	5	256.30	77.50	2026-08-06 08:16:15.414611	2026-08-06 08:16:15.414611	1.70
161	31	11	49.50	12.70	2026-08-06 08:16:15.414611	2026-08-06 08:16:15.414611	1.00
162	31	11	196.50	86.90	2026-08-06 08:16:15.414611	2026-08-06 08:16:15.414611	1.00
163	31	10	98.50	9.20	2026-08-06 08:16:15.414611	2026-08-06 08:16:15.414611	3.50
164	31	2	61.30	27.60	2026-08-06 08:16:15.414611	2026-08-06 08:16:15.414611	5.50
165	31	6	254.20	52.00	2026-08-06 08:16:15.414611	2026-08-06 08:16:15.414611	3.50
166	31	9	336.10	202.90	2026-08-06 08:16:15.414611	2026-08-06 08:16:15.414611	1.30
167	31	4	41.10	19.70	2026-08-06 08:16:15.414611	2026-08-06 08:16:15.414611	1.00
168	31	7	39.00	15.10	2026-08-06 08:16:15.414611	2026-08-06 08:16:15.414611	0.80
169	31	7	126.70	64.90	2026-08-06 08:16:15.414611	2026-08-06 08:16:15.414611	1.50
170	31	1	591.70	124.30	2026-08-06 08:16:15.414611	2026-08-06 08:16:15.414611	5.00
171	31	8	79.00	44.50	2026-08-06 08:16:15.414611	2026-08-06 08:16:15.414611	1.50
172	32	9	205.60	128.20	2026-08-06 08:21:03.014939	2026-08-06 08:21:03.014939	1.30
173	32	11	133.20	124.60	2026-08-06 08:21:03.014939	2026-08-06 08:21:03.014939	1.00
174	32	2	53.50	35.60	2026-08-06 08:21:03.014939	2026-08-06 08:21:03.014939	5.50
175	32	10	38.40	8.50	2026-08-06 08:21:03.014939	2026-08-06 08:21:03.014939	3.50
176	32	5	182.30	106.20	2026-08-06 08:21:03.014939	2026-08-06 08:21:03.014939	1.70
177	32	7	11.90	9.00	2026-08-06 08:21:03.014939	2026-08-06 08:21:03.014939	0.80
178	32	7	41.50	22.80	2026-08-06 08:21:03.014939	2026-08-06 08:21:03.014939	1.50
179	32	11	117.80	47.40	2026-08-06 08:21:03.014939	2026-08-06 08:21:03.014939	1.00
180	32	6	209.00	78.20	2026-08-06 08:21:03.014939	2026-08-06 08:21:03.014939	3.50
181	32	1	364.00	142.90	2026-08-06 08:21:03.014939	2026-08-06 08:21:03.014939	5.00
182	32	4	48.90	27.30	2026-08-06 08:21:03.014939	2026-08-06 08:21:03.014939	1.00
183	32	8	44.50	29.30	2026-08-06 08:21:03.014939	2026-08-06 08:21:03.014939	1.50
184	33	1	615.20	189.80	2026-08-06 08:36:01.98796	2026-08-06 08:36:01.98796	5.00
185	33	9	201.30	74.50	2026-08-06 08:36:01.98796	2026-08-06 08:36:01.98796	1.30
186	33	6	200.70	13.20	2026-08-06 08:36:01.98796	2026-08-06 08:36:01.98796	3.50
187	33	2	139.50	91.30	2026-08-06 08:36:01.98796	2026-08-06 08:36:01.98796	5.50
188	33	7	39.80	27.00	2026-08-06 08:36:01.98796	2026-08-06 08:36:01.98796	0.80
189	33	5	154.50	97.20	2026-08-06 08:36:01.98796	2026-08-06 08:36:01.98796	1.70
190	33	7	20.00	2.60	2026-08-06 08:36:01.98796	2026-08-06 08:36:01.98796	1.50
191	33	11	338.10	171.30	2026-08-06 08:36:01.98796	2026-08-06 08:36:01.98796	1.00
192	33	4	151.20	126.40	2026-08-06 08:36:01.98796	2026-08-06 08:36:01.98796	1.00
193	33	8	114.00	59.50	2026-08-06 08:36:01.98796	2026-08-06 08:36:01.98796	1.50
194	33	10	72.20	2.80	2026-08-06 08:36:01.98796	2026-08-06 08:36:01.98796	3.50
195	33	6	13.40	4.00	2026-08-06 08:36:01.98796	2026-08-06 08:36:01.98796	2.00
197	34	9	93.50	87.00	2026-08-07 07:11:19.670071	2026-08-07 07:11:19.670071	1.30
198	34	4	33.00	22.00	2026-08-07 07:11:19.670071	2026-08-07 07:11:19.670071	1.00
199	34	2	46.50	39.00	2026-08-07 07:11:19.670071	2026-08-07 07:11:19.670071	5.50
200	34	6	52.90	36.90	2026-08-07 07:11:19.670071	2026-08-07 07:11:19.670071	3.00
201	34	11	57.00	55.50	2026-08-07 07:11:19.670071	2026-08-07 07:11:19.670071	1.00
202	34	8	29.00	23.50	2026-08-07 07:11:19.670071	2026-08-07 07:11:19.670071	1.50
203	34	7	19.50	14.50	2026-08-07 07:11:19.670071	2026-08-07 07:11:19.670071	2.00
204	34	5	39.00	38.50	2026-08-07 07:11:19.670071	2026-08-07 07:11:19.670071	0.70
205	34	5	59.00	58.50	2026-08-07 07:11:19.670071	2026-08-07 07:11:19.670071	1.70
206	34	1	232.00	95.00	2026-08-07 07:11:19.670071	2026-08-07 07:11:19.670071	3.00
207	34	10	41.30	21.60	2026-08-07 07:11:19.670071	2026-08-07 07:11:19.670071	3.50
208	35	9	71.50	55.40	2026-08-07 07:16:01.055343	2026-08-07 07:16:01.055343	1.30
209	35	4	34.50	31.50	2026-08-07 07:16:01.055343	2026-08-07 07:16:01.055343	1.00
210	35	2	60.50	51.50	2026-08-07 07:16:01.055343	2026-08-07 07:16:01.055343	5.50
211	35	6	45.20	31.00	2026-08-07 07:16:01.055343	2026-08-07 07:16:01.055343	3.00
212	35	11	66.50	56.00	2026-08-07 07:16:01.055343	2026-08-07 07:16:01.055343	1.00
213	35	8	26.50	23.00	2026-08-07 07:16:01.055343	2026-08-07 07:16:01.055343	1.50
214	35	5	31.50	29.60	2026-08-07 07:16:01.055343	2026-08-07 07:16:01.055343	0.70
215	35	5	44.50	44.00	2026-08-07 07:16:01.055343	2026-08-07 07:16:01.055343	1.70
216	35	7	24.00	16.00	2026-08-07 07:16:01.055343	2026-08-07 07:16:01.055343	2.00
217	35	1	220.50	168.00	2026-08-07 07:16:01.055343	2026-08-07 07:16:01.055343	3.00
218	35	10	44.00	20.00	2026-08-07 07:16:01.055343	2026-08-07 07:16:01.055343	3.50
\.


--
-- Data for Name: shipments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipments (id, "clientId", date, notes, "createdAt", "updatedAt") FROM stdin;
7	4	2026-08-05	\N	2026-08-05 14:07:18.992751	2026-08-05 14:07:18.992751
8	3	2026-08-05	\N	2026-08-05 14:56:30.657008	2026-08-05 14:56:30.657008
9	5	2026-08-03	\N	2026-08-05 15:03:02.003389	2026-08-05 15:03:02.003389
10	5	2026-01-13	\N	2026-08-05 15:08:47.413094	2026-08-05 15:08:47.413094
11	5	2026-01-21	\N	2026-08-05 15:10:42.666255	2026-08-05 15:10:42.666255
12	5	2026-01-22	\N	2026-08-05 15:12:37.776356	2026-08-05 15:12:37.776356
13	5	2026-01-24	\N	2026-08-05 15:14:14.999986	2026-08-05 15:14:14.999986
14	5	2026-02-06	\N	2026-08-05 15:15:19.658199	2026-08-05 15:15:19.658199
15	5	2026-02-24	\N	2026-08-05 15:17:48.993403	2026-08-05 15:17:48.993403
16	5	2026-02-25	\N	2026-08-05 15:18:37.460726	2026-08-05 15:18:37.460726
17	5	2026-07-06	\N	2026-08-05 15:19:39.550675	2026-08-05 15:19:39.550675
19	5	2026-06-03	\N	2026-08-06 06:42:01.109142	2026-08-06 06:42:01.109142
20	5	2026-06-02	\N	2026-08-06 06:42:48.125855	2026-08-06 06:42:48.125855
21	5	2026-07-10	\N	2026-08-06 06:44:22.026219	2026-08-06 06:44:22.026219
22	5	2026-07-11	\N	2026-08-06 06:45:17.904976	2026-08-06 06:45:17.904976
23	5	2026-05-01	\N	2026-08-06 06:47:36.632783	2026-08-06 06:47:36.632783
24	3	2026-08-04	\N	2026-08-06 06:51:12.124356	2026-08-06 06:51:12.124356
25	4	2026-08-04	\N	2026-08-06 06:55:39.7548	2026-08-06 06:55:39.7548
26	6	2026-08-03	\N	2026-08-06 06:57:32.572122	2026-08-06 06:57:32.572122
27	3	2026-08-02	\N	2026-08-06 07:08:57.285656	2026-08-06 07:08:57.285656
28	4	2026-08-02	\N	2026-08-06 07:14:20.549206	2026-08-06 07:14:20.549206
29	3	2026-08-01	\N	2026-08-06 07:21:49.286426	2026-08-06 07:21:49.286426
30	4	2026-08-01	\N	2026-08-06 07:28:54.549098	2026-08-06 07:28:54.549098
31	7	2026-07-28	\N	2026-08-06 08:16:15.396917	2026-08-06 08:16:15.396917
32	8	2026-07-28	\N	2026-08-06 08:21:03.003833	2026-08-06 08:21:03.003833
33	9	2026-07-29	\N	2026-08-06 08:36:01.970237	2026-08-06 08:36:01.970237
34	4	2026-08-06	\N	2026-08-07 07:06:03.549404	2026-08-07 07:06:03.549404
35	3	2026-08-06	\N	2026-08-07 07:16:01.030726	2026-08-07 07:16:01.030726
\.


--
-- Data for Name: treatment_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.treatment_products (id, "productId", "ratePerHa", unit, "treatmentId") FROM stdin;
175	416	0.40	л/га	77
176	430	0.10	л/га	77
104	422	1.50	л/га	51
105	421	0.50	л/га	51
106	416	2.50	л/га	44
107	418	1.50	л/га	44
108	417	2.00	л/га	43
109	420	2.00	л/га	45
177	422	3.50	л/га	78
178	385	1.00	л/га	79
179	402	0.40	л/га	79
180	407	1.50	л/га	79
117	421	0.50	л/га	50
118	424	1.70	л/га	50
119	425	1.20	л/га	52
120	427	0.80	л/га	52
121	428	1.20	л/га	53
181	402	0.40	л/га	80
182	403	0.20	л/га	80
183	402	0.40	л/га	81
184	403	0.20	л/га	81
185	362	0.20	л/га	82
186	438	5.00	л/га	83
128	399	10.00	кг/га	54
129	399	10.00	кг/га	55
130	399	10.00	кг/га	56
131	422	3.00	л/га	42
187	422	3.30	л/га	84
188	416	0.40	л/га	85
189	430	0.15	л/га	85
191	452	5.00	л/га	87
193	422	3.30	л/га	89
194	445	2.00	л/га	90
195	385	1.00	л/га	91
196	402	0.40	л/га	91
197	405	0.50	л/га	91
198	369	0.50	л/га	92
199	389	0.30	л/га	92
200	381	1.50	кг/га	92
201	397	0.50	л/га	92
203	405	0.50	л/га	94
204	430	0.15	л/га	95
205	440	0.05	л/га	95
208	405	0.66	л/га	97
209	431	1.00	л/га	97
155	402	0.40	л/га	46
156	381	2.00	кг/га	41
157	365	0.75	л/га	41
210	366	0.15	л/га	97
211	397	0.10	л/га	97
212	450	3.00	л/га	98
161	380	1.50	кг/га	47
162	402	0.40	л/га	47
163	403	0.20	л/га	47
164	365	0.30	л/га	49
217	453	0.75	кг/га	100
167	425	0.50	л/га	59
168	429	0.35	л/га	59
169	402	0.15	л/га	58
170	402	0.15	л/га	57
222	376	0.20	л/га	102
223	362	0.20	л/га	102
173	416	0.40	л/га	60
174	430	0.10	л/га	60
224	405	0.50	л/га	102
225	397	0.50	л/га	102
226	405	0.50	л/га	103
227	452	3.00	л/га	104
228	405	0.50	л/га	105
231	364	0.30	л/га	107
232	375	0.80	кг/га	107
233	397	0.50	л/га	107
234	405	0.50	л/га	107
235	417	2.00	л/га	108
236	447	0.50	л/га	108
237	357	0.66	л/га	109
238	368	0.50	л/га	109
239	440	0.10	л/га	110
240	430	0.15	л/га	110
241	402	0.15	л/га	111
242	362	0.20	л/га	111
244	418	1.50	л/га	113
245	416	2.00	л/га	113
254	417	1.00	л/га	117
255	447	0.10	л/га	117
256	453	0.15	л/га	117
257	432	1.00	л/га	118
258	357	0.50	л/га	118
259	425	1.50	л/га	119
260	442	2.00	л/га	119
261	440	0.15	л/га	120
262	430	0.15	л/га	120
263	375	0.80	кг/га	121
264	364	0.30	л/га	121
265	405	0.50	л/га	121
266	453	0.70	кг/га	122
267	387	0.02	кг/га	122
268	448	0.60	л/га	122
269	456	0.03	кг/га	123
270	425	1.00	л/га	123
271	427	0.80	л/га	123
272	440	0.20	л/га	124
273	430	0.15	л/га	124
282	425	1.00	л/га	126
283	427	0.80	л/га	126
284	439	0.60	л/га	126
285	456	0.03	кг/га	126
286	385	1.20	л/га	127
287	403	0.20	л/га	127
288	364	0.40	л/га	127
294	367	0.03	л/га	130
295	457	2.50	кг/га	130
296	458	0.30	л/га	130
297	459	0.50	л/га	131
298	421	0.50	л/га	131
299	402	0.30	л/га	132
300	448	0.50	л/га	132
301	413	0.30	кг/га	133
302	458	0.30	л/га	133
309	439	0.80	л/га	136
310	429	1.20	л/га	136
316	457	2.00	кг/га	139
317	405	0.50	л/га	139
318	458	0.30	л/га	139
319	419	2.00	л/га	140
322	445	2.00	л/га	142
329	387	0.02	кг/га	144
330	453	0.30	кг/га	144
331	458	0.30	л/га	144
332	445	2.00	л/га	145
333	438	5.00	л/га	146
337	437	0.35	л/га	148
338	385	1.20	л/га	148
339	404	0.20	л/га	148
340	384	2.50	кг/га	149
341	405	0.50	л/га	149
342	458	0.25	л/га	149
344	398	1.50	л/га	151
345	452	5.00	л/га	152
346	411	3.00	кг/га	153
347	369	1.00	л/га	154
348	376	0.40	л/га	154
349	405	0.50	л/га	154
350	458	0.25	л/га	154
351	411	3.00	кг/га	155
356	398	1.50	л/га	158
357	376	0.40	л/га	159
358	369	1.00	л/га	159
359	458	0.25	л/га	159
\.


--
-- Data for Name: treatments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.treatments (id, culture, area, completed, "dueDate", "actualDate", "isTankMix", "hasCompatibilityIssues", "compatibilityWarnings", notes, "createdAt") FROM stdin;
41	груша	2.00	t	2026-04-19	2026-04-19	t	f	\N	Летние сорта, южный сад	2026-05-16 07:20:20.542355
42	другое	1.50	t	2026-04-15	2026-04-15	f	f	\N	Подготовка почвы пот посадку Капусты	2026-05-16 07:20:20.551186
43	морковь	1.50	t	2026-04-27	2026-04-27	f	f	\N	\N	2026-05-16 07:20:20.555292
44	свекла	1.50	t	2026-04-27	2026-04-27	t	f	\N	\N	2026-05-16 07:20:20.559816
45	другое	0.15	t	2026-04-29	2026-04-28	f	f	\N	Редиска	2026-05-16 07:20:20.56373
46	груша	3.00	t	2026-04-14	2026-04-14	f	f	\N	Беларусская поздняя	2026-05-16 07:20:20.56715
49	другое	0.15	t	2026-05-07	2026-05-07	f	f	\N	Редиска	2026-05-16 07:20:20.577504
52	свекла	1.50	t	2026-05-10	2026-05-10	t	f	\N	\N	2026-05-16 07:20:20.585876
53	морковь	1.50	t	2026-05-10	2026-05-09	f	f	\N	\N	2026-05-16 07:20:20.58848
55	черешня	5.00	t	2026-03-27	2026-03-27	f	f	\N	\N	2026-05-16 07:20:20.594721
56	слива	0.40	t	2026-03-28	2026-03-28	f	f	\N	\N	2026-05-16 07:20:20.598106
57	свекла	1.50	t	2026-05-12	2026-05-12	f	f	\N	\N	2026-05-16 07:20:20.601495
58	капуста	1.50	t	2026-05-12	2026-05-12	f	f	\N	\N	2026-05-16 07:20:20.604639
59	морковь	1.50	t	2026-05-12	2026-05-12	t	f	\N	\N	2026-05-16 07:20:20.60784
102	яблоко	12.00	t	2026-06-05	2026-06-14	t	f	Слишком много разных типов препаратов в смеси - возможна нестабильность	\N	2026-06-04 06:33:18.643258
90	лук	4.00	t	2026-05-26	2026-05-25	f	f	\N	\N	2026-05-26 09:13:09.234911
91	яблоко	4.00	t	2026-05-28	2026-05-27	t	f		\N	2026-05-27 06:34:00.242089
92	груша	16.00	t	2026-05-30	2026-05-31	t	f		\N	2026-05-27 08:21:36.171319
122	томаты	4.30	t	2026-06-25	2026-06-24	t	f		\N	2026-06-24 14:39:37.911378
54	груша	22.50	t	2026-03-22	2026-03-22	f	f	\N	\N	2026-05-16 07:20:20.591416
94	груша	12.00	t	2026-06-01	2026-05-31	f	f	\N	\N	2026-05-31 11:23:55.858656
95	лук	4.00	t	2026-06-03	2026-06-02	t	f		\N	2026-06-02 09:50:26.682609
47	груша	16.00	t	2026-05-02	2026-05-05	t	f	\N	Розовый бутон	2026-05-16 07:20:20.570458
51	лук	4.00	t	2026-04-27	2026-04-26	t	f	\N	\N	2026-05-16 07:20:20.583231
50	лук	4.00	t	2026-05-10	2026-05-09	t	f	\N	\N	2026-05-16 07:20:20.580641
60	лук	4.00	t	2026-05-13	2026-05-13	t	f	\N	\N	2026-05-16 07:20:20.611039
77	лук	4.00	t	2026-05-16	2026-05-16	t	f		\N	2026-05-16 14:14:44.050783
78	другое	2.00	t	2026-05-17	2026-05-17	f	f	\N	Потготовка почвы под томат	2026-05-17 09:14:07.169847
82	капуста	1.50	t	2026-05-21	2026-05-20	f	f	\N	\N	2026-05-20 05:01:30.623327
83	другое	2.00	t	2026-05-22	2026-05-21	f	f	\N	Подготовка почвы	2026-05-21 07:02:09.909801
84	другое	1.50	t	2026-05-22	2026-05-21	f	f	\N	\N	2026-05-21 09:10:34.744335
97	капуста	1.50	t	2026-06-03	2026-06-02	t	f		\N	2026-06-02 10:50:21.343252
85	лук	4.00	t	2026-05-21	2026-05-22	f	f	\N	\N	2026-05-21 12:59:36.671435
87	другое	4.00	t	2026-05-22	2026-05-22	f	f	\N	Подготовка почвы	2026-05-22 13:28:28.329041
80	слива	0.40	t	2026-05-20	2026-05-22	t	f		\N	2026-05-19 09:11:53.950051
81	черешня	3.50	t	2026-05-20	2026-05-22	t	f		\N	2026-05-19 09:16:03.125404
89	другое	2.00	t	2026-05-24	2026-05-23	f	f	\N	Подготовка почвы	2026-05-23 11:21:56.074223
79	яблоко	10.00	t	2026-05-18	2026-05-24	t	f		\N	2026-05-17 09:25:26.028316
98	свекла	1.50	t	2026-06-04	2026-06-03	f	f	\N	\N	2026-06-03 06:39:30.031793
100	картофель	6.66	t	2026-06-04	2026-06-03	f	f	\N	\N	2026-06-03 14:02:59.521432
104	другое	2.00	t	2026-06-06	2026-06-05	f	f	\N	Подготовка почвы под свеклу	2026-06-05 09:28:05.440613
103	лук	4.00	t	2026-06-06	2026-06-05	f	f	\N	\N	2026-06-05 06:29:22.419933
105	капуста	1.00	t	2026-06-06	2026-06-05	f	f	\N	\N	2026-06-05 13:48:21.528748
109	капуста	1.50	t	2026-06-10	2026-06-09	t	f		\N	2026-06-09 12:56:03.364984
108	морковь	1.00	t	2026-06-07	2026-06-07	t	f		\N	2026-06-06 13:53:43.86397
123	свекла	1.50	t	2026-06-27	2026-06-26	t	f		Поле в деревне	2026-06-26 08:18:05.65592
110	лук	4.00	t	2026-06-12	2026-06-11	t	f		\N	2026-06-11 11:00:23.111802
111	капуста	1.50	t	2026-06-13	2026-06-11	t	f		\N	2026-06-12 08:17:51.700824
124	лук	4.00	t	2026-06-28	2026-06-28	t	f		\N	2026-06-27 11:46:57.908175
117	морковь	1.50	t	2026-06-20	2026-06-18	t	f		\N	2026-06-19 13:17:54.533899
113	свекла	1.50	t	2026-06-19	2026-06-18	t	f		Поле в Деревне	2026-06-18 08:02:13.733904
107	груша	16.00	t	2026-06-07	2026-06-20	t	f	Слишком много разных типов препаратов в смеси - возможна нестабильность	\N	2026-06-06 13:50:08.092213
118	груша	2.00	t	2026-06-21	2026-06-20	t	f		По медянице в южном саду	2026-06-20 09:45:47.627443
119	свекла	1.50	t	2026-06-21	2026-06-20	t	f		\N	2026-06-20 09:51:04.520468
120	лук	4.00	t	2026-06-21	2026-06-20	t	f		\N	2026-06-20 11:01:39.699351
121	слива	0.40	t	2026-06-24	2026-06-23	t	f		\N	2026-06-23 14:58:11.625132
131	лук	4.00	t	2026-07-03	2026-07-01	t	f		\N	2026-07-02 08:24:31.117633
130	томаты	4.30	t	2026-07-03	2026-06-30	t	f		\N	2026-07-02 08:22:13.652028
132	капуста	1.50	t	2026-07-03	2026-06-26	t	f		\N	2026-07-02 08:38:01.13439
142	свекла	1.50	t	2026-07-10	2026-07-09	f	f	\N	\N	2026-07-09 08:00:19.310454
144	томаты	4.50	t	2026-07-11	2026-07-10	t	f		\N	2026-07-10 11:03:15.449609
139	лук	4.00	t	2026-07-05	2026-07-04	t	f		\N	2026-07-04 09:55:05.09284
136	морковь	1.00	t	2026-07-03	2026-07-02	t	f		сев-зап. поле	2026-07-02 11:12:46.382886
126	свекла	1.50	t	2026-07-03	2026-07-08	t	f		поле в деревне  (Смыло дождем)	2026-07-02 07:46:30.986832
133	капуста	1.00	t	2026-07-03	2026-07-04	t	f		Поздняя	2026-07-02 09:03:17.695259
140	капуста	1.00	t	2026-07-06	2026-07-08	f	f	\N	поздняя	2026-07-05 07:20:18.626974
145	морковь	1.00	t	2026-07-13	2026-07-12	f	f	\N	болото	2026-07-12 08:10:39.923855
127	яблоко	12.00	t	2026-07-03	2026-07-12	t	f		\N	2026-07-02 08:01:35.680247
146	другое	2.00	t	2026-07-13	2026-07-12	f	f	\N	Восточное поле	2026-07-12 09:08:44.390612
149	лук	4.00	t	2026-07-26	2026-07-25	t	f		\N	2026-07-25 11:29:17.832267
148	груша	16.00	t	2026-07-26	2026-07-20	t	f		\N	2026-07-25 11:27:38.173512
153	лук	4.00	t	2026-08-01	2026-07-31	f	f	\N	\N	2026-07-31 09:04:36.545883
152	другое	4.00	t	2026-07-31	2026-07-30	f	f	\N	Подготовка поля под ЛУК	2026-07-30 13:32:24.603807
151	свекла	1.50	t	2026-07-27	2026-07-26	f	f	\N	\N	2026-07-26 09:38:25.413321
154	лук	4.00	f	2026-08-03	\N	t	f		\N	2026-08-02 08:38:44.382464
155	яблоко	12.00	f	2026-08-03	\N	f	f	\N	\N	2026-08-02 08:40:31.310799
158	свекла	1.50	f	2026-08-05	\N	f	f	\N	\N	2026-08-04 09:46:19.551093
159	свекла	1.50	t	2026-08-05	2026-08-05	t	f		\N	2026-08-05 06:37:04.179517
\.


--
-- Data for Name: vehicles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicles (id, name, type, model, year, vin, "insuranceDate", "roadLegalUntil", notes, "createdAt", "updatedAt") FROM stdin;
1	ГАЗ КУПАВА [AA 6343-3]	грузовой автомобиль	ГАЗ 3309 370031 "КУПАВА"	2006	Y3H47380060039306	2026-12-10	2025-08-23	\N	2026-05-16 04:58:20.724115	2026-05-16 04:58:20.724115
2	МАЗ КУПАВА [AB 1265-3]	грузовой автомобиль	МАЗ 437041 281 КУПАВА 478800	\N	Y3M43704170005527	2026-10-19	2025-12-06	\N	2026-05-16 04:58:20.730412	2026-05-16 04:58:20.730412
3	ГАЗ 3309 [EC 9281]	грузовой автомобиль	ГАЗ 3309	2004	XTH33090040864227	2026-09-23	2024-10-09	\N	2026-05-16 04:58:20.735516	2026-05-16 04:58:20.735516
4	ГАЗ Самосвал [AK 6436-3]	грузовой автомобиль	ГАЗ САЗ 35071	2005	X3E35071050001767	2026-09-23	2024-08-02	\N	2026-05-16 04:58:20.740212	2026-05-16 04:58:20.740212
5	ГАЗ 377030 [AA 2656-3]	грузовой автомобиль	ГАЗ 377030	2005	X9437703050005023	2026-12-27	2025-03-10	\N	2026-05-16 04:58:20.745016	2026-05-16 04:58:20.745016
6	ГАЗ 377030 [AA 2655-3]	грузовой автомобиль	ГАЗ 377030	2005	33090050888278	2026-12-27	2025-04-25	\N	2026-05-16 04:58:20.750087	2026-05-16 04:58:20.750087
7	МТЗ 82.1 [EA 5618]	трактор	Беларус 82.1	2003	08086165	2026-10-10	2024-04-01	\N	2026-05-16 04:58:20.754694	2026-05-16 04:58:20.754694
8	МТЗ 82.1 [ГТ 0495]	трактор	Беларус 82.1	2008	80883383	2025-08-28	2024-04-01	\N	2026-05-16 04:58:20.759339	2026-05-16 04:58:20.759339
9	МТЗ 1221 [EA 4873]	трактор	Беларус 1221B	2005	12015540	2024-10-10	2024-04-01	\N	2026-05-16 04:58:20.764334	2026-05-16 04:58:20.764334
10	Амкадор [EB-3 8139]	другая техника	Амкадор 332С4	2011	110789	2026-03-05	2026-08-01	\N	2026-05-16 04:58:20.769027	2026-05-16 04:58:20.769027
11	МТЗ 80 [ГТ 9211]	трактор	Беларус 80	1990	715251	\N	2008-01-01	\N	2026-05-16 04:58:20.773114	2026-05-16 04:58:20.773114
12	МТЗ 80 [ГТ 9230]	трактор	Беларус 80	1993	899915	\N	2008-01-01	\N	2026-05-16 04:58:20.777294	2026-05-16 04:58:20.777294
13	МТЗ 82 [EA 4076]	трактор	Беларус 82.1	2002	08060246	2026-01-20	2024-01-04	\N	2026-05-16 04:58:20.781236	2026-05-16 04:58:20.781236
15	ПСЕ-Ф [EK-3 1510]	прицеп	ПСЕ-Ф 12.56	1996	075911	2026-03-05	2025-04-01	\N	2026-05-19 09:46:07.880496	2026-05-19 09:46:07.880496
14	ПСТ-6 [EA-3 7017]	прицеп	ПСТ-6	2006	22	\N	2019-08-21	\N	2026-05-19 09:43:47.82045	2026-05-19 09:46:44.661071
16	ПСТ-9 [EA 1205]	прицеп	ПСТ-9	2006	124	2026-10-26	2025-04-01	\N	2026-05-19 09:49:22.566993	2026-05-19 09:49:22.566993
17	ПСЕ-Ф [EK-3 2945]	прицеп	ПСЕ-Ф-12.55	1992	056297	2025-11-23	2025-04-01	\N	2026-05-19 09:51:11.726616	2026-05-19 09:51:11.726616
18	2ПСТ-5 [EA 6366]	прицеп	2ПСТ-5	2006	174	\N	2019-08-21	\N	2026-05-19 09:53:01.584017	2026-05-19 09:53:01.584017
19	ПСЕ-Ф [5687 EA]	прицеп	ПСЕ-Ф-12.5 Б	1995	074133	\N	2018-06-12	\N	2026-05-19 09:54:37.965672	2026-05-19 09:54:37.965672
20	Опрыскиватель навесной Jacto	сельхозорудие	Jacto Falcon Vortex	\N	\N	\N	\N	\N	2026-05-19 09:57:59.064108	2026-05-19 09:59:03.873039
21	Опрыскиватель садовый Jacto	сельхозорудие	Jacto	\N	\N	\N	\N	\N	2026-05-19 09:59:57.544302	2026-05-19 09:59:57.544302
\.


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clients_id_seq', 9, true);


--
-- Name: equipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_id_seq', 25, true);


--
-- Name: inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_id_seq', 460, true);


--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_transactions_id_seq', 419, true);


--
-- Name: maintenance_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.maintenance_records_id_seq', 5, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 12, true);


--
-- Name: shipment_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shipment_items_id_seq', 218, true);


--
-- Name: shipments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shipments_id_seq', 35, true);


--
-- Name: treatment_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.treatment_products_id_seq', 359, true);


--
-- Name: treatments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.treatments_id_seq', 159, true);


--
-- Name: vehicles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vehicles_id_seq', 21, true);


--
-- Name: equipment PK_0722e1b9d6eb19f5874c1678740; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT "PK_0722e1b9d6eb19f5874c1678740" PRIMARY KEY (id);


--
-- Name: products PK_0806c755e0aca124e67c0cf6d7d; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "PK_0806c755e0aca124e67c0cf6d7d" PRIMARY KEY (id);


--
-- Name: treatments PK_133f26d52c70b9fa3c2dbb3c89e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.treatments
    ADD CONSTRAINT "PK_133f26d52c70b9fa3c2dbb3c89e" PRIMARY KEY (id);


--
-- Name: vehicles PK_18d8646b59304dce4af3a9e35b6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT "PK_18d8646b59304dce4af3a9e35b6" PRIMARY KEY (id);


--
-- Name: maintenance_records PK_287b838a22e8c8804262ccdb6a1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_records
    ADD CONSTRAINT "PK_287b838a22e8c8804262ccdb6a1" PRIMARY KEY (id);


--
-- Name: shipments PK_6deda4532ac542a93eab214b564; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT "PK_6deda4532ac542a93eab214b564" PRIMARY KEY (id);


--
-- Name: shipment_items PK_7dfc873be1417190f0e5e001dd3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipment_items
    ADD CONSTRAINT "PK_7dfc873be1417190f0e5e001dd3" PRIMARY KEY (id);


--
-- Name: inventory PK_82aa5da437c5bbfb80703b08309; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT "PK_82aa5da437c5bbfb80703b08309" PRIMARY KEY (id);


--
-- Name: inventory_transactions PK_9b7144851f08f9eededde7edd42; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT "PK_9b7144851f08f9eededde7edd42" PRIMARY KEY (id);


--
-- Name: treatment_products PK_dc1a4a361890da5792c3db95250; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.treatment_products
    ADD CONSTRAINT "PK_dc1a4a361890da5792c3db95250" PRIMARY KEY (id);


--
-- Name: clients PK_f1ab7cf3a5714dbc6bb4e1c28a4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT "PK_f1ab7cf3a5714dbc6bb4e1c28a4" PRIMARY KEY (id);


--
-- Name: maintenance_records FK_1190e448dca1a6a2982600f0bb9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_records
    ADD CONSTRAINT "FK_1190e448dca1a6a2982600f0bb9" FOREIGN KEY ("vehicleId") REFERENCES public.vehicles(id) ON DELETE CASCADE;


--
-- Name: treatment_products FK_11dc10dbd67685bd5c2fc09994a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.treatment_products
    ADD CONSTRAINT "FK_11dc10dbd67685bd5c2fc09994a" FOREIGN KEY ("treatmentId") REFERENCES public.treatments(id) ON DELETE CASCADE;


--
-- Name: shipment_items FK_4adc7d31b2e34803fb8b0d7ec7f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipment_items
    ADD CONSTRAINT "FK_4adc7d31b2e34803fb8b0d7ec7f" FOREIGN KEY ("productId") REFERENCES public.products(id);


--
-- Name: treatment_products FK_78b61248c8eecc09107d82c2264; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.treatment_products
    ADD CONSTRAINT "FK_78b61248c8eecc09107d82c2264" FOREIGN KEY ("productId") REFERENCES public.inventory(id);


--
-- Name: shipments FK_ac32e989bba954a3ab561f2467e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT "FK_ac32e989bba954a3ab561f2467e" FOREIGN KEY ("clientId") REFERENCES public.clients(id);


--
-- Name: shipment_items FK_eeef177e88218449410bbb3af44; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipment_items
    ADD CONSTRAINT "FK_eeef177e88218449410bbb3af44" FOREIGN KEY ("shipmentId") REFERENCES public.shipments(id) ON DELETE CASCADE;


--
-- Name: inventory_transactions FK_f21250669a9728997c6d8f6f5da; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT "FK_f21250669a9728997c6d8f6f5da" FOREIGN KEY ("productId") REFERENCES public.inventory(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict yYs7sIWrNUieqGZCIv7U78KabDF1KTRxetmKptHTz6wPiCtECtdU6xWBXZyknmR

