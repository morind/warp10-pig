Loading Customer Data into HBase using a PIG script
There are different ways to load data into HBase tables like:
‘put’ to manually load data records into HBase, ImportTSV and bulk load options.

Alternatively, lets try to load huge customer data file into HBase using Apache PIG.
The data set has the following fields:


Custno, firstname, lastname, age, profession
4000001,Kristina,Chung,55,Pilot
4000002,Paige,Chen,74,Teacher
4000003,Sherri,Melton,34,Firefighter
4000004,Gretchen,Hill,66,Computer hardware engineer
4000005,Karen,Puckett,74,Lawyer
4000006,Patrick,Song,42,Veterinarian
4000007,Elsie,Hamilton,43,Pilot
4000008,Hazel,Bender,63,Carpenter
4000009,Malcolm,Wagner,39,Artist
4000010,Dolores,McLaughlin,60,Writer
4000011,Francis,McNamara,47,Therapist
4000012,Sandy,Raynor,26,Writer
4000013,Marion,Moon,41,Carpenter
4000014,Beth,Woodard,65,
4000015,Julia,Desai,49,Musician
4000016,Jerome,Wallace,52,Pharmacist
4000017,Neal,Lawrence,72,Computer support specialist
4000018,Jean,Griffin,45,Childcare worker
4000019,Kristine,Dougherty,63,Financial analyst

## Step 1: Create a HBase table ‘customers’ with column_family ‘customers_data’ from HBase shell.

### Enter into HBase shell
[training@localhost ~]$ hbase shell

### Create a table ‘customers’ with column family ‘customers_data’
hbase(main):001:0> create 'customers', 'customers_data'

### List the tables
hbase(main):002:0> list

### Exit from HBase shell
hbase(main):003:0> exit

## Step 2: Write the following PIG script to load data into the ‘customers’ table in HBase

-- Name your script Load_HBase_Customers.pig
-- Load dataset 'customers' from HDFS location

raw_data = LOAD 'hdfs:/user/training/customers' USING PigStorage(',') AS (
           custno:chararray,
           firstname:chararray,
           lastname:chararray,
           age:int,
           profession:chararray
);

-- To dump the data from PIG Storage to stdout
/* dump raw_data; */

-- Use HBase storage handler to map data from PIG to HBase
--NOTE: In this case, custno (first unique column) will be considered as row key.

STORE raw_data INTO 'hbase://customers' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'customers_data:firstname 
 customers_data:lastname 
 customers_data:age 
 customers_data:profession'
);

## Step 3: Run the PIG Script (Load_HBase_Customers.pig)

[training@localhost ~]$ pig Load_HBase_Customers.pig

## Step 4: Enter HBase shell and verify the data in the ‘customers’ table.

hbase(main):001:0> scan 'customers'
You may add an additional column family, say ‘transactions’ and try adding transactional data into the table.
