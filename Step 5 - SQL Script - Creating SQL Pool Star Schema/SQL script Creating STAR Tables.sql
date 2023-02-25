IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dimRiders')
BEGIN
    CREATE TABLE dimRiders(
        rider_key            INT NOT NULL,
        first_name           VARCHAR(50) NOT NULL,
        last_name            VARCHAR(50) NOT NULL,
        address              VARCHAR(100) NOT NULL,
        birthday             DATE NOT NULL,
        account_start_date   DATE NOT NULL,
        account_end_date     DATE,
        is_member            BIT
    );
END

GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dimStation')
BEGIN
    CREATE TABLE  dimStation
    (
        station_key          VARCHAR(50) ,
        station_name         VARCHAR(75) NOT NULL,
        latitude             FLOAT NOT NULL,
        longitude            FLOAT NOT NULL
    );
END

GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dimDatePayment')
BEGIN
    CREATE TABLE  dimDatePayment
    (
        date_key            INT IDENTITY(1,1) NOT NULL,
        date                DATE,
        year                SMALLINT,
        quarter             SMALLINT,
        month               SMALLINT,
        day                 SMALLINT,
        week                SMALLINT,
        is_weekend          BIT,
        payment_id          INT
    );
END

GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dimDateTrip')
BEGIN
    CREATE TABLE  dimDateTrip
    (
        date_key            INT IDENTITY(1,1) NOT NULL,
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
    );
END

GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FactTime')
BEGIN
CREATE TABLE FactTime
    (
        trip_key             VARCHAR(50) NOT NULL,
        rideable_type        VARCHAR(75) NOT NULL,
        start_date_id        INT NOT NULL ,
        ended_date_id        INT NOT NULL ,
        start_station_id     VARCHAR(50) NOT NULL ,
        end_station_id       VARCHAR(50) NOT NULL ,
        rider_id             INT 
    );
END

GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FactTime')
BEGIN
    CREATE TABLE FactMoney
    (
        payment_id           INT NOT NULL,
        date_id              INT NOT NULL,
        rider_id             INT NOT NULL,
        amount               MONEY NOT NULL
    );
END

GO;