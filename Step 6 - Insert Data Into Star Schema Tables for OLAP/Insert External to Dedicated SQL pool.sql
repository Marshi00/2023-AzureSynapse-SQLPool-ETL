INSERT INTO dimDate (date_time, second, minute, hour, day, dayofweek, is_weekend, month, Quarter, Year)
SELECT CAST(date_time AS DATETIME)                         AS date_time,
       second 											   AS second,
       minute 											   AS minute,
       hour 											   AS hour,
       day 											       AS day,
       dayofweek 										   AS dayofweek,
       is_weekend 										   AS is_weekend,
       month        									   AS month,
       Quarter 											   AS Quarter,
       Year                                                AS Year
FROM trip

GO


INSERT INTO dimRiders (rider_key, first_name, last_name, address, birthday, account_start_date, account_end_date, is_member)
SELECT rider_id                  					 AS rider_key,
       first                                         AS first_name,
       last                                          AS last_name,
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

INSERT INTO FactPayment (payment_id, date_id, rider_id, amount)
SELECT p.payment_id                                  AS payment_id,
       d.date_time                                   AS date_id,
       p.rider_id                                    AS rider_id,
       CAST(p.amount AS DECIMAL(10,2))               AS amount
FROM payment p
JOIN dimDate d ON ( CAST(p.date AS DATETIME) = d.date_time )

GO

INSERT INTO FactTrip (trip_key, rideable_type, start_date_id, ended_date_id, start_station_id, end_station_id, rider_id, age, trip_duration)
SELECT t.trip_id                                            AS trip_key,
       t.rideable_type                                      AS rideable_type,
       st.date_time                                         AS start_date_id,
       sp.date_time                                         AS ended_date_id,
       t.start_station_id                                   AS start_station_id,
       t.end_station_id                                     AS end_station_id,
       t.rider_id                                           AS rider_id,
       DATEDIFF_BIG(SECOND, t.start_at, CAST(r.birthday AS DATETIME)) AS age,
       DATEDIFF_BIG(SECOND, t.ended_at, t.start_at)         AS age
FROM trip t
JOIN dimDate start ON ( start.date_time = t.start_at )
JOIN dimDate stop ON ( stop.date_time = t.ended_at )
JOIN dimRiders as r ON (r.rider_key = t.rider_id)
WHERE DATEDIFF(minute, t.start_at, t.ended_at) <> 0

GO;