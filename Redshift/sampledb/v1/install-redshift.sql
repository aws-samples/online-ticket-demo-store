CREATE SCHEMA dms_sample;

-- ------------ Write CREATE-TABLE-stage scripts -----------

CREATE TABLE dms_sample.mlb_data(
    mlb_id double precision,
    mlb_name character varying(30),
    mlb_pos character varying(30),
    mlb_team character varying(30),
    mlb_team_long character varying(30),
    bats character varying(30),
    throws character varying(30),
    birth_year character varying(30),
    bp_id double precision,
    bref_id character varying(30),
    bref_name character varying(30),
    cbs_id character varying(30),
    cbs_name character varying(30),
    cbs_pos character varying(30),
    espn_id double precision,
    espn_name character varying(30),
    espn_pos character varying(30),
    fg_id character varying(30),
    fg_name character varying(30),
    lahman_id character varying(30),
    nfbc_id double precision,
    nfbc_name character varying(30),
    nfbc_pos character varying(30),
    retro_id character varying(30),
    retro_name character varying(30),
    debut character varying(30),
    yahoo_id double precision,
    yahoo_name character varying(30),
    yahoo_pos character varying(30),
    mlb_depth character varying(30)
);

CREATE TABLE dms_sample.name_data(
    name_type character varying(15) NOT NULL,
    name character varying(45) NOT NULL
);

CREATE TABLE dms_sample.nfl_data(
    position character varying(5),
    player_number numeric(3,0),
    name character varying(40),
    status character varying(10),
    stat1 character varying(10),
    stat1_val character varying(10),
    stat2 character varying(10),
    stat2_val character varying(10),
    stat3 character varying(10),
    stat3_val character varying(10),
    stat4 character varying(10),
    stat4_val character varying(10),
    team character varying(10)
);

CREATE TABLE dms_sample.nfl_stadium_data(
    stadium character varying(60),
    seating_capacity double precision,
    location character varying(40),
    surface character varying(80),
    roof character varying(30),
    team character varying(40),
    opened character varying(10),
    sport_location_id double precision
);

CREATE TABLE dms_sample.person(
    id double precision NOT NULL,
    full_name character varying(60) NOT NULL,
    last_name character varying(30),
    first_name character varying(30),
    provincia character varying(30)
);

CREATE TABLE dms_sample.player(
    id double precision NOT NULL,
    sport_team_id double precision NOT NULL,
    last_name character varying(30),
    first_name character varying(30),
    full_name character varying(30)
);

CREATE TABLE dms_sample.seat(
    sport_location_id double precision NOT NULL,
    seat_level numeric(1,0) NOT NULL,
    seat_section character varying(15) NOT NULL,
    seat_row character varying(10) NOT NULL,
    seat character varying(10) NOT NULL,
    seat_type character varying(15)
);

CREATE TABLE dms_sample.seat_type(
    name character varying(15) NOT NULL,
    description character varying(120),
    relative_quality numeric(2,0)
);

CREATE TABLE dms_sample.sport_division(
    sport_type_name character varying(15) NOT NULL,
    sport_league_short_name character varying(10) NOT NULL,
    short_name character varying(10) NOT NULL,
    long_name character varying(60),
    description character varying(120)
);

CREATE TABLE dms_sample.sport_league(
    sport_type_name character varying(15) NOT NULL,
    short_name character varying(10) NOT NULL,
    long_name character varying(60) NOT NULL,
    description character varying(120)
);

CREATE TABLE dms_sample.sport_location(
    id numeric(3,0) NOT NULL,
    name character varying(60) NOT NULL,
    city character varying(60) NOT NULL,
    seating_capacity numeric(7,0),
    levels numeric(1,0),
    sections numeric(4,0)
);

CREATE TABLE dms_sample.sport_team(
    id double precision NOT NULL,
    name character varying(30) NOT NULL,
    abbreviated_name character varying(10),
    home_field_id numeric(3,0),
    sport_type_name character varying(15) NOT NULL,
    sport_league_short_name character varying(10) NOT NULL,
    sport_division_short_name character varying(10)
);

CREATE TABLE dms_sample.sport_type(
    name character varying(15) NOT NULL,
    description character varying(120)
);

CREATE TABLE dms_sample.sporting_event(
    id bigint NOT NULL,
    sport_type_name character varying(15) NOT NULL,
    home_team_id integer NOT NULL,
    away_team_id integer NOT NULL,
    location_id smallint NOT NULL,
    start_date_time TIMESTAMP without time zone NOT NULL,
    start_date date NOT NULL,
    sold_out smallint NOT NULL DEFAULT 0
);

CREATE TABLE dms_sample.sporting_event_ticket(
    id double precision NOT NULL,
    sporting_event_id double precision NOT NULL,
    sport_location_id double precision NOT NULL,
    seat_level numeric(1,0),
    seat_section character varying(15) NOT NULL,
    seat_row character varying(10) NOT NULL,
    seat character varying(10) NOT NULL,
    ticketholder_id double precision,
    ticket_price numeric(8,2) NOT NULL
);

CREATE TABLE dms_sample.ticket_purchase_hist(
    sporting_event_ticket_id double precision NOT NULL,
    purchased_by_id double precision NOT NULL,
    transaction_date_time TIMESTAMP without time zone NOT NULL,
    transferred_from_id double precision,
    purchase_price numeric(8,2) NOT NULL
);

-- ------------ Write CREATE-CONSTRAINT-stage scripts -----------

ALTER TABLE dms_sample.sport_team
ADD CONSTRAINT sport_team_u UNIQUE (sport_type_name, sport_league_short_name, name);

ALTER TABLE dms_sample.name_data
ADD CONSTRAINT name_data_pk PRIMARY KEY (name_type, name);

ALTER TABLE dms_sample.person
ADD CONSTRAINT person_pk PRIMARY KEY (id);

ALTER TABLE dms_sample.player
ADD CONSTRAINT player_pk PRIMARY KEY (id);

ALTER TABLE dms_sample.seat_type
ADD CONSTRAINT st_seat_type_pk PRIMARY KEY (name);

ALTER TABLE dms_sample.sport_division
ADD CONSTRAINT sport_division_pk PRIMARY KEY (sport_type_name, sport_league_short_name, short_name);

ALTER TABLE dms_sample.sport_league
ADD CONSTRAINT sport_league_pk PRIMARY KEY (short_name);

ALTER TABLE dms_sample.sport_location
ADD CONSTRAINT sport_location_pk PRIMARY KEY (id);

ALTER TABLE dms_sample.sport_team
ADD CONSTRAINT sport_team_pk PRIMARY KEY (id);

ALTER TABLE dms_sample.sport_type
ADD CONSTRAINT sport_type_pk PRIMARY KEY (name);

ALTER TABLE dms_sample.sporting_event
ADD CONSTRAINT sporting_event_pk PRIMARY KEY (id);

ALTER TABLE dms_sample.sporting_event_ticket
ADD CONSTRAINT sporting_event_ticket_pk PRIMARY KEY (id);

ALTER TABLE dms_sample.ticket_purchase_hist
ADD CONSTRAINT ticket_purchase_hist_pk PRIMARY KEY (sporting_event_ticket_id, purchased_by_id, transaction_date_time);

-- ------------ Write CREATE-VIEW-stage scripts -----------

CREATE VIEW dms_sample.sporting_event_info (event_id, sport, event_date_time, home_team, away_team, location, city) AS
SELECT e.id AS event_id,
    e.sport_type_name AS sport,
    e.start_date_time AS event_date_time,
    h.name AS home_team,
    a.name AS away_team,
    l.name AS location,
    l.city
   FROM dms_sample.sporting_event e,
    dms_sample.sport_team h,
    dms_sample.sport_team a,
    dms_sample.sport_location l
  WHERE (((e.home_team_id)::double precision = h.id) AND ((e.away_team_id)::double precision = a.id) AND ((e.location_id)::numeric = l.id));

CREATE VIEW dms_sample.sporting_event_ticket_info (ticket_id, event_id, sport, event_date_time, home_team, away_team, location, city, seat_level, seat_section, seat_row, seat, ticket_price, ticketholder) AS
SELECT t.id AS ticket_id,
    e.event_id,
    e.sport,
    e.event_date_time,
    e.home_team,
    e.away_team,
    e.location,
    e.city,
    t.seat_level,
    t.seat_section,
    t.seat_row,
    t.seat,
    t.ticket_price,
    p.full_name AS ticketholder
   FROM dms_sample.sporting_event_info e,
    dms_sample.sporting_event_ticket t,
    dms_sample.person p
  WHERE ((t.sporting_event_id = (e.event_id)::double precision) AND (t.ticketholder_id = p.id));

