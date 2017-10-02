# DDL Statements

Use the following DDL statements as a reference and starting point for uploading our datasets into your own DB.

Note: *Our DDL statments follow redshift syntax. You may need to adjust data types and other fields as necessary for your dialect.*


```
CREATE external TABLE datablocks_spectrum.FRED_data(
   dataset_code VARCHAR(16) NOT NULL
  ,date             DATE  NOT NULL
  ,value             NUMERIC(5,2) NOT NULL
)
row format delimited
fields terminated by ','
stored as textfile
location 's3://looker-datablocks/finance/FRED_data/';
```

```
CREATE external TABLE FRED_metadata(
   id                    DATE  NOT NULL
  ,dataset_code          VARCHAR(7) NOT NULL
  ,database_code         VARCHAR(4) NOT NULL
  ,name                  VARCHAR(44) NOT NULL
  ,description           VARCHAR(276) NOT NULL
  ,refreshed_at          VARCHAR(23)
  ,newest_available_date DATE
  ,oldest_available_date DATE
  ,column_names          VARCHAR(17)
  ,frequency             VARCHAR(6)
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
   dataset_code VARCHAR(25) NOT NULL
  ,description  VARCHAR(256) NOT NULL
)
row format delimited
fields terminated by ','
stored as textfile
location 's3://looker-datablocks/finance/FRED_metadata_codes/';
```
