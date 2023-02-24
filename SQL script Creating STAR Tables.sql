CREATE TABLE dimRiders(
    rider_key            INT NOT NULL,
    first_name           VARCHAR(50) NOT NULL,
    last_name            VARCHAR(50) NOT NULL,
    address              VARCHAR(100) NOT NULL,
    birthday             DATE NOT NULL,
    account_start_date   DATE NOT NULL,
    account_end_date     DATE,
    is_member            BIT
)

GO

CREATE TABLE  dimStation
(
    station_key          VARCHAR(50) ,
    station_name         VARCHAR(75) NOT NULL,
    latitude             FLOAT NOT NULL,
    longitude            FLOAT NOT NULL
)
GO

CREATE TABLE  dimDatePayment
(
    date                DATE,
    year                SMALLINT,
    quarter             SMALLINT,
    month               SMALLINT,
    day                 SMALLINT,
    week                SMALLINT,
    is_weekend          BIT,
    payment_id          INT
)
GO

CREATE TABLE  dimDateTrip
(
    date                DATETIME,
    year                SMALLINT,
    quarter             SMALLINT,
    month               SMALLINT,
    day                 SMALLINT,
    week                SMALLINT,
    hour                SMALLINT,
    min                 SMALLINT,
    is_weekend          BIT,
    trip_id             VARCHAR(50)
)
GO

CREATE TABLE FactTime
(
    trip_key             VARCHAR(50) NOT NULL,
    rideable_type        VARCHAR(75) NOT NULL,
    start_date_id        INT NOT NULL ,
    ended_date_id        INT NOT NULL ,
    start_station_id     VARCHAR(50) NOT NULL ,
    end_station_id       VARCHAR(50) NOT NULL ,
    rider_id             INT 
)
GO

CREATE TABLE FactMoney
(
    payment_id           INT NOT NULL,
    date_id              INT NOT NULL,
    rider_id             INT NOT NULL,
    amount               MONEY NOT NULL
)
GO;