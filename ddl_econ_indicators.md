# Get Started

Check out our [**Blocks Directory**](https://looker.com/platform/blocks/directory#data) for a full list of data blocks and use cases

[**Start Modeling**](https://discourse.looker.com/t/data-block-data-block-setup-instructions-and-everything-in-between/5949) by reading through this discourse post.


# DDL Statements

Use the following DDL statements as a *reference and starting point* for uploading our datasets into your own DB.

Note: *The following DDL statments follow Amazon Redshift syntax. You may need to adjust data types and other fields as necessary for your dialect.*

[(jump)](#datablocks-finance-redshift) **Working with Redshift? Refer to our steps below.**

### Schema

```
CREATE TABLE FRED_data(
   dataset_code     VARCHAR(25)
  ,date             DATE
  ,value            NUMERIC(18,2)
)

CREATE TABLE FRED_metadata(
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

CREATE TABLE FRED_metadata_codes(
   dataset_code VARCHAR(30)
  ,description  VARCHAR(1000)
)
```

### Copy Data from S3

```
COPY FRED_data
FROM 's3://looker-datablocks/finance/FRED_data/'
CREDENTIALS 'aws_access_key_id=<aws_access_key_id>;aws_secret_access_key=<aws_secret_access_key>'  -- replace with access key and secret key from step 1
REGION 'us-east-1'
IGNOREHEADER as 1
CSV;

COPY FRED_metadata
FROM 's3://looker-datablocks/finance/FRED_metadata/'
CREDENTIALS 'aws_access_key_id=<aws_access_key_id>;aws_secret_access_key=<aws_secret_access_key>'  -- replace with access key and secret key from step 1
REGION 'us-east-1'
IGNOREHEADER as 1
CSV;

COPY FRED_metadata
FROM 's3://looker-datablocks/finance/FRED_metadata_codes/'
CREDENTIALS 'aws_access_key_id=<aws_access_key_id>;aws_secret_access_key=<aws_secret_access_key>'  -- replace with access key and secret key from step 1
REGION 'us-east-1'
IGNOREHEADER as 1
CSV;
```

# datablocks-finance-redshift

Using Redshift? These instructions are for uploading the ACS dataset into your Redshift database. Note: _if you already have an AWS IAM user with the proper policy you may skip step 1._

### Overall Steps:
1. [(jump)](#step-1-add-policy-to-iam-user-and-get-access-key) In your AWS console, apply our policy to your IAM user and grab the IAM access key ID and secret access key (this will be used in the authorization/credentials piece of the [`copy`](http://docs.aws.amazon.com/redshift/latest/dg/copy-parameters-data-source-s3.html) command in step 3)
2. [(jump)](#step-2-create-tables-in-redshift) Create tables in Redshift
3. [(jump)](#step-3-copy-data-to-redshift-from-lookers-s3-bucket) Copy data to Redshift from Looker’s S3 bucket
4. [(jump)](#step-4-add-lookml-files-to-your-looker-project) Add LookML files to your Looker project

__________________________________________________________________________________________

### Step 1: Add Policy to IAM User and Get Access Key

If you don't already have an IAM user with an access key and secret access key, you will need to create one in the AWS console.

![iam](aws_add_user.png)

Once the user is created, you will be provided with an Access Key ID and Secret Access Key. Write these down for later - the secret key will be shown only once. More information on access keys [here](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys).

![iam](aws_get_access_key.png)

Next you will need to add our policy to your IAM user to allow the user to copy data from the Looker S3 bucket.
You can copy the policy directly from here:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1507928463000",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::looker-datablocks",
                "arn:aws:s3:::looker-datablocks/*"
            ]
        }
    ]
}
```

![iam](aws_add_policy.png)
![iam](aws_looker_policy.png)


### Step 2: Create Tables in Redshift

Run the following [`create table`](http://docs.aws.amazon.com/redshift/latest/dg/r_CREATE_TABLE_NEW.html) commands in Redshift. Refer above to the full list of tables that you may need to define.

```
CREATE TABLE FRED_data(
   dataset_code     VARCHAR(25)
  ,date             DATE
  ,value            NUMERIC(18,2)
)
```

### Step 3: Copy Data to Redshift from Looker's S3 Bucket

Run the following [`copy`](http://docs.aws.amazon.com/redshift/latest/dg/copy-parameters-data-source-s3.html) commands in Redshift. Refer above to the full list of copy commands to be added.
**Note:** _you will need to add your aws_access_key_id and aws_secret_access_key from step 1 into each of the statements_

```
COPY FRED_data
FROM 's3://looker-datablocks/finance/FRED_data/'
CREDENTIALS 'aws_access_key_id=<aws_access_key_id>;aws_secret_access_key=<aws_secret_access_key>'  -- replace with access key and secret key from step 1
REGION 'us-east-1'
IGNOREHEADER as 1
CSV;
```

### Step 4: Add LookML Files to your Looker Project

- Copy the LookML files from this repo [(or download here)](https://github.com/llooker/datablocks-finance/archive/master.zip)
- Add the files to your Looker project (prefixed with `rs`)
- Change the `connection` parameter in the model file to your Redshift connection

![looker](lookml_upload.gif)

Now you're ready to explore ACS data and combine with your other datasets!
