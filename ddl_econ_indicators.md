# DDL Statements for Redshift

Use the following DDL statements as a reference and starting point for uploading our datasets into your own DB.

Note: *The following DDL statments follow Redshift syntax. You may need to adjust data types and other fields as necessary for your dialect.*

```
CREATE external TABLE datablocks_spectrum.FRED_data(
   dataset_code     VARCHAR(25)
  ,date             DATE
  ,value            NUMERIC(18,2)
)
row format delimited
fields terminated by ','
stored as textfile
location 's3://looker-datablocks/finance/FRED_data/';
```

```
CREATE external TABLE FRED_metadata(
   id                    DATE
  ,dataset_code          VARCHAR(25)
  ,database_code         VARCHAR(4)
  ,name                  VARCHAR(150)
  ,description           VARCHAR(1000)
  ,refreshed_at          VARCHAR(23)
  ,newest_available_date DATE
  ,oldest_available_date DATE
  ,column_names          VARCHAR(17)
  ,frequency             VARCHAR(10)
  ,type                  VARCHAR(11)
  ,premium               VARCHAR(5)
  ,database_id           INTEGER
)
row format delimited
fields terminated by ','
stored as textfile
location 's3://looker-datablocks/finance/FRED_metadata/';
```

```
CREATE external TABLE FRED_metadata_codes(
   dataset_code VARCHAR(30)
  ,description  VARCHAR(1000)
)
row format delimited
fields terminated by ','
stored as textfile
location 's3://looker-datablocks/finance/FRED_metadata_codes/';
```

# DDL statements for Snowflake

Use the following DDL statements as a reference and starting point for uploading our datasets into your own DB.

Note: *The following DDL statments follow Snowflake syntax. You may need to adjust data types and other fields as necessary for your dialect.*

### Create (and use) a schema for finance data ###
create schema finance;
use schema finance;

### FRED_data ###

```
CREATE TABLE finance.FRED_data(
   dataset_code VARCHAR(25) NOT NULL primary key
  ,date         DATE  NOT NULL
  ,value        NUMERIC(18,2) NOT NULL
);

create or replace file format datablocks_csv_format
type = 'CSV'
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
field_delimiter = ','
skip_header = 1;

create or replace stage datablocks_stage
file_format = datablocks_csv_format
url = 's3://looker-datablocks';

copy into finance.FRED_data
  from @datablocks_stage/finance/FRED_data/;
```

### FRED_metadata ###

```
CREATE TABLE FRED_metadata(
   id                    DATE  NOT NULL primary key
  ,dataset_code          VARCHAR(25) NOT NULL
  ,database_code         VARCHAR(4) NOT NULL
  ,name                  VARCHAR(150) NOT NULL
  ,description           VARCHAR(1000) NOT NULL
  ,refreshed_at          VARCHAR(23)
  ,newest_available_date DATE
  ,oldest_available_date DATE
  ,column_names          VARCHAR(17)
  ,frequency             VARCHAR(10)
  ,type                  VARCHAR(11)
  ,premium               VARCHAR(5)
  ,database_id           INTEGER
);

copy into finance.FRED_metadata
    from @datablocks_stage/finance/FRED_metadata/;
```

### FRED_metadata_codes ###

```
CREATE TABLE FRED_metadata_codes(
   dataset_code VARCHAR(30) NOT NULL primary key
  ,description  VARCHAR(1000) NOT NULL
);

copy into finance.FRED_metadata_codes
    from @datablocks_stage/finance/FRED_metadata_codes/;
```
