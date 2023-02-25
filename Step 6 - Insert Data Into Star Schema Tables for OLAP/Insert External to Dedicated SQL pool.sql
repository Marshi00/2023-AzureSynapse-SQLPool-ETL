INSERT INTO dimDatePayment (date, year, quarter, month, day, week, is_weekend, payment_id)
SELECT CAST(date AS date)                              AS date,
       YEAR(CAST(date AS date))                                     AS year,
       DATEPART(quarter, CAST(date AS date))                        AS quarter,
       MONTH(CAST(date AS date))                                    AS month,
       DAY(CAST(date AS date))                                      AS day,
       DATEPART(week, CAST(date AS date))                           AS week,
       CASE WHEN DATEPART(weekday, CAST(date AS date)) IN (1, 7) THEN 1 ELSE 0 END AS is_weekend,
       payment_id                                     AS payment_id
FROM payment

GO

INSERT INTO dimDateTrip (date, year, quarter, month, day, week, hour, min, is_weekend, trip_id)
SELECT CAST(start_at AS DATETIME)                          AS date,
       DATEPART(year, CAST(start_at AS DATETIME))          AS year,
       DATEPART(quarter, CAST(start_at AS DATETIME))       AS quarter,
       DATEPART(month, CAST(start_at AS DATETIME))         AS month,
       DATEPART(day, CAST(start_at AS DATETIME))           AS day,
       DATEPART(week, CAST(start_at AS DATETIME))          AS week,
       DATEPART(hour, CAST(start_at AS DATETIME))          AS hour,
       DATEPART(minute, CAST(start_at AS DATETIME))        AS min,
       CASE WHEN DATEPART(weekday, CAST(start_at AS DATETIME)) IN (1, 7) THEN 1 ELSE 0 END AS is_weekend,
       trip_id                                             AS trip_id
FROM trip


GO

INSERT INTO dimDateTrip (date, year, quarter, month, day, week, hour, min, is_weekend, trip_id)
SELECT CAST(ended_at AS DATETIME)                            AS date,
       DATEPART(year, CAST(ended_at AS DATETIME))            AS year,
       DATEPART(quarter, CAST(ended_at AS DATETIME))         AS quarter,
       DATEPART(month, CAST(ended_at AS DATETIME))           AS month,
       DATEPART(day, CAST(ended_at AS DATETIME))             AS day,
       DATEPART(week, CAST(ended_at AS DATETIME))            AS week,
       DATEPART(hour, CAST(ended_at AS DATETIME))            AS hour,
       DATEPART(minute, CAST(ended_at AS DATETIME))          AS min,
       CASE WHEN DATEPART(weekday, CAST(ended_at AS DATETIME)) IN (1, 7) THEN 1 ELSE 0 END AS is_weekend,
       trip_id                                              AS trip_id
FROM trip


GO

INSERT INTO dimRiders (rider_key, first_name, last_name, address, birthday, account_start_date, account_end_date, is_member)
SELECT CAST(rider_id AS VARCHAR(50))                  AS rider_key,
       first_name                                    AS first_name,
       last_name                                     AS last_name,
       address                                       AS address,
       CAST(birthday AS DATE)                        AS birthday,
       CAST(account_start_date AS DATETIME)          AS account_start_date,
       CAST(account_end_date AS DATETIME)            AS account_end_date,
       CASE WHEN is_member = 'true' THEN 1 ELSE 0 END    AS is_member
FROM riders

GO

INSERT INTO dimStation (station_key, station_name, latitude, longitude)
SELECT station_id                                     AS station_key,
       name                                           AS station_name,
       latitude                                       AS latitude,
       longitude                                      AS longitude
FROM station

GO

INSERT INTO FactMoney (payment_id, date_id, rider_id, amount)
SELECT p.payment_id                                  AS payment_id,
       d.date_key                                    AS date_id,
       p.rider_id                                    AS rider_id,
       CAST(p.amount AS DECIMAL(10,2))              AS amount
FROM payment p
JOIN dimDatePayment d ON (p.payment_id = d.payment_id)

GO

INSERT INTO FactTime (trip_key, rideable_type, start_date_id, ended_date_id, start_station_id, end_station_id, rider_id)
SELECT t.trip_id                                            AS trip_key,
       t.rideable_type                                      AS rideable_type,
       st.date_key                                       AS start_date_id,
       sp.date_key                                        AS ended_date_id,
       t.start_station_id                                   AS start_station_id,
       t.end_station_id                                     AS end_station_id,
       t.rider_id                                           AS rider_id
FROM trip t
JOIN dimDateTrip st ON (( st.trip_id = t.trip_id ) AND  ( st.date = t.start_at ))
JOIN dimDateTrip sp ON (( sp.trip_id = t.trip_id ) AND  ( sp.date = t.ended_at ))
WHERE DATEDIFF(minute, t.start_at, t.ended_at) <> 0