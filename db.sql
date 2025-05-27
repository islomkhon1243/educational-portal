--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

-- Started on 2025-02-10 16:36:54

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
-- TOC entry 2 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 4892 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 49228)
-- Name: admins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admins (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.admins OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 49227)
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admins_id_seq OWNER TO postgres;

--
-- TOC entry 4893 (class 0 OID 0)
-- Dependencies: 234
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- TOC entry 219 (class 1259 OID 24597)
-- Name: applicants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicants (
    id integer NOT NULL,
    name character varying(100),
    email character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    password character varying(100)
);


ALTER TABLE public.applicants OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24596)
-- Name: applicants_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.applicants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.applicants_id_seq OWNER TO postgres;

--
-- TOC entry 4894 (class 0 OID 0)
-- Dependencies: 218
-- Name: applicants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.applicants_id_seq OWNED BY public.applicants.id;


--
-- TOC entry 227 (class 1259 OID 32798)
-- Name: applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applications (
    id integer NOT NULL,
    university_id integer,
    name character varying(255),
    email character varying(255),
    personal_statement text,
    file_path character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    user_id integer,
    status character varying(255)
);


ALTER TABLE public.applications OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 32797)
-- Name: applications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.applications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.applications_id_seq OWNER TO postgres;

--
-- TOC entry 4895 (class 0 OID 0)
-- Dependencies: 226
-- Name: applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.applications_id_seq OWNED BY public.applications.id;


--
-- TOC entry 231 (class 1259 OID 40994)
-- Name: articles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.articles (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    category character varying(100) NOT NULL,
    description text NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.articles OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 40993)
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.articles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.articles_id_seq OWNER TO postgres;

--
-- TOC entry 4896 (class 0 OID 0)
-- Dependencies: 230
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.articles_id_seq OWNED BY public.articles.id;


--
-- TOC entry 223 (class 1259 OID 24615)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24614)
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO postgres;

--
-- TOC entry 4897 (class 0 OID 0)
-- Dependencies: 222
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- TOC entry 229 (class 1259 OID 40981)
-- Name: email_verifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_verifications (
    id integer NOT NULL,
    email text NOT NULL,
    code text NOT NULL,
    expires_at timestamp without time zone NOT NULL
);


ALTER TABLE public.email_verifications OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 40980)
-- Name: email_verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_verifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.email_verifications_id_seq OWNER TO postgres;

--
-- TOC entry 4898 (class 0 OID 0)
-- Dependencies: 228
-- Name: email_verifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_verifications_id_seq OWNED BY public.email_verifications.id;


--
-- TOC entry 221 (class 1259 OID 24605)
-- Name: resources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resources (
    id integer NOT NULL,
    title character varying(255),
    description text,
    url character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    category_id integer
);


ALTER TABLE public.resources OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24604)
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resources_id_seq OWNER TO postgres;

--
-- TOC entry 4899 (class 0 OID 0)
-- Dependencies: 220
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resources_id_seq OWNED BY public.resources.id;


--
-- TOC entry 217 (class 1259 OID 24591)
-- Name: table1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.table1 (
    id integer NOT NULL,
    name character varying,
    description character varying
);


ALTER TABLE public.table1 OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24590)
-- Name: table1_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.table1 ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.table1_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 32789)
-- Name: universities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.universities (
    id integer NOT NULL,
    name character varying(255),
    description text,
    location character varying(255),
    established character varying(255),
    image_url character varying(255),
    admission_start date,
    admission_end date,
    faculties character varying,
    conditions character varying,
    additional character varying
);


ALTER TABLE public.universities OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 32788)
-- Name: universities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.universities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.universities_id_seq OWNER TO postgres;

--
-- TOC entry 4900 (class 0 OID 0)
-- Dependencies: 224
-- Name: universities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.universities_id_seq OWNED BY public.universities.id;


--
-- TOC entry 233 (class 1259 OID 49183)
-- Name: user_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_documents (
    id integer NOT NULL,
    user_id integer NOT NULL,
    file_name character varying(255) NOT NULL,
    file_path character varying(255) NOT NULL,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_documents OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 49182)
-- Name: user_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_documents_id_seq OWNER TO postgres;

--
-- TOC entry 4901 (class 0 OID 0)
-- Dependencies: 232
-- Name: user_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_documents_id_seq OWNED BY public.user_documents.id;


--
-- TOC entry 4693 (class 2604 OID 49231)
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- TOC entry 4680 (class 2604 OID 24600)
-- Name: applicants id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicants ALTER COLUMN id SET DEFAULT nextval('public.applicants_id_seq'::regclass);


--
-- TOC entry 4686 (class 2604 OID 32801)
-- Name: applications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications ALTER COLUMN id SET DEFAULT nextval('public.applications_id_seq'::regclass);


--
-- TOC entry 4689 (class 2604 OID 40997)
-- Name: articles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);


--
-- TOC entry 4684 (class 2604 OID 24618)
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- TOC entry 4688 (class 2604 OID 40984)
-- Name: email_verifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_verifications ALTER COLUMN id SET DEFAULT nextval('public.email_verifications_id_seq'::regclass);


--
-- TOC entry 4682 (class 2604 OID 24608)
-- Name: resources id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources ALTER COLUMN id SET DEFAULT nextval('public.resources_id_seq'::regclass);


--
-- TOC entry 4685 (class 2604 OID 32792)
-- Name: universities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.universities ALTER COLUMN id SET DEFAULT nextval('public.universities_id_seq'::regclass);


--
-- TOC entry 4691 (class 2604 OID 49186)
-- Name: user_documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_documents ALTER COLUMN id SET DEFAULT nextval('public.user_documents_id_seq'::regclass);


--
-- TOC entry 4886 (class 0 OID 49228)
-- Dependencies: 235
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admins (id, email, password_hash, created_at) FROM stdin;
1	admin@gmail.com	$2a$10$JJ0OzulKNEMU6RO4J2BmBeEhrwaJb9wgPLSceXzuy/jlTpC9IOK3e	2025-02-06 12:48:24.054995
\.


--
-- TOC entry 4870 (class 0 OID 24597)
-- Dependencies: 219
-- Data for Name: applicants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applicants (id, name, email, created_at, password) FROM stdin;
13	Saidikarimov Islomkhon Oktamkhanovich	islomkhon1243@gmail.com	2025-01-31 12:06:26.991406	$2a$10$jB3.IXIYi/R7me3SL7ihpu76.bG2JxZaHabG6X6.TdX2kuRz85yiS
14	Бахрам Киргизбаев	baha_5434@mail.ru	2025-01-31 12:10:02.991279	$2a$10$Ahj9ecFaOQwfZEfdDohfHuJsQ20nyq6Marod1aZ9NPp.H.FYC.xfG
15	Ринат Хасанов	aries_2603@mail.ru	2025-01-31 12:11:42.160168	$2a$10$dSp6.TfD5XRA39NjONlxSOrxiLGG197tArNnAhE9dTTmEW7FMSwQS
\.


--
-- TOC entry 4878 (class 0 OID 32798)
-- Dependencies: 227
-- Data for Name: applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applications (id, university_id, name, email, personal_statement, file_path, created_at, user_id, status) FROM stdin;
35	5	Saidikarimov Islomkhon Oktamkhanovich	islomkhon1243@gmail.com	sdfsdf	uploads\\1738559623841.pdf	2025-02-03 13:05:05.18371	13	declined
36	1	Saidikarimov Islomkhon Oktamkhanovich	islomkhon1243@gmail.com	asdasd	uploads\\1738559623841.pdf	2025-02-10 17:11:31.331142	13	in process
37	2	Saidikarimov Islomkhon Oktamkhanovich	islomkhon1243@gmail.com	asdasdasd	uploads\\1738559623841.pdf	2025-02-10 17:12:19.39526	13	accepted
\.


--
-- TOC entry 4882 (class 0 OID 40994)
-- Dependencies: 231
-- Data for Name: articles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.articles (id, title, category, description, content, created_at) FROM stdin;
492	Статья про ТОП-10 востребованных специальностей в 2025 году	AI Generated	## ТОП-10 востребованных специальностей 2025 года: Будущее уже здесь\n\nРынок труда постоянно меняется...	## ТОП-10 востребованных специальностей 2025 года: Будущее уже здесь\n\nРынок труда постоянно меняется, и предвидеть будущее – задача непростая. Однако, анализируя текущие тренды и прогнозы экспертов, можно с уверенностью выделить ряд профессий, которые будут невероятно востребованы уже в 2025 году.  Забудьте о стабильности – будущее принадлежит тем, кто готов адаптироваться и постоянно обучаться.\n\nЭтот список составлен с учетом технологического прогресса, растущих потребностей общества и глобальных изменений.  Важно помнить, что это лишь прогноз, и конкретный спрос может варьироваться в зависимости от региона и отрасли.\n\n**ТОП-10 востребованных специальностей 2025 года:**\n\n1. **Специалисты по искусственному интеллекту (ИИ) и машинному обучению:**  Разработчики, инженеры, аналитики данных – все, кто умеет работать с ИИ, будут нарасхват.  От создания умных алгоритмов до обеспечения безопасности ИИ-систем –  сфера применения безгранична.\n\n2. **Специалисты по кибербезопасности:**  С ростом цифровизации возрастает и количество киберугроз.  Эксперты по защите данных,  специалисты по предотвращению кибератак и реагированию на инциденты будут крайне востребованы.\n\n3. **Разработчики программного обеспечения:**  Несмотря на развитие ИИ,  программисты остаются незаменимыми.  Специалисты, владеющие различными языками программирования и способные создавать качественное и эффективное ПО, будут высоко ценятся.\n\n4. **Data Scientists (Ученые данных):**  Анализ больших объемов данных – ключ к принятию эффективных решений в любой сфере.  Специалисты, способные извлекать полезную информацию из массивов данных и делать на ее основе прогнозы, будут в приоритете.\n\n5. **Специалисты по облачным технологиям (Cloud Computing):**  Переход компаний в облако – неизбежный процесс.  Администраторы, архитекторы и инженеры облачных систем будут пользоваться высоким спросом.\n\n6. **Специалисты по блокчейн-технологиям:**  Разработчики, аудиторы и консультанты в сфере блокчейна –  новые профессии с огромным потенциалом.  Широкое внедрение криптовалют и технологии блокчейн требует высококвалифицированных специалистов.\n\n7. **Специалисты по анализу больших данных (Big Data Analysts):**  По сути, это более узкая специализация, чем Data Scientist,  фокусирующаяся на обработке и анализе исключительно больших массивов информации.\n\n8. **Специалисты в сфере  ESG (Environmental, Social, and Governance):**  Растущее внимание к экологическим, социальным и управленческим вопросам приводит к высокому спросу на специалистов, которые могут оценивать и улучшать ESG-показатели компаний.\n\n9. **Специалисты по робототехнике и автоматизации:**  Разработчики, инженеры и техники, работающие с роботами и автоматизированными системами, будут востребованы в различных отраслях – от промышленности до медицины.\n\n10. **Специалисты по цифровым маркетингу:**  Продвижение товаров и услуг в цифровом пространстве требует  высокого профессионализма.  Маркетологи, способные эффективно использовать различные цифровые инструменты, будут крайне востребованы.\n\n**Заключение:**\n\nПолучение востребованной специальности – это инвестиция в собственное будущее.  Постоянное обучение,  адаптация к новым технологиям и стремление к самосовершенствованию – вот ключи к успеху в динамично меняющемся мире. Не бойтесь экспериментировать,  изучать новые области и выбирать профессию, которая вас действительно увлекает.  Будущее за теми, кто готов к изменениям!\n	2025-02-10 10:35:14.099626
493	Статья про Как выбрать будущую профессию	AI Generated	##  Как найти свою профессию: путеводитель по лабиринту выбора\n\nВыбор будущей профессии – один из са...	##  Как найти свою профессию: путеводитель по лабиринту выбора\n\nВыбор будущей профессии – один из самых важных и одновременно сложных решений в жизни.  Давление со стороны родителей, модные тренды и неопределенность будущего могут сбить с толку даже самого уверенного в себе человека. Но не паникуйте!  Этот путеводитель поможет вам разобраться в себе и сделать осознанный выбор.\n\n**Шаг 1: Самопознание – ключ к успеху**\n\nПрежде чем рассматривать конкретные профессии, важно понять себя.  Задайте себе следующие вопросы:\n\n* **Какие у меня интересы?** Что я люблю делать в свободное время?  Что меня увлекает настолько, что я готов(а) проводить за этим часами?\n* **Какие мои сильные стороны?**  В чем я хорош(а)?  Какие навыки у меня развиты?  (Например, аналитические способности, креативность, коммуникабельность, технические навыки).\n* **Какие мои ценности?**  Что для меня важно в работе?  (Например, стабильность, творчество, помощь людям, высокая зарплата, возможность путешествовать).\n* **Какой у меня стиль работы?**  Предпочитаю ли я работать самостоятельно или в команде?  Люблю ли я рутину или предпочитаю разнообразие?  Работаю ли я лучше под давлением или в спокойной обстановке?\n\nПройдите онлайн-тесты на профориентацию.  Многие ресурсы предлагают бесплатные тесты, которые помогут определить ваши склонности и подходящие типы профессий.  Однако помните, что результаты тестов – это лишь отправная точка, а не абсолютная истина.\n\n**Шаг 2: Исследование мира профессий**\n\nТеперь, когда вы лучше понимаете себя, пора исследовать мир профессий.\n\n* **Поговорите с людьми разных профессий.**  Узнайте о их повседневной работе, плюсах и минусах профессии, необходимых навыках и образовании.\n* **Изучите рынок труда.**  Какие профессии востребованы сейчас и в будущем?  Какие перспективы роста в выбранной сфере?  Проведите исследование на сайтах по поиску работы, статистических порталах и в новостях.\n* **Посетите дни открытых дверей в университетах и колледжах.**  Это отличная возможность узнать больше о конкретных программах обучения и пообщаться со студентами и преподавателями.\n* **Попробуйте себя в разных сферах.**  Практика – лучший способ понять, подходит ли вам та или иная профессия.  Стажировки, волонтерство, подработка – все это поможет вам получить практический опыт.\n\n\n**Шаг 3: Составление плана действий**\n\nПосле анализа собственных качеств и изучения рынка труда, составьте план действий:\n\n* **Выберите несколько профессий, которые вам интересны.**  Не ограничивайте себя одним вариантом.\n* **Узнайте, какое образование необходимо для каждой профессии.**  Подумайте о поступлении в университет, колледж или получении профессиональных курсов.\n* **Составьте план подготовки.**  Что вам нужно сделать, чтобы достичь вашей цели?  Какие навыки нужно развивать?  Какие знания необходимо получить?\n* **Будьте готовы к изменениям.**  Мир постоянно меняется, и ваши планы тоже могут корректироваться.  Будьте гибкими и открыты новым возможностям.\n\n\n**Шаг 4: Не бойтесь ошибаться**\n\nВыбор профессии – это марафон, а не спринт.  Не бойтесь ошибаться и менять свои планы.  Важно постоянно развиваться, учиться новому и адаптироваться к изменяющимся условиям рынка труда.  Главное –  делать осознанный выбор, опираясь на свои интересы, способности и ценности.  Ваш профессиональный путь – это ваше собственное путешествие, и вы сами определяете его маршрут.\n	2025-02-10 10:35:24.444841
495	Статья про Как написать мотивационное письмо для поступления	AI Generated	##  Ключ к успеху: как написать мотивационное письмо, которое откроет вам двери университета\n\nПоступ...	##  Ключ к успеху: как написать мотивационное письмо, которое откроет вам двери университета\n\nПоступление в университет – это серьезный шаг, и мотивационное письмо – ваш главный помощник в этом процессе.  Это не просто формальность, а возможность показать себя с лучшей стороны, рассказать о своих целях и убедить приемную комиссию в том, что именно вы – идеальный кандидат.  Но как написать такое письмо, которое действительно произведет впечатление?\n\n**1.  Внимательно изучите требования:**\n\nПрежде чем приступать к написанию, ознакомьтесь с требованиями университета к мотивационному письму. Обратите внимание на указанный объем, формат (например, шрифт, межстрочный интервал), и  специфические вопросы, на которые нужно ответить.  Незнание этих требований может привести к отбраковке вашей заявки.\n\n**2.  Продемонстрируйте свою индивидуальность:**\n\nПриемная комиссия читает десятки, а то и сотни мотивационных писем. Ваша задача – выделиться из общей массы. Не копируйте шаблоны и не пишите банальности.  Расскажите о своих уникальных качествах, достижениях и интересах, которые  сделают вас ценным студентом.  Помните, что это  ваш шанс показать, почему вы подходите именно этому университету и выбранной программе.\n\n**3.  Убедительно расскажите свою историю:**\n\nМотивационное письмо – это не просто перечень ваших успехов. Это история вашего пути, которая логично подводит к вашему желанию поступить в данный университет.  Объясните, что привело вас к выбору этой программы, какие ваши интересы и опыт  связаны с ней, и как вы планируете использовать полученные знания в будущем.\n\n**4.  Подчеркните свои навыки и опыт:**\n\nУкажите конкретные примеры, демонстрирующие ваши навыки и умения, которые важны для обучения на выбранной программе. Это могут быть участие в проектах, волонтерская деятельность,  научные работы,  публикации или достижения в спорте или творчестве.  Не просто перечисляйте их, а объясняйте, чему вы научились и как это поможет вам в университете.\n\n**5.  Объясните свой выбор университета:**\n\nПочему именно этот университет?  Что вас привлекает в его программе, преподавательском составе,  исследовательской деятельности или инфраструктуре?  Продемонстрируйте, что вы хорошо изучили университет и осознанно сделали свой выбор.  Не ограничивайтесь общими фразами, а укажите конкретные факты и аргументы.\n\n**6.  Оформите письмо грамотно и корректно:**\n\nМотивационное письмо должно быть написано грамотно, без орфографических и пунктуационных ошибок.  Избегайте сложных и многосложных предложений,  будьте лаконичны и точны.  Проверьте письмо на наличие ошибок несколько раз, желательно, чтобы его прочитал кто-то другой.\n\n**7.  Будьте искренни:**\n\nСамое главное –  будьте искренни.  Пишите от души,  раскрывайте свои настоящие мотивы и цели.  Искренность всегда чувствуется, и она гораздо ценнее  написанного «под копирку» текста.\n\n**8.  Проверьте и отредактируйте:**\n\nПосле написания письма обязательно перечитайте его несколько раз. Убедитесь, что оно соответствует всем требованиям, логично построено,  читается легко и убедительно.  Попросите кого-нибудь из друзей или преподавателей проверить ваше письмо на наличие ошибок и дать обратную связь.\n\nНаписание мотивационного письма – это серьезная работа, требующая времени и усилий. Но результат стоит затраченных сил.  Хорошо написанное мотивационное письмо  может стать  ключом к успеху в поступлении в ваш желаемый университет.  Удачи!\n	2025-02-10 10:35:37.945672
496	Статья про Как правильно подготовиться к вступительным экзаменам	AI Generated	## Штурм вуза: как подготовиться к вступительным экзаменам и не сойти с ума\n\nВступительные экзамены ...	## Штурм вуза: как подготовиться к вступительным экзаменам и не сойти с ума\n\nВступительные экзамены – стресс, который знакомому каждому абитуриенту.  Однако, с грамотной подготовкой этот стресс можно значительно снизить, превратив его в продуктивное напряжение.  Эта статья подскажет, как эффективно подготовиться к экзаменам и поступить в желаемый вуз.\n\n**1. Планирование – ключ к успеху:**\n\nНельзя просто сесть и начать зубрить.  Нужно составить четкий план подготовки.  Определите:\n\n* **Список предметов:**  Какие экзамены вам предстоят?\n* **Даты экзаменов:**  Это критически важно для составления графика.\n* **Уровень подготовки:**  Честно оцените свои знания по каждому предмету.\n* **Сильные и слабые стороны:**  На какие темы нужно обратить больше внимания?\n* **Время:**  Сколько времени вы можете посвятить подготовке ежедневно/еженедельно?  Будьте реалистичны!\n\nСоздайте расписание, которое включает не только учебу, но и отдых, спорт, хобби.  Избегайте переутомления – это снижает эффективность.  Разбейте весь материал на небольшие, осмысленные блоки.  Например, вместо "прочитать главу", напишите "выучить параграфы 1-3, решить 5 задач".\n\n**2. Эффективные методы обучения:**\n\nЗабудьте о бессмысленном зубрежке.  Вот несколько эффективных методов:\n\n* **Метод Фейнмана:**  Объясните изученный материал, как будто вы объясняете его кому-то другому.  Это поможет выявить пробелы в знаниях.\n* **Карточки:**  Запишите на карточках ключевые понятия, формулы, даты.  Это удобный способ повторения.\n* **Составление конспектов:**  Сжатое изложение материала в собственных словах способствует лучшему запоминанию.\n* **Решение задач/тестов:**  Практика – залог успеха.  Решайте как можно больше задач по каждому предмету, включая прошлые варианты экзаменов.\n* **Использование разных источников информации:**  Учебники, онлайн-курсы, видеоуроки – разнообразие делает обучение более интересным и эффективным.\n\n**3. Забота о себе:**\n\nПодготовка – марафон, а не спринт.  Забота о физическом и психическом здоровье – неотъемлемая часть успеха:\n\n* **Режим дня:**  Ложитесь спать и просыпайтесь в одно и то же время, даже в выходные.  Хороший сон – залог продуктивной учебы.\n* **Здоровое питание:**  Питайтесь полноценно и регулярно.  Избегайте фастфуда и перекусов.\n* **Физическая активность:**  Регулярные физические упражнения снижают стресс и улучшают концентрацию.  Даже короткие прогулки на свежем воздухе принесут пользу.\n* **Отдых и развлечения:**  Не забывайте о хобби и отдыхе.  Полное погружение в учебу может привести к выгоранию.\n\n**4.  Практика и имитация экзаменационных условий:**\n\nЗа несколько недель до экзаменов начните решать пробные тесты в условиях, приближенных к реальным:  отведите определенное время, сидите за столом, не пользуйтесь подсказками.  Это поможет снизить стресс во время настоящего экзамена.\n\n**5.  Не бойтесь просить о помощи:**\n\nЕсли у вас возникают сложности с каким-то предметом, не стесняйтесь обратиться за помощью к репетитору, учителям или одноклассникам.  Взаимная поддержка очень важна в этот период.\n\n\nПодготовка к вступительным экзаменам – это серьезная работа, требующая дисциплины и самоорганизации.  Но помните, что успех зависит не только от количества выученного материала, но и от грамотного планирования, эффективных методов обучения и заботы о себе. Удачи!\n	2025-02-10 10:35:45.262485
497	Статья про Стоит ли поступать в университет или выбрать онлайн-образование?	AI Generated	## Университет или онлайн: выбор за вами, но с осознанием!\n\nВыбор между традиционным университетским...	## Университет или онлайн: выбор за вами, но с осознанием!\n\nВыбор между традиционным университетским образованием и онлайн-обучением – один из самых важных в жизни молодого человека.  Оба варианта имеют свои преимущества и недостатки, и идеального решения не существует.  Эта статья поможет вам взвесить все "за" и "против", чтобы сделать осознанный выбор, соответствующий вашим целям, личности и обстоятельствам.\n\n**Университет: классика жанра с неоспоримыми плюсами**\n\n* **Сеть контактов:** Университет – это не только лекции и семинары. Это  богатая социальная среда, позволяющая завести полезные знакомства с однокурсниками, преподавателями, а возможно, и будущими работодателями.  Неформальное общение, совместная работа над проектами – все это способствует развитию коммуникативных навыков и построению карьеры.\n* **Структурированное обучение:**  Четкий график занятий,  регулярные контрольные работы и экзамены дисциплинируют и помогают поддерживать стабильный темп обучения.  Для многих студентов именно эта структура является необходимым стимулом.\n* **Прямое взаимодействие с преподавателями:**  Возможность задать вопрос напрямую, получить индивидуальную консультацию и обсудить сложные темы –  незаменимый аспект традиционного обучения.\n* **Доступ к ресурсам:**  Университеты предоставляют доступ к библиотекам, лабораториям, спортивным залам и другим ресурсам, которые могут существенно обогатить учебный процесс.\n* **Диплом государственного образца:**  Для некоторых профессий и компаний диплом государственного образца – обязательное условие трудоустройства.\n\n\n**Онлайн-образование: гибкость и доступность в новом свете**\n\n* **Гибкость и свобода:**  Возможность учиться в удобное время и в удобном месте – огромное преимущество для занятых людей, родителей или тех, кто проживает вдали от университетов.\n* **Доступность:**  Онлайн-курсы часто стоят дешевле, чем очное обучение, а также доступны людям с ограниченными возможностями или проживающим в отдаленных регионах.\n* **Специализация:**  Онлайн-платформы предлагают широкий выбор специализированных курсов, которые могут быть недоступны в вашем регионе или университете.\n* **Удобство:**  Нет необходимости тратить время и деньги на дорогу, проживание и другие расходы, связанные с очным обучением.\n* **Современные технологии:**  Многие онлайн-курсы используют интерактивные методы обучения, видеолекции, онлайн-симуляторы и другие современные технологии, повышающие эффективность обучения.\n\n\n**Что учесть при выборе:**\n\n* **Ваши цели:**  Что вы хотите получить от образования?  Высокооплачиваемую работу?  Новые знания и навыки?  Личное удовлетворение?  Цели определят ваш выбор.\n* **Ваш стиль обучения:**  Вы предпочитаете структурированную среду или  самостоятельную работу?  Экстроверт или интроверт?\n* **Финансовые возможности:**  Учитывайте стоимость обучения, проживание (если необходимо), учебные материалы и другие расходы.\n* **Ваш характер:**  Способны ли вы к самодисциплине, необходимой для успешного онлайн-обучения?\n\n\n**Заключение:**\n\nВыбор между университетом и онлайн-образованием – это индивидуальный выбор, который зависит от множества факторов.  Внимательно взвесьте все "за" и "против", учитывая свои цели, возможности и предпочтения.  Возможно,  комбинация обоих вариантов –  обучение в университете с дополнением онлайн-курсами – станет оптимальным решением.  Главное –  сделать осознанный выбор и идти к своей цели с уверенностью!\n	2025-02-10 10:35:51.81507
498	Статья про Как совмещать учебу и подработку без вреда для учебы?	AI Generated	## Как совмещать учебу и подработку без вреда для успеваемости?\n\nСтуденческая жизнь – это время акти...	## Как совмещать учебу и подработку без вреда для успеваемости?\n\nСтуденческая жизнь – это время активного обучения, саморазвития и, зачастую, необходимости подработки для обеспечения себя карманными деньгами.  Совмещать эти два аспекта непросто, но вполне возможно, если подойти к вопросу грамотно и организованно.  Главное – не допустить, чтобы подработка стала камнем преткновения на пути к успешной учебе.  Эта статья расскажет вам, как этого избежать.\n\n**1. Планирование – ключ к успеху:**\n\nПрежде чем искать подработку, составьте детальный график своей учебной недели.  Запланируйте время на лекции, семинары, самостоятельную подготовку к занятиям, выполнение домашних заданий и контрольных работ.  Только после этого ищите работу, учитывая свободное время.  Используйте календари, планировщики (Google Calendar, Trello, Notion) или даже обычный ежедневник – главное, чтобы система планирования была вам удобна и эффективна.\n\n**2. Выбор подходящей подработки:**\n\nНе каждая подработка подходит для совмещения с учебой.  Избегайте вакансий с жестким графиком и большим количеством сверхурочных часов.  Идеальный вариант – это:\n\n* **Гибкий график:**  работа на удалёнке (фриланс – копирайтинг, дизайн, программирование),  часовая оплата (официант, промоутер с возможностью выбора смен),  работа с неполной занятостью.\n* **Соответствие вашим навыкам:**  если вы умеете писать, редактировать, переводить, программировать – используйте свои умения для удаленной работы.  Это позволит зарабатывать, не тратя много времени на дорогу и адаптацию.\n* **Работа, связанная с вашей специальностью:**  подработка, которая хоть как-то связана с будущей профессией, будет полезна для приобретения опыта и расширения кругозора.\n\n**3. Эффективное управление временем:**\n\n* **Техника Pomodoro:**  работайте сконцентрированно 25 минут, затем делайте 5-минутный перерыв.  Этот метод помогает поддерживать высокую продуктивность и избегать переутомления.\n* **Приоритезация задач:**  определите, какие задачи наиболее важны для учебы и работы, и начинайте с них.  Используйте матрицу Эйзенхауэра для классификации задач по срочности и важности.\n* **Минимизация отвлекающих факторов:**  выключайте уведомления на телефоне, найдите тихое место для работы и учебы, избегайте социальных сетей во время работы.\n\n**4. Забота о здоровье:**\n\nСовмещение учебы и работы – это стресс.  Не забывайте о достаточном отдыхе, сбалансированном питании и физических нагрузках.  Спорт помогает снять напряжение и улучшить концентрацию.  Высыпайтесь – это крайне важно для успешной учебы и работы.\n\n**5. Коммуникация:**\n\nНе стесняйтесь говорить преподавателям о вашей подработке, особенно если она может повлиять на посещаемость занятий или выполнение заданий.  Возможно, они пойдут вам навстречу и предложат альтернативные варианты.\n\n**Заключение:**\n\nСовмещать учебу и подработку реально, но требует самодисциплины, планирования и эффективного управления временем.  Выбирайте подработку, которая подходит вашему графику и навыкам, и не забывайте о собственном здоровье и благополучии.  Успешная учеба – это приоритет, и подработка должна служить ей поддержкой, а не помехой.\n	2025-02-10 10:35:58.100434
\.


--
-- TOC entry 4874 (class 0 OID 24615)
-- Dependencies: 223
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name) FROM stdin;
1	Programming
2	Data Science
3	Web Development
\.


--
-- TOC entry 4880 (class 0 OID 40981)
-- Dependencies: 229
-- Data for Name: email_verifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_verifications (id, email, code, expires_at) FROM stdin;
\.


--
-- TOC entry 4872 (class 0 OID 24605)
-- Dependencies: 221
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resources (id, title, description, url, created_at, category_id) FROM stdin;
1	IT	Information technologies	https://en.wikipedia.org/wiki/Information_technology	2025-01-17 13:35:22.344443	1
\.


--
-- TOC entry 4868 (class 0 OID 24591)
-- Dependencies: 217
-- Data for Name: table1; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.table1 (id, name, description) FROM stdin;
1	first	this is first row
2	second	this is second row
3	third	this is third row
4	fourth	this is fourth row
\.


--
-- TOC entry 4876 (class 0 OID 32789)
-- Dependencies: 225
-- Data for Name: universities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.universities (id, name, description, location, established, image_url, admission_start, admission_end, faculties, conditions, additional) FROM stdin;
6	Казахский национальный аграрный исследовательский университет	Специализируется на аграрных науках, а также предлагает программы по менеджменту, рекламе и маркетингу.	Алматы	1929	https://eldala.kz/uploads/all/64/ba/3d/64ba3de7ad3499f1cb8ec66e17e5db3e.jpg	2025-01-01	2025-02-01	\N	\N	\N
4	Южно-Казахстанский университет имени Мухтара Ауэзова	Южно-Казахстанский университет им. М.Ауезова – крупнейший и многопрофильный университет Республики Казахстан, научно-образовательный, интеллектуальный, культурный центр региона.\nВ университете ведется подготовка специалистов для всех секторов экономики, науки и культуры региона, республики и мирового пространства. Южно-Казахстанский государственный университет им. М.Ауезова является одним из самых ярких брендов сферы высшего образования республики.	Шымкент	1943	https://beam-storage.object.pscloud.io/organizations/188/images/b57c42aa-e9b3-4077-b74d-272ce3d4ea64.png	2025-02-01	2025-06-01	Высшая школа "Сельско-хозяйственных наук"\nВысшая школа "Информационных технологий и энергетики"\nВысшая школа "Текстильной и пищевой инженерии"\nВысшая школа "Химической инженерии и биотехнологии"\nВысшая школа "Управления и бизнеса"\nЕстественно-научно-педагогическая высшая школа\nФакультет строительства и транспорта\nФакультет механики и нефтегазового дела\nФакультет педагогики и культуры\n"Юридический" Факультет\nФакультет филологии\nФакультет Физическая культура и спорт\nФакультет по работе с иностранными студентами и довузовской подготовки\nИнститут дистанционного обучения	Бакалавриат\n1. Документ об общем среднем, техническом и профессиональном, послесреднем или высшем образовании (подлинник);\n2. Копия документа, удостоверяющего личность;\n3. 6 фотокарточек размером 3х4 сантиметра;\n4. Медицинская справка по форме 075-У;\n5. Cертификат единого национального тестирования;\n6. Выписка из ведомости специального или творческого экзамена (для поступающих по образовательным программам, требующим специальной или творческой подготовки, в том числе по областям образования «Педагогические науки»);\n7. Cвидетельство о присуждении образовательного гранта (при его наличии).\n Примечание: Для иностранных граждан документы на иностранном языке предоставляются с нотариально засвидельствованным переводом на казахский или русский язык.	https://auezov.edu.kz/media/attachments/2024/09/05/putevoditel-uku-rus-2024-2025.pdf
2	Евразийский национальный университет имени Л.Н. Гумилева (ЕНУ)	Ведущий национальный университет, известный своими программами в области инженерии, естественных наук и гуманитарных дисциплин.	Астана	1996	https://fb.ru/misc/i/gallery/50521/3059435.jpg	2025-01-01	2025-02-01	\N	\N	\N
3	Казахский национальный исследовательский технический университет имени К. Сатпаева (КазНИТУ)	Известен своими инженерными и техническими программами, а также научными исследованиями в области энергетики и информационных технологий.	Алматы	1934	https://tse2.mm.bing.net/th?id=OIP.t0m8JGg58BJUO6RfmhKzpwHaE8&pid=Api	2025-01-01	2025-02-01	\N	\N	\N
7	Международный казахско-турецкий университет имени Ходжа Ахмеда Ясави	Совместный казахско-турецкий университет, предлагающий программы на казахском, турецком и английском языках.	Туркестан	1993	https://admin.vipusknik.kz/storage/1080/12115549-1532637883692846-8328533743114644431-njpg.jpeg	2025-01-01	2025-02-01	\N	\N	\N
5	Казахский национальный педагогический университет имени Абая (КазНПУ)	Первый высший учебный заведением Казахстана, специализирующийся на подготовке педагогических кадров.	Алматы	1928	https://kaznpu.kz/docs/logotip.jpg	2025-02-01	2025-03-01	\N	\N	\N
8	Карагандинский технический университет имени Абылкаса Сагинова	Известен своими программами в области горного дела, металлургии и других технических дисциплин.	Караганда	1953	https://www.kstu.kz/wp-content/uploads/2022/08/logo_stu-1024x1024.png	2025-01-01	2025-02-01	\N	\N	\N
1	Казахский национальный университет имени аль-Фараби (КазНУ)	Крупнейший и старейший классический университет Казахстана, предлагающий широкий спектр программ бакалавриата, магистратуры и докторантуры.	Алматы	1934	https://tse2.mm.bing.net/th?id=OIP.kZ6NtVGaKWyBIHBEKTvyVQHaHk&pid=Api	2025-01-01	2025-02-01	\N	\N	\N
\.


--
-- TOC entry 4884 (class 0 OID 49183)
-- Dependencies: 233
-- Data for Name: user_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_documents (id, user_id, file_name, file_path, uploaded_at) FROM stdin;
1	13	Современные технологии Тестовые вопросы.pdf	uploads\\1738559623841.pdf	2025-02-03 11:13:43.860742
3	13	Методы Экзаменационные вопросы.pdf	uploads\\1738562445881.pdf	2025-02-03 12:00:45.889254
\.


--
-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 234
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admins_id_seq', 1, true);


--
-- TOC entry 4903 (class 0 OID 0)
-- Dependencies: 218
-- Name: applicants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applicants_id_seq', 15, true);


--
-- TOC entry 4904 (class 0 OID 0)
-- Dependencies: 226
-- Name: applications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applications_id_seq', 37, true);


--
-- TOC entry 4905 (class 0 OID 0)
-- Dependencies: 230
-- Name: articles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.articles_id_seq', 594, true);


--
-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 222
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 3, true);


--
-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 228
-- Name: email_verifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.email_verifications_id_seq', 8, true);


--
-- TOC entry 4908 (class 0 OID 0)
-- Dependencies: 220
-- Name: resources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resources_id_seq', 1, true);


--
-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 216
-- Name: table1_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.table1_id_seq', 4, true);


--
-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 224
-- Name: universities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.universities_id_seq', 10, true);


--
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 232
-- Name: user_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_documents_id_seq', 3, true);


--
-- TOC entry 4718 (class 2606 OID 49238)
-- Name: admins admins_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_email_key UNIQUE (email);


--
-- TOC entry 4720 (class 2606 OID 49236)
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- TOC entry 4696 (class 2606 OID 24603)
-- Name: applicants applicants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT applicants_pkey PRIMARY KEY (id);


--
-- TOC entry 4706 (class 2606 OID 32806)
-- Name: applications applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (id);


--
-- TOC entry 4712 (class 2606 OID 41002)
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- TOC entry 4714 (class 2606 OID 41004)
-- Name: articles articles_title_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_title_key UNIQUE (title);


--
-- TOC entry 4700 (class 2606 OID 24622)
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- TOC entry 4702 (class 2606 OID 24620)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4708 (class 2606 OID 40990)
-- Name: email_verifications email_verifications_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_verifications
    ADD CONSTRAINT email_verifications_email_key UNIQUE (email);


--
-- TOC entry 4710 (class 2606 OID 40988)
-- Name: email_verifications email_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_verifications
    ADD CONSTRAINT email_verifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4698 (class 2606 OID 24613)
-- Name: resources resources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- TOC entry 4704 (class 2606 OID 32796)
-- Name: universities universities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.universities
    ADD CONSTRAINT universities_pkey PRIMARY KEY (id);


--
-- TOC entry 4716 (class 2606 OID 49191)
-- Name: user_documents user_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_documents
    ADD CONSTRAINT user_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4722 (class 2606 OID 32807)
-- Name: applications applications_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id);


--
-- TOC entry 4721 (class 2606 OID 24623)
-- Name: resources resources_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- TOC entry 4723 (class 2606 OID 49192)
-- Name: user_documents user_documents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_documents
    ADD CONSTRAINT user_documents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.applicants(id) ON DELETE CASCADE;


-- Completed on 2025-02-10 16:36:54

--
-- PostgreSQL database dump complete
--

