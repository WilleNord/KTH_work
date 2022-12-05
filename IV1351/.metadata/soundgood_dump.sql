PGDMP     !                    z         	   soundgood    15.1    15.1 �               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16398 	   soundgood    DATABASE     k   CREATE DATABASE soundgood WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';
    DROP DATABASE soundgood;
                postgres    false            �            1259    16705    ensemble    TABLE     �   CREATE TABLE public.ensemble (
    id integer NOT NULL,
    min_students integer NOT NULL,
    max_students integer NOT NULL,
    genre character varying(100) NOT NULL,
    time_slot_id integer
);
    DROP TABLE public.ensemble;
       public         heap    postgres    false            �            1259    16693 	   time_slot    TABLE     �   CREATE TABLE public.time_slot (
    id integer NOT NULL,
    datetime timestamp(6) without time zone NOT NULL,
    duration time(6) without time zone NOT NULL,
    person_id integer
);
    DROP TABLE public.time_slot;
       public         heap    postgres    false            �            1259    25096    e_month    VIEW     B  CREATE VIEW public.e_month AS
 SELECT date_trunc('month'::text, ts.datetime) AS month,
    count(e.id) AS "Ensembles/month"
   FROM (public.ensemble e
     LEFT JOIN public.time_slot ts ON ((ts.id = e.time_slot_id)))
  GROUP BY (date_trunc('month'::text, ts.datetime))
  ORDER BY (date_trunc('month'::text, ts.datetime));
    DROP VIEW public.e_month;
       public          postgres    false    235    235    237    237            �            1259    16717    group_lesson    TABLE     �   CREATE TABLE public.group_lesson (
    id integer NOT NULL,
    min_students integer NOT NULL,
    max_students integer NOT NULL,
    instrument character varying(100) NOT NULL,
    skill_level character varying(20) NOT NULL,
    time_slot_id integer
);
     DROP TABLE public.group_lesson;
       public         heap    postgres    false            �            1259    25092    gl_month    VIEW     N  CREATE VIEW public.gl_month AS
 SELECT date_trunc('month'::text, ts.datetime) AS month,
    count(gl.id) AS "Group lessons/month"
   FROM (public.group_lesson gl
     LEFT JOIN public.time_slot ts ON ((ts.id = gl.time_slot_id)))
  GROUP BY (date_trunc('month'::text, ts.datetime))
  ORDER BY (date_trunc('month'::text, ts.datetime));
    DROP VIEW public.gl_month;
       public          postgres    false    239    239    235    235            �            1259    16837    individual_lesson    TABLE     �   CREATE TABLE public.individual_lesson (
    id integer NOT NULL,
    instrument character varying(100) NOT NULL,
    skill_level character varying(20) NOT NULL,
    time_slot_id integer,
    booking_id integer
);
 %   DROP TABLE public.individual_lesson;
       public         heap    postgres    false            �            1259    25088    il_month    VIEW     X  CREATE VIEW public.il_month AS
 SELECT date_trunc('month'::text, ts.datetime) AS month,
    count(il.id) AS "Individual lessons/month"
   FROM (public.individual_lesson il
     LEFT JOIN public.time_slot ts ON ((ts.id = il.time_slot_id)))
  GROUP BY (date_trunc('month'::text, ts.datetime))
  ORDER BY (date_trunc('month'::text, ts.datetime));
    DROP VIEW public.il_month;
       public          postgres    false    247    235    235    247            �            1259    25100    all_lessons    VIEW     A  CREATE VIEW public.all_lessons AS
 SELECT e_month.month,
    e_month."Ensembles/month",
    gl_month."Group lessons/month",
    il_month."Individual lessons/month"
   FROM ((public.e_month
     JOIN public.gl_month ON ((e_month.month = gl_month.month)))
     JOIN public.il_month ON ((gl_month.month = il_month.month)));
    DROP VIEW public.all_lessons;
       public          postgres    false    251    252    252    253    253    251            �            1259    16594    booking    TABLE     �   CREATE TABLE public.booking (
    id integer NOT NULL,
    person_id integer NOT NULL,
    discount_id integer,
    lesson_price_id integer NOT NULL
);
    DROP TABLE public.booking;
       public         heap    postgres    false            �            1259    16743    booking_ensemble    TABLE     l   CREATE TABLE public.booking_ensemble (
    ensemble_id integer NOT NULL,
    booking_id integer NOT NULL
);
 $   DROP TABLE public.booking_ensemble;
       public         heap    postgres    false            �            1259    16758    booking_group_lesson    TABLE     t   CREATE TABLE public.booking_group_lesson (
    booking_id integer NOT NULL,
    group_lesson_id integer NOT NULL
);
 (   DROP TABLE public.booking_group_lesson;
       public         heap    postgres    false            �            1259    16593    booking_id_seq    SEQUENCE     �   CREATE SEQUENCE public.booking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.booking_id_seq;
       public          postgres    false    229                       0    0    booking_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.booking_id_seq OWNED BY public.booking.id;
          public          postgres    false    228            �            1259    16615    contact_person    TABLE     �   CREATE TABLE public.contact_person (
    person_id integer NOT NULL,
    name character varying(100) NOT NULL,
    phone_number character varying(20) NOT NULL
);
 "   DROP TABLE public.contact_person;
       public         heap    postgres    false            �            1259    16518    discount    TABLE     a   CREATE TABLE public.discount (
    id integer NOT NULL,
    percentage numeric(10,0) NOT NULL
);
    DROP TABLE public.discount;
       public         heap    postgres    false            �            1259    16517    discount_id_seq    SEQUENCE     �   CREATE SEQUENCE public.discount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.discount_id_seq;
       public          postgres    false    215                       0    0    discount_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.discount_id_seq OWNED BY public.discount.id;
          public          postgres    false    214            �            1259    16525    email    TABLE     j   CREATE TABLE public.email (
    id integer NOT NULL,
    email_address character varying(100) NOT NULL
);
    DROP TABLE public.email;
       public         heap    postgres    false            �            1259    16524    email_id_seq    SEQUENCE     �   CREATE SEQUENCE public.email_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.email_id_seq;
       public          postgres    false    217                       0    0    email_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.email_id_seq OWNED BY public.email.id;
          public          postgres    false    216            �            1259    16704    ensemble_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ensemble_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.ensemble_id_seq;
       public          postgres    false    237                       0    0    ensemble_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.ensemble_id_seq OWNED BY public.ensemble.id;
          public          postgres    false    236            �            1259    16716    group_lesson_id_seq    SEQUENCE     �   CREATE SEQUENCE public.group_lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.group_lesson_id_seq;
       public          postgres    false    239                       0    0    group_lesson_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.group_lesson_id_seq OWNED BY public.group_lesson.id;
          public          postgres    false    238            �            1259    16539    person    TABLE       CREATE TABLE public.person (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    person_number character varying(12) NOT NULL,
    street character varying(100) NOT NULL,
    zip_code character varying(10) NOT NULL,
    city character varying(100) NOT NULL
);
    DROP TABLE public.person;
       public         heap    postgres    false            �            1259    16799    sibling    TABLE     a   CREATE TABLE public.sibling (
    person_id integer NOT NULL,
    sibling_id integer NOT NULL
);
    DROP TABLE public.sibling;
       public         heap    postgres    false            �            1259    16853    number_of_siblings    VIEW     �   CREATE VIEW public.number_of_siblings AS
 SELECT count(sibling.sibling_id) AS siblings
   FROM (public.sibling
     LEFT JOIN public.person ON ((sibling.sibling_id = person.id)))
  GROUP BY person.name;
 %   DROP VIEW public.number_of_siblings;
       public          postgres    false    221    242    221            �            1259    16866    has_siblings    VIEW     �   CREATE VIEW public.has_siblings AS
 SELECT number_of_siblings.siblings AS "Number of siblings",
    count(number_of_siblings.siblings) AS count
   FROM public.number_of_siblings
  GROUP BY number_of_siblings.siblings;
    DROP VIEW public.has_siblings;
       public          postgres    false    248            �            1259    16836    individual_lesson_id_seq    SEQUENCE     �   CREATE SEQUENCE public.individual_lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.individual_lesson_id_seq;
       public          postgres    false    247                       0    0    individual_lesson_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.individual_lesson_id_seq OWNED BY public.individual_lesson.id;
          public          postgres    false    246            �            1259    16625 
   instructor    TABLE     k   CREATE TABLE public.instructor (
    person_id integer NOT NULL,
    teaches_ensembles boolean NOT NULL
);
    DROP TABLE public.instructor;
       public         heap    postgres    false                       1259    25147    instructor_lesson_month    VIEW     �  CREATE VIEW public.instructor_lesson_month AS
 SELECT instructor.person_id,
    EXTRACT(month FROM ts.datetime) AS month
   FROM ((((public.instructor
     LEFT JOIN public.time_slot ts ON ((ts.person_id = instructor.person_id)))
     FULL JOIN public.individual_lesson il ON ((il.time_slot_id = ts.id)))
     FULL JOIN public.group_lesson gl ON ((gl.time_slot_id = ts.id)))
     FULL JOIN public.ensemble e ON ((e.time_slot_id = ts.id)));
 *   DROP VIEW public.instructor_lesson_month;
       public          postgres    false    239    247    237    235    235    235    231            �            1259    16635    instructor_teach_instrument    TABLE     ~   CREATE TABLE public.instructor_teach_instrument (
    person_id integer NOT NULL,
    teach_instrument_id integer NOT NULL
);
 /   DROP TABLE public.instructor_teach_instrument;
       public         heap    postgres    false            �            1259    16532    lesson_price    TABLE     �   CREATE TABLE public.lesson_price (
    id integer NOT NULL,
    lesson_type character varying(20) NOT NULL,
    level character varying(20) NOT NULL,
    price numeric(20,0) NOT NULL
);
     DROP TABLE public.lesson_price;
       public         heap    postgres    false            �            1259    16531    lesson_price_id_seq    SEQUENCE     �   CREATE SEQUENCE public.lesson_price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.lesson_price_id_seq;
       public          postgres    false    219                       0    0    lesson_price_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.lesson_price_id_seq OWNED BY public.lesson_price.id;
          public          postgres    false    218                       1259    25157    next_week_ensembles    VIEW       CREATE VIEW public.next_week_ensembles AS
 SELECT ensemble.id,
    ensemble.genre,
    EXTRACT(dow FROM ts.datetime) AS weekday,
    ensemble.min_students,
    ensemble.max_students
   FROM (public.ensemble
     JOIN public.time_slot ts ON ((ensemble.time_slot_id = ts.id)))
  WHERE (EXTRACT(week FROM ts.datetime) = ( SELECT (EXTRACT(week FROM CURRENT_TIMESTAMP) + (1)::numeric)));
 &   DROP VIEW public.next_week_ensembles;
       public          postgres    false    237    237    235    235    237    237    237            �            1259    16576    student    TABLE     p   CREATE TABLE public.student (
    person_id integer NOT NULL,
    skill_level character varying(20) NOT NULL
);
    DROP TABLE public.student;
       public         heap    postgres    false            �            1259    16862    no_sibling_students    VIEW     �   CREATE VIEW public.no_sibling_students AS
 SELECT count(student.person_id) AS no_sibling_students
   FROM public.student
  WHERE (NOT (student.person_id IN ( SELECT sibling.person_id
           FROM public.sibling)));
 &   DROP VIEW public.no_sibling_students;
       public          postgres    false    242    225            �            1259    16547    person_email    TABLE     d   CREATE TABLE public.person_email (
    person_id integer NOT NULL,
    email_id integer NOT NULL
);
     DROP TABLE public.person_email;
       public         heap    postgres    false            �            1259    16538    person_id_seq    SEQUENCE     �   CREATE SEQUENCE public.person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.person_id_seq;
       public          postgres    false    221                       0    0    person_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.person_id_seq OWNED BY public.person.id;
          public          postgres    false    220            �            1259    16650    person_phone    TABLE     d   CREATE TABLE public.person_phone (
    person_id integer NOT NULL,
    phone_id integer NOT NULL
);
     DROP TABLE public.person_phone;
       public         heap    postgres    false            �            1259    16563    phone    TABLE     h   CREATE TABLE public.phone (
    id integer NOT NULL,
    phone_number character varying(20) NOT NULL
);
    DROP TABLE public.phone;
       public         heap    postgres    false            �            1259    16562    phone_id_seq    SEQUENCE     �   CREATE SEQUENCE public.phone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.phone_id_seq;
       public          postgres    false    224                       0    0    phone_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.phone_id_seq OWNED BY public.phone.id;
          public          postgres    false    223            �            1259    16821    rent    TABLE     �   CREATE TABLE public.rent (
    rent_instrument_id integer NOT NULL,
    person_id integer NOT NULL,
    start_month character varying(20) NOT NULL,
    duration integer NOT NULL,
    to_be_delivered boolean NOT NULL
);
    DROP TABLE public.rent;
       public         heap    postgres    false            �            1259    16815    rent_instrument    TABLE     �   CREATE TABLE public.rent_instrument (
    id integer NOT NULL,
    brand character varying(100),
    rental_price numeric(20,0) NOT NULL,
    type character varying(100) NOT NULL,
    inventory_id integer
);
 #   DROP TABLE public.rent_instrument;
       public         heap    postgres    false            �            1259    16814    rent_instrument_id_seq    SEQUENCE     �   CREATE SEQUENCE public.rent_instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.rent_instrument_id_seq;
       public          postgres    false    244                       0    0    rent_instrument_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.rent_instrument_id_seq OWNED BY public.rent_instrument.id;
          public          postgres    false    243                       1259    25162    seats_next_week_ensembles    VIEW     �  CREATE VIEW public.seats_next_week_ensembles AS
 SELECT
        CASE
            WHEN (( SELECT count(*) AS count
               FROM (public.booking_ensemble
                 JOIN public.next_week_ensembles nwe_1 ON ((nwe_1.id = booking_ensemble.ensemble_id)))
              GROUP BY nwe_1.genre) > nwe.max_students) THEN (nwe.max_students - ( SELECT count(*) AS count
               FROM (public.booking_ensemble
                 JOIN public.next_week_ensembles nwe_1 ON ((nwe_1.id = booking_ensemble.ensemble_id)))
              GROUP BY nwe_1.genre))
            ELSE (0)::bigint
        END AS "seats left",
    nwe.genre,
    nwe.weekday
   FROM public.next_week_ensembles nwe
  ORDER BY nwe.weekday;
 ,   DROP VIEW public.seats_next_week_ensembles;
       public          postgres    false    240    258    258    258    258            �            1259    25108    total    VIEW     �   CREATE VIEW public.total AS
 SELECT all_lessons.month,
    sum(((all_lessons."Ensembles/month" + all_lessons."Group lessons/month") + all_lessons."Individual lessons/month")) AS total
   FROM public.all_lessons
  GROUP BY all_lessons.month;
    DROP VIEW public.total;
       public          postgres    false    254    254    254    254                        1259    25112    show_lessons    VIEW     �  CREATE VIEW public.show_lessons AS
 SELECT e_month.month,
    e_month."Ensembles/month",
    gl_month."Group lessons/month",
    il_month."Individual lessons/month",
    total.total
   FROM (((public.e_month
     JOIN public.gl_month ON ((e_month.month = gl_month.month)))
     JOIN public.il_month ON ((gl_month.month = il_month.month)))
     JOIN public.total ON ((total.month = il_month.month)));
    DROP VIEW public.show_lessons;
       public          postgres    false    253    251    251    255    252    252    253    255            �            1259    16587    teach_instrument    TABLE     r   CREATE TABLE public.teach_instrument (
    id integer NOT NULL,
    instrument character varying(100) NOT NULL
);
 $   DROP TABLE public.teach_instrument;
       public         heap    postgres    false            �            1259    16586    teach_instrument_id_seq    SEQUENCE     �   CREATE SEQUENCE public.teach_instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.teach_instrument_id_seq;
       public          postgres    false    227                       0    0    teach_instrument_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.teach_instrument_id_seq OWNED BY public.teach_instrument.id;
          public          postgres    false    226            �            1259    16692    time_slot_id_seq    SEQUENCE     �   CREATE SEQUENCE public.time_slot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.time_slot_id_seq;
       public          postgres    false    235                       0    0    time_slot_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.time_slot_id_seq OWNED BY public.time_slot.id;
          public          postgres    false    234                       2604    16597 
   booking id    DEFAULT     h   ALTER TABLE ONLY public.booking ALTER COLUMN id SET DEFAULT nextval('public.booking_id_seq'::regclass);
 9   ALTER TABLE public.booking ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    228    229    229            �           2604    16521    discount id    DEFAULT     j   ALTER TABLE ONLY public.discount ALTER COLUMN id SET DEFAULT nextval('public.discount_id_seq'::regclass);
 :   ALTER TABLE public.discount ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    214    215    215            �           2604    16528    email id    DEFAULT     d   ALTER TABLE ONLY public.email ALTER COLUMN id SET DEFAULT nextval('public.email_id_seq'::regclass);
 7   ALTER TABLE public.email ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    217    217                       2604    16708    ensemble id    DEFAULT     j   ALTER TABLE ONLY public.ensemble ALTER COLUMN id SET DEFAULT nextval('public.ensemble_id_seq'::regclass);
 :   ALTER TABLE public.ensemble ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    237    237                       2604    16720    group_lesson id    DEFAULT     r   ALTER TABLE ONLY public.group_lesson ALTER COLUMN id SET DEFAULT nextval('public.group_lesson_id_seq'::regclass);
 >   ALTER TABLE public.group_lesson ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    238    239    239            	           2604    16840    individual_lesson id    DEFAULT     |   ALTER TABLE ONLY public.individual_lesson ALTER COLUMN id SET DEFAULT nextval('public.individual_lesson_id_seq'::regclass);
 C   ALTER TABLE public.individual_lesson ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    246    247    247                        2604    16535    lesson_price id    DEFAULT     r   ALTER TABLE ONLY public.lesson_price ALTER COLUMN id SET DEFAULT nextval('public.lesson_price_id_seq'::regclass);
 >   ALTER TABLE public.lesson_price ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    219    219                       2604    16542 	   person id    DEFAULT     f   ALTER TABLE ONLY public.person ALTER COLUMN id SET DEFAULT nextval('public.person_id_seq'::regclass);
 8   ALTER TABLE public.person ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    220    221                       2604    16566    phone id    DEFAULT     d   ALTER TABLE ONLY public.phone ALTER COLUMN id SET DEFAULT nextval('public.phone_id_seq'::regclass);
 7   ALTER TABLE public.phone ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    224    224                       2604    16818    rent_instrument id    DEFAULT     x   ALTER TABLE ONLY public.rent_instrument ALTER COLUMN id SET DEFAULT nextval('public.rent_instrument_id_seq'::regclass);
 A   ALTER TABLE public.rent_instrument ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    243    244    244                       2604    16590    teach_instrument id    DEFAULT     z   ALTER TABLE ONLY public.teach_instrument ALTER COLUMN id SET DEFAULT nextval('public.teach_instrument_id_seq'::regclass);
 B   ALTER TABLE public.teach_instrument ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226    227                       2604    16696    time_slot id    DEFAULT     l   ALTER TABLE ONLY public.time_slot ALTER COLUMN id SET DEFAULT nextval('public.time_slot_id_seq'::regclass);
 ;   ALTER TABLE public.time_slot ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    235    235            �          0    16594    booking 
   TABLE DATA                 public          postgres    false    229   O�                 0    16743    booking_ensemble 
   TABLE DATA                 public          postgres    false    240   I�                 0    16758    booking_group_lesson 
   TABLE DATA                 public          postgres    false    241   L�       �          0    16615    contact_person 
   TABLE DATA                 public          postgres    false    230   ��       �          0    16518    discount 
   TABLE DATA                 public          postgres    false    215   ��       �          0    16525    email 
   TABLE DATA                 public          postgres    false    217   /�                 0    16705    ensemble 
   TABLE DATA                 public          postgres    false    237   c�                 0    16717    group_lesson 
   TABLE DATA                 public          postgres    false    239   ��                 0    16837    individual_lesson 
   TABLE DATA                 public          postgres    false    247   ��       �          0    16625 
   instructor 
   TABLE DATA                 public          postgres    false    231   y�       �          0    16635    instructor_teach_instrument 
   TABLE DATA                 public          postgres    false    232   ��       �          0    16532    lesson_price 
   TABLE DATA                 public          postgres    false    219   Z�       �          0    16539    person 
   TABLE DATA                 public          postgres    false    221   �       �          0    16547    person_email 
   TABLE DATA                 public          postgres    false    222   "�       �          0    16650    person_phone 
   TABLE DATA                 public          postgres    false    233   ��       �          0    16563    phone 
   TABLE DATA                 public          postgres    false    224   ^�       
          0    16821    rent 
   TABLE DATA                 public          postgres    false    245   -�       	          0    16815    rent_instrument 
   TABLE DATA                 public          postgres    false    244   ��                 0    16799    sibling 
   TABLE DATA                 public          postgres    false    242   ��       �          0    16576    student 
   TABLE DATA                 public          postgres    false    225   �       �          0    16587    teach_instrument 
   TABLE DATA                 public          postgres    false    227   ��                  0    16693 	   time_slot 
   TABLE DATA                 public          postgres    false    235   �                  0    0    booking_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.booking_id_seq', 250, true);
          public          postgres    false    228                        0    0    discount_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.discount_id_seq', 1, true);
          public          postgres    false    214            !           0    0    email_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.email_id_seq', 15, true);
          public          postgres    false    216            "           0    0    ensemble_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.ensemble_id_seq', 102, true);
          public          postgres    false    236            #           0    0    group_lesson_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.group_lesson_id_seq', 268, true);
          public          postgres    false    238            $           0    0    individual_lesson_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.individual_lesson_id_seq', 100, true);
          public          postgres    false    246            %           0    0    lesson_price_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.lesson_price_id_seq', 7, true);
          public          postgres    false    218            &           0    0    person_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.person_id_seq', 15, true);
          public          postgres    false    220            '           0    0    phone_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.phone_id_seq', 15, true);
          public          postgres    false    223            (           0    0    rent_instrument_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.rent_instrument_id_seq', 16, true);
          public          postgres    false    243            )           0    0    teach_instrument_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.teach_instrument_id_seq', 5, true);
          public          postgres    false    226            *           0    0    time_slot_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.time_slot_id_seq', 534, true);
          public          postgres    false    234            -           2606    16747 &   booking_ensemble booking_ensemble_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public.booking_ensemble
    ADD CONSTRAINT booking_ensemble_pkey PRIMARY KEY (ensemble_id, booking_id);
 P   ALTER TABLE ONLY public.booking_ensemble DROP CONSTRAINT booking_ensemble_pkey;
       public            postgres    false    240    240            /           2606    16762 .   booking_group_lesson booking_group_lesson_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.booking_group_lesson
    ADD CONSTRAINT booking_group_lesson_pkey PRIMARY KEY (booking_id, group_lesson_id);
 X   ALTER TABLE ONLY public.booking_group_lesson DROP CONSTRAINT booking_group_lesson_pkey;
       public            postgres    false    241    241                       2606    16599    booking booking_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.booking DROP CONSTRAINT booking_pkey;
       public            postgres    false    229                       2606    16619 "   contact_person contact_person_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.contact_person
    ADD CONSTRAINT contact_person_pkey PRIMARY KEY (person_id);
 L   ALTER TABLE ONLY public.contact_person DROP CONSTRAINT contact_person_pkey;
       public            postgres    false    230                       2606    16523    discount discount_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.discount
    ADD CONSTRAINT discount_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.discount DROP CONSTRAINT discount_pkey;
       public            postgres    false    215                       2606    16530    email email_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.email DROP CONSTRAINT email_pkey;
       public            postgres    false    217            )           2606    16710    ensemble ensemble_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.ensemble
    ADD CONSTRAINT ensemble_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.ensemble DROP CONSTRAINT ensemble_pkey;
       public            postgres    false    237            +           2606    16722    group_lesson group_lesson_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.group_lesson DROP CONSTRAINT group_lesson_pkey;
       public            postgres    false    239            7           2606    16842 (   individual_lesson individual_lesson_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.individual_lesson DROP CONSTRAINT individual_lesson_pkey;
       public            postgres    false    247            !           2606    16629    instructor instructor_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_pkey PRIMARY KEY (person_id);
 D   ALTER TABLE ONLY public.instructor DROP CONSTRAINT instructor_pkey;
       public            postgres    false    231            #           2606    16639 <   instructor_teach_instrument instructor_teach_instrument_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.instructor_teach_instrument
    ADD CONSTRAINT instructor_teach_instrument_pkey PRIMARY KEY (person_id, teach_instrument_id);
 f   ALTER TABLE ONLY public.instructor_teach_instrument DROP CONSTRAINT instructor_teach_instrument_pkey;
       public            postgres    false    232    232                       2606    16537    lesson_price lesson_price_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.lesson_price
    ADD CONSTRAINT lesson_price_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.lesson_price DROP CONSTRAINT lesson_price_pkey;
       public            postgres    false    219                       2606    16551    person_email person_email_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.person_email
    ADD CONSTRAINT person_email_pkey PRIMARY KEY (person_id, email_id);
 H   ALTER TABLE ONLY public.person_email DROP CONSTRAINT person_email_pkey;
       public            postgres    false    222    222                       2606    16546    person person_person_number_key 
   CONSTRAINT     c   ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_person_number_key UNIQUE (person_number);
 I   ALTER TABLE ONLY public.person DROP CONSTRAINT person_person_number_key;
       public            postgres    false    221            %           2606    16654    person_phone person_phone_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.person_phone
    ADD CONSTRAINT person_phone_pkey PRIMARY KEY (person_id, phone_id);
 H   ALTER TABLE ONLY public.person_phone DROP CONSTRAINT person_phone_pkey;
       public            postgres    false    233    233                       2606    16544    person person_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.person DROP CONSTRAINT person_pkey;
       public            postgres    false    221                       2606    16568    phone phone_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.phone
    ADD CONSTRAINT phone_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.phone DROP CONSTRAINT phone_pkey;
       public            postgres    false    224            3           2606    16820 $   rent_instrument rent_instrument_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.rent_instrument
    ADD CONSTRAINT rent_instrument_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.rent_instrument DROP CONSTRAINT rent_instrument_pkey;
       public            postgres    false    244            5           2606    16825    rent rent_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.rent
    ADD CONSTRAINT rent_pkey PRIMARY KEY (rent_instrument_id, person_id);
 8   ALTER TABLE ONLY public.rent DROP CONSTRAINT rent_pkey;
       public            postgres    false    245    245            1           2606    16803    sibling sibling_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.sibling
    ADD CONSTRAINT sibling_pkey PRIMARY KEY (person_id, sibling_id);
 >   ALTER TABLE ONLY public.sibling DROP CONSTRAINT sibling_pkey;
       public            postgres    false    242    242                       2606    16580    student student_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (person_id);
 >   ALTER TABLE ONLY public.student DROP CONSTRAINT student_pkey;
       public            postgres    false    225                       2606    16592 &   teach_instrument teach_instrument_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.teach_instrument
    ADD CONSTRAINT teach_instrument_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.teach_instrument DROP CONSTRAINT teach_instrument_pkey;
       public            postgres    false    227            '           2606    16698    time_slot time_slot_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.time_slot
    ADD CONSTRAINT time_slot_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.time_slot DROP CONSTRAINT time_slot_pkey;
       public            postgres    false    235            ;           2606    16605     booking booking_discount_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_discount_id_fkey FOREIGN KEY (discount_id) REFERENCES public.discount(id);
 J   ALTER TABLE ONLY public.booking DROP CONSTRAINT booking_discount_id_fkey;
       public          postgres    false    215    229    3595            G           2606    16753 1   booking_ensemble booking_ensemble_booking_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.booking_ensemble
    ADD CONSTRAINT booking_ensemble_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.booking(id) ON DELETE CASCADE;
 [   ALTER TABLE ONLY public.booking_ensemble DROP CONSTRAINT booking_ensemble_booking_id_fkey;
       public          postgres    false    3613    240    229            H           2606    16748 2   booking_ensemble booking_ensemble_ensemble_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.booking_ensemble
    ADD CONSTRAINT booking_ensemble_ensemble_id_fkey FOREIGN KEY (ensemble_id) REFERENCES public.ensemble(id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.booking_ensemble DROP CONSTRAINT booking_ensemble_ensemble_id_fkey;
       public          postgres    false    240    237    3625            I           2606    16763 9   booking_group_lesson booking_group_lesson_booking_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.booking_group_lesson
    ADD CONSTRAINT booking_group_lesson_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.booking(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.booking_group_lesson DROP CONSTRAINT booking_group_lesson_booking_id_fkey;
       public          postgres    false    241    229    3613            J           2606    16768 >   booking_group_lesson booking_group_lesson_group_lesson_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.booking_group_lesson
    ADD CONSTRAINT booking_group_lesson_group_lesson_id_fkey FOREIGN KEY (group_lesson_id) REFERENCES public.group_lesson(id) ON DELETE CASCADE;
 h   ALTER TABLE ONLY public.booking_group_lesson DROP CONSTRAINT booking_group_lesson_group_lesson_id_fkey;
       public          postgres    false    241    239    3627            <           2606    16610 $   booking booking_lesson_price_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_lesson_price_id_fkey FOREIGN KEY (lesson_price_id) REFERENCES public.lesson_price(id);
 N   ALTER TABLE ONLY public.booking DROP CONSTRAINT booking_lesson_price_id_fkey;
       public          postgres    false    219    229    3599            =           2606    16600    booking booking_person_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.student(person_id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.booking DROP CONSTRAINT booking_person_id_fkey;
       public          postgres    false    3609    225    229            >           2606    16620 ,   contact_person contact_person_person_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contact_person
    ADD CONSTRAINT contact_person_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.student(person_id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.contact_person DROP CONSTRAINT contact_person_person_id_fkey;
       public          postgres    false    230    3609    225            E           2606    16711 #   ensemble ensemble_time_slot_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ensemble
    ADD CONSTRAINT ensemble_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES public.time_slot(id);
 M   ALTER TABLE ONLY public.ensemble DROP CONSTRAINT ensemble_time_slot_id_fkey;
       public          postgres    false    235    237    3623            F           2606    16723 +   group_lesson group_lesson_time_slot_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES public.time_slot(id);
 U   ALTER TABLE ONLY public.group_lesson DROP CONSTRAINT group_lesson_time_slot_id_fkey;
       public          postgres    false    3623    239    235            O           2606    16848 3   individual_lesson individual_lesson_booking_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.booking(id);
 ]   ALTER TABLE ONLY public.individual_lesson DROP CONSTRAINT individual_lesson_booking_id_fkey;
       public          postgres    false    247    229    3613            P           2606    16843 5   individual_lesson individual_lesson_time_slot_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES public.time_slot(id);
 _   ALTER TABLE ONLY public.individual_lesson DROP CONSTRAINT individual_lesson_time_slot_id_fkey;
       public          postgres    false    235    3623    247            ?           2606    16630 $   instructor instructor_person_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.instructor DROP CONSTRAINT instructor_person_id_fkey;
       public          postgres    false    221    3603    231            @           2606    16640 F   instructor_teach_instrument instructor_teach_instrument_person_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instructor_teach_instrument
    ADD CONSTRAINT instructor_teach_instrument_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.instructor(person_id) ON DELETE CASCADE;
 p   ALTER TABLE ONLY public.instructor_teach_instrument DROP CONSTRAINT instructor_teach_instrument_person_id_fkey;
       public          postgres    false    3617    231    232            A           2606    16645 P   instructor_teach_instrument instructor_teach_instrument_teach_instrument_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instructor_teach_instrument
    ADD CONSTRAINT instructor_teach_instrument_teach_instrument_id_fkey FOREIGN KEY (teach_instrument_id) REFERENCES public.teach_instrument(id) ON DELETE CASCADE;
 z   ALTER TABLE ONLY public.instructor_teach_instrument DROP CONSTRAINT instructor_teach_instrument_teach_instrument_id_fkey;
       public          postgres    false    232    227    3611            8           2606    16557 '   person_email person_email_email_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.person_email
    ADD CONSTRAINT person_email_email_id_fkey FOREIGN KEY (email_id) REFERENCES public.email(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.person_email DROP CONSTRAINT person_email_email_id_fkey;
       public          postgres    false    217    3597    222            9           2606    16552 (   person_email person_email_person_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.person_email
    ADD CONSTRAINT person_email_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.person_email DROP CONSTRAINT person_email_person_id_fkey;
       public          postgres    false    222    3603    221            B           2606    16655 (   person_phone person_phone_person_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.person_phone
    ADD CONSTRAINT person_phone_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.person_phone DROP CONSTRAINT person_phone_person_id_fkey;
       public          postgres    false    221    233    3603            C           2606    16660 '   person_phone person_phone_phone_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.person_phone
    ADD CONSTRAINT person_phone_phone_id_fkey FOREIGN KEY (phone_id) REFERENCES public.phone(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.person_phone DROP CONSTRAINT person_phone_phone_id_fkey;
       public          postgres    false    3607    233    224            M           2606    16831    rent rent_person_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rent
    ADD CONSTRAINT rent_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.student(person_id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.rent DROP CONSTRAINT rent_person_id_fkey;
       public          postgres    false    225    245    3609            N           2606    16826 !   rent rent_rent_instrument_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rent
    ADD CONSTRAINT rent_rent_instrument_id_fkey FOREIGN KEY (rent_instrument_id) REFERENCES public.rent_instrument(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.rent DROP CONSTRAINT rent_rent_instrument_id_fkey;
       public          postgres    false    3635    245    244            K           2606    16804    sibling sibling_person_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sibling
    ADD CONSTRAINT sibling_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.student(person_id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.sibling DROP CONSTRAINT sibling_person_id_fkey;
       public          postgres    false    3609    242    225            L           2606    16809    sibling sibling_sibling_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sibling
    ADD CONSTRAINT sibling_sibling_id_fkey FOREIGN KEY (sibling_id) REFERENCES public.student(person_id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.sibling DROP CONSTRAINT sibling_sibling_id_fkey;
       public          postgres    false    3609    242    225            :           2606    16581    student student_person_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.student DROP CONSTRAINT student_person_id_fkey;
       public          postgres    false    3603    225    221            D           2606    16699 "   time_slot time_slot_person_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.time_slot
    ADD CONSTRAINT time_slot_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.instructor(person_id);
 L   ALTER TABLE ONLY public.time_slot DROP CONSTRAINT time_slot_person_id_fkey;
       public          postgres    false    231    235    3617            �   �  x��ڻn�@��>O�%H�\ΜQQPD�����@hx�E
��+R~�w�יc+w޾�x�{�����ϗ�__}������o��o�?��pyQn/����������|}s�S�40L�`����M��P$�"-��HEr(�C� �Q��z-��EUP���!(MAP�IM�hRD�"�Ѥ�&E4)�I]���"�3jQ�uA!hJAS�� )"���"B�)"���"B�)bH�ZD?���&�
ACP
����I)E��RDJ)E��RDJS���"�,����.(A)h
Z��&H�XRĒ"����%E,)bIK�(�$Q��;�<�v��ծ��j�^VAjз���&����8��&�W)r���(�F�t� 5���5�W^�{�M�U�Jw�H�ܨA�k�J�6�ڨ47�&w�hn4���F�6���Li47ڤkQ}�o��\������F�3�RI�ƤkQAs#h�As#���]4hn��A�hP�v�Agʠ6�1h47���ΔA�Ơ]4iM�E�vѤ3%in$�I�h�.��F�ܘt�L���Ƥ�1��ImL:S&͍I��6���v�E�袹���Egʢ]t�.�h]�F�dn��{���QT5A]Pzy��)h��=�����Q�uA!詈u��)h��=�vϫqTUR�T'�v��a��&�%j�o��յ������N*H��qkUIj�Z��Fj��zXUR�T'��]F���Ij���Inn��<l         �  x����� 5����Ra�N'�$�r1�Q�F�� ��N��� ��Ru�ԩJ���~zy��O߿��߇??��Շϟ�����~��ߏ}����/�|��_�h��K�ʗ_�yV�����'�:\՞�j�U���EW�����U�~]5��W�t��E�&|]T�_��z��V7�(��&�E���3�k����(�����kېz�3��U�ᠫrʓ�WPcҽ��_Gr1�_.c��ƅcr�S~���&�������,6b�J��*k<C/�*��Z��٠.�c.4T�6b���s4�W�aYȪ��~C����Uz^�6i/0Z�{�h����Ð/����S �/������꡿5r���Z��nX6 ,���޲��{�0ߨ���#^��}����i�bнfN�a5���0oX�d��0>�p9�M5�!?�	�t�C�1E1@�Тar?淒\��b�����r��n�^tU�d~`�����1�dÅ^�wq"��d#u/&6I�����r`8���a:������h+�8���;}��ƭh�+m�Q��X� J�,ץX�� 	ʎ��>�#�4\��&��p�2���A]��<��`�л�f`���"�)!%���+4KX�C����W�0�����ä�N}#���#�V��Q�B|��Qj1�c�8�����l�����V�t0��D�Mt��dy�n�9d��0�(�+_f�H�����Hߖ'�e
��eB�W/��U�ڨ�Y"\�ņ8-ǣ0��K|(��D
ƍi�À(&)O7�RB�q�}��
�JS��t�0�
��]��ʯ��Rp��^�_!zx �R�v�`>�j�c��ic�e�7��zB�p�!����2d��_x�e�Rr\xNl��)�p�p*0����aq˼�[L���<^���Pl,�g�������&��y��i4P��E#c�-$�Qj�0"ESaސ��p/�:��|�+�$��S�{�e�7��vj�h\b?ׂP�#ͧ��E��Xb��	Æ0yN��_��5���X$�]#��|��5by,F�Q�GR���U\ィ���������j.2��#�4���|�:�*�r:z��Hg|�RY��XI[S���Q�^�ƾ�H��iy3Zԓ\��`�:-=<�ZL�5#�6�D5uI�;�<�o��0%e`���w%�5�OG����b+�����v������f E1�\�����z]�^͌���X�<1�[F�nJ�֢6���n:=��T������f�^���n4}Iņ��Լ�)1ט濒���w��xR���MR.��`4ƚn��/8(#m`R�L1��ⷣս��dܣ�t���N�lt�N�GrW�F,���x�N�5�̫�q��D��~}{%��˨)V����`\Ky�.��gV5�rDJ,�w5.�N�^�x�FM�#)���w��)IjxT���J�:#������{��Ӄ]����g�������J����o��k�B�|N��m��t���a��.��n	����7����pS�/D��b��F�+J��
_�tb5�uz�X4�+.��f��6nu׶��N��9JP��W�F<0�E��c�λLŦ�?��y�@h�!,_�*���0{=J_;en�gt@]��M���X�>	�ϰ��bz,*���H��yI�8�O��d8%E(�NyC�Q��F���r�*��Qxj��r�_q��w�xX�5��� ,��e�ռ�c켄��6�XW�~����-kNrTrYS-}���q^~}[�=��lQ}�\.�]���l�K�����S��qy�ek渜����J1�)0�u�P�z�����^F��m/^��	�S�c��5������9��W��q,�1�PC]�<* ~��G��F�3%��Z����]u{3���,RWm�^�^�nF��������4���!68�cy���y�  ~��<���K�d�Ga�'09\f�ǰ� ����_M�������6��R�h:�Xr<�^���6B�߼�j�         `  x���K����W���~�[d�������!�kb���J+��R��N�s����o���w����o�����?��O?|��~�������_���߿��嗏�����ۏ?�v}����W���{��M�,�+��������sʣ5�j��g�ڰ��O��՞ܟ>���m�KG,�G㭓-�P[�Yz7���k���3�Ǧ:6%�R��|�Yz�����^�ٵQ>o���Q��ـ͆y�Y�]|J�uѣw5��:���=b����P;E����	�Y�6����l���;�Z�z�����Zb�[W��V5Bo��oݶ�;��A��ijE��Ը�5n?���=j��ܺ�� ���$��*4�?�m�<U$ �T�8UD<�TQ9U��T�k�7��%��^L2͓��Ifr��,nI&O9&��I&6�2,��Ny$xj���2�u{�3�m�0����Sxa2�y8Å��0�.�[�>ȢY,L5f�2�^6I��F�I�j�&)���4|�6ORV_X-F�G")W�	�n[��Nj�ՆQ	����ϊϨ�����W��y��O$LJ���||����L�ǿ5��ǘo�����g=d||�3[����X<�}4���L�o�X�dl��r��3SR�)�ʔ�H���Nw,�;���]9�$B���7s��8�ƜE��,&s��������m�XV<47�ɤr��p�۽v�Z����&�k�zP�U�JW%������~�*^��JW%����UI9p	-w	�J���������U�v�P᪤pU�Um�X�đa��U���$ X�J�MBIK�PWB�+��+�������4[��"*��,j��kq�չ��^����B	�����n?�MX�z�mw&Y`Y^u�..��5]��]��\�YZΤ~��Ls�er��h�<X.Z4/�7��E��M՛���˃�˃��A�3o��Oe��Л����z���oG�AsqO��$9�a��Fˡ�9�-D��F��F��FKw�Ww�Ww�6ZfB�~><5MQ~9����U7Z�;�o����A�p�c0ȿ�)�v����=�f��v{��D��p{:���_���G�{v���K���I�����H}9�^�T��3+��E۩�C��P��'�b�z3�.��'��,J��8|]LR&�7[n�3���s�A�8S�8S��rй���r@�6��L��,����$�=���$ ��M����Mr�_�N�9Fo �zsL��_$0Nn�A�w;=���b�؝i��ۀ���Owv��ߎ|73̓��=c�=�8Ӽ�i�~oL����x�9�^N/���񝡺�7wǻ)$9j��4�^���I�w6w�J��ԗ4�Ij/h�+J�@8���y�[g���R��2�:o�/�>���Т�Gԧ�ԓ9���ge������ �a����iY�y�	��J���g6� ��{��B���,U��9���d�'[a��3a��;i���N�G��ۄQ�i��ؒw��X�G���L�&]�,��4�T%6p�[���jK�<jA)�T�c����
�����8�@�	��{yd�/�jY5v�� �'հGƇao�Z�rM�,����m;"��5�?k̰U�1V�9K�س��f)9���vDL0��f<yD4��<��k
�<���5��e�I�B˓T��f��M،i���/Ͷ<��{kBJJ����[�����B���,O~�5��U+l^ k{)�8�ݶR���_	,v�Pɐ����!�)/Qû��Cc"QN�嚄�����L���&xT�zV��#c�K�~�W(1�R1��Km+eqm�-�wأٟb�ne[Ԭ�����$��qR�/L��fkڳBf�Ԍ�ɑZ`��k{�ю��2�#���m��^���0WX͍�	�w�xǊ!���P^]$|q��f1�\8���)�wp�&�*j�"p�}o�;���Df�8�o�?�b՗��f7�'mI�ca;MC�+�ͰzrB���x��s�̧_�>��>�H��>��>��f��f�LX�57kt6k4w\�M\���h���x��İCc�DN�]}o9��U���r�å�,�Pz�l~�G��0���e�s3?$}�sd懄Xh~�l~hn~�����t�!��n~�n~n~�n~������P���%9���:���*����7�^�$`4?7?45?47?��Kk5?L6?$_�6�.6;�Q���d���^��f߅.P�� 	iS/�k�P8�K�j�^¡b=�KP�K��Kp�� '��!����W����6&���+"5746d��;
��`���bЂ�[UC@����n�l�l�E���! ��J�7:^��~c5,5��ٍg�G)���?\�/*�ND�
M��퀲�pY��ߋk�X֟,�v�EY������
	B�A�U�Ue�l�f����I"P_~}C����y�-�L��!k��~}�dG@���;6_ߐ���/aH:�(�P�0�����&�͎�4� ���!t�a�%�>��������k�1Ml�4�K5�~���p�P>Y(;�ġ�z�P�\(�*���	vt�P�J�u�B�T�<�r�%��P~�P�����B�d�<&	o	,Y�9�7���%�����K�՛�+7���t�]�.�v������]��7�8��������5�ʚuw�z�f=��}�f}y�{�&��5��ua��bͺs{��Do.<O��ϩBx��Ak��'�X,<��ϗυ��������������������d�8���Oր�k�]��_Û�P��b�z\X=λ��?���b	����?{��{�;]����^��6Vcc��d]U���`��م�(�;�ź�;Y����6�b_���3OZ�UP�.�zwv�'�ug���P�U��*nV�`u����=�>����[3#����E�ŗ�O��~�� �}�S��o�p�k��5��n�>����E�\�=�$~��{��{��{{���f��5���b�{��v%v�����xz�����v�>�����Zls-����N�,�f>w]���ۘ�YD[�����z�vp>p�z�]�-.�V�q;˸���Ke������;�Q%�]ƭ~�˸����Ra������.�.F����l{[����{7�_\�ߖ�����6���[=\glܦ�Y�l~��d�11�K�3v�;�~��khq	���+�ci����%��WHW�5��n������N���&�=�1Q��1��D�td�K[p��5+�H�%���~���d,Mp�6�y��tĪZA3����Z��ɱ��G��tUQ|I���)��h210/����&�Ļ�������LbY��O�6�d@)7�|x�)o��i�!��m���+�2���ld����Mp~/�F��D����(il;<_����c�h��t˩�D����O�9®�Ą���v,��ϓQ���/L��& ��Ɠ����s�ʏ��
�Q���؉���¢ra�5�����dZ��h^X4.,r/aa������Ȱm�E_,,���ŅE_^XL/,..,⃭:Hxep{su���yC���7���!�d���B�K!~,*B��%����<3�;�B����7C���8Ŀ�o���%�|����2�O�d�t(ď<a?�T���;�_�7C�����~;�_�B�<��C�$^�W��� �����d����V�? �f�CU(N�IB�������� 2���vu�}9ھm7Gۃ�va�}3ڞ��#�#d�|�s�˹���vS��43�Wf�#�wv��DD���b�;��Vb4;l����v�Auv�fv�;;��ɢ��Hv��I��a��c;�X;*Î��u��a�b��2U�1�nF��5~(b�ӆ�ũ:V�# Pu��.��b��o�����A�      �     x����N1�=Oqwhb�����A� .M-W��tH;�����qgw��|9���٢|^�d���n�n��ԍk�n�v�C�`5~|)p�]����
?���H2Ny�)�_&��d���|+�7*�X.eAI���1{�[l����`��=QPI�L��;C0S�şnB�(i���c[+��Z���^�X�%z$�˃r��!���؃$Vd2O�_���=Hs��'�,��M0��;���џ<!XFW�������*������$uW�8j{��j�5����{Q�/d��C      �   6   x���v
Q���W((M��L�K�,N�/�+Qs�	uV�0�Q02д��� Ui�      �   $  x����N�0E����
hy�MXt	��S{H-�L�Ϥ�a�����9n6��ˮl6��O{k�Cc˷ǧ���<�.�E �Td��FYN:����+���Z
�-v����q|��s-9d�Q��[���o����;R5��.�Z	����s6t#�=�`��"o�T^*��~�Q��	<$�t�K:e��B~���-�cC�G�.�b�%7��ȝ[�rI��5��$����Q,�fH(r%@%;��ⲃF��ɚ �Zt�}O�_�T˟r�2���t5�ݼ�duQ|�B$         ^  x����jAE����B#]�W�]�+�,F$B�'�,��n��F����y�˩TnN�������~���~�z<=�����O��˻����Wer�q���q�z5e~�v�ɸ$?<<?�$c�ɗX��?Yf�m0�$�P�QJ]$�)�_��O����o���K��/v��29�Jɥl�1atl�+&�Ms�(-݊��R��E�������]�"1}��W�ױ�ڱ�����mͰ�Bk�Z3�Кa��X,�ŢksWw��c9II�Ĳl��Xb[nb��<���R���f�:��.�J,��v%6Xv�j��}%�W�j%vWw%vW��1���V��*g�֪�ZX\U���U96Wq%W�jak�I�x㊵*�V�jUl���{.s�Y���7H3�sg9�f�c���m�=E�R��R�,Պ	sͪ�\��1ڬz�v��h)XF��J��ŕ�k&=�.~�S��k�k�+�b`w-f�c��k�<��oF����y��vawuqW`wu3�1�}-&�W7{�͞�\iWbqu3�1׌y��Ņ��͘��U��j�<�1��f�c����<F�1��Z-l�Ռy�u��H,�2�w1���dF=��U��������           x����n�6@������B3�$=�hZ(ҢIz-�x�pֆ��nz�P҈3���W>G���7�~{�z������_w����x������ӧ��Ꮧ��{���Mzq8��^���t�����������������������~��*o������t�%������K�"�Aք�$�8�s������7�\��o���͗H&��X������ߟ��1�h�'�*�'�0�*���2��K��Dk���R?����6!�q��� 'pF��8#��X���8$EE����^E�F^�+ʀ��?Z^v�+����"���TEh�,6nExVj��M��2F;Z���A�H~jrF� "2G2��>��P� w$+96�� ��)�$�)�AI^� �d+Q�h��H�E0�f�c��)H6�crD�@���R�lm��rI$����m�����S'(Z�����h��]Q��Ѫ?;�v�h���ܒ��~T
��1��+Z��@z��~�����uM���kv,��u!�HL�26O9#>u�;"�d����#��[�&ք�Fw�b�ܱΈo͕1�2�0b���{4�*a���hc!.��F`�6HD)����6�D���VQDf/-�!2C����ϕy���(A�(�dd��n��DI�)�QـDQ|Q2Eq2i����Q��@�(~}!�u��vH5p��<Q��S��F��;��MɌ�Ԧ�E�N���VNo�������tQE��;[�M�Me�)03��Ab�� 2�
Q������#2x�8�3�d���'��4"C��P����5Z�E��͇ b�6���^ �Ք�Dd��R:!	��{��L b���C*�@[:!�2XGDB1��3h�)1�ZNf���3��_�H�M���;2��gH�V�z�A��i�33Aӭ��C������_�Qv�3��%бN�-)���b��7�_�g���Kf~I�R#3��~�d���Jfni��?>>}�d��Ŷ�����G�V�o�1��ed����F�3��0��o���'w�̌.����Ngc�� ��E[f����mS�5���R]�`w`��;�sՉ����n��F�l�&�o��y͏q�T拾�,�����E4�l���䧊0�4��݈�,��+�.�3reӵ`|�|a^��,!�/�'L*��'�&{��M?1��|aj��1ar���i��X�hs�1��L0��0�3��L0��[�]dq�1��~�L1�؄�|L-�Pˢ���|�(�J1����}�(SK12e�a|�,az)�	c��-�TS��ig8SL5�e�$A|��K��Rw����ZU~{�ȼR��I�-�_�'�꼥��P��K�)M��Z SJ����Vtp�r$��k�/Z-0ؚD~ѡ_�$�m�����\���;8�?KH0��'$����]g��#��2�J쵕�D���~F�Q��e�m�]F�����9*~e�m�����<�G%�a��D�\B���j�Bo�#��o��.Ҁa��L�ѹ�>1>��?3��G�U�%��L³��m������E.��ѹ�(#�d�YF�~���9ŋ(�sN�D����������"m|a���o"2H_!�i��H�.zQD'M��[��m����l���?9��ӽ��y�}ma�����Hax�!Xax�S�������Ȍ�X藡vW20@?5D��}�D�dm�Z�)Y��1�"f������E�K��Й�l��Z��{��?�H��         w  x���Ak1�{~��܂)��F����b(i��\����!�C~�zj�g������y�o%�W���w������x����̇��2oϛ������x�?|�Y���x�O��E�iu8�~���뿗i\��W+&2ő�����[f6�đ�ea#%�̽���5������-�,�ec#5��-���0RzKc#�0G���4ҡ1�
@��)&Tє64ň�Ҋ��QCS��CR4�%M1%ES��c24�5M1'CS����MiQ)%#^���Q����xq��W�$�0�?���r��O�hN����Ik�R�gf��1�I�����Ԣ̂�4��a&zҒ�E���4$����3ӎr����v�CG=��]訡'�(��zҎr�Hѓv�CG����:2���Б�'�(G�dDO�Q���{��<�����������esx�m��:3E��ZhG%�����J�)�I;�q �DO���~fEO��X������QfCO�Q�0=iG8_������i�)�#	zҎ$td�I;�ȑ���O"G2�'�H"G�c�Ў$r$8A	�H"G�ݾЎ$r$؝
��F���J;��m�n>����RiCx;^�ÊRi?5�y�G۩�˃�J�����C?~DW�<܉J{����mu9�������~��.�i��h����_�}4ׇ����>�h��!#��>��CF��}4χ`"�����C08k����Lx��y>ӈF�Pχ�䬴�{b�G`�^]i ��@�Ϧ�B4��hH���i#*~ �H����+�D����w<�bj��5?i(6���-�\)����+%�m�s�d��b��a��b�l���b����b�lu��b�����K�bc��M�O��~�G^]��a܍      �   O   x���v
Q���W((M��L���+.)*M.�/Rs�	uV�0�Q 
�jZsy�ވD��:
i�9��k0!U�)B ��M,      �   r   x���v
Q���W((M��L���+.)*M.�/�/IMLΈ���(�9���+h�(jZsy��ۘ|�F��mD�nc��6���@ݦ��6�Q0�H7evS���)�n.. �s��      �   �   x���=�0�=�"�-��g;t��(��Z�9� �����C]�����=Q���⢨�|����a{z��홗|x��pFe�\��E"0nN�pa�O*�PH��	\N��d�I5Kj@�9�R�ܚ��~���-�U��K:-�E+���2�]��i�������      �   �  x��T�N1��W�Vb���VW	�GEBDhڭ�1��d&�L������^;"b�����{�j<������V�����mSì�u8�����ۍw��7�v�8���B�j!�\�1�5��Ue��q��ō�B� ����|t�_D��O+_w�vi��2�A����\i��\Q�)AL�uU�n#r�aT�8m����/\6�l(Ჹ�of�/1��Ĺa��E@>J�e/�1#������U��ah<ViC�L������5�D�TadN2�3�>���&.��T����i���x��-]�6�?ILM9j��؁Nz7=4�ASyJS#�¬�Ҙ7׊�_7s[����6=�͕d��
�*�RK۝�P+^�M��O���JU����s��4�II�1j�H�IF���4�v/�b���<��~��FM[�D+C�*�)�*	�4�87
f��]�uHPK�֐<g����.]*���L+)^��p�ES�ĕ.��:��,�n��.,�>��QJ_��GŃ-KW��h�1�\"uƕ�1��u��)C3�96���t���<�H����!e0�����+z�yj�nW�g�z`�Co���$�b�RL%f��\��"�9I$��+�1�����Q���@iIlD�.��y�b�B�W�4K�J��n`�7x9�v�c�H2 v�y�}n�=���\ǠE���h(t�&T띶�fؤr8C�_�X+��{`c_���e��5&/�)����ċ�	�3Nu�}�Z�u�.7�1Q|t���$      �   �   x���;
�PD���bJ?��;XY�� L����!���فӟS}��S��G���4>��|ޯ��.�ù鰡����?�ĐyjH�<3dB�r!/����R�+C%䵡r��)V�V�e��bˀKE����/0Wa�~!��M      �   �   x��ѻ
�@D�~�bJ����,R,Hm%A�E��ݼ�ӟS}���� �'����|����,�-L�<�z8^���;�g�R!����\�C!䥡��P	ym���14B�$:%ʰ�*���Tlq��2�R�e�*�����[      �   �   x���M
�0��}O�]D2��+�\tQ�
�z EP���[M���|y�~hc��q���q�����y����a�PG�D�P�^n���L�}$�S�IU\�2�(�.4�]D2��ܐ�h&0�Ŭ,�	M|�o2���$��lX	��2���m�3% "A��3� 4%c��P F�>SPM0G�5U���      
   h   x���v
Q���W((M��L�+J�+Qs�	uV�0�Q��QP��/S�Q0�Q()*Mմ��$��DG�� ��%5�/-1����@�@;���KH�hhՉ�T.. ͜>�      	   �   x���M� ���>��
"�ض�NA/,��U�)���͍���O=� ����P���l�ۓt�ߐJ_rq��\���U��,�q�:�2҆.i͹���%�f\h��;� ����⨾���Ȝ=��ݙ�h��pTܠ���qT�5x�bGm���8i�]⤑=�Y���r���x�i�� �*A����y2u��:�ؗ���[k�kŭ��"���l��GQ�ƌ=��^J�!���g���Xk�         U   x���v
Q���W((M��L�+�Ry�
a�>���
f:
��\�D�� N�9)*͈SiA�;-�6�RG�Ѐ8��:
�@�\\ �=b�      �   w   x���v
Q���W((M��L�+.)MI�+Qs�	uV�0�QPOJM���K-R״��$�Ŝt-�k�$]��POf^IjQnjJfbI*����gD�>c��Ĕ�ļ��b�����M #a��      �   r   x���v
Q���W((M��L�+IMLΈ��+.)*�M�+Qs�	uV�0�QPw/�,I,R״��$A�Pg@fb^>���]�bŤj4jt�)-I%U�)PcpbE~AF~X3 ��]             x���O�,7����H��U��ݰb�œP�H`	�"RH���x���)35�z��,���z��v�9U�O�}��~�}��?���������~��O�������������?����o�����k-�o�o�ߤ����_��wя˯�է�z;������N�W��z�;�߻�xhx��^����z�_��x�דGy�\�.�Bt��\��DC�%���b����b�|�zy�\�e��-'e�A~�Ȳ�}m��~__�c�o_vK!��z��=���߫�\}���WW���z�?�G�[�s�����/7��/�/XN�r6�?���������y����}+r+w�����?�&����n���^y��V���������t��n=>֫��T9������s�aM>�o{�r����֓�V������z��Ҽ��h���[!�[;χ����yl�_����}��r����8���q�_j�����y��wo�0��q>ʘ���L���wx�K�GW����28���U�o�7h�}�~&�G�^��[���8<*�zqx����������_��Z�����o��&p~��Uy~��<6���\��U������
���:�-��F�W�?)7}~~�<v��z��H�jC�1�����y����k�?�>
�Ww���~	��O���~a��]��
�c��}����y�xH��e��i?d�g?�ylp�*���;�U����p~����{�<N�������@�1���y��|��Ҽ�2�c��=�/�c����o�����9��ǌ��1�~���o��9ͳ�qh?�z,��|��z��0����Η�W���q(�7>*���ūa���yt{~��_���E��x�����Q2�8���8�{�W��>�?-��3` �Yviѥ�!�L�׹���[�pg	�cI9��#��^ZR�˚V���R6؆3�A�M��8������mC�R���Or��ɓ��m�"ח�C�l5O��C�
��`Bim��E�t�H��kx�t�yRe�ˡ�R
J"w�¦E�&��8�X��6q(���W@Q�)�/tn�8m��rn�Tg捽�Cw&��M��(R�=OʘF��EѦH寯��{�t�Q��}ݡ���8�����TT�*�b?S������p8P�̤-{R�QI:�ZIœ2�C2,��)J�����OV��7�t���8�f�����8���q۰�����q�Q��ʪ�S�K����񈿟_�	(KB�-��Sq�_�g�cD/����#GO�St��C�E����Y�D�%F��.�P0N�y/���X��w	(kf��)ݪނ	(&�/�v"�q�0e��u��P6�)~V$Qx��Wq/�8�#���%��'�>d��l&N���"F��H���)��ݍ��b��*Vv��gV�5�;�� �7B�=�q6v
(��q۰��)�O�����O�a��a��SZ���/�)������Ŧ8x
���"��(�3�c��$__$1�P��S��K@���CJ��p�T�����$��'��H�%����{ކu�Vv���)ͿLġ��/d�Fy���0��,�̞#ϫ+�'�`}�4R��?LD��P��d��4�%v��PL�۳�!:5zyw�Ɉ^*�~P������/X�H��(h��.&޳W0�u�Y���t�4�����m��`PL���m�bN�򍔧F�����"�n�n�4E�����m�<�%VA�kv�P��)�nR�跙�����N��$��������SY�/6K��'�C��6���"����W^�q�*�)��ġ�9)n �}{dEH=E�G?o��r���q���K��oHz_zj��i(xR���DwY����U1N�����g�8��	�k��%֊m�S����M�Yb2xT����.??z	(�}��門bZ�}U<)���}iÈ�~98?9����`�Pf�+߮���}����"���u8PL���E	(�%.nK^
z_���W��a��v��SK���-wHK
h���A��α�/�&K�VUštS!y�r�v�)����|�6�LW����K�/�<jǺ���b�l�nlVOQ�!/�D�L�W����� q(�)�z	(��� ����Vݫ[����z��}�	(xR.h��'I�/d�,V�wkK1K,�l�8���dZ
h���r`��v�rA��c�cqu�lx,n�=e��W�b<�����6e7��Y�C%.(�ցS��HH�)�sq(��Zb��� �MH�O���}����$��[����y�k,q
�
�c�%v�^�a�w��Ή��Fy��E����3q(����)��fqG6&���:�	(fH�D�f����&��,�+�$��'�=����U���]�!�Ԃ�\�ӟ,��k�}�0>���Y�lN�ѻjE
Nc�|�R��6Q&��y<)Z�,q-�<����W���s`S�UL��;o;�h����S�`�"n�|
h����cS=q����F�zj�/'3'��jw&F���]q!EM��դ�P�Tݻg9�H��ܣ��&�W��Wm��b뾪b�,�%E�����{�	(��˭�L@�8��C�PX�W+�PL�̴�6���m̏C�k';4���F2N������3K��(L@�
Iu=��������[O@1��\W$�����mJ36������tJ��`��j3=�����YN@���/hL@��'��P��kF�d�6<)�Yj�8�OUš����ƎC��qw8|J_��l�v�y�`�A��B�դP�d<Ὧ�Yb��?�t��n	(����_�C�}��U7��������EPq(z_~�Zʆޗ�u�	(��O�O@A��K�	(k��o8lU��x�h��Y�Cٍ�"|���Yb�nD��2��m^�Cٍ�X麯�c'�_����,~�`��)��f�;���S.P0K\��q(�]P�]�� ���:0K<���b�:����V�@��қ���W����ɴ��2\���T>xX!9[e��z�y_�j�b4����P�{���8����2�ī����͊$�`�knl��:���	���<�I�3�m^K@1��ON��hf����Su�i�����W+��E�V��	W�N@��/�[!Z����?��
VHN=�}���,q�E�VL��OǡX�^��"K�=;���R!�&$��/q�d�C�}�����#}�N�&�B��)M�籸I��}wjG����t꾙>z�GK5]^��_�5}�~KN��ə�`O��������X�2xX��f���l�夰�5E�2]b���a��u_��M����}�R���S�q(��ޯO<�m��]��b�觳DF���	�<6�G�f8P��)n�[��S�Av	(K��MH6����ҏ�7������L������G���ְBR\�'��}�Q@
V�̧�Y龎�GWM@�
I?^N@A�r���ĉ+l
h�ǋ�'q(]���m���;�#�/S�X��u�����	(F��[�[_k�Ʉd��}���j}��Ǧ�ۆ6���{�1�q(fֽ��V�fr_�ۥq(���>枀���\m3�B�%�	(��ѭO@1/���P��XyC���܎C1o���G���ݍ��_��hS�}/ ��)�Yv���v$���}�0���^�	(��ޭ?�CX�R�( e���z
�ѿON&[��X^����a"z�rH@1���ڹS�R�b�6���6�'��I�,���@���`���)|�D3���iZq(F�/n��bgݻaE���w�p&�����;z	(楡�O�&K|�M1�ѫ[����6eV��6��^ݙa(�κڦ��V��P:̺�N����{��I��tWzn7�4Rd���� u�������:̺�+���S�.([��D�l'W����c@���Yؓb������v���M@1���}uY�O!���h���"�v1�#?��Y��aq(F��CQ3C�}Y#EQy�Gġ�Y��!K��by��e�7[b���ܦ���bk��z�����}�u_� $   ����C1}q{+�P�{�|B��f�ዺ����/�ϖ�     