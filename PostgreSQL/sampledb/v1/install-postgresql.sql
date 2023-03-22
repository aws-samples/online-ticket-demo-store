-- Sample PostgreSQL database for Database Migration Service testing

-- Creating schema and tables
select null as "Setting appropriate search path";
set search_path = dms_sample;
select null as "Creating the tables";
\i ./schema/create-table.sql
select null as "Creating required indexes";
\i ./schema/create-index.sql
select null as "Creating dms_user user:";
\i ./user/create-user.sql

-- Copying base data
select null as "Copying base data into tables";
\copy mlb_data from './data/csv/mlb_data.csv' DELIMITER ',' CSV HEADER;
\copy name_data from './data/csv/name_data.csv' DELIMITER ';' CSV HEADER;
\copy nfl_data from './data/csv/nfl_data.csv' DELIMITER ',' CSV HEADER;
\copy nfl_stadium_data from './data/csv/nfl_stadium_data.csv' DELIMITER ',' CSV HEADER;
\copy seat_type from './data/csv/seat_type.csv' DELIMITER ',' CSV HEADER;
\copy sport_location from './data/csv/sport_location.csv' DELIMITER ',' CSV HEADER;
\copy sport_division from './data/csv/sport_division.csv' DELIMITER ',' CSV HEADER;
\copy sport_league from './data/csv/sport_league.csv' DELIMITER ',' CSV HEADER;

INSERT INTO dms_sample.person (id, full_name, last_name, first_name, provincia)
SELECT row_number() OVER() as rownum
           ,allrows.full_name
           ,allrows.last_name
           ,allrows.first_name
           ,allrows.provincia
FROM (
        SELECT first.name || ' ' || last.name as full_name
                   ,last.name as last_name
                   ,first.name as first_name
                   ,prov.name as provincia
        FROM (
                 SELECT first.name
                 FROM dms_sample.name_data first
                 WHERE  first.name_type not in ('LAST', 'PROVINCIA')
                 ORDER BY random()
                 LIMIT 100
          ) AS first
        CROSS JOIN (
                 SELECT last.name
                 FROM dms_sample.name_data last
                 WHERE last.name_type  = 'LAST'
                 ORDER BY random()
                 LIMIT 100
          ) AS last
        CROSS JOIN (
                 SELECT prov.name
                 FROM dms_sample.name_data prov
                 WHERE prov.name_type  = 'PROVINCIA'
                 ORDER BY random()
                 LIMIT 100
          ) AS prov
    ORDER BY random()
        LIMIT  50000
) AS allrows;

-- loading NFL and MLB teams
select null as "Loading NFL and MLB teams";
\i ./schema/functions/loadmlbteams.sql
\i ./schema/functions/loadnflteams.sql
select loadmlbteams();
select loadnflteams();
\i ./schema/functions/set_mlb_team_home_field.sql
\i ./schema/functions/setnflhomefield.sql
select setnflteamhomefield();

-- generating seats
select null as "Generating game seats";
\i ./schema/functions/esubstr.sql
\i ./schema/functions/generateseats.sql
select generateseats();
select generateseats();
select generateseats();
select generateseats();

-- loading mlb and nfl players
select null as "Creating players";
\i ./schema/functions/loadmlbplayers.sql
\i ./schema/functions/loadnflplayers.sql
select loadmlbplayers();
select loadnflplayers();

-- generating mlb and nfl seasons
select null as "Creating the MLB and NFL seasons";
\i ./schema/functions/generatemlbseason.sql
select generatemlbseason();
\i ./schema/functions/generatenflseason.sql
select generatenflseason();

-- generating tickets for game events
select null as "Generating game tickets for MLB and NFL";
\i ./schema/functions/generatesporttickets.sql
-- generating football and baseball tickets
select generatesporttickets('football');
select generatesporttickets('baseball');

-- Sell tickets and generating ticket activities
select null as "Creating functions to sell and transfer tickets";
\i ./schema/functions/generateticketactivity.sql
-- generating some initial ticket purchases
select generateticketactivity(5000);

-- Generating transfer activity procedures and views
\i ./schema/functions/transferticket.sql
\i ./schema/functions/generatetransferactivity.sql
select generatetransferactivity(1000);

-- modify 70% of ticket dates back to 1 year ago
WITH rows_to_update AS (
  SELECT sporting_event_ticket_id, purchased_by_id, transaction_date_time
  FROM dms_sample.ticket_purchase_hist
  WHERE transaction_date_time >= '2023-01-01 00:00:00'
  ORDER BY random()
  LIMIT (SELECT round(COUNT(*) * 0.7) FROM dms_sample.ticket_purchase_hist)
)
UPDATE dms_sample.ticket_purchase_hist
SET transaction_date_time = dms_sample.ticket_purchase_hist.transaction_date_time - interval '1 year'
FROM rows_to_update
WHERE dms_sample.ticket_purchase_hist.sporting_event_ticket_id = rows_to_update.sporting_event_ticket_id
  AND dms_sample.ticket_purchase_hist.purchased_by_id = rows_to_update.purchased_by_id
  AND dms_sample.ticket_purchase_hist.transaction_date_time = rows_to_update.transaction_date_time;

-- adding Foreign Keys
\i ./schema/foreign-keys.sql

-- creating required views
\i ./schema/create-view.sql
