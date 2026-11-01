--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

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

ALTER TABLE IF EXISTS ONLY public.game_platforms DROP CONSTRAINT IF EXISTS game_platforms_platform_name_fkey;
ALTER TABLE IF EXISTS ONLY public.game_platforms DROP CONSTRAINT IF EXISTS game_platforms_game_id_fkey;
ALTER TABLE IF EXISTS ONLY public.platforms DROP CONSTRAINT IF EXISTS platforms_pkey;
ALTER TABLE IF EXISTS ONLY public.games DROP CONSTRAINT IF EXISTS games_pkey;
ALTER TABLE IF EXISTS ONLY public.game_platforms DROP CONSTRAINT IF EXISTS game_platforms_pkey;
ALTER TABLE IF EXISTS public.games ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.platforms;
DROP SEQUENCE IF EXISTS public.games_id_seq;
DROP TABLE IF EXISTS public.games;
DROP TABLE IF EXISTS public.game_platforms;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: game_platforms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_platforms (
    game_id integer NOT NULL,
    platform_name character varying(50) NOT NULL,
    release_date date NOT NULL,
    metacritic_score integer,
    CONSTRAINT game_platforms_metacritic_score_check CHECK (((metacritic_score >= 0) AND (metacritic_score <= 100)))
);


--
-- Name: games; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.games (
    id integer NOT NULL,
    title character varying(150) NOT NULL,
    publisher character varying(100) NOT NULL,
    developer character varying(100) NOT NULL,
    genre character varying(50) NOT NULL,
    launch_price_usd numeric(5,2) NOT NULL,
    pegi_rating integer NOT NULL,
    game_engine character varying(100) NOT NULL,
    multiplayer boolean NOT NULL,
    CONSTRAINT games_pegi_rating_check CHECK ((pegi_rating = ANY (ARRAY[3, 7, 12, 16, 18])))
);


--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.games_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.games_id_seq OWNED BY public.games.id;


--
-- Name: platforms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.platforms (
    name character varying(50) NOT NULL
);


--
-- Name: games id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.games ALTER COLUMN id SET DEFAULT nextval('public.games_id_seq'::regclass);


--
-- Data for Name: game_platforms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.game_platforms (game_id, platform_name, release_date, metacritic_score) FROM stdin;
1	PC	2015-05-19	93
1	PlayStation 4	2015-05-19	92
1	Xbox One	2015-05-19	91
1	Nintendo Switch	2019-10-15	85
1	PlayStation 5	2022-12-14	94
1	Xbox Series X/S	2022-12-14	94
2	PC	2011-11-11	94
2	PlayStation 3	2011-11-11	92
2	Xbox 360	2011-11-11	96
3	PC	2015-11-10	84
3	PlayStation 4	2015-11-10	87
3	Xbox One	2015-11-10	88
3	PlayStation 5	2024-04-25	\N
3	Xbox Series X/S	2024-04-25	\N
4	PC	2018-03-27	78
4	PlayStation 4	2018-03-27	81
4	Xbox One	2018-03-27	82
5	PC	2020-12-10	86
5	PlayStation 4	2020-12-10	57
5	Xbox One	2020-12-10	61
5	PlayStation 5	2022-02-15	75
5	Xbox Series X/S	2022-02-15	87
5	Nintendo Switch 2	2025-06-05	\N
6	PC	2022-02-25	94
6	PlayStation 4	2022-02-25	\N
6	PlayStation 5	2022-02-25	96
6	Xbox One	2022-02-25	\N
6	Xbox Series X/S	2022-02-25	96
6	Nintendo Switch 2	2026-08-28	\N
7	PlayStation 4	2018-10-26	97
7	Xbox One	2018-10-26	97
7	PC	2019-11-05	93
8	PlayStation 3	2013-09-17	97
8	Xbox 360	2013-09-17	97
8	PlayStation 4	2014-11-18	97
8	Xbox One	2014-11-18	97
8	PC	2015-04-14	96
8	PlayStation 5	2022-03-15	81
8	Xbox Series X/S	2022-03-15	79
9	PC	2016-05-13	85
9	PlayStation 4	2016-05-13	85
9	Xbox One	2016-05-13	87
9	Nintendo Switch	2017-11-10	79
10	PlayStation 4	2017-02-28	89
10	PC	2020-08-07	84
\.


--
-- Data for Name: games; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.games (id, title, publisher, developer, genre, launch_price_usd, pegi_rating, game_engine, multiplayer) FROM stdin;
1	The Witcher 3: Wild Hunt	CD Projekt	CD Projekt Red	Action RPG	59.99	18	REDengine 3	f
2	The Elder Scrolls V: Skyrim	Bethesda Softworks	Bethesda Game Studios	Action RPG	59.99	18	Creation Engine	f
3	Fallout 4	Bethesda Softworks	Bethesda Game Studios	Action RPG	59.99	18	Creation Engine	f
4	Far Cry 5	Ubisoft	Ubisoft Montreal	FPS	59.99	18	Dunia Engine 2	t
5	Cyberpunk 2077	CD Projekt	CD Projekt Red	Action RPG	59.99	18	REDengine 4	f
6	Elden Ring	Bandai Namco Entertainment	FromSoftware	Action RPG	59.99	16	Dantelion Engine	t
7	Red Dead Redemption 2	Rockstar Games	Rockstar Studios	Action-adventure	59.99	18	RAGE	t
8	Grand Theft Auto V	Rockstar Games	Rockstar North	Action-adventure	59.99	18	RAGE	t
9	DOOM (2016)	Bethesda Softworks	id Software	FPS	59.99	18	id Tech 6	t
10	Horizon Zero Dawn	Sony Interactive Entertainment	Guerrilla Games	Action RPG	59.99	16	Decima	f
\.


--
-- Data for Name: platforms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.platforms (name) FROM stdin;
PC
PlayStation 3
PlayStation 4
PlayStation 5
Xbox One
Xbox 360
Xbox Series X/S
Nintendo Switch
Nintendo Switch 2
\.


--
-- Name: games_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.games_id_seq', 10, true);


--
-- Name: game_platforms game_platforms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_platforms
    ADD CONSTRAINT game_platforms_pkey PRIMARY KEY (game_id, platform_name);


--
-- Name: games games_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: platforms platforms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platforms
    ADD CONSTRAINT platforms_pkey PRIMARY KEY (name);


--
-- Name: game_platforms game_platforms_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_platforms
    ADD CONSTRAINT game_platforms_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.games(id) ON DELETE CASCADE;


--
-- Name: game_platforms game_platforms_platform_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_platforms
    ADD CONSTRAINT game_platforms_platform_name_fkey FOREIGN KEY (platform_name) REFERENCES public.platforms(name);


--
-- PostgreSQL database dump complete
--

