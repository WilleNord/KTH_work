--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15.1

-- Started on 2023-01-10 20:21:19 CET

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

DROP DATABASE soundgood;
--
-- TOC entry 3868 (class 1262 OID 16398)
-- Name: soundgood; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE soundgood WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE soundgood OWNER TO postgres;

\connect soundgood

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
-- TOC entry 237 (class 1259 OID 16705)
-- Name: ensemble; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ensemble (
    id integer NOT NULL,
    min_students integer NOT NULL,
    max_students integer NOT NULL,
    genre character varying(100) NOT NULL,
    time_slot_id integer
);


ALTER TABLE public.ensemble OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16693)
-- Name: time_slot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.time_slot (
    id integer NOT NULL,
    datetime timestamp(6) without time zone NOT NULL,
    duration time(6) without time zone NOT NULL,
    person_id integer
);


ALTER TABLE public.time_slot OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 25096)
-- Name: e_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.e_month AS
 SELECT date_trunc('month'::text, ts.datetime) AS month,
    count(e.id) AS "Ensembles/month"
   FROM (public.ensemble e
     LEFT JOIN public.time_slot ts ON ((ts.id = e.time_slot_id)))
  GROUP BY (date_trunc('month'::text, ts.datetime))
  ORDER BY (date_trunc('month'::text, ts.datetime));


ALTER TABLE public.e_month OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16717)
-- Name: group_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_lesson (
    id integer NOT NULL,
    min_students integer NOT NULL,
    max_students integer NOT NULL,
    instrument character varying(100) NOT NULL,
    skill_level character varying(20) NOT NULL,
    time_slot_id integer
);


ALTER TABLE public.group_lesson OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 25092)
-- Name: gl_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.gl_month AS
 SELECT date_trunc('month'::text, ts.datetime) AS month,
    count(gl.id) AS "Group lessons/month"
   FROM (public.group_lesson gl
     LEFT JOIN public.time_slot ts ON ((ts.id = gl.time_slot_id)))
  GROUP BY (date_trunc('month'::text, ts.datetime))
  ORDER BY (date_trunc('month'::text, ts.datetime));


ALTER TABLE public.gl_month OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 16837)
-- Name: individual_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.individual_lesson (
    id integer NOT NULL,
    instrument character varying(100) NOT NULL,
    skill_level character varying(20) NOT NULL,
    time_slot_id integer,
    booking_id integer
);


ALTER TABLE public.individual_lesson OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 25088)
-- Name: il_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.il_month AS
 SELECT date_trunc('month'::text, ts.datetime) AS month,
    count(il.id) AS "Individual lessons/month"
   FROM (public.individual_lesson il
     LEFT JOIN public.time_slot ts ON ((ts.id = il.time_slot_id)))
  GROUP BY (date_trunc('month'::text, ts.datetime))
  ORDER BY (date_trunc('month'::text, ts.datetime));


ALTER TABLE public.il_month OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 25100)
-- Name: all_lessons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_lessons AS
 SELECT e_month.month,
    e_month."Ensembles/month",
    gl_month."Group lessons/month",
    il_month."Individual lessons/month"
   FROM ((public.e_month
     FULL JOIN public.gl_month ON ((e_month.month = gl_month.month)))
     FULL JOIN public.il_month ON ((gl_month.month = il_month.month)));


ALTER TABLE public.all_lessons OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16594)
-- Name: booking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking (
    id integer NOT NULL,
    person_id integer NOT NULL,
    discount_id integer,
    lesson_price_id integer NOT NULL
);


ALTER TABLE public.booking OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16743)
-- Name: booking_ensemble; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking_ensemble (
    ensemble_id integer NOT NULL,
    booking_id integer NOT NULL
);


ALTER TABLE public.booking_ensemble OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16758)
-- Name: booking_group_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking_group_lesson (
    booking_id integer NOT NULL,
    group_lesson_id integer NOT NULL
);


ALTER TABLE public.booking_group_lesson OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16593)
-- Name: booking_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.booking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.booking_id_seq OWNER TO postgres;

--
-- TOC entry 3869 (class 0 OID 0)
-- Dependencies: 228
-- Name: booking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.booking_id_seq OWNED BY public.booking.id;


--
-- TOC entry 230 (class 1259 OID 16615)
-- Name: contact_person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_person (
    person_id integer NOT NULL,
    name character varying(100) NOT NULL,
    phone_number character varying(20) NOT NULL
);


ALTER TABLE public.contact_person OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16518)
-- Name: discount; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discount (
    id integer NOT NULL,
    percentage numeric(10,0) NOT NULL
);


ALTER TABLE public.discount OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16517)
-- Name: discount_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.discount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discount_id_seq OWNER TO postgres;

--
-- TOC entry 3870 (class 0 OID 0)
-- Dependencies: 214
-- Name: discount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.discount_id_seq OWNED BY public.discount.id;


--
-- TOC entry 217 (class 1259 OID 16525)
-- Name: email; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email (
    id integer NOT NULL,
    email_address character varying(100) NOT NULL
);


ALTER TABLE public.email OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16524)
-- Name: email_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.email_id_seq OWNER TO postgres;

--
-- TOC entry 3871 (class 0 OID 0)
-- Dependencies: 216
-- Name: email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_id_seq OWNED BY public.email.id;


--
-- TOC entry 236 (class 1259 OID 16704)
-- Name: ensemble_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ensemble_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ensemble_id_seq OWNER TO postgres;

--
-- TOC entry 3872 (class 0 OID 0)
-- Dependencies: 236
-- Name: ensemble_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ensemble_id_seq OWNED BY public.ensemble.id;


--
-- TOC entry 238 (class 1259 OID 16716)
-- Name: group_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.group_lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_lesson_id_seq OWNER TO postgres;

--
-- TOC entry 3873 (class 0 OID 0)
-- Dependencies: 238
-- Name: group_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.group_lesson_id_seq OWNED BY public.group_lesson.id;


--
-- TOC entry 242 (class 1259 OID 16799)
-- Name: sibling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sibling (
    person_id integer NOT NULL,
    sibling_id integer NOT NULL
);


ALTER TABLE public.sibling OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16576)
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    person_id integer NOT NULL,
    skill_level character varying(20) NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 16853)
-- Name: number_of_siblings; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.number_of_siblings AS
 SELECT count(sibling.sibling_id) AS siblings
   FROM (public.student
     LEFT JOIN public.sibling ON ((sibling.sibling_id = student.person_id)))
  GROUP BY student.person_id;


ALTER TABLE public.number_of_siblings OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 16866)
-- Name: has_siblings; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.has_siblings AS
 SELECT number_of_siblings.siblings AS "Number of siblings",
    count(number_of_siblings.siblings) AS count
   FROM public.number_of_siblings
  GROUP BY number_of_siblings.siblings
  ORDER BY number_of_siblings.siblings;


ALTER TABLE public.has_siblings OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 16836)
-- Name: individual_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.individual_lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.individual_lesson_id_seq OWNER TO postgres;

--
-- TOC entry 3874 (class 0 OID 0)
-- Dependencies: 246
-- Name: individual_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.individual_lesson_id_seq OWNED BY public.individual_lesson.id;


--
-- TOC entry 231 (class 1259 OID 16625)
-- Name: instructor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor (
    person_id integer NOT NULL,
    teaches_ensembles boolean NOT NULL
);


ALTER TABLE public.instructor OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 25147)
-- Name: instructor_lesson_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.instructor_lesson_month AS
 SELECT instructor.person_id,
    EXTRACT(month FROM ts.datetime) AS month
   FROM ((((public.instructor
     LEFT JOIN public.time_slot ts ON ((ts.person_id = instructor.person_id)))
     FULL JOIN public.individual_lesson il ON ((il.time_slot_id = ts.id)))
     FULL JOIN public.group_lesson gl ON ((gl.time_slot_id = ts.id)))
     FULL JOIN public.ensemble e ON ((e.time_slot_id = ts.id)));


ALTER TABLE public.instructor_lesson_month OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 33228)
-- Name: instructor_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.instructor_month AS
 SELECT count(instructor_lesson_month.month) AS lessons
   FROM public.instructor_lesson_month
  WHERE (instructor_lesson_month.month = EXTRACT(month FROM CURRENT_DATE))
  GROUP BY instructor_lesson_month.person_id
 HAVING (count(instructor_lesson_month.month) > 5)
  ORDER BY (count(instructor_lesson_month.month));


ALTER TABLE public.instructor_month OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16635)
-- Name: instructor_teach_instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor_teach_instrument (
    person_id integer NOT NULL,
    teach_instrument_id integer NOT NULL
);


ALTER TABLE public.instructor_teach_instrument OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16532)
-- Name: lesson_price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson_price (
    id integer NOT NULL,
    lesson_type character varying(20) NOT NULL,
    level character varying(20) NOT NULL,
    price numeric(20,0) NOT NULL
);


ALTER TABLE public.lesson_price OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16531)
-- Name: lesson_price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesson_price_id_seq OWNER TO postgres;

--
-- TOC entry 3875 (class 0 OID 0)
-- Dependencies: 218
-- Name: lesson_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_price_id_seq OWNED BY public.lesson_price.id;


--
-- TOC entry 256 (class 1259 OID 25157)
-- Name: next_week_ensembles; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.next_week_ensembles AS
 SELECT ensemble.id,
    ensemble.genre,
    EXTRACT(dow FROM ts.datetime) AS weekday,
    ensemble.min_students,
    ensemble.max_students
   FROM (public.ensemble
     JOIN public.time_slot ts ON ((ensemble.time_slot_id = ts.id)))
  WHERE (EXTRACT(week FROM ts.datetime) = ( SELECT (EXTRACT(week FROM CURRENT_TIMESTAMP) + (1)::numeric)));


ALTER TABLE public.next_week_ensembles OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 16862)
-- Name: no_sibling_students; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.no_sibling_students AS
 SELECT count(student.person_id) AS no_sibling_students
   FROM public.student
  WHERE (NOT (student.person_id IN ( SELECT sibling.person_id
           FROM public.sibling)));


ALTER TABLE public.no_sibling_students OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16539)
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    person_number character varying(12) NOT NULL,
    street character varying(100) NOT NULL,
    zip_code character varying(10) NOT NULL,
    city character varying(100) NOT NULL
);


ALTER TABLE public.person OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16547)
-- Name: person_email; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_email (
    person_id integer NOT NULL,
    email_id integer NOT NULL
);


ALTER TABLE public.person_email OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16538)
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_id_seq OWNER TO postgres;

--
-- TOC entry 3876 (class 0 OID 0)
-- Dependencies: 220
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.person_id_seq OWNED BY public.person.id;


--
-- TOC entry 233 (class 1259 OID 16650)
-- Name: person_phone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_phone (
    person_id integer NOT NULL,
    phone_id integer NOT NULL
);


ALTER TABLE public.person_phone OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16563)
-- Name: phone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.phone (
    id integer NOT NULL,
    phone_number character varying(20) NOT NULL
);


ALTER TABLE public.phone OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16562)
-- Name: phone_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.phone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phone_id_seq OWNER TO postgres;

--
-- TOC entry 3877 (class 0 OID 0)
-- Dependencies: 223
-- Name: phone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.phone_id_seq OWNED BY public.phone.id;


--
-- TOC entry 245 (class 1259 OID 16821)
-- Name: rent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rent (
    rent_instrument_id integer NOT NULL,
    person_id integer NOT NULL,
    start_month character varying(20) NOT NULL,
    duration integer NOT NULL,
    to_be_delivered boolean NOT NULL
);


ALTER TABLE public.rent OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16815)
-- Name: rent_instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rent_instrument (
    id integer NOT NULL,
    brand character varying(100),
    rental_price numeric(20,0) NOT NULL,
    type character varying(100) NOT NULL,
    inventory_id integer
);


ALTER TABLE public.rent_instrument OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16814)
-- Name: rent_instrument_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rent_instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rent_instrument_id_seq OWNER TO postgres;

--
-- TOC entry 3878 (class 0 OID 0)
-- Dependencies: 243
-- Name: rent_instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rent_instrument_id_seq OWNED BY public.rent_instrument.id;


--
-- TOC entry 260 (class 1259 OID 33232)
-- Name: seat_count; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.seat_count AS
 SELECT nwe.id,
    count(booking_ensemble.ensemble_id) AS count
   FROM (public.booking_ensemble
     JOIN public.next_week_ensembles nwe ON ((nwe.id = booking_ensemble.ensemble_id)))
  GROUP BY nwe.id;


ALTER TABLE public.seat_count OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 33236)
-- Name: seats_next_week_ensembles; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.seats_next_week_ensembles AS
 SELECT next_week_ensembles.id,
    next_week_ensembles.genre,
    next_week_ensembles.weekday,
        CASE
            WHEN (( SELECT seat_count.count
               FROM public.seat_count
              WHERE (seat_count.id = next_week_ensembles.id)) < next_week_ensembles.max_students) THEN (next_week_ensembles.max_students - ( SELECT seat_count.count
               FROM public.seat_count
              WHERE (seat_count.id = next_week_ensembles.id)))
            ELSE (0)::bigint
        END AS "seats available"
   FROM public.next_week_ensembles
  ORDER BY next_week_ensembles.genre, next_week_ensembles.weekday;


ALTER TABLE public.seats_next_week_ensembles OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 33220)
-- Name: total_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.total_month AS
 SELECT all_lessons.month,
    sum(((COALESCE(all_lessons."Ensembles/month", (0)::bigint) + COALESCE(all_lessons."Group lessons/month", (0)::bigint)) + COALESCE(all_lessons."Individual lessons/month", (0)::bigint))) AS total
   FROM public.all_lessons
  GROUP BY all_lessons.month
  ORDER BY all_lessons.month;


ALTER TABLE public.total_month OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 33224)
-- Name: show_lessons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.show_lessons AS
 SELECT total_month.month,
    e_month."Ensembles/month",
    gl_month."Group lessons/month",
    il_month."Individual lessons/month",
    total_month.total
   FROM (((public.total_month
     FULL JOIN public.il_month ON ((il_month.month = total_month.month)))
     FULL JOIN public.gl_month ON ((gl_month.month = total_month.month)))
     FULL JOIN public.e_month ON ((e_month.month = total_month.month)))
  WHERE (EXTRACT(year FROM total_month.month) = (2023)::numeric);


ALTER TABLE public.show_lessons OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16587)
-- Name: teach_instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teach_instrument (
    id integer NOT NULL,
    instrument character varying(100) NOT NULL
);


ALTER TABLE public.teach_instrument OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16586)
-- Name: teach_instrument_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teach_instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teach_instrument_id_seq OWNER TO postgres;

--
-- TOC entry 3879 (class 0 OID 0)
-- Dependencies: 226
-- Name: teach_instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teach_instrument_id_seq OWNED BY public.teach_instrument.id;


--
-- TOC entry 234 (class 1259 OID 16692)
-- Name: time_slot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.time_slot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.time_slot_id_seq OWNER TO postgres;

--
-- TOC entry 3880 (class 0 OID 0)
-- Dependencies: 234
-- Name: time_slot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.time_slot_id_seq OWNED BY public.time_slot.id;


--
-- TOC entry 3596 (class 2604 OID 16597)
-- Name: booking id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking ALTER COLUMN id SET DEFAULT nextval('public.booking_id_seq'::regclass);


--
-- TOC entry 3590 (class 2604 OID 16521)
-- Name: discount id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount ALTER COLUMN id SET DEFAULT nextval('public.discount_id_seq'::regclass);


--
-- TOC entry 3591 (class 2604 OID 16528)
-- Name: email id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email ALTER COLUMN id SET DEFAULT nextval('public.email_id_seq'::regclass);


--
-- TOC entry 3598 (class 2604 OID 16708)
-- Name: ensemble id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble ALTER COLUMN id SET DEFAULT nextval('public.ensemble_id_seq'::regclass);


--
-- TOC entry 3599 (class 2604 OID 16720)
-- Name: group_lesson id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson ALTER COLUMN id SET DEFAULT nextval('public.group_lesson_id_seq'::regclass);


--
-- TOC entry 3601 (class 2604 OID 16840)
-- Name: individual_lesson id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson ALTER COLUMN id SET DEFAULT nextval('public.individual_lesson_id_seq'::regclass);


--
-- TOC entry 3592 (class 2604 OID 16535)
-- Name: lesson_price id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_price ALTER COLUMN id SET DEFAULT nextval('public.lesson_price_id_seq'::regclass);


--
-- TOC entry 3593 (class 2604 OID 16542)
-- Name: person id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person ALTER COLUMN id SET DEFAULT nextval('public.person_id_seq'::regclass);


--
-- TOC entry 3594 (class 2604 OID 16566)
-- Name: phone id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone ALTER COLUMN id SET DEFAULT nextval('public.phone_id_seq'::regclass);


--
-- TOC entry 3600 (class 2604 OID 16818)
-- Name: rent_instrument id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rent_instrument ALTER COLUMN id SET DEFAULT nextval('public.rent_instrument_id_seq'::regclass);


--
-- TOC entry 3595 (class 2604 OID 16590)
-- Name: teach_instrument id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teach_instrument ALTER COLUMN id SET DEFAULT nextval('public.teach_instrument_id_seq'::regclass);


--
-- TOC entry 3597 (class 2604 OID 16696)
-- Name: time_slot id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_slot ALTER COLUMN id SET DEFAULT nextval('public.time_slot_id_seq'::regclass);


--
-- TOC entry 3844 (class 0 OID 16594)
-- Dependencies: 229
-- Data for Name: booking; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (1, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (2, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (3, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (4, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (5, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (6, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (7, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (8, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (9, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (10, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (11, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (12, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (13, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (14, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (15, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (16, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (17, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (18, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (19, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (20, 11, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (21, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (22, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (23, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (24, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (25, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (26, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (27, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (28, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (29, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (30, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (31, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (32, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (33, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (34, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (35, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (36, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (37, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (38, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (39, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (40, 12, NULL, 2);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (41, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (42, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (43, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (44, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (45, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (46, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (47, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (48, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (49, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (50, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (51, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (52, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (53, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (54, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (55, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (56, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (57, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (58, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (59, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (60, 13, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (61, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (62, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (63, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (64, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (65, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (66, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (67, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (68, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (69, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (70, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (71, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (72, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (73, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (74, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (75, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (76, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (77, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (78, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (79, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (80, 14, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (81, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (82, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (83, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (84, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (85, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (86, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (87, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (88, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (89, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (90, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (91, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (92, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (93, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (94, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (95, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (96, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (97, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (98, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (99, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (100, 15, NULL, 3);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (101, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (102, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (103, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (104, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (105, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (106, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (107, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (108, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (109, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (110, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (111, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (112, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (113, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (114, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (115, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (116, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (117, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (118, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (119, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (120, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (121, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (122, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (123, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (124, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (125, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (126, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (127, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (128, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (129, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (130, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (131, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (132, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (133, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (134, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (135, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (136, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (137, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (138, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (139, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (140, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (141, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (142, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (143, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (144, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (145, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (146, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (147, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (148, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (149, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (150, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (151, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (152, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (153, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (154, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (155, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (156, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (157, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (158, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (159, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (160, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (161, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (162, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (163, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (164, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (165, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (166, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (167, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (168, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (169, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (170, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (171, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (172, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (173, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (174, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (175, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (176, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (177, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (178, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (179, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (180, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (181, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (182, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (183, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (184, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (185, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (186, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (187, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (188, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (189, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (190, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (191, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (192, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (193, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (194, 13, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (195, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (196, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (197, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (198, 12, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (199, 14, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (200, 11, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (201, 6, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (202, 6, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (203, 6, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (204, 6, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (205, 6, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (206, 7, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (207, 7, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (208, 7, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (209, 7, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (210, 7, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (211, 8, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (212, 8, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (213, 8, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (214, 8, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (215, 8, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (216, 9, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (217, 9, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (218, 9, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (219, 9, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (220, 9, NULL, 4);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (221, 11, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (222, 11, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (223, 11, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (224, 11, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (225, 11, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (226, 12, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (227, 12, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (228, 12, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (229, 12, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (230, 12, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (231, 10, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (232, 10, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (233, 10, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (234, 10, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (235, 10, NULL, 5);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (236, 13, NULL, 6);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (237, 13, NULL, 6);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (238, 13, NULL, 6);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (239, 13, NULL, 6);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (240, 13, NULL, 6);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (241, 14, NULL, 6);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (242, 14, NULL, 6);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (243, 14, NULL, 6);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (244, 14, NULL, 6);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (245, 14, NULL, 6);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (246, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (247, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (248, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (249, 15, NULL, 7);
INSERT INTO public.booking (id, person_id, discount_id, lesson_price_id) VALUES (250, 15, NULL, 7);


--
-- TOC entry 3855 (class 0 OID 16743)
-- Dependencies: 240
-- Data for Name: booking_ensemble; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (43, 101);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (74, 122);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (64, 125);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (46, 129);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (23, 199);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (34, 193);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (52, 181);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (24, 138);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (5, 170);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (4, 113);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (55, 154);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (95, 181);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (13, 188);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (33, 109);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (89, 174);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (71, 132);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (30, 155);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (68, 105);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (13, 175);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (55, 182);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (43, 185);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (28, 119);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (21, 129);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (10, 105);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (89, 108);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (57, 156);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (29, 184);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (96, 183);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (81, 170);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (89, 136);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (37, 156);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (62, 106);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (96, 138);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (102, 179);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (57, 112);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (99, 110);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (29, 142);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (99, 145);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (21, 101);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (21, 151);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (18, 180);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (99, 139);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (92, 113);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (13, 133);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (25, 146);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (53, 187);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (74, 146);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (83, 131);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (29, 107);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (85, 118);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (9, 166);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (72, 111);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (49, 160);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (17, 194);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (77, 170);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (14, 104);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (49, 155);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (3, 122);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (5, 191);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (58, 127);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (84, 171);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (87, 195);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (23, 151);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (87, 108);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (97, 138);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (3, 145);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (23, 149);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (35, 199);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (78, 165);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (39, 169);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (68, 106);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (3, 174);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (89, 192);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (26, 169);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (21, 178);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (91, 166);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (13, 170);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (101, 120);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (32, 190);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (50, 177);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (87, 144);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (30, 132);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (49, 198);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (101, 163);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (33, 113);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (85, 144);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (28, 140);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (80, 176);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (79, 137);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (77, 164);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (86, 199);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (15, 177);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (71, 200);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (58, 103);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (32, 131);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (27, 112);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (98, 185);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (71, 120);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (58, 139);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (4, 122);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (100, 127);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (8, 148);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (85, 159);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (32, 124);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (38, 107);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (42, 178);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (40, 165);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (58, 176);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (48, 161);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (30, 137);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (60, 173);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (86, 172);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (56, 160);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (42, 106);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (58, 198);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (21, 184);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (38, 110);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (11, 114);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (82, 181);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (90, 105);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (28, 153);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (99, 154);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (43, 130);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (52, 142);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (89, 116);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (61, 133);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (31, 136);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (44, 152);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (76, 168);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (15, 140);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (59, 101);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (37, 170);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (75, 148);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (45, 179);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (4, 162);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (47, 188);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (44, 151);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (91, 112);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (84, 144);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (20, 112);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (18, 120);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (74, 104);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (19, 108);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (64, 161);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (39, 132);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (20, 168);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (76, 144);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (51, 179);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (51, 175);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (53, 185);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (97, 113);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (20, 184);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (74, 159);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (85, 154);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (48, 168);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (68, 128);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (48, 164);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (75, 110);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (65, 161);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (12, 125);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (77, 121);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (55, 148);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (80, 165);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (96, 105);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (90, 119);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (18, 148);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (82, 172);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (83, 162);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (82, 197);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (43, 135);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (101, 115);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (27, 154);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (28, 145);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (89, 125);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (36, 180);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (5, 185);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (49, 177);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (59, 195);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (52, 173);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (70, 136);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (38, 112);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (39, 120);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (16, 182);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (68, 135);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (69, 153);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (19, 111);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (81, 175);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (88, 132);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (45, 150);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (94, 168);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (61, 192);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (96, 102);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (9, 179);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (47, 154);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (83, 127);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (23, 118);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (32, 182);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (62, 162);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (19, 186);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (96, 143);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (47, 170);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (98, 137);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (55, 198);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (5, 181);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (56, 107);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (64, 172);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (4, 166);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (33, 117);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (18, 159);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (65, 192);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (38, 123);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (49, 157);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (50, 175);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (12, 158);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (98, 174);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (16, 179);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (83, 197);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (7, 178);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (35, 176);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (33, 112);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (70, 174);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (52, 115);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (72, 142);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (80, 196);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (36, 103);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (64, 114);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (31, 197);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (19, 158);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (43, 150);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (72, 130);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (42, 149);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (82, 125);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (3, 135);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (38, 151);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (96, 172);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (46, 186);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (40, 135);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (52, 113);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (47, 197);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (78, 117);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (37, 157);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (62, 145);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (38, 137);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (86, 173);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (100, 187);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (89, 122);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (47, 148);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (30, 198);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (73, 130);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (80, 124);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (28, 123);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (81, 182);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (64, 119);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (63, 116);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (29, 173);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (52, 141);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (41, 157);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (4, 164);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (41, 115);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (49, 174);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (57, 113);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (28, 191);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (3, 127);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (46, 146);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (55, 115);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (24, 173);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (61, 198);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (72, 160);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (7, 199);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (90, 126);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (83, 194);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (89, 147);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (60, 141);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (10, 106);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (41, 135);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (36, 139);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (95, 152);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (25, 132);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (44, 200);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (60, 120);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (89, 171);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (99, 180);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (42, 182);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (8, 113);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (88, 144);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (35, 165);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (32, 118);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (62, 194);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (47, 138);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (50, 127);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (41, 161);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (76, 133);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (19, 194);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (92, 131);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (32, 183);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (58, 133);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (46, 190);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (75, 108);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (3, 192);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (22, 146);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (15, 108);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (80, 171);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (95, 183);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (70, 178);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (66, 104);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (24, 149);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (6, 155);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (69, 184);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (52, 102);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (85, 163);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (36, 165);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (38, 125);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (58, 113);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (70, 133);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (45, 172);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (42, 105);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (89, 140);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (6, 144);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (41, 175);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (83, 107);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (70, 118);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (20, 170);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (88, 179);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (48, 163);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (99, 194);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (37, 183);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (63, 144);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (28, 129);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (93, 157);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (82, 112);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (56, 105);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (18, 130);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (2, 109);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (14, 159);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (7, 150);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (93, 179);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (99, 125);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (52, 167);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (55, 158);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (40, 124);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (51, 171);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (7, 119);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (55, 191);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (71, 105);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (31, 166);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (28, 152);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (47, 184);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (41, 144);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (54, 176);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (70, 148);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (63, 183);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (101, 140);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (16, 128);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (65, 128);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (67, 180);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (99, 192);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (11, 162);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (24, 169);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (66, 117);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (65, 153);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (82, 133);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (18, 196);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (73, 126);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (18, 123);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (79, 125);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (59, 121);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (20, 196);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (38, 132);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (96, 176);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (4, 194);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (11, 148);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (92, 111);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (26, 199);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (43, 145);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (95, 189);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (73, 181);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (60, 103);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (81, 114);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (91, 121);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (29, 172);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (8, 196);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (32, 150);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (3, 169);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (75, 139);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (36, 194);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (97, 139);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (62, 183);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (82, 117);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (36, 188);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (21, 141);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (50, 182);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (18, 195);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (100, 182);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (62, 155);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (55, 109);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (7, 139);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (85, 112);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (56, 133);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (84, 138);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (63, 155);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (30, 122);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (97, 158);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (43, 183);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (83, 178);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (30, 130);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (25, 137);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (101, 142);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (11, 182);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (74, 145);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (10, 154);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (88, 158);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (100, 108);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (100, 194);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (93, 118);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (6, 142);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (64, 121);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (41, 186);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (53, 117);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (98, 155);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (98, 176);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (67, 197);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (49, 194);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (38, 130);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (40, 141);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (5, 159);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (100, 148);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (40, 112);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (31, 179);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (18, 133);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (27, 165);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (45, 129);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (5, 147);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (91, 152);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (90, 124);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (56, 159);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (49, 149);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (64, 133);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (9, 192);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (17, 183);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (83, 102);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (4, 186);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (18, 173);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (64, 162);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (22, 143);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (6, 119);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (94, 111);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (28, 144);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (26, 196);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (20, 118);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (29, 123);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (56, 167);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (26, 198);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (100, 181);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (44, 147);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (78, 135);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (82, 139);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (25, 119);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (35, 124);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (78, 114);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (94, 110);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (20, 150);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (53, 107);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (80, 114);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (83, 112);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (93, 180);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (73, 160);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (50, 134);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (48, 136);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (41, 121);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (29, 103);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (17, 102);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (27, 167);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (73, 164);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (90, 168);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (82, 156);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (96, 130);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (26, 186);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (50, 167);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (82, 199);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (59, 167);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (6, 148);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (78, 142);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (8, 112);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (94, 200);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (50, 143);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (38, 147);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (72, 154);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (92, 117);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (51, 195);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (85, 166);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (40, 147);
INSERT INTO public.booking_ensemble (ensemble_id, booking_id) VALUES (91, 183);


--
-- TOC entry 3856 (class 0 OID 16758)
-- Dependencies: 241
-- Data for Name: booking_group_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 3);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 3);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 32);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 159);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 230);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 155);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 255);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 245);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 51);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 11);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 64);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 127);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 238);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 158);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 201);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 152);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 209);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 129);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 100);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 105);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 72);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 69);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 2);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 5);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 8);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 250);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 22);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 239);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 78);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 266);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 150);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 71);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 102);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 234);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 168);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 181);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 25);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 221);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 153);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 54);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 193);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 264);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 198);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 137);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 185);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 119);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 104);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 2);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 5);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 8);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (212, 7);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 250);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 22);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 239);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (212, 78);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 266);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 150);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 71);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 102);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 88);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 234);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 168);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (212, 181);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 25);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 221);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 153);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 98);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 54);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (212, 193);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (212, 264);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 198);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 137);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 185);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 119);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 104);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 70);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 28);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 225);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 81);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 235);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 82);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 109);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 70);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 28);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 225);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 81);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 235);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 82);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 109);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 63);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 213);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 66);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 262);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 116);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 63);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 213);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 66);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 262);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 116);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 121);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 172);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 114);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 33);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 121);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 172);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 114);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 33);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 159);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 230);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 255);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 245);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 51);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 11);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 64);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 127);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 238);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 158);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 201);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 152);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 209);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 129);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 100);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 105);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 72);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 69);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 5);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 8);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 7);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 22);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 239);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 266);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 150);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 71);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 102);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 88);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 168);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 181);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 25);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 153);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 98);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 54);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 193);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 264);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 198);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 137);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 185);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 119);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 104);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 28);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 225);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 81);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 235);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 82);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 109);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 63);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 213);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 66);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 262);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 116);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 172);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 114);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (212, 33);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 159);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 230);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 255);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 245);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 51);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 11);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 64);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 127);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 238);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 158);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 201);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 152);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 209);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 129);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (212, 100);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 105);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 72);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 69);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 2);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 5);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 8);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 7);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 250);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 22);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 239);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 266);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 150);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 71);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (212, 102);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 88);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 234);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 168);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 181);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 25);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 221);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 153);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 98);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 54);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 193);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 264);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 185);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 104);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 70);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 28);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 225);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 81);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 235);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 82);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 109);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 63);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 213);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 262);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 116);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 121);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 172);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 33);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 159);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (212, 230);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 11);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 64);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 127);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 238);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 158);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 201);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 152);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 209);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 129);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 100);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 105);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (212, 72);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 69);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 2);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 5);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 7);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 22);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 239);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 78);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 150);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 71);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 102);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 168);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 181);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 25);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 221);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 153);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 98);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 54);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 193);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 264);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 198);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 137);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 185);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 119);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 104);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 70);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 28);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 225);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (212, 81);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 235);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 82);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 109);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 63);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 66);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 262);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 116);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 121);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 172);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 33);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 159);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 230);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 255);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 51);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 11);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 158);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 201);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 209);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 129);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 100);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 105);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 72);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 69);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 2);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 5);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 8);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 250);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 22);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 239);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 266);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 150);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 102);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 88);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 234);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 181);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (212, 25);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 221);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 98);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 54);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 193);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 198);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 137);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 104);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 70);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 28);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 81);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 235);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 82);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 109);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 213);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 66);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 116);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 121);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 33);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 230);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 255);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 245);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 51);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 64);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 127);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 238);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 158);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 201);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 152);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 209);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 129);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 100);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 105);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 69);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 2);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 5);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 7);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 250);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 22);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 78);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 266);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 150);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 71);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 102);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 88);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 234);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 168);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 181);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 25);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 221);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 98);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 54);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (218, 193);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 264);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 198);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 137);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (208, 185);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 119);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (202, 70);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 28);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 225);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 81);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 235);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (213, 82);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (214, 109);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 63);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (216, 213);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 66);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (211, 262);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (209, 116);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 121);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 172);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 114);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (203, 33);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 159);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (206, 230);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (207, 255);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (215, 245);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (217, 11);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 64);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 127);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (220, 158);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 201);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (201, 152);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (205, 209);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (219, 100);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (210, 105);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 72);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (204, 69);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 84);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 135);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 85);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 165);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 60);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 162);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 207);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 254);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 227);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 242);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 94);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 186);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 210);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 80);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 80);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 241);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 38);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 246);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 226);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 147);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 149);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 125);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 216);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 30);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 128);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 14);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 259);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 223);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 205);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 42);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 118);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 211);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 124);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 175);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 58);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 204);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 9);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 176);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 107);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 74);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 138);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 160);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 148);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 151);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 164);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 199);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 218);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 231);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 133);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 59);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 169);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 268);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 112);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 144);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 18);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 202);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 44);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 140);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 21);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 220);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 212);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 67);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 190);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 131);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 244);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 263);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 62);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 187);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 222);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 126);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 132);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 120);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 48);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 101);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 146);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 10);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 249);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 117);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 228);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 36);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 31);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 134);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 161);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 247);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 115);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 93);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 240);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 91);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 182);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 17);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 141);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 215);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 106);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 217);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 179);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 27);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 184);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 35);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 122);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 37);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 173);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 143);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 265);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 87);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 23);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 188);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 214);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 52);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 73);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 156);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 224);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 56);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 194);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 16);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 171);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 111);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 97);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 57);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 208);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 113);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 183);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 15);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 139);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 20);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 232);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 34);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 243);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 252);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 24);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 219);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 89);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 170);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 258);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 99);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 43);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 65);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 103);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 49);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 248);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 50);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 251);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 110);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 142);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 206);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 45);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 3);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 32);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 155);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 84);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 135);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 85);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 165);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 60);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 207);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 254);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 227);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 242);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 94);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 210);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 80);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 241);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 38);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 246);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 226);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 147);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 149);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 125);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 216);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 30);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 14);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 259);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 223);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 205);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 42);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 118);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 211);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 124);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 175);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 58);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 204);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 9);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 176);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 107);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 74);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 138);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 160);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 148);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 151);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 164);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 199);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 218);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 231);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 133);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 59);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 169);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 268);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 112);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 144);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 18);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 202);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 44);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 140);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 21);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 220);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 212);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 67);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 190);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 131);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 244);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 263);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 62);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 187);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 126);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 132);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 48);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 101);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 146);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 10);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 117);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 228);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 36);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 31);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 134);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 161);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 247);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 115);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 93);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 240);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 91);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 182);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 17);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 141);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 215);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 217);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 179);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 27);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 184);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 35);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 122);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 37);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 173);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 143);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 265);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 87);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 23);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 188);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 214);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 52);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 73);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 156);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 224);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 56);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 194);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 16);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 171);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 111);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 97);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 57);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 208);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 113);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 183);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 15);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 139);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 20);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 232);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 243);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 252);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 24);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 219);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 89);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 170);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 258);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 99);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 43);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 65);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 103);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 49);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 248);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 50);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 251);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 110);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 142);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 206);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 45);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 3);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 32);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 155);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 84);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 135);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 85);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 165);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 60);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 162);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 207);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 254);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 227);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 242);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 94);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 186);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 210);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 80);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 38);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 246);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 226);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 147);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 149);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 125);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 216);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 128);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 14);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 259);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 223);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 205);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 211);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 124);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 175);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 204);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 9);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 176);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 107);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 74);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 138);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 148);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 151);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 164);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 199);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 218);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 231);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 133);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 59);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 169);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 268);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 112);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 144);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 18);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 202);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 44);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 140);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 21);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 220);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 212);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 67);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 244);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 263);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 62);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 187);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 222);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 132);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 120);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 48);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 101);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 146);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 10);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 249);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 228);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 36);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 134);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 161);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 247);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 115);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 93);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 240);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 91);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 182);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 17);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 141);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 106);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 217);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 179);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 27);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 184);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 35);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 37);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 173);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 143);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 265);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 87);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 23);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 188);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 214);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 52);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 73);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 156);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 224);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 56);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 194);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 16);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 171);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 111);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 97);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 208);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 113);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 15);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 139);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 20);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 232);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 34);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 243);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 252);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 24);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 219);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 89);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 170);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 99);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 43);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 103);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 49);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 50);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 251);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 110);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 142);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 206);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 45);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 3);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 3);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 32);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 84);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 135);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 85);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 165);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 60);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 162);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 207);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 227);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 242);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 94);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 186);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 210);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 80);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 80);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 241);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 38);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 246);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 226);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 147);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 149);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 125);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 216);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 30);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 128);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 14);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 259);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 205);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 42);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 118);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 211);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 204);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 9);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 176);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 107);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 74);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 138);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 160);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 148);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 151);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 164);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 199);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 231);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 133);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 59);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 169);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 268);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 112);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 144);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 18);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 202);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 140);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 220);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 212);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 190);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 131);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 244);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 263);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 62);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 187);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 222);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 126);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 132);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 120);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 101);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 10);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 249);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 117);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 228);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 36);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 31);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 134);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 161);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (230, 247);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 115);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 93);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 240);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 91);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 182);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 17);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 215);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 106);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 217);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 179);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 184);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 35);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 122);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 143);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (229, 265);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 23);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 214);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 52);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 73);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (226, 156);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 224);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 194);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (225, 16);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 97);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 57);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 208);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 113);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 183);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 15);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 20);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 232);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (227, 34);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 243);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 252);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 24);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 219);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 170);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 258);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (234, 99);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (228, 43);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (222, 65);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (221, 103);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (224, 49);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (231, 248);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (235, 50);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 251);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (232, 110);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (233, 142);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (223, 45);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 6);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 55);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (239, 136);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (244, 123);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 189);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (242, 237);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 203);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 13);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (236, 96);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (243, 177);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (249, 191);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (249, 233);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (236, 163);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (243, 197);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (243, 157);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (236, 200);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (248, 145);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (239, 192);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (240, 46);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (239, 154);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (243, 257);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 236);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (243, 260);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 267);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (248, 75);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (237, 83);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 19);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (248, 178);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 53);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (236, 29);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (237, 196);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (245, 229);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (249, 253);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 166);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 180);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (245, 79);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (236, 167);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 86);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (236, 77);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 26);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (240, 39);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (237, 174);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (236, 41);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (242, 40);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 256);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (240, 68);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (239, 130);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 92);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 95);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 76);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (249, 195);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 12);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 90);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (239, 61);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (245, 6);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (236, 55);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (240, 136);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 123);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (245, 189);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 237);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (242, 203);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (249, 13);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 96);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 177);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (242, 191);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (242, 233);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (240, 163);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (248, 197);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 157);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 200);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (239, 145);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (237, 192);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (242, 46);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (237, 154);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (237, 257);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (245, 236);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 260);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (237, 75);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 83);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 19);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 53);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (240, 29);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 196);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (242, 229);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 253);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (245, 166);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (243, 180);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 79);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 167);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 86);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 77);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (242, 26);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (248, 39);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 174);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 41);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (243, 40);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (240, 256);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 68);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 130);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 92);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 95);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (249, 76);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (245, 195);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 12);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (244, 90);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 61);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 6);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (239, 55);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (243, 136);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (237, 123);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (248, 189);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (236, 237);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 203);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 13);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (243, 96);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 177);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (240, 191);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 233);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 163);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 197);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (244, 157);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 200);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (245, 145);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (244, 192);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (249, 46);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 154);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 260);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (244, 267);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (244, 75);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (249, 83);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (237, 178);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (239, 53);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (245, 29);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 229);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (245, 253);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 166);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 180);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (249, 79);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (242, 167);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (244, 86);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (240, 77);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (249, 26);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (245, 39);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 41);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 256);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 68);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (237, 130);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (240, 92);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (242, 95);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 195);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (240, 12);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (249, 55);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (237, 136);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 123);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 203);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (236, 13);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 177);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 191);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 157);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (238, 192);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 46);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (248, 154);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 257);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (249, 236);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (236, 260);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 267);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (242, 75);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 19);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (243, 29);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (244, 196);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 229);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 253);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (248, 166);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 180);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 79);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 167);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (240, 86);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (239, 77);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 39);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (241, 174);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (247, 41);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (249, 40);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (237, 256);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (244, 68);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (244, 130);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (248, 92);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (237, 95);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (250, 76);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (245, 12);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (246, 90);
INSERT INTO public.booking_group_lesson (booking_id, group_lesson_id) VALUES (248, 61);


--
-- TOC entry 3845 (class 0 OID 16615)
-- Dependencies: 230
-- Data for Name: contact_person; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.contact_person (person_id, name, phone_number) VALUES (6, 'Kevyn Mejia', '0734249422');
INSERT INTO public.contact_person (person_id, name, phone_number) VALUES (7, 'Hilary Vargas', '0738779216');
INSERT INTO public.contact_person (person_id, name, phone_number) VALUES (8, 'Demetrius Mosley', '0735927237');
INSERT INTO public.contact_person (person_id, name, phone_number) VALUES (9, 'Kessie James', '0738550235');
INSERT INTO public.contact_person (person_id, name, phone_number) VALUES (10, 'Aretha Mcfadden', '0736336723');
INSERT INTO public.contact_person (person_id, name, phone_number) VALUES (11, 'Evangeline Chang', '0731385378');
INSERT INTO public.contact_person (person_id, name, phone_number) VALUES (12, 'Evangeline Price', '0732834894');
INSERT INTO public.contact_person (person_id, name, phone_number) VALUES (13, 'Josiah Fletcher', '0732553612');
INSERT INTO public.contact_person (person_id, name, phone_number) VALUES (14, 'Brynne Mccray', '0735954116');
INSERT INTO public.contact_person (person_id, name, phone_number) VALUES (15, 'Bruce Willis', '0731231337');


--
-- TOC entry 3830 (class 0 OID 16518)
-- Dependencies: 215
-- Data for Name: discount; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.discount (id, percentage) VALUES (1, 20);


--
-- TOC entry 3832 (class 0 OID 16525)
-- Dependencies: 217
-- Data for Name: email; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.email (id, email_address) VALUES (1, 'sed.auctor.odio@icloud.net');
INSERT INTO public.email (id, email_address) VALUES (2, 'sem.egestas.blandit@hotmail.net');
INSERT INTO public.email (id, email_address) VALUES (3, 'elementum@google.org');
INSERT INTO public.email (id, email_address) VALUES (4, 'donec@aol.com');
INSERT INTO public.email (id, email_address) VALUES (5, 'ac@yahoo.com');
INSERT INTO public.email (id, email_address) VALUES (6, 'ornare@yahoo.couk');
INSERT INTO public.email (id, email_address) VALUES (7, 'cras.eget@hotmail.ca');
INSERT INTO public.email (id, email_address) VALUES (8, 'quisque@yahoo.edu');
INSERT INTO public.email (id, email_address) VALUES (9, 'vitae.dolor@aol.net');
INSERT INTO public.email (id, email_address) VALUES (10, 'dui.cum@icloud.edu');
INSERT INTO public.email (id, email_address) VALUES (11, 'commodo.ipsum@aol.edu');
INSERT INTO public.email (id, email_address) VALUES (12, 'aliquam.eu.accumsan@hotmail.edu');
INSERT INTO public.email (id, email_address) VALUES (13, 'felis.ullamcorper@aol.com');
INSERT INTO public.email (id, email_address) VALUES (14, 'sed@google.net');
INSERT INTO public.email (id, email_address) VALUES (15, 'quis.diam@hotmail.org');


--
-- TOC entry 3852 (class 0 OID 16705)
-- Dependencies: 237
-- Data for Name: ensemble; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (1, 3, 6, 'Rock', 16);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (2, 3, 6, 'Jazz', 20);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (3, 4, 8, 'Jazz', 160);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (4, 4, 8, 'Jazz', 165);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (5, 4, 8, 'Jazz', 170);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (6, 4, 8, 'Jazz', 175);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (7, 4, 8, 'Jazz', 180);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (8, 4, 8, 'Classic', 185);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (9, 4, 8, 'Rock', 190);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (10, 4, 8, 'Classic', 195);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (11, 4, 8, 'Rock', 200);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (12, 4, 8, 'Jazz', 205);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (13, 4, 8, 'Classic', 210);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (14, 4, 8, 'Jazz', 215);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (15, 4, 8, 'Jazz', 220);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (16, 4, 8, 'Jazz', 225);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (17, 4, 8, 'Classic', 230);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (18, 4, 8, 'Classic', 235);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (19, 4, 8, 'Jazz', 240);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (20, 4, 8, 'Classic', 245);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (21, 4, 8, 'Rock', 250);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (22, 4, 8, 'Classic', 255);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (23, 4, 8, 'Classic', 260);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (24, 4, 8, 'Jazz', 265);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (25, 4, 8, 'Jazz', 270);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (26, 4, 8, 'Jazz', 275);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (27, 4, 8, 'Jazz', 280);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (28, 4, 8, 'Jazz', 285);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (29, 4, 8, 'Classic', 290);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (30, 4, 8, 'Rock', 295);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (31, 4, 8, 'Jazz', 300);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (32, 4, 8, 'Rock', 305);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (33, 4, 8, 'Jazz', 310);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (34, 4, 8, 'Jazz', 315);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (35, 4, 8, 'Classic', 320);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (36, 4, 8, 'Jazz', 325);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (37, 4, 8, 'Jazz', 330);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (38, 4, 8, 'Rock', 335);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (39, 4, 8, 'Jazz', 340);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (40, 4, 8, 'Rock', 345);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (41, 4, 8, 'Rock', 350);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (42, 4, 8, 'Jazz', 355);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (43, 4, 8, 'Jazz', 360);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (44, 4, 8, 'Rock', 365);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (45, 4, 8, 'Classic', 370);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (46, 4, 8, 'Jazz', 375);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (47, 4, 8, 'Rock', 380);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (48, 4, 8, 'Jazz', 385);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (49, 4, 8, 'Jazz', 390);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (50, 4, 8, 'Jazz', 395);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (51, 4, 8, 'Jazz', 400);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (52, 4, 8, 'Jazz', 405);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (53, 4, 8, 'Rock', 161);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (54, 4, 8, 'Jazz', 166);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (55, 4, 8, 'Jazz', 171);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (56, 4, 8, 'Rock', 176);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (57, 4, 8, 'Jazz', 181);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (58, 4, 8, 'Classic', 186);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (59, 4, 8, 'Rock', 191);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (60, 4, 8, 'Jazz', 196);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (61, 4, 8, 'Jazz', 201);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (62, 4, 8, 'Jazz', 206);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (63, 4, 8, 'Classic', 211);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (64, 4, 8, 'Jazz', 216);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (65, 4, 8, 'Classic', 221);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (66, 4, 8, 'Rock', 226);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (67, 4, 8, 'Jazz', 231);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (68, 4, 8, 'Jazz', 236);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (69, 4, 8, 'Jazz', 241);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (70, 4, 8, 'Classic', 246);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (71, 4, 8, 'Jazz', 251);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (72, 4, 8, 'Jazz', 256);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (73, 4, 8, 'Jazz', 261);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (74, 4, 8, 'Jazz', 266);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (75, 4, 8, 'Jazz', 271);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (76, 4, 8, 'Jazz', 276);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (77, 4, 8, 'Classic', 281);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (78, 4, 8, 'Jazz', 286);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (79, 4, 8, 'Jazz', 291);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (80, 4, 8, 'Jazz', 296);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (81, 4, 8, 'Jazz', 301);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (82, 4, 8, 'Classic', 306);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (83, 4, 8, 'Jazz', 311);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (84, 4, 8, 'Jazz', 316);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (85, 4, 8, 'Jazz', 321);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (86, 4, 8, 'Jazz', 326);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (87, 4, 8, 'Jazz', 331);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (88, 4, 8, 'Jazz', 336);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (89, 4, 8, 'Jazz', 341);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (90, 4, 8, 'Jazz', 346);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (91, 4, 8, 'Rock', 351);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (92, 4, 8, 'Jazz', 356);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (93, 4, 8, 'Jazz', 361);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (94, 4, 8, 'Rock', 366);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (95, 4, 8, 'Classic', 371);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (96, 4, 8, 'Jazz', 376);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (97, 4, 8, 'Jazz', 381);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (98, 4, 8, 'Jazz', 386);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (99, 4, 8, 'Classic', 391);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (100, 4, 8, 'Classic', 396);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (101, 4, 8, 'Jazz', 401);
INSERT INTO public.ensemble (id, min_students, max_students, genre, time_slot_id) VALUES (102, 4, 8, 'Jazz', 406);


--
-- TOC entry 3854 (class 0 OID 16717)
-- Dependencies: 239
-- Data for Name: group_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (3, 3, 6, 'Guitar', 'Intermediate', 12);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (5, 3, 6, 'Piano', 'Beginner', 4);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (2, 3, 6, 'Guitar', 'Beginner', 1);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (6, 4, 8, 'Flute', 'Advanced', 2);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (7, 4, 8, 'Guitar', 'Beginner', 22);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (8, 4, 8, 'Saxophone', 'Beginner', 18);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (9, 4, 8, 'Guitar', 'Intermediate', 39);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (10, 4, 8, 'Guitar', 'Intermediate', 44);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (11, 4, 8, 'Guitar', 'Beginner', 49);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (12, 4, 8, 'Piano', 'Advanced', 54);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (13, 4, 8, 'Piano', 'Advanced', 59);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (14, 4, 8, 'Guitar', 'Intermediate', 64);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (15, 4, 8, 'Piano', 'Intermediate', 69);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (16, 4, 8, 'Guitar', 'Intermediate', 74);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (17, 4, 8, 'Piano', 'Intermediate', 79);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (18, 4, 8, 'Guitar', 'Intermediate', 84);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (19, 4, 8, 'Piano', 'Advanced', 89);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (20, 4, 8, 'Guitar', 'Intermediate', 94);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (21, 4, 8, 'Piano', 'Intermediate', 99);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (22, 4, 8, 'Piano', 'Beginner', 104);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (23, 4, 8, 'Guitar', 'Intermediate', 109);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (24, 4, 8, 'Piano', 'Intermediate', 114);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (25, 4, 8, 'Guitar', 'Beginner', 119);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (26, 4, 8, 'Piano', 'Advanced', 124);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (27, 4, 8, 'Guitar', 'Intermediate', 129);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (28, 4, 8, 'Guitar', 'Beginner', 134);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (29, 4, 8, 'Guitar', 'Advanced', 139);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (30, 4, 8, 'Guitar', 'Intermediate', 144);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (31, 4, 8, 'Piano', 'Intermediate', 149);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (32, 4, 8, 'Guitar', 'Intermediate', 154);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (33, 4, 8, 'Piano', 'Beginner', 159);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (34, 4, 8, 'Guitar', 'Intermediate', 164);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (35, 4, 8, 'Guitar', 'Intermediate', 169);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (36, 4, 8, 'Piano', 'Intermediate', 174);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (37, 4, 8, 'Guitar', 'Intermediate', 179);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (38, 4, 8, 'Guitar', 'Intermediate', 184);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (39, 4, 8, 'Guitar', 'Advanced', 189);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (40, 4, 8, 'Guitar', 'Advanced', 194);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (41, 4, 8, 'Piano', 'Advanced', 199);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (42, 4, 8, 'Piano', 'Intermediate', 204);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (43, 4, 8, 'Piano', 'Intermediate', 209);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (44, 4, 8, 'Guitar', 'Intermediate', 214);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (45, 4, 8, 'Piano', 'Intermediate', 219);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (46, 4, 8, 'Guitar', 'Advanced', 224);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (48, 4, 8, 'Piano', 'Intermediate', 234);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (49, 4, 8, 'Piano', 'Intermediate', 239);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (50, 4, 8, 'Piano', 'Intermediate', 244);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (51, 4, 8, 'Guitar', 'Beginner', 249);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (52, 4, 8, 'Guitar', 'Intermediate', 254);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (53, 4, 8, 'Guitar', 'Advanced', 259);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (54, 4, 8, 'Piano', 'Beginner', 264);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (55, 4, 8, 'Piano', 'Advanced', 269);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (56, 4, 8, 'Guitar', 'Intermediate', 274);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (57, 4, 8, 'Guitar', 'Intermediate', 279);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (58, 4, 8, 'Piano', 'Intermediate', 284);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (59, 4, 8, 'Flute', 'Intermediate', 38);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (60, 4, 8, 'Saxophone', 'Intermediate', 43);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (61, 4, 8, 'Flute', 'Advanced', 48);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (62, 4, 8, 'Flute', 'Intermediate', 53);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (63, 4, 8, 'Saxophone', 'Beginner', 58);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (64, 4, 8, 'Flute', 'Beginner', 63);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (65, 4, 8, 'Flute', 'Intermediate', 68);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (66, 4, 8, 'Saxophone', 'Beginner', 73);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (67, 4, 8, 'Saxophone', 'Intermediate', 78);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (68, 4, 8, 'Saxophone', 'Advanced', 83);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (69, 4, 8, 'Saxophone', 'Beginner', 88);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (70, 4, 8, 'Piano', 'Beginner', 93);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (71, 4, 8, 'Flute', 'Beginner', 98);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (72, 4, 8, 'Piano', 'Beginner', 103);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (73, 4, 8, 'Piano', 'Intermediate', 108);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (74, 4, 8, 'Piano', 'Intermediate', 113);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (75, 4, 8, 'Flute', 'Advanced', 118);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (76, 4, 8, 'Flute', 'Advanced', 123);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (77, 4, 8, 'Piano', 'Advanced', 128);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (78, 4, 8, 'Piano', 'Beginner', 133);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (79, 4, 8, 'Piano', 'Advanced', 138);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (80, 4, 8, 'Piano', 'Intermediate', 143);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (81, 4, 8, 'Flute', 'Beginner', 148);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (82, 4, 8, 'Saxophone', 'Beginner', 153);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (83, 4, 8, 'Flute', 'Advanced', 158);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (84, 4, 8, 'Piano', 'Intermediate', 163);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (85, 4, 8, 'Flute', 'Intermediate', 168);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (86, 4, 8, 'Flute', 'Advanced', 173);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (87, 4, 8, 'Piano', 'Intermediate', 178);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (88, 4, 8, 'Piano', 'Beginner', 183);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (89, 4, 8, 'Piano', 'Intermediate', 188);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (90, 4, 8, 'Flute', 'Advanced', 193);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (91, 4, 8, 'Piano', 'Intermediate', 198);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (92, 4, 8, 'Flute', 'Advanced', 203);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (93, 4, 8, 'Saxophone', 'Intermediate', 208);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (94, 4, 8, 'Flute', 'Intermediate', 213);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (95, 4, 8, 'Piano', 'Advanced', 218);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (96, 4, 8, 'Flute', 'Advanced', 223);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (97, 4, 8, 'Piano', 'Intermediate', 228);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (98, 4, 8, 'Flute', 'Beginner', 233);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (99, 4, 8, 'Saxophone', 'Intermediate', 238);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (100, 4, 8, 'Saxophone', 'Beginner', 243);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (101, 4, 8, 'Saxophone', 'Intermediate', 248);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (102, 4, 8, 'Saxophone', 'Beginner', 253);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (103, 4, 8, 'Piano', 'Intermediate', 258);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (104, 4, 8, 'Piano', 'Beginner', 263);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (105, 4, 8, 'Piano', 'Beginner', 268);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (106, 4, 8, 'Piano', 'Intermediate', 273);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (107, 4, 8, 'Saxophone', 'Intermediate', 278);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (109, 4, 8, 'Piano', 'Beginner', 288);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (110, 4, 8, 'Flute', 'Intermediate', 293);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (111, 4, 8, 'Flute', 'Intermediate', 298);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (112, 4, 8, 'Saxophone', 'Intermediate', 303);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (113, 4, 8, 'Piano', 'Intermediate', 308);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (114, 4, 8, 'Flute', 'Beginner', 313);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (115, 4, 8, 'Flute', 'Intermediate', 318);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (116, 4, 8, 'Flute', 'Beginner', 323);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (117, 4, 8, 'Piano', 'Intermediate', 328);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (118, 4, 8, 'Flute', 'Intermediate', 333);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (119, 4, 8, 'Flute', 'Beginner', 338);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (120, 4, 8, 'Saxophone', 'Intermediate', 343);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (121, 4, 8, 'Saxophone', 'Beginner', 348);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (122, 4, 8, 'Flute', 'Intermediate', 353);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (123, 4, 8, 'Piano', 'Advanced', 358);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (124, 4, 8, 'Saxophone', 'Intermediate', 363);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (125, 4, 8, 'Piano', 'Intermediate', 368);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (126, 4, 8, 'Piano', 'Intermediate', 373);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (127, 4, 8, 'Piano', 'Beginner', 378);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (128, 4, 8, 'Piano', 'Intermediate', 383);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (129, 4, 8, 'Saxophone', 'Beginner', 388);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (130, 4, 8, 'Piano', 'Advanced', 393);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (131, 4, 8, 'Piano', 'Intermediate', 398);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (132, 4, 8, 'Saxophone', 'Intermediate', 403);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (133, 4, 8, 'Piano', 'Intermediate', 408);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (134, 4, 8, 'Piano', 'Intermediate', 413);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (135, 4, 8, 'Piano', 'Intermediate', 418);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (136, 4, 8, 'Flute', 'Advanced', 423);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (137, 4, 8, 'Piano', 'Beginner', 428);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (138, 4, 8, 'Piano', 'Intermediate', 433);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (139, 4, 8, 'Drums', 'Intermediate', 37);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (140, 4, 8, 'Guitar', 'Intermediate', 42);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (141, 4, 8, 'Guitar', 'Intermediate', 47);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (142, 4, 8, 'Saxophone', 'Intermediate', 52);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (143, 4, 8, 'Guitar', 'Intermediate', 57);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (144, 4, 8, 'Saxophone', 'Intermediate', 62);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (145, 4, 8, 'Drums', 'Advanced', 67);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (146, 4, 8, 'Drums', 'Intermediate', 72);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (147, 4, 8, 'Guitar', 'Intermediate', 77);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (148, 4, 8, 'Saxophone', 'Intermediate', 82);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (149, 4, 8, 'Guitar', 'Intermediate', 87);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (150, 4, 8, 'Drums', 'Beginner', 92);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (151, 4, 8, 'Drums', 'Intermediate', 97);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (152, 4, 8, 'Saxophone', 'Beginner', 102);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (153, 4, 8, 'Drums', 'Beginner', 107);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (154, 4, 8, 'Drums', 'Advanced', 112);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (155, 4, 8, 'Drums', 'Intermediate', 117);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (156, 4, 8, 'Saxophone', 'Intermediate', 122);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (157, 4, 8, 'Saxophone', 'Advanced', 127);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (158, 4, 8, 'Drums', 'Beginner', 132);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (159, 4, 8, 'Drums', 'Beginner', 137);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (160, 4, 8, 'Saxophone', 'Intermediate', 142);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (161, 4, 8, 'Drums', 'Intermediate', 147);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (162, 4, 8, 'Drums', 'Intermediate', 152);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (163, 4, 8, 'Drums', 'Advanced', 157);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (164, 4, 8, 'Drums', 'Intermediate', 162);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (165, 4, 8, 'Drums', 'Intermediate', 167);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (166, 4, 8, 'Drums', 'Advanced', 172);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (167, 4, 8, 'Saxophone', 'Advanced', 177);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (168, 4, 8, 'Drums', 'Beginner', 182);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (169, 4, 8, 'Saxophone', 'Intermediate', 187);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (170, 4, 8, 'Saxophone', 'Intermediate', 192);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (171, 4, 8, 'Guitar', 'Intermediate', 197);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (172, 4, 8, 'Drums', 'Beginner', 202);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (173, 4, 8, 'Saxophone', 'Intermediate', 207);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (174, 4, 8, 'Drums', 'Advanced', 212);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (175, 4, 8, 'Drums', 'Intermediate', 217);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (176, 4, 8, 'Saxophone', 'Intermediate', 222);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (177, 4, 8, 'Guitar', 'Advanced', 227);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (178, 4, 8, 'Guitar', 'Advanced', 232);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (179, 4, 8, 'Drums', 'Intermediate', 237);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (180, 4, 8, 'Drums', 'Advanced', 242);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (181, 4, 8, 'Drums', 'Beginner', 247);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (182, 4, 8, 'Drums', 'Intermediate', 252);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (183, 4, 8, 'Drums', 'Intermediate', 257);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (184, 4, 8, 'Drums', 'Intermediate', 262);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (185, 4, 8, 'Drums', 'Beginner', 267);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (186, 4, 8, 'Saxophone', 'Intermediate', 272);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (187, 4, 8, 'Saxophone', 'Intermediate', 277);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (188, 4, 8, 'Saxophone', 'Intermediate', 282);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (189, 4, 8, 'Drums', 'Advanced', 287);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (190, 4, 8, 'Drums', 'Intermediate', 292);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (191, 4, 8, 'Guitar', 'Advanced', 297);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (192, 4, 8, 'Saxophone', 'Advanced', 302);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (193, 4, 8, 'Guitar', 'Beginner', 307);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (194, 4, 8, 'Drums', 'Intermediate', 312);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (195, 4, 8, 'Drums', 'Advanced', 317);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (196, 4, 8, 'Guitar', 'Advanced', 322);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (197, 4, 8, 'Saxophone', 'Advanced', 327);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (198, 4, 8, 'Drums', 'Beginner', 332);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (199, 4, 8, 'Saxophone', 'Intermediate', 337);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (200, 4, 8, 'Guitar', 'Advanced', 342);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (201, 4, 8, 'Saxophone', 'Beginner', 347);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (202, 4, 8, 'Saxophone', 'Intermediate', 352);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (203, 4, 8, 'Drums', 'Advanced', 357);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (204, 4, 8, 'Guitar', 'Intermediate', 362);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (205, 4, 8, 'Saxophone', 'Intermediate', 367);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (206, 4, 8, 'Drums', 'Intermediate', 372);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (207, 4, 8, 'Saxophone', 'Intermediate', 377);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (208, 4, 8, 'Drums', 'Intermediate', 382);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (209, 4, 8, 'Saxophone', 'Beginner', 387);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (210, 4, 8, 'Guitar', 'Intermediate', 392);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (211, 4, 8, 'Saxophone', 'Intermediate', 397);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (212, 4, 8, 'Saxophone', 'Intermediate', 402);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (213, 4, 8, 'Drums', 'Beginner', 407);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (214, 4, 8, 'Saxophone', 'Intermediate', 412);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (215, 4, 8, 'Drums', 'Intermediate', 417);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (216, 4, 8, 'Drums', 'Intermediate', 422);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (217, 4, 8, 'Drums', 'Intermediate', 427);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (218, 4, 8, 'Drums', 'Intermediate', 432);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (219, 4, 8, 'Guitar', 'Intermediate', 36);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (220, 4, 8, 'Guitar', 'Intermediate', 41);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (221, 4, 8, 'Piano', 'Beginner', 46);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (222, 4, 8, 'Piano', 'Intermediate', 51);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (223, 4, 8, 'Guitar', 'Intermediate', 56);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (224, 4, 8, 'Guitar', 'Intermediate', 61);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (225, 4, 8, 'Guitar', 'Beginner', 66);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (226, 4, 8, 'Piano', 'Intermediate', 71);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (227, 4, 8, 'Piano', 'Intermediate', 76);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (228, 4, 8, 'Guitar', 'Intermediate', 81);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (229, 4, 8, 'Piano', 'Advanced', 86);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (230, 4, 8, 'Piano', 'Beginner', 91);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (231, 4, 8, 'Piano', 'Intermediate', 96);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (232, 4, 8, 'Guitar', 'Intermediate', 101);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (233, 4, 8, 'Guitar', 'Advanced', 106);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (234, 4, 8, 'Guitar', 'Beginner', 111);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (235, 4, 8, 'Guitar', 'Beginner', 116);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (236, 4, 8, 'Guitar', 'Advanced', 121);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (237, 4, 8, 'Guitar', 'Advanced', 126);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (238, 4, 8, 'Guitar', 'Beginner', 131);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (239, 4, 8, 'Guitar', 'Beginner', 136);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (240, 4, 8, 'Guitar', 'Intermediate', 141);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (241, 4, 8, 'Piano', 'Intermediate', 146);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (242, 4, 8, 'Piano', 'Intermediate', 151);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (243, 4, 8, 'Guitar', 'Intermediate', 156);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (244, 4, 8, 'Guitar', 'Intermediate', 35);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (245, 4, 8, 'Guitar', 'Beginner', 40);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (246, 4, 8, 'Drums', 'Intermediate', 45);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (247, 4, 8, 'Drums', 'Intermediate', 50);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (248, 4, 8, 'Drums', 'Intermediate', 55);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (249, 4, 8, 'Drums', 'Intermediate', 60);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (250, 4, 8, 'Drums', 'Beginner', 65);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (251, 4, 8, 'Guitar', 'Intermediate', 70);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (252, 4, 8, 'Drums', 'Intermediate', 75);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (253, 4, 8, 'Guitar', 'Advanced', 80);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (254, 4, 8, 'Drums', 'Intermediate', 85);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (255, 4, 8, 'Drums', 'Beginner', 90);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (256, 4, 8, 'Drums', 'Advanced', 95);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (257, 4, 8, 'Drums', 'Advanced', 100);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (258, 4, 8, 'Guitar', 'Intermediate', 105);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (259, 4, 8, 'Drums', 'Intermediate', 110);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (260, 4, 8, 'Guitar', 'Advanced', 115);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (262, 4, 8, 'Guitar', 'Beginner', 125);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (263, 4, 8, 'Guitar', 'Intermediate', 130);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (264, 4, 8, 'Drums', 'Beginner', 135);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (265, 4, 8, 'Guitar', 'Intermediate', 140);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (266, 4, 8, 'Guitar', 'Beginner', 145);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (267, 4, 8, 'Drums', 'Advanced', 150);
INSERT INTO public.group_lesson (id, min_students, max_students, instrument, skill_level, time_slot_id) VALUES (268, 4, 8, 'Drums', 'Intermediate', 155);


--
-- TOC entry 3862 (class 0 OID 16837)
-- Dependencies: 247
-- Data for Name: individual_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (1, 'Guitar', 'Intermediate', 410, 1);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (2, 'Guitar', 'Intermediate', 415, 2);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (3, 'Guitar', 'Intermediate', 420, 3);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (4, 'Guitar', 'Intermediate', 425, 4);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (5, 'Guitar', 'Intermediate', 430, 5);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (6, 'Guitar', 'Intermediate', 435, 6);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (7, 'Guitar', 'Intermediate', 440, 7);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (8, 'Guitar', 'Intermediate', 445, 8);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (9, 'Guitar', 'Intermediate', 450, 9);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (10, 'Guitar', 'Intermediate', 455, 10);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (11, 'Guitar', 'Intermediate', 460, 11);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (12, 'Guitar', 'Intermediate', 465, 12);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (13, 'Guitar', 'Intermediate', 470, 13);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (14, 'Guitar', 'Intermediate', 475, 14);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (15, 'Guitar', 'Intermediate', 480, 15);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (16, 'Guitar', 'Intermediate', 485, 16);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (17, 'Guitar', 'Intermediate', 490, 17);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (18, 'Guitar', 'Intermediate', 495, 18);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (19, 'Guitar', 'Intermediate', 500, 19);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (20, 'Guitar', 'Intermediate', 505, 20);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (21, 'Piano', 'Intermediate', 411, 21);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (22, 'Piano', 'Intermediate', 416, 22);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (23, 'Piano', 'Intermediate', 421, 23);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (24, 'Piano', 'Intermediate', 426, 24);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (25, 'Piano', 'Intermediate', 431, 25);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (26, 'Piano', 'Intermediate', 436, 26);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (27, 'Piano', 'Intermediate', 441, 27);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (28, 'Piano', 'Intermediate', 446, 28);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (29, 'Piano', 'Intermediate', 451, 29);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (30, 'Piano', 'Intermediate', 456, 30);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (31, 'Piano', 'Intermediate', 461, 31);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (32, 'Piano', 'Intermediate', 466, 32);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (33, 'Piano', 'Intermediate', 471, 33);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (34, 'Piano', 'Intermediate', 476, 34);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (35, 'Piano', 'Intermediate', 481, 35);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (36, 'Piano', 'Intermediate', 486, 36);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (37, 'Piano', 'Intermediate', 491, 37);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (38, 'Piano', 'Intermediate', 496, 38);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (39, 'Piano', 'Intermediate', 501, 39);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (40, 'Piano', 'Intermediate', 506, 40);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (41, 'Saxophone', 'Advanced', 437, 41);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (42, 'Saxophone', 'Advanced', 442, 42);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (43, 'Saxophone', 'Advanced', 447, 43);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (44, 'Saxophone', 'Advanced', 452, 44);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (45, 'Saxophone', 'Advanced', 457, 45);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (46, 'Saxophone', 'Advanced', 462, 46);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (47, 'Saxophone', 'Advanced', 467, 47);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (48, 'Saxophone', 'Advanced', 472, 48);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (49, 'Saxophone', 'Advanced', 477, 49);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (50, 'Saxophone', 'Advanced', 482, 50);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (51, 'Saxophone', 'Advanced', 487, 51);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (52, 'Saxophone', 'Advanced', 492, 52);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (53, 'Saxophone', 'Advanced', 497, 53);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (54, 'Saxophone', 'Advanced', 502, 54);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (55, 'Saxophone', 'Advanced', 507, 55);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (56, 'Saxophone', 'Advanced', 512, 56);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (57, 'Saxophone', 'Advanced', 517, 57);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (58, 'Saxophone', 'Advanced', 522, 58);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (59, 'Saxophone', 'Advanced', 527, 59);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (60, 'Saxophone', 'Advanced', 532, 60);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (61, 'Flute', 'Advanced', 438, 61);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (62, 'Flute', 'Advanced', 443, 62);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (63, 'Flute', 'Advanced', 448, 63);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (64, 'Flute', 'Advanced', 453, 64);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (65, 'Flute', 'Advanced', 458, 65);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (66, 'Flute', 'Advanced', 463, 66);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (67, 'Flute', 'Advanced', 468, 67);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (68, 'Flute', 'Advanced', 473, 68);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (69, 'Flute', 'Advanced', 478, 69);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (70, 'Flute', 'Advanced', 483, 70);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (71, 'Flute', 'Advanced', 488, 71);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (72, 'Flute', 'Advanced', 493, 72);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (73, 'Flute', 'Advanced', 498, 73);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (74, 'Flute', 'Advanced', 503, 74);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (75, 'Flute', 'Advanced', 508, 75);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (76, 'Flute', 'Advanced', 513, 76);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (77, 'Flute', 'Advanced', 518, 77);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (78, 'Flute', 'Advanced', 523, 78);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (79, 'Flute', 'Advanced', 528, 79);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (80, 'Flute', 'Advanced', 533, 80);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (81, 'Guitar', 'Advanced', 289, 81);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (82, 'Guitar', 'Advanced', 294, 82);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (83, 'Guitar', 'Advanced', 299, 83);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (84, 'Guitar', 'Advanced', 304, 84);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (85, 'Guitar', 'Advanced', 309, 85);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (86, 'Guitar', 'Advanced', 314, 86);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (87, 'Guitar', 'Advanced', 319, 87);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (88, 'Guitar', 'Advanced', 324, 88);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (89, 'Guitar', 'Advanced', 329, 89);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (90, 'Guitar', 'Advanced', 334, 90);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (91, 'Guitar', 'Advanced', 339, 91);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (92, 'Guitar', 'Advanced', 344, 92);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (93, 'Guitar', 'Advanced', 349, 93);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (94, 'Guitar', 'Advanced', 354, 94);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (95, 'Guitar', 'Advanced', 359, 95);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (96, 'Guitar', 'Advanced', 364, 96);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (97, 'Guitar', 'Advanced', 369, 97);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (98, 'Guitar', 'Advanced', 374, 98);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (99, 'Guitar', 'Advanced', 379, 99);
INSERT INTO public.individual_lesson (id, instrument, skill_level, time_slot_id, booking_id) VALUES (100, 'Guitar', 'Advanced', 384, 100);


--
-- TOC entry 3846 (class 0 OID 16625)
-- Dependencies: 231
-- Data for Name: instructor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instructor (person_id, teaches_ensembles) VALUES (1, true);
INSERT INTO public.instructor (person_id, teaches_ensembles) VALUES (2, true);
INSERT INTO public.instructor (person_id, teaches_ensembles) VALUES (3, false);
INSERT INTO public.instructor (person_id, teaches_ensembles) VALUES (4, false);
INSERT INTO public.instructor (person_id, teaches_ensembles) VALUES (5, false);


--
-- TOC entry 3847 (class 0 OID 16635)
-- Dependencies: 232
-- Data for Name: instructor_teach_instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instructor_teach_instrument (person_id, teach_instrument_id) VALUES (1, 1);
INSERT INTO public.instructor_teach_instrument (person_id, teach_instrument_id) VALUES (1, 3);
INSERT INTO public.instructor_teach_instrument (person_id, teach_instrument_id) VALUES (2, 1);
INSERT INTO public.instructor_teach_instrument (person_id, teach_instrument_id) VALUES (2, 2);
INSERT INTO public.instructor_teach_instrument (person_id, teach_instrument_id) VALUES (3, 1);
INSERT INTO public.instructor_teach_instrument (person_id, teach_instrument_id) VALUES (3, 3);
INSERT INTO public.instructor_teach_instrument (person_id, teach_instrument_id) VALUES (3, 5);
INSERT INTO public.instructor_teach_instrument (person_id, teach_instrument_id) VALUES (4, 4);
INSERT INTO public.instructor_teach_instrument (person_id, teach_instrument_id) VALUES (4, 5);
INSERT INTO public.instructor_teach_instrument (person_id, teach_instrument_id) VALUES (4, 2);
INSERT INTO public.instructor_teach_instrument (person_id, teach_instrument_id) VALUES (5, 1);
INSERT INTO public.instructor_teach_instrument (person_id, teach_instrument_id) VALUES (5, 2);


--
-- TOC entry 3834 (class 0 OID 16532)
-- Dependencies: 219
-- Data for Name: lesson_price; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lesson_price (id, lesson_type, level, price) VALUES (1, 'individual', 'beginner', 300);
INSERT INTO public.lesson_price (id, lesson_type, level, price) VALUES (2, 'individual', 'intermediate', 400);
INSERT INTO public.lesson_price (id, lesson_type, level, price) VALUES (3, 'individual', 'advanced', 500);
INSERT INTO public.lesson_price (id, lesson_type, level, price) VALUES (4, 'group', 'beginner', 100);
INSERT INTO public.lesson_price (id, lesson_type, level, price) VALUES (5, 'group', 'intermediate', 200);
INSERT INTO public.lesson_price (id, lesson_type, level, price) VALUES (6, 'group', 'advanced', 300);
INSERT INTO public.lesson_price (id, lesson_type, level, price) VALUES (7, 'ensemble', 'all', 200);


--
-- TOC entry 3836 (class 0 OID 16539)
-- Dependencies: 221
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (1, 'Xaviera West', '621055072856', '819-3388 Nulla Avenue', '03112', 'Avesta');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (2, 'Clinton Hatfield', '235432407864', '723-7517 Phasellus Ave', '73275', 'Märsta');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (3, 'Howard Hobbs', '202753287869', '9332 Gravida Rd.', '39688', 'Ockelbo');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (4, 'Carter Poole', '715548441674', 'Ap #601-6034 Non, Road', '58227', 'Gävle');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (5, 'Remedios Barry', '682438873574', 'P.O. Box 826, 7829 Mi Ave', '66699', 'Ockelbo');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (6, 'Logan Mejia', '605847632153', '547-4686 Erat, Rd.', '56699', 'Borlänge');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (7, 'Bree Vargas', '983661899712', '881-1370 Cras Rd.', '37371', 'Ockelbo');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (8, 'Simone Mosley', '343273421477', '384-4497 Velit. Avenue', '08228', 'Avesta');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (9, 'Tanner James', '435738765674', 'Ap #945-5548 Pede. Av.', '86934', 'Söderhamn');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (10, 'Linda Mcfadden', '281338879192', '168-4792 Pharetra. Av.', '23603', 'Söderhamn');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (11, 'Aaron Chang', '650844527556', '7932 Etiam Avenue', '18505', 'Finspång');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (12, 'Bianca Price', '135726735212', 'P.O. Box 717, 6163 Nec Road', '22446', 'Motala');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (13, 'Ferris Fletcher', '452321522832', '767-3149 Viverra. St.', '41554', 'Alingsås');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (14, 'Daquan Mccray', '876082812882', '112-4840 Diam. Avenue', '87497', 'Alingsås');
INSERT INTO public.person (id, name, person_number, street, zip_code, city) VALUES (15, 'Vaughan Tucker', '521222901847', 'Ap #140-4280 A St.', '48682', 'Ludvika');


--
-- TOC entry 3837 (class 0 OID 16547)
-- Dependencies: 222
-- Data for Name: person_email; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.person_email (person_id, email_id) VALUES (1, 1);
INSERT INTO public.person_email (person_id, email_id) VALUES (2, 2);
INSERT INTO public.person_email (person_id, email_id) VALUES (3, 3);
INSERT INTO public.person_email (person_id, email_id) VALUES (4, 4);
INSERT INTO public.person_email (person_id, email_id) VALUES (5, 5);
INSERT INTO public.person_email (person_id, email_id) VALUES (6, 6);
INSERT INTO public.person_email (person_id, email_id) VALUES (7, 7);
INSERT INTO public.person_email (person_id, email_id) VALUES (8, 8);
INSERT INTO public.person_email (person_id, email_id) VALUES (9, 9);
INSERT INTO public.person_email (person_id, email_id) VALUES (10, 10);
INSERT INTO public.person_email (person_id, email_id) VALUES (11, 11);
INSERT INTO public.person_email (person_id, email_id) VALUES (12, 12);
INSERT INTO public.person_email (person_id, email_id) VALUES (13, 13);
INSERT INTO public.person_email (person_id, email_id) VALUES (14, 14);
INSERT INTO public.person_email (person_id, email_id) VALUES (15, 15);


--
-- TOC entry 3848 (class 0 OID 16650)
-- Dependencies: 233
-- Data for Name: person_phone; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.person_phone (person_id, phone_id) VALUES (1, 1);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (2, 2);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (3, 3);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (4, 4);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (5, 5);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (6, 6);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (7, 7);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (8, 8);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (9, 9);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (10, 10);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (11, 11);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (12, 12);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (13, 13);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (14, 14);
INSERT INTO public.person_phone (person_id, phone_id) VALUES (15, 15);


--
-- TOC entry 3839 (class 0 OID 16563)
-- Dependencies: 224
-- Data for Name: phone; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.phone (id, phone_number) VALUES (1, '0763463264');
INSERT INTO public.phone (id, phone_number) VALUES (2, '0767151754');
INSERT INTO public.phone (id, phone_number) VALUES (3, '0763854776');
INSERT INTO public.phone (id, phone_number) VALUES (4, '0766066162');
INSERT INTO public.phone (id, phone_number) VALUES (5, '0769806275');
INSERT INTO public.phone (id, phone_number) VALUES (6, '0764325945');
INSERT INTO public.phone (id, phone_number) VALUES (7, '0761325812');
INSERT INTO public.phone (id, phone_number) VALUES (8, '0767232866');
INSERT INTO public.phone (id, phone_number) VALUES (9, '0762038863');
INSERT INTO public.phone (id, phone_number) VALUES (10, '0765741176');
INSERT INTO public.phone (id, phone_number) VALUES (11, '0767660681');
INSERT INTO public.phone (id, phone_number) VALUES (12, '0764462108');
INSERT INTO public.phone (id, phone_number) VALUES (13, '0762874855');
INSERT INTO public.phone (id, phone_number) VALUES (14, '0761165280');
INSERT INTO public.phone (id, phone_number) VALUES (15, '0767731634');


--
-- TOC entry 3860 (class 0 OID 16821)
-- Dependencies: 245
-- Data for Name: rent; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rent (rent_instrument_id, person_id, start_month, duration, to_be_delivered) VALUES (1, 9, 'Nov', 6, true);
INSERT INTO public.rent (rent_instrument_id, person_id, start_month, duration, to_be_delivered) VALUES (4, 10, 'Dec', 6, false);
INSERT INTO public.rent (rent_instrument_id, person_id, start_month, duration, to_be_delivered) VALUES (7, 11, 'Oct', 6, false);
INSERT INTO public.rent (rent_instrument_id, person_id, start_month, duration, to_be_delivered) VALUES (13, 11, 'Nov', 6, true);


--
-- TOC entry 3859 (class 0 OID 16815)
-- Dependencies: 244
-- Data for Name: rent_instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (1, 'Fender', 100, 'Guitar', 1);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (2, 'Fender', 100, 'Guitar', 2);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (3, 'Fender', 100, 'Guitar', 3);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (4, 'Yamaha', 120, 'Guitar', 4);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (5, 'Yamaha', 100, 'Guitar', 5);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (6, 'Yamaha', 100, 'Guitar', 6);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (7, 'Yamaha', 500, 'Piano', 7);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (8, 'Yamaha', 500, 'Piano', 8);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (9, 'Pearl', 300, 'Drums', 9);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (10, 'Pearl', 300, 'Drums', 10);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (11, 'Yamaha', 300, 'Drums', 11);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (12, 'Yamaha', 300, 'Drums', 12);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (13, 'Jupiter', 50, 'Flute', 13);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (14, 'Jupiter', 50, 'Flute', 14);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (15, 'Selmer', 200, 'Saxophone', 15);
INSERT INTO public.rent_instrument (id, brand, rental_price, type, inventory_id) VALUES (16, 'Selmer', 200, 'Saxophone', 16);


--
-- TOC entry 3857 (class 0 OID 16799)
-- Dependencies: 242
-- Data for Name: sibling; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sibling (person_id, sibling_id) VALUES (6, 7);
INSERT INTO public.sibling (person_id, sibling_id) VALUES (6, 8);
INSERT INTO public.sibling (person_id, sibling_id) VALUES (7, 8);
INSERT INTO public.sibling (person_id, sibling_id) VALUES (7, 6);
INSERT INTO public.sibling (person_id, sibling_id) VALUES (8, 7);
INSERT INTO public.sibling (person_id, sibling_id) VALUES (8, 6);
INSERT INTO public.sibling (person_id, sibling_id) VALUES (9, 10);
INSERT INTO public.sibling (person_id, sibling_id) VALUES (10, 9);


--
-- TOC entry 3840 (class 0 OID 16576)
-- Dependencies: 225
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.student (person_id, skill_level) VALUES (6, 'beginner');
INSERT INTO public.student (person_id, skill_level) VALUES (7, 'beginner');
INSERT INTO public.student (person_id, skill_level) VALUES (8, 'beginner');
INSERT INTO public.student (person_id, skill_level) VALUES (9, 'beginner');
INSERT INTO public.student (person_id, skill_level) VALUES (10, 'intermediate');
INSERT INTO public.student (person_id, skill_level) VALUES (11, 'intermediate');
INSERT INTO public.student (person_id, skill_level) VALUES (12, 'intermediate');
INSERT INTO public.student (person_id, skill_level) VALUES (13, 'advanced');
INSERT INTO public.student (person_id, skill_level) VALUES (14, 'advanced');
INSERT INTO public.student (person_id, skill_level) VALUES (15, 'advanced');


--
-- TOC entry 3842 (class 0 OID 16587)
-- Dependencies: 227
-- Data for Name: teach_instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.teach_instrument (id, instrument) VALUES (1, 'Guitar');
INSERT INTO public.teach_instrument (id, instrument) VALUES (2, 'Piano');
INSERT INTO public.teach_instrument (id, instrument) VALUES (3, 'Drums');
INSERT INTO public.teach_instrument (id, instrument) VALUES (4, 'Flute');
INSERT INTO public.teach_instrument (id, instrument) VALUES (5, 'Saxophone');


--
-- TOC entry 3850 (class 0 OID 16693)
-- Dependencies: 235
-- Data for Name: time_slot; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (25, '2022-12-05 14:00:00', '02:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (27, '2022-12-06 14:00:00', '02:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (29, '2022-12-07 14:00:00', '02:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (31, '2022-12-08 14:00:00', '02:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (33, '2022-12-09 14:00:00', '02:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (26, '2022-12-05 14:00:00', '02:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (28, '2022-12-06 14:00:00', '02:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (30, '2022-12-07 14:00:00', '02:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (32, '2022-12-08 14:00:00', '02:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (34, '2022-12-09 14:00:00', '02:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (1, '2022-12-05 10:00:00', '02:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (4, '2022-12-05 14:00:00', '02:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (9, '2022-12-06 10:00:00', '02:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (12, '2022-12-06 14:00:00', '02:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (16, '2022-12-07 14:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (20, '2022-12-08 14:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (2, '2022-12-05 11:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (3, '2022-12-05 13:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (10, '2022-12-06 11:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (11, '2022-12-06 13:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (14, '2022-12-07 11:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (15, '2022-12-07 13:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (17, '2022-12-08 10:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (18, '2022-12-08 11:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (19, '2022-12-08 13:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (21, '2022-12-09 10:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (24, '2022-12-09 14:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (5, '2022-12-05 10:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (6, '2022-12-05 11:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (7, '2022-12-05 13:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (8, '2022-12-05 14:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (13, '2022-12-07 10:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (22, '2022-12-09 11:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (23, '2022-12-09 13:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (35, '2023-07-01 06:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (36, '2023-11-12 19:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (37, '2023-10-27 05:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (38, '2023-05-26 10:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (39, '2023-03-27 22:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (40, '2023-10-12 03:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (41, '2023-06-20 17:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (42, '2023-06-19 07:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (43, '2023-01-14 17:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (44, '2023-07-24 01:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (45, '2023-02-20 17:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (46, '2023-03-25 09:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (47, '2023-09-01 22:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (48, '2023-12-30 02:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (49, '2023-10-17 02:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (50, '2023-08-19 14:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (51, '2023-07-09 05:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (52, '2023-12-20 18:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (53, '2023-07-03 22:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (54, '2023-12-12 13:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (55, '2023-12-15 01:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (56, '2023-03-15 01:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (57, '2023-09-21 01:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (58, '2023-07-19 00:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (59, '2023-01-31 18:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (60, '2023-07-29 19:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (61, '2023-10-05 04:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (62, '2023-06-03 08:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (63, '2023-10-30 02:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (64, '2023-03-08 01:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (65, '2023-01-02 16:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (66, '2023-06-10 23:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (67, '2023-03-28 15:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (68, '2023-12-09 15:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (69, '2023-10-26 03:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (70, '2023-12-17 12:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (71, '2023-02-21 19:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (72, '2023-07-21 15:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (73, '2023-07-29 18:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (74, '2023-10-13 05:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (75, '2023-11-09 23:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (76, '2023-01-30 17:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (77, '2023-02-22 04:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (78, '2023-06-24 23:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (79, '2023-09-01 20:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (80, '2023-07-12 00:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (81, '2023-08-04 06:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (82, '2023-04-19 04:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (83, '2023-10-27 18:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (84, '2023-06-09 23:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (85, '2023-01-25 03:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (86, '2023-06-30 10:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (87, '2023-02-24 02:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (88, '2023-12-24 08:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (89, '2023-05-24 07:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (90, '2023-10-10 06:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (91, '2023-09-29 04:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (92, '2023-02-15 14:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (93, '2023-06-04 09:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (94, '2023-10-30 10:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (95, '2023-10-27 04:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (96, '2023-05-17 13:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (97, '2023-04-26 21:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (98, '2023-02-18 08:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (99, '2023-06-20 00:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (100, '2023-05-05 06:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (101, '2023-10-30 17:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (102, '2023-11-28 23:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (103, '2023-12-19 18:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (104, '2023-01-12 07:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (105, '2023-11-25 00:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (106, '2023-02-20 15:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (107, '2023-03-29 09:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (108, '2023-09-30 12:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (109, '2023-09-26 21:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (110, '2023-03-12 08:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (111, '2023-03-07 18:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (112, '2023-04-14 11:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (113, '2023-04-04 06:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (114, '2023-11-11 13:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (115, '2023-05-08 20:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (116, '2023-07-01 18:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (117, '2023-01-04 08:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (118, '2023-05-18 22:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (119, '2023-03-20 12:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (120, '2023-10-12 03:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (121, '2023-05-07 22:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (122, '2023-10-04 08:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (123, '2023-12-07 00:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (124, '2023-09-26 15:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (125, '2023-07-30 08:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (126, '2023-01-18 22:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (127, '2023-03-09 17:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (128, '2023-08-29 23:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (129, '2023-09-13 13:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (130, '2023-07-03 16:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (131, '2023-11-16 03:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (132, '2023-11-19 04:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (133, '2023-01-29 04:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (134, '2023-06-10 21:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (135, '2023-04-28 23:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (136, '2023-01-28 12:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (137, '2023-09-25 18:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (138, '2023-08-04 05:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (139, '2023-06-22 01:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (140, '2023-09-22 20:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (141, '2023-08-24 08:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (142, '2023-04-17 20:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (143, '2023-02-13 12:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (144, '2023-03-05 07:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (145, '2023-02-09 10:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (146, '2023-02-14 19:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (147, '2023-08-18 06:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (148, '2023-06-24 17:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (149, '2023-08-13 05:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (150, '2023-05-13 22:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (151, '2023-01-30 22:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (152, '2023-01-15 15:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (153, '2023-07-09 03:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (154, '2023-01-03 15:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (155, '2023-05-27 08:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (156, '2023-11-09 15:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (157, '2023-02-24 01:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (158, '2023-05-23 01:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (159, '2023-09-20 20:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (160, '2023-09-13 01:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (161, '2023-07-29 11:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (162, '2023-04-30 12:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (163, '2023-01-04 19:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (164, '2023-11-07 05:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (165, '2023-03-26 08:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (166, '2023-01-13 10:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (167, '2023-01-14 15:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (168, '2023-01-10 20:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (169, '2023-09-17 10:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (170, '2023-10-01 10:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (171, '2023-07-17 22:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (172, '2023-07-16 19:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (173, '2023-08-20 21:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (174, '2023-08-06 21:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (175, '2023-08-17 15:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (176, '2023-01-29 06:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (177, '2023-08-05 04:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (178, '2023-09-23 15:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (179, '2023-09-20 16:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (180, '2023-04-12 09:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (181, '2023-08-25 16:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (182, '2023-03-13 13:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (183, '2023-02-19 02:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (184, '2023-02-17 22:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (185, '2023-09-16 05:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (186, '2023-04-02 07:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (187, '2023-05-26 15:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (188, '2023-11-19 03:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (189, '2023-10-05 12:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (190, '2023-06-22 01:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (191, '2023-01-05 17:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (192, '2023-11-23 03:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (193, '2023-12-26 12:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (194, '2023-10-24 09:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (195, '2023-12-06 20:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (196, '2023-02-15 07:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (197, '2023-10-13 23:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (198, '2023-08-25 10:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (199, '2023-10-16 10:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (200, '2023-11-04 12:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (201, '2023-03-24 02:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (202, '2023-09-16 16:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (203, '2023-11-15 14:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (204, '2023-03-19 22:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (205, '2023-02-24 20:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (206, '2023-10-14 05:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (207, '2023-09-20 18:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (208, '2023-08-22 10:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (209, '2023-12-09 12:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (210, '2023-08-23 12:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (211, '2023-05-05 23:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (212, '2023-10-08 04:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (213, '2023-02-01 00:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (214, '2023-06-15 02:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (215, '2023-06-18 14:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (216, '2023-03-01 01:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (217, '2023-03-24 14:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (218, '2023-11-19 17:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (219, '2023-12-24 09:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (220, '2023-11-12 23:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (221, '2023-12-22 06:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (222, '2023-03-29 00:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (223, '2023-02-06 21:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (224, '2023-04-01 17:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (225, '2023-04-17 10:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (226, '2023-09-18 13:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (227, '2023-02-06 23:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (228, '2023-10-17 01:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (229, '2023-12-30 17:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (230, '2023-09-18 14:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (231, '2023-01-24 13:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (232, '2023-05-28 17:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (233, '2023-04-04 09:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (234, '2023-07-18 07:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (235, '2023-06-26 01:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (236, '2023-08-08 00:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (237, '2023-09-10 02:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (238, '2023-12-08 21:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (239, '2023-12-11 16:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (240, '2023-06-06 02:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (241, '2023-12-20 21:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (242, '2023-07-31 15:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (243, '2023-12-05 09:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (244, '2023-12-15 23:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (245, '2023-11-06 18:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (246, '2023-01-07 12:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (247, '2023-03-17 07:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (248, '2023-07-18 18:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (249, '2023-10-15 14:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (250, '2023-07-15 11:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (251, '2023-04-07 15:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (252, '2023-08-29 03:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (253, '2023-02-18 23:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (254, '2023-09-29 20:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (255, '2023-06-09 11:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (256, '2023-09-30 12:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (257, '2023-10-25 22:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (258, '2023-12-09 20:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (259, '2023-06-04 10:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (260, '2023-04-07 09:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (261, '2023-10-15 09:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (262, '2023-09-14 11:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (263, '2023-05-29 19:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (264, '2023-04-18 21:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (265, '2023-09-01 07:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (266, '2023-07-28 06:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (267, '2023-05-11 19:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (268, '2023-12-18 08:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (269, '2023-01-11 12:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (270, '2023-10-09 04:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (271, '2023-03-18 01:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (272, '2023-02-05 23:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (273, '2023-09-07 08:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (274, '2023-10-08 07:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (275, '2023-10-06 15:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (276, '2023-05-06 16:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (277, '2023-07-05 15:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (278, '2023-04-02 20:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (279, '2023-10-19 12:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (280, '2023-12-28 23:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (281, '2023-06-01 01:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (282, '2023-09-27 15:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (283, '2023-02-13 12:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (284, '2023-03-26 09:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (285, '2023-07-15 21:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (286, '2023-12-12 08:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (287, '2023-01-17 16:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (288, '2023-07-18 04:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (289, '2023-08-13 19:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (290, '2023-08-14 17:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (291, '2023-03-25 01:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (292, '2023-06-26 03:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (293, '2023-12-19 13:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (294, '2023-02-11 06:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (295, '2023-10-09 20:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (296, '2023-06-17 13:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (297, '2023-02-10 17:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (298, '2023-10-14 14:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (299, '2023-04-10 18:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (300, '2023-01-19 10:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (301, '2023-11-20 07:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (302, '2023-04-01 00:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (303, '2023-06-02 16:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (304, '2023-03-18 13:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (305, '2023-01-31 07:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (306, '2023-03-20 08:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (307, '2023-04-25 03:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (308, '2023-10-23 21:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (309, '2023-03-13 04:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (310, '2023-02-09 01:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (311, '2023-08-27 11:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (312, '2023-10-11 23:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (313, '2023-09-17 05:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (314, '2023-05-06 11:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (315, '2023-10-04 00:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (316, '2023-03-16 03:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (317, '2023-12-09 11:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (318, '2023-08-20 15:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (319, '2023-12-21 15:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (320, '2023-07-18 00:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (321, '2023-07-13 04:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (322, '2023-06-27 11:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (323, '2023-09-02 14:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (324, '2023-03-13 22:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (325, '2023-03-02 02:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (326, '2023-11-26 03:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (327, '2023-02-26 20:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (328, '2023-07-30 00:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (329, '2023-07-07 15:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (330, '2023-07-30 11:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (331, '2023-12-23 16:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (332, '2023-04-30 15:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (333, '2023-03-19 23:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (334, '2023-06-30 15:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (335, '2023-01-04 01:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (336, '2023-10-29 01:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (337, '2023-05-02 20:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (338, '2023-05-29 07:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (339, '2023-05-21 23:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (340, '2023-09-07 12:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (341, '2023-07-10 22:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (342, '2023-03-15 20:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (343, '2023-07-16 21:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (344, '2023-11-05 11:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (345, '2023-03-19 23:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (346, '2023-06-24 14:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (347, '2023-11-22 20:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (348, '2023-09-14 18:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (349, '2023-05-11 06:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (350, '2023-02-25 01:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (351, '2023-07-15 20:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (352, '2023-06-12 13:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (353, '2023-09-17 17:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (354, '2023-08-13 05:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (355, '2023-04-18 01:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (356, '2023-02-21 03:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (357, '2023-01-27 08:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (358, '2023-01-16 01:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (359, '2023-10-04 15:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (360, '2023-09-10 03:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (361, '2023-12-30 07:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (362, '2023-03-26 18:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (363, '2023-03-22 01:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (364, '2023-06-27 01:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (365, '2023-08-28 15:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (366, '2023-06-06 15:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (367, '2023-03-17 05:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (368, '2023-02-28 22:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (369, '2023-01-27 08:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (370, '2023-08-11 11:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (371, '2023-11-20 05:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (372, '2023-12-21 08:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (373, '2023-07-14 12:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (374, '2023-03-23 20:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (375, '2023-02-15 09:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (376, '2023-07-15 14:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (377, '2023-01-20 19:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (378, '2023-11-01 18:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (379, '2023-03-06 19:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (380, '2023-05-26 01:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (381, '2023-02-17 18:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (382, '2023-10-23 02:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (383, '2023-03-06 06:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (384, '2023-08-29 09:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (385, '2023-04-06 01:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (386, '2023-03-12 02:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (387, '2023-11-29 10:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (388, '2023-12-02 21:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (389, '2023-06-16 17:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (390, '2023-05-18 13:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (391, '2023-03-01 15:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (392, '2023-02-12 19:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (393, '2023-11-08 07:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (394, '2023-04-07 12:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (395, '2023-01-12 05:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (396, '2023-04-06 06:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (397, '2023-03-20 00:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (398, '2023-06-27 10:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (399, '2023-01-16 06:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (400, '2023-04-16 12:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (401, '2023-04-05 05:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (402, '2023-06-21 08:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (403, '2023-07-14 18:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (404, '2023-10-25 03:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (405, '2023-07-25 11:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (406, '2023-01-31 19:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (407, '2023-07-26 22:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (408, '2023-05-20 14:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (409, '2023-01-28 06:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (410, '2023-02-02 12:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (411, '2023-10-15 10:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (412, '2023-09-27 20:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (413, '2023-08-17 14:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (414, '2023-08-20 22:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (415, '2023-11-19 08:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (416, '2023-02-02 16:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (417, '2023-09-07 01:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (418, '2023-01-09 22:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (419, '2023-09-12 11:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (420, '2023-11-26 05:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (421, '2023-03-07 09:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (422, '2023-03-04 10:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (423, '2023-01-11 14:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (424, '2023-08-24 21:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (425, '2023-10-11 21:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (426, '2023-03-09 05:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (427, '2023-09-07 21:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (428, '2023-05-08 02:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (429, '2023-08-24 04:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (430, '2023-02-16 00:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (431, '2023-04-27 01:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (432, '2023-05-12 08:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (433, '2023-04-08 06:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (434, '2023-07-25 19:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (435, '2023-02-06 13:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (436, '2023-08-01 11:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (437, '2023-01-06 11:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (438, '2023-01-15 12:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (439, '2023-01-27 20:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (440, '2023-03-28 03:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (441, '2023-10-25 02:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (442, '2023-10-20 01:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (443, '2023-05-24 23:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (444, '2023-05-16 18:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (445, '2023-03-06 22:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (446, '2023-10-03 06:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (447, '2023-05-18 01:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (448, '2023-08-16 12:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (449, '2023-08-05 07:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (450, '2023-06-16 00:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (451, '2023-09-04 09:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (452, '2023-03-06 08:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (453, '2023-09-01 16:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (454, '2023-04-01 08:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (455, '2023-07-07 05:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (456, '2023-02-25 09:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (457, '2023-12-09 19:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (458, '2023-03-24 10:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (459, '2023-12-09 09:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (460, '2023-03-02 00:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (461, '2023-06-13 13:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (462, '2023-04-07 00:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (463, '2023-07-10 10:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (464, '2023-03-30 23:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (465, '2023-08-09 20:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (466, '2023-11-04 01:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (467, '2023-01-13 04:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (468, '2023-08-08 17:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (469, '2023-03-03 18:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (470, '2023-06-15 16:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (471, '2023-02-12 19:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (472, '2023-12-20 10:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (473, '2023-01-11 14:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (474, '2023-04-21 10:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (475, '2023-01-16 05:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (476, '2023-03-27 08:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (477, '2023-05-12 03:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (478, '2023-06-03 13:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (479, '2023-07-05 20:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (480, '2023-08-30 01:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (481, '2023-03-05 05:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (482, '2023-01-04 16:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (483, '2023-08-20 18:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (484, '2023-07-22 19:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (485, '2023-09-10 07:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (486, '2023-07-13 07:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (487, '2023-12-04 17:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (488, '2023-06-12 15:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (489, '2023-02-23 17:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (490, '2023-02-06 01:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (491, '2023-01-18 23:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (492, '2023-02-06 12:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (493, '2023-12-21 08:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (494, '2023-02-18 14:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (495, '2023-03-17 19:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (496, '2023-01-17 02:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (497, '2023-09-02 03:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (498, '2023-02-23 05:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (499, '2023-07-28 10:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (500, '2023-04-28 04:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (501, '2023-03-21 05:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (502, '2023-02-12 13:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (503, '2023-10-11 00:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (504, '2023-01-18 14:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (505, '2023-10-03 14:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (506, '2023-01-10 06:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (507, '2023-11-12 08:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (508, '2023-10-23 23:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (509, '2023-11-17 10:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (510, '2023-12-15 09:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (511, '2023-06-13 22:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (512, '2023-04-10 17:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (513, '2023-12-19 10:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (514, '2023-05-20 19:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (515, '2023-04-23 06:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (516, '2023-03-13 09:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (517, '2023-10-13 21:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (518, '2023-01-11 09:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (519, '2023-08-29 12:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (520, '2023-11-13 15:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (521, '2023-03-30 19:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (522, '2023-09-12 10:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (523, '2023-04-18 00:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (524, '2023-04-15 06:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (525, '2023-08-31 16:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (526, '2023-08-08 10:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (527, '2023-01-10 11:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (528, '2023-06-16 13:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (529, '2023-09-20 15:00:00', '01:00:00', 5);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (530, '2023-04-28 12:00:00', '01:00:00', 1);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (531, '2023-06-19 04:00:00', '01:00:00', 2);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (532, '2023-05-05 14:00:00', '01:00:00', 3);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (533, '2023-01-28 17:00:00', '01:00:00', 4);
INSERT INTO public.time_slot (id, datetime, duration, person_id) VALUES (534, '2023-08-08 22:00:00', '01:00:00', 5);


--
-- TOC entry 3881 (class 0 OID 0)
-- Dependencies: 228
-- Name: booking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.booking_id_seq', 250, true);


--
-- TOC entry 3882 (class 0 OID 0)
-- Dependencies: 214
-- Name: discount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.discount_id_seq', 1, true);


--
-- TOC entry 3883 (class 0 OID 0)
-- Dependencies: 216
-- Name: email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.email_id_seq', 15, true);


--
-- TOC entry 3884 (class 0 OID 0)
-- Dependencies: 236
-- Name: ensemble_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ensemble_id_seq', 102, true);


--
-- TOC entry 3885 (class 0 OID 0)
-- Dependencies: 238
-- Name: group_lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.group_lesson_id_seq', 268, true);


--
-- TOC entry 3886 (class 0 OID 0)
-- Dependencies: 246
-- Name: individual_lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.individual_lesson_id_seq', 100, true);


--
-- TOC entry 3887 (class 0 OID 0)
-- Dependencies: 218
-- Name: lesson_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_price_id_seq', 7, true);


--
-- TOC entry 3888 (class 0 OID 0)
-- Dependencies: 220
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.person_id_seq', 15, true);


--
-- TOC entry 3889 (class 0 OID 0)
-- Dependencies: 223
-- Name: phone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.phone_id_seq', 15, true);


--
-- TOC entry 3890 (class 0 OID 0)
-- Dependencies: 243
-- Name: rent_instrument_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rent_instrument_id_seq', 16, true);


--
-- TOC entry 3891 (class 0 OID 0)
-- Dependencies: 226
-- Name: teach_instrument_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teach_instrument_id_seq', 5, true);


--
-- TOC entry 3892 (class 0 OID 0)
-- Dependencies: 234
-- Name: time_slot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.time_slot_id_seq', 534, true);


--
-- TOC entry 3637 (class 2606 OID 16747)
-- Name: booking_ensemble booking_ensemble_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_ensemble
    ADD CONSTRAINT booking_ensemble_pkey PRIMARY KEY (ensemble_id, booking_id);


--
-- TOC entry 3639 (class 2606 OID 16762)
-- Name: booking_group_lesson booking_group_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_group_lesson
    ADD CONSTRAINT booking_group_lesson_pkey PRIMARY KEY (booking_id, group_lesson_id);


--
-- TOC entry 3621 (class 2606 OID 16599)
-- Name: booking booking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_pkey PRIMARY KEY (id);


--
-- TOC entry 3623 (class 2606 OID 16619)
-- Name: contact_person contact_person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_person
    ADD CONSTRAINT contact_person_pkey PRIMARY KEY (person_id);


--
-- TOC entry 3603 (class 2606 OID 16523)
-- Name: discount discount_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount
    ADD CONSTRAINT discount_pkey PRIMARY KEY (id);


--
-- TOC entry 3605 (class 2606 OID 16530)
-- Name: email email_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_pkey PRIMARY KEY (id);


--
-- TOC entry 3633 (class 2606 OID 16710)
-- Name: ensemble ensemble_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble
    ADD CONSTRAINT ensemble_pkey PRIMARY KEY (id);


--
-- TOC entry 3635 (class 2606 OID 16722)
-- Name: group_lesson group_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_pkey PRIMARY KEY (id);


--
-- TOC entry 3647 (class 2606 OID 16842)
-- Name: individual_lesson individual_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_pkey PRIMARY KEY (id);


--
-- TOC entry 3625 (class 2606 OID 16629)
-- Name: instructor instructor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_pkey PRIMARY KEY (person_id);


--
-- TOC entry 3627 (class 2606 OID 16639)
-- Name: instructor_teach_instrument instructor_teach_instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_teach_instrument
    ADD CONSTRAINT instructor_teach_instrument_pkey PRIMARY KEY (person_id, teach_instrument_id);


--
-- TOC entry 3607 (class 2606 OID 16537)
-- Name: lesson_price lesson_price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_price
    ADD CONSTRAINT lesson_price_pkey PRIMARY KEY (id);


--
-- TOC entry 3613 (class 2606 OID 16551)
-- Name: person_email person_email_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_email
    ADD CONSTRAINT person_email_pkey PRIMARY KEY (person_id, email_id);


--
-- TOC entry 3609 (class 2606 OID 16546)
-- Name: person person_person_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_person_number_key UNIQUE (person_number);


--
-- TOC entry 3629 (class 2606 OID 16654)
-- Name: person_phone person_phone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_phone
    ADD CONSTRAINT person_phone_pkey PRIMARY KEY (person_id, phone_id);


--
-- TOC entry 3611 (class 2606 OID 16544)
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- TOC entry 3615 (class 2606 OID 16568)
-- Name: phone phone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone
    ADD CONSTRAINT phone_pkey PRIMARY KEY (id);


--
-- TOC entry 3643 (class 2606 OID 16820)
-- Name: rent_instrument rent_instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rent_instrument
    ADD CONSTRAINT rent_instrument_pkey PRIMARY KEY (id);


--
-- TOC entry 3645 (class 2606 OID 16825)
-- Name: rent rent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rent
    ADD CONSTRAINT rent_pkey PRIMARY KEY (rent_instrument_id, person_id);


--
-- TOC entry 3641 (class 2606 OID 16803)
-- Name: sibling sibling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sibling
    ADD CONSTRAINT sibling_pkey PRIMARY KEY (person_id, sibling_id);


--
-- TOC entry 3617 (class 2606 OID 16580)
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (person_id);


--
-- TOC entry 3619 (class 2606 OID 16592)
-- Name: teach_instrument teach_instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teach_instrument
    ADD CONSTRAINT teach_instrument_pkey PRIMARY KEY (id);


--
-- TOC entry 3631 (class 2606 OID 16698)
-- Name: time_slot time_slot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_slot
    ADD CONSTRAINT time_slot_pkey PRIMARY KEY (id);


--
-- TOC entry 3651 (class 2606 OID 16605)
-- Name: booking booking_discount_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_discount_id_fkey FOREIGN KEY (discount_id) REFERENCES public.discount(id);


--
-- TOC entry 3663 (class 2606 OID 16753)
-- Name: booking_ensemble booking_ensemble_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_ensemble
    ADD CONSTRAINT booking_ensemble_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.booking(id) ON DELETE CASCADE;


--
-- TOC entry 3664 (class 2606 OID 16748)
-- Name: booking_ensemble booking_ensemble_ensemble_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_ensemble
    ADD CONSTRAINT booking_ensemble_ensemble_id_fkey FOREIGN KEY (ensemble_id) REFERENCES public.ensemble(id) ON DELETE CASCADE;


--
-- TOC entry 3665 (class 2606 OID 16763)
-- Name: booking_group_lesson booking_group_lesson_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_group_lesson
    ADD CONSTRAINT booking_group_lesson_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.booking(id) ON DELETE CASCADE;


--
-- TOC entry 3666 (class 2606 OID 16768)
-- Name: booking_group_lesson booking_group_lesson_group_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_group_lesson
    ADD CONSTRAINT booking_group_lesson_group_lesson_id_fkey FOREIGN KEY (group_lesson_id) REFERENCES public.group_lesson(id) ON DELETE CASCADE;


--
-- TOC entry 3652 (class 2606 OID 16610)
-- Name: booking booking_lesson_price_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_lesson_price_id_fkey FOREIGN KEY (lesson_price_id) REFERENCES public.lesson_price(id);


--
-- TOC entry 3653 (class 2606 OID 16600)
-- Name: booking booking_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.student(person_id) ON DELETE CASCADE;


--
-- TOC entry 3654 (class 2606 OID 16620)
-- Name: contact_person contact_person_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_person
    ADD CONSTRAINT contact_person_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.student(person_id) ON DELETE CASCADE;


--
-- TOC entry 3661 (class 2606 OID 16711)
-- Name: ensemble ensemble_time_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble
    ADD CONSTRAINT ensemble_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES public.time_slot(id);


--
-- TOC entry 3662 (class 2606 OID 16723)
-- Name: group_lesson group_lesson_time_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES public.time_slot(id);


--
-- TOC entry 3671 (class 2606 OID 16848)
-- Name: individual_lesson individual_lesson_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.booking(id);


--
-- TOC entry 3672 (class 2606 OID 16843)
-- Name: individual_lesson individual_lesson_time_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES public.time_slot(id);


--
-- TOC entry 3655 (class 2606 OID 16630)
-- Name: instructor instructor_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- TOC entry 3656 (class 2606 OID 16640)
-- Name: instructor_teach_instrument instructor_teach_instrument_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_teach_instrument
    ADD CONSTRAINT instructor_teach_instrument_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.instructor(person_id) ON DELETE CASCADE;


--
-- TOC entry 3657 (class 2606 OID 16645)
-- Name: instructor_teach_instrument instructor_teach_instrument_teach_instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_teach_instrument
    ADD CONSTRAINT instructor_teach_instrument_teach_instrument_id_fkey FOREIGN KEY (teach_instrument_id) REFERENCES public.teach_instrument(id) ON DELETE CASCADE;


--
-- TOC entry 3648 (class 2606 OID 16557)
-- Name: person_email person_email_email_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_email
    ADD CONSTRAINT person_email_email_id_fkey FOREIGN KEY (email_id) REFERENCES public.email(id) ON DELETE CASCADE;


--
-- TOC entry 3649 (class 2606 OID 16552)
-- Name: person_email person_email_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_email
    ADD CONSTRAINT person_email_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- TOC entry 3658 (class 2606 OID 16655)
-- Name: person_phone person_phone_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_phone
    ADD CONSTRAINT person_phone_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- TOC entry 3659 (class 2606 OID 16660)
-- Name: person_phone person_phone_phone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_phone
    ADD CONSTRAINT person_phone_phone_id_fkey FOREIGN KEY (phone_id) REFERENCES public.phone(id) ON DELETE CASCADE;


--
-- TOC entry 3669 (class 2606 OID 16831)
-- Name: rent rent_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rent
    ADD CONSTRAINT rent_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.student(person_id) ON DELETE CASCADE;


--
-- TOC entry 3670 (class 2606 OID 16826)
-- Name: rent rent_rent_instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rent
    ADD CONSTRAINT rent_rent_instrument_id_fkey FOREIGN KEY (rent_instrument_id) REFERENCES public.rent_instrument(id) ON DELETE CASCADE;


--
-- TOC entry 3667 (class 2606 OID 16804)
-- Name: sibling sibling_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sibling
    ADD CONSTRAINT sibling_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.student(person_id) ON DELETE CASCADE;


--
-- TOC entry 3668 (class 2606 OID 16809)
-- Name: sibling sibling_sibling_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sibling
    ADD CONSTRAINT sibling_sibling_id_fkey FOREIGN KEY (sibling_id) REFERENCES public.student(person_id) ON DELETE CASCADE;


--
-- TOC entry 3650 (class 2606 OID 16581)
-- Name: student student_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- TOC entry 3660 (class 2606 OID 16699)
-- Name: time_slot time_slot_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_slot
    ADD CONSTRAINT time_slot_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.instructor(person_id);


-- Completed on 2023-01-10 20:21:20 CET

--
-- PostgreSQL database dump complete
--

